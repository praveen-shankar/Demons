trigger ContactTrigger on Contact(before update, before insert, after insert, after update) { //, before insert

 if (test.isRunningTest()) {
  /*ContactTriggerSetting__c objOppCustomSetting = new ContactTriggerSetting__c();
  objOppCustomSetting.Name = 'Contact';
  objOppCustomSetting.Contact_Trigger_Status__c = true;
  insert objOppCustomSetting;*/
 }

 ContactTriggerSetting__c ContactTriggerSetting = ContactTriggerSetting__c.getValues('Contact');
 Boolean IsTriggerON = ContactTriggerSetting != null ? ContactTriggerSetting.Contact_Trigger_Status__c : false;
 if (IsTriggerON) {
  RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Prospect'
   And sObjectType = 'Account'
   Limit 1
  ];
  Id ProspectRecordTypeId = null;
  If(rtypes.size() > 0) {
   ProspectRecordTypeId = rtypes.get(0).Id;
  }


  if (Trigger.IsUpdate && Trigger.isBefore) {
   //crm_ContactTriggerhelper.checkcontactedituser(Trigger.new, Trigger.oldMap);
   //check for sync contacts 
   Map < String, Set < String >> contactParamMap = new Map < String, Set < String >> ();
   set < String > params = new Set < String > ();
   Map < String, Contact > newcontactMap = new Map < String, Contact > ();
   List < Contact > conStatusList = new List < Contact > ();
   List < Contact > setnotoMarketingActivitiesList = new List < Contact > ();
   List < Contact > setagreedtoMarketingActivitiesList = new List < Contact > ();
   List < Contact > contactListCSContacts = new List < Contact > ();
   Set < Id > contactsInContext = new Set < Id > ();

   Set < Id > Contactids = new Set < Id > ();
   Map < id, Contact > ConMap = new Map < Id, Contact > ();
   for (Contact con: Trigger.new) {
    Contactids.add(con.id);
    ConMap.put(con.id, con);

   }

   List < Contact > Contactlist = [Select id, crm_Lead_map_field_for_Contact__c, Master_Reference_Id__c, account.recordtypeid, account.crm_Count_of_Primary_Relation__c from Contact where id in: contactids and crm_Lead_map_field_for_Contact__c = true and Master_Reference_Id__c = null];
   for (Contact con: Contactlist) {

    system.debug('## ' + con.account.recordtypeid + ':: ' + ProspectRecordTypeId + con.crm_Lead_map_field_for_Contact__c + con.Master_Reference_Id__c);

    if (con.crm_Lead_map_field_for_Contact__c && con.Master_Reference_Id__c == null && con.account.recordtypeid != ProspectRecordTypeId) {

     contactListCSContacts.add(ConMap.get(con.id));
    } //end of lead conversion checck


   }

   for (Contact con: Trigger.new) {
    contactsInContext.add(con.Id);
    Contact oldCon = Trigger.oldMap.get(con.id);
    if (con.status__c != oldCon.status__c) {
     conStatusList.add(con);
    }




    if (con.crm_Has_agreed_to_Marketing_actvities__c != oldCon.crm_Has_agreed_to_Marketing_actvities__c && con.crm_Has_agreed_to_Marketing_actvities__c)
     setnotoMarketingActivitiesList.add(con);

    if (con.crm_No_to_Marketing_activities__c != oldCon.crm_No_to_Marketing_activities__c && con.crm_No_to_Marketing_activities__c)
     setagreedtoMarketingActivitiesList.add(con);

    newcontactMap.put(con.email, con);

    if (con.MobilePhone != oldCon.MobilePhone) {
     params.add('MobilePhone');
     contactParamMap.put(con.email, params);
    }

    if (con.crm_No_to_Marketing_activities__c != oldCon.crm_No_to_Marketing_activities__c) {
     params.add('crm_No_to_Marketing_activities__c');
     contactParamMap.put(con.email, params);
    }

    if (con.crm_Has_agreed_to_Marketing_actvities__c != oldCon.crm_Has_agreed_to_Marketing_actvities__c) {
     params.add('crm_Has_agreed_to_Marketing_actvities__c');
     contactParamMap.put(con.email, params);
    }
   } //end of for 

   if (setagreedtoMarketingActivitiesList.size() > 0) {
    crm_ContactTriggerhelper.setagreedtoMarketingActivities(setagreedtoMarketingActivitiesList);
   }

   if (setnotoMarketingActivitiesList.size() > 0) {
    crm_ContactTriggerhelper.setnotoMarketingActivities(setnotoMarketingActivitiesList);
   }
   if (contactParamMap.size() > 0) {
    crm_ContactTriggerhelper.syncContactdetails(contactsInContext, contactParamMap, newcontactMap);
   }

   if (conStatusList.size() > 0) {
    crm_ContactTriggerhelper.setContactrecordtypeonUpdate(conStatusList, Trigger.oldMap);
   }

   crm_ContactTriggerhelper.updatemarketingfields(Trigger.new, Trigger.oldMap);

   if (contactListCSContacts.size() > 0) {
    crm_ContactTriggerhelper.createCSContact(contactListCSContacts);
   }

   //Added by Supriya bring integration                
   //if opp is updated after closed won and was earlier verified by contract management and status was callout finished
   environment_settings__c env = environment_settings__c.getValues('ContactBringIntegrationSwitch');
   if (env != null && env.value__c == 'true') {
    crm_ContactTriggerhelper.sendtoBring(Trigger.new, Trigger.oldMap);

   }
  }

  //if lead is converted to Contact , create a cloned CS contact , also checck if sales contact is on relation , move to party

  if (Trigger.isInsert && Trigger.isBefore) {
   List < Contact > Updatedlist = new List < Contact > ();
   for (Contact c: Trigger.new) {
    if (c.crm_Contact_Type__c == 'Sales' && c.Status__c == 'Aktiv')
     Updatedlist.add(c);
    //marketing activities


   }


   if (Updatedlist.size() > 0)
    crm_ContactTriggerhelper.updatesalesowner(Updatedlist);



  }

  if (Trigger.isUpdate && Trigger.IsAfter) {
   set < id > Contactids = new set < id > ();
   set < id > Accountids = new set < id > ();
   for (Contact c: Trigger.new) {
    Contact oldCon = Trigger.oldMap.get(c.id);
    if (c.crm_Contact_Type__c == 'Sales' && c.status__c == 'Aktiv' && (c.crm_functional_decision_level__c != oldcon.crm_functional_decision_level__c || c.Accountid != oldcon.Accountid)) {
     Contactids.add(c.id);
     Accountids.add(c.accountid);
    }

    if (c.crm_Contact_Type__c == 'Sales' && c.status__c != oldcon.status__c) {
     Contactids.add(c.id);
     Accountids.add(c.accountid);
    }


    List < accountContactrelation > acclist = [Select id, accountid, contactid from accountContactrelation where contactid in: Contactids];

    for (accountContactrelation obj: acclist)
     Accountids.add(obj.accountid);

    if (Accountids.size() > 0)
     AccountContactRelationTriggerHelper.setprimarycontact(Accountids);
   }

  }


 }


}