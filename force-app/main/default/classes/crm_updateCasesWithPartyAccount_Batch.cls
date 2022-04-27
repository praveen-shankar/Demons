/**@author  - Akshata Asukar   
       @description - This batch class will update Cases with Party level account id on crm_Party_Level_Account__c.
       @date - 17 August 2016
**/


global class crm_updateCasesWithPartyAccount_Batch implements Database.Batchable<SObject>{
    
    String query = '';
    
    public crm_updateCasesWithPartyAccount_Batch (Integer year, Integer month){
       
        query = 'SELECT Id,crm_Party_Level_Account__c,Account.Parentid FROM Case WHERE crm_Party_Level_Account__c= null and Accountid!=null AND Account.Parentid!=null AND crm_Month__c = ' + month + ' AND crm_Year__c = ' + year  ;
             
    }
    
       //Start method
    global Database.QueryLocator start(Database.BatchableContext BC){   
        return Database.getQueryLocator(query);
    } 
    
     //Execute Method
    global void execute(Database.BatchableContext BC, list<Case> casestoupdate){
    List<crm_Exception__c> errorlogs=new List<crm_Exception__c>();
    
    try
    {
        for(Case caseObj: casestoupdate)
        {
          caseObj.crm_Party_Level_Account__c=caseObj.account.parentid;
        }
    
        Database.SaveResult[] UpdateResultList=Database.update(casestoupdate,false);

                for(Integer i = 0; i < UpdateResultList.size(); i++)
                 {
                            if(UpdateResultList[i].isSuccess()==false)
                            {
                              for(Database.Error err : UpdateResultList[i].getErrors()) {
                                 crm_Exception__c ex=new crm_Exception__c();   if(err.getMessage().length()>255)    {
                                 err.getMessage().abbreviate(252);
                                 }
                                 ex.crm_Message__c=err.getMessage();  ex.crm_Dml_Field_Names__c=String.valueof(err.getFields());  ex.crm_Stack_Trace__c='Case id'+casestoupdate[i].id;  errorlogs.add(ex);
                                 }

                            }
                }
                
                
                     if(errorlogs.size()>0)
                    insert errorlogs;
                    System.debug('errorlogs@@'+errorlogs);
            }
            catch(Exception e){ crm_Exception_handler.createExceptionRecords(e); }
    
    }
    
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List < string > toAddress = new List < string > ();
        environment_settings__c emailnotifications = environment_settings__c.getValues('BatchEmailNotification');
        List < String > valuesList1 = new List < String > ();
        if (emailnotifications != null && emailnotifications.value__c != null) 
        valuesList1 = emailnotifications.value__c.split(',');
     
       for (String emailuser:valuesList1 )
            toAddress.add(emailuser);  
       //below code will send an email to User about the status
        mail.setToAddresses(toAddress);
        mail.setSenderDisplayName('Batch Processing : Case Update');
        mail.setSubject('Batch Process Id: '+a.Id+' '+a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    }