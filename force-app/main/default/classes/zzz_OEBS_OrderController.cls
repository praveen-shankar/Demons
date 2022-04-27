// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest
private class zzz_OEBS_OrderController {
    
    /*
    *   Static resources for doing the test
    */
    static String testReleaseReason = 'test release of order';
    static String testProduct = 'Test Product';
    static String testDescription = 'Test description';
    static String testOrderURL = 'http:\\www.test.com';
    static String testContractName = 'Test kontrakt';
    static Integer orderNumber = 0000;
    static Integer orderId = 9999;
    static String contractNumber = '00000';
    static PostalUnit__c postalUnit;
    
    static PostalUnit__c getPostalUnit() {
        if(postalUnit == null){
            postalUnit = new PostalUnit__c(unit_number__c = '0000');
            insert postalUnit;
        }
        return postalUnit;
    }
    
    static String getOrderNumber() {
        orderNumber++;
        return 'TestOEBS' + orderNumber;
    }
    
    static String getOrderId() {
        orderId--;
        return 'TestOEBS' + orderId;
    }
    
    static map<Id,Account> accountMap = new map<Id,Account>();
    
    static map<Id,Account> getOEBSTestAccounts() {
        if(accountMap.isEmpty()) {
            return zzz_OEBS_OrderController.getOEBSTestAccounts(200);
        }
        return accountMap;
    }
    
    static map<Id,Account> getOEBSTestAccounts(Integer nmbOfAccounts) {
        if(accountMap.isEmpty()) {
            list<Account> accountList = new list<Account>();
            for(Integer i = 0; i < nmbOfAccounts; i++) {
                accountList.add(new Account(Name = 'Account ' + i, crm_customer_number__c = 'Test00'+i));
            }
            insert accountList;
            for(Account acc : accountList) {
                accountMap.put(acc.id, acc);
            }
        }
        return accountMap;
    }
    
    static List<Case> getOEBSTestCase(Integer nmbOfCases) {
        list<Case> cases = new list<Case>();
        for(Integer i = 0; i < nmbOfCases; i++) {
            cases.add(new Case( OEBS_contract_name__c = zzz_OEBS_OrderController.testContractName,
                                OEBS_contract_number__c = zzz_OEBS_OrderController.contractNumber,
                                OEBS_order_line_id__c = zzz_OEBS_OrderController.getOrderId(),
                                OEBS_order_number__c = zzz_OEBS_OrderController.getOrdernumber(),
                                OEBS_Order_Status__c = null,
                                OEBS_order_URL__c = zzz_OEBS_OrderController.testOrderURL,
                                OEBS_producer__c = zzz_OEBS_OrderController.getOEBSTestAccounts(nmbOfCases).values().get(i).id,
                                OEBS_top_article__c = zzz_OEBS_OrderController.testProduct,
                                OEBS_order_release_reason__c = null,
                                Submission_place__c = zzz_OEBS_OrderController.getPostalUnit().id, 
                                description = zzz_OEBS_OrderController.testdescription,
                                origin = 'OEBS'));
        }
        return cases;
    }
    
    
    
    static {
        KatsTestUtilities.createEconnectEnvironmentSettings();
    }
    
    
    /*
    *   TESTS
    */
    
    //Test if the system handles 200 inserts
    static testMethod void bulktestInsert() {
        List<Case> cases = zzz_OEBS_OrderController.getOEBSTestCase(200);
        
        Test.startTest();
            insert cases;
        Test.stopTest();
    }
    
