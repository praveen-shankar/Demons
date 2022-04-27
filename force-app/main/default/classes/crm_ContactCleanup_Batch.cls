/*
Created By:Supriya Goel
Date: 14th march  2018
Set record type for contact Inactive , Sales , Customer service
*/

global class crm_ContactCleanup_Batch implements Database.batchable<sObject>
{    
 
global Database.QueryLocator start(Database.BatchableContext BC){
       Set<String> contactType = new Set<String>{'Sales','Sales/Customer Service','Customer Service'};
       
       Id privateRecordtypeid  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Privat').getRecordTypeId();
       
       //select the custom metadatyypes values
       
       List<Contact_CR__mdt> customvalues= [Select id, MasterLabel,DeveloperName,  values__c from Contact_CR__mdt where DeveloperName ='crm_ContactCleanup_Batch' limit 1];
       List<String> valuesList = new List<String>();
       Set <String> valuesSet = new Set<String>();
       
        if ((customvalues.size() > 0) && (customvalues[0].values__c!= null))
           valuesList = customvalues[0].values__c.split(',');
           
           valuesSet.addAll(valuesList);
       
       //select all contacts where account !=private
       String query = 'Select id, recordTypeid,status__c , crm_Contact_Type__c,accountid, account.parentid,  account.recordtypeid, Sync_to_Marketing__c from Contact where crm_Contact_Type__c in :contactType  and account.recordtypeid!= :privateRecordtypeid '; 
       if(valuesSet.size()>0 )
           query += ' and id in :valuesSet ';
           System.debug('## valuesSet ' + valuesSet );
       query += ' order by lastmodifieddate desc';
       System.debug('## query' + query);
       return database.getquerylocator(query);
    }    
    
global void execute(Database.BatchableContext BC, List<Contact> ContactList) {

   //get all sales contact and change relationship
    List<Contact> salesContacts = new List<Contact>();
    List<Contact> salesCSContacts = new List<Contact>();
    List<Contact> newContacts = new List<Contact>();
    List<Contact> newContactsWithoutSharedContacts = new List<Contact>();
    Set<Id> salesCSContactsId = new Set<Id>();
   
    List<AccountContactRelation> relationshiplist=new List<AccountContactRelation>();
        
    //get record  types for contact 
    Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
    Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
    Id inactiveRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Inactive').getRecordTypeId();
    
    Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    Id relationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Relation level Customer').getRecordTypeId();
     
    system.debug('@@@prospectRecordTypeId'+ prospectRecordTypeId);  
    for (Contact c:  ContactList){
        system.debug('@@@cccc'+ c + c.account.recordtypeid);
        
        if(c.account.recordtypeid == prospectRecordTypeId) { //If Contact is directly connected to prospect, mark it as sales
               c.recordtypeid= salesRecordTypeId ;
               c.crm_Contact_Type__c  ='Sales';
               if(c.status__c == 'Aktiv') c.Sync_to_Marketing__c= true;
               newContactsWithoutSharedContacts.add(c); 
          
        }
        
      /*  if(c.crm_Contact_Type__c =='Sales' && c.account.recordtypeid == relationRecordTypeId && c.account.parentid != null) {
            salesContacts.add(c);
                c.Accountid= c.account.parentid;//moving contact to party
                c.recordtypeid= salesRecordTypeId ;
                if(c.status__c == 'Aktiv') c.Sync_to_Marketing__c=true;
                newContacts.add(c);     
            }*/
             
         if(c.account.recordtypeid == relationRecordTypeId && c.account.parentid==null) {
               c.recordtypeid= csRecordTypeId ;
               c.crm_Contact_Type__c  ='Customer Service';
               c.Sync_to_Marketing__c=false;
               newContactsWithoutSharedContacts.add(c); 
          }
        
        //Separate out Sales/Customer Service Contacts that are connected to Relations account with party  
        if((c.crm_Contact_Type__c =='Sales/Customer Service' || c.crm_Contact_Type__c =='Sales')  && c.account.recordtypeid == relationRecordTypeId && c.account.parentid != null) {
            //c.recordtypeid= csRecordTypeId ;
            //c.crm_Contact_Type__c  ='Customer Service';
            //c.Sync_to_Marketing__c=false;
            salesCSContactsId.add(c.id);                 
         }
        
    }
     
     System.debug('##salesCSContactsId'+ salesCSContactsId);
     
     //fetch all  fields from salesCSContacts 
     Map<String, Schema.SObjectField> objfieldMap = Contact.sObjectType.getDescribe().fields.getMap();
     Set<Id> CSIds= new Set<Id>();
    String strfieldName = '';
     
    for(Schema.SObjectField Field : objfieldMap.Values())
    {
         Schema.DescribeFieldResult fieldResult = Field.getDescribe();
         strfieldName += fieldResult.getName() + ',';
    }
     
    strfieldName = strfieldName.substring(0, strfieldName.length()-1);
    // Build a Dynamic Query String to find rcords that need to be separated
    salesCSContacts= Database.query(' select ' + strfieldName + ' ,  account.parentid  from Contact where id in : salesCSContactsId ');
    for (Contact  con: salesCSContacts){
        Contact cloneCon=con.clone(false, true);
       // cloneCon.ownerid  =con.ownerid;
        clonecon.recordtypeid=  salesRecordTypeId ;  //sales
        cloneCon.Master_Reference_Id__c=con.id;
        cloneCon.crm_Contact_Type__c ='Sales';
        if(cloneCon.status__c == 'Aktiv') cloneCon.Sync_to_Marketing__c= true;
        cloneCon.crm_Origination_type__c ='Cloned';
        cloneCon.crm_Was_Split_From_Customer_Service__c = true;
        cloneCon.Caesar_Contact_Id__c='';
        cloneCon.crm_Activities_Count__c =0;
        cloneCon.crm_Campaign_Count__c =0;
        cloneCon.crm_Case_Count__c=0;
        cloneCon.crm_Email_Sent_Count__c=0;
        cloneCon.crm_Opportunity_Count__c=0;
        CSIds.add(con.id);
       // if(con.account.parentid!=null)
        cloneCon.Accountid= con.accountid; //con.account.parentid;
      
             
        con.recordtypeid=  csRecordTypeId ;     //CS 
        con.crm_Contact_Type__c =  'Customer Service';     //CS 
        con.crm_Origination_type__c ='Original';
        con.crm_Was_Split_From_Customer_Service__c = true; 
        con.Sync_to_Marketing__c=false; 
        salesContacts.add(cloneCon);
        newContacts.add(con);
     }
     
    if(newContactsWithoutSharedContacts.size()>0) {
         Database.Upsert(newContactsWithoutSharedContacts, false);
    }
    
    //newContacts have contacts with type Sales and Customer Service. All Contacts relation accounts have party.
    if (newContacts.size()>0){
        Database.UpsertResult[] srList = Database.Upsert(newContacts, false);
        System.debug('##srList update'+ srList   + newContacts);
    }
  
    //Inserting new cloned separated Sales contact
    if (salesContacts.size()>0){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true; 
        Database.SaveResult[] srList = Database.Insert(salesContacts,dml);
        System.debug('##srList insert'+ srList );
        
    }
    
    System.debug('##salesContacts'+ salesContacts);
    Set<Id> salesContactsid= new Set<Id>();
    
      for (Contact c: salesContacts){
          salesContactsid.add(c.id);
      }
      
      list<Contact> salesContactlist= [Select id, accountid, account.parentid from Contact where id in :salesContactsid ];
       System.debug('##salesContactlist'+ salesContactlist);
    
     for (Contact c: salesContactlist){
        //Shared Contact with relation account indirect for customer service
        AccountContactRelation relationship = new AccountContactRelation();
        relationship.Accountid=c.accountid; //relation accountid;
        relationship.Contactid=c.id;
        relationshiplist.add(relationship);
        c.Accountid= c.Account.parentid;//changing the relationship with party              
    }
    
    for (Contact c : newContacts){
         AccountContactRelation relationship = new AccountContactRelation();   
        relationship.Accountid=c.account.parentid; //accountid;
        relationship.Contactid=c.id;
        relationshiplist.add(relationship);                
    }
              
    if (salesContactlist.size()>0){
        Database.UpsertResult[] srList = Database.Upsert(salesContactlist, false);
        System.debug('##Contactlist'+ srList   + salesContactlist);
}
    
    if (relationshiplist.size()>0){
      
       Database.UpsertResult[] srList = Database.Upsert(relationshiplist, false);
       System.debug('##srList update'+ srList   + relationshiplist);
    }
    
    System.debug('##'+ newContacts);
    
    Map<Id,Contact> salesCSContactsMap = new Map<Id, Contact>(); 
    List<Contact> newsalesContacts= [Select id , Master_Reference_Id__c from contact where Master_Reference_Id__c!='' and Master_Reference_Id__c  in :CSIds ];
    
    
    System.debug('## newsalesContacts '+ newsalesContacts);
    for (Contact con : newsalesContacts){
         salesCSContactsMap.put(con.Master_Reference_Id__c, con);  // C1* => sales1, sales
    }
    
    List<Contact> CSContacts = [Select id, Master_Reference_Id__c  from contact where id in :salesCSContactsMap.keyset() ];
    for (Contact con: CSContacts ){
         contact salescon= salesCSContactsMap.get(con.id);
         con.Master_Reference_Id__c  = salescon.id;
    }
    
     if (CSContacts .size()>0){
       Database.UpsertResult[] srList = Database.Upsert(CSContacts , false);
    }
    
  
    }
    
    global void finish(Database.BatchableContext BC) {
    
    //call crm_setRecordtypeforContact_Batch 
                
    }


}