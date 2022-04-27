@isTest
private class zzz_Case_SearchUndeliverableController {
    
    static UndeliverableShipment__c getUndeliverable() {
        UndeliverableShipment__c undeliverable = new UndeliverableShipment__c(
            recieverAddress__c = 'Test reciever address',
            recieverCountry__c = 'Test reciever country',
            recieverName__c = 'Test reciever name',
            recieverPostalAddress__c = 'Test reciever postal address',
            recieverZipCode__c = '0000',
            senderAddress__c = 'Test sender address',
            senderCountry__c = 'Test sender country',
            senderName__c = 'Test sender name',
            senderPostalAddress__c = 'Test sender postal address',
            senderZipCode__c = '0000',
            weight__c = 5,
            Shipment_identification__c = '0000TEST',
            Shipment_number__c = '00000',
            submitted__c = system.today(),
            interiorDescription__c = 'Test tester',
            outerDescription__c = 'Test tester',
            Funnet__c = 'TEST funnet',
            status__c = 'Unidentified',
            Kommentar__c='1234'
            
        );
        upsert undeliverable;
        
        
        undeliverable = [SELECT id,
            name,
            recieverAddress__c,
            recieverCountry__c,
            recieverName__c,
            recieverPostalAddress__c,
            recieverZipCode__c,
            senderAddress__c,
            senderCountry__c,
            senderName__c,
            senderPostalAddress__c,
            senderZipCode__c,
            Shipment_identification__c,
            submitted__c,
            Shipment_number__c,
            outerDescription__c,
            interiorDescription__c,
            Funnet__c,
            status__c,
            recordtypeId,
            weight__c,
                 Kommentar__c        
            FROM UndeliverableShipment__c WHERE id =:undeliverable.id LIMIT 1];
            
        return undeliverable;
    }
    
    static Case getCase() {
        Case c = new Case(); 
            c.RecordTypeId = KATSutilities.getRecordType('complaint');
            c.reciever_country__c = 'Test_Country';
            c.reciever_name__c = 'Test_Name';
            c.reciever_postal_address__c = 'Test_City';
            c.reciever_zip_code__c = '0000';
            c.reciever_address__c = 'Test_Address';
            c.shipper_country__c = 'Test_Country';
            c.shipper_name__c = 'Test_Name';
            c.shipper_postal_address__c = 'Test_City';
            c.shipper_zip_code__c = '0000';
            c.shipper_address__c = 'Test_Address';
            c.Vekt_Maks__c = 10;
            c.Vekt_Min__c = 5;
            c.Shipment_identification__c = '0000000TEST';
            c.Shipment_number__c = '0000000Test';
            c.external_description__c ='TEST tester testar testen'; 
            c.content_description__c = 'TEST tester testar testen';
        upsert c;
        
        return c;
    }
    
