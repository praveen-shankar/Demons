@isTest
private class zzz_Lightuser_ReportWizardController {

    static testMethod void testLightuser_ReportWizardController() {
        test.setCurrentPageReference(new PageReference('Lightuser_ReportWizard'));

        Lightuser_ReportWizardController result;
        
        test.startTest();
            result = new Lightuser_ReportWizardController();
        test.stopTest();
        
        system.assertNotEquals(null, result.searchParameterHolder);
        system.assertNotEquals(null, result.caseList);
        system.assertEquals(true, result.caseList.isEmpty());
    }
    
    static testMethod void testClearSearch() {
        test.setCurrentPageReference(new PageReference('Lightuser_ReportWizard'));
        
        Lightuser_ReportWizardController lrwc = new Lightuser_ReportWizardController();
            lrwc.caseList.add(new Case());
            lrwc.caseList.add(new Case());
            lrwc.caseList.add(new Case());
        
        test.startTest();
            lrwc.clearSearch();
        test.stopTest();
        
        system.assertEquals(true, lrwc.caseList.isEmpty());
    }
    
    static testMethod void testExportResultToExcel() {
        test.setCurrentPageReference(new PageReference('Lightuser_ReportWizard'));
        
        Lightuser_ReportWizardController lrwc = new Lightuser_ReportWizardController();
        PageReference result;
        
        test.startTest();
            result = lrwc.exportResultToExcel();
        test.stopTest();
        
        system.assertNotEquals(null, result);
    }
    
    static testMethod void testSearchForCases() {
        PostalUnit__c pu = new PostalUnit__c();
            pu.level_in_hierarchy__c = 9;
            pu.unit_name__c = 'Test Unit';
            pu.DRM_id__c = '1234';
            pu.unit_number__c = '1234';
        upsert pu;
        list<Case> newCaseList = new list<Case>(); 
        for(integer i = 0; i < 21; i++) {
            Case testCase = new Case();
            testCase.RecordTypeId = KATSutilities.getRecordType('deviation_case');
            testCase.deviation_postal_nmb_from__c = '1234';
            testCase.deviation_postal_nmb_to__c = '4321';
            //testCase.deviation_depature_spread__c = 'Spredning';
            //Cspahsse2 Supriya 29122016
             testCase.deviation_depature_spread__c = 'Spreading';
            testCase.Created_by_Unit__c = pu.id;
            newCaseList.add(testCase);
        }
        upsert newCaseList;
        
        
        test.setCurrentPageReference(new PageReference('Lightuser_ReportWizard'));
        Lightuser_ReportWizardController lrwc = new Lightuser_ReportWizardController();
        
        test.startTest();
            lrwc.searchForCases();
        test.stopTest();
        
        system.assertEquals(20, lrwc.caseList.size());
    }
    
    static testMethod void testSearchCases() {
        PostalUnit__c pu = new PostalUnit__c();
            pu.level_in_hierarchy__c = 9;
            pu.unit_name__c = 'Test Unit';
            pu.DRM_id__c = '1234';
            pu.unit_number__c = '1234';
        upsert pu;
        
        Case testCase = new Case();
            testCase.RecordTypeId = KATSutilities.getRecordType('deviation_case');
            testCase.deviation_postal_nmb_from__c = '1234';
            testCase.deviation_postal_nmb_to__c = '4321';
            //testCase.deviation_depature_spread__c = 'Spredning';
            //Cspahsse2 Supriya 29122016
             testCase.deviation_depature_spread__c = 'Spreading';
            testCase.Created_by_Unit__c = pu.id;
        insert testCase;
        
        test.setCurrentPageReference(new PageReference('Lightuser_ReportWizard'));

        Lightuser_ReportWizardController lrwc = new Lightuser_ReportWizardController();

        List<Case> resultList;
        test.startTest();
            lrwc.searchParameterHolder.deviation_postal_nmb_from__c = '0123';
            lrwc.searchParameterHolder.deviation_postal_nmb_to__c = '5432';
            //lrwc.searchParameterHolder.deviation_depature_spread__c = 'Spredning';
            //Cspahsse2 Supriya 29122016
            lrwc.searchParameterHolder.deviation_depature_spread__c = 'Spreading';
            
            resultList = lrwc.searchCases(2);
        test.stopTest();
        
        system.assertEquals(1, resultList.size());
    }
    static testMethod void testSearchCases_2() {
        PostalUnit__c pu = new PostalUnit__c();
            pu.level_in_hierarchy__c = 9;
            pu.unit_name__c = 'Test Unit';
            pu.DRM_id__c = '1234';
            pu.unit_number__c = '1234';
        upsert pu;
        
        Case testCase = new Case();
            testCase.RecordTypeId = KATSutilities.getRecordType('deviation_case');
            testCase.deviation_postal_nmb_from__c = '1200';
            testCase.deviation_postal_nmb_to__c = '1210';
           //testCase.deviation_depature_spread__c = 'Spredning';
            //Cspahsse2 Supriya 29122016
             testCase.deviation_depature_spread__c = 'Spreading';
            testCase.Created_by_Unit__c = pu.id;
        insert testCase;
        
        test.setCurrentPageReference(new PageReference('Lightuser_ReportWizard'));

        Lightuser_ReportWizardController lrwc = new Lightuser_ReportWizardController();

        List<Case> resultList;
       
            lrwc.deviation_postal_nmb_range = '1190-1210';
            
            resultList = lrwc.searchCases(2);
      
        
        system.assertEquals(1, resultList.size());
        
    }
     static testMethod void testSearchCases_3() {
        PostalUnit__c pu = new PostalUnit__c();
            pu.level_in_hierarchy__c = 9;
            pu.unit_name__c = 'Test Unit';
            pu.DRM_id__c = '1234';
            pu.unit_number__c = '1234';
        upsert pu;
        
        Case testCase = new Case();
            testCase.RecordTypeId = KATSutilities.getRecordType('deviation_case');
            testCase.deviation_postal_nmb_from__c = '1200';
            testCase.deviation_postal_nmb_to__c = '1210';
            testCase.deviation_affected_postal_nmb__c='1201';
           //testCase.deviation_depature_spread__c = 'Spredning';
            //Cspahsse2 Supriya 29122016
             testCase.deviation_depature_spread__c = 'Spreading';
            testCase.Created_by_Unit__c = pu.id;
        insert testCase;
        
         Case testCase2 = new Case();
            testCase2.RecordTypeId = KATSutilities.getRecordType('deviation_case');
            testCase2.deviation_postal_nmb_from__c = '';
            testCase2.deviation_postal_nmb_to__c = '';
            testCase2.deviation_affected_postal_nmb__c='1599';
            //testCase2.deviation_depature_spread__c = 'Spredning';
            //Cspahsse2 Supriya 29122016
             testCase2.deviation_depature_spread__c = 'Spreading';
            testCase2.Created_by_Unit__c = pu.id;
        insert testCase2;
        
        test.setCurrentPageReference(new PageReference('Lightuser_ReportWizard'));

        Lightuser_ReportWizardController lrwc = new Lightuser_ReportWizardController();

        List<Case> resultList;
       
            lrwc.deviation_postal_nmb_range = '1201,1599';
            
            resultList = lrwc.searchCases(2);
      
        
        system.assertEquals(2, resultList.size());
        
    }

