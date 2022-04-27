/************************************************************

Name: CreateContactcontroller
Type: Apex Class  
Purpose: Apex Class  for  lightning component 
CreateContactcmp
***********************************************************/
public class CreateContactController {
    
    /**
* Create a new contact Record
*
* @param contact to be inserted
* 
*/
    
    public string relationaccountid{get;set;}
    public List<Contact> contactlist=new List<Contact>();
    public User logggedInUser{get;set;}
    
    @AuraEnabled
    public static Map<id,String> getAccountOptions(String accountId){
        List<Account> relationaccounts= [Select id, name, crm_customer_number__c, crm_Primary_Customer_Account__c from Account where parentid  =:accountId order by crm_Primary_Customer_Account__c desc];
        Map<id,String> accountMap= new Map<Id, String>();
        for (Account a:relationaccounts )
        {
            accountMap.put(a.id,a.name +','+a.crm_customer_number__c)  ;
            
        }
        return accountMap;
        
    }
    
    @AuraEnabled
    public static Map<String, String> getfunctionalarea()
    {
        Map<String, String> options = new Map<String, String>();
        
       Schema.DescribeFieldResult fieldResult =  Contact.crm_function_working_area__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        
        return options;
    }
    
    @AuraEnabled
    public static Map<String, String> getstatus()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  Contact.status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        
        return options;
    }
    
    @AuraEnabled
    public static Map<String, String> getfunctionaldecisionlevel()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  Contact.crm_functional_decision_level__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        
        return options;
    }    
    
    @AuraEnabled
    public static List<Contact> createRecord (Contact conObject){
       
        System.debug('~~~conObject::'+conObject.AccountId);  
        System.debug('~~~conObject::'+conObject); 
       
      
        List<AccountContactRelation>   relationshiplist = new List<AccountContactRelation>();
        List<Contact> contactlist= new List<Contact>();
        List<Contact> duplicatecontact;
        Boolean hasDuplicateContact;
        Integer Count;
        Integer duplicatecount;
        String message;
       
        RecordType[] cstypes = [SELECT Id FROM RecordType Where DeveloperName = 'Customer_Service' And sObjectType = 'Contact' Limit 1];
        Id csRecordTypeId = null;
        If(cstypes.size() > 0) {
            csRecordTypeId  = cstypes.get(0).Id;
        }
        
        RecordType[] salestypes = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Sales' And sObjectType = 'Contact' Limit 1];
        Id salesRecordTypeId = null;
        If(salestypes.size() > 0) {
            salesRecordTypeId  = salestypes.get(0).Id;
        }
       
        
        //Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
      
        // Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
        Account relationaccount= [Select id, parentid from Account where id=:conobject.accountId]; 
        
        try
        {
            conObject.Accountid= relationaccount.parentid;
            conObject.crm_Contact_Type__c ='Sales';
            conObject.Recordtypeid=salesRecordTypeId;
            conObject.Sync_to_Marketing__c= true;
            contactlist.add(conObject);
            hasDuplicateContact = false;
            Count = 0;
            
            if(contactlist.size() > 0)  {
                
                duplicatecontact= new List<Contact>();
                System.debug('contactlist $$$'+contactlist);            
                Database.SaveResult[] srList = Database.Insert(contactlist, false);
                System.debug('srList $$$'+srList);
                for (Database.SaveResult sr : srList) 
                {
                    if (!sr.isSuccess()) 
                    {
                        for (Database.Error error : sr.getErrors()) 
                        {
                            if (error instanceof Database.DuplicateError) 
                            {
                                Database.DuplicateError duplicateError =  (Database.DuplicateError)error;
                                Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                                duplicatecount=0;
                                for(Datacloud.MatchResult matchResult : duplicateResult.getMatchResults())
                                {    
                                    
                                    
                                    for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) 
                                    {
                                        duplicatecount++;
                                        DuplicateContact.add((Contact)matchRecord.getRecord());
                                    }
                                }
                                message=String.valueof(duplicatecount)+' Possible Duplicate Record found. '+duplicateResult.getErrorMessage();
                                System.debug('DuplicateContact: ' + DuplicateContact);
                                hasDuplicateContact= !DuplicateContact.isEmpty();
                            }
                        }
                    }
                }
            } 
            if(conObject.id!=null)
            {
                AccountContactRelation relationship=new AccountContactRelation();
                relationship.AccountId= relationaccount.id;//accountId;//'001w000001Z2aUwAAJ'; //accountId;
                relationship.Contactid=conObject.id;
                relationshiplist.add(relationship);
                
                User adminUser =[select  id from user where alias='aadmi' limit 1];       
                   
                Contact cloneCSCon=conObject.clone(false, true);
                if (adminUser!=null )
                    cloneCSCon.ownerid  = adminUser.id;
                cloneCSCon.recordtypeid=  csRecordTypeId ;  //sales
                cloneCSCon.Master_Reference_Id__c=conObject.id;
                cloneCSCon.crm_Contact_Type__c ='Customer Service';
                cloneCSCon.crm_Origination_type__c ='New';
                cloneCSCon.crm_Was_Split_From_Customer_Service__c = false;
                cloneCSCon.accountid= relationaccount.id;
                cloneCSCon.Sync_to_Marketing__c=false;
                insert cloneCSCon;
                
                System.debug('cloneCSCon' + cloneCSCon);
                
                Contact newContact= [Select id, Master_Reference_Id__c from contact where Master_Reference_Id__c= :conObject.id ];
                conObject.Master_Reference_Id__c= newContact.id;
                update conObject;
                
                 System.debug('conObject' + conObject);

                AccountContactRelation relationship1=new AccountContactRelation();
                relationship1.Accountid = relationaccount.parentid; //accountid;
                relationship1.Contactid = newContact.id;
                relationshiplist.add(relationship1);
                System.debug('relationshiplist' + relationshiplist);
            
           if(relationshiplist.size()>0)
           {
               insert relationshiplist;
           }
       }
            
            
           
        }  
        catch(Exception ex)
        {
            
            
        }
        System.debug('DuplicateContact: ' + DuplicateContact);
        return DuplicateContact;
        //  upsert conObject;
        
    }    
    
    
    @AuraEnabled
    public static List<Contact> createDuplicateRecord (Contact conObject, Id accountId){ 
        AccountContactRelation relationship=new AccountContactRelation();
        List<AccountContactRelation>   relationshiplist = new List<AccountContactRelation>();
        List<Contact> Contactlist= new List<Contact>();
       
        Boolean redirect=false;
        Integer duplicatecount;
        List<Contact> duplicatecontact;
        Boolean hasDuplicateContact;
        
        RecordType[] salestypes = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Sales' And sObjectType = 'Contact' Limit 1];
        Id salesRecordTypeId = null;
        If(salestypes.size() > 0) {
            salesRecordTypeId  = salestypes.get(0).Id;
        }
        
        
        Account relationaccount= [Select id, parentid from Account where id=:conobject.accountId]; 
        conObject.Accountid= relationaccount.parentid;
        conObject.crm_Contact_Type__c ='Sales';
        conObject.Recordtypeid=salesRecordTypeId;
        conObject.Sync_to_Marketing__c=true;
        contactlist.add(conObject);
        Id Contactid;
        try{
            duplicatecontact= new List<Contact>();
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.AllowSave = false; 
            Database.SaveResult[] srList = Database.Insert(contactlist,dml);
            System.debug('###srList' + srList);
            for (Database.SaveResult sr : srList) 
            {
                 if (!sr.isSuccess()) 
                    {
                        for (Database.Error error : sr.getErrors()) 
                        {
                            if (error instanceof Database.DuplicateError) 
                            {
                                Database.DuplicateError duplicateError =  (Database.DuplicateError)error;
                                Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                                duplicatecount=0;
                                for(Datacloud.MatchResult matchResult : duplicateResult.getMatchResults())
                                {    
                                    
                                    
                                    for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) 
                                    {
                                        duplicatecount++;
                                        DuplicateContact.add((Contact)matchRecord.getRecord());
                                    }
                                }
                               // message=String.valueof(duplicatecount)+' Possible Duplicate Record found. '+duplicateResult.getErrorMessage();
                                System.debug('DuplicateContact: ' + DuplicateContact);
                                hasDuplicateContact= !DuplicateContact.isEmpty();
                            }
                        }
                    }
            }
            
            if(conObject.id!=null)
            {
                relationaccount= [Select id, parentid from Account where id=:conobject.accountId]; 
                relationship.Accountid=relationaccount.id;
                relationship.Contactid=conobject.id;
                relationshiplist.add(relationship);
            }
            if(relationshiplist.size()>0)
            {
                System.debug('@@@@relationshiplist@@@'+relationshiplist);
                insert relationshiplist;
            }
        }
        
        catch(Exception ex)
        {
            
            
        }
         return DuplicateContact;
        
    } 
}