    //Test one insert
    static testMethod void testInsert() {
        Case c = zzz_OEBS_OrderController.getOEBSTestCase(1).get(0);
        
        Test.startTest();
            insert c;
        Test.stopTest();
        
        c = [SELECT id,
                    origin,
                    OEBS_Order_Status__c,
                    Description,
                    OEBS_to_be_deleted__c,
                    OEBS_top_article__c,
                    Produkt__c,
                    OEBS_order_release_reason__c,
                    RecordTypeId,
                    OEBS_order_number__c,
                    type__c,
                    subject
            FROM Case c
            WHERE id = :c.id];
        
        system.assertEquals('OEBS', c.origin);
        system.assertEquals(null, c.OEBS_Order_Status__c);
        system.assertEquals(zzz_OEBS_OrderController.testdescription, c.Description);
        system.assertEquals(false, c.OEBS_to_be_deleted__c);
        system.assertEquals(zzz_OEBS_OrderController.testProduct,c.OEBS_top_article__c);
        system.assertEquals(c.OEBS_top_article__c, c.Produkt__c);
        system.assertEquals(null,c.OEBS_order_release_reason__c);
        system.assertEquals(KatsUtilities.getRecordType('deviation_case'), c.RecordTypeId);
        system.assert(String.isEmpty(c.type__c));
        system.assertEquals('Avvik Ordre ' + c.OEBS_order_number__c, c.subject);
    }
    
    static testMethod void TestReopenCase() 
    {
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        Service_Product__c testProd = new Service_Product__c();
        testProd.Name = 'Prod1';
        testProd.IsActive__c = true;
        testProd.Product_Code__c = '2234';
        //testProd.Eier__c = 'Post';
        //Csphase2 Supriya 29122016
        testProd.Eier__c = 'MAIL';
        database.insert(testProd);

        Code_Event__c testHenvend = new Code_Event__c();
        testHenvend.IsActive__c = true;
        testHenvend.Name = 'Demo Henvend';
       // testHenvend.CaseTypeMultiselect__c = 'Avvik';
       //Csphase2 Supriya 29122016
         testHenvend.CaseTypeMultiselect__c = 'Deviation';
        Database.insert(testHenvend); 

        Code_Reason1__c ar1 = new Code_Reason1__c();
        ar1.Name = 'Test Arsak 1';
        Database.insert(ar1);

        Case originalCase = zzz_OEBS_OrderController.getOEBSTestCase(1).get(0);
        originalCase.OEBS_Order_Status__c = 'Released';
       // originalCase.type__c = 'Registrert';
       // originalCase.status = 'Avsluttet';
        originalCase.type__c = 'Registrert';
        originalCase.status = 'Closed';
        originalCase.Code_Event__c = testHenvend.Id;
        originalCase.Service_Product__c = testProd.Id;/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        originalCase.Code_Reason1__c = ar1.Id;
        originalCase.Category__c = 'Demo Henvend';
        originalCase.Produkt__c = 'Prod1';
        originalCase.reason__c = ar1.Name;
        originalCase.OEBS_order_release_reason__c = 'Test released';
        
        insert originalCase;
        
        Case newCase = new Case(OEBS_contract_name__c = originalCase.OEBS_contract_name__c,
                                OEBS_contract_number__c = originalCase.OEBS_contract_number__c,
                                OEBS_order_line_id__c = originalCase.OEBS_order_line_id__c,
                                OEBS_order_number__c = originalCase.OEBS_order_number__c,
                                OEBS_Order_Status__c = null,
                                OEBS_order_URL__c = originalCase.OEBS_order_URL__c,
                                OEBS_producer__c = originalCase.OEBS_producer__c,
                                OEBS_top_article__c = originalCase.OEBS_top_article__c,
                                OEBS_order_release_reason__c = null,
                                Submission_place__c = originalCase.Submission_place__c, 
                                description = 'Reopened: ' + originalCase.description,
                                origin = 'OEBS');
                        
        Test.startTest();
            system.debug('Test start'); 
            insert newCase;
        Test.stopTest();
        
        Case c = [SELECT id,
                    origin,
                    OEBS_Order_Status__c,
                    Description,
                    OEBS_to_be_deleted__c,
                    OEBS_top_article__c,
                    Produkt__c,
                    OEBS_order_release_reason__c,
                    RecordTypeId,
                    OEBS_order_number__c,
                    type__c,
                    subject
                FROM Case
                WHERE id = :originalCase.id];
        
        List<Case> newCaseList = new list<Case>();
        newCaseList = [SELECT id,
                    origin,
                    OEBS_Order_Status__c,
                    Description,
                    OEBS_to_be_deleted__c,
                    OEBS_top_article__c,
                    Produkt__c,
                    OEBS_order_release_reason__c,
                    RecordTypeId,
                    OEBS_order_number__c,
                    type__c,
                    subject
                FROM Case
                WHERE id = :newCase.id];
        
        system.assert(newCaseList.isEmpty());
        
        system.assertEquals('OEBS', c.origin);
        system.assertEquals(null, c.OEBS_Order_Status__c);
        system.assertEquals(false, c.OEBS_to_be_deleted__c);
        system.assertEquals(zzz_OEBS_OrderController.testProduct,c.OEBS_top_article__c);
        system.assertEquals(c.OEBS_top_article__c, c.Produkt__c);
        system.assertEquals(null,c.OEBS_order_release_reason__c);
        system.assertEquals(KatsUtilities.getRecordType('deviation_case'), c.RecordTypeId);
        system.assert(String.isEmpty(c.type__c));
        system.assertEquals('Avvik Ordre ' + c.OEBS_order_number__c, c.subject);
        system.assertEquals('Reopened: ' + zzz_OEBS_OrderController.testDescription, c.description);
    }
    
