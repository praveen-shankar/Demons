/*
Created By:Supriya Goel
Date: 7th june 2019

*/

global class crm_sentToConga_Batch implements Database.batchable<sObject>
{    
     public Set<string> reqId= new Set<String>();
      global Integer Failurecount=0;     
      
    //added
    global crm_sentToConga_Batch (){}
     
   global Database.QueryLocator start(Database.BatchableContext BC){
   String  conversionHeat='Heat B - September 2019';
   String customerstate ='Standard agreement';

   String query  ='Select id, Is_Conversion_Email_Sent__c, Template_Sent_Via_Conga__c  , orga__c from Account where Template_Sent_Via_Conga__c = false and crm_Conv_Converison_Heat__c =:conversionHeat and crm_conv_Customer_state__c =:customerstate';
   return database.getquerylocator(query);
    }  
    
     global void execute(Database.BatchableContext BC, List<Account> accountList) {
     for(Account a:accountList)
         a.Template_Sent_Via_Conga__c  = true;
      
         //update accounta nd handle exceptions
        String FailedOrgNumber;

         List<crm_Exception__c> errorlogs=new List<crm_Exception__c>();
      
        Database.SaveResult[] UpdateResultList=Database.update(accountList,false);

                for(Integer i = 0; i < UpdateResultList.size(); i++)
                 {
                            if(UpdateResultList[i].isSuccess()==false)
                            {
                                 Failurecount++;   FailedOrgNumber= accountList[i].orga__c;
                                 
                                 for(Database.Error err : UpdateResultList[i].getErrors()) {   crm_Exception__c ex=new crm_Exception__c();
                                 if(err.getMessage().length()>255)        {    err.getMessage().abbreviate(252);             }
                                 ex.crm_Message__c=err.getMessage();String.valueof(err.getFields());
                                 ex.crm_Stack_Trace__c='crm_sentToConga_Batch failed for this customer with OrgNumber:'+FailedOrgNumber+' and Account Id'+accountList[i].id;    errorlogs.add(ex);
                                 }

                            }
                }   
         
     
     } 
     
      global void finish(Database.BatchableContext BC) {}
      
      }