    /* TODO: Write proper testing when logic is landed. This test has sole focus on line coverage 
    static testMethod void coverageTest() {
        
        
        Case c = new Case(); 
            c.RecordTypeId = KATSutilities.getRecordType('shipment_case');
            c.reciever_country__c = 'Norge';
            c.reciever_name__c = 'Per';
            c.reciever_postal_address__c = 'Oslo';
            c.reciever_zip_code__c = '0313';
            c.reciever_address__c = 'Blindernveien';
            c.shipper_country__c = 'Norge';
            c.shipper_name__c = 'Per';
            c.shipper_postal_address__c = 'Oslo';
            c.shipper_zip_code__c = '0313';
            c.shipper_address__c = 'Blindernveien';
            c.Vekt_Maks__c = 10;
            c.Vekt_Min__c = 5;
            c.Shipment_identification__c = '321*';
            c.external_description__c ='a b d e f yty erfe ad erge ad ferferf awdaw xasxasx wedwe grerg awdawda eger awdaawdaw egege adasdasd regerge asS EFWscc awd awdads wadafaw adadaw'; 
            c.content_description__c = 'a b d e f yty erfe ad erge ad ferferf awdaw xasxasx wedwe grerg awdawda eger awdaawdaw egege adasdasd regerge asS EFWscc awd awdads wadafaw adadaw';
            
        upsert c;
        system.debug('Case id = ' + c.Id);
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        cs.getHasUndeliverable();
        
        //cs.record = 'Registrert';
        cs.getProxyObject().Booking_date__c = system.today().addDays(-5);
        cs.getProxyObject().Distribution_date__c = system.today();
        
        UndeliverableShipment__c undeliverable = new UndeliverableShipment__c();
            undeliverable.recieverAddress__c = 'Blindernveien';
            undeliverable.recieverCountry__c = 'Norge';
            undeliverable.recieverName__c = 'Per';
            undeliverable.recieverPostalAddress__c = 'Oslo';
            undeliverable.recieverZipCode__c = '0313';
            undeliverable.senderAddress__c = 'Blindernveien';
            undeliverable.senderCountry__c = 'Norge';
            undeliverable.senderName__c = 'Per';
            undeliverable.senderPostalAddress__c = 'Oslo';
            undeliverable.senderZipCode__c = '0313';
            undeliverable.weight__c = 7;
            undeliverable.Shipment_identification__c = '321';
            undeliverable.submitted__c = system.today();
            undeliverable.interiorDescription__c = 'a b d e f yty erfe ad erge ad ferferf awdaw xasxasx wedwe grerg awdawda eger awdaawdaw egege adasdasd regerge asS EFWscc awd awdads wadafaw adadaw';
            undeliverable.outerDescription__c = 'a b d e f yty erfe ad erge ad ferferf awdaw xasxasx wedwe grerg awdawda eger awdaawdaw egege adasdasd regerge asS EFWscc awd awdads wadafaw adadaw';
            
        upsert undeliverable;
        system.debug('Undeliverable id = ' + undeliverable.Id);
        
        
        cs.searchUndeliverableShipment();
        //cs.createCase();
        cs.getHasUndeliverable();
        
        cs.undeliverableId = undeliverable.Id;
        cs.seeUndeliverable();
        
        cs.attachUndeliverableToCase();
    }*/
    
    //Test constructor
    static testMethod void testConstructor() {
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        
        Case c = cs.c;
        //system.assertEquals(cs.c.RecordTypeId, KATSUtilities.getRecordType('shipment_case'));
    }
    
    //Test constructor with case reference
    static testMethod void testConstructorWithExcistingCase() {
        Case c = zzz_Case_SearchUndeliverableController.getCase();
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        Case testCase = cs.c;
        c = [SELECT id, Shipment_identification__c, Shipment_number__c, Vekt_Min__c, Vekt_Maks__c, external_description__c, content_description__c, RecordTypeId FROM Case WHERE id = :c.id LIMIT 1];
        
        /*
        system.assertEquals(c.RecordTypeId, testCase.RecordTypeId);
        system.assertEquals(c.Shipment_identification__c, testCase.Shipment_identification__c);
        system.assertEquals(c.Shipment_number__c, testCase.Shipment_number__c);
        system.assertEquals(c.Shipment_number__c, testCase.Shipment_number__c);
        system.assertEquals(c.Vekt_Min__c, testCase.Vekt_Min__c);
        system.assertEquals(c.Vekt_Maks__c, testCase.Vekt_Maks__c);
        */
    }
     //Test constructor with case reference

    
    //The page returned should contain the same undeliverable object as the one reffered to in Case_SearchUndeliverableController
    static testMethod void testViewUndeliverable() {
        UndeliverableShipment__c us = new UndeliverableShipment__c();
        upsert us;
        
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        cs.undeliverableId = us.id;
        
        PageReference page = cs.viewUndeliverable();
        
        us = [SELECT id FROM UndeliverableShipment__c WHERE id = :us.id LIMIT 1];
        
        //  ID is truncated to 15 characters, ID's are 15 character, but the API returns a 18 character long case-safe version for external systems
        //  see http://www.salesforce.com/us/developer/docs/api/Content/field_types.htm and ID Field Type for further details
        system.assertEquals(page.getURL(), '/' + String.valueOf(us.id).substring(0,15));
    }
     static testMethod void testViewUndeliverableException() {
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        cs.undeliverableId = 'fi fa fom';
        PageReference page = cs.viewUndeliverable();    
    }
    