    static testMethod void testCreateOrderReleaseEmail_1() {
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        User testAdminUser = KatsTestUtilities.getTestAdminUser();
        Case testCase;
        
        System.runAs(testAdminUser) {
            testCase = zzz_OEBS_OrderController.getOEBSTestCase(1).get(0);
            testCase.OEBS_Order_Status__c = 'Released';
            testCase.OEBS_order_release_reason__c = 'Test';
            testCase.OEBS_order_number__c = '1234';
            testCase.OwnerId = testUser.id;
            insert testCase;
        }
        
        testCase = [SELECT OEBS_order_line_id__c,
                        OEBS_order_release_reason__c,
                        OEBS_Order_Status__c,
                        OEBS_order_number__c,
                        Owner.id,
                        Owner.Username,
                        Owner.Email,
                        CaseNumber
                    FROM Case
                    WHERE Id = :testCase.id];
        
        Messaging.SingleEmailMessage result;
        test.startTest();
            System.runAs(testAdminUser) {
                result = OEBS_OrderController.createOrderReleaseEmail(testCase);
            }
        test.stopTest();
        
        system.assertEquals(1, result.getToAddresses().size());
        system.assertEquals(testUser.email, result.getToAddresses().get(0));
        system.assertEquals('KATS Ordrefrigivelse', result.getSenderDisplayName());
        system.assertEquals('High', result.getEmailPriority());
        system.assertEquals(true, String.isNotBlank(result.getSubject()));
        system.assertEquals(true, String.isNotBlank(result.getPlainTextBody()));
        system.assertEquals(true, result.getSaveAsActivity());
        system.assertEquals(testCase.id, result.getWhatId());
    }
    /* Deactivated because of the NO_MASS_MAIL_PERMISSION setting
    static testMethod void test_SendOrderReleaseEmail_1() {
        list<Case> releasedCaseList = new list<Case>();
        
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        User testAdminUser = KatsTestUtilities.getTestAdminUser();
        Case testCase;
        
        System.runAs(testAdminUser) {
            testCase = zzz_OEBS_OrderController.getOEBSTestCase(1).get(0);
            testCase.OEBS_Order_Status__c = 'Released';
            testCase.OEBS_order_release_reason__c = 'Test';
            testCase.OEBS_order_number__c = '1234';
            testCase.OwnerId = testUser.id;
            insert testCase;
        }
        
        testCase = [SELECT OEBS_order_line_id__c,
                        OEBS_order_release_reason__c,
                        OEBS_Order_Status__c,
                        OEBS_order_number__c,
                        Owner.id,
                        Owner.Username,
                        Owner.Email,
                        CaseNumber
                    FROM Case
                    WHERE Id = :testCase.id];
        
        releasedCaseList.add(testCase);
        
        list<Messaging.SendEmailResult> result;
        test.startTest();
            result = OEBS_OrderController.sendOrderReleaseEmail(releasedCaseList);
        test.stopTest();
        
        system.assertEquals(1, releasedCaseList.size());
    }
 /**/   
}