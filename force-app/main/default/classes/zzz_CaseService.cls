@isTest
private class zzz_CaseService {
    static Group g;
    static User testUser;
    static {
        List<Profile> profileList = [select Id from Profile where name='System Administrator'];
        DateTime timestamp = dateTime.now();
        String appendTimeStamp = timestamp.format('MMddyyyyhhmmss','America/New_York');
        testUser = new User(
            alias='t'+ appendTimeStamp.substring(0,4),
            email='mahoel'+appendTimeStamp+'@posten.capgemini.com.test',
            emailencodingkey='UTF-8', 
            lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = profilelist.get(0).Id,
            timezonesidkey='America/Los_Angeles',           
            username='mahoel'+appendTimeStamp+'@posten.capgemini.com.test'
            );
        
        insert testUser;        
        list<environment_settings__c> environmentSettingList = new list<environment_settings__c>();
        String value  = URL.getSalesforceBaseUrl().toExternalForm() ;
            environmentSettingList.add(new environment_settings__c(Name = 'salesforce_hostname', Description__c = '', value__c = value));
            environmentSettingList.add(new environment_settings__c(Name = 'eConnectEndpointURI', Description__c = '', value__c = 'https://qa.econnect.postennorge.no/'));
            environmentSettingList.add(new environment_settings__c(Name = 'eConnectCertificateName', Description__c = '', value__c = 'Posten_KATS_to_eConnect_QA'));
        upsert environmentSettingList;
        
        g = new Group(Type='Queue', Name='Test queue for CaseService unit tests');
        insert g;
        System.runAs(testUser) {
            List<QueueSObject> qList = new List<QueueSObject>();
                qList.add(new QueueSObject(SobjectType='Case', QueueId=g.Id));
                qList.add(new QueueSObject(SobjectType='QueueDetails__c', QueueId=g.Id));
            insert qList;
        }
        
        Map<String,ID> profiles =new Map<String,ID>();
        List<Profile> ps = [select id, name from Profile where name = 
         'Standard User' or name = 'System Administrator'];
         
        for(Profile p : ps){
            profiles.put(p.name, p.id);
        }
    }

    static testMethod void testQueues() {
        System.runAs(testUser) {
            Test.startTest();
            Integer sizeBefore = cti_CaseService.getQueues().size();
            
            QueueDetails__c qd = createQueueDetails();
            
            List<QueueDetails__c> qdList = cti_CaseService.getQueues();
            //System.assert(qdList.size() == sizeBefore+1, 'qdList.size is ' + qdList.size() + ' and not the expected size = ' + (sizeBefore + 1));
            //System.assert(qdList.get(0).Id == qd.Id);
            System.assert(qdList.size() > 0, 'No queues were retrieved');
            Test.stopTest();
        }
    }
    
    static testMethod void testGetCasesWithInvalidQueueId() {
        System.runAs(testUser) {
            Test.startTest();
            Case c = new Case();
            insert c;
            
            List<Case> cList = cti_CaseService.getCases(c.Id, false, false);
            System.assert(cList == null, 'cti_CaseService.getCases should return null because of invalid QueueDetails__c.Id but is ' + cList);
            Test.stopTest();
        }
    }
    
    static testMethod void testGetCasesWithNullValues() {
        System.runAs(testUser) {
            Test.startTest();
            Integer numCases = 4;
            List<Case> cList = createCases(numCases);
            QueueDetails__c qd = createQueueDetails();
            Boolean nullValue = null;
            List<Case> cList2 = cti_CaseService.getCases(qd.Id, nullValue, nullValue);
            System.assert(cList.size() == cList2.size(), 'cti_CaseService.getCases(qd, null, null) should return all cases in the queue');
            cList2 = cti_CaseService.getCases(qd.Id, false, nullValue);
            System.assert(cList.size() == cList2.size(), 'cti_CaseService.getCases(qd, false, null) should return all cases in the queue');
            cList2 = cti_CaseService.getCases(qd.Id, nullValue, false);
            System.assert(cList.size() == cList2.size(), 'cti_CaseService.getCases(qd, null, false) should return all cases in the queue');
            Test.stopTest();
        }
    }
    
