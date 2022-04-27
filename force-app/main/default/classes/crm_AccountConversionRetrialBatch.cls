//C-100214 - Batch in salesforce
//Author - Supriya Goel 

public with sharing class crm_AccountConversionRetrialBatch implements Database.Batchable<sObject>{

public String accountId= '';
 
  public crm_AccountConversionRetrialBatch (String accountId){
        this.accountId= accountId;   
       
    }
   
    public Database.QueryLocator start(Database.BatchableContext BC){
     String query = 'SELECT Id,Customer_Converted__c From Account Where id =:accountId and Customer_Converted__c= \'Converted\'';
       
           
           
      
       return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Id> ids = new List<Id>();
        List<Account> toupdate = new List<Account>();
        for(Account a  :scope) {
            ids.add(a.id);
        }    
    
        if(ids.size() > 0) System.enqueueJob(new crm_convertCustomerIntegrationController(ids));
        
    }
    
   
    
    //Finish
    public void finish(Database.BatchableContext BC){
        
    }   
    
}