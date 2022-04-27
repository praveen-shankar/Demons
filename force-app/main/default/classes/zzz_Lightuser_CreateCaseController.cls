//Added as a part of P3CRM-Sales project, removing reference from standard Product Object
//to custom Service Product object. Change by Rajeev on 13th July 2016
// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest
private class zzz_Lightuser_CreateCaseController
{
    
     static testMethod void createCustomSetting() {
        List<cs_CaseRecordTypeToEnquiryTypMap__c> lcs = new List<cs_CaseRecordTypeToEnquiryTypMap__c>();
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs1 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs1.Name = 'campaign';
        cs1.cs_Code_Event_Api__c =' Kampanje';
        lcs.add(cs1);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs2 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs2.Name = 'Cargo_Claims';
        cs2.cs_Code_Event_Api__c ='Reklamasjon Gods';
        lcs.add(cs2);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs3 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs3.Name = 'complaint';
        cs3.cs_Code_Event_Api__c =' Klage';
        lcs.add(cs3);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs4 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs4.Name = 'deviation_case';
        cs4.cs_Code_Event_Api__c =' Avvik';
        lcs.add(cs4);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs5 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs5.Name = 'distribution_plan_case';
        cs5.cs_Code_Event_Api__c =' Avtale';
        lcs.add(cs5);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs6 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs6.Name = 'Gjenligg';
        cs6.cs_Code_Event_Api__c =' Gjenligg';
        lcs.add(cs6);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs7 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs7.Name = 'internal_support    ';
        cs7.cs_Code_Event_Api__c =' Internsupport';
        lcs.add(cs7);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs8 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs8.Name = 'Internsupport';
        cs8.cs_Code_Event_Api__c =' Avvik';
        lcs.add(cs8);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs9 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs9.Name = 'planned_distribution_case';
        cs9.cs_Code_Event_Api__c =' Bestillinger';
        lcs.add(cs9);
        
        cs_CaseRecordTypeToEnquiryTypMap__c cs10 = new cs_CaseRecordTypeToEnquiryTypMap__c();
        cs10.Name = 'simple_inquiry';
        cs10.cs_Code_Event_Api__c ='Rådgivning/Informasjon';
        lcs.add(cs10);
        
        
        
        insert lcs;
        
        
        
        
}
    
    private static Service_Product__c testproductFam = createTestProductFamily();
    private static Service_Product__c testproduct = createTestProduct(testproductFam);
    private static Code_Reason1__c testReason=createTestReason();
    private static Code_Reason2__c testReason2 = createTestReason2();
    
    // This test methods will cover the situations where the user will try to Save the Case
    // But due to missing information errors will be displayed.
    // This code will cover the validation handling portion of the code
    static testMethod void TestLightuser_ValidationCoverage()
    {
        createCustomSetting();
        // Creating Code Event Record
        Code_Event__c ce1 = new Code_Event__c(Name='MyTestEvent');
        ce1.CaseTypeMultiselect__c = 'Avvik';
        //Cspahse2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Deviation';
        ce1.IsActive__c = true;
        insert ce1;
        

        
        // Creating Code Event Record
        Code_Event__c ce2 = new Code_Event__c(Name='avvik som skal krediteres');
        ce2.CaseTypeMultiselect__c = 'Avvik';
       //Cspahse2 Supriya 29122016
       // ce1.CaseTypeMultiselect__c = 'Deviation';
        ce2.IsActive__c = true;
        insert ce2;        

        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId);
        insert pf1;


        // Creating Product Record
        Id prodRecId = KATSutilities.getRecordType('Product');
        RecordType rcdtyp = [select id , developerName from RecordType where developerName = 'Product' and sobjectType = 'Service_Product__c' limit 1];
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', Produktfamilie__c = pf1.id, recordTypeId = rcdtyp.id, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);
        insert p1;       

        // Creating Code Reason 1 Record
        Code_Reason1__c cr1 = new Code_Reason1__c(Name='MyTestReason1');
        insert cr1;

        // Creating Code Reason 2 Record
        Code_Reason2__c cr2 = new Code_Reason2__c(Name='MyTestReason2');
        insert cr2;

        // Creating setup for Code Event and Product
        Code_Event_Prod__c cep1 = new Code_Event_Prod__c();
        cep1.Code_Event__c = ce1.id;
        cep1.Service_Product__c = p1.id;
        cep1.IsActive__c = true;
        database.insert(cep1);

