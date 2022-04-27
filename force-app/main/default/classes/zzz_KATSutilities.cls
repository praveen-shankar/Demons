@isTest
private class zzz_KATSutilities {
    
    static testMethod void testWashEmailAddress() {
        String testEmail = 'test@test.com';
        system.assertEquals(testEmail,KATSutilities.washEmailAddress(testEmail));
        system.assertEquals(testEmail,KATSutilities.washEmailAddress('mailto:'+testEmail));
        system.assertEquals(testEmail,KATSutilities.washEmailAddress(','+testEmail));
        system.assertEquals(testEmail,KATSutilities.washEmailAddress('('+testEmail));
        system.assertEquals(testEmail,KATSutilities.washEmailAddress(')'+testEmail));
        system.assertEquals(testEmail,KATSutilities.washEmailAddress('['+testEmail));
        system.assertEquals(testEmail,KATSutilities.washEmailAddress(']'+testEmail));
        system.assertEquals(testEmail,KATSutilities.washEmailAddress(':'+testEmail));
        system.assertEquals(testEmail,KATSutilities.washEmailAddress('"'+testEmail));
        system.assertEquals(testEmail,KATSutilities.washEmailAddress('\''+testEmail));
        system.assertEquals(testEmail,KATSutilities.washEmailAddress('*'+testEmail));
        system.assertEquals(testEmail,KATSutilities.washEmailAddress('test@te st.com'));
        system.assertEquals(null,KATSutilities.washEmailAddress('æøå'+testEmail));
        system.assertEquals(null,KATSutilities.washEmailAddress(''));
    }
    
    static testMethod void testWashEmailAddress_2() {
        String testEmail = 'mailto:test@test.com';
    }
    
    static testMethod void testGetRecordTypeName() {
        Id recordId = [select id, Name, IsPersonType, developerName, SobjectType from recordtype where isActive=true limit 1].id;
        String s = KATSutilities.getRecordTypeName(recordId);
    }
    static testMethod void testGetRecordTypeList(){
         list<RecordType> recordTypeList=new List<RecordType>();
        
         recordTypeList=KATSutilities.getRecordTypeList();
         System.assertNotEquals(recordTypeList, null);
         System.assert((recordTypeList.size()>0));
         
    }
    
    static testMethod void systemUpsertTest() {
        Account a = new Account(name='TEST');
        KATSutilities.upsertAsSystem(a);
        Contact c = new Contact(lastName='TEST');
        KATSutilities.upsertAsSystem(c);
        list<Account> accounts = new list<Account>();
        list<Contact> contacts = new list<Contact>();
        accounts.add(new Account(name='TEST'));
        contacts.add(new Contact(lastName='TEST'));
        KATSutilities.upsertAsSystem(accounts);
        KATSutilities.upsertAsSystem(contacts);
    }
    
    static testMethod void isValidEmailTest() {
        system.assertEquals(true,KATSutilities.isValidEmail('test@example.org'));
        system.assertEquals(true,KATSutilities.isValidEmail('test1@exam1ple.org'));
        system.assertEquals(true,KATSutilities.isValidEmail('test_test@example.org'));
        system.assertEquals(true,KATSutilities.isValidEmail('test.test@exa.mple.org'));
        system.assertEquals(false,KATSutilities.isValidEmail('test@exa mple.org'));
        system.assertEquals(false,KATSutilities.isValidEmail('æøå@example.org'));
        system.assertEquals(false,KATSutilities.isValidEmail('\'test@example.org'));
        system.assertEquals(false,KATSutilities.isValidEmail('<sk@example.org'));

    } 
    