    static testMethod void testNoCasesQueued() {
        System.runAs(testUser) {
            Test.startTest();
            QueueDetails__c qd = createQueueDetails();
            Boolean assignedToCTI = false;
            Boolean assignedToCTIAgent = false;
            List<Case> cList = cti_CaseService.getCases(qd.id, assignedToCTI, assignedToCTIAgent);
            System.assert(cList.size() == 0);
            Test.stopTest();
        }       
    }
    
    static testMethod void testGetCase() {
        // RecordType = ? Er kanskje ikke nødvendig å teste fordi da må man opprette en recordtype bare for formålet eller bruke en som eksisterer
        System.runAs(testUser) {
            Test.startTest();
            RecordType r = [select id, name from recordtype limit 1];
            Case c = new Case(Subject = 'testSubject', Entry_Email_Address__c = 'mahoel@capgemini.com', SuppliedEmail='mahoel@capgemini.com', Case_URL__c = 'https://test.com', Assigned_to_CTI__c = true, Assigned_to_CTI_Agent__c = false);
            insert c; 
            Case d = cti_CaseService.getCase(c.Id);
            System.assert(c.Id == d.Id);
            System.assert(c.Subject == d.Subject);
            System.assert(c.Entry_Email_Address__c == d.Entry_Email_Address__c);
            System.assert(c.SuppliedEmail == d.SuppliedEmail);
            System.assert(c.Case_URL__c != d.Case_URL__c, 'Case_URL__c has not been changed on getCase to correct Case URL');
            System.debug('--- URL is: ' + d.Case_URL__c);
            System.assert(c.Assigned_to_CTI__c == d.Assigned_to_CTI__c, 'Should be equal c.Assigned_to_CTI__c (' + c.Assigned_To_CTI__c + ') != d.Assigned_to_CTI__c (' + d.Assigned_To_CTI__c + ')');
            System.assert(c.Assigned_to_CTI_Agent__c == d.Assigned_to_CTI_Agent__c, 'Should be equal c.Assigned_to_CTI_Agent__c (' + c.Assigned_to_CTI_Agent__c + ') != d.Assigned_to_CTI_Agent__c (' + d.Assigned_to_CTI_Agent__c + ')');
            System.assert(d.CreatedDate != null, 'd.CreatedDate should not be null' );
            Test.stopTest();
            //System.assert(c.Customer_name__c == 'Capgemini', 'c.Customer_name__c = ' + c.Customer_name__c);
        }
    }
    
    static testMethod void testCasesQueued() {
        System.runAs(testUser) {    
            Test.startTest();
            QueueDetails__c qd = createQueueDetails();
    
            Case c = createCases(1).get(0);
            Boolean assignedToCTI = false;
            Boolean assignedToCTIAgent = false;
            List<Case> cList = cti_CaseService.getCases(qd.id, assignedToCTI, assignedToCTIAgent);
            //System.assert(c.)
            
            System.assert(c.Assigned_to_CTI_Agent__c == assignedToCTIAgent);
            System.assert(c.Assigned_to_CTI__c == assignedToCTI);
            System.assert(cList.size() == 1, 'cList.size() is ' + cList.size() + ' but should be 1'); 
            System.assert(cList.get(0).Id == c.Id);    
            System.assert(cList.get(0).Case_URL__c != NULL);
            Test.stopTest();
        }
    }
    
