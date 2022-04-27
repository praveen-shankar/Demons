/*
    NB: RUNNING THESE OUTSIDE OF TEST WILL RESULT IN THE CREATION OF OBJECTS!!!
*/
//// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
public with sharing class KatsTestUtilities {
  private static Service_Product__c testProduct;
  private static User testKundekonsulentUser;
  private static User testAdminUser;
  private static User testLightuser;
  private static BusinessHours bh;
  private static Group testGroup;
  private static Group hiPriG;
  private static Group lowPriG;
  private static list<QueueDetails__c> qdList;
  private static CDS_Service__c cdsService;
  private static ErrorLogging__c testErrorLogging;
  private static GlobalAddressListName__c testGlobalAddressListName;
  private static Organization_environment_settings__c orgSetting;
  private static postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters mockBusinessAccount;
  private static postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters mockPrivateAccount;
  private static Account testBusinessAccount;
  private static Account testPrivateAccount;
  private static Account testGlobalAddressAccount;
  private static Contact testContact;
  private static LogSettings__c logSetting;
  //private static Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
  
  static {
    if(testAdminUser == null) {createTestAdminUser();}
    System.runAs(testAdminUser) {
      if(testProduct==null){createTestProduct();}
      if(testKundekonsulentUser == null) {createTestKundekonsulentUser();}
      if(bh == null) {initializeBusinessHours();}
      if(testGroup == null) {createTestGroup();}
      if(hiPriG == null) {createLowPriorityQueue();}
      if(hiPriG == null) {createHighPriorityQueue();}
      if(qdList == null) {createQueueDetails();}
      if(cdsService == null) {createCDSService();}
      if(testErrorLogging == null) {createTestErrorLogging();}
      if(orgSetting == null) {createTestOrganizationEnvironmentSettings();}
      if(mockBusinessAccount == null) {mockBusinessAccount = mock_KatsSakgetcustomer.getBusinessAccount();}
      if(mockPrivateAccount == null) {mockPrivateAccount = mock_KatsSakgetcustomer.getPrivateAccount();}
      if(testBusinessAccount == null) {createTestBusinessAccount();}
      if(testPrivateAccount == null) {createTestPrivateAccount();}
      if(testGlobalAddressAccount == null) {createTestGlobalAddressAccount();}
      if(testContact == null) {createTestContact();}
      if(testGlobalAddressListName == null) {createTestGlobalAddressListName();}
      if(logSetting==null) { createTestLogSettings();}
    }
  }
  
  public static Service_Product__c getTestProduct(){
    return testProduct;
  }
  
  public static User getTestKundekonsulentUser() {
    return testKundekonsulentUser;
  }
  
  public static User getTestAdminUser() {
    return testAdminUser;
  }
  
  public static User getTestLightuser() {
    return testLightuser;
  }
  
  public static User getAdminAdmin() {
    return [SELECT id, username, profile.Name FROM User WHERE Id = '00520000001C2TK' LIMIT 1];
  }
  
  public static Group getTestQueue() {
    return testGroup;
  }
  
  public static Group getLowPriTestQueue() {
    return lowPriG;
  }
  
  public static Group getHiPriTestQueue() {
    return hiPriG;
  }
  
  public static Account getTestBusinessAccount() {
    return testBusinessAccount;
  }
  
  public static Account getTestPrivateAccount() {
    return testPrivateAccount;
  }
  
  public static Account getTestGlobalAddressAccount() {
    return testGlobalAddressAccount;
  }
  
  public static Contact getTestContact() {
    return testContact;
  }
  
  public static list<QueueDetails__c> getQueueDetails() {
    return qdList;
  }
  
  public static CDS_Service__c getCDSService() {
    return cdsService;
  }
  
  //private static void createQueueDetails() {
  
  public static GlobalAddressListName__c getTestGlobalAddressListName() {
    return testGlobalAddressListName;
  }
  public static ErrorLogging__c getTestErrorLogging(){
    return testErrorLogging;
  }
  
  public static Organization_environment_settings__c getTestOrganizationEnvironmentSettings() {
    return orgSetting;
  }
  public static LogSettings__c getLogSettings(){
    return logSetting;
  }
  
  public static list<QueueDetails__c> createQueueDetails() {
    System.runAs(testAdminUser) {
      qdList = new list<QueueDetails__c>();
        qdList.add(new QueueDetails__c(queue_name__c=testGroup.name + ' ' + System.now(), OwnerId=testGroup.Id, Business_Hours__c = bh.Id, queue_deadline__c = 360)); // bh.Id
        qdList.add(new QueueDetails__c(queue_name__c=hiPriG.name + ' ' + System.now(), OwnerId=hiPriG.Id, Business_Hours__c = bh.Id, queue_deadline__c = 360)); // bh.Id
        qdList.add(new QueueDetails__c(queue_name__c=lowPriG.name + ' ' + System.now(), OwnerId=lowPriG.Id, Business_Hours__c = bh.Id, queue_deadline__c = 480)); // bh.Id
      insert qdList;
      
      for(QueueDetails__c qd : qdList) {
        qd.fetch_from_cti__c = true;
      }
      
      update qdList;
    }
    return qdList;
    }
    
    private static void createTestProduct(){
      Service_Product__c p=new Service_Product__c(Name='MyTestProduct');
      insert p;
    }
    private static void initializeBusinessHours() {
    List<BusinessHours> bhours = [select Id from BusinessHours where name='Privat'];
    bh = bhours.get(0);
  }
  
  private static void createTestKundekonsulentUser() {
    System.runAs(testAdminUser) {
      List<Profile> profiles = [select Id from Profile where name='System Administrator'];
      DateTime timestamp = dateTime.now();
      
      String appendTimeStamp = timestamp.format('MMddyyyyhhmmss','America/New_York');
      
      testKundekonsulentUser = new User(
        alias='t'+ appendTimeStamp.substring(0,4),
        email='testUser'+appendTimeStamp+'@test.com',
        emailencodingkey='UTF-8', 
            lastname='User',
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = profiles.get(0).Id,
          timezonesidkey='America/Los_Angeles',      
            username='testUser'+appendTimeStamp+'@posten.com.test'
        );
      
      insert testKundekonsulentUser;
    }
  }
  
  private static void createTestAdminUser() {
    List<Profile> profiles = [select Id from Profile where name='System Administrator'];
    DateTime timestamp = dateTime.now();
    String appendTimeStamp = timestamp.format('MMddyyyyhhmmss','America/New_York');
    testAdminUser = new User(
      alias='t'+ appendTimeStamp.substring(0,4),
      email='testAdminUser'+appendTimeStamp+'@test.com',
      emailencodingkey='UTF-8', 
          lastname='Admin',
          languagelocalekey='en_US',
          localesidkey='en_US', 
          profileid = profiles.get(0).Id,
        timezonesidkey='America/Los_Angeles',      
          username='testAdminUser'+appendTimeStamp+'@posten.com.test'
      );
    
    insert testAdminUser;
  }
  
  private static void createTestLightuser() {
    List<Profile> profiles = [select Id from Profile where name='Posten Light Bruker Profile'];
    DateTime timestamp = dateTime.now();
    String appendTimeStamp = timestamp.format('MMddyyyyhhmmss','America/New_York');
    testLightuser = new User(
      alias='t'+ appendTimeStamp.substring(0,4),
      email='testLightuser'+appendTimeStamp+'@test.com',
      emailencodingkey='UTF-8', 
          lastname='Light',
          languagelocalekey='en_US',
          localesidkey='en_US', 
          profileid = profiles.get(0).Id,
        timezonesidkey='America/Los_Angeles',      
          username='lightuser'+appendTimeStamp+'@posten.com.test'
      );
    
    insert testLightuser;
  }
  
  public static void createTestGroup() {
    testGroup = new Group(Type = 'Queue', Name='Test queue from KatsTestUtilities');
    insert testGroup;
    
    // Associate the Group (Queue) with Case and QueueDetails__c to allow those types to be owned by the Group (Queue)
    List<QueueSObject> qList = new List<QueueSObject>();
    qList.add(new QueueSObject(SobjectType='Case', QueueId=testGroup.Id));
    qList.add(new QueueSObject(SobjectType='QueueDetails__c', QueueId=testGroup.Id));
    insert qList;
  }
  
  public static void createEconnectEnvironmentSettings() {
    list<environment_settings__c> oesList = new list<environment_settings__c>();
    
    oesList.add(new environment_settings__c(Name = 'eConnectCertificateName', Description__c = '', value__c = 'Posten_KATS_to_eConnect_QA'));
    oesList.add(new environment_settings__c(Name = 'eConnectEndpointURI', Description__c = '', value__c = 'https://qa.econnect.postennorge.no/'));
    oesList.add(new environment_settings__c(Name = 'OEBSorderFallbackURL', Description__c = '', value__c = 'https://qa02.posten.no/OA_HTML/RF.jsp?function_id=25582&resp_id=50297&resp_appl_id=20003&security_group_id=0&lang_code=N '));
    
    upsert oesList;
  }
  
  private static void createLowPriorityQueue() {
    lowPriG = new Group(Type = 'Queue', Name='Low Pri Test Queue');
    insert lowPriG;
    
    // Associate the Group (Queue) with Case and QueueDetails__c to allow those types to be owned by the Group (Queue)
    System.runAs(testAdminUser) {
      List<QueueSObject> qList = new List<QueueSObject>();
      qList.add(new QueueSObject(SobjectType='Case', QueueId=lowPriG.Id));
      qList.add(new QueueSObject(SobjectType='QueueDetails__c', QueueId=lowPriG.Id));
      insert qList;
    }
  }
  
  private static void createHighPriorityQueue() {
    hiPriG = new Group(Type = 'Queue', Name='High Pri Test Queue');
    insert hiPriG;
    
    // Associate the Group (Queue) with Case and QueueDetails__c to allow those types to be owned by the Group (Queue)
    System.runAs(testAdminUser) {
      List<QueueSObject> qList = new List<QueueSObject>();
      qList.add(new QueueSObject(SobjectType='Case', QueueId=hiPriG.Id));
      qList.add(new QueueSObject(SobjectType='QueueDetails__c', QueueId=hiPriG.Id));
      insert qList;
    }
  }
  
  private static void createTestBusinessAccount() {
    testBusinessAccount = new Account();
          testBusinessAccount.Name = mockBusinessAccount.OrganizationParty.LegalName;
          testBusinessAccount.crm_customer_number__c = mockBusinessAccount.OrganizationParty.PartyNumber;
      testBusinessAccount.Orga__c = mockBusinessAccount.OrganizationParty.CustomerNumber;
      testBusinessAccount.Phone = mockBusinessAccount.OrganizationParty.Communications.Communication.get(0).PhoneNumber;
          testBusinessAccount.BillingStreet = mockBusinessAccount.OrganizationParty.Addresses.Address.get(0).Street;
      testBusinessAccount.BillingCity = mockBusinessAccount.OrganizationParty.Addresses.Address.get(0).City;
      testBusinessAccount.BillingPostalCode = mockBusinessAccount.OrganizationParty.Addresses.Address.get(0).PostalCode;
      testBusinessAccount.BillingCountry = mockBusinessAccount.OrganizationParty.Addresses.Address.get(0).Country;
      testBusinessAccount.ShippingStreet = mockBusinessAccount.OrganizationParty.Addresses.Address.get(1).Street;
      testBusinessAccount.ShippingCity = mockBusinessAccount.OrganizationParty.Addresses.Address.get(1).City;
      testBusinessAccount.ShippingPostalCode = mockBusinessAccount.OrganizationParty.Addresses.Address.get(1).PostalCode;
      testBusinessAccount.ShippingCountry = mockBusinessAccount.OrganizationParty.Addresses.Address.get(1).Country;
    insert testBusinessAccount;
  }
  
  private static void createTestPrivateAccount() {
    testPrivateAccount = new Account();
          testPrivateAccount.FirstName = mockPrivateAccount.PersonParty.Names.FirstName;
          testPrivateAccount.LastName = mockPrivateAccount.PersonParty.Names.LastName;
          testPrivateAccount.crm_customer_number__c = mockPrivateAccount.PersonParty.PartyNumber;
      testPrivateAccount.BillingStreet = mockPrivateAccount.PersonParty.Addresses.Address.get(0).Street;
      testPrivateAccount.BillingCity = mockPrivateAccount.PersonParty.Addresses.Address.get(0).City;
      testPrivateAccount.BillingPostalCode = mockPrivateAccount.PersonParty.Addresses.Address.get(0).PostalCode;
      testPrivateAccount.BillingCountry = mockPrivateAccount.PersonParty.Addresses.Address.get(0).Country;
      testPrivateAccount.ShippingStreet = mockPrivateAccount.PersonParty.Addresses.Address.get(1).Street;
      testPrivateAccount.ShippingCity = mockPrivateAccount.PersonParty.Addresses.Address.get(1).City;
      testPrivateAccount.ShippingPostalCode = mockPrivateAccount.PersonParty.Addresses.Address.get(1).PostalCode;
      testPrivateAccount.ShippingCountry = mockPrivateAccount.PersonParty.Addresses.Address.get(1).Country;
    insert testPrivateAccount;
  }
  
  private static void createTestGlobalAddressAccount() {
    testGlobalAddressAccount = new Account();
      testGlobalAddressAccount.Name = 'Posten Global Adresseliste';
    insert testGlobalAddressAccount;
  }
  
  private static void createTestContact() {
    RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'Customer_Service' And sObjectType = 'Contact' Limit 1];
    Id csRecordTypeId = null;
    If(rtypes.size() > 0) {
    csRecordTypeId  = rtypes.get(0).Id;
    }
    System.debug('Recordtype id: ' + csRecordTypeId);


      testContact = new Contact();
      testContact.FirstName = mockBusinessAccount.OrganizationParty.Contacts.Contact.get(0).ContactName.FirstName;
      testContact.LastName = mockBusinessAccount.OrganizationParty.Contacts.Contact.get(0).ContactName.LastName;
      testContact.Caesar_Contact_Id__c = mockBusinessAccount.OrganizationParty.Contacts.Contact.get(0).ContactID;
      testContact.department = mockBusinessAccount.OrganizationParty.Contacts.Contact.get(0).Department;
      testContact.title = mockBusinessAccount.OrganizationParty.Contacts.Contact.get(0).Title;
      testContact.phone = mockBusinessAccount.OrganizationParty.Contacts.Contact.get(0).Communication.PhoneNumber;
      testContact.MobilePhone = mockBusinessAccount.OrganizationParty.Contacts.Contact.get(0).Communication.MobileNumber;
      testContact.email = mockBusinessAccount.OrganizationParty.Contacts.Contact.get(0).Communication.EMailAddress;
      testContact.Status__c = 'Aktiv';
      testContact.AccountId = testBusinessAccount.id;
      testContact.recordtypeid = csRecordTypeId; 
    upsert testContact;
  }
  
  private static void createCDSService() {
    cdsService = new CDS_Service__c(CDS_Service_Group_Name__c='Test_Service_Name');
    cdsService.Name = 'Test Service Name';
    Code_Event__c ce = new Code_Event__c(Name='Test Category');
    cdsService.Code_Event__c =ce.id ;
    cdsService.Case_default_division__c = 'Test Division';
    cdsService.Case_default_type__c = 'Test Type';
    cdsService.QueueDetails__c = qdlist.get(0).Id;
    upsert cdsService;
  }
  
  private static void createTestGlobalAddressListName() {
    testGlobalAddressListName = new GlobalAddressListName__c();
    testGlobalAddressListName.Name = 'Default';
    testGlobalAddressListName.name__c = '' + KatsTestUtilities.getTestGlobalAddressAccount().id;
    
    try{
      upsert testGlobalAddressListName;
    } catch(system.DmlException e){
      system.debug('GlobalAddressListName__c Default already exsists');
    }
  }
  private static void createTestErrorLogging(){
    testErrorLogging=new ErrorLogging__c();
    testErrorLogging.Name='Default';
    testErrorLogging.on__c=true;
    
    try {
      upsert testErrorLogging;
    } catch (system.Dmlexception dmlex){
      system.debug('ErrorLogging__c Default already exists');
    }
  }
  
  private static void createTestOrganizationEnvironmentSettings() {
    orgSetting = Organization_environment_settings__c.getInstance(UserInfo.getOrganizationId());
    
    if(orgSetting == null) {
      orgSetting = new Organization_environment_settings__c();
      orgSetting.Name = UserInfo.getOrganizationId();
    }
      orgSetting.eConnectCertificateName__c = 'test';
      orgSetting.eConnectEndpointURI__c = 'test';
      orgSetting.Environment_type__c = 'Sandbox';
      orgSetting.Sandbox_name__c = 'Sandbox';
      orgSetting.Storkunde__c = 1234;
      orgSetting.VIP__c = 4321;
      upsert orgSetting;    
  }
  
  private static void createTestLogSettings(){
    logSetting= LogSettings__c.getInstance('Default');
    if(logSetting==null){
      logSetting=new LogSettings__c();
      logSetting.Name='Default';
    }
    logSetting.Age__c=1;
    logSetting.Enabled__c=true;
    upsert logSetting;
  } 
}