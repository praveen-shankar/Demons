/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class zzz_Case_ShipmentImportWizardController {
    static Case_ShipmentImportWizardController ctrl;
    static Attachment csvFile;
    
    static testMethod void testSelectOptionHelperClass() {
        Map<String, String> fieldNames = new Map<String, String> {
            'Subject'   =>  'Subject',
            'Description' => 'Description'
        };
        Case_ShipmentImportWizardController.SelectOptionHelper selectOptionHelper = new Case_ShipmentImportWizardController.SelectOptionHelper(fieldNames);
        
    }
    
    static testMethod void testStep1() {
                Case c = new Case();
        upsert c;
        
        c = [SELECT id, caseNumber FROM Case WHERE id = :c.Id LIMIT 1];
        ApexPages.currentPage().getParameters().put('case', c.Id);
                ctrl = new Case_ShipmentImportWizardController();
        
        
        csvFile = new Attachment();
        
        csvFile.Body = Blob.valueOf('Subject;Description\nhei;hei;');
        csvFile.ContentType = 'application/csv';
        ctrl.csvFile = csvFile;
        ctrl.step1();
    }
    
    static testMethod void testStep2() {
        Case c = new Case();
        upsert c;
        
        c = [SELECT id, caseNumber FROM Case WHERE id = :c.Id LIMIT 1];
        ApexPages.currentPage().getParameters().put('case', c.Id);
                ctrl = new Case_ShipmentImportWizardController();
        
        
        csvFile = new Attachment();
        
        csvFile.Body = Blob.valueOf('Subject;Description\nhei;hei');
        csvFile.ContentType = 'application/csv';
        ctrl.csvFile = csvFile;
        Test.startTest();

        ApexPages.currentPage().getParameters().put('case', c.Id);
        ctrl.step2();
        
        Test.stopTest();
    }
    
    static testMethod void testStep3() {
                Case c = new Case();
        upsert c;
        
        // Custom Settings Record to be Added
        environment_settings__c es1 = new environment_settings__c();
        es1.Name = 'ImportShipmentOrigin';
        es1.value__c = 'Import';
        es1.Description__c = 'Test Setup Value';
        Database.insert(es1);

        c = [SELECT id, caseNumber FROM Case WHERE id = :c.Id LIMIT 1];
        Test.startTest();
        ApexPages.currentPage().getParameters().put('case', c.Id);
                ctrl = new Case_ShipmentImportWizardController();
        
        
        csvFile = new Attachment();
        
        csvFile.Body = Blob.valueOf('Avsender;Mottaker\nAvsenders navn;Mottakers navn');
        // TODO: håndtere at noen rader har flere verdier enn andre, dvs inneholder ; for mye
        csvFile.ContentType = 'application/csv';
        ctrl.csvFile = csvFile;

        ApexPages.currentPage().getParameters().put('case', c.Id);
        ctrl.step2();
        ApexPages.currentPage().getParameters().put('case', c.Id);
        
        //System.assertNotEquals(ctrl.selectOptionHelpers, null);

        ctrl.selectOptionHelpers.get(0).selectedFieldName = 'shipper_name__c';
        ctrl.selectOptionHelpers.get(1).selectedFieldName = 'reciever_name__c';
        
        ctrl.step3();
        Test.stopTest();
        
        //System.assertEquals('Avsenders navn', ctrl.cases.get(0).shipper_name__c);
        //ctrl.saveShipmentCases();
        List<Case> cases = [select Id, shipper_name__c, reciever_name__c from Case where ParentId = :c.Id];
        //System.assertEquals('Mottakers navn', cases.get(0).reciever_name__c);
        //System.assertEquals('Avsenders navn', cases.get(0).shipper_name__c);
        
    }

    static testMethod void testStep2Negative() {
        Case c = new Case();
        upsert c;
        
        c = [SELECT id, caseNumber FROM Case WHERE id = :c.Id LIMIT 1];
        ApexPages.currentPage().getParameters().put('case', c.Id);
                ctrl = new Case_ShipmentImportWizardController();
        
        
        csvFile = new Attachment();
        
        csvFile.Body = Blob.valueOf('Subject;Description\nhei;hei');
        csvFile.ContentType = 'text';
        ctrl.csvFile = csvFile;
        Test.startTest();

        ApexPages.currentPage().getParameters().put('case', c.CaseNumber);
        ctrl.step2();
        
        Test.stopTest();
    }
}