    static testMethod void truncate() {
        system.assertEquals('1234', KATSutilities.truncate('1234', 4));
        system.assertEquals('1234', KATSutilities.truncate('1234', 100));
        system.assertEquals('123', KATSutilities.truncate('1234', 3));
        system.assertEquals('1', KATSutilities.truncate('1234', 1));
        system.assertEquals('aaaa', KATSutilities.truncate('aaaaa', 4, false));
        system.assertEquals('aaaa', KATSutilities.truncate('aaaaa', 4, true));      
        system.assertEquals('åååå', KATSutilities.truncate('åååå', 4, false));      
        system.assertEquals('ååå', KATSutilities.truncate('ååå', 40, false));       
        system.assertEquals('ååå', KATSutilities.truncate('ååå', 40, true));        
        system.assertEquals('åå', KATSutilities.truncate('åååå', 4, true));
        system.assertEquals('a', KATSutilities.truncate('aå', 1, true));
        system.assertEquals('', KATSutilities.truncate('åååå', 1, true));
        system.assertEquals('a', KATSutilities.truncate('aå', 2, true));
        system.assertEquals('Long incl non-æøå-latin characters.', KATSutilities.truncate('Long incl non-æøå-latin characters. Long incl non-æøå-latin characters', 38, true));
    }
        
    static testMethod void getRemoveLeadingZeros() {
        system.assertEquals('1234', KATSutilities.removeLeadingZeros('00001234'));
        system.assertEquals('1234', KATSutilities.removeLeadingZeros('01234'));
        system.assertEquals('1234', KATSutilities.removeLeadingZeros('1234'));
        system.assertEquals('12340000000000', KATSutilities.removeLeadingZeros('12340000000000'));
        system.assertEquals('12340000000000', KATSutilities.removeLeadingZeros('00012340000000000'));
        system.assertEquals('1234', KATSutilities.removeLeadingZeros('0000000000000000000000000000001234'));
        system.assertEquals('10203040', KATSutilities.removeLeadingZeros('000010203040'));
        system.assertEquals('100001234', KATSutilities.removeLeadingZeros('100001234'));
        system.assertEquals('A0001234', KATSutilities.removeLeadingZeros('A0001234'));
        system.assertEquals(null, KATSutilities.removeLeadingZeros(null));
    }
        
    static testMethod void getNames() { 
        system.assertEquals('Jens Peter', KATSutilities.getFirstName('Jens Peter Jensen'));
        system.assertEquals('Jens', KATSutilities.getFirstName('Jens Jensen'));
        system.assertEquals('Jens', KATSutilities.getFirstName(' Jens  Jensen'));
        system.assertEquals('', KATSutilities.getFirstName('Jens'));
        system.assertEquals('', KATSutilities.getFirstName(''));
        system.assertEquals('', KATSutilities.getFirstName(null));
        system.assertEquals('Jensen', KATSutilities.getLastName(' Jens  Jensen'));
        system.assertEquals('Jensen', KATSutilities.getLastName(' Jens Peter Jensen'));
        system.assertEquals('Jensen', KATSutilities.getLastName('Jens Peter Jensen  '));
        system.assertEquals('Jensen', KATSutilities.getLastName('Jensen'));
        system.assertEquals('', KATSutilities.getLastName(''));
        system.assertEquals('', KATSutilities.getLastName(null));
    }
    
    static testMethod void copyResolutionTimeMilestoneToCase() { 
        
        Account keyAccount = new Account(customer_segment__c='A', name='Segment A account');
        insert keyAccount;
        
        list<case> cases = new list<case>();
        list<ID> caseIds = new list<ID>();
        case caseWithNewEntitlement = new Case( account=keyAccount );
        case caseWithEntitlementRemoved = new Case( account=keyAccount );
        case caseWithEntitlementUpdated = new Case( account=keyAccount );

        for(integer i=0; i<200; i++) {
            cases.add( new case( subject='test'+i, account=keyAccount ) );
        }
        insert cases;
        for(case c:cases) { caseIds.add(c.id); }
        caseIds.add(caseWithNewEntitlement.id);
        caseIds.add(caseWithEntitlementRemoved.id);
        caseIds.add(caseWithEntitlementUpdated.id);
        
        
        test.startTest();
        upsert KATSutilities.copyResolutionMilestoneToCase(caseIds);
        test.stopTest();
        
    }
    
