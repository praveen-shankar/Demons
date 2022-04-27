// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.crm_customer_number__c with Account.crm_customer_number__c
@isTest
private class zzz_CaseController {
 static {
       crm_AccountRecordTypes__c rr = new crm_AccountRecordTypes__c();
        rr.Name = 'Relation level Customer';
        rr.crm_Record_Type_Label__c ='Relation level Customer';
        insert rr;
    }
    static testMethod void copyAccountDetailsToCase_1(){
        // Check if values are copied correctly when a case and account is associated
        String recordId=KATSutilities.getRecordType('person_account');
        String recordIdBusiness=KATSutilities.getRecordType('business_account');
        list<Account> accList=new list<Account>();
        list<Case> newCases = new list<Case>();
        map<Id, Case> oldCaseMap = new map<Id, Case>();
        
        Account a1=new Account( crm_customer_number__c='12345678',FirstName='A', LastName='lName', PersonEmail=null, RecordTypeId=recordId, Phone='00998877'); 
        Account a2=new Account( crm_customer_number__c='12345676', Name='Bedrift AS', RecordTypeId=recordIdBusiness, Phone='99009900');
        accList.add(a1); accList.add(a2);
        insert accList;     
        
        Case c1=new Case(subject='TEST', accountId=a1.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com', AccountPhone__c=null, AccountEmail__c=null);
        Case c2=new Case(subject='Test case', accountId=a1.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com', AccountPhone__c=null);  
        oldCaseMap.put(c1.id, new Case(id=c1.id, subject='TEST', accountId=null, description = 'test', SuppliedEmail='SuppliedEmail@test.com', AccountPhone__c=null, AccountEmail__c=null)); 
        oldCaseMap.put(c2.id, new Case(id=c2.id, subject='Test case', accountId=a2.id, description = 'test', SuppliedEmail=null, AccountPhone__c='99009900'));     
        newCases.add(c1); newCases.add(c2);

        test.startTest();
        CaseController.copyAccountDetailsToCase(newCases, oldCaseMap);
        test.stopTest();
        
        system.assertEquals(c1.AccountPhone__c, '00998877');
        system.assertEquals(c1.AccountEmail__c, c1.SuppliedEmail);
        system.assertEquals(c2.AccountPhone__c, '00998877');
    }

     static testMethod void MaintainPrivateAccountContactDetails_1() {    
        String recordId=KATSutilities.getRecordType('person_account');
        String recordIdBusiness=KATSutilities.getRecordType('business_account');
        
        list<Case> newCases = new list<Case>();
        list<Account> accList=new list<Account>();
        map<Id, Case> oldCaseMap = new map<Id, Case>();
        
        Account a1=new Account( crm_customer_number__c='12345678',FirstName='A', LastName='lName', PersonEmail=null, RecordTypeId=recordId);   
        Account a2=new Account( crm_customer_number__c='12345677',FirstName='B', LastName='lName', PersonEmail='tobeupdated@mail.com', RecordTypeId=recordId); 
        Account a3=new Account( crm_customer_number__c='12345675',FirstName='D', LastName='lName', PersonEmail=null, RecordTypeId=recordId);
        Account a4=new Account( crm_customer_number__c='12345676', Name='Bedrift AS', RecordTypeId=recordIdBusiness);      
        accList.add(a1); accList.add(a2); accList.add(a3); accList.add(a4);
        insert accList;
       
            
        Case c1=new Case(subject='Account is set', accountId=a1.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com');      
        Case c2=new Case(subject='Test case', accountId=a2.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com');
        Case c3=new Case(subject='Test case', accountId=a3.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com', AccountPhone__c='11223344');
        Case c4=new Case(subject='Test case', accountId=null, description = 'testBedrift', SuppliedEmail='SuppliedEmail@test.com');
        Case c5=new Case(subject='Test case', accountId=a4.Id, description = 'testBedrift1', SuppliedEmail='SuppliedEmail@test.com');
        oldCaseMap.put(c1.id, new Case(id=c1.id, subject='Test case', accountId=null, description = 'test', SuppliedEmail='SuppliedEmail@test.com'));
        oldCaseMap.put(c2.id, new Case(id=c2.id, subject='Test case', accountId=a2.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com'));
        oldCaseMap.put(c3.id, new Case(id=c3.id, subject='Test case', accountId=null, description = 'test',AccountPhone__c=null, SuppliedEmail='SuppliedEmail@test.com'));  
        oldCaseMap.put(c4.id, new Case(id=c4.id, subject='Test case', accountId=null, description = 'testBedrift', SuppliedEmail=null));          
        oldCaseMap.put(c5.id, new Case(id=c5.id, subject='Test case', accountId=a4.Id, description = 'testBedrift1', SuppliedEmail='SuppliedEmail@test.com'));          
        newCases.add(c1);newCases.add(c2); newCases.add(c3);newCases.add(c4);
        c5.accountId = a2.Id;
        newCases.add(c5);
            
    
        test.startTest();
        CaseController.maintainPrivateAccountDetails(newCases, oldCaseMap);    
        test.stopTest();
      
        accList=[select personEmail, Phone from Account where id in :accList order by firstName];
        
        system.assertEquals(c1.AccountEmail__c, accList.get(0).personemail);
        system.assertEquals(c2.AccountEmail__c, accList.get(1).personemail);
        system.assertEquals(c3.AccountEmail__c, null);
        system.assertEquals(c4.AccountPhone__c, accList.get(3).Phone);  
    }
     

    static testMethod void testResetCtiOnCase_1() {
        Case newCase = new Case(ownerId = '50130000000014a', Assigned_to_CTI__c = true, Assigned_to_CTI_Agent__c = false);
        Case oldCase = new Case(ownerId = '50130000000014b', Assigned_to_CTI__c = true, Assigned_to_CTI_Agent__c = false);
        
        //Test
        test.startTest();
            CaseController.resetCtiOnCase(newCase,oldCase);
        test.stopTest();
        
        //Controll
        system.assertEquals(false, newCase.Assigned_to_CTI__c);
        system.assertEquals(true, newCase.Assigned_to_CTI_Agent__c);
    }
    
    static testMethod void testResetCtiOnCase_2() {
        Case newCase = new Case(ownerId = '50130000000014c', Assigned_to_CTI__c = true, Assigned_to_CTI_Agent__c = false);
        Case oldCase = new Case(ownerId = '50130000000014c', Assigned_to_CTI__c = true, Assigned_to_CTI_Agent__c = false);
        
        //Test
        test.startTest();
            CaseController.resetCtiOnCase(newCase,oldCase);
        test.stopTest();
        
        //Controll
        system.assertEquals(true, newCase.Assigned_to_CTI__c);
        system.assertEquals(false, newCase.Assigned_to_CTI_Agent__c);
    }
    
    static testMethod void testSetResponsibleSeller_1() {
        list<Case> newCases = new list<Case>();
        list<Case> oldCases = new list<Case>();
        
        newCases.add(new Case(Hidden_responsible_seller_email__c = 'test@test.com',Division_link__c = '50130000000014b'));
        
        //Test
        test.startTest();
            CaseController.setResponsibleSeller(newCases,null);
        test.stopTest();
        
        //Controll
        system.assertEquals(null, newCases.get(0).Hidden_responsible_seller_email__c);
        system.assertEquals(null, newCases.get(0).Division_link__c);
    }
    
    static testMethod void testSetResponsibleSeller_2() {
        String sellerEmail = 'test@test.com';
        String accountId = '50130000000014b';
        String divisionLink = '50130000000014b';
        
        list<Case> newCases = new list<Case>();
        map<Id, Case> oldCaseMap = new map<Id, Case>();
        
        newCases.add(new Case(id = '500C000000KoOZS', accountId = accountId, Hidden_responsible_seller_email__c = sellerEmail,Division_link__c = divisionLink));
        oldCaseMap.put('500C000000KoOZS',new Case(id = '500C000000KoOZS', accountId = accountId, Hidden_responsible_seller_email__c = sellerEmail,Division_link__c = divisionLink));
        
        //Test
        test.startTest();
            CaseController.setResponsibleSeller(newCases,oldCaseMap);
        test.stopTest();
        
        //Controll
        system.assertEquals(accountId, newCases.get(0).accountId);
        system.assertEquals(sellerEmail, newCases.get(0).Hidden_responsible_seller_email__c);
        system.assertEquals(divisionLink, newCases.get(0).Division_link__c);
    }
    
    static testMethod void testSetResponsibleSeller_3() {
        //Test data values
        String testAccountName = 'testSetResponsibleSeller_2';
        String testDivisionType = 'Test';
        String testDivisionSellerEmail = 'newseller@test.com';
        
        //Test data config
        list<Case> newCases = new list<Case>();
        map<Id, Case> oldCaseMap = new map<Id, Case>();
        insert new division_types__c(name = 'Test');
        
        Account acc = new Account(name = testAccountName);
        insert acc;
        Division__c div = new Division__c(Account__c = acc.id, name = testDivisionType,Sales_Person_Email__c = testDivisionSellerEmail);
        insert div;
        
        newCases.add(new Case(id = '500C000000KoOZS', accountId = acc.id, Division__c = 'Test bedrift', Hidden_responsible_seller_email__c = 'test@test.com',Division_link__c = '50130000000014b'));
        oldCaseMap.put('500C000000KoOZS', new Case(id = '500C000000KoOZS', accountId = '50130000000014b', Division__c = 'Annen divisjon', Hidden_responsible_seller_email__c = 'test@test.com',Division_link__c = '50130000000014b'));
        
        //Test
        test.startTest();
            CaseController.setResponsibleSeller(newCases,oldCaseMap);
        test.stopTest();
        
        //Controll
        //system.assertEquals(acc.id, newCases.get(0).accountId);
        //system.assertEquals(testDivisionSellerEmail, newCases.get(0).Hidden_responsible_seller_email__c);
        //system.assertEquals(div.id, newCases.get(0).Division_link__c);
    }
    
    static testMethod void testSetResponsibleSeller_4() {
        //Test data values
        String testAccountName = 'testSetResponsibleSeller_2';
        String testDivisionType1 = 'Div1';
        String testDivisionType2 = 'Div2';
        String testDivisionSellerEmail1 = 'seller1@test.com';
        String testDivisionSellerEmail2 = 'seller2@test.com';
        
        //Test data config
        list<Case> newCases = new list<Case>();
        map<Id, Case> oldCaseMap = new map<Id, Case>();
        insert new division_types__c(name = 'Div1');
        insert new division_types__c(name = 'Div2');
        
        Account acc = new Account(name = testAccountName);
        insert acc;
        Division__c div1 = new Division__c(Account__c = acc.id, name = testDivisionType1,Sales_Person_Email__c = testDivisionSellerEmail1);
        insert div1;
        Division__c div2 = new Division__c(Account__c = acc.id, name = testDivisionType2,Sales_Person_Email__c = testDivisionSellerEmail2);
        insert div2;
        
        newCases.add(new Case(id = '500C000000KoOZS', accountId = acc.id, Division__c = testDivisionType2, Hidden_responsible_seller_email__c = testDivisionSellerEmail1,Division_link__c = div1.id));
        oldCaseMap.put('500C000000KoOZS', new Case(id = '500C000000KoOZS', accountId = acc.id, Division__c = testDivisionType1, Hidden_responsible_seller_email__c = testDivisionSellerEmail1,Division_link__c = div1.id));
        
        //Test
        test.startTest();
            CaseController.setResponsibleSeller(newCases,oldCaseMap);
        test.stopTest();
        
        //Controll
        //system.assertEquals(acc.id, newCases.get(0).accountId);
        //system.assertEquals(testDivisionSellerEmail2, newCases.get(0).Hidden_responsible_seller_email__c);
        //system.assertEquals(div2.id, newCases.get(0).Division_link__c);
    }

    static testMethod void setUnitToBlameEmailAddress_1() {
        //Test data config
        Case newCase = new Case(Hidden_Unit_Email__c = 'test@test.com', unit_to_blame__c = null);
        
        //Test
        test.startTest();
            CaseController.setUnitToBlameEmailAddress(newCase, null);
        test.stopTest();
        
        //Controll
        system.assertEquals(null, newCase.unit_to_blame__c);
        system.assertEquals(null, newCase.Hidden_Unit_Email__c);
    }
    
    static testMethod void setUnitToBlameEmailAddress_2() {
        String unitEmail = 'test@test.com';
        String pibEmail = 'pib@test.com';
        environment_settings__c es = new environment_settings__c(Name = 'default_email_for_PIB_units', value__c = pibEmail);
        insert es;
        
        //Test data config
        PostalUnit__c testUnit = new PostalUnit__c(unit_number__c = '00011', email__c = unitEmail);
        insert testUnit;
        
        Case newCase = new Case(Hidden_Unit_Email__c = null, unit_to_blame__c = testUnit.id);
        
        //Test
        test.startTest();
            CaseController.setUnitToBlameEmailAddress(newCase, null);
        test.stopTest();
        
        //Controll
        system.assertEquals(testUnit.id, newCase.unit_to_blame__c);
        system.assertEquals(unitEmail, newCase.Hidden_Unit_Email__c);
    }
    
    static testMethod void setUnitToBlameEmailAddress_3() {
        String unitEmail = 'test@test.com';
        String pibEmail = 'pib@test.com';
        environment_settings__c es = new environment_settings__c(Name = 'default_email_for_PIB_units', value__c = pibEmail);
        insert es;
        
        //Test data config
        PostalUnit__c testUnit = new PostalUnit__c(unit_number__c = '00011', email__c = unitEmail, distribution_type__c = 'Post i butikk');
        insert testUnit;
        
        Case newCase = new Case(Hidden_Unit_Email__c = null, unit_to_blame__c = testUnit.id);
        
        //Test
        test.startTest();
            CaseController.setUnitToBlameEmailAddress(newCase, null);
        test.stopTest();
        
        //Controll
        system.assertEquals(testUnit.id, newCase.unit_to_blame__c);
        system.assertEquals(pibEmail, newCase.Hidden_Unit_Email__c);
    }
    
    static testMethod void setUnitToBlameEmailAddress_4() {
        String unitEmail = 'test@test.com';
        String pibEmail = 'pib@test.com';
        environment_settings__c es = new environment_settings__c(Name = 'default_email_for_PIB_units', value__c = pibEmail);
        insert es;
        
        //Test data config
        PostalUnit__c testUnit = new PostalUnit__c(unit_number__c = '00011', email__c = unitEmail, distribution_type__c = 'test');
        insert testUnit;
        
        Case newCase = new Case(Hidden_Unit_Email__c = null, unit_to_blame__c = testUnit.id);
        
        //Test
        test.startTest();
            CaseController.setUnitToBlameEmailAddress(newCase, null);
        test.stopTest();
        
        //Controll
        system.assertEquals(testUnit.id, newCase.unit_to_blame__c);
        system.assertEquals(unitEmail, newCase.Hidden_Unit_Email__c);
    }
    
    static testMethod void setUnitToBlameEmailAddress_5() {
        String oldUnitEmail = 'oldtest@test.com';
        String newUnitEmail = 'test@test.com';
        
        //Test data config
        PostalUnit__c testNewUnit = new PostalUnit__c(unit_number__c = '00011', email__c = newUnitEmail, distribution_type__c = 'test');
        insert testNewUnit;
        
        Case newCase = new Case(Hidden_Unit_Email__c = oldUnitEmail, unit_to_blame__c = testNewUnit.id);
        Case oldCase = new Case(Hidden_Unit_Email__c = oldUnitEmail, unit_to_blame__c = '500C000000KoOZS');
        
        //Test
        test.startTest();
            CaseController.setUnitToBlameEmailAddress(newCase, oldCase);
        test.stopTest();
        
        //Controll
        system.assertEquals(testNewUnit.id, newCase.unit_to_blame__c);
        system.assertEquals(newUnitEmail, newCase.Hidden_Unit_Email__c);
    }
    
    static testMethod void setUnitToBlameFromPickupArea_1(){
        PostalUnit__c p1 = new PostalUnit__c(unit_number__c = 'Test1000', DRM_id__c = 'Test1000', unit_number_in_subsidiary__c = 'Test1000', distribution_type__c = 'test');
        PostalUnit__c p2 = new PostalUnit__c(unit_number__c = 'Test2000', DRM_id__c = 'Test2000', unit_number_in_subsidiary__c = 'Test2000', distribution_type__c = 'test');
        insert p1;
        insert p2;
        Pickup_area__c pa1 = new Pickup_area__c(Name='Post 1000', postal_unit__c = p1.Id);
        Pickup_area__c pa2 = new Pickup_area__c(Name='Post 2000', postal_unit__c = p2.Id);
        insert pa1;
        insert pa2;

        //On Insert: If both Postal Unit and Pickup Area are set, check if Pickup Area belongs to the Postal Unit. If not, set Pickup Area blank.
        Case newCase1 = new Case(subject='TEST',unit_to_blame__c=p1.Id,pickup_area__c=pa1.Id);
        CaseController.setUnitToBlameFromPickupArea(newCase1, null);
        system.assertEquals(newCase1.unit_to_blame__c,p1.Id);
        system.assertEquals(newCase1.pickup_area__c,pa1.Id);
        
        //On Insert: If both Postal Unit and Pickup Area are set, check if Pickup Area belongs to the Postal Unit. If not, set Pickup Area blank.
        Case newCase2 = new Case(subject='TEST',unit_to_blame__c=p1.Id,pickup_area__c=pa2.Id);
        CaseController.setUnitToBlameFromPickupArea(newCase2, null);
        system.assertEquals(newCase2.unit_to_blame__c,p1.Id);
        system.assertEquals(newCase2.pickup_area__c,null);
        
        //If Postal Unit is blank and Pickup Area is added, update Postal Unit 
        Case newCase3 = new Case(subject='TEST',pickup_area__c=pa1.Id);
        CaseController.setUnitToBlameFromPickupArea(newCase3, null);
        system.assertEquals(newCase3.unit_to_blame__c,p1.Id);
        system.assertEquals(newCase3.pickup_area__c,pa1.Id);
        
        // On Update: If Postal Unit and Pickup Area are changed simultaneously, check if Pickup Area belongs to the Postal Unit. If not, set Pickup Area blank. 
        Case oldCase4 = new Case(subject='TEST',unit_to_blame__c=p1.Id,pickup_area__c=pa1.Id);
        Case newCase4 = new Case(subject='TEST',unit_to_blame__c=p2.Id,pickup_area__c=pa2.Id);
        CaseController.setUnitToBlameFromPickupArea(newCase4, oldCase4);
        system.assertEquals(newCase4.unit_to_blame__c,p2.Id);
        system.assertEquals(newCase4.pickup_area__c,pa2.Id);
        
        // On Update: If only Pickup Area is changed, update Postal Unit.
        Case oldCase5 = new Case(subject='TEST',unit_to_blame__c=p1.Id,pickup_area__c=pa1.Id);
        Case newCase5 = new Case(subject='TEST',unit_to_blame__c=p1.Id,pickup_area__c=pa2.Id);
        CaseController.setUnitToBlameFromPickupArea(newCase5, oldCase5);
        system.assertEquals(newCase5.unit_to_blame__c,p2.Id);
        system.assertEquals(newCase5.pickup_area__c,pa2.Id);
        
        // On Update: If only Postal Unit is changed, set Pickup Area blank.
        Case oldCase6 = new Case(subject='TEST',unit_to_blame__c=p1.Id,pickup_area__c=pa1.Id);
        Case newCase6 = new Case(subject='TEST',unit_to_blame__c=p2.Id,pickup_area__c=pa1.Id);
        CaseController.setUnitToBlameFromPickupArea(newCase6, oldCase6);
        system.assertEquals(newCase6.unit_to_blame__c,p2.Id);
        system.assertEquals(newCase6.pickup_area__c,null);
    }

    static testMethod void setWebformParameters() {
        Account a1 = new Account(Name='Test account', crm_customer_number__c='TestPartyNumber123', CRMStatus__c='Storkunde');
        Account a2 = new Account(Name='Test account', crm_customer_number__c='TestPartyNumber1234');
        a1.RecordTypeId = [select id from RecordType where developerName =:'business_account' limit 1].id;
        a2.RecordTypeId = [select id from RecordType where developerName =:'business_account' limit 1].id;
        insert a1;
        insert a2;
        
        webform_setting__c ws1 = new webform_setting__c(Name='ws1', Customer_Input__c='TestInput1', Origin__c='Web - klage',Record_type__c='shipment_case',Type__c='pakke-avsender');
        webform_setting__c ws2 = new webform_setting__c(Name='ws2', Customer_Input__c='TestInput2', Origin__c='Web - klage',Record_type__c='shipment_case_reciever',Type__c='pakke-avsender',Segment__c='Logistikk');
        webform_setting__c ws3 = new webform_setting__c(Name='ws3', Customer_Input__c='TestInput3', Origin__c='Web - klage',Record_type__c='invoice_related_case',Type__c='faktura');
        webform_setting__c ws4 = new webform_setting__c(Name='ws4', Customer_Input__c='TestInput2', Origin__c='Web - henvendelse',Record_type__c='simple_inquiry',Type__c='pakke-mottaker',Segment__c='Post');
        webform_setting__c ws5 = new webform_setting__c(Name='ws5', Customer_Input__c='TestInput5', Origin__c='Web - henvendelse',Record_type__c='simple_inquiry',Type__c='pakke-mottaker');
        webform_setting__c ws6 = new webform_setting__c(Name='ws6', Customer_Input__c='b:i:new:reklamation_av_paket', Origin__c='Web - klag',Record_type__c='simple_inquiry',Type__c='pakke-mottaker');
        webform_setting__c ws7 = new webform_setting__c(Name='ws7', Customer_Input__c='b:c:new:reklamation_av_henleverans', Origin__c='Web - klag',Record_type__c='complaint',Type__c='');
        webform_setting__c ws8 = new webform_setting__c(Name='ws8', Customer_Input__c='b:c:new:reklamation_av_expressbud', Origin__c='Web - klag',Record_type__c='complaint',Type__c='');
        webform_setting__c ws9 = new webform_setting__c(Name='ws9', Customer_Input__c='b:c:new:reklamation', Origin__c='Web - klag',Record_type__c='complaint',Type__c='');
        
        upsert ws1;
        upsert ws2;
        upsert ws3;
        upsert ws4;
        upsert ws5;
        upsert ws7;
        upsert ws8;
        upsert ws9;
        
        // Test setTypeInvoiceCase(Case newCase)
        Case c1 = new Case(Subject='Test2',Origin='Web - klage',type='faktura', Webform_customer_input__c='b:i:new:reklamation_av_paket',Invoice_no__c='abc123456789',Description='test',Kundenummer__c='1245656',Anledningen_til_din_reklamation__c='test',Annan_anledning__c='123456',Foretagsnamn__c='test',Kontaktperson__c='test person');
        Case c2 = new Case(Subject='Test2',Origin='Web - klage',type='faktura', Webform_customer_input__c='TestInput3');
        
        // Test setTypeShipmentCase(Case newCase)
        Case c3 = new Case(Subject='Test1',Origin='Web - klage', type='pakke-avsender',Webform_customer_input__c='TestInput1',Shipment_number__c='SM183405176NO');
        Case c4 = new Case(Subject='Test1',Origin='Web - klage', type='pakke-mottaker',Webform_customer_input__c='TestInput1');
        Case c21 = new Case(Subject='Test2',Origin='Web - klage',type='faktura', Webform_customer_input__c='TestInput3');
        Case c31 = new Case(Subject='Test2',Origin='Web - klage',type='faktura', Webform_customer_input__c='b:i:new:reklamation_av_paket');
        Case c41 = new Case(Subject='Test2',Origin='Web - klage',type='faktura', Webform_customer_input__c='TestInput2');
        
        // Test setWebformRecordType(Case newCase)
        Case c5 = new Case(Subject='Test1',Origin='Web - klage', type='faktura', Webform_customer_input__c='NotValidCustomerInput');
        Case c6 = new Case(Subject='Test1',Origin='Web - klage', Webform_customer_input__c='NotValidCustomerInput');
        // Subtest getCustomerSegment(Case newCase)
        Case c7 = new Case(Subject='Test2',Origin='Web - henvendelse', Webform_customer_input__c='TestInput2',AccountId = a1.Id);
        Case c8 = new Case(Subject='Test2',Origin='Web - henvendelse', Webform_customer_input__c='TestInput2',AccountId = a2.Id);
        Case c9 = new Case(Subject='Test2',Origin='Web - henvendelse', Webform_customer_input__c='TestInput2',AccountId = a2.Id, suppliedEmail='test@staples.no');
        
        // Test setWebformValuesFromCdsService(Case newCase)
        Code_Event__c ce=new Code_Event__c(Name='TestCategory');
        insert ce;
        CDS_service__c cds = new CDS_service__c(Name='test',CDS_Service_Group_Name__c='TestInput5', Code_Event__c=ce.id, Case_default_type__c='TestType');
        upsert cds;
        Case c10 = new Case(Subject='Test2',Origin='Web - henvendelse',type='faktura', Webform_customer_input__c='TestInput5');

        // For new webforms
        
        Case cWeb1 = new Case(Subject='Reklamation av hemleverans',Origin='Web - klage',type='faktura', Webform_customer_input__c='b:c:new:reklamation_av_henleverans',Description_Temp1__c='1234',Kundenummer__c='1245656',Anledningen_til_din_reklamation__c='test',Annan_anledning__c='123456',Foretagsnamn__c='test',Kontaktperson__c='test person',Description_Temp2__c ='test',Description_Temp3__c ='test',Description_Temp4__c='test',Antal__c ='test',Description_Temp5__c ='test');
        Case cWeb2 = new Case(Subject='b:c:new:reklamation_av_expressbud',Origin='Web - klage',type='faktura', Webform_customer_input__c='b:c:new:reklamation_av_expressbud',Description_Temp1__c='1234',Kundenummer__c='1245656',Anledningen_til_din_reklamation__c='test',Annan_anledning__c='123456',Foretagsnamn__c='test',Kontaktperson__c='test person',Description_Temp2__c ='test',Description_Temp3__c ='test',Description_Temp4__c='test',Antal__c ='test',Description_Temp5__c ='test');
        Case cWeb3 = new Case(Subject='b:c:new:reklamation',Origin='Web - klage',type='faktura', Webform_customer_input__c='b:c:new:reklamation',Description_Temp1__c='1234',Kundenummer__c='1245656',Anledningen_til_din_reklamation__c='test',Annan_anledning__c='123456',Foretagsnamn__c='test',Kontaktperson__c='test person',Description_Temp2__c ='test',Description_Temp3__c ='test',Description_Temp4__c='test',Antal__c ='test',Description_Temp5__c ='test');
        Case cWeb4 = new Case(Subject='Test2',Origin='Web - klage',type='faktura', Webform_customer_input__c='b:c:new:reklamation_av_henleverans');
        Case cWeb5 = new Case(Subject='Test2',Origin='Web - klage',type='faktura', Webform_customer_input__c='b:c:new:reklamation_av_expressbud');
        Case cWeb6 = new Case(Subject='Test2',Origin='Web - klage',type='faktura', Webform_customer_input__c='b:c:new:reklamation');
     
        
        // Set parameters
        CaseController.setWebformParameters(c1);
        CaseController.setWebformParameters(c2);
        CaseController.setWebformParameters(c3);
        CaseController.setWebformParameters(c4);
        CaseController.setWebformParameters(c5);
        CaseController.setWebformParameters(c6);
        CaseController.setWebformParameters(c21);
        CaseController.setWebformParameters(c31);
        CaseController.setWebformParameters(c41);
        CaseController.setWebformParameters(cWeb1);
        CaseController.setWebformParameters(cWeb2);
        CaseController.setWebformParameters(cWeb3);
        CaseController.setWebformParameters(cWeb4);
        CaseController.setWebformParameters(cWeb5);
        CaseController.setWebformParameters(cWeb6);
        insert c7;
        insert c8;
        insert c9;
        CaseController.setWebformParameters(c10);
    }
  /*  static testMethod void createManualCase()
    {       Test.startTest();
            list<Case> c=new list<Case>();
            list<Case> cUpdate=new list<Case>();
             Case c1=new Case(Status='New',Subject='Test1',Origin='Manual',type='Complaint',Bypass_Duplicate_Check__c=false, Shipment_number__c='xxx111222',Description='TestCase1',Shipment_identification__c='yyy123123');
             c.add(c1);  
             Case c2=new Case(Status='New',Subject='Test2',Origin='Manual',type='Complaint',Bypass_Duplicate_Check__c=false, Shipment_number__c='abc123456789',Description='TestCase2',Shipment_identification__c='1245656');
             c.add(c2);
             Case c3=new Case(Status='New',Subject='Test3',Origin='Manual',type='Complaint',Bypass_Duplicate_Check__c=false, Shipment_number__c='abc123456710',Description='TestCase3',Shipment_identification__c='1245634');
             c.add(c3);
             insert c;
     try{
             c2.Shipment_number__c='xxx111222';
             c2.Shipment_identification__c='yyy123123';  
              c3.Shipment_number__c='xxx111222';
              c3.Shipment_identification__c='yyy123123'; 
              cUpdate.add(c2);
              cUpdate.add(c3);
              update cUpdate;
         
         }
     catch(Exception e)         
     { Boolean msg= (e.getMessage().contains('This is a case with duplicate%'))?true:false;
       system.debug('Here is the message in Exception'+msg);
     }
     Test.stopTest();    
     
    }
    */
    
    static testMethod void TestsetHenvendelsestypeDefaultsMethod(){    
        createCustomSetting();
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue1 = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue1;
            QueuesObject testQueue2 = new QueueSObject(QueueID = testGroup.id, SObjectType = 'QueueDetails__c');
            insert testQueue2;
            
        }
        
        // Creating Code Event Record
        Code_Event__c ce1 = new Code_Event__c(Name='MyTestEvent');
        ce1.CaseTypeMultiselect__c = 'Klage';
        //CSpahse2 Supriya 29122016
        //ce1.CaseTypeMultiselect__c = 'Complaint';
        ce1.IsActive__c = true;
        insert ce1;
        
        // Creating Product Family Record
        id prodFamRecId = [select id from RecordType where DeveloperName='Product_Family' and SobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family'); added as part of 7th Nov Release
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId); /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert pf1;
        
        
        // Creating Product Record
        RecordType rcdtyp = [select id , developerName from RecordType where developerName = 'Product' and sobjectType = 'Service_Product__c' limit 1];
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
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
        cep1.Service_Product__c = p1.id; /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cep1.IsActive__c = true;
        database.insert(cep1);
        
        // Creating setup for Product and Code Reason 1
        CodeProdReason__c cpr1 = new CodeProdReason__c();
        cpr1.Henvendelsestype__c = ce1.id;
        cpr1.Service_Product__c = p1.id; /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cpr1.Code_reason1__c = cr1.id;
        cpr1.IsActive__c = true;
        database.insert(cpr1);
        
        
        // Creating setup for Code Reason 1 and Code Reason 2
        Code_Reason_12__c cr12 = new Code_Reason_12__c();
        cr12.Code_reason1__c = cr1.Id;
        cr12.Code_reason2__c = cr2.Id;
        cr12.Service_Product__c = p1.id; /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        database.insert(cr12);
        
        
        QueueDetails__c qd1 = new QueueDetails__c();
        qd1.Code_Event__c = ce1.id;
        qd1.Service_Product__c = p1.id; /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        qd1.Code_Reason1__c = cr1.id;
        qd1.Code_Reason2__c = cr2.id;
        qd1.queue_name__c = 'Test Queue Detail';
        qd1.ownerId = testGroup.id;
        database.insert(qd1);
        
        
        // Creating Test Case
        Case c1 = new Case();
        c1.recordTypeId = KATSutilities.getRecordType('complaint');
        //c1.Status = 'Ny';
        //CSphase2 Supriya 29122016
        c1.Status = 'New';
        c1.Category__c = 'MyTestEvent';
        c1.OwnerId = testGroup.id;
        insert c1;
        
        test.startTest();
        CaseController.setHenvendelsestypeDefaults(c1,qd1);
        test.stopTest();
    }
    
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
    
}