    static testMethod void testCloseUndeliverable_withoutCase() {
        UndeliverableShipment__c us = new UndeliverableShipment__c();
        upsert us;
        
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        cs.undeliverableId = us.id;
        cs.comment = 'Test comment';
        cs.shipTo = 'Test ship to';
        
        PageReference page = cs.closeUndeliverable();
        us = [SELECT id, Kommentar__c, Levert_til__c, status__c, Case__c FROM UndeliverableShipment__c WHERE id = :us.id LIMIT 1];
        system.assertEquals(page.getURL(), '/' + us.id);
      //  system.assertEquals(us.status__c, 'Identified');
        system.assertEquals(us.Levert_til__c, cs.shipTo);
        system.assertEquals(us.Kommentar__c, cs.comment);
        system.assertEquals(us.Case__c, null);
    }
    
    //Test closing undeliverable attached to case.
    static testMethod void testCloseUndeliverable_WithCase() {
        Case c = zzz_Case_SearchUndeliverableController.getCase();
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        UndeliverableShipment__c us = new UndeliverableShipment__c();
        upsert us;
        
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        cs.undeliverableId = us.id;
        cs.comment = 'Test comment';
        cs.shipTo = 'Test ship to';
       
        
        PageReference page = cs.closeUndeliverable();
        us = [SELECT id, Kommentar__c, Levert_til__c, status__c, Case__c FROM UndeliverableShipment__c WHERE id = :us.id LIMIT 1];
        
        /*
        system.assertEquals(page.getURL(), '/' + c.id);
        system.assertEquals(us.status__c, 'Tilknyttet sak');
        system.assertEquals(us.Levert_til__c, cs.shipTo);
        system.assertEquals(us.Kommentar__c, cs.comment);
        system.assertEquals(us.Case__c, c.id);
        */
        
    }
    
    //Test and Store case with and without case id in url
    static testMethod void testStoreAndGoToCase_withoutCase() {
        PageReference page;
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        
        //Registered
        cs.record = 'Registrert';
        page = cs.storeAndGoToCase();
        Case c = [SELECT id, status, type__c FROM Case WHERE id = :cs.c.id LIMIT 1];

        /*
        system.assertEquals(page.getURL(), '/'+ c.id + '/e?retURL=' + c.id);
        system.assertEquals(c.status, 'Under behandling');
        system.assertEquals(c.type__c, 'Registrert');
        */

        //Unregistered
        cs.record = '';
        page = cs.storeAndGoToCase();
        c = [SELECT id, status, type__c FROM Case WHERE id = :cs.c.id LIMIT 1];

        /*
        system.assertEquals(page.getURL(), '/'+ c.id + '/e?retURL=' + c.id);
        system.assertEquals(c.status, 'Under behandling');
        system.assertEquals(c.type__c, 'Uregistrert');
        */
    }
    
    static testMethod void testStoreAndGoToCase_withCase() {
        Case c = zzz_Case_SearchUndeliverableController.getCase();
        ApexPages.currentPage().getParameters().put('id', c.Id);
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        PageReference page = cs.storeAndGoToCase();
        
        //URL returns to the edit view
        //system.assertEquals(page.getURL(), '/'+ c.id + '/e?retURL=' + c.id );
    }
    
    //Test if the correct profiles can see the content description of a undeliverable shipment
    static testMethod void testHasCorrectProfile_True() {
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        
        Map<String,ID> profiles =new Map<String,ID>();
        for(Profile p : [SELECT id, name FROM Profile]){
            profiles.put(p.name, p.id);
        }
        
        User u = new User(alias = 'standt',
            email='standarduser@testorg.com',
            emailencodingkey='UTF-8',
            lastname='Testing',
            languagelocalekey='en_US',
            localesidkey='en_US',
            Username = 'standarduserUndeliverable@test.com',
            timezonesidkey='America/Los_Angeles',
            profileId = profiles.get('System Administrator')
        );
        
        System.runAs(u) {
            system.assertEquals(cs.hasCorrectProfile(), true);
        }
    }
    
