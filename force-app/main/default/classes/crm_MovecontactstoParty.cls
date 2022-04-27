/*
Created By:Supriya goel
Date: 8th nov
To map contacts from Party level customer to primary relaiton level customer
*/


global class crm_MovecontactstoParty implements Database.batchable<sObject>,Database.Stateful
{
    
    
    public string callback = '';  
    
    global crm_MovecontactstoParty (String callback){
        this.callback = callback;   
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'business_account' And sObjectType = 'Account' Limit 1 ];
        Id relationLevelRecordTypeId  = null;
        If(rtypes.size() > 0) {
            relationLevelRecordTypeId  = rtypes.get(0).Id;
        }
        
        Set<String> contactType = new Set<String>{'Sales'};
            Map<String, Schema.SObjectField> objfieldMap = Contact.sObjectType.getDescribe().fields.getMap();
        String strfieldName = '';
        for(Schema.SObjectField Field : objfieldMap.Values())
        {
            Schema.DescribeFieldResult fieldResult = Field.getDescribe();
            
            if (fieldResult.isAccessible())
                strfieldName += fieldResult.getName() + ',';
        }
        
        strfieldName = strfieldName.substring(0, strfieldName.length()-1);
        
        strfieldName = strfieldName.replace('LastViewedDate,','');
        strfieldName = strfieldName.replace('LastReferencedDate,','');
        
        
        // Build a Dynamic Query String.
        List<Contact_CR__mdt> customvalues= [Select id, MasterLabel,DeveloperName,  values__c from Contact_CR__mdt where DeveloperName ='crm_MovecontactstoParty' limit 1];
        List<String> valuesList = new List<String>();
        Set <String> valuesSet = new Set<String>();
        
        if ((customvalues.size() > 0) && (customvalues[0].values__c!= null))
            valuesList = customvalues[0].values__c.split(',');
        
        valuesSet.addAll(valuesList);
        string query='Select ' + strfieldName + ' , Account.crm_Count_of_Relation_level_Accounts__c, account.parentid from contact where Account.RecordTypeid=:relationLevelRecordTypeId  and AccountId != null  and ispersonaccount=false And crm_Contact_type__c = :contactType';
        if(valuesSet.size()>0 )
            query += ' and id in :valuesSet ';
        System.debug('## valuesSet ' + valuesSet );
        query += ' order by lastmodifieddate desc';
        System.debug('## query' + query);
        return database.getquerylocator(query);   
    } 
    
    global void execute(Database.BatchableContext BC, List<Contact> ContactList) 
    { 
        System.debug('@@@@ContactList'+ContactList); 
        
        Map<id,id> AccConMap=new Map<id,id>();
        Map<id,Contact> ContactMap=new Map<id,Contact>();
        
        Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
        
        List<Contact> ToupdatesalesContacts = new List<Contact>();
        List<Contact> newContacts = new List<Contact>();
        
        List<AccountContactRelation> relationshiplist = new List<AccountContactRelation>();
        Set<id> CSIds  = new Set<Id>();
        
        for(Contact con:ContactList)
        {
            
            
            if(con.Master_Reference_Id__c== null) 
            { //create cs contact 
                
                AccConMap.put(con.id ,con.Accountid);
                ContactMap.put(con.id, con);
                CSIds.add(con.id);
            }
            
            con.accountid=con.account.parentid;
            ToupdatesalesContacts.add(con);
            
        }
        
        System.debug('@@@@AccConMap@@'+AccConMap); 
        System.debug('@@@@ContactMap@@'+ContactMap); 
        
        
        User adminUser =[select  id from user where alias='aadmi' limit 1]; 
        Savepoint sp = Database.setSavepoint();
        for (Contact conObject:  ContactMap.values())
        {    
            Contact cloneCSCon=conObject.clone(false, true);
            if (adminUser!=null )
                cloneCSCon.ownerid  = adminUser.id;
            cloneCSCon.recordtypeid=  csRecordTypeId ;  //sales
            cloneCSCon.Master_Reference_Id__c=conObject.id;
            cloneCSCon.crm_Contact_Type__c ='Customer Service';
            cloneCSCon.crm_Origination_type__c ='New';
            cloneCSCon.crm_Was_Split_From_Customer_Service__c = false;
            cloneCSCon.accountid= AccConMap.get(conObject.id);
            cloneCSCon.Sync_to_Marketing__c=false;
            newContacts.add(cloneCSCon);
        }
        
        if (newContacts.size()>0)
        {
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true;
            Database.SaveResult[] srList = Database.Insert(newContacts,dml);
        }   
        
        for (Contact c : newContacts)
        {
            AccountContactRelation relationship = new AccountContactRelation();   
            relationship.Accountid=c.account.parentid; //indirect with party for CS contact
            relationship.Contactid=c.id;
            relationshiplist.add(relationship);                
        }                   
        if (relationshiplist.size()>0)
        {
            
            Database.UpsertResult[] srList = Database.Upsert(relationshiplist, false);
            System.debug('##srList update'+ srList   + relationshiplist);
        }
        
        Map<Id,Contact> salesCSContactsMap = new Map<Id, Contact>(); 
        List<Contact> newsalesContacts= [Select id , Master_Reference_Id__c from contact where Master_Reference_Id__c!='' and Master_Reference_Id__c  in :CSIds ];
        
        
        System.debug('## newsalesContacts '+ newsalesContacts);
        for (Contact con : newsalesContacts)
        {
            salesCSContactsMap.put(con.Master_Reference_Id__c, con);  // C1* => sales1, sales
        }
        
        List<Contact> CSContacts = [Select id, Master_Reference_Id__c  from contact where id in :salesCSContactsMap.keyset() ];
        for (Contact con: CSContacts )
        {
            contact salescon= salesCSContactsMap.get(con.id);
            con.Master_Reference_Id__c  = salescon.id;
        }
        
        try
        {
            if (CSContacts .size()>0)
            {
                Database.UpsertResult[] srList = Database.Upsert(CSContacts);
            }
            
            if (ToupdatesalesContacts.size()>0)
            {
                Database.UpsertResult[] srList = Database.Upsert(ToupdatesalesContacts);
            }
        }     
        catch (exception exp)
        {
            System.debug('The following exception has occurred: ' + exp.getMessage());
            Database.rollback(sp);
            crm_Exception_handler.createExceptionRecords(exp);

        }
    }    
        
        
        global void finish(Database.BatchableContext BC) 
        {
            
            String str = '';
            crm_AccountRecordTypes__c rTRelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
            String RelationLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTRelation.crm_Record_Type_Label__c).getRecordTypeId();
            AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
            
            if(callback != '' && callback != null)
                str += callback + '\n';
            if(a != null && a.size() > 0)
            {
                str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
            }
            
            
            if(!Test.IsRunningTest())
                Database.executeBatch(new crm_CreatePartyForRelationWithRevenue(str));
        } 
        
        
        
        
    }