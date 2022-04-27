/* Created By: Supriya goel
Date: Sprint 6 US
Test class: Class for the count for relation 
*/

public class crm_AccountTriggerHelper {
 public static Boolean isFirstTime = true;
 /*  
   public static crm_AccountRecordTypes__c rTProspect= crm_AccountRecordTypes__c.getValues('Prospect');
     public static Id ProspectRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTProspect.crm_Record_Type_Label__c).getRecordTypeId();
     public static  void CountRelation(list<Account> acntList ) {
     Set<Id> parentAccs = new Set<Id>();
    
    RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'business_account' And sObjectType = 'Account' Limit 1];
     Id RelationLevelRecordTypeId = null;
     If(rtypes.size() > 0) {
     RelationLevelRecordTypeId = rtypes.get(0).Id;
     }
             
             Map<Id, Integer> childCount = new Map<Id, Integer>();
              if(acntList.size()>0){ 
             for (Account a : acntList){
               
                 if(a.ParentId != null && a.RecordTypeId == RelationLevelRecordTypeId)
                     parentAccs.add(a.ParentId);  //collect parent ids
                }
             } 
               
            
             for(Account acc : [Select Id, ParentId from Account where ParentId IN :parentAccs]){
                 if(childCount.get(acc.ParentId) == null)
                 childCount.put(acc.ParentId, 0);  //create a counter for parent
              
             childCount.put(acc.ParentId, childCount.get(acc.ParentId) +1); //increment counter
              
             }
              
             List<Account> accsUpdate = new List<Account>{};
              
             for(Id accId : childCount.keySet())
             accsUpdate.add(new Account(Id = accId, crm_Count_of_Relation_level_Accounts__c= childCount.get(accId))); //set parent counts
              
             if(accsUpdate != null && !accsUpdate.isEmpty())
             Database.update(accsUpdate); //update parent accounts
             
       
       }//end of method
       
       public static  void CountRelationUpdate(list<Account> acntList , list<Account> oldacntList ) {
             Set<Id> parentAccs = new Set<Id>();
              crm_AccountRecordTypes__c rTRelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
     Id RelationLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTRelation.crm_Record_Type_Label__c).getRecordTypeId();
             
             
             Map<Id, Integer> childCount = new Map<Id, Integer>();
              if(acntList.size()>0){ 
              
             for (Account a : acntList){
             
                 if(a.ParentId != null && a.RecordTypeId ==RelationLevelRecordTypeId )
                     parentAccs.add(a.ParentId);  //collect parent ids
                }
             } 
             
             if(oldacntList.size()>0){ 
             for (Account a : oldacntList){
                 if(a.ParentId != null)
                     parentAccs.add(a.ParentId);  //collect parent ids
                }
             } 
               
            
             for(Account acc : [Select Id, ParentId from Account where ParentId IN :parentAccs]){
                 if(childCount.get(acc.ParentId) == null)
                 childCount.put(acc.ParentId, 0);  //create a counter for parent
              
             childCount.put(acc.ParentId, childCount.get(acc.ParentId) +1); //increment counter
              
             }
              
             List<Account> accsUpdate = new List<Account>{};
              
             for(Id accId : childCount.keySet())
             accsUpdate.add(new Account(Id = accId, crm_Count_of_Relation_level_Accounts__c= childCount.get(accId))); //set parent counts
              
             if(accsUpdate != null && !accsUpdate.isEmpty())
             Database.update(accsUpdate); //update parent accounts
             
       
       }//end of method
       */
 public static List < Account > IsLeadUpdated(List < Account > triggerNewList, Map < id, Account > triggerOldMap) {
  RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Prospect'
   And sObjectType = 'Account'
   Limit 1
  ];
  Id ProspectRecordTypeId = null;
  If(rtypes.size() > 0) {
   ProspectRecordTypeId = rtypes.get(0).Id;
  }