    //Test if the correct profiles can see the content description of a undeliverable shipment
    static testMethod void testHasCorrectProfile_False() {
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        
        Map<String,ID> profiles =new Map<String,ID>();
        List<String> names = new List<String>();
        for(Profile p : [SELECT id, name FROM Profile]){
            profiles.put(p.name, p.id);
            names.add(p.name);
        }
        
        User u = new User(alias = 'standt',
            email='standarduser@testorg.com',
            emailencodingkey='UTF-8',
            lastname='Testing',
            languagelocalekey='en_US',
            localesidkey='en_US',
            Username = 'standarduserUndeliverable@test.com',
            timezonesidkey='America/Los_Angeles',
            profileId = profiles.get('CS Admin')
        );
        
        System.runAs(u) {
            system.assertEquals(cs.hasCorrectProfile(), false);
        }
    }
    
    static testMethod void testsearchUndeliverableShipment_emptyResult() {
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        
        //Test with no result
        cs.searchUndeliverableShipment();
    }
    
    //SOQL Test with result - Can ony use: Shipment_identification__c, Shipment_number__c, record, Vekt_Min__c, Vekt_Maks__c, fromDate, toDate
    static testMethod void testsearchUndeliverableShipment_SOQLresult() {
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        
        UndeliverableShipment__c undeliverable = zzz_Case_SearchUndeliverableController.getUndeliverable();
        
        cs.c.Shipment_identification__c = undeliverable.Shipment_identification__c;
        cs.c.Shipment_number__c = undeliverable.Shipment_number__c;
        cs.c.Vekt_Min__c = undeliverable.weight__c - 1;
        cs.c.Vekt_Maks__c = undeliverable.weight__c + 1;
        cs.record = [SELECT developerName FROM RecordType WHERE id = :undeliverable.recordtypeId LIMIT 1].developerName;
        cs.getProxyObject().Booking_date__c = undeliverable.submitted__c.addDays(-1);//fromdate
        cs.getProxyObject().Distribution_date__c = undeliverable.submitted__c.addDays(1);//todate
        
        cs.searchUndeliverableShipment();
        
        system.assertEquals(true, cs.results.size() > 0);
    }
    
    
    // Test method getCurrentSearchStatus()
    static testMethod void testCurrentSearchStatus() {
        Case_SearchUndeliverableController cs1 = new Case_SearchUndeliverableController();
        Case_SearchUndeliverableController cs2 = new Case_SearchUndeliverableController();      
        cs1.status='Alle';
        cs2.status='Uidentifisert';
        system.assertEquals(true, cs1.getCurrentSearchStatus());
        system.assertEquals(false, cs2.getCurrentSearchStatus());
    }
    //
    
    static testMethod void testsearchUndeliverableShipment_SOSLresult() {
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        
        UndeliverableShipment__c undeliverable = zzz_Case_SearchUndeliverableController.getUndeliverable();
        
        cs.c.Shipment_identification__c = undeliverable.Shipment_identification__c;
        cs.c.Shipment_number__c = undeliverable.Shipment_number__c;
        cs.c.Vekt_Min__c = undeliverable.weight__c - 1;
        cs.c.Vekt_Maks__c = undeliverable.weight__c + 1;
        cs.record = [SELECT developerName FROM RecordType WHERE id = :undeliverable.recordtypeId LIMIT 1].developerName;
        cs.getProxyObject().Booking_date__c = undeliverable.submitted__c.addDays(-1);//fromdate
        cs.getProxyObject().Distribution_date__c = undeliverable.submitted__c.addDays(1);//todate
        
        cs.c.shipper_name__c = undeliverable.senderName__c+'*';
        cs.c.shipper_address__c = undeliverable.senderAddress__c;
        cs.c.shipper_postal_address__c = undeliverable.senderPostalAddress__c;
        cs.c.shipper_zip_code__c = undeliverable.senderZipCode__c;
        cs.c.shipper_country__c = undeliverable.senderCountry__c;
        cs.c.reciever_Name__c = undeliverable.recieverName__c;
        cs.c.reciever_Address__c = undeliverable.recieverAddress__c;
        cs.c.reciever_Postal_Address__c = undeliverable.recieverPostalAddress__c;
        cs.c.reciever_Zip_Code__c = undeliverable.recieverZipCode__c;
        cs.c.reciever_Country__c = undeliverable.recieverCountry__c;
        cs.c.content_description__c = undeliverable.interiorDescription__c;
        cs.c.external_description__c = undeliverable.outerDescription__c;
        
        System.debug('TEST-> ' + [SELECT id, status__c FROM UndeliverableShipment__c WHERE id = :undeliverable.id LIMIT 1]);
        
        cs.searchUndeliverableShipment();
        
    }
    
