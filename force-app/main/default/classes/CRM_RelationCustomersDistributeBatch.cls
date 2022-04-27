/**********************************************************************
 Name: CRM_RelationCustomersDistributeBatch 
======================================================
Req:

======================================================
Purpose:
This Batch class is to distribute the relation level 
customers to other system after party level customer 
conversion
======================================================
History
-------
VERSION  AUTHOR            DATE              DETAIL
   1.0 -  Vasudha Tandon    07/05/2020     Initial Development
***********************************************************************/
global class CRM_RelationCustomersDistributeBatch implements Database.Batchable<sObject>{
 
    global List<Id> listParentIds;
    /*******************************************************************
        Purpose: To return the records of Customers (Account)
        Parameters: Database.BatchableContext
        Returns: List of Customers object records
    ********************************************************************/
    global Database.QueryLocator start(Database.BatchableContext BC){
        try {
            System.debug('Entering start: ');

           
            Datetime currenttime = datetime.now();
            Datetime backtime = currenttime.addMinutes(-45);
            String formattedDatetime = backtime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.000+0000');
            String currentFormatTime = currenttime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.000+0000');
            
            String queryRelationCustomersData;
            String subQuery;
            
            subQuery = '(SELECT Id, Name, crm_Account__c, crm_Origin_System__c, crm_Origin_System_Reference__c, ';
            subQuery = subQuery + 'crm_Status__c, Customer_Numberf__c, createddate FROM Related_Account__r ';
            subQuery = subQuery + 'WHERE crm_Status__c = \'A\') ';
            
            queryRelationCustomersData= 'SELECT ';
            queryRelationCustomersData= queryRelationCustomersData + 'Id, parentId, Name, ';
            queryRelationCustomersData= queryRelationCustomersData + 'RecordType.name, CreatedDate, ';
            queryRelationCustomersData= queryRelationCustomersData + 'orga__c, isMail_Send_To_Amphora_Customer__c,Parent.Customer_Converted__c, ';
            queryRelationCustomersData= queryRelationCustomersData + 'Parent.crm_Updated_by_CDH__c, Parent.crm_customer_converted_date__c, ';
            queryRelationCustomersData= queryRelationCustomersData + subQuery;
            queryRelationCustomersData= queryRelationCustomersData + 'FROM ';
            queryRelationCustomersData= queryRelationCustomersData + 'Account ';
            queryRelationCustomersData= queryRelationCustomersData + 'where RecordType.name =\'Relation level Customer\' ';
            queryRelationCustomersData= queryRelationCustomersData + 'and crm_Updated_by_CDH__c = true ' ;
            
             //For UAT 
             //queryRelationCustomersData= queryRelationCustomersData + 'and CreatedDate = TODAY' ;
            // For Production
            queryRelationCustomersData= queryRelationCustomersData + 'and CreatedDate < '+currentFormatTime;
            queryRelationCustomersData= queryRelationCustomersData + ' and CreatedDate >= ' +formattedDatetime ;
            //queryRelationCustomersData= queryRelationCustomersData + 'and Id =\'0011q00000i22epAAA\' ';
                    
            System.debug('queryRelationCustomersData== ' + queryRelationCustomersData);
            
            Database.QueryLocator queryLocatorRelationCustomersData;
            queryLocatorRelationCustomersData = Database.getQueryLocator(queryRelationCustomersData);
            
            System.debug('queryLocatorRelationCustomersData == ' + queryLocatorRelationCustomersData );    
            System.debug('Exiting start: ');
            return queryLocatorRelationCustomersData;
        }
        catch (Exception e) {
            System.debug('Exception -----'+e);
            return null;
        }
    }


    /*******************************************************************
        Purpose: To find the records of Party level customer that 
            associated with relation level customers where created date 
            is today's date
        Parameters: Database.BatchableContext, listRelationCustomersRecords
        Returns: NA
    ********************************************************************/
    global void execute(Database.BatchableContext BC, List<Account> listRelationCustomersRecords){
        try {
            System.debug('Entering execute: ' + listRelationCustomersRecords);
            Map<Id, Date> mapRelationCreatedDate = new Map<Id, Date>();
            List<Account> listUpdatedAmphoraRelationCustomer = new List<Account>();
            listParentIds = new List<Id>();
            
            if(!listRelationCustomersRecords.isEmpty()){
                for(Account accRelation : listRelationCustomersRecords){
                    
                    mapRelationCreatedDate.put(accRelation.parentId, accRelation.CreatedDate.date());
                
                }
            }
            
            if(!mapRelationCreatedDate.keySet().isEmpty()){
                List<Account> listParentCustomerRecords = [Select id , name ,RecordType.name , crm_customer_converted_date__c 
                                                                from Account 
                                                                where Id IN : mapRelationCreatedDate.keyset() AND Customer_Converted__c = 'Converted' and crm_Updated_by_CDH__c  = true];
             System.debug('listParentCustomerRecords : '+listParentCustomerRecords );
                if(!listParentCustomerRecords.isEmpty()){
                    for(Account accParent :listParentCustomerRecords){
                        
                         if(mapRelationCreatedDate.containskey(accParent.Id)){
                              System.debug('mapRelationCreatedDate.containskey(accParent.Id) : '+mapRelationCreatedDate.containskey(accParent.Id));
                             listParentIds.add(accParent.Id);
                         }
                    }
                    
                }
                if(!listParentIds.isEmpty()){
                System.enqueueJob(new crm_convertCustomerIntegrationController(listParentIds));
                }
                
            }
            
              List<Messaging.SingleEmailMessage> allMsg = New List<Messaging.SingleEmailMessage>();
                environment_settings__c recipientlist = environment_settings__c.getValues('ToRecipientList');
            environment_settings__c recipientCClist = environment_settings__c.getValues('ToRecipientListCC');
                List < String > toAddress = new List < String > ();
                List < String > toAddressCC = new List < String > ();
                  
                if (recipientlist != null && recipientlist.value__c != null) {
                   toAddress = recipientlist.value__c.split(';');
                }
      
                if (recipientCClist != null && recipientCClist.value__c != null) {
                  toAddressCC = recipientCClist.value__c.split(';');
                }
                
                if(!listRelationCustomersRecords.isEmpty()){
                    for(Account a : listRelationCustomersRecords){
                    //Processed Customer
                        if((!a.Related_Account__r.isEmpty()) && (!a.isMail_Send_To_Amphora_Customer__c) && (a.Parent.Customer_Converted__c == 'Converted') && (a.Parent.crm_customer_converted_date__c < a.CreatedDate) && (a.Parent.crm_Updated_by_CDH__c)){
                            for(crm_Account_Cross_Reference__c c : a.Related_Account__r){
                                if(c.crm_Origin_System__c == 'AMPHORA_SPN' || c.crm_Origin_System__c == 'AMPHORA_BCI'){
                                    String formatted_Date = DateTime.newInstance(c.createdDate.year(), c.createdDate.month(), c.createdDate.day()).format('d-MM-YYYY');
                                    Messaging.singleEmailMessage mail = New Messaging.singleEmailMessage();
                                    mail.setToAddresses(toAddress);
                                    mail.setCCAddresses(toAddressCC);
                                    mail.setSaveAsActivity(false);
                                    mail.setUseSignature(false);
                                    string subj ='Mark as converted - ' +c.Customer_Numberf__c+ ' is added to <' + a.orga__c + '> < '+ a.Name + '> on ' + formatted_Date ;
                                    mail.setSubject(subj);
                                    string body = 'Account details ';
                                    body = body + '<br/> <br/> Org. no- ' + a.orga__c;
                                    body = body + '<br/> <br/> Org. name- ' + a.Name;
                                    body = body + '<br/> <br/> Customer Master number- ' + c.Customer_Numberf__c;
                                    if(c.crm_Origin_System__c == 'AMPHORA_BCI'){
                                        body = body + '<br/> <br/> Amphora BCI customer number- ' + c.crm_Origin_System_Reference__c;
                                    }
                                    else if(c.crm_Origin_System__c == 'AMPHORA_SPN'){
                                        body = body + '<br/> <br/> Amphora SPN customer number- ' + c.crm_Origin_System_Reference__c;
                                    }
                                    //body = body + '<br/> <br/> Amphora SPN customer number- ' + c.crm_Origin_System_Reference__c;
                                    body = body + '<br/> <br/> Date and time when this customer was received in Salesforce from CDH- ' + formatted_Date ;
                                    body = body + '<br/> <br/> Thanks, <br/> Salesforce Support';
                                    
                                    System.debug('###body ' + body );
                                    mail.setHtmlBody(body);
                                    
                                    allMsg.add(mail); 
                                    a.isMail_Send_To_Amphora_Customer__c = true;
                                    listUpdatedAmphoraRelationCustomer.add(a);
                                
                            }
                        } // end of second for
                      }
                      //Processed Customers
                      
                        
                } //end of first for 
                }
                
                system.debug('###'+allMsg);
                Messaging.sendEmail(allMsg,false); 
                
                if(!listUpdatedAmphoraRelationCustomer.isEmpty()){
                    Database.update(listUpdatedAmphoraRelationCustomer);
                
                }
            System.debug('listUpdatedAmphoraRelationCustomer: '+listUpdatedAmphoraRelationCustomer);
            System.debug('Exiting execute: '+listParentIds);
        }
        catch (Exception e) {
            System.debug('Exception -----'+ e);
            //crm_Exception_handler.createExceptionRecordsAnyType(e, null);
        }
    }


    /*******************************************************************
        Purpose: To start the execution of crm_convertCustomerIntegrationController batch
        Parameters: Database.BatchableContext
        Returns: NA
    ********************************************************************/
    global void finish(Database.BatchableContext BC){
       
        System.debug('Entering finish:');
           
        try
        {
            Datetime nextRunTime = datetime.now().addMinutes(15);
            String day = string.valueOf(nextRunTime.day());
            String month = string.valueOf(nextRunTime.month());
            String hour = string.valueOf(nextRunTime.hour());
            String minute = string.valueOf(nextRunTime.minute());
            //String minute = '61';
            String second = '00';
            String year = string.valueOf(nextRunTime.year());
            
            String strJobName = 'CRM_RelationCustomersDistributeSchedular-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
            System.debug('jobname' +strJobName );
            String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
            System.debug('schedule' + strSchedule);
            
            //Integer min = currenttime.minute();
            
            System.schedule(strJobName ,  strSchedule , new CRM_RelationCustomersDistributeSchedular());
        }
        Catch(Exception ex)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'posten.salesforce@tcs.com'};              
                mail.setToAddresses(toAddresses);
               mail.setReplyTo('posten.salesforce@tcs.com');
            mail.setSenderDisplayName('Posten');
            mail.setSubject('Customer Distribution Batch');
            mail.setPlainTextBody('Unable to schedule next batch run ' + ex.getMessage());
            
            // Send the email for the developer reference
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
                   
        System.debug('Exiting finish: ');
       
    }
}