    static Case createCase(String origin) {
        Case c = new Case(Origin = origin);
        //insert c;
        

        return c;
    }
    
    private static Datetime getEndDateTime() {
        List<BusinessHours> bh = [select Id, WednesdayEndTime, ThursdayStartTime from BusinessHours where Name = 'Privat'];
        Date endDate = Date.newInstance(2011,12,14);
        Time endTime = bh.get(0).WednesdayEndTime;

        Datetime endDatetime = Datetime.newInstance(endDate, endTime);
        return endDatetime;
    }
    
    private static Datetime getNextDateTime() {
        List<BusinessHours> bh = [select Id, WednesdayEndTime, ThursdayStartTime from BusinessHours where Name = 'Privat'];
        Date nextDate = Date.newInstance(2011,12,15);
        Time nextTime = bh.get(0).ThursdayStartTime;

        Datetime nextDateTime = Datetime.newInstance(nextDate, nextTime);
        return nextDateTime;
    }

    static testMethod void testAddHoursToDateBusinessHours() { 
        List<BusinessHours> bhours = [select Id from BusinessHours where name='Privat'];
        integer minutes = 60;
        Datetime dateBefore = Datetime.newInstance(2011,12,08, 18,0,0);
        
        Datetime actual = KATSutilities.addMinutesToDateWithRespectToBusinessHours(minutes, dateBefore, bhours.get(0));
        
        Datetime dateExpected = Datetime.newInstance(2011,12,09, 9,0,0);
        //System.assertEquals(dateExpected, actual);
    }
    static TestMethod void testKATSutilitues()
    {
        code_event__c c1=new code_event__c(name='test');
        insert c1;
        KATSutilities.getEventFromId(c1.id);
        User u = crm_TestDataFactory.createUser();
        //u.crm_user_type__c='Sales';
        insert u;
        KATSutilities.getFullUser(u.id);
        
        string s='test';
        KATSutilities.toUpperCase(s);
        string rectype='Agreement';
        KATSutilities.getRecordTypeByName(rectype);
        
        Case test1 = new Case();
        test1.subject = 'Test 1';
        test1.origin = 'Telefon';
        test1.SuppliedEmail='a@b.com';
        Database.insert(test1);
        KATSutilities.performExtendedSenderSearch(test1);
        
        set<Id> cid = new set<id>();
    	cid.add(test1.Id);
        KATSutilities.setCommunityassignmentrule(cid);
	    
        
        list<Case> clist = new list<Case>();
        clist.add(test1);
        KATSutilities.performExtendedSenderSearch(clist);
        
        string ph='123456';
        KATSutilities.getPostalUnitbyPhone(ph);
        

    }
    
    static testMethod void getBusinessHours() {
        List<Profile> profiles = [select Id from Profile where name='System Administrator'];
        DateTime timestamp = dateTime.now();
        String appendTimeStamp = timestamp.format('MMddyyyyhhmmss','America/New_York');
        User testUser = new User(
            alias='t'+ appendTimeStamp.substring(0,4),
            email='mahoel'+appendTimeStamp+'@posten.capgemini.com.test',
            emailencodingkey='UTF-8', 
            lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = profiles.get(0).Id,
            timezonesidkey='America/Los_Angeles',           
            username='mahoel'+appendTimeStamp+'@posten.capgemini.com.test'
            );
        
        insert testUser;
        
        Group g = new Group(Type = 'Queue', Name='Test queue from KatsTestUtilities');
        insert g;
        // Associate the Group (Queue) with Case and QueueDetails__c to allow those types to be owned by the Group (Queue)
        System.runAs(testUser) {
            List<QueueSObject> qList = new List<QueueSObject>();
            qList.add(new QueueSObject(SobjectType='Case', QueueId=g.Id));
            qList.add(new QueueSObject(SobjectType='QueueDetails__c', QueueId=g.Id));
            insert qList;
        }
        
        
        KATSutilities.getBusinessHours(createCaseOnQueue(g));
    }
    