        // Creating setup for Product and Code Reason 1
        CodeProdReason__c cpr1 = new CodeProdReason__c();
        cpr1.Henvendelsestype__c = ce1.id;
        cpr1.Service_Product__c = p1.id;
        cpr1.Code_reason1__c = cr1.id;
        cpr1.IsActive__c = true;
        database.insert(cpr1);


        // Creating setup for Code Reason 1 and Code Reason 2
        Code_Reason_12__c cr12 = new Code_Reason_12__c();
        cr12.Code_reason1__c = cr1.Id;
        cr12.Code_reason2__c = cr2.Id;
        cr12.Service_Product__c = p1.id;
        database.insert(cr12);

        // Create Controller for this Lightuser Create Case page
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);

        Test.startTest();

        Case c1 = new Case();
        c1.recordTypeId = KATSutilities.getRecordType('complaint');
        c1.Status = 'Ny';

        Lightuser_CreateCaseController lc = new Lightuser_CreateCaseController(new ApexPages.StandardController(c1));

        // Here we set the values first to populate the Maps we need later before saving
        lc.eventId = ce1.id;
        lc.productFamily = pf1.id;
        lc.productId = p1.id;
        lc.reason1Id = cr1.id;
        lc.reason2Id = cr2.id;

        lc.getEventOpts();
        lc.getProductFamiliesOpts();
        lc.getProductOpts();
        lc.getReason1Opts();
        lc.getReason2Opts();

        lc.productFamily = null;
        lc.productId = null;
        lc.reason1Id = null;
        lc.reason2Id = null;

        // Testing when EventId is null
        lc.eventId = null;
        lc.saveCase();

        lc.eventId = ce1.id;

        // Testing when Product Family is null
        lc.productFamily = null;
        lc.saveCase();

        lc.productFamily = pf1.id;

        // Testing when Product is null
        lc.productId = null;
        lc.saveCase();

        lc.productId = p1.id;

        // Testing when Reason 1 (Arsak1) is null
        lc.reason1Id = null;
        lc.saveCase();

        lc.reason1Id = 'NO_REASON1';
        lc.saveCase();

        lc.reason1Id = cr1.id;

        // Testing when Reason2 (Arsak2) is null
        lc.reason2Id = null;
        lc.saveCase();

        lc.reason2Id = cr2.id;
        lc.saveCase();

        // Add a non-existent Postal Unit
        lc.pu_to_blame = new PostalUnit__c(Name = 'Postal Unit') ;
        lc.saveCase();

        // Testing for new Code_Event: avvik som skal krediteres
        lc.eventId = ce2.id;
        //lc.saveCase();
        

        Test.stopTest();
    }



    // This test method will try to cover all the sections under the functions returning select options
    static testMethod void TestLightuser_SelectOptionCoverage()
    {
        createCustomSetting();
        // Creating Code Event Record
        Code_Event__c ce1 = new Code_Event__c(Name='MyTestEvent');
        ce1.CaseTypeMultiselect__c = 'Klage';
        //Cspahse2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;

        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release

        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId);
        insert pf1;


        // Creating Product Record
        Id prodRecId = KATSutilities.getRecordType('Product');
        RecordType rcdtyp = [select id , developerName from RecordType where developerName = 'Product' and sobjectType = 'Service_Product__c' limit 1];
        Service_Product__c p1 = new Service_Product__c(Name='MyTestProduct', recordTypeId = rcdtyp.id, check_kollinummer__c = true, check_adresseendring__c = true, check_fakturanummer__c = true);
        insert p1;       

        // Creating Code Reason 1 Record
        Code_Reason1__c cr1 = new Code_Reason1__c(Name='MyTestReason1');
        insert cr1;

        // Creating Code Reason 2 Record
        Code_Reason2__c cr2 = new Code_Reason2__c(Name='MyTestReason2');
        insert cr2;

        // Create Controller for this Lightuser Create Case page
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);

        Test.startTest();

        Lightuser_CreateCaseController lc = new Lightuser_CreateCaseController(new ApexPages.StandardController(new Case()));

        // getProductFamiliesOpts coverage
        // ------------------------------------------------------------------------------------------------------------------------
        lc.eventId = null;
        lc.getEventOpts();
        lc.getProductFamiliesOpts();

        // Now we will have an event id, but there are not linkage between the selected Event Id and Products
        lc.eventId = ce1.id;
        lc.getProductFamiliesOpts();
        lc.getProductOpts();

        // Creating setup for Code Event and Product
        Code_Event_Prod__c cep1 = new Code_Event_Prod__c();
        cep1.Code_Event__c = ce1.id;
        cep1.Service_Product__c = p1.id;
        cep1.IsActive__c = true;
        database.insert(cep1);
        lc.getProductFamiliesOpts();

        p1.Produktfamilie__c = pf1.id;
        database.update(p1);
        lc.getProductFamiliesOpts();



        // getProductOpts coverage
        // ------------------------------------------------------------------------------------------------------------------------
        // Testing when there is no Product Family Selected
        lc.productFamily = null;
        lc.getProductOpts();
        lc.getReason1Opts();

        // Now we test after the user has selected the Product Family
        lc.productFamily = pf1.id;
        lc.productId = 'NO_PRODUKT';
        lc.getProductOpts();
        lc.getReason1Opts();

        // getReason1Opts coverage
        // ------------------------------------------------------------------------------------------------------------------------
        // First with no Product Selected
        lc.productId = 'NO_PRODUKT';
        lc.getReason1Opts();

        // Next with Product Selected but no setup linkage
        lc.productId = p1.id;
        lc.getReason1Opts();

        // Creating setup for Product and Code Reason 1
        CodeProdReason__c cpr1 = new CodeProdReason__c();
        cpr1.Henvendelsestype__c = ce1.id;
        cpr1.Service_Product__c = p1.id;
        cpr1.Code_reason1__c = cr1.id;
        cpr1.IsActive__c = true;
        database.insert(cpr1);

        // Now with the setup
        lc.getReason1Opts();


        // getReason2Opts coverage
        // ------------------------------------------------------------------------------------------------------------------------
        // First we check without selecting Arsak1
        lc.reason1Id = null;
        lc.getReason2Opts();

        // Next we test with No values selected
        lc.reason1Id = 'NO_REASON1';
        lc.getReason2Opts();

        // Next we test with Reason 1 (Arsak1) selected by no setup
        lc.reason1Id = cr1.id;
        lc.getReason2Opts();


        // Creating setup for Code Reason 1 and Code Reason 2
        Code_Reason_12__c cr12 = new Code_Reason_12__c();
        cr12.Code_reason1__c = cr1.Id;
        cr12.Code_reason2__c = cr2.Id;
        cr12.Service_Product__c = p1.id;
        database.insert(cr12);

        // Last we test with setup
        lc.getReason2Opts();        

        Test.stopTest();

    }



    //Testing creation of Case Controller with basic information
    static testMethod void TestLightuser_CreateCaseController_1() 
    {
        createCustomSetting();
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        
        Lightuser_CreateCaseController lc;
        Test.startTest();
             lc = new Lightuser_CreateCaseController(new ApexPages.StandardController(new Case()));
        Test.stopTest();
        
        system.assertEquals(null, lc.acct);
        system.assertEquals(null, lc.customerName);
        system.assertEquals(null, lc.customerNumber);
        system.assertNotEquals(null, lc.pu);
    }
    
    //Testing page buildup based on some input paramters
    static testMethod void TestLightuser_CreateCaseController_2() 
    {
        createCustomSetting();
        Code_Event__c ce=new Code_Event__c(Name= 'Avvik');
        ce.CaseTypeMultiselect__c = 'Gjenligg;Avvik';
        //Cspahse2 supriya 29122016
         //ce.CaseTypeMultiselect__c = 'Undelivered Mail;Deviation';
        ce.IsActive__c = true;
        insert ce;      
        
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', 'testUnit');
        ApexPages.currentPage().getParameters().put('record', KATSutilities.getRecordType('deviation_case'));
        ApexPages.currentPage().getParameters().put('user', 'testUser');
        ApexPages.currentPage().getParameters().put('prod', testproduct.id);
        ApexPages.currentPage().getParameters().put('kat',ce.Id);
          
        Lightuser_CreateCaseController lc;
        Test.startTest();
             lc = new Lightuser_CreateCaseController(new ApexPages.StandardController(new Case()));
        Test.stopTest();
        
        system.assertEquals(null, lc.acct);
        system.assertEquals(null, lc.customerName);
        system.assertEquals(null, lc.customerNumber);
        system.assertEquals('testUnit', lc.pu.Name);
    }
    
    //Testing if the Postal Unit selected is a Valid Postal Unit or not. This should FAIL as no unit exists in database.
    static testMethod void TestIsPostalUnitValid_1() 
    {
        createCustomSetting();
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        Lightuser_CreateCaseController lc = new Lightuser_CreateCaseController(new ApexPages.StandardController(new Case()));
        
        lc.pu.Name = 'testUnit';
        
        Boolean result = false;
        
        Test.startTest();
            result = lc.isPostalUnitValid(lc.pu);
        Test.stopTest();
        
        system.assertEquals(false, result);
    }
    
    //Testing if the Postal Unit selected is a Valid Postal Unit or not. This should PASS as unit exists in database.
    static testMethod void TestIsPostalUnitValid_2() 
    {
        createCustomSetting();
        PostalUnit__c pu = new PostalUnit__c();
        pu.name = 'testUnit';
        pu.unit_number__c = '1234';
        upsert pu;
        
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', pu.Name);
        Lightuser_CreateCaseController lc = new Lightuser_CreateCaseController(new ApexPages.StandardController(new Case()));
        
        Boolean result = false;
        
        Test.startTest();
            result = lc.isPostalUnitValid(lc.pu);
        Test.stopTest();
        
        system.assertEquals(true, result);
    }
    
    //Testing if the Postal Unit selected is a Valid Postal Unit or not. This should FAIL as multiple units exist in database with same name.
    static testMethod void TestIsPostalUnitValid_3() 
    {
        createCustomSetting();
        PostalUnit__c pu = new PostalUnit__c();
        pu.name = 'testUnit';
        pu.unit_number__c = '1234';
        pu.DRM_id__c = '1';
        upsert pu;
        
        PostalUnit__c pu2 = new PostalUnit__c();
        pu2.name = 'testUnit';
        pu2.unit_number__c = '1235';
        pu.DRM_id__c = '2';
        upsert pu2;
        
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', pu.Name);
        Lightuser_CreateCaseController lc = new Lightuser_CreateCaseController(new ApexPages.StandardController(new Case()));
        
        Boolean result = false;
        
        Test.startTest();
            result = lc.isPostalUnitValid(lc.pu);
        Test.stopTest();
        
        system.assertEquals(false, result);
    }
    
    
    //This function will check the validation function with no information provided in the Page. This should FAIL and return false.
    static testMethod void TestIsValidFields_1() 
    {
        createCustomSetting();
        Case c = new Case();
        
        Lightuser_CreateCaseController lc = new Lightuser_CreateCaseController(new ApexPages.StandardController(c));

        Boolean result = false;
        Test.startTest();
            result = lc.isValidFields();
        Test.stopTest();
        
        //system.assertEquals(false, result);
    }
    
    
     //This function will check the validation function with basic required information provided in the Page. This should PASS and return true.
    static testMethod void TestIsValidFields_2() 
    {
        createCustomSetting();
        Code_Event__c ce=new Code_Event__c(Name='Distribusjon');
        insert ce;
        Case c = new Case();
        c.Type__c = 'type';
        c.Service_Product__c = testproduct.id;
        c.Code_Event__c = ce.id;
        c.Code_Reason1__c =testReason.id;
        c.measures__c = 'test';
        c.deviation_route__c = 'test';
        c.deviation_postal_nmb_from__c = 'test';
        c.deviation_postal_nmb_to__c = 'test';
        c.deviation_nmb_households__c = 2;
        c.deviation_affected_address__c = 'test';
        c.Description= 'Description';
        
        PostalUnit__c pu = new PostalUnit__c();
        pu.name = 'testUnit';
        pu.unit_number__c = '1234';
        pu.DRM_id__c = '1';
        upsert pu;
        
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', pu.Name);
        ApexPages.currentPage().getParameters().put('record', KATSutilities.getRecordType('deviation_case'));
        ApexPages.currentPage().getParameters().put('user', 'Test User');
        
        Lightuser_CreateCaseController lc = createController(c, pu);
        
        Boolean result = false;
        Test.startTest();
            result = lc.isValidFields();
        Test.stopTest();
        system.debug(lc);
        //system.assertEquals(true, result);
    }
    
    static testMethod void TestIsValidFields_3() {
        createCustomSetting();
        Code_Event__c ce=new Code_Event__c(Name='Avvik');
        insert ce;
        Case c = new Case();
            c.Type__c = 'type';
            c.Service_Product__c = testproduct.id;
            c.Code_Event__c = ce.id;
            c.Code_Reason1__c =testReason.id;
            c.measures__c = 'test';
            c.Subject = 'subject';
            c.Description= 'Description';
        
        PostalUnit__c pu = new PostalUnit__c();
        pu.name = 'testUnit';
        pu.unit_number__c = '1234';
        pu.DRM_id__c = '1';
        upsert pu;
        
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', pu.Name);
        ApexPages.currentPage().getParameters().put('record', KATSutilities.getRecordType('deviation_case'));
        ApexPages.currentPage().getParameters().put('user', 'Test User');
        
        Lightuser_CreateCaseController lc = createController(c, pu);
        
        Boolean result = false;
        Test.startTest();
            result = lc.isValidFields();
        Test.stopTest();
        
        //system.assertEquals(true, result);
    }
    
    static testMethod void TestIsValidFields_4() {
        createCustomSetting();
        Code_Event__c ce=new Code_Event__c(Name='Terminal');
        insert ce;
        Case c = new Case();
            c.Type__c = 'type';
            c.Produkt__c = 'test';
            c.Code_Event__c = ce.id;
            c.Code_Reason1__c =testReason.id;
            c.measures__c = 'test';
            c.deviation_route__c = 'test';
            c.Letter_priority__c = 'test';
            c.deviation_depature_spread__c = 'test';
            c.deviation_shipments_nmb__c = 2;
            c.Description= 'Description';
        
        PostalUnit__c pu = new PostalUnit__c();
        pu.name = 'testUnit';
        pu.unit_number__c = '1234';
        pu.DRM_id__c = '1';
        upsert pu;
        
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', pu.Name);
        ApexPages.currentPage().getParameters().put('record', KATSutilities.getRecordType('deviation_case'));
        ApexPages.currentPage().getParameters().put('user', 'Test User');
        
        Lightuser_CreateCaseController lc = createController(c, pu);
        
        Boolean result = false;
        Test.startTest();
            result = lc.isValidFields();
        Test.stopTest();
        
        //system.assertEquals(true, result);
    }
    
    
    /** Check is these validations still are useful
     * 
     * 
    //Test validation of deviation_affected_address__c
    //Should be required if category__c dosen't contains "gjenligg"
    static testMethod void TestIsValidFields_5() {
        Code_Event__c ce=new Code_Event__c(Name='Distribusjon test');
        insert ce;
        Case c = new Case();
            c.Type__c = 'type';
            c.Service_Product__c = testproduct.id;
            c.Code_Event__c = ce.id;
            c.Code_Reason1__c =testReason.id;
            c.measures__c = 'test';
            c.deviation_route__c = 'test';
            c.deviation_postal_nmb_from__c = 'test';
            c.deviation_postal_nmb_to__c = 'test';
            c.deviation_nmb_households__c = 2;
            c.Description= 'Description';
        
        PostalUnit__c pu = new PostalUnit__c();
        pu.name = 'testUnit';
        pu.unit_number__c = '1234';
        pu.DRM_id__c = '1';
        upsert pu;
        
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', pu.Name);
        ApexPages.currentPage().getParameters().put('record', KATSutilities.getRecordType('deviation_case'));
        ApexPages.currentPage().getParameters().put('user', 'Test User');
        ApexPages.currentPage().getParameters().put('kat', ce.id);
        Lightuser_CreateCaseController lc = createController(c, pu);
        Lightuser_CreateCaseController.eventName=ce.name;
        Boolean result = false;
        Test.startTest();
            result = lc.isValidFields();
        Test.stopTest();
        
        system.assertEquals(false, result);
    }
    */
    //Test validation of deviation_affected_address__c
    //Should not be required if category__c contains "gjenligg"
    static testMethod void TestIsValidFields_6() {
        createCustomSetting();
        Code_Event__c ce=new Code_Event__c(Name= 'Test Distribusjon Gjenligg');
        insert ce;
        Case c = new Case();
            c.Type__c = 'type';
            c.Service_Product__c = testproduct.id;
            c.Code_Event__c =ce.id;
           c.Code_Reason1__c =testReason.id;
            c.measures__c = 'test';
            c.deviation_route__c = 'test';
            c.deviation_postal_nmb_from__c = 'test';
            c.deviation_postal_nmb_to__c = 'test';
            c.deviation_nmb_households__c = 2;
            c.deviation_affected_address__c = 'test';
            c.Description= 'Description';
        
        PostalUnit__c pu = new PostalUnit__c();
        pu.name = 'testUnit';
        pu.unit_number__c = '1234';
        pu.DRM_id__c = '1';
        upsert pu;
        
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', pu.Name);
        ApexPages.currentPage().getParameters().put('record', KATSutilities.getRecordType('deviation_case'));
        ApexPages.currentPage().getParameters().put('user', 'Test User');
        
        Lightuser_CreateCaseController lc = createController(c, pu);
        
        Boolean result = false;
        Test.startTest();
            result = lc.isValidFields();
        Test.stopTest();
        
        //system.assertEquals(true, result);
    }
    
    static testMethod void TestSetPostalUnit_1() {
        createCustomSetting();
        Case c = new Case();
                
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', 'unit');
        ApexPages.currentPage().getParameters().put('record', KATSutilities.getRecordType('deviation_case'));
        ApexPages.currentPage().getParameters().put('user', 'Test User');
        
        Lightuser_CreateCaseController lc = createController(c, null);
        
        Id result;
        
        Test.startTest();
            result = lc.setPostalUnit(lc.pu);
        Test.stopTest();
        
        system.assertEquals(null, result);
    }
    
    static testMethod void TestSetPostalUnit_2() {
        createCustomSetting();
        Case c = new Case();
        
        PostalUnit__c pu = new PostalUnit__c();
        pu.name = 'testUnit';
        pu.unit_number__c = '1234';
        pu.DRM_id__c = '1';
        upsert pu;
        
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', pu.name);
        ApexPages.currentPage().getParameters().put('record', KATSutilities.getRecordType('deviation_case'));
        ApexPages.currentPage().getParameters().put('user', 'Test User');
        
        Lightuser_CreateCaseController lc = createController(c, pu);
        
        Id result;
        
        Test.startTest();
            result = lc.setPostalUnit(lc.pu);
        Test.stopTest();
        
        system.assertEquals(pu.id, result);
    }
    
    static testMethod void testSetAccount_1() {
        createCustomSetting();
        Case c = new Case();
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        Lightuser_CreateCaseController lc = createController(c, null);
        
        Id result;
        
        Test.startTest();
            result = lc.setAccount();
        Test.stopTest();
        
        system.assertEquals(null, result);
    }
    
    static testMethod void testSetAccount_2() {
        createCustomSetting();
        Case c = new Case();
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        Lightuser_CreateCaseController lc = createController(c, null);
        
        lc.customerNumber = '1234';
        
        Id result;
        
        Test.startTest();
            result = lc.setAccount();
        Test.stopTest();
        
        system.assertEquals(null, result);
    }
    
    static testMethod void testSetAccount_3() {
        createCustomSetting();
        crm_AccountRecordTypes__c rr = new crm_AccountRecordTypes__c();
        rr.Name = 'Relation level Customer';
        rr.crm_Record_Type_Label__c ='Relation level Customer';
        insert rr;
        Account acc = new Account();
            acc.Name = 'Test';
            acc.crm_customer_number__c = 'Test123';
        upsert acc;
        
        Case c = new Case();
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        Lightuser_CreateCaseController lc = createController(c, null);
        
        lc.customerNumber = '1234';
        
        Id result;
        
        Test.startTest();
            result = lc.setAccount();
        Test.stopTest();
        
        system.assertEquals(null, result);
    }
    
    static testMethod void testSetAccount_4() {
        createCustomSetting();
        crm_AccountRecordTypes__c rr = new crm_AccountRecordTypes__c();
        rr.Name = 'Relation level Customer';
        rr.crm_Record_Type_Label__c ='Relation level Customer';
        insert rr;
        Account acc = new Account();
            acc.Name = 'Test';
            acc.crm_customer_number__c = 'Test123';
        upsert acc;
        
        Case c = new Case();
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        Lightuser_CreateCaseController lc = createController(c, null);
        
        lc.customerNumber = acc.crm_customer_number__c;
        
        Id result;
        
        Test.startTest();
            result = lc.setAccount();
        Test.stopTest();
        
        system.assertEquals(acc.id, result);
    }
    
    static testMethod void testSaveCase_Avvik() 
    {
        createCustomSetting();
    crm_AccountRecordTypes__c rr = new crm_AccountRecordTypes__c();
        rr.Name = 'Relation level Customer';
        rr.crm_Record_Type_Label__c ='Relation level Customer';
        insert rr;
        Account acc = new Account();
        acc.Name = 'Test';
        acc.crm_customer_number__c = 'Test123';
        upsert acc;
        
        Code_Event__c ce=new Code_Event__c(Name= 'Avvik');
        ce.CaseTypeMultiselect__c = 'Gjenligg;Avvik';
        ce.IsActive__c = true;
        insert ce;
        
        Code_Event_Prod__c ce_Prod = new Code_Event_Prod__c();
        ce_Prod.Code_Event__c = ce.Id;
        ce_Prod.Service_Product__c = testproduct.id;
        ce_Prod.IsActive__c = true;
        database.insert(ce_Prod);
        
        CodeProdReason__c cpr = new CodeProdReason__c();
        cpr.Code_reason1__c = testReason.Id;
        cpr.Service_Product__c = testproduct.Id;
        database.insert(cpr);
        
        Code_Reason_12__c cr12 = new Code_Reason_12__c();
        cr12.Code_reason1__c = testReason.Id;
        cr12.Code_reason2__c = testReason2.Id;
        database.insert(cr12);
        
        Case c = new Case();
        c.RecordTypeId = KATSutilities.getRecordType('deviation_case');
        c.Created_by_Name__c = 'Test';
        c.Type__c = 'Registrert';
        c.Service_Product__c = testproduct.id;
        c.Code_Event__c = ce.id;
        c.Code_Reason1__c = testReason.id;
        c.measures__c = 'Test';
        c.subject = 'testSaveCase_4';
        c.description = 'Test case';
        database.insert(c);
        
        PostalUnit__c pu = new PostalUnit__c();
        pu.name = 'testUnit';
        pu.unit_number__c = '1234';
        pu.DRM_id__c = '1';
        upsert pu;
        
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', pu.Name);
        ApexPages.currentPage().getParameters().put('record', KATSutilities.getRecordType('deviation_case'));
        ApexPages.currentPage().getParameters().put('user', 'Test User');
        ApexPages.currentPage().getParameters().put('partyId', 'partyId');
        
        Lightuser_CreateCaseController lc = createController(c, pu);
        lc.customerNumber = acc.crm_customer_number__c;
        
        test.startTest();
        
        lc.getEventOpts();
        lc.getProductFamiliesOpts();        //Fail
        //lc.saveCase();                      //Will give an error and not save the case, as EventId is null
        
        lc.eventId = ce.id;
        
        //Running test on function setCaseCategory
        lc.setCaseCategory();
        
        lc.getProductFamiliesOpts();
        lc.getProductOpts();                //Fail
        //lc.saveCase();                      //Will give an error and not save, as the Product Family is null
        lc.productFamily = testproductFam.id;
        
        lc.getProductOpts();
        lc.getReason1Opts();                //Fail
        lc.productId = testproduct.Id;
        
        lc.getReason1Opts();
        lc.getReason2Opts();                //Fail
        //lc.saveCase();                      //Will give an error and not save, as the Reason 1 is null
        lc.reason1Id = testReason.id;
        
        lc.getReason2Opts();
        lc.reason2Id = null;
        
        PageReference result;
        
        
        
        //result = lc.saveCase();
        
        test.stopTest();
        
    }
    
    static testMethod void testSaveCase_Gjenligg() 
    {
        createCustomSetting();
    crm_AccountRecordTypes__c rr = new crm_AccountRecordTypes__c();
        rr.Name = 'Relation level Customer';
        rr.crm_Record_Type_Label__c ='Relation level Customer';
        insert rr;
        Account acc = new Account();
        acc.Name = 'Test';
        acc.crm_customer_number__c = 'Test123';
        //Dinesh , added line no.934 on 23 Feb 2017
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        upsert acc;
        
        Code_Event__c ce=new Code_Event__c(Name= 'Distribusjon');
        ce.CaseTypeMultiselect__c = 'Gjenligg;Avvik';
        //Cspahse2 Supriya 29122016
        //ce.CaseTypeMultiselect__c = 'Undelivered Mail;Deviation';
        ce.IsActive__c = true;
        insert ce;
        
        
        
        Code_Event__c ce2 = new Code_Event__c(Name= 'Terminal');
       ce2.CaseTypeMultiselect__c = 'Gjenligg;Avvik';
         //Cspahse2 Supriya 29122016
        //ce2.CaseTypeMultiselect__c = 'Undelivered Mail;Deviation';
        ce2.IsActive__c = true;
        insert ce2;
        
        
        Code_Event_Prod__c ce_Prod = new Code_Event_Prod__c();
        ce_Prod.Code_Event__c = ce.Id;
        ce_Prod.Service_Product__c = testproduct.id;
        ce_Prod.IsActive__c = true;
        database.insert(ce_Prod);
        
        CodeProdReason__c cpr = new CodeProdReason__c();
        cpr.Code_reason1__c = testReason.Id;
        cpr.Service_Product__c = testproduct.Id;
        database.insert(cpr);
        
        Code_Reason_12__c cr12 = new Code_Reason_12__c();
        cr12.Code_reason1__c = testReason.Id;
        cr12.Code_reason2__c = testReason2.Id;
        database.insert(cr12);
        
        Case c = new Case();
        c.RecordTypeId = KATSutilities.getRecordType('deviation_case');
        c.Created_by_Name__c = 'Test';
        c.Type__c = 'Registrert';
        
        c.Service_Product__c = testproduct.id;
        c.Code_Event__c = ce.id;
        c.Code_Reason1__c = testReason.id;
        c.Produkt__c = testproduct.Name;
        c.Category__c = ce.Name;
        c.reason__c = testReason.Name;
        c.subject = 'testSaveCase_4';
                
        PostalUnit__c pu = new PostalUnit__c();
        pu.name = 'testUnit';
        pu.unit_number__c = '1234';
        pu.DRM_id__c = '1';
        upsert pu;
        
        PageReference testPage = new PageReference('Lightuser_CreateCaseController');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('unit', pu.Name);
        ApexPages.currentPage().getParameters().put('record', KATSutilities.getRecordType('Gjenligg'));
        ApexPages.currentPage().getParameters().put('user', 'Test User');
        ApexPages.currentPage().getParameters().put('partyId', 'partyId');
        ApexPages.currentPage().getParameters().put('kat', ce.id);
        
        Lightuser_CreateCaseController lc = createController(c, pu);
        lc.customerNumber = acc.crm_customer_number__c;
        
        test.startTest();
        
        lc.getEventOpts();
        lc.eventId = ce.id;
        
        lc.getProductFamiliesOpts();
        lc.productFamily = testproductFam.id;
        
        lc.getProductOpts();
        lc.productId = testproduct.Id;
        
        lc.getReason1Opts();
        lc.reason1Id = testReason.id;
        
        lc.getReason2Opts();
        lc.reason2Id = null;
        
        PageReference result;
        
        result = lc.saveCase();
        
        c.measures__c = 'Test';         //Validation check for Measures
        result = lc.saveCase();
        
        lc.eventId = ce2.Id;            //Validation check for Henvendelsestyper - Terminal Gjenligg
        result = lc.saveCase();
        
        c.description = 'Test case';    //Validation check for missing Description
        result = lc.saveCase();
         
        test.stopTest();
        
        
    }
       
    
    private static Lightuser_CreateCaseController createController(Case c, PostalUnit__c pu) {
        
        System.assertNotEquals(Case.Subject, null);
        ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(c);
        Case c1 = (Case) stdController.getRecord();
        c1.Subject = c.Subject;
        c1.Description = c.Description;
        c1.Created_by_Name__c = c.Created_by_Name__c;
        c1.Type__c = c.Type__c;
        c1.RecordTypeId = c.RecordTypeId;
        Lightuser_CreateCaseController lc = new Lightuser_CreateCaseController(stdController);
        lc.eventId=c.Code_Event__c;
        lc.productId=c.Service_Product__c;
        lc.reason1Id=c.Code_Reason1__c;
        if(pu != null) { lc.pu.Name = pu.Name; }
        return lc;
    }
    
     private static Service_Product__c createTestProductFamily()
     {
         createCustomSetting();
        Id prod = [SELECT id FROM RecordType WHERE DeveloperName = 'Product_Family' AND SobjectType = 'Service_Product__c'].id;
        
        Service_Product__c p=new Service_Product__c(Name='MyTestProduct');
        p.RecordTypeId = prod;
        p.IsActive__c = true;
        insert p;
        return p;
     }
      
     private static Service_Product__c createTestProduct(Service_Product__c fam)
     {
         createCustomSetting();
        Id prodFam = [SELECT id FROM RecordType WHERE DeveloperName = 'Product' AND SobjectType = 'Service_Product__c'].id; 
        
        Service_Product__c p=new Service_Product__c(Name='MyTestProduct');
        p.RecordTypeId = prodFam;
        p.Produktfamilie__c = fam.Id;
        p.IsActive__c = true;
        insert p;
        return p;
     }
    
     private static Code_Reason1__c createTestReason(){
         createCustomSetting();
        Code_Reason1__c r=new Code_Reason1__c(Name='MyTestReason1_1');
        insert r;
        return r;
     }
     
     
     private static Code_Reason2__c createTestReason2()
     {
         createCustomSetting();
        Code_Reason2__c r=new Code_Reason2__c(Name='MyTestReason2_2');
        insert r;
        return r;
     }    
}