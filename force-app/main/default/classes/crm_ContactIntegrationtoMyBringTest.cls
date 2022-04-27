/*Date: 25th jan 2019
Test class: Test class for the crm_ContactIntegrationtoMyBring
*/

@isTest
public class crm_ContactIntegrationtoMyBringTest {
@isTest static void contactsyncTest() {
String JSONMsg ='{"workingArea":"Logistics","userLanguage":"English","userEmail":"supriya.goel@capgemini.com","salesforceStatus":"active", "phoneNumber":"11111","mybringUserId":"0031X000003fADTQA2",  "mybringStatus":"inactive", "mobileNumber":"122233", "mobileCountryCode":"NO", "marketingActivitiesLastUpdate":"2019-01-22 08:34:05",  "lastUpdatedTime":"2019-01-22 08:34:05","lastLoginDateTime":"2019-01-22 08:34:05","createdDateTime":"2019-01-22 08:34:05", "lastName":"goel",  "firstName":"supriya",  "declinedMarketingActivities":"true", "agreedToSms":"false",  "agreedToEmail":"false", "agreedToMyBring":"false", "aggreedMarketingActivities":"false" ,  "customers": [ {"customerMasterNumber": "10008151176", "sourceSystem": "","possibleCustomerNumbers": ["1111",  "123334"], "roles": ["OM_SUPPLIER", "BASIC"]}, {"customerMasterNumber": "10005568742", "sourceSystem": "","possibleCustomerNumbers": ["1111",  "123334"], "roles": ["OM_SUPPLIER", "BASIC"]}]}';
String JSONMsg1 ='{"workingArea":"Logistics","userLanguage":"English","userEmail":"supriya1.goel@capgemini.com","salesforceStatus":"active", "phoneNumber":"11111","mybringUserId":"0031X000003fADTQ11",  "mybringStatus":"active", "mobileNumber":"122233", "mobileCountryCode":"NO", "marketingActivitiesLastUpdate":"2019-01-22 08:34:05",  "lastUpdatedTime":"2019-01-22 08:34:05","lastLoginDateTime":"2019-01-22 08:34:05","createdDateTime":"2019-01-22 08:34:05", "lastName":"goel",  "firstName":"supriya",  "declinedMarketingActivities":"false", "agreedToSms":"true",  "agreedToEmail":"true",  "agreedToMyBring":"true", "aggreedMarketingActivities":"true" ,  "customers": [ {"customerMasterNumber": "10008151176", "sourceSystem": "","possibleCustomerNumbers": ["1111",  "123334"], "roles": ["OM_SUPPLIER", "BASIC"]}, {"customerMasterNumber": "10005568742", "sourceSystem": "","possibleCustomerNumbers": ["1111",  "123334"], "roles": ["OM_SUPPLIER", "BASIC"]}]}';

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/ContactIntegrationtoMyBring/';
    req.httpMethod = 'PATCH';
    req.requestBody = Blob.valueof(JSONMsg);

    RestContext.request = req;
    RestContext.response= res;
    
     crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
    environment_settings__c envMobCode = New environment_settings__c(name='MobileCountryCodes',
                                                         value__c='+47=NO');
    insert envMobCode;
    
    environment_settings__c envLang = New environment_settings__c(name='Preferred_Language',
                                                         value__c='Danish=DA,English=EN,Finnish=FI,Norwegian=NO,Swedish=SV,Norwegian=NN,Norwegian=NB');
    insert envLang;
       
       //create relation level account
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partyLevelacnt.id;
       relationLevelacnt1.crm_customer_number__c = '10008151176';
       insert  relationLevelacnt1;
    
       Account relationLevelacnt2= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt2.parentId=partyLevelacnt.id;
       relationLevelacnt2.crm_customer_number__c = '10005568742';
       insert  relationLevelacnt2;   
       
       Contact con = New Contact(firstname='supriya', lastname='goel',
                                  email='supriya1.goel@capgemini.com',AccountId=partyLevelacnt.Id,
                                  my_bring_userId__c='0031X000003fADTQ11',crm_contact_type__c='Sales');
      insert con;
      
       String CSRectypeId = [Select Id from recordType where sObjectType = 'Contact' and developerName like 'Customer_Service'].Id;
       Contact con1 = New Contact(firstname='supriya', lastname='goel',
                                  email='supriya1.goel@capgemini.com',AccountId=relationLevelacnt1.Id,
                                  recordTypeId = CSRectypeId, crm_contact_type__c = 'Customer Service');
    insert con1;
    
    Test.startTest();
   // crm_ContactIntegrationtoMyBring  rep= new crm_ContactIntegrationtoMyBring();
    String conId=crm_ContactIntegrationtoMyBring.processContact();
      req.requestBody = Blob.valueof(JSONMsg1);
      RestContext.request = req;
    RestContext.response= res;
     String conId1=crm_ContactIntegrationtoMyBring.processContact();
    Test.stopTest();
   
    }
    