    static testMethod void testGetHasUndeliverable() {
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        
        //Test with empty list should return false
        system.assertEquals(false, cs.getHasUndeliverable());
        
        //Test with list containing objects should return true
        cs.undeliverable.add(zzz_Case_SearchUndeliverableController.getUndeliverable());
        system.assertEquals(true, cs.getHasUndeliverable());
    }
    
    static testMethod void testUndeliverableResults() {
        
        UndeliverableShipment__c undeliverable = zzz_Case_SearchUndeliverableController.getUndeliverable();
        
        Case_SearchUndeliverableController.UndeliverableResults ur = new Case_SearchUndeliverableController.UndeliverableResults(undeliverable);
        
        system.assertEquals(undeliverable.name, ur.name);
        system.assertEquals(undeliverable.id, ur.undeliverable.id);
        system.assertEquals(undeliverable.submitted__c, ur.submitted);
        system.assertEquals(undeliverable.Shipment_number__c, ur.ShipmentNumber);
        system.assertEquals(undeliverable.Shipment_identification__c, ur.ShipmentIdentification);
        system.assertEquals(undeliverable.recieverName__c, ur.recieverName);
        system.assertEquals(undeliverable.recieverAddress__c, ur.recieverAddress);
        system.assertEquals(undeliverable.recieverPostalAddress__c, ur.recieverPostalAddress);
        system.assertEquals(undeliverable.recieverZipCode__c, ur.recieverZipCode);
        system.assertEquals(undeliverable.recieverCountry__c, ur.recieverCountry);
        system.assertEquals(undeliverable.senderName__c, ur.shipperName);
        system.assertEquals(undeliverable.senderAddress__c, ur.shipperAddress);
        system.assertEquals(undeliverable.senderPostalAddress__c, ur.shipperPostalAddress);
        system.assertEquals(undeliverable.senderZipCode__c, ur.shipperZipCode);
        system.assertEquals(undeliverable.senderCountry__c, ur.shipperCountry);
        system.assertEquals(undeliverable.outerDescription__c, ur.outerDescription);
        system.assertEquals(undeliverable.interiorDescription__c, ur.innerDescription);
        system.assertEquals(undeliverable.Funnet__c, ur.funnet);

        system.assertEquals(ur.hitsRecipient, 0);
        system.assertEquals(ur.hitsSender, 0);
        system.assertEquals(ur.hitsInnerDescription, 0);
        system.assertEquals(ur.hitsOuterDescription, 0);
        system.assertEquals(ur.hitsTotal, 0);
    }
    
