public class crm_ContactTriggerhelper {

 public static void syncContactdetails(Set < Id > contactsInContext, map < String, Set < String >> contactParamMap, Map < String, Contact > newcontactMap) {

  List < Contact > contactList = [Select id, email, mobilephone from Contact where email in: contactParamMap.keyset()];
  Map < String, List < Contact >> contactMap = new Map < String, List < Contact >> ();
  for (Contact con: contactList) {
   if (contactMap.containskey(con.email)) {
    List < Contact > templist = new List < Contact > ();
    templist = contactMap.get(con.email);
    templist.add(con);
    contactMap.put(con.email, templist);
   } else {
    List < Contact > templist = new List < Contact > ();
    templist.add(con);
    contactMap.put(con.email, templist);
   }
  }

  Map < Id, Contact > UpdatedContactMap = new Map < Id, Contact > ();

  for (String email: contactParamMap.keyset()) {
   if (contactParamMap.containskey(email)) {
    Set < String > params = contactParamMap.get(email);
    System.debug(contactMap);
    if (!contactMap.isEmpty()) {
     List < Contact > templist = contactMap.get(email);
     Contact conobj = newcontactMap.get(email);
     System.debug(params);
     System.debug(templist);
     System.debug(conobj);
     if (params.contains('MobilePhone')) {
      for (Contact c: templist) {
       c.MobilePhone = conobj.MobilePhone;
       UpdatedContactMap.put(c.id, c);
      }
     }

     if (params.contains('crm_No_to_Marketing_activities__c')) {
      for (Contact c: templist) {
       c.crm_No_to_Marketing_activities__c = conobj.crm_No_to_Marketing_activities__c;
       UpdatedContactMap.put(c.id, c);
      }
     }

     if (params.contains('crm_Has_agreed_to_Marketing_actvities__c')) {
      for (Contact c: templist) {
       c.crm_Has_agreed_to_Marketing_actvities__c = conobj.crm_Has_agreed_to_Marketing_actvities__c;
       UpdatedContactMap.put(c.id, c);
      }
     }
    }
   }

  }
  for (Id s: contactsInContext) {
   UpdatedContactMap.remove(s);
  }

  system.debug('@@' + UpdatedContactMap);
  controlContactTriggerExecution.deactivateContactTrigger();
  update UpdatedContactMap.values();
  controlContactTriggerExecution.activateContactTrigger();

 }

 /* public static void checkcontactedituser(List < Contact > triggerNewlist, Map < id, Contact > triggeroldMap) {

          list < User > loggedinuser = [Select id, crm_User_Type__c from user where id =: UserInfo.getUserId() limit 1];
          Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
          Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
          
          for (Contact con: triggerNewlist) {
              Contact oldCon = (triggeroldMap != null && triggeroldMap.containsKey(con.id)) ? triggeroldMap.get(con.id) : null;
              if (oldcon != null && con != oldCon && loggedinuser[0].crm_User_Type__c == 'Sales' && con.recordtypeid == csRecordTypeId) {
                  con.addError('Customer Service contact cannot be edited by sales user');
                  break;
              }
              
              if (oldcon != null && con != oldCon && loggedinuser[0].crm_User_Type__c == 'Customer Service' && con.recordtypeid == salesRecordTypeId) {
                  con.addError('Sales contact cannot be edited by Customer Service user');
                  break;
              }
          }

  }*/

 public static void setContactrecordtypeonUpdate(List < Contact > triggerNewlist, Map < id, Contact > triggeroldMap) {

  RecordType[] cstypes = [SELECT Id FROM RecordType Where DeveloperName = 'Customer_Service'
   And sObjectType = 'Contact'
   Limit 1
  ];
  Id csRecordTypeId = null;
  If(cstypes.size() > 0) {
   csRecordTypeId = cstypes.get(0).Id;
  }

  RecordType[] salestypes = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Sales'
   And sObjectType = 'Contact'
   Limit 1
  ];
  Id salesRecordTypeId = null;
  If(salestypes.size() > 0) {
   salesRecordTypeId = salestypes.get(0).Id;
  }

