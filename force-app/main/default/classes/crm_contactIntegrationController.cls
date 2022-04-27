/*Supriya goel
 Contacts- mybring integration 
 11 dec 2018 */

public without sharing class crm_contactIntegrationController implements Queueable, Database.AllowsCallouts {

 //Initializing Variables
 List < String > contactids;


 //Constructor
 //Pass List of Opportunity Ids to this class, along with actionType. The valid values for actionType is fetched from Custom setting : environment_settings__c.getValues('AgeementMasterCodes')
 public crm_contactIntegrationController(List < String > contactids) {
  this.contactids = contactids;

 }

 //Main method

 public void execute(QueueableContext context) {
  environment_settings__c env = environment_settings__c.getValues('ContactBringIntegrationSwitch');
  if ((env != null && env.value__c == 'true') || Test.isRunningTest()) {
   if (!contactids.isEmpty()) {

    System.debug('contactids' + contactids);
    String conToProcessId = null;
    conToProcessId = contactids.get(contactids.size() - 1); //get last element
    System.debug('conToProcessId ' + conToProcessId);

    Contact c = [Select id, account.orga__c, Email, firstname, lastname, name, My_Bring_Userid__c,crm_myBring_last_login__c, crm_Has_agreed_to_Marketing_actvities__c,Mybring_Created_Date__c, crm_No_to_Marketing_activities__c, Marketing_Activities_Agreed_To__c, status__c, mybringstatus__c, et4ae5__Mobile_Country_Code__c, mobilePhone, Phone, crm_function_working_area__c, Preferred_Language__c, createddate, lastmodifieddate__c from contact where id =: conToProcessId]; //and  lastmodifieddate__c>= :lasttimestamp
    crm_ContactWrapper conObj = new crm_ContactWrapper();
       if(c.Marketing_Activities_Agreed_To__c == null){
           c.Marketing_Activities_Agreed_To__c = '';
       }
    conObj.firstName = c.firstname;
    conObj.lastName = c.lastname;
    conObj.userEmail = c.email;
    conObj.aggreedMarketingActivities = String.valueof(c.crm_Has_agreed_to_Marketing_actvities__c).toLowerCase();
    conObj.declinedMarketingActivities = String.valueof(c.crm_No_to_Marketing_activities__c).toLowerCase();
    /*conObj.agreedToEmail = String.valueof(c.crm_Has_Agreed_To_Email__c).toLowerCase();
    conObj.agreedToSms = String.valueof(c.crm_Has_Agreed_to_SMS__c).toLowerCase();
    conObj.agreedToMyBring = String.valueof(c.crm_Has_Agreed_to_MyBring__c).toLowerCase();*/
    conObj.agreedToEmail = c.Marketing_Activities_Agreed_To__c.contains('Email')?'true':'false';
    conObj.agreedToSMS = c.Marketing_Activities_Agreed_To__c.contains('SMS')?'true':'false';
    conObj.agreedToMyBring = c.Marketing_Activities_Agreed_To__c.contains('MyBring')?'true':'false';
    conObj.marketingActivitiesLastUpdate = String.valueof(c.lastmodifieddate__c);
    if (c.status__c == 'Aktiv')
     conObj.salesforceStatus = 'active'; // c.status__c;
    else
    if (c.status__c == 'Inaktiv')    conObj.salesforceStatus = 'inactive';
    conObj.mybringStatus = c.mybringStatus__c.toLowerCase();
   
    conObj.mobileNumber = c.mobilePhone;
    conObj.phoneNumber = c.Phone;
    conObj.workingArea = c.crm_function_working_area__c;
    
  //setting the mobile country code field
   
  environment_settings__c mobilecountrycodes= environment_settings__c.getValues('MobileCountryCodes');
  List < String > mobilevaluesList = new List < String > ();
  Map < String, string > MobileCountryCodesMap= new Map < String, String > ();
  List < String > MobileStrList= new List < String > ();
  if (mobilecountrycodes != null && mobilecountrycodes.value__c != null) {
   mobilevaluesList = mobilecountrycodes.value__c.split(',');

   for (String str: mobilevaluesList ) {
    MobileStrList = str.split('=');  mobilecountrycodesMap.put(MobileStrList[1].trim(), MobileStrList[0].trim());
     
   }

  }
  system.debug('##mobilecountrycodesMap' + mobilecountrycodesMap);
  system.debug('##cc in controller ' + c);
  
  if (c.et4ae5__Mobile_Country_Code__c!= null && mobilecountrycodesMap.containskey(c.et4ae5__Mobile_Country_Code__c))
  conObj.mobileCountryCode  = mobilecountrycodesMap.get(c.et4ae5__Mobile_Country_Code__c);
  else
  conObj.mobileCountryCode  = '+47';
  
  

    environment_settings__c prefLanguage = environment_settings__c.getValues('Preferred_Language');
    List < String > valuesList = new List < String > ();
    List < String > value = new List < String > ();
    Map < String, string > prefLanguageMap = new Map < String, String > ();
    if (prefLanguage != null && prefLanguage.value__c != null) {
     valuesList = prefLanguage.value__c.split(',');

     for (String str: valuesList) {
      value = str.split('=');
      prefLanguageMap.put(value[0], value[1]);

     }

    }


    if (c.Preferred_Language__c != null && prefLanguageMap.containskey(c.Preferred_Language__c))
     conObj.userLanguage = prefLanguageMap.get(c.Preferred_Language__c);    else     conObj.userLanguage = 'EN';

    conobj.lastUpdatedTime = String.valueof(c.lastmodifieddate__c );
    conobj.createdDateTime= String.valueof(c.Mybring_Created_Date__c );
    conobj.lastLoginDateTime = String.valueof(c.crm_myBring_last_login__c);
    
    conObj.salesforceUserId = c.id;
    
    
    
   // conobj.lastLoginDateTime = String.valueof(c.lastmodifieddate__c);  as discussd removing this mapping 
    if(c.My_Bring_Userid__c!=null)
        conobj.mybringUserId = String.valueof(c.My_Bring_Userid__c);
        
    else     conobj.mybringUserId = String.valueof(c.id);   
   

    String tId = c.Id + String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
    System.debug('JSON BODY' + JSON.serialize(conobj, true));
    HttpRequest req = new HttpRequest();
    req.setBody(JSON.serialize(conobj, true));
    environment_settings__c env1 = environment_settings__c.getValues('MyBring_Contact_Update_Integration');
    System.debug(env1);
    if(env1 != null)        req.setEndpoint(env1.value__c);
        else
      req.setEndpoint('https://www.qa.mybring.com/useradmin/sync/user/update');    
    //for custom setting {}
    
    
    environment_settings__c MyBringcredentials = environment_settings__c.getValues('MyBringcredentials');
    
    List < String > credvaluesList = new List < String > ();
    List < String > cvalue = new List < String > ();
    Map < String, string > MyBringcredentialsMap = new Map < String, String > ();
    if (MyBringcredentials != null && MyBringcredentials.value__c != null) {
     credvaluesList = MyBringcredentials.value__c.split(';');
     System.debug(credvaluesList );
     for (String str: credvaluesList ) {
      cvalue = str.split(':');      req.setHeader(cvalue[0], cvalue[1]);

     }

    }
    
    System.debug(req);
    
   // req.setHeader('X-Salesforce-Api-Name', 'apiUserName');
    //req.setHeader('X-Salesforce-Api-Key', 'apiKey');
    
    req.setHeader('Content-Type', 'application/json');
    req.setMethod('POST');


    req.setTimeout(20000);
    System.debug('## req' + req);
    Http http = new Http();

    try {
     HTTPResponse res = http.send(req);
     System.debug('###res' + res);
     if (res.getStatus() == 'OK' && res.getStatusCode() == 200) {
      c.crm_Callout_Status__c = 'Callout Finished';      c.crm_contact_Interface_TransactionId__c = tId;      update c;

     } else if (res.getStatus() != 'OK' && res.getStatusCode() != 200) {
      crm_Exception_handler.createNonExceptionRecords(res.getStatus(), res.getStatusCode(), c.Id, tId, 'Class.crm_contactIntegrationController');
      c.crm_contact_Interface_TransactionId__c = tId;
      update c;
     }

     System.debug(c);
    }
    Catch(Exception general) {
     crm_Exception_handler.createExceptionRecordsAnyType(general, c.Id);
    }
   }

   //Prepare for next job
   if (contactIds.size() > 1)
    contactIds.remove(contactids.size() - 1); //remove last element and send this updated list to next chained job

  if (contactIds.size() > 1) {     if (Test.isRunningTest() == false) {        System.enqueueJob(new crm_contactIntegrationController(contactIds)); //submit next job
   }
   }
  }

 }
}