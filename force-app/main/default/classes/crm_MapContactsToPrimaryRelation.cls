/*
Created By:Akshata Asukar
Date: 22 November 2016 (Sprint 5)
To map contacts from Party level customer to primary relaiton level customer
*/


global class crm_MapContactsToPrimaryRelation implements Database.batchable<sObject>,Database.Stateful
{
  crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
  Id PartyLevelRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
  
    global Database.QueryLocator start(Database.BatchableContext BC){
        Set<String> contactType = new Set<String>{'Sales', 'Sales/Customer Service'};
      Map<String, Schema.SObjectField> objfieldMap = Contact.sObjectType.getDescribe().fields.getMap();
      String strfieldName = '';
      for(Schema.SObjectField Field : objfieldMap.Values())
        {
             Schema.DescribeFieldResult fieldResult = Field.getDescribe();
             strfieldName += fieldResult.getName() + ',';
        }
       
       strfieldName = strfieldName.substring(0, strfieldName.length()-1);
     // Build a Dynamic Query String.
      List<Contact_CR__mdt> customvalues= [Select id, MasterLabel,DeveloperName,  values__c from Contact_CR__mdt where DeveloperName ='crm_MapContactsToPrimaryRelation' limit 1];
       List<String> valuesList = new List<String>();
       Set <String> valuesSet = new Set<String>();
       
        if ((customvalues.size() > 0) && (customvalues[0].values__c!= null))
           valuesList = customvalues[0].values__c.split(',');
           
           valuesSet.addAll(valuesList);
      //string query='Select ' + strfieldName + ' , Account.crm_Count_of_Relation_level_Accounts__c from contact where Account.RecordTypeid=:PartyLevelRecordTypeId ';
       string query='Select ' + strfieldName + ' , Account.crm_Count_of_Relation_level_Accounts__c from contact where Account.RecordTypeid=:PartyLevelRecordTypeId and AccountId != null And Master_Reference_Id__c = null and ispersonaccount=false And crm_Contact_type__c = :contactType  ';
      if(valuesSet.size()>0 )
           query += ' and id in :valuesSet ';
           System.debug('## valuesSet ' + valuesSet );
       query += ' order by lastmodifieddate desc';
       System.debug('## query' + query);
       return database.getquerylocator(query);   
      } 
      
       global void execute(Database.BatchableContext BC, List<Contact> ContactList) { 
       System.debug('@@@@ContactList'+ContactList); 
       List<contact> contacttoupdatelist=new List<Contact>();
       Map<id,id> AccConMap=new Map<id,id>();
       Map<id,Contact> ContactMap=new Map<id,Contact>();
       Map<id,id> PrimaryAccMap=new Map<id,id>();
       List<Account> PrimaryRelationAccountList=new List<Account>();
       
       
       
       Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
       Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
       Set<Id> CSIds= new Set<Id>();
     
       List<Contact> salesContacts = new List<Contact>();
       List<Contact> ToupdatesalesContacts = new List<Contact>();
       List<Contact> UpdatedCSContacts= new List<Contact>();
       
       List<AccountContactRelation> AccountContactRelationListUpdated = new List<AccountContactRelation>();
       
       for(Contact con:ContactList){
            if (con.Account.crm_Count_of_Relation_level_Accounts__c==0) { //mark the contact as sales 
               con.recordtypeid=  salesRecordTypeId;  //sales
               con.crm_Contact_Type__c ='Sales';
               if(con.status__c == 'Aktiv')
                con.Sync_to_Marketing__c= true;
                ToupdatesalesContacts.add(con);
               
           }
       else{
            AccConMap.put(con.id ,con.Accountid);
            ContactMap.put(con.id, con);
           
           }
           
       }
       
       System.debug('@@@@AccConMap@@'+AccConMap); 
       System.debug('@@@@ContactMap@@'+ContactMap); 
           
      
       PrimaryRelationAccountList=[Select id,parentid from Account where crm_Primary_Customer_Account__c=true and Parentid in:AccConMap.values()];
       System.debug('@@@@PrimaryRelationAccountList@@'+PrimaryRelationAccountList); 
       for(Account acc:PrimaryRelationAccountList){
            PrimaryAccMap.put(acc.parentid,acc.id);
       }
         
        //query all indirect relationships for contacts which are on  Party and delete them
         List<AccountContactRelation> relationshiplist =[Select id, accountid, contactid from AccountContactRelation where contactid in :AccConMap.keyset() and IsDirect=false];
         delete relationshiplist ;
         
        for (Id contactid : AccConMap.keyset()){
        Contact con = ContactMap.get(contactid);
        System.debug('@@@@con@@'+con); 
        Id primaryAccount= PrimaryAccMap.get(con.Accountid);
       
          //mark the existing as CS and new as Sales
            system.debug('@@contactid'+ contactid);
            Contact clonecon = con.clone(false, true);
            clonecon.recordtypeid =  salesRecordTypeId ;  //sales
            cloneCon.Master_Reference_Id__c = con.id;
            cloneCon.crm_Contact_Type__c ='Sales';
            if(con.status__c =='Aktiv')
                cloneCon.Sync_to_Marketing__c= true;
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
                
                             
            con.recordtypeid = csRecordTypeId ;     //CS 
            con.crm_Contact_Type__c = 'Customer Service';     //CS 
            con.crm_Origination_type__c ='Original';
            con.crm_Was_Split_From_Customer_Service__c = true; 
            con.Sync_to_Marketing__c = false; 
            con.Accountid = primaryAccount;
            
          
            salesContacts.add(cloneCon);
            UpdatedCSContacts.add(con);
            
             system.debug('@@cloneCon'+ cloneCon);
             
             system.debug('@@con'+ con);
                                             
            }

        
         if(salesContacts.size()>0){
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.AllowSave = true; 
            Database.SaveResult[] srList = Database.Insert(salesContacts,dml);
            
        }
        
        Set<Id> salesContactsid= new Set<Id>();
        
          for (Contact c: salesContacts){
            salesContactsid.add(c.id);
      }
      
      list<Contact> salesContactlist= [Select id, accountid from Contact where id in :salesContactsid ];
       System.debug('##salesContactlist'+ salesContactlist);
    
     for (Contact c: salesContactlist){
       
        AccountContactRelation relationship = new AccountContactRelation();
        Id primaryAccount= PrimaryAccMap.get(c.Accountid);
        relationship.Accountid=primaryAccount; //accountid;
        relationship.Contactid=c.id;
        AccountContactRelationListUpdated.add(relationship);
              
    }
    
    
       
        
        System.debug('@@AccountContactRelationListUpdated'+AccountContactRelationListUpdated);
        
        if(AccountContactRelationListUpdated.size()>0){
            insert AccountContactRelationListUpdated;          
        }
        
        if(UpdatedCSContacts.size()>0){
            Database.UpsertResult[] srList = Database.Upsert(UpdatedCSContacts, false);
        }
        
        system.debug('@@ ToupdatesalesContacts' + ToupdatesalesContacts);
        
        if(ToupdatesalesContacts.size()>0)
             Database.UpsertResult[] srList = Database.Upsert(ToupdatesalesContacts, false);
        
       
                  
        
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
        
         if (CSContacts.size()>0){
           Database.UpsertResult[] srList = Database.Upsert(CSContacts , false);
        }
           
    }
        
        
        
          global void finish(Database.BatchableContext BC) 
         {
         
             }
             
}