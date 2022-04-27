// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest
private class zzz_OEBS_ReleaseOrderPageController {
    private static PostalUnit__c testUnit;
    private static Account testAccount;
    
    static {
        testUnit = new PostalUnit__c(Name = 'Test Unit - 1234',
                                    DRM_id__c = 'abc123',
                                    unit_number__c = '1234',
                                    unit_name__c = 'Test Unit');
        testAccount = new Account(Name = 'Test OEBS Account',
                                    crm_customer_number__c = '12345678');
        
        upsert testAccount;
        upsert testUnit;
    }
    
    static testMethod void OEBS_ReleaseOrderPageController_1() {
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Submission_place__c = testunit.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        upsert testCase;
        
        test.setCurrentPageReference(new PageReference('OEBS_ReleaseOrderPage'));
        
        ApexPages.currentPage().getParameters().put('id',testCase.id);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        
        OEBS_ReleaseOrderPageController result;
        
        test.startTest();
            result = new OEBS_ReleaseOrderPageController(stdController);
        test.stopTest();
        
        system.assertNotEquals(null, result.caseToBeReleased);
        system.assertEquals(testCase.id, result.caseToBeReleased.id);
        system.assertEquals(null, result.orderReleaseReason);
    }
    
    
    static testMethod void OEBS_ReleaseOrderPageController_2() {
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Submission_place__c = testunit.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        upsert testCase;
        
        test.setCurrentPageReference(new PageReference('OEBS_ReleaseOrderPage'));

        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        
        OEBS_ReleaseOrderPageController result;
        
        test.startTest();
            result = new OEBS_ReleaseOrderPageController(stdController);
        test.stopTest();
        
        system.assertEquals(null, result.caseToBeReleased);
        system.assertEquals(null, result.orderReleaseReason);
    }
    
    static testMethod void OEBS_ReleaseOrderPageController_3() {
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Submission_place__c = testunit.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = 'Test'
        );
        upsert testCase;
        
        test.setCurrentPageReference(new PageReference('OEBS_ReleaseOrderPage'));
        
        ApexPages.currentPage().getParameters().put('id',testCase.id);

        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        
        OEBS_ReleaseOrderPageController result;
        
        test.startTest();
            result = new OEBS_ReleaseOrderPageController(stdController);
        test.stopTest();
        
        system.assertNotEquals(null, result.caseToBeReleased);
        system.assertEquals(testCase.id, result.caseToBeReleased.id);
        system.assertEquals('Test', result.orderReleaseReason);
    }
    
    static testMethod void releaseOrderGoToCase_1() {
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Submission_place__c = testunit.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        upsert testCase;
        
        test.setCurrentPageReference(new PageReference('OEBS_ReleaseOrderPage'));
        
        ApexPages.currentPage().getParameters().put('id',testCase.id);

        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        
        OEBS_ReleaseOrderPageController controller = new OEBS_ReleaseOrderPageController(stdController);
        controller.orderReleaseReason = 'test release';
        
        PageReference result;
        test.startTest();
            result = controller.releaseOrderGoToCase();
        test.stopTest();
        
        system.assertEquals(new PageReference('/'+testCase.id).getUrl(), result.getUrl());
    }
    
    static testMethod void releaseOrderGoToCase_2() {
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Submission_place__c = testunit.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        upsert testCase;
        
        test.setCurrentPageReference(new PageReference('OEBS_ReleaseOrderPage'));
        
        ApexPages.currentPage().getParameters().put('id',testCase.id);

        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        
        OEBS_ReleaseOrderPageController controller = new OEBS_ReleaseOrderPageController(stdController);
        
        PageReference result;
        test.startTest();
            result = controller.releaseOrderGoToCase();
        test.stopTest();
        
        system.assertEquals(null, result);
    }
    
    static testMethod void releaseOrderCloseCase_1() {
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Submission_place__c = testunit.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        upsert testCase;
        
        test.setCurrentPageReference(new PageReference('OEBS_ReleaseOrderPage'));
        
        ApexPages.currentPage().getParameters().put('id',testCase.id);

        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        
        OEBS_ReleaseOrderPageController controller = new OEBS_ReleaseOrderPageController(stdController);
        controller.orderReleaseReason = 'test release';
        
        PageReference result;
        test.startTest();
            result = controller.releaseOrderCloseCase();
        test.stopTest();
        
    }
    
    static testMethod void releaseOrderCloseCase_2() {
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Submission_place__c = testunit.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        upsert testCase;
        
        test.setCurrentPageReference(new PageReference('OEBS_ReleaseOrderPage'));
        
        ApexPages.currentPage().getParameters().put('id',testCase.id);

        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        
        OEBS_ReleaseOrderPageController controller = new OEBS_ReleaseOrderPageController(stdController);
        
        PageReference result;
        test.startTest();
            result = controller.releaseOrderCloseCase();
        test.stopTest();
        
        system.assertEquals(null, result);
    }
    
    static testMethod void releaseOrder_1() {
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Submission_place__c = testunit.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        upsert testCase;
        
        test.setCurrentPageReference(new PageReference('OEBS_ReleaseOrderPage'));

        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        
        ApexPages.currentPage().getParameters().put('id',testCase.id);
        
        OEBS_ReleaseOrderPageController controller = new OEBS_ReleaseOrderPageController(stdController);
        controller.orderReleaseReason = 'test release';
        
        PageReference result;
        test.startTest();
            result = controller.releaseOrder('test');
        test.stopTest();
        
        system.assertEquals(new PageReference('test').getUrl(), result.getUrl());
    }
    
    static testMethod void abort_1() {
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Submission_place__c = testunit.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        upsert testCase;
        
        test.setCurrentPageReference(new PageReference('OEBS_ReleaseOrderPage'));
        
        ApexPages.currentPage().getParameters().put('id',testCase.id);

        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        
        OEBS_ReleaseOrderPageController controller = new OEBS_ReleaseOrderPageController(stdController);
        
        PageReference result;
        test.startTest();
            result = controller.abort();
        test.stopTest();
        
        system.assertEquals(new PageReference('/' + testCase.id).getUrl(), result.getUrl());
    }
    
    
    static testMethod void abort_2() {
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Submission_place__c = testunit.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        upsert testCase;
        
        test.setCurrentPageReference(new PageReference('OEBS_ReleaseOrderPage'));
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        
        OEBS_ReleaseOrderPageController controller = new OEBS_ReleaseOrderPageController(stdController);
                
        PageReference result;
        test.startTest();
            result = controller.abort();
        test.stopTest();
        
        
        system.assertEquals(new PageReference('/home/home.jsp').getUrl(), result.getUrl());
    }
    
    static testMethod void saveAndGoToCase_1() {
        Case testCase = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Submission_place__c = testunit.id,
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
        upsert testCase;
        
        test.setCurrentPageReference(new PageReference('OEBS_ReleaseOrderPage'));
        
        ApexPages.currentPage().getParameters().put('id',testCase.id);

        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        
        OEBS_ReleaseOrderPageController controller = new OEBS_ReleaseOrderPageController(stdController);
        
        PageReference result;
        test.startTest();
            result = controller.saveAndGoToCase();
        test.stopTest();
        
        system.assertEquals(new PageReference('/' + testCase.id).getUrl(), result.getUrl());
    }
}