  RecordType[] inactivetypes = [SELECT Id FROM RecordType Where DeveloperName = 'Inactive'
   And sObjectType = 'Contact'
   Limit 1
  ];
  Id inactiveRecordTypeId = null;
  If(inactivetypes.size() > 0) {
   inactiveRecordTypeId = inactivetypes.get(0).Id;
  }

  String adminId = '';

  List < User > userList = [Select id from user where alias = 'aadmi'
   limit 1
  ];
  if (userList != null && userList.size() > 0) {
   adminId = userlist[0].id;
  }

  Set < Id > inactivecontactids = new Set < Id > ();
  Set < Id > activecontactids = new Set < Id > ();

  for (Contact c: triggerNewlist) {
   if (c.status__c == 'Inaktiv') {
    inactivecontactids.add(c.id);
   }
   if (c.status__c == 'Aktiv') {
    activecontactids.add(c.id);
   }
  }

  System.debug('##activecontactids ' + activecontactids);

  for (Contact c: triggerNewlist) {
   Contact oldCon = triggeroldMap.get(c.id);
   if (c.status__c == 'Inaktiv' && (c.crm_Contact_Type__c == 'Customer Service' || c.crm_Contact_Type__c == 'Sales')) {
    c.RecordtypeId = inactiveRecordTypeId;
    c.Sync_to_Marketing__c = false;
    c.Temp_ownerid__c = c.ownerid;
    c.Ownerid = adminId;
    //geta all activities and mark as blank 

   } else if (c.status__c == 'Aktiv' && c.crm_Contact_Type__c == 'Customer Service') {
    c.RecordtypeId = csRecordTypeId;
    c.Sync_to_Marketing__c = false;
    if (c.Temp_ownerid__c != null)
     c.ownerid = c.Temp_ownerid__c;
   } else if (c.status__c == 'Aktiv' && c.crm_Contact_Type__c == 'Sales') {
    c.RecordtypeId = salesRecordTypeId;
    c.Sync_to_Marketing__c = true;
    if (c.Temp_ownerid__c != null)
     c.ownerid = c.Temp_ownerid__c;
   }

  }

  /* *****************update tasks *********************/
  List < Task > inactivetaskList = [Select id, whoid, who.name, Contact_Name__c, Contact_Id__c from task where whoid in: inactivecontactids and(what.type = 'Account'
   OR what.type = 'Opportunity')];
  if (inactivetaskList.size() > 0) {
   for (Task t: inactivetaskList) {
    t.Contact_Name__c = t.who.name;
    t.Contact_Id__c = t.whoid;
    t.whoid = null;

   }

   update inactivetaskList;
  }

  System.debug('##inactivetaskList ' + inactivetaskList);

  /*AggregateResult[] results = [Select what.type,COUNT_DISTINCT(id) from task where what.type != 'Case' group by what.type];
        List<String> typeList = new List<string>();
        for (AggregateResult ar : results) {
            typeList.add((String)ar.get('type'));
        }*/

  //what.type contains more than 1 lakh records with duplicate values, using this query only distinct values will come.
  List < Task > activetaskList = [Select id, whoid, Contact_Id__c from task where Contact_Id__c in: activecontactids and(what.type = 'Account'
   OR what.type = 'Opportunity')];
  //List<Task> activetaskList =[Select id, whoid, Contact_Id__c from task where Contact_Id__c!= null and what.type not in :typeList and Contact_Id__c != null];
  if (activetaskList.size() > 0) {
   for (Task t: activetaskList) {
    t.whoid = t.Contact_Id__c;

   }

   update activetaskList;
  }
  System.debug('##activetaskList' + activetaskList);

  /**********************************************/

  /* *****************update events*********************/
  List < Event > inactiveEventList = [Select id, whoid, who.name, Contact_Name__c, Contact_Id__c from Event where whoid in: inactivecontactids and(what.type = 'Account'
   OR what.type = 'Opportunity')];
  if (inactiveEventList.size() > 0) {
   for (Event e: inactiveEventList) {
    e.Contact_Name__c = e.who.name;
    e.Contact_Id__c = e.whoid;
    e.whoid = null;

   }

   update inactiveEventList;
  }

