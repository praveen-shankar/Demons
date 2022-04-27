/*
Created By:Supriya Goel
Date:16th oct   2018
Set the account lookup from the account text field and then mark the record as account set
*/

global class crm_setaccountonagreement_Batch implements Database.batchable<sObject>
{    
 
global Database.QueryLocator start(Database.BatchableContext BC){

 String query = 'Select id, Account__c,AccountNumberText__c, Account_updated__c from cs_agreement_details__c where  AccountNumberText__c !=null and Account__c = null order by createddate desc';
 return database.getquerylocator(query); 

 }
 
 global void execute(Database.BatchableContext BC, List<cs_agreement_details__c> agrList) {
     Set<String> customernumberSet= new Set<String>();
     for (cs_agreement_details__c agr : agrList){
          customernumberSet.add(agr.AccountNumberText__c);
                
     }
     
     Map<String, Id> customerNumberMap =  new Map<String, Id>();
     
     List<Account> acntlist= [Select id, crm_customer_number__c  from Account where  crm_customer_number__c  in  :customernumberSet];
     for (Account a:acntlist)
         customerNumberMap .put(a.crm_customer_number__c  ,a.id);
         
     for (cs_agreement_details__c agr : agrList){    
     if(customerNumberMap.containskey(agr.AccountNumberText__c)) 
         agr.Account__c = customerNumberMap.get(agr.AccountNumberText__c);    
     }
     
     System.debug('##'+agrList);
     
     
    try
       {   
     
     List<crm_Exception__c> errorlogs=new List<crm_Exception__c>();
     if (agrList.size()>0){
        Database.SaveResult[] UpdateResultList = Database.update(agrList, false);
        for(Integer i = 0; i < UpdateResultList.size(); i++)
           {
                if(UpdateResultList[i].isSuccess()==false)
                {
                     String FailedaccNumber;   
                     for(Database.Error err : UpdateResultList[i].getErrors()) { crm_Exception__c ex=new crm_Exception__c();
                     if(err.getMessage().length()>255)   {  err.getMessage().abbreviate(252);FailedaccNumber=agrList[i].AccountNumberText__c; }
                     ex.crm_Message__c=err.getMessage();  ex.crm_Dml_Field_Names__c = String.valueof(err.getFields()); ex.crm_Stack_Trace__c = 'crm_setaccountonagreement_Batch :  Failedaccountnumber :' +FailedaccNumber; errorlogs.add(ex);
                     }
        
                }
                
               
                
            }
  
 }
 
   if(errorlogs.size()>0)   insert errorlogs;
  }
            catch(Exception e){ crm_Exception_handler.createExceptionRecords(e); }
}

global void finish(Database.BatchableContext BC) {
    
   
                
    }


}