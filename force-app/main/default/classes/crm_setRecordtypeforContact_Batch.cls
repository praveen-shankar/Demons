/*
Created By:Supriya Goel
Date: 19th march  2018
Set record type for contact Inactive , Sales , Customer service
*/

global class crm_setRecordtypeforContact_Batch implements Database.batchable<sObject>
{    
 
global Database.QueryLocator start(Database.BatchableContext BC){
       Set<String> contactType = new Set<String>{'Sales','Customer Service'};
        
       Id privateRecordtypeid  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Privat').getRecordTypeId();
       
       
       //select the custom metadatyypes values
       
       List<Contact_CR__mdt> customvalues= [Select id, MasterLabel,DeveloperName,  values__c from Contact_CR__mdt where DeveloperName ='crm_setRecordtypeforContact_Batch' limit 1];
       List<String> valuesList = new List<String>();
       Set <String> valuesSet = new Set<String>();
       
       if ((customvalues.size() > 0) && (customvalues[0].values__c!= null))
           valuesList = customvalues[0].values__c.split(',');
           
           valuesSet.addAll(valuesList);
           
       String query = 'Select id, recordTypeid,status__c , crm_Contact_Type__c, Sync_to_Marketing__c from Contact where crm_Contact_Type__c in :contactType  and account.recordtypeid!= :privateRecordtypeid ';
        if(valuesSet.size()>0 )
           query += ' and id in :valuesSet ';
           System.debug('## valuesSet ' + valuesSet );
       query += ' order by lastmodifieddate desc';
       System.debug('## query' + query);
       return database.getquerylocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<Contact> ContactList) {
    
      //get record  types for contact 
    Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
    Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
    Id inactiveRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Inactive').getRecordTypeId();
    
    if(ContactList.size()>0){
        for (Contact c:ContactList ){
            //c.crm_Origination_type__c ='Existing';
        
            if(String.isBlank(c.status__c)) {
                c.status__c= 'Aktiv';
            }
            if(c.status__c=='Inaktiv') {
                c.RecordtypeId= inactiveRecordTypeId ;
                 c.Sync_to_Marketing__c=false;
            }
                        
            if (c.status__c=='Aktiv'  && c.crm_Contact_Type__c  == 'Customer Service'){
                 c.RecordtypeId= csRecordTypeId ;
                 c.Sync_to_Marketing__c=false;
            }
            if (c.status__c=='Aktiv'  && c.crm_Contact_Type__c  == 'Sales'){
                 c.RecordtypeId= salesRecordTypeId ;
                 c.Sync_to_Marketing__c=true;
            }
                  
        }
    
    Database.upsert(ContactList, false );
  } 
    
    }
    
    global void finish(Database.BatchableContext BC) {
                
    }


}