    ///////////
    @isTest
    static void testDeclinedMarketingActivities(){
		String JSONMsg ='{"workingArea":"Logistics","userLanguage":"English","userEmail":"supriya.goel@capgemini.com","salesforceStatus":"Inactive", "phoneNumber":"11111","mybringUserId":"0031X000003fADTQA2",  "mybringStatus":"inactive", "mobileNumber":"122233", "mobileCountryCode":"+47", "marketingActivitiesLastUpdate":"2019-01-22 08:34:05",  "lastUpdatedTime":"2019-01-22 08:34:05","lastLoginDateTime":"","createdDateTime":"2019-01-22 08:34:05", "lastName":"goel",  "firstName":"supriya",  "declinedMarketingActivities":"true", "agreedToSms":"false",  "agreedToEmail":"false", "agreedToMyBring":"false", "aggreedMarketingActivities":"false" ,  "customers": [ {"customerMasterNumber": "10008151176", "sourceSystem": "","possibleCustomerNumbers": ["1111",  "123334"], "roles": ["OM_SUPPLIER", "BASIC"]},{"customerMasterNumber": "1045876254", "sourceSystem": "","possibleCustomerNumbers": ["1111",  "123334"], "roles": ["OM_SUPPLIER", "BASIC"]}]}';

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/ContactIntegrationtoMyBring/';
    req.httpMethod = 'PATCH';
    req.requestBody = Blob.valueof(JSONMsg);

    RestContext.request = req;
    RestContext.response= res;
    
     crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
    environment_settings__c envMobCode = New environment_settings__c(name='MobileCountryCodes',
                                                         value__c='+47=NO, +1=US');
    insert envMobCode;
    
    environment_settings__c envLang = New environment_settings__c(name='Preferred_Language',
                                                         value__c='Danish=DA,English=EN,Finnish=FI,Norwegian=NO,Swedish=SV,Norwegian=NN,Norwegian=NB');
    insert envLang;
       
       //create relation level account
       Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt.parentId=partyLevelacnt.id;
       relationLevelacnt.crm_customer_number__c = '10008151176';
       insert  relationLevelacnt;
       
       Contact con = New Contact(firstname='supriya', lastname='goel',
                                  email='supriya.goel@capgemini.com',AccountId=partyLevelacnt.Id,
                                  my_bring_userId__c='0031X000003fADTQ11',crm_contact_type__c='Sales');
    insert con;
        
        String CSRectypeId = [Select Id from recordType where sObjectType = 'Contact' and developerName like 'Customer_Service'].Id;
       Contact con1 = New Contact(firstname='supriya', lastname='goel',
                                  email='supriya.goel@capgemini.com',AccountId=relationLevelacnt.Id,
                                  recordTypeId = CSRectypeId, crm_contact_type__c = 'Customer Service');
    insert con1;
    
    Test.startTest();
   // crm_ContactIntegrationtoMyBring  rep= new crm_ContactIntegrationtoMyBring();
    String conId=crm_ContactIntegrationtoMyBring.processContact();
      req.requestBody = Blob.valueof(JSONMsg);
      RestContext.request = req;
    RestContext.response= res;
     String conId1=crm_ContactIntegrationtoMyBring.processContact();
    Test.stopTest();


        
    }
    
    
    //////////
    