    static testMethod void testCreateCase() {
        Group g2 = new Group(Type='Queue', Name='Test queue for CaseService unit tests999');
        insert g2;
        
        System.runAs(testUser) {
            List<QueueSObject> qList = new List<QueueSObject>();
            qList.add(new QueueSObject(SobjectType='Case', QueueId=g2.Id));
            qList.add(new QueueSObject(SobjectType='QueueDetails__c', QueueId=g2.Id));
            insert qList;
        
        
            Test.startTest();
            g2 = [select Id from Group where Name = 'Test queue for CaseService unit tests999'];
            Case c = new Case(Subject = '-999', OwnerId = g2.Id);
            System.debug('--- c.Id = ' + c.Id);
            insert c;
            System.debug('--- c.Id = ' + c.Id);
            System.assert(g2.Id != null);
            //update c;
            Case d = [select Id from Case where id=:c.id];
            System.debug('+++ d.Id = ' + d.Id);
    
            
            Test.stopTest();
        }
    }
    
    static testMethod void testCasesAssignedToCTI() {
        System.runAs(testUser) {
            Test.startTest();
            QueueDetails__c qd = createQueueDetails();
            Integer numCases = 5, numCasesAssignedToCTI = 2;
            List<Case> cList = createCases(numCases);
            Boolean assignedToCTI = true;
            Boolean assignedToCTIAgent = false;
            System.assert(cList.size() == numCases);
            
            for(Integer i = 0; i < numCasesAssignedToCTI; i++) {
                Case c = cList.get(i);
                cti_CaseService.setCaseStatus(cList.get(i).Id, assignedToCTI, assignedToCTIAgent);
            }
            
            List<Case> cListRetrieved = cti_CaseService.getCases(qd.id, !assignedToCTI, assignedToCTIAgent);
            System.assert(cListRetrieved.size() == (numCases - numCasesAssignedToCTI), 'Antall etter assigned_to_CTI ' + cListRetrieved.size() + ' - ( totalt antall cases (' + numCases + ') + antall assigned (' + numCasesAssignedToCTI + '))');
            Test.stopTest();
        }
    }
    
    static testMethod void testCasesAssignedToCTIAgent() {
        System.runAs(testUser) {
                    Test.startTest();
            QueueDetails__c qd = createQueueDetails();
            Integer numCases = 5, numCasesAssignedToCTI = 2;
            List<Case> cList = createCases(numCases);
            for(Integer i = 0; i < numCasesAssignedToCTI; i++) {
                cti_CaseService.setCaseStatus(cList.get(i).Id, false, true);
            }
            Boolean assignedToCTI = false;
            Boolean assignedToCTIAgent = false;
            List<Case> cListRetrieved = cti_CaseService.getCases(qd.id, assignedToCTI, assignedToCTIAgent);
            System.assert(cListRetrieved.size() == (numCases - numCasesAssignedToCTI), 'Antall etter assigned_to_CTI_Agent__c ' + cListRetrieved.size() + ' - ( totalt antall cases (' + numCases + ') + antall assigned (' + numCasesAssignedToCTI + '))');
            Test.stopTest();
        }
    }
    
    static testMethod void testResetCaseStatuses() {
        System.runAs(testUser) {
            Test.startTest();
            QueueDetails__c qd = createQueueDetails();
            Integer numCases = 5;
            List<Case> cList = createCases(numCases);
            System.assert(cList.size() == numCases);
            for(Case c : cList) {
                c.Assigned_to_CTI__c = true;
            }
            update cList;
            cti_CaseService.resetCaseStatuses(qd.Id); 
            cList = [SELECT c.Id from Case c where c.OwnerId = :qd.OwnerId and c.Assigned_to_CTI__c = false];
            System.assert(cList.size() == numCases, 'Number of cases after status reset is ' + cList.size() + ' but should be ' + numCases);
            Test.stopTest();
        }
    }
    
    static testMethod void testGetCaseAssignedToCTI() {
 //     RecordType r = new RecordType(Name='Test');
 //     insert r;
        //Case c = new Case(Subject='Test subject', Entry_Email_Adress__c = 'test@test.test', c.RecordTypeId = r.Id);
    }
    