    static Case createCaseOnQueue(Group queue) {
        Case c = new Case(Assigned_to_CTI__c = false, Assigned_to_CTI_Agent__c = true, OwnerId = queue.Id);
        insert c;
        return c;
    }
    
    static Case createCaseWithOrigin(Group queue, String origin) {
        Case c = new Case(OwnerId = queue.Id, Origin=origin);
        insert c;
        return c;
    }
    
    static testMethod void addMessageTest1() {
        Test.setCurrentPage(new PageReference('/apex/mainSearch')); 
        
        Test.startTest();
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Test Fatal Message'));
        Test.stopTest();
        
        System.assertEquals('Test Fatal Message', ApexPages.getMessages().get(0).getDetail());
    }
    
    static testMethod void addMessageTest2() {
        Test.setCurrentPage(new PageReference('/apex/mainSearch')); 
        ApexPages.message m = new ApexPages.Message(ApexPages.Severity.INFO, 'Test Info Message');
        ApexPages.message m2 = new ApexPages.Message(ApexPages.Severity.FATAL, 'Test Fatal Message');
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u1 = new User(Alias = 'newUser1', Email='test@test.com', 
         EmailEncodingKey='UTF-8', LastName='addMessageTest2', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p1.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='addMessageTest2@test.com');
        
        Test.startTest();
            System.runAs(u1) {
                KATSutilities.addMessage(m);
                KATSutilities.addMessage(m2);
                
            }
        Test.stopTest();
        
        System.assertEquals('Test Info Message', ApexPages.getMessages().get(0).getDetail()); 
        System.assertEquals('Test Fatal Message', ApexPages.getMessages().get(1).getDetail());
    }
    
    static testMethod void addMessageTest3() {
        Filter_info_message__c fim = new Filter_info_message__c();
            fim.name = 'Default';
            fim.Display_User_Message__c = true;
        upsert fim;
        
        Test.setCurrentPage(new PageReference('/apex/mainSearch')); 
        ApexPages.message m = new ApexPages.Message(ApexPages.Severity.INFO, 'Test Info Message');
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name='KATS Kundekonsulent']; 
        User u2 = new User(Alias = 'newUser2', Email='test@test.com', 
         EmailEncodingKey='UTF-8', LastName='addMessageTest3', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p2.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='addMessageTest3@test.com');
        
        Test.startTest();
            System.runAs(u2) {
                KATSutilities.addMessage(m);
            }
        Test.stopTest();
        
        System.assertEquals(Filter_info_message__c.getInstance('Default').Display_User_Message__c, ApexPages.hasMessages());
    }
    /* validateShipmentID */
     static testMethod void testValidateShipmentID(){
        
        System.assertEquals(true, KATSutilities.validateShipmentID('123456789'));
        System.assertEquals(false, KATSutilities.validateShipmentID('12345678'));
        System.assertEquals(true, KATSutilities.validateShipmentID('12345678901234567890123456789012345')); // 35 characters
        System.assertEquals(false, KATSutilities.validateShipmentID('123456789012345678901234567890123456')); // 36 characters
        System.assertEquals(true, KATSutilities.validateShipmentID('no0000000000CD'));
        System.assertEquals(false, KATSutilities.validateShipmentID('no-0000000000CD'));
        System.assertEquals(false, KATSutilities.validateShipmentID('SE00112233*'));
        System.assertEquals(false, KATSutilities.validateShipmentID(null));
    
    }
    static testMethod void testremoveAccountFromCase(){
        GlobalAddressListName__c gal=KatsTestUtilities.getTestGlobalAddressListName();  
        Account a=new account(Name=gal.Name);
        Case c=new Case(AccountId=a.id);
        List<Case> newCaseList = new List<Case>(); newCaseList.add(c);
        KATSutilities.removeAccountFromCase(newCaseList);
        System.assertEquals(c.accountId, null);
    }
}