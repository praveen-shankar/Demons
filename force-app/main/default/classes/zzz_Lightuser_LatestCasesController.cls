// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest
private class zzz_Lightuser_LatestCasesController {
    
    
    private static Code_Reason1__c testReason=createTestReason();
    
    
    
    static testMethod void testLightuser_LatestCasesController_1() {
        PageReference testPage = new PageReference('Lightuser_LatestCasesController');
        Test.setCurrentPage(testPage);
        
        Test.startTest();
            Lightuser_LatestCasesController llcc = new Lightuser_LatestCasesController();
        Test.stopTest();
        
        system.assertEquals(true, llcc.latestCases.isEmpty());
        system.assertEquals(true, String.isBlank(llcc.partyNumber));
    }
    
    static testMethod void testLightuser_LatestCasesController_2() {
        Account testAccount = new Account(Name = 'test', crm_customer_number__c = '1234567');
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        testaccount.recordtypeid= recordtypeid;
        upsert testAccount;
        
        Code_Event__c ce=new Code_Event__c(Name='testCategory');
        insert ce;
        
        Case testCase1 = new Case(
            Produkt__c = 'testProduct',
            Type__c = 'testType',
            Subject = 'testCase1',
            Code_Reason1__c = testReason.id,
            Code_Event__c = ce.id,
            //status = 'Ny',
            //Csphase2 Supriya 29122016
             status = 'New',
            AccountId = testAccount.id
        );
        
        Case testCase2 = new Case(
            Produkt__c = 'testProduct',
            Type__c = 'testType',
            Subject = 'testCase2',
            Code_Reason1__c = testReason.id,
            Code_Event__c = ce.id,
           // status = 'Ny'
             //Csphase2 Supriya 29122016
             status = 'New'
        );
        upsert testCase1;
        upsert testCase2;
        
        PageReference testPage = new PageReference('Lightuser_LatestCasesController');
        
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('partyid', testAccount.crm_customer_number__c);
        
        Test.startTest();
            Lightuser_LatestCasesController llcc = new Lightuser_LatestCasesController();
        Test.stopTest();
        
        system.assertEquals(testAccount.crm_customer_number__c, llcc.partyNumber);
        system.assertEquals(false, llcc.latestCases.isEmpty());
        system.assertEquals(1, llcc.latestCases.size());
        system.assertEquals(testCase1.id, llcc.latestCases.get(0).id);
    }
    
    static testMethod void testLightuser_LatestCasesController_3() {
        Code_Event__c ce=new Code_Event__c(Name='testCategory');
        insert ce;
        
        Case testCase1 = new Case(
            Produkt__c = 'testProduct',
            Type__c = 'testType',
            Subject = 'testCase1',
            Code_Reason1__c = testReason.id,
            Code_Event__c =ce.id,
            //status = 'Ny',
             //Csphase2 Supriya 29122016
             status = 'New',
            Origin = 'AvT',
            recordtypeId = KATSutilities.getRecordType('deviation_case')
        );
        
        Case testCase2 = new Case(
            Produkt__c = 'testProduct',
            Type__c = 'testType',
            Subject = 'testCase2',
           Code_Reason1__c = testReason.id,
            Code_Event__c = ce.id,
            //status = 'Ny',
             //Csphase2 Supriya 29122016
             status = 'New',
            Origin = 'Lightuser',
            recordtypeId = KATSutilities.getRecordType('deviation_case')
        );
        
        Case testCase3 = new Case(
            Produkt__c = 'testProduct',
            Type__c = 'testType',
            Subject = 'testCase2',
            Code_Reason1__c = testReason.id,
            Code_Event__c = ce.id,
            //status = 'Ny',
             //Csphase2 Supriya 29122016
             status = 'New',
            Origin = 'Email',
            recordtypeId = KATSutilities.getRecordType('deviation_case')
        );
        
        Case testCase4 = new Case(
            Produkt__c = 'testProduct',
            Type__c = 'testType',
            Subject = 'testCase2',
            Code_Reason1__c = testReason.id,
            Code_Event__c = ce.id,
           // status = 'Ny'
            //Csphase2 Supriya 29122016
             status = 'New'
        );
        upsert testCase1;
        upsert testCase2;
        upsert testCase3;
        upsert testCase4;
        
        PageReference testPage = new PageReference('Lightuser_LatestCasesController');
        Test.setCurrentPage(testPage);
        
        Test.startTest();
            Lightuser_LatestCasesController llcc = new Lightuser_LatestCasesController();
        Test.stopTest();
        
        system.assertEquals(null, llcc.partyNumber);
        system.assertEquals(false, llcc.latestCases.isEmpty());
        system.assertEquals(2, llcc.latestCases.size());
    }
    