    static testMethod void testSearchCases_4() {
        PostalUnit__c pu = new PostalUnit__c();
            pu.level_in_hierarchy__c = 9;
            pu.unit_name__c = 'Test Unit';
            pu.DRM_id__c = '1234';
            pu.unit_number__c = '1234';
        upsert pu;
        
        Case testCase = new Case();
            testCase.RecordTypeId = KATSutilities.getRecordType('deviation_case');
            testCase.deviation_postal_nmb_from__c = '1200';
            testCase.deviation_postal_nmb_to__c = '1210';
            testCase.deviation_affected_postal_nmb__c='1201';
           //testCase.deviation_depature_spread__c = 'Spredning';
            //Cspahsse2 Supriya 29122016
             testCase.deviation_depature_spread__c = 'Spreading';
            testCase.Created_by_Unit__c = pu.id;
        insert testCase;
        
         Case testCase2 = new Case();
            testCase2.RecordTypeId = KATSutilities.getRecordType('deviation_case');
            testCase2.deviation_postal_nmb_from__c = '';
            testCase2.deviation_postal_nmb_to__c = '';
            testCase2.deviation_affected_postal_nmb__c='1599';
            //testCase2.deviation_depature_spread__c = 'Spredning';
            //Cspahsse2 Supriya 29122016
             testCase2.deviation_depature_spread__c = 'Spreading';
            testCase2.Created_by_Unit__c = pu.id;
        insert testCase2;
        
        test.setCurrentPageReference(new PageReference('Lightuser_ReportWizard'));

        Lightuser_ReportWizardController lrwc = new Lightuser_ReportWizardController();

        List<Case> resultList;
       
            lrwc.deviation_postal_nmb_range = '1599';
            
            resultList = lrwc.searchCases(1);
      
        
        system.assertEquals(1, resultList.size());
        
    }

    static testMethod void testSearchCases_5() {
        PostalUnit__c pu = new PostalUnit__c();
            pu.level_in_hierarchy__c = 9;
            pu.unit_name__c = 'Test Unit';
            pu.DRM_id__c = '1234';
            pu.unit_number__c = '1234';
        upsert pu;

        Date fDate1 = Date.newInstance(2015,12,01);
        
        Case testCase = new Case();
            testCase.RecordTypeId = KATSutilities.getRecordType('deviation_case');
            testCase.deviation_postal_nmb_from__c = '1200';
            testCase.deviation_postal_nmb_to__c = '1210';
            testCase.deviation_affected_postal_nmb__c='1201';
            //testCase.deviation_depature_spread__c = 'Spredning';
            //Cspahsse2 Supriya 29122016
            testCase.deviation_depature_spread__c = 'Spreading';
            testCase.deviation_time_of_incident__c = fDate1;
            testCase.Created_by_Unit__c = pu.id;
        insert testCase;
        
        test.setCurrentPageReference(new PageReference('Lightuser_ReportWizard'));

        Lightuser_ReportWizardController lrwc = new Lightuser_ReportWizardController();

        List<Case> resultList;

            lrwc.proxy.deviation_time_of_incident__c = Date.newInstance(2015,12,01);
            
            resultList = lrwc.searchCases(1);
      
        
        system.assertEquals(1, resultList.size());
        
    }
    
    static testMethod void testaddSearchTerm(){
      Lightuser_ReportWizardController lrwc = new Lightuser_ReportWizardController();
        String query='SELECT id FROM case WHERE something=something';
        String term='something else=something else';
        query=lrwc.addSearchTerm(query, term);
        system.assertEquals(query, 'SELECT id FROM case WHERE something=something AND something else=something else');
        
    }
    
}