    static testMethod void testCustomerExistsInKats() {
        System.runAs(testUser) {
            Test.startTest();
            String phoneNumber = '-0090210';
            Account account = createAccount(phoneNumber);
            Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
            account.recordtypeid= RecordTypeid;
            upsert account;
            String URL = cti_CaseService.getURLWithCustomerInfo(phoneNumber);
            URL = URL.replaceFirst('/$',''); //  removing trailing / if it exists
            System.assert(URL.endsWith(account.Id), 'URL does not end with correct Account ID (' + account.Id + ') '+ URL);
            System.assert(URL.startsWith('http'), 'URL is malformed: ' + URL);
            Test.stopTest();
        }
    }
    /*
    static testMethod void testCustomerDoesNotExistInKats() {
        System.runAs(testUser) {
            Test.startTest(); 
            String phoneNumber = '-0090210';
            String URL = cti_CaseService.getURLWithCustomerInfo(phoneNumber);
            URL = URL.replaceFirst('/$',''); //  removing trailing / if it exists
            System.assert(URL.endsWith(phoneNumber), 'URL does not end with phoneNumber (' + phoneNumber + ') '+ URL);
            System.assert(URL.startsWith('http'), 'URL is malformed: ' + URL);
            Test.stopTest();
        }
    }*/
    
    static testMethod void testGetSimpleInquiryURL() {
        System.runAs(testUser) {
            Test.startTest();
            String actualUrl = cti_CaseService.getURLWithCustomerInfo('');
            System.assert(actualUrl.endsWith('action=createSimpleInquiry'), 'URL should end with action=createSimpleInquiry');
            System.assert(actualUrl.startsWith('http'), 'URL is malformed: ' + actualUrl);
        }
    }
    
    static testMethod void testGetPhone() {
        String inputValue = '12345678/500P00000037dQD';
        String expected = '12345678';
        String actual = cti_CaseService.getPhone(inputValue);
        System.assertEquals(expected, actual, 'Phonenumbers are different');
    }
    
    static testMethod void testGetId() {
        String inputValue = '12345678/500P00000037dQD';
        Id expected = '500P00000037dQD';
        Id actual = cti_CaseService.getQueueId(inputValue);
        System.assertEquals(expected, actual, 'Ids are different');
        
    }

    
    private static void changeStatus(List<Case> casesToChangeStatusOn, String status) {
        for(Case c: casesToChangeStatusOn) {
            c.Status = status;
            c.date_to_be_resumed__c = System.now() + 3600;
        }
        update casesToChangeStatusOn;
    }

    
    /**
    *   Use this method to change CTI flags Assigned_to_CTI__c = false, Assigned_to_CTI_Agent__c = false for
    *   numCasesNotAssignedToCTI numer of cases. That way we have some Cases to check that CaseResetCTIFlags
    *   actually resets flags.
    */
    private static List<Id> makeSomeCasesNotAssignedToCTI(List<Case> cases, Integer numCasesNotAssignedToCTI) {
        List<Id> idsOfCasesNotAssignedToCTI = new List<Id>();
        for(Integer i = 0; i < numCasesNotAssignedToCTI; i++) {         
            cti_CaseService.setCaseStatus(cases.get(i).Id, false, false);
            idsOfCasesNotAssignedToCTI.add(cases.get(i).Id);
        } // cases available to CTI have flags assigned_To_CTI__c = false and assigned_To_CTI_Agent__c = true
        return idsOfCasesNotAssignedToCTI;
    }
    
    static testMethod void testAssigningToCtiQueueResetsFlags() {
        System.runAs(testUser) {
            Test.startTest();
            Test.stopTest();
        }
    }
    