    static testMethod void testSeeCase_1() {
        Lightuser_LatestCasesController llcc = new Lightuser_LatestCasesController();
        
        PageReference testPage = new PageReference('Lightuser_LatestCasesController');
        Test.setCurrentPage(testPage);
        
        PageReference result;
        Test.startTest();
            result = llcc.seeCase();
        Test.stopTest();
        
        system.assertEquals(null, result);
    }
    
    static testMethod void testSeeCase_2() {
        Lightuser_LatestCasesController llcc = new Lightuser_LatestCasesController();
        
        PageReference testPage = new PageReference('Lightuser_LatestCasesController');
        Test.setCurrentPage(testPage);
        
        llcc.caseCaseNumber = '1234567';
        
        PageReference result;
        Test.startTest();
            result = llcc.seeCase();
        Test.stopTest();
        
        system.assertEquals(null, result);
    }
    
    static testMethod void testSeeCase_3() {
        Code_Event__c ce=new Code_Event__c(Name='testCategory');
        insert ce;
        Case testCase1 = new Case(
            Produkt__c = 'testProduct',
            Type__c = 'testType',
            Subject = 'testCase1',
           Code_Reason1__c = testReason.id,
            Code_Event__c = ce.id,
           // status = 'Ny',
            //Csphase2 Supriya 29122016
             status = 'New',
            Origin = 'AvT',
            recordtypeId = KATSutilities.getRecordType('deviation_case')
        );
        upsert testCase1;
        
        Lightuser_LatestCasesController llcc = new Lightuser_LatestCasesController();
        llcc.caseCaseNumber = [SELECT caseNumber FROM Case WHERE id =:testCase1.id LIMIT 1].caseNumber;
        
        PageReference testPage = new PageReference('Lightuser_LatestCasesController');
        Test.setCurrentPage(testPage);
        
        PageReference result;
        
        Test.startTest();
            result = llcc.seeCase();
        Test.stopTest();
        
        system.assertEquals(testCase1.id, result.getParameters().get('id'));
    }
    
    static testMethod void testSeeCase_4() {
        Code_Event__c ce=new Code_Event__c(Name='testCategory');
        insert ce;
        Case testCase1 = new Case(
            Produkt__c = 'testProduct',
            Type__c = 'testType',
            Subject = 'testCase1',
            Code_Reason1__c = testReason.id,
            Code_Event__c = ce.id,
            //status = 'Ny',
             //Csphase2 Supriya 29122016
             status = 'New',
            Origin = 'AvT',
            recordtypeId = KATSutilities.getRecordType('deviation_case')
        );
        upsert testCase1;
        
        Lightuser_LatestCasesController llcc = new Lightuser_LatestCasesController();
        llcc.caseCaseNumber = [SELECT caseNumber FROM Case WHERE id =:testCase1.id LIMIT 1].caseNumber;
        llcc.partyNumber = '1234';
        
        PageReference testPage = new PageReference('Lightuser_LatestCasesController');
        Test.setCurrentPage(testPage);
        
        PageReference result;
        
        Test.startTest();
            result = llcc.seeCase();
        Test.stopTest();
        
        system.assertEquals(testCase1.id, result.getParameters().get('id'));
        system.assertEquals('1234', result.getParameters().get('partyid'));
        
    }   
    
      private static Code_Reason1__c createTestReason(){
        Code_Reason1__c r=new Code_Reason1__c(Name='MyTestReason1');
        insert r;
        return r;
    }
}