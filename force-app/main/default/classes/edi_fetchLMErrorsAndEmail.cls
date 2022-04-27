/*
 * Author - Rajeev Shekhar
 * Scheduled job to fetch EDI errors from LM
*/
public with sharing class edi_fetchLMErrorsAndEmail {
    @future(callout=true)
    public static void process(Id jobId) {        
        environment_settings__c env = environment_settings__c.getValues('EDI_LM_Callout_interval_minutes');
        if ((env != null && env.value__c != null) || Test.isRunningTest()) {
            String responseBody = null;
            Datetime startDateTime = null;
            Set<String> ediIdents = new Set<String>();
            Map<String,List<Edi_Information__c>> ediMap = new Map<String,List<Edi_Information__c>>();
            String tId = String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
            Integer minutes = Integer.valueOf(env.value__c);
            AsyncApexJob[] asyncjob = new List<AsyncApexJob>();
            
            edi_fetchLMErrorsAndEmailWrapper wrapper = new edi_fetchLMErrorsAndEmailWrapper();
            edi_fetchLMErrorsAndEmailWrapper.cls_ediInfo edirequest = new edi_fetchLMErrorsAndEmailWrapper.cls_ediInfo();
            edi_fetchLMErrorsAndEmailWrapper.cls_header ediheader = new edi_fetchLMErrorsAndEmailWrapper.cls_header();
             environment_settings__c envsetting= environment_settings__c.getValues('LM_last_completed_date');
             
            startDateTime = System.now().addMinutes(minutes);
            if(String.IsNotBlank(jobId)  && envsetting != null &&  envsetting.value__c == 'true') {
                asyncjob = [SELECT Id,CompletedDate from AsyncApexJob where ApexClass.Name = 'edi_fetchLMErrorsAndEmail'
                            AND Status = 'Completed' Order By CompletedDate DESC LIMIT 1];
            }            
            if(asyncjob.size() > 0) {             startDateTime = asyncjob.get(0).CompletedDate;     }
            
            //Setting the header
            edirequest.StartDateTime = startDateTime.format('yyyy-MM-dd\'T\'HH:mm:ssZ', 'Europe/Oslo');
            edirequest.BrokerID = null;
            edirequest.CompanyCode = null;
            edirequest.ReturnStatus = null;
            edirequest.ReturnStatusText = null;
            
            //Setting the body
            ediheader.MessageId = tId;
            ediheader.MessageType = 'REST';
            ediheader.MessageMode = 'REST';
            ediheader.Action = 'getRejectedLM_API';
            ediheader.FirstProcessedTimestamp = Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ssZ', 'Europe/Oslo');//Datetime format yyyy-MM-dd'T'HH:mm:ssZ
            ediheader.ProcessedTimestamp = Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ssZ', 'Europe/Oslo');//Datetime format yyyy-MM-dd'T'HH:mm:ssZ;
            ediheader.SourceSystemTimestamp = Datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ssZ', 'Europe/Oslo');//Datetime format yyyy-MM-dd'T'HH:mm:ssZ;
            ediheader.SourceCompany = 'Posten';
            ediheader.SourceSystem = 'Salesforce';
            ediheader.SourceSystemUser = Userinfo.getUserId();
            ediheader.SourceSystemRef = 'Posten-Salesforce';            
            
            wrapper.EDIDetails = edirequest;
            wrapper.header = ediheader;
            
            //Serialization
            String requestBody = JSON.serialize(wrapper);
            
            //Create HttpRequest       
            HttpRequest req = new HttpRequest();
            req.setBody(requestBody);
            req.setEndpoint('callout:crm_edi_LM_getRejected_endpoint');
            req.setHeader('Content-Type', 'application/json;charset=utf-8');
            req.setHeader('MessageId', tId);
            req.setMethod('POST');
            req.setTimeout(Integer.valueOf(System.Label.edi_getRejectedAPI_timeout));
            System.debug('Request: '+requestBody);
            Http http = new Http();
            try {
                HTTPResponse res = http.send(req);
                if(res.getStatus() == 'OK' && res.getStatusCode() == 200) {
                    responseBody = res.getBody();
                    edi_getRejectedLM_API response = edi_getRejectedLM_API.parse(responseBody);
                    System.debug('response JSON: '+responseBody);
                    System.debug('response parsed: '+ response);
                    if(response != null) {
                        EDI_LM_Error__c[] lmerrors = new List<EDI_LM_Error__c>();
                        edi_getRejectedLM_API.cls_RejectedEDI[] redi = response.RejectedEDI;
                        if(redi != null) {
                            for(Integer i=0;i<redi.size();i++) {
                                if(redi[i].EDIIdent != null)
                                    ediIdents.add(redi[i].EDIIdent);
                            }
                            for(Edi_Information__c edi : [SELECT ID,EDI_Identificator__c,E_mail_for_LM_error_notifications__c FROM Edi_Information__c WHERE EDI_Identificator__c IN :ediIdents]) {
                                if(!ediMap.containsKey(edi.EDI_Identificator__c))
                                    ediMap.put(edi.EDI_Identificator__c,new List<Edi_Information__c>{edi});
                                else  ediMap.get(edi.EDI_Identificator__c).add(edi);    
                            }
                            
                            //fetch the errors which should be skipped 
                            
                            List < edi_error_label__mdt> errorMsgList= [Select id, DeveloperName, MasterLabel, Message__c from edi_error_label__mdt];
                            System.debug('@@errorMsgList' + errorMsgList);
                            
                            List<String> errorlist = new List<String>();
                            
                            for (edi_error_label__mdt newobj : errorMsgList) {
                                errorlist.add(newobj.Message__c.tolowercase());
                            
                            }
                            
                          
                            for(Integer i=0;i<redi.size();i++) {
                                if(ediMap.containsKey(redi[i].EDIIdent)) {
                                    for(Edi_Information__c e : ediMap.get(redi[i].EDIIdent)) {
                                        if(String.IsNotBlank(e.E_mail_for_LM_error_notifications__c)) {
                                          if(errorlist.size()>0 ){
                                            // for (edi_error_label__mdt newobj : errorMsgList) { 
                                             
                                                   //if ( !redi[i].FailureMessage.contains(newobj.MasterLabel)) {
                                                    
                                                     if ( !errorlist.contains(redi[i].FailureMessage.tolowercase())) {  
                                          
                                            EDI_LM_Error__c lmerror = new EDI_LM_Error__c();           lmerror.Name = redi[i].EDIIdent; lmerror.Status__c = response.Status;   lmerror.SQL_Code__c = response.SQLCode;
                                            lmerror.Return_Status_Text__c = response.ReturnStatusText; lmerror.Parcel_Number__c = redi[i].ParcelNumber; lmerror.Run_Number__c = redi[i].RunNumber;
                                            lmerror.Failure_Message__c = redi[i].FailureMessage;  lmerror.Email__c = e.E_mail_for_LM_error_notifications__c;lmerror.EDI_Identificator__c = redi[i].EDIIdent;  lmerror.EDI__c = e.Id;
                                            if(redi[i].Timestamp != null) {     String[] tbf = redi[i].Timestamp.split('T')[0].split('-');     String[] taf = redi[i].Timestamp.split('T')[1].split(':');
                                                Datetime timestamp = DateTime.newInstanceGMT(Integer.valueof(tbf[0]),Integer.valueof(tbf[1]),Integer.valueof(tbf[2]),Integer.valueof(taf[0]),Integer.valueof(taf[1]),0);  lmerror.Timestamp__c = timestamp.addHours(-1);                     
                                            }                                          
                                            
                                            lmerrors.add(lmerror);
                                            
                                            }//end of if
                                            
                                         // }//end of if  
                                          //}//end of for
                                         }//end of size check   
                                        } //end of null check for notifications
                                    }
                                }         
                            }
                            if(lmerrors.size() > 0) {                                try{                        insert lmerrors;
                            OrgWideEmailAddress owa  =[select id, Address from OrgWideEmailAddress where address ='integrasjon.norge@bring.com' limit 1];
                             Messaging.SingleEmailMessage[] emails = new Messaging.SingleEmailMessage[]{};                           Messaging.SendEmailResult[] emailresult = new Messaging.SendEmailResult[]{};
                                Id templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'EDI_LM_Errors_Norge' Limit 1].Id;                                                                          
                                for(EDI_LM_Error__c err : lmerrors) {
                                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  List<String> emailIds = new List<String>();
                                    if(String.IsNotBlank(err.Email__c)) { emailIds = err.Email__c.split(',');           email = Messaging.renderStoredEmailTemplate(templateId,null,err.Id);
                                        email.setToAddresses(emailIds); 
                                       // mail.setSenderDisplayName('System Admin');
                                        email.setOrgWideEmailAddressId(owa.id);
                                        
                                         email.setSubject(email.getSubject());  email.sethtmlBody(email.gethtmlBody()); email.saveAsActivity = false; emails.add(email); 
                                    }                                    
                                }
                                if(emails.size() > 0) {  emailresult = Messaging.sendEmail(emails);
                                    System.debug('Email Results are:' + emailresult);
                                }    
                                }Catch(Exception e) { System.debug('Exception occured in edi_fetchLMErrorsAndEmail class: ' + e);
                                } 
                            }    
                        }
                    }                   
                } else {                crm_Exception_handler.createNonExceptionRecords('Callout failed: ' + res.getStatus(),res.getStatusCode(),null,tId,'edi_fetchLMErrorsAndEmail');
                }    
            }Catch(exception e) {
                System.debug('Exception occured in edi_fetchLMErrorsAndEmail class: ' + e);
                crm_Exception_handler.createExceptionRecords(e);
            } finally {
               /* Integer nextFireTimeMinutes = Integer.valueOf(env.value__c.removeStart('-'));
                Datetime currentTime = System.now();
                Datetime sysTime;
                String cronExpression;
                Integer dayOfWeek = Integer.valueOf(currentTime.format('u'));
                if(jobId != null) System.AbortJob(jobId);
                if(!Test.isRunningTest()) {
                    sysTime = currentTime.addMinutes(nextFireTimeMinutes); cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();       System.Schedule('EDI_getRejectedFromLM_RegularJob', cronExpression, new edi_fetchLMErrorsSchedulable());                                  
                }*/
            }
        }
    }
}