    /*Unit test to test get segment by caller ID*/
    static testMethod void testGetSegmentKnownAccount_1() {
        String aNumber;     
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        System.runAs(testUser){
            Test.startTest();
            
            Account a = createCargoAccount('225050505', 'VIP');
            a.recordtypeid = recordtypeid;
            update a;
            aNumber = '225050505';
            String returnSegment = cti_CaseService.getSegmentByCallerId(aNumber);
            System.assertEquals('VIP',returnSegment, 'Should be VIP when number starts with 22');           
            
        }
    }
     static testMethod void testGetSegmentKnownAccount_2() {
        String aNumber;     
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        System.runAs(testUser){
            Account a = createCargoAccountWithSector('225050505', 'VIP', 'Bok og papir');       
            a.recordtypeid= recordtypeid;
            aNumber = '225050505';
            String returnSegment = cti_CaseService.getSegmentByCallerId(aNumber);
           // System.assertEquals('VIP_Bok_og_papir',returnSegment);
            a.Sector__c='';
            upsert a;
            returnSegment = cti_CaseService.getSegmentByCallerId(aNumber);
            System.assertEquals('VIP',returnSegment);
            a.Sector__c=null;
            upsert a;
            returnSegment = cti_CaseService.getSegmentByCallerId(aNumber);
            System.assertEquals('VIP',returnSegment);
        }
    }
    
    /* Test method for creating URL. When a case is given as input the method should output url to the case.
    */
    static testMethod void testCreateURL(){
        Case c=new Case();
        insert c;
        Case x;
        String URL=cti_CaseService.createUrl(c);
        String baseURL=cti_CaseService.createUrl(x);
        
        System.assertEquals(( new PageReference(cti_CaseService.baseURL + c.Id).getUrl()), URL);
        System.assertEquals( new PageReference(cti_CaseService.baseURL).getUrl(), baseURL);
        
    }
   
    static QueueDetails__c createQueueDetails() {
        QueueDetails__c qd = new QueueDetails__c(queue_name__c='Test kø' + System.now(), OwnerId=g.Id);
        insert qd;
        qd.fetch_from_cti__c = true;
        update qd;
        return qd;
    }
    
    static List<Case> createCases(Integer n) {
        List<Case> cList = new List<Case>();
            
        for(Integer i = 0; i < n; i++) {
            Case c = new Case(Assigned_to_CTI__c = false, Assigned_to_CTI_Agent__c = false);
            c.OwnerId = g.Id;
            cList.add(c);
        }
        
        insert cList;
        return cList;
    }
    
    static List<Case> createCases(Integer n, Boolean assignedToCTI, Boolean assignedToCTIAgent) {
        List<Case> cList = new List<Case>();
            
        for(Integer i = 0; i < n; i++) {
            Case c = new Case(Assigned_to_CTI__c = assignedToCTI, Assigned_to_CTI_Agent__c = assignedToCTIAgent);
            c.OwnerId = g.Id;
            cList.add(c);
        }
        
        insert cList;
        return cList;
    }
    
    static Account createCargoAccount(String aPhoneNumber, String segment){
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account a = createAccountWithContact(aPhoneNumber);
        a.CRMStatus__c = segment;
        a.recordtypeid=recordtypeid;
        KATSutilities.upsertAsSystem(a);
        return a;
    }
     static Account createCargoAccountWithSector(String aPhoneNumber, String segment, String sector){
        
        Account a = createAccountWithContact(aPhoneNumber);
        a.CRMStatus__c = segment;
        a.Sector__c=sector;
        KATSutilities.upsertAsSystem(a);
        return a;
    }
    
    static Account createAccount(String aPhoneNumber) {
        Account a = new Account(Name='Test account', Phone = aPhoneNumber);
        KATSutilities.upsertAsSystem(a);
        //insert a;
        return a;
    }
    
    static Account createAccountWithContact(String aPhoneNumber){       
        Account a = createAccount(aPhoneNumber);
        Contact c = createContact(aPhoneNumber, a);
        
        return a;
    }
    
    static Contact createContact(String aPhoneNumber, Account a){
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.FirstName = 'test';
        c.LastName = 'contact';
        c.Phone = aPhoneNumber;
        c.MobilePhone = aPhoneNumber;
        KATSutilities.upsertAsSystem(c);
        
        return c;
    }
}