    //Test if the quicksort method works
    static testMethod void testQuickSort() {
        Case_SearchUndeliverableController.QuickSort qs = new Case_SearchUndeliverableController.QuickSort();
        
        Case_SearchUndeliverableController.UndeliverableResults ur1 =
            new Case_SearchUndeliverableController.UndeliverableResults(zzz_Case_SearchUndeliverableController.getUndeliverable());
            
        Case_SearchUndeliverableController.UndeliverableResults ur2 =
            new Case_SearchUndeliverableController.UndeliverableResults(zzz_Case_SearchUndeliverableController.getUndeliverable());
            
        Case_SearchUndeliverableController.UndeliverableResults ur3 =
            new Case_SearchUndeliverableController.UndeliverableResults(zzz_Case_SearchUndeliverableController.getUndeliverable());
        
        //Each hit is marked by a negative number in the controllerclass
        ur1.hitsInnerDescription = -1;
        ur1.hitsOuterDescription = -1;
        ur1.hitsRecipient = -1;
        ur1.hitsSender = -1;
        
        ur2.hitsInnerDescription = -2;
        ur2.hitsOuterDescription = -2;
        ur2.hitsRecipient = -2;
        ur2.hitsSender = -2;
        
        system.assertEquals(ur1.hitsTotal > ur2.hitsTotal, true);
        system.assertEquals(ur3.hitsTotal > ur1.hitsTotal, true);
        
        //Adds the results in a not sortet order.
        List<Case_SearchUndeliverableController.UndeliverableResults> listResults = new List<Case_SearchUndeliverableController.UndeliverableResults>();
        listResults.add(ur3);
        listResults.add(ur2);
        listResults.add(ur1);
        
        //Check if the order is as predicted
        system.assertEquals(listResults.get(0).id, ur3.id);
        system.assertEquals(listResults.get(1).id, ur2.id);
        system.assertEquals(listResults.get(2).id, ur1.id);
        
        qs.sort(listResults);
        
        system.assertEquals(listResults.get(0).id, ur2.id);
        system.assertEquals(listResults.get(1).id, ur1.id);
        system.assertEquals(listResults.get(2).id, ur3.id);
        
    }
        static testMethod void testsearchUndeliverableShipment_SOQLresult1() {
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        
        UndeliverableShipment__c undeliverable = zzz_Case_SearchUndeliverableController.getUndeliverable();
        
        cs.c.Shipment_identification__c = undeliverable.Shipment_identification__c;
        cs.c.Shipment_number__c = undeliverable.Shipment_number__c;
        cs.c.external_description__c='ExtAbc';
        cs.c.content_description__c='IntAbc';
        cs.c.Vekt_Min__c = undeliverable.weight__c - 1;
        cs.c.Vekt_Maks__c = undeliverable.weight__c + 1;
        //cs.record = [SELECT developerName FROM RecordType WHERE id = :undeliverable.recordtypeId LIMIT 1].developerName;
        cs.getProxyObject().Booking_date__c = undeliverable.submitted__c.addDays(-1);//fromdate
        cs.getProxyObject().Distribution_date__c = undeliverable.submitted__c.addDays(1);//todate
        
        cs.searchUndeliverableShipment();
        // Dinesh , Commented line no. 506 on 23 Feb 2017
       // system.assertEquals(true, cs.results.size() > 0);
    }
           static testMethod void testsearchUndeliverableShipment_SOQLresult2() {
        Case_SearchUndeliverableController cs = new Case_SearchUndeliverableController();
        cs.outerDescription='Abcd';
        cs.innerDescription='RDFG';
        cs.HasUndeliverable=true;
        cs.maxCommentLength=3;
        UndeliverableShipment__c undeliverable = zzz_Case_SearchUndeliverableController.getUndeliverable();
        
        cs.c.Shipment_identification__c = undeliverable.Shipment_identification__c;
        cs.c.Shipment_number__c = undeliverable.Shipment_number__c;
        cs.c.external_description__c='ExtAbc';
        cs.c.content_description__c='IntAbc';
        cs.c.Vekt_Min__c = undeliverable.weight__c - 1;
        cs.c.Vekt_Maks__c = undeliverable.weight__c + 1;
        cs.undeliverableNumber=undeliverable.Name;
        //cs.record = [SELECT developerName FROM RecordType WHERE id = :undeliverable.recordtypeId LIMIT 1].developerName;
        cs.getProxyObject().Booking_date__c = undeliverable.submitted__c.addDays(-1);//fromdate
        cs.getProxyObject().Distribution_date__c = undeliverable.submitted__c.addDays(1);//todate
        
        cs.searchUndeliverableShipment();
        
        system.assertEquals(true, cs.results.size() > 0);
    }

    
}