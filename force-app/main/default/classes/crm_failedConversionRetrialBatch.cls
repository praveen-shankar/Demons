//Agreement Phase 2 Project
//Author - Rajeev Shekhar

public with sharing class crm_failedConversionRetrialBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Schedulable{
   
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,crm_Type__c,crm_Dml_Id__c,crm_Stack_Trace__c,crm_Verified_Completed__c From crm_Exception__c Where crm_Type__c = \'System.CalloutException\'';
        query += ' And crm_Dml_Id__c != null And crm_Stack_Trace__c LIKE \'%Class.crm_convertCustomerIntegrationController%\'';
       return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<crm_Exception__c> scope) {
        List<Id> ids = new List<Id>();
        List<crm_Exception__c> toupdate = new List<crm_Exception__c>();
        for(crm_Exception__c e :scope) {
            ids.add(e.crm_Dml_Id__c);
        }    
    
        if(ids.size() > 0) System.enqueueJob(new crm_convertCustomerIntegrationController(ids));
        delete scope;
    }
    
    public void execute(SchedulableContext sc){
        Database.executeBatch(new crm_failedConversionRetrialBatch());
    }
    
    //Finish
    public void finish(Database.BatchableContext BC){
        
    }   
    
}