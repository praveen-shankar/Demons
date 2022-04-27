//Contact integration with mybring for failed records
//Author -Supriya Goel

global with sharing class crm_sendfailedcontactstoMybringBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    global integer count = 0;
    public Database.QueryLocator start(Database.BatchableContext BC){
    
        String testid= '0031q000009wJVCAA2';
        String calloutstatus='Callout Finished';
        String query = 'Select id , account.orga__c, Email, firstname ,My_Bring_Userid__c, crm_Callout_Status__c,lastname, name ,crm_Has_agreed_to_Marketing_actvities__c,crm_No_to_Marketing_activities__c,crm_Has_Agreed_To_Email__c,crm_Has_Agreed_to_SMS__c,status__c, mybringstatus__c,et4ae5__Mobile_Country_Code__c,mobilePhone,Phone, crm_function_working_area__c,Preferred_Language__c,createddate,  lastmodifieddate__c from contact where My_Bring_Userid__c!=null and crm_Callout_Status__c !=:calloutstatus';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> scope) {
        List<Id> ids = new List<Id>();
        List<Contact> toupdate = new List<Contact>();
        for(Contact c :scope) {
            ids.add(c.id);
            count++;
        }    
    
         if(ids.size()>0) {      
                System.enqueueJob(new crm_contactIntegrationController(ids)); 
         }
        
    }   
  
    
    //Finish
    public void finish(Database.BatchableContext BC){
        
        System.debug('Count of Jobs'+ count);
    }  
    
}