  public static TestMethod void Test_insertOrUpdateLogResult_insertsuccess()
  {
      crm_TestDataFactory.CreateCustomSetting();
      Account test_acct = crm_TestDataFactory.createPartylevelAccount();
      insert test_acct;
      Contact test_cont = crm_TestDataFactory.createContact();
      test_cont.crm_myBring_last_login__c = datetime.now();
      test_cont.My_Bring_Userid__c = '3c5cee70-668b-41ec-bf2d-f1614e51b706';
      test_cont.crm_myBring_user__c = [Select id from user where alias = 'aadmi'][0].id;
      
      Test.startTest();
      crm_ContactIntegrationtoMyBring.insertOrUpdateLogResult ('insert', new list<contact> {test_cont},'Test_namecheck');
      List <ContactLogCreation__c> clc = [select id,My_Bring_Userid__c from ContactLogCreation__c where My_Bring_Userid__c = '3c5cee70-668b-41ec-bf2d-f1614e51b706' ];
      System.assertEquals(1, clc.size());
  	  Test.stopTest();
  }
     public static TestMethod void Test_insertOrUpdateLogResult_insertfail()
  {
      crm_TestDataFactory.CreateCustomSetting();
      Account test_acct = crm_TestDataFactory.createPartylevelAccount();
      insert test_acct;
      Contact test_cont = crm_TestDataFactory.createContact();
      test_cont.crm_myBring_last_login__c = datetime.now();
      test_cont.LastName = null;
      test_cont.My_Bring_Userid__c = '3c5cee70-668b-41ec-bf2d-f1614e51b706';
      test_cont.crm_myBring_user__c = [Select id from user where alias = 'aadmi'][0].id;
      
      Test.startTest();
      crm_ContactIntegrationtoMyBring.insertOrUpdateLogResult ('insert', new list<contact> {test_cont},'Test_namecheck');
      List <ContactLogCreation__c> clc = [select id,My_Bring_Userid__c from ContactLogCreation__c];
      System.assertEquals('3c5cee70-668b-41ec-bf2d-f1614e51b706', clc[0].My_Bring_Userid__c);
  	  Test.stopTest();
  }
    public static TestMethod void Test_insertOrUpdateLogResult_updatesuccess()
  {
      crm_TestDataFactory.CreateCustomSetting();
      Account test_acct = crm_TestDataFactory.createPartylevelAccount();
      insert test_acct;
      //Account TestAcc = New Account(Name='Test Account');
      //insert TestAcc;
      Contact test_cont = crm_TestDataFactory.createContact();
      test_cont.AccountId = test_acct.Id;
      test_cont.crm_myBring_last_login__c = datetime.now();
      test_cont.My_Bring_Userid__c = '3c5cee70-668b-41ec-bf2d-f1614e51b706';
      test_cont.crm_myBring_user__c = [Select id from user where alias = 'aadmi'][0].id;
      insert test_cont;
      
      Test.startTest();
      crm_ContactIntegrationtoMyBring.insertOrUpdateLogResult ('update', new list<contact> {test_cont},'Test_namecheck');
      List <ContactLogCreation__c> clc = [select id,My_Bring_Userid__c from ContactLogCreation__c where My_Bring_Userid__c = '3c5cee70-668b-41ec-bf2d-f1614e51b706' ];
      System.assertEquals(1, clc.size());
  	  Test.stopTest();
  }
   
}