  List < Event > activeEventList = [Select id, whoid, who.name, Contact_Id__c from Event where Contact_Id__c in: activecontactids and(what.type = 'Account'
   OR what.type = 'Opportunity')];
  if (activeEventList.size() > 0) {
   for (Event e: activeEventList) {
    e.whoid = e.Contact_Id__c;
   }

   update activeEventList;
  }

  /**********************************************/




 }

 public static void setnotoMarketingActivities(List < Contact > contactList) {
  //changes done for C-0888 - Zapier
  List < String > valuesList = new List < String > ();
  Set < String > valuesSet = new Set < String > ();
  environment_settings__c Profileids = environment_settings__c.getValues('Agreed_to_marketing_access');
  String Profilestr = Profileids.value__c;

  if (Profilestr != '')
   valuesList = Profilestr.split(';');
  valuesSet.addAll(valuesList);


  List < Profile > ProfilesList = [Select id from Profile where name in: valuesSet];
  Set < Id > profileidset = new Set < id > ();

  for (Profile p: ProfilesList) {
   profileidset.add(p.id);

  }
  for (Contact c: contactList) {
   if (!profileidset.contains(Userinfo.getProfileId())) {
    c.addError('Agreed to marketing user checkbox cannot be set to true');
    break;
   } else {
    c.crm_No_to_Marketing_activities__c = false;
   }
  }
 }

 public static void setagreedtoMarketingActivities(List < Contact > contactList) {
  for (Contact c: contactList) {
   c.crm_Has_agreed_to_Marketing_actvities__c = false;
  }
 }



 public static void createCSContact(List < Contact > contactList) {

  RecordType[] cstypes = [SELECT Id FROM RecordType Where DeveloperName = 'Customer_Service'
   And sObjectType = 'Contact'
   Limit 1
  ];
  Id csRecordTypeId = null;
  If(cstypes.size() > 0) {
   csRecordTypeId = cstypes.get(0).Id;
  }

  RecordType[] salestypes = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Sales'
   And sObjectType = 'Contact'
   Limit 1
  ];
  Id salesRecordTypeId = null;
  If(salestypes.size() > 0) {
   salesRecordTypeId = salestypes.get(0).Id;
  }

  RecordType[] accountrecordtypes = [SELECT Id, DeveloperName FROM RecordType Where sObjectType = 'Account'];
  Map < Id, String > accountrecordtypeMap = new Map < Id, String > ();
  If(accountrecordtypes.size() > 0) {
   for (RecordType type: accountrecordtypes) {
    accountrecordtypeMap.put(type.id, type.DeveloperName);

   }
  }
  System.debug('##accountrecordtypeMap ' + accountrecordtypeMap);

  User adminUser = [select id from user where alias = 'aadmi'
   limit 1
  ];

  Set < Id > contactIds = new Set < Id > ();
  Set < Id > accountIds = new Set < Id > ();
  Map < Id, Id > accountMap = new Map < Id, Id > ();
  Map < Id, Id > parentaccountMap = new Map < Id, Id > ();

  for (Contact c: contactList) {
   accountIds.add(c.accountid); //party
   contactIds.add(c.id);
  }

  List < Account > accountlist = [Select id, parentid, recordtypeid from Account where id in: accountIds];
  for (Account a: accountlist) {
   accountMap.put(a.Id, a.recordtypeid);
   if (a.parentid != null)
    parentaccountMap.put(a.id, a.parentid);

  }
  System.debug('##accountMap ' + accountMap);
  System.debug('##parentaccountMap ' + parentaccountMap);


  Map < Id, Id > parentprimaryrelaccount = new Map < Id, Id > ();
  Map < Id, Id > SalesCSContactMap = new Map < Id, Id > ();


  List < Account > relationaccount = [Select id, crm_Primary_Customer_Account__c, parentid from Account where parentid =: accountIds and crm_Primary_Customer_Account__c = true];
  for (Account a: relationaccount) {
   parentprimaryrelaccount.put(a.parentid, a.id);

  }
  System.debug('##parentprimaryrelaccount ' + parentprimaryrelaccount);
  List < Contact > CSContactlist = new List < Contact > ();
  List < Contact > SalesContactlist = new List < Contact > ();
  Map < Id, Id > Contactmap = new Map < Id, Id > ();

  for (Contact c: contactList) {
   Id relationAccountid = null;
   String accountrecordtype = accountrecordtypeMap.get(accountMap.get(c.accountid));
   //account recordtype = party , create a CS contact, account record type= relation , update contact to be on party ,  

   if (accountrecordtype == 'business_account' || accountrecordtype == 'crm_Party_level_Customer') {
    if (accountrecordtype == 'business_account') {
     relationAccountid = c.accountid;
     Contactmap.put(c.id, c.accountid);

     System.debug('##relationAccountid' + relationAccountid);

     if (parentaccountMap.containskey(c.accountid))
      c.Accountid = parentaccountMap.get(c.accountid);
     // SalesContactlist.add(c);
    }

    System.debug('@@SalesContactlist ' + SalesContactlist);

    // if (SalesContactlist.size()>0)
    //  update SalesContactlist;


    //create cs contact 

    Contact cloneCSCon = c.clone(false, true);
    if (adminUser != null)
     cloneCSCon.ownerid = adminUser.id;
    cloneCSCon.recordtypeid = csRecordTypeId; //sales
    cloneCSCon.Master_Reference_Id__c = c.id;
    cloneCSCon.crm_Contact_Type__c = 'Customer Service';
    cloneCSCon.accountid = null;
    cloneCSCon.crm_Origination_type__c = 'New';
    cloneCSCon.crm_Was_Split_From_Customer_Service__c = false;
    cloneCSCon.My_Bring_Userid__c = '';
    if (parentprimaryrelaccount.containskey(c.accountid)) //party 
     cloneCSCon.accountid = parentprimaryrelaccount.get(c.accountid); //relation  wth CS    //partyid,relid
    else if (relationAccountid != null)
     cloneCSCon.accountid = relationAccountid;
    cloneCSCon.Sync_to_Marketing__c = false;
    if (cloneCSCon.accountid != null)
     CSContactlist.add(cloneCSCon);

   }

  }
  if (CSContactlist.size() > 0) {
   Database.DMLOptions dml = new Database.DMLOptions();
   dml.DuplicateRuleHeader.allowSave = true;
   dml.DuplicateRuleHeader.runAsCurrentUser = true;
   Database.SaveResult[] srList = Database.Insert(CSContactlist, dml);
   system.debug('##srList ' + srList);
  }

  system.debug('##CSContactlist' + CSContactlist);
  // insert CSContactlist;

  List < Contact > serviceContactlist = [Select id, accountid, account.parentid, Master_Reference_Id__c from Contact where Master_Reference_Id__c in: contactids]; //sales contacts
  System.debug('##serviceContactlist' + serviceContactlist);


  Set < Id > CSAccountid = new Set < Id > ();
  for (Contact c: serviceContactlist) {
   SalesCSContactMap.put(c.Master_Reference_Id__c, c.id); //salessup , cssup
   CSAccountid.add(c.accountid); //trel level id 

  }
  Map < Id, Id > CSAccountMap = new Map < Id, Id > ();

  List < Account > CSAccountList = [select id, parentid from Account where id in: CSAccountid];
  for (Account a: CSAccountList) {
   CSAccountMap.put(a.id, a.parentid); //1, parentid 

  }

  System.debug('##CSAccountMap ' + CSAccountMap);

  List < AccountContactRelation > relationshiplist = new List < AccountContactRelation > ();

  for (Contact c: Contactlist) {
   System.debug('##c ' + c);
   c.Master_Reference_Id__c = SalesCSContactMap.get(c.id);
   System.debug('##c.accountid ' + c.accountid);
   AccountContactRelation relationship = new AccountContactRelation();
   if (parentprimaryrelaccount.containskey(c.accountid)) {
    relationship.Accountid = parentprimaryrelaccount.get(c.accountid); //cssup account rel id

    relationship.Contactid = c.id; //sales up 
    relationshiplist.add(relationship);
   }
  }

  System.debug('##relationshiplist1111sales ' + relationshiplist);


  for (Contact c: serviceContactlist) {
   AccountContactRelation relationship = new AccountContactRelation();
   if (parentaccountMap.containskey(c.accountid))
    relationship.Accountid = parentaccountMap.get(c.accountid); //i contact is created o relation

   else if (CSAccountMap.containskey(c.accountid))
    relationship.Accountid = CSAccountMap.get(c.accountid);

   relationship.Contactid = c.id;
   if (relationship.Accountid != null)
    relationshiplist.add(relationship);
  }

  System.debug('##relationshiplist1111cs ' + relationshiplist);

  if (relationshiplist.size() > 0)

   insert relationshiplist;


 }

 public static void updatesalesowner(List < Contact > contactList) {
  String adminId = '';

  List < User > userList = [Select id from user where alias = 'aadmi'
   limit 1
  ];
  if (userList != null && userList.size() > 0) {
   adminId = userlist[0].id;
  }

  for (Contact c: contactList) {
   c.ownerId = adminId;
   //if ((c.crm_Has_agreed_to_Marketing_actvities__c) && (c.Marketing_Activities_Agreed_To__c == null) && !(c.yes_to_insights_trends_and_analysis__c) && !(c.yes_to_industry_and_service_development__c)) 
   if ((c.crm_Has_agreed_to_Marketing_actvities__c) && ((c.marketing_activities_agreed_to__c == null) || (c.marketing_activities_agreed_to__c == ''))) {
    /*c.crm_Has_Agreed_To_Email__c = true;
    c.crm_Has_Agreed_to_SMS__c = true;
    c.crm_Has_Agreed_To_MyBring__c = true; */
    /*c.yes_to_insights_trends_and_analysis__c = true;
    c.yes_to_industry_and_service_development__c = true;*/
    c.marketing_activities_agreed_to__c = 'Email;SMS;MyBring';

   }

  }
 }

 public static void updatemarketingfields(List < Contact > contactList, Map < Id, contact > contactoldMap) {

  for (Contact c: contactList) {
   Contact oldCon = contactoldMap.get(c.id);

   if (!(oldCon.crm_Has_agreed_to_Marketing_actvities__c) && (c.crm_Has_agreed_to_Marketing_actvities__c) && ((c.Marketing_Activities_Agreed_To__c == null) || (c.Marketing_Activities_Agreed_To__c == ''))) {
    /*c.crm_Has_Agreed_To_Email__c = true;
    c.crm_Has_Agreed_to_SMS__c = true;
    c.crm_Has_Agreed_To_Mybring__c = true;*/
    /*c.yes_to_insights_trends_and_analysis__c = true;
    c.yes_to_industry_and_service_development__c = true;*/
    c.marketing_activities_agreed_to__c = 'Email;SMS;MyBring';
   }

    if ((oldCon.crm_Has_agreed_to_Marketing_actvities__c) && (c.crm_Has_agreed_to_Marketing_actvities__c) && ((c.Marketing_Activities_Agreed_To__c == null) || (c.Marketing_Activities_Agreed_To__c == ''))) {
    //c.crm_Has_agreed_to_Marketing_actvities__c.addError('If agreed to Marketing activities,you must choose either Insight Trends & Analysis or Industry & service development');
    c.crm_Has_agreed_to_Marketing_actvities__c = false;
    c.crm_No_to_Marketing_activities__c = true;
   }

    /*if((oldCon.crm_Has_agreed_to_Marketing_actvities__c) && (c.crm_Has_agreed_to_Marketing_actvities__c) && ((c.yes_to_insights_trends_and_analysis__c) || (c.yes_to_industry_and_service_development__c)) && (c.Marketing_Activities_Agreed_To__c==null) && (oldCon.Marketing_Activities_Agreed_To__c!=null)){
    c.crm_Has_agreed_to_Marketing_actvities__c.addError('If agreed to Marketing activities,you must choose atleast one from Email, SMS and MyBring');
      } */

   if (c.crm_No_to_Marketing_activities__c) {
    /*c.crm_Has_Agreed_To_Email__c = false;
    c.crm_Has_Agreed_to_SMS__c = false;
    c.crm_Has_Agreed_To_Mybring__c = false;*/
    /*c.yes_to_insights_trends_and_analysis__c = false;
    c.yes_to_industry_and_service_development__c = false; */
    c.Marketing_Activities_Agreed_To__c = null;
   }

  }

 }

 //Supriya  bring integration

 public static void sendtoBring(List < Contact > contactList, Map < Id, Contact > oldMap) {

  List <Id> Cids = new List <Id> ();
  RecordType[] salestypes = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Sales'
   And sObjectType = 'Contact'
   Limit 1
  ];
  Id salesRecordTypeId = null;
  If(salestypes.size() > 0) {
   salesRecordTypeId = salestypes.get(0).Id;
  }

  RecordType[] inactivetypes = [SELECT Id FROM RecordType Where DeveloperName = 'Inactive'
   And sObjectType = 'Contact'
   Limit 1
  ];
  Id inactiveRecordTypeId = null;
  If(inactivetypes.size() > 0) {
   inactiveRecordTypeId = inactivetypes.get(0).Id;
  }

  string MyBringuserid;
  string Batchjobuserid;
  string Datamigrationteamid;
  string Adminuserid;

  environment_settings__c env = environment_settings__c.getValues('MyBringContactintegrationid');
  if (env != null && env.value__c != '') {
   List < User > myBringUserList = [Select id from user where username =: env.value__c limit 1];
   if (myBringUserList.size() > 0) {
    MyBringuserid = myBringUserList[0].id;
   }
  }

  environment_settings__c env1 = environment_settings__c.getValues('AdminUserId');
  if (env1 != null && env1.value__c != '') {
   List < User > AdminUserList = [Select id from user where username =: env1.value__c limit 1];
   if (AdminUserList.size() > 0) {
    Adminuserid = AdminUserList[0].id;
   }
  }

  environment_settings__c env2 = environment_settings__c.getValues('BatchUserId');
  if (env2 != null && env2.value__c != '') {
   List < User > BatchUserList = [Select id from user where username =: env2.value__c limit 1];
   if (BatchUserList.size() > 0) {
    Batchjobuserid = BatchUserList[0].id;
   }
  }

  environment_settings__c env3 = environment_settings__c.getValues('DataMigrationTeamId');
  if (env3 != null && env3.value__c != '') {
   List < User > DataMigrationTeamList = [Select id from user where username =: env3.value__c limit 1];
   if (DataMigrationTeamList.size() > 0) {
    Datamigrationteamid = DataMigrationTeamList[0].id;
   }
  }


  for (Contact c: ContactList) {
   Contact OldCon = oldMap.get(c.id);
   System.debug('OldCon' + OldCon);
   System.debug('new con' + c);

   if ((c.recordtypeid == salesRecordTypeId || c.recordtypeid == inactiveRecordTypeId) && oldCon != c && c.crm_Callout_Status__c != 'Callout Pending' && oldCon.crm_Callout_Status__c != 'Callout Pending' && c.My_Bring_Userid__c != null && oldCon.My_Bring_Userid__c != null && (c.lastmodifiedbyid != Adminuserid && c.lastmodifiedbyid != MyBringuserid && c.lastmodifiedbyid != Batchjobuserid && c.lastmodifiedbyid != Datamigrationteamid)) { //.&& c.crm_Callout_Status__c != 'Callout Pending'
    c.crm_Callout_Status__c = 'Callout Pending';
    Cids.add(c.id);
   }
  }

  System.debug('Cids' + Cids);

  if (Cids.size() > 0)
   System.enqueueJob(new crm_contactIntegrationController(Cids));


 }

}