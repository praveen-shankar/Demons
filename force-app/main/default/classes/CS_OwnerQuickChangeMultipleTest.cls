@isTest
private class CS_OwnerQuickChangeMultipleTest {
  static List<Case> clist;
  static CS_OwnerQuickChangeControllerMultiple  ctrl;
  static User testUser;// = KatsTestUtilities.getTestUser();

  static void init() {
    CS_OwnerQuickChangeMultipleTest.createTestUser();
     Account testAccount = new Account(Name = 'Test OEBS Account',
                                    crm_customer_number__c = '12345678');
        
        upsert testAccount;
         clist= new List<Case>();
   
     Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                OEBS_Order_Status__c = '');
              
    
    clist.add(testCase);
    insert clist;
    ctrl = new CS_OwnerQuickChangeControllerMultiple(new ApexPages.StandardSetController (clist));
  }

  private static void createTestUser() {
    List<Profile> profiles = [select Id from Profile where name='System Administrator'];
    DateTime timestamp = dateTime.now();
    String appendTimeStamp = timestamp.format('MMddyyyyhhmmss','America/New_York');
    testUser = new User(
      alias='t'+ appendTimeStamp.substring(0,4),
      email='test'+appendTimeStamp+'@posten.capgemini.com.test',
      emailencodingkey='UTF-8', 
          lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', 
          profileid = profiles.get(0).Id,
        timezonesidkey='America/Los_Angeles',      
          username='mahoel'+appendTimeStamp+'@posten.capgemini.com.test'
      );
    
    insert testUser;
  }

    static testMethod void testOwnerChange() {
      init();
      //testUser = KatsTestUtilities.getTestUser();
      Test.startTest();
        ctrl.ownerId = testUser.Id;
       // ctrl.changeOwner();
        Test.stopTest();
       
    }
}