  for (Account acnt: triggerNewList) {
   if (acnt.crm_Lead_mapped_field__c == '1' && acnt.RecordTypeId != ProspectRecordTypeId) {
    acnt.crm_Lead_mapped_field__c = '';
    acnt.BillingStreet = TriggerOldMap.get(acnt.id).BillingStreet;
    acnt.BillingCity = TriggerOldMap.get(acnt.id).BillingCity;
    acnt.BillingState = TriggerOldMap.get(acnt.id).BillingState;
    acnt.BillingCountry = TriggerOldMap.get(acnt.id).BillingCountry;
    acnt.BillingPostalCode = TriggerOldMap.get(acnt.id).BillingPostalCode;
    acnt.Phone = TriggerOldMap.get(acnt.id).Phone;
    acnt.Website = TriggerOldMap.get(acnt.id).Website;
    acnt.Rating = TriggerOldMap.get(acnt.id).Rating;
    acnt.AnnualRevenue = TriggerOldMap.get(acnt.id).AnnualRevenue;
    acnt.Name = TriggerOldMap.get(acnt.id).Name;
    //acnt.BillingCountryCode=TriggerOldMap.get(acnt.id).BillingCountryCode;
    acnt.Fax = TriggerOldMap.get(acnt.id).Fax;
    acnt.BillingLatitude = TriggerOldMap.get(acnt.id).BillingLatitude;
    acnt.Owner = TriggerOldMap.get(acnt.id).owner;
    acnt.BillingLongitude = TriggerOldMap.get(acnt.id).BillingLongitude;
    acnt.NumberOfEmployees = TriggerOldMap.get(acnt.id).NumberOfEmployees;
    //acnt.BillingStateCode=TriggerOldMap.get(acnt.id).BillingStateCode;
    acnt.Industry = TriggerOldMap.get(acnt.id).Industry;
    acnt.orga__c = TriggerOldMap.get(acnt.id).orga__c;
    acnt.AccountSource = TriggerOldMap.get(acnt.id).AccountSource;
    acnt.Website = TriggerOldMap.get(acnt.id).Website;
   }
  }
  return triggerNewList;
 }

 public static void countPrimaryaccount(List < Account > newAccountlist) {

  RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'business_account'
   And sObjectType = 'Account'
   Limit 1
  ];
  Id RelationLevelRecordTypeId = null;
  If(rtypes.size() > 0) {
   RelationLevelRecordTypeId = rtypes.get(0).Id;
  }
  Map < id, Integer > PrimaryCount = new Map < id, Integer > ();
  Set < id > ParentIdset = new Set < id > ();

  Integer count = 0;

  for (Account acc: newAccountlist) {
   if (acc.recordTypeId == RelationLevelRecordTypeId && acc.Parentid != null)
    ParentIdset.add(acc.Parentid);
  }

  for (AggregateResult agg: [SELECT Count(id) primaryAcc, ParentId account from account WHERE crm_Primary_Customer_Account__c = true and recordtypeId =: RelationLevelRecordTypeId and ParentId in: ParentIdset group by ParentId]) {
   PrimaryCount.put((Id) agg.get('account'), (Integer) agg.get('primaryAcc'));
  }
  System.debug('@@PrimaryCount' + PrimaryCount);
  for (Account relAcc: newAccountlist) {
   count = PrimaryCount.get(relAcc.Parentid);
   if (relAcc.crm_Primary_Customer_Account__c == true) {
    if (count == 0) {
     count = 1;
     PrimaryCount.put(relAcc.Parentid, count);
    } else if (count == 1) {
     relAcc.adderror('Primary account already exists for parent account');
    }
   }
  }

 }

 public static void countPrimaryaccountUpdate(Map < id, Account > newAccountMap, Map < id, Account > oldAccountMap) {
/*  RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'business_account'
   And sObjectType = 'Account'
   Limit 1
  ];
  Id RelationLevelRecordTypeId = null;
  If(rtypes.size() > 0) {
   RelationLevelRecordTypeId = rtypes.get(0).Id;
  }
  Map < id, Integer > PrimaryCount = new Map < id, Integer > ();
  Set < id > ParentIdset = new Set < id > ();
  Set < id > accountid = new Set < id > ();
  Integer count = 0;

  for (Account acc: newAccountMap.values()) {
   if (acc.recordTypeId == RelationLevelRecordTypeId && acc.Parentid != null) {
    ParentIdset.add(acc.Parentid);
    accountid.add(acc.id);
   }
  }

  for (AggregateResult agg: [SELECT Count(id) primaryAcc, ParentId account from account WHERE crm_Primary_Customer_Account__c = true and recordtypeId =: RelationLevelRecordTypeId and ParentId in: ParentIdset and id not in: accountid group by ParentId]) {
   PrimaryCount.put((Id) agg.get('account'), (Integer) agg.get('primaryAcc'));
  }
  System.debug('@@PrimaryCount' + PrimaryCount);
  for (Account relAcc: newAccountMap.values()) {
   count = PrimaryCount.get(relAcc.Parentid);
   Account oldValue = oldAccountMap.get(relAcc.id);
   System.debug('@@oldValue' + oldValue);
   if (relAcc.crm_Primary_Customer_Account__c == true && relAcc.crm_Primary_Customer_Account__c != oldValue.crm_Primary_Customer_Account__c) {
    if (count == 0) {
     count = 1;
     PrimaryCount.put(relAcc.Parentid, count);
    } else if (count == 1) {
     relAcc.adderror('Primary account already exists for parent account');
    }
   }
  }*/
 }

 public static void updateAddress(List < Account > triggerNewList, Map < id, Account > triggerOldMap, Boolean isInsert) {

  RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Prospect'
   And sObjectType = 'Account'
   Limit 1
  ];
  Id ProspectRecordTypeId = null;
  If(rtypes.size() > 0) {
   ProspectRecordTypeId = rtypes.get(0).Id;
  }

  for (Account acc: triggerNewList) {
   if (isInsert && acc.RecordTypeId == ProspectRecordTypeId) {
    if (acc.crm_Lead_mapped_field__c == '1') {
     System.debug('-----------------------1');
     acc.crm_Lead_mapped_field__c = '';
     acc.crm_Billing_City__c = acc.BillingCity;
     acc.crm_Billing_Country__c = acc.BillingCountry;
     acc.crm_Billing_State_Province__c = acc.BillingState;
     acc.crm_Billing_Street__c = acc.BillingStreet;
     acc.crm_Billing_Zip_Postal_Code__c = acc.BillingPostalCode;
     acc.crm_Visit_Address_City__c = acc.BillingCity;
     acc.crm_Visit_Address_Country__c = acc.BillingCountry;
     acc.crm_Visit_Address_Street__c = acc.BillingStreet;
     acc.crm_Visit_Address_Zipcode__c = acc.BillingPostalCode;
     acc.crm_bus_addr_City__c = acc.BillingCity;
     acc.crm_bus_addr_Country__c = acc.BillingCountry;
     acc.crm_bus_addr_Street__c = acc.BillingStreet;
     acc.crm_bus_addr_Zip_Code__c = acc.BillingPostalCode;
     acc.crm_Shipping_City__c = acc.BillingCity;
     acc.crm_Shipping_Country__c = acc.BillingCountry;
     acc.crm_Shipping_State_Province__c = acc.BillingState;
     acc.crm_Shipping_Street__c = acc.BillingStreet;
     acc.crm_Shipping_Zip_Postal_Code__c = acc.BillingPostalCode;
     acc.ShippingCity = acc.BillingCity;
     acc.ShippingCountry = acc.BillingCountry;
     acc.ShippingPostalCode = acc.BillingPostalCode;
     acc.ShippingState = acc.BillingState;
     acc.ShippingStreet = acc.BillingStreet;
    } else if (acc.crm_Lead_mapped_field__c != '1') {
     System.debug('-----------------------2');
     acc.crm_Lead_mapped_field__c = '';
     acc.ShippingCity = acc.crm_Shipping_City__c;
     acc.ShippingCountry = acc.crm_Shipping_Country__c;
     acc.ShippingPostalCode = acc.crm_Shipping_Zip_Postal_Code__c;
     acc.ShippingState = acc.crm_Shipping_State_Province__c;
     acc.ShippingStreet = acc.crm_Shipping_Street__c;
     acc.BillingCity = acc.crm_Billing_City__c;
     acc.BillingCountry = acc.crm_Billing_Country__c;
     acc.BillingState = acc.crm_Billing_State_Province__c;
     acc.BillingStreet = acc.crm_Billing_Street__c;
     acc.BillingPostalCode = acc.crm_Billing_Zip_Postal_Code__c;
    }
   } else if (!isInsert && acc.RecordTypeId == ProspectRecordTypeId) {
    System.debug('-----------------------3');
    if (acc.crm_Lead_mapped_field__c != '1') {
     acc.crm_Lead_mapped_field__c = '';
     if (acc.crm_Shipping_City__c != TriggerOldMap.get(acc.id).crm_Shipping_City__c)
      acc.ShippingCity = acc.crm_Shipping_City__c;
     if (acc.crm_Shipping_Country__c != TriggerOldMap.get(acc.id).crm_Shipping_Country__c)
      acc.ShippingCountry = acc.crm_Shipping_Country__c;
     if (acc.crm_Shipping_Zip_Postal_Code__c != TriggerOldMap.get(acc.id).crm_Shipping_Zip_Postal_Code__c)
      acc.ShippingPostalCode = acc.crm_Shipping_Zip_Postal_Code__c;
     if (acc.crm_Shipping_State_Province__c != TriggerOldMap.get(acc.id).crm_Shipping_State_Province__c)
      acc.ShippingState = acc.crm_Shipping_State_Province__c;
     if (acc.crm_Shipping_Street__c != TriggerOldMap.get(acc.id).crm_Shipping_Street__c)
      acc.ShippingStreet = acc.crm_Shipping_Street__c;
     if (acc.crm_Billing_City__c != TriggerOldMap.get(acc.id).crm_Billing_City__c)
      acc.BillingCity = acc.crm_Billing_City__c;
     if (acc.crm_Billing_Country__c != TriggerOldMap.get(acc.id).crm_Billing_Country__c)
      acc.BillingCountry = acc.crm_Billing_Country__c;
     if (acc.crm_Billing_State_Province__c != TriggerOldMap.get(acc.id).crm_Billing_State_Province__c)
      acc.BillingState = acc.crm_Billing_State_Province__c;
     if (acc.crm_Billing_Street__c != TriggerOldMap.get(acc.id).crm_Billing_Street__c)
      acc.BillingStreet = acc.crm_Billing_Street__c;
     if (acc.crm_Billing_Zip_Postal_Code__c != TriggerOldMap.get(acc.id).crm_Billing_Zip_Postal_Code__c)
      acc.BillingPostalCode = acc.crm_Billing_Zip_Postal_Code__c;

    } else if (acc.crm_Lead_mapped_field__c == '1') {
     System.debug('-----------------------4');
     acc.crm_Lead_mapped_field__c = '';
     acc.crm_Billing_City__c = acc.BillingCity;
     acc.crm_Billing_Country__c = acc.BillingCountry;
     acc.crm_Billing_State_Province__c = acc.BillingState;
     acc.crm_Billing_Street__c = acc.BillingStreet;
     acc.crm_Billing_Zip_Postal_Code__c = acc.BillingPostalCode;
     acc.crm_Visit_Address_City__c = acc.BillingCity;
     acc.crm_Visit_Address_Country__c = acc.BillingCountry;
     acc.crm_Visit_Address_Street__c = acc.BillingStreet;
     acc.crm_Visit_Address_Zipcode__c = acc.BillingPostalCode;
     acc.crm_bus_addr_City__c = acc.BillingCity;
     acc.crm_bus_addr_Country__c = acc.BillingCountry;
     acc.crm_bus_addr_Street__c = acc.BillingStreet;
     acc.crm_bus_addr_Zip_Code__c = acc.BillingPostalCode;
     acc.crm_Shipping_City__c = acc.BillingCity;
     acc.crm_Shipping_Country__c = acc.BillingCountry;
     acc.crm_Shipping_State_Province__c = acc.BillingState;
     acc.crm_Shipping_Street__c = acc.BillingStreet;
     acc.crm_Shipping_Zip_Postal_Code__c = acc.BillingPostalCode;
     acc.ShippingCity = acc.BillingCity;
     acc.ShippingCountry = acc.BillingCountry;
     acc.ShippingPostalCode = acc.BillingPostalCode;
     acc.ShippingState = acc.BillingState;
     acc.ShippingStreet = acc.BillingStreet;
    }
   }

  }
 } //end of method
 // method to update last_updated_time__c
 public static void checkIfUpdated(List < Account > triggerNewList, List < Account > triggerOldList) {
  set < String > fieldSets = Schema.SObjectType.Account.fields.getMap().keySet();
  list < String > allFields = new list < String > (fieldSets);

  System.debug('old : ' + triggerOldList);
  Integer i = 0, j = 0;
  while (j < allFields.size()) {
   if (i < triggerNewList.size() && triggerOldList[i].get(allFields[j]) != triggerNewList[i].get(allFields[j])) {
    triggerNewList[i].Last_Updated_Time__c = System.now();
    i++;
    j = 0;
   }
   j++;
  }
  System.debug('new : ' + triggerNewList);
 } //end of method

 //Added by Rajeev Shekhar
 //Customer Conversion Interface, Date 15-April-2018
 public static void initiateCustomerConversion(Account[] newAccounts, Map < Id, Account > oldAccountMap) {
  environment_settings__c env = environment_settings__c.getValues('ConvertCustomerInterfaceSwitch');
  //Perform callout if the switch is ON
  if (env != null && env.value__c == 'true') {
   List < Id > accIds = new List < Id > ();
      String getDateFromSetting = Label.AccountTrigger_Octoberfirst2020;
      String[] lstPartsOfDate = getDateFromSetting .split('@@@');
      Datetime dt = datetime.newInstance(Integer.valueOf(lstPartsOfDate[0]), Integer.valueOf(lstPartsOfDate[1]), Integer.valueOf(lstPartsOfDate[2]));
      System.debug('dt-P11--class----'+dt);
   accIds.clear();
   for (Account a: newAccounts) {
       System.debug('account --------'+a.Id);
    if (String.isNotBlank(a.Customer_Converted__c)) {
     String oldVal = oldAccountMap.get(a.Id).Customer_Converted__c;
     if (a.Customer_Converted__c == 'NotConverted' && String.isNotBlank(oldVal) && oldVal != 'NotConverted') {
      //accIds.add(a.Id);
     }
     if(a.Customer_Converted__c == 'Converted' && String.isNotBlank(oldVal) && oldVal != 'Converted') {
      accIds.add(a.Id);
     }else if(a.Customer_Converted__c == 'Converted' &&  a.CreatedDate >= dt && String.isBlank(oldVal) ){
         accIds.add(a.Id);
     }
        
    }
   }
 System.debug('accIds--------'+accIds);
      if (accIds.size() > 0){
         if(Limits.getQueueableJobs() == 1){
              System.debug('Limits.getQueueableJobs()-------'+Limits.getQueueableJobs());
              System.debug('accIds--------'+accIds);
                String hour = String.valueOf(Datetime.now().hour());
                String min = String.valueOf(Datetime.now().minute()); 
                String ss = String.valueOf(Datetime.now().second() + 15);
                //parse to cron expression
                String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
            System.schedule('Account master' + String.valueOf(Math.random()), nextFireTime, new crm_AccountTriggerIntegrationSchedulable(accIds));
          }else{
              System.enqueueJob(new crm_convertCustomerIntegrationController(accIds));
          }
          
      }  
  }
 }

 //Added by supriya 28th sept econnect issue for Process builder when updating account 
 //show relation below party

 public static void showrelationbelowparty(List < Account > accountList) {
  RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'business_account'
   And sObjectType = 'Account'
   Limit 1
  ];
  Id rectype = null;
  If(rtypes.size() > 0) {
   rectype = rtypes.get(0).Id;
  }
  System.debug('Recordtype id: ' + rectype);
  //Id rectype = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Relation level Customer').getRecordTypeId();

  for (Account a: accountList) {
   if (a.recordtypeid == rectype && a.parentid != null) {
    a.crm_Party_level_Account__c = a.parentid;
   }

  }

 }

 //Added by supriya 
 //show status Process builder
 public static void ChangeCustomerStatus(List < Account > accountList) {
  Map < Id, String > partystatusMap = new Map < Id, String > ();

  for (Account a: accountList) {
   partystatusMap.put(a.id, a.crm_Customer_Status_Role_3__c);

  }
  Map < id, List < Account >> partyrelMap = new Map < id, List < Account >> ();
  List < Account > relAccounts = [Select id, parentid, crm_Customer_Status_Role_3__c from Account where parentid in: partystatusMap.keyset()];
  for (Account a: relAccounts) {

   if (partyrelMap.containsKey(a.parentid)) {
    List < Account > templist = new List < Account > ();
    templist = partyrelMap.get(a.parentid);
    templist.add(a);
    partyrelMap.put(a.parentid, templist);

   } else {
    List < Account > templist = new List < Account > ();
    templist.add(a);
    partyrelMap.put(a.parentid, templist);
   }

  }
  List < Account > Updatelist = new List < Account > ();

  for (Id parentid: partyrelMap.keyset()) {
   List < Account > relList = partyrelMap.get(parentid);
   for (Account a: relList) {
    a.crm_Customer_Status_Role_3__c = partystatusMap.get(parentid);
    Updatelist.add(a);

   }
  }
  
  if(Updatelist.size()>0)
      update Updatelist;
      
       RecordType[] salestypes = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Sales' And sObjectType = 'Contact' Limit 1];
        Id salesRecordTypeId = null;
        If(salestypes.size() > 0) {
            salesRecordTypeId  = salestypes.get(0).Id;
        }
      
 List<Contact> contactlist = [Select id , status__c ,  crm_contact_type__c, account.crm_Customer_Status_Role_3__c, recordtypeid  from Contact where accountid in :  partystatusMap.keyset() and recordtypeid = :salesRecordTypeId  ]; 
   for (Contact c :contactList){
       if (c.account.crm_Customer_Status_Role_3__c == 'I' || c.account.crm_Customer_Status_Role_3__c == 'i')
           c.status__c= 'Inaktiv';
      
   }
   if(contactList.size()>0)
       update contactList;
      

 } //end of fn

 //Method to enqueue Opportunities to be sent via Agreement master interface
 //Author: Rajeev Shekhar
 public static void enqueueOpportunityAgreementMaster(List < Account > newAccounts) {
  environment_settings__c env = environment_settings__c.getValues('AgeementMasterInterfaceSwitch');
  if (env != null && env.value__c == 'true') {
   Set < Id > parentIds = new Set < Id > ();
   List < String > oppIds = new List < Id > ();
   List < Opportunity > oppsToUpdate = new List < Opportunity > ();

   RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'business_account'
    And sObjectType = 'Account'
    Limit 1
   ];
   Id rectype = null;
   If(rtypes.size() > 0) {
    rectype = rtypes.get(0).Id;
   }
   for (Account acct: [Select Id, crm_Updated_by_CDH__c, ParentId, RecordTypeId From Account Where Id In: newAccounts]) {
    if (acct.RecordTypeId == rectype)
     parentIds.add(acct.ParentId);
   }
   System.debug('parentIds--------@'+parentIds);

   for (Opportunity opps: [Select Id, crm_Agreement_End_Date__c, crm_Callout_Status__c From Opportunity Where AccountId IN: parentIds And crm_Verified_by_Contract_Management__c = true And IsWon = true]) {
    System.debug('opps.crm_Agreement_End_Date__c--------@'+opps.crm_Agreement_End_Date__c);
    System.debug('opps.crm_Agreement_End_Date__c--------@'+opps.crm_Agreement_End_Date__c);
    
    if ((opps.crm_Agreement_End_Date__c == null) || (opps.crm_Agreement_End_Date__c >= Date.today())) {
     if (opps.crm_Callout_Status__c == 'Callout Finished') {
      opps.crm_Callout_Status__c = 'Callout Pending';
      oppsToUpdate.add(opps);
     }
     oppIds.add(opps.Id);
    }
   }
   
   try {
    update oppsToUpdate;
   }
   Catch(Exception e) {
    System.debug(e);
   }
   System.debug('oppIds--------@'+oppIds);
   //account --> Relation level getting inserted
   if (oppIds.size() > 0) System.enqueueJob(new crm_agreementIntegrationController(oppIds, 'account'));
  }
 }

 //Method to send emails to Opp Owner when party is made inactive
 //Author: Supriya Goel
 public static void sendEmailOppOwnerPartyInactivation(List < Account > newAccounts, Map < Id, Account > oldAccountsMap) {
  environment_settings__c env = environment_settings__c.getValues('AgeementMasterInterfaceSwitch');
  if (env != null && env.value__c == 'true') {
   Set < Id > partyIds = new Set < Id > ();
   List < String > oppIds = new List < Id > ();

   RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Party_level_Customer'
    And sObjectType = 'Account'
    Limit 1
   ];
   Id partyrectype = null;
   If(rtypes.size() > 0) {
    partyrectype = rtypes.get(0).Id;
   }


   List < Account > acntlist = [Select Id, crm_Customer_Status_Role_3__c, RecordTypeId From Account Where Id In: newAccounts];
   for (Account acct1: acntlist) {
    Account oldAccount = oldAccountsMap.get(acct1.id);
    if (String.isNotBlank(acct1.crm_Customer_Status_Role_3__c) && acct1.crm_Customer_Status_Role_3__c.equalsIgnoreCase('I') && acct1.RecordTypeId == partyrectype && oldAccount.crm_Customer_Status_Role_3__c != acct1.crm_Customer_Status_Role_3__c)
     partyIds.add(acct1.Id);
   }

   OrgWideEmailAddress owa = [Select id, DisplayName, Address from OrgWideEmailAddress limit 1];
   List < Messaging.SingleEmailMessage > allmsg = new List < Messaging.SingleEmailMessage > ();

   for (Opportunity opps: [Select Id, Name, Ownerid, Owner.Email, Owner.Name, Account.name, Account.crm_Reason_for_Customer_Blocking__c, crm_Agreement_End_Date__c, crm_Primary_Opportunity_Contact__c, Accountid From Opportunity Where AccountId IN: partyIds And crm_Verified_by_Contract_Management__c = true And IsWon = true]) {
    if ((opps.crm_Agreement_End_Date__c == null) || (opps.crm_Agreement_End_Date__c >= Date.today())) {
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
     List < string > toAddress = new List < string > ();
     mail.setToAddresses(new String[] {
      opps.Owner.Email
     });
  //   mail.setTargetObjectId(opps.crm_Primary_Opportunity_Contact__c);
     mail.setSaveAsActivity(false);
     mail.setUseSignature(false);
     mail.setSubject('Opportunity created for an Inactive Party ' + opps.Name);
     String reason = '';
     if (opps.Account.crm_Reason_for_Customer_Blocking__c != '')
      reason = ' due to ' + opps.Account.crm_Reason_for_Customer_Blocking__c;
     string body = 'Hello ' + opps.Owner.Name + ',';
     body = body + '<br/> <br/> The account ' + opps.account.name + ' has been inactivated ' + reason;
     body = body + '<br/> Please view your oportunity <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + opps.id + '">' + opps.Name + '</a>';
     body = body + '<br/> <br/> Thanks, <br/> Salesforce Support';
     mail.setHtmlBody(body);

     allmsg.add(mail);
     try {
      Messaging.sendEmail(allmsg, false);
     } catch (Exception e) {
      System.debug(e.getMessage());
     }
    }
   }
  }
 }
 
  //Added by Jainam Shah for Incident Resoltuion on 04-Feb-2019
  public static void setPrimaryRelation(List < Account > newAccountlist){
   Set < Id > parentIds = new Set < Id > ();
   Set <Id> partylevelId = new Set<Id>();
    Map<id, List<Account>> PartyRelationAccountMap = new Map<Id, List<Account>>();
    Map<id, Account> RelationPartyAccountMap = new Map<Id, Account>();
    Map<Id,Id> ParentAccountOwnerMap = new Map<Id,Id>(); 
        
         for (account acnt : newAccountlist){
             ParentAccountOwnerMap.put(acnt.id, acnt.createdbyid); //party  , party owner
             partylevelId.add(acnt.id); 
         
         }
    
    for (Account acct: [Select Id, ParentId, RecordTypeId From Account Where Id In: partylevelId]) {
    parentIds.add(acct.ParentId);
     }
       List<Account> allrelationAccounts=[select id,parentid, crm_Customer_Number__c,crm_Count_of_Relation_level_Accounts__c, crm_Primary_Customer_Account__c,createdbyid,crm_Revenue_This_Year__c,crm_bus_addr_City__c , crm_bus_addr_Country__c,crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c  FROM account where  parentid in :parentIds and crm_Customer_Number__c!=null order by parentid, createddate asc];
        
           for (account acnt : allrelationAccounts){
                    
            
           if(PartyRelationAccountMap.containskey(acnt.parentid) ){
                 List<Account> tempList= PartyRelationAccountMap.get(acnt.parentid);
                 tempList.add(acnt);
                 PartyRelationAccountMap.put(acnt.parentid, tempList);
             }else {
                  List<Account> tempList= new List<Account>();
                  tempList.add(acnt);
                  PartyRelationAccountMap.put(acnt.parentid, tempList); 
                  
             }
        } //parentid,  list of all relation accnts
        
         System.debug('@@@PartyRelationAccountMap'+PartyRelationAccountMap);
         
         for (Id Acntid: PartyRelationAccountMap.keyset()){
         System.debug('@@@in Acntid'+Acntid);
         List<Account> relationaccounts= PartyRelationAccountMap.get(Acntid);
          Boolean checkprimary= false;
          Decimal highestRevenuethisyear = relationaccounts[0].crm_Revenue_This_Year__c;
          Id primaryRelationId=relationaccounts[0].id ;
          System.debug('@@@relationaccounts'+relationaccounts+ relationaccounts[0].crm_Revenue_This_Year__c);
          for(Account a: relationaccounts){
          
              if(a.crm_Primary_Customer_Account__c  == true) {
               System.debug('@@@in 1'+a );      
                  checkprimary=true; 
                  RelationPartyAccountMap.put(a.parentid, a);    
                  break;
                   
                   
              }
              
             
          }
          if(checkprimary == false){
           for(Account a: relationaccounts){
              
                 if(a.crm_customer_number__c.isNumeric()){
                          System.debug('@@@in 2' + a );
                                checkprimary=true;
                                RelationPartyAccountMap.put(a.parentid, a);
                               
                                
                                break;
                                
                        } //end of if
                                        
                   
                  
                   
               }//end of for
               
          }//end of checkprimary if
          
          
          
          
          
            if(!checkprimary) {//setprimarynow 
            Boolean ishighest = false;
               for(Account a: relationaccounts){          
                                      
                            if(a.crm_Revenue_This_Year__c > highestRevenuethisyear ){   
                             System.debug('@@@in 3' + a );
                             
                                primaryRelationId=a.id;
                                highestRevenuethisyear= a.crm_Revenue_This_Year__c;
                                ishighest=true;
                                RelationPartyAccountMap.put(a.parentid, a);
                               
                                
                                }
                            
                        }
                        
            if(!ishighest)
            
                RelationPartyAccountMap.put(Acntid, relationaccounts[0]);   
            }//check primary false    
            
            checkprimary= false;       
             
          }//end of loop
          
        List<Account> Acntlist= new List<Account>();
       
        for (Id acntid: RelationPartyAccountMap.keyset()){
        
            Account a = new Account();
            a.id=acntid;
            a.crm_Primary_Customer_Account__c = true; 
            Account relationAccount= RelationPartyAccountMap.get(acntid);
            Account a1 = new Account();
            a1.id=relationAccount.id;
            a1.crm_Primary_Customer_Account__c= true;
            AcntList.add(a1);
           // AcntList.add(a);
       
        }
        
        System.debug('@@@Aaaaa'+ AcntList);
         update Acntlist;
              
        // setaddress(RelationPartyAccountMap, ParentAccountOwnerMap );
  
  }
    //To CHnage converted Status to converted of  Party Level Customer
     public static void setPartyConverted(List < Account > newAccountlist){
        System.debug('newAccountlist----------'+newAccountlist);
         String strUpdateConversionComment = Label.AccTrigger_UpdateConversionComment;
        List<Account> listNewAccount = new List<Account>();
        Set<Id> setPartylevelId = new Set<Id>();
        for (account acnt : newAccountlist){
             
             setPartylevelId.add(acnt.id);  //Party Ids
         
        }
        System.debug('setPartylevelId----------'+setPartylevelId);
        if(!setPartylevelId.isEmpty()){
           for (Account acct: [Select Id, Customer_Converted__c , crm_conv_Conversion_comment__c From Account Where Id In: setPartylevelId]) {
               System.debug('acct--Customer_Converted__c--------'+acct.Customer_Converted__c);
                if(String.isBlank(acct.Customer_Converted__c) || acct.Customer_Converted__c != 'Converted'){
                    
                    acct.Customer_Converted__c = 'Converted';
                    //acct.crm_customer_converted_date__c    = System.today();
                     acct.crm_conv_Conversion_comment__c = strUpdateConversionComment.replace('ConvertedDate', String.valueof(System.today()));

                    listNewAccount.add(acct);
                    System.debug('acct--listNewAccount--------'+listNewAccount);
                     
                }
               
            
            } 
        }
    
        if(!listNewAccount.isEmpty()){
             System.debug('acct--listNewAccount---end-----'+listNewAccount);
            Update listNewAccount;
        }
            
    }  
    
    public static void setPartyConvertedFromProspect(List < Account > listNewAccount , Map<Id, Account> mapOldAccount){
        
        List<Account> lstUpdatedAccounts = new List<Account>();
        Set<Id> setAccIds = new Set<Id>();
        Id partyrectype = null;
        Id prospectRecordTypeId = null;
        environment_settings__c env = environment_settings__c.getValues('PartyConvertedFromProspectSwitch');
        System.debug('env----'+env);
        if (env != null && env.value__c == 'true') {
            RecordType[] rPartytype = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Party_level_Customer'
                                    And sObjectType = 'Account' Limit 1 ];
           
            if(rPartytype.size() > 0) {
                partyrectype = rPartytype.get(0).Id;
                System.debug('partyrectype----'+partyrectype);
            }
            RecordType[] rProspecttype = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Prospect'
                                            And sObjectType = 'Account' Limit 1 ];
              
            if(rProspecttype.size() > 0) {
               prospectRecordTypeId = rProspecttype.get(0).Id;
                System.debug('rProspecttype.get(0).Id----'+rProspecttype.get(0).Id);
            }
            
            for(Account accObj :listNewAccount){
                setAccIds.add(accObj.Id);
            }
            System.debug('ssetAccIds---'+setAccIds);
            if(!setAccIds.isEmpty()){
                for (Account accParty: [Select Id , crm_Updated_by_CDH__c,Customer_Converted__c from Account where Id IN :setAccIds AND recordtype.Id = : partyrectype]){
                    Account stroldProspectId = mapOldAccount.get(accParty.Id);
                    System.debug('accParty---'+accParty);
                    System.debug('stroldProspectId---'+stroldProspectId);
                    System.debug('stroldProspectId.RecordType.Id---'+stroldProspectId.RecordTypeId);
                     System.debug('prospectRecordTypeId---'+prospectRecordTypeId);
                    System.debug('accParty.crm_Updated_by_CDH__c---'+accParty.crm_Updated_by_CDH__c);
                    if(stroldProspectId.RecordTypeId == prospectRecordTypeId && accParty.crm_Updated_by_CDH__c == true){
                        accParty.Customer_Converted__c = 'Converted';
                        lstUpdatedAccounts.add(accParty);
                        System.debug('lstUpdatedAccounts---'+lstUpdatedAccounts);
                    }
                        
                }
            }
            if(!lstUpdatedAccounts.isEmpty()){
                 System.debug('acct--lstUpdatedAccounts---end-----'+lstUpdatedAccounts);
                Update lstUpdatedAccounts;
            }
           
        }    
    }
    
    public static void sendDisqalifiedStatusToPB(Account newAcc,Account oldAcc){
        system.debug('Inside sendDisqalifiedStatusToPB');
        if(!(newAcc.disqualified__c) && (oldAcc.disqualified__c) && newAcc.Person_Id__c != null && !(newAcc.Not_updated_from_trigger__c)){
            system.debug('newAcc --> '+newAcc);
            system.debug('oldAcc --> '+oldAcc);
            String personId = newAcc.person_Id__c;
            String customerId = newAcc.Id;
            system.debug('PersonId --> '+personId);
            cs_DigitollApiHandler.setQualifyStatusInPB(false, personId, customerId);
        }
        newAcc.Not_updated_from_trigger__c = false;
    }

    public static void sendPersonPreferenceToPB(Account newAcc,Account oldAcc){
        system.debug('Inside sendPersonPreferenceToPB');
        if((newAcc.Do_not_want_custom_clearance__c != oldAcc.Do_not_want_custom_clearance__c) && newAcc.Person_Id__c != null && !(newAcc.Not_updated_from_trigger__c)){
            system.debug('newAcc --> '+newAcc);
            system.debug('oldAcc --> '+oldAcc);
            Boolean customClearance = newAcc.Do_not_want_custom_clearance__c;
            String personId = newAcc.person_Id__c;
            String customerId = newAcc.Id;
            system.debug('PersonId --> '+personId);
            cs_DigitollApiHandler.setCustomClearancePreferenceInPB(customClearance, personId, customerId);
        }
        newAcc.Not_updated_from_trigger__c = false;
    }
    public static void setUpdatedByTriggerCheck(Set<Id> accIds){
        List<Account> accToUpdate = New List<Account>();
        for(Account a : [Select id, not_updated_from_trigger__c from account where Id IN :accIds]){
            a.Not_updated_from_trigger__c = false;
            accToUpdate.add(a);
        }
        update accToUpdate;
    }

} // end of class