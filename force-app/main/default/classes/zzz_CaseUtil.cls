@isTest
private class zzz_CaseUtil
{
    static testMethod void testForCoveringExceptions()
    {
        //Coverage for cases with no account on the functions assignRecieverInfoToCase and assignSenderInfoToCase
        Case c1 = createCaseKlage();
        c1.AccountId = null;
        Database.insert(c1);

        CaseUtil.assignRecieverInfoToCase(c1);
        CaseUtil.assignSenderInfoToCase(c1);


        //False case while running the functions isRecieveShipment, isSenderShipment and isCargoClaims
        Id rtId = KATSUtilities.getRecordType('planned_distribution_case');
        Case c2 = new Case(RecordTypeId = rtId);
        Database.insert(c2);

        CaseUtil.isSenderShipment(c2);
        CaseUtil.isRecieveShipment(c2);
        CaseUtil.isCargoClaims(c2);
    }

    static testMethod void testShouldAssignAvsenderKlage()
    {
        Case c = createCaseKlage();
        
        Boolean actual = CaseUtil.isSenderShipment(c);
        //System.assertEquals(actual, true);
        actual = CaseUtil.isRecieveShipment(c);
        //System.assertEquals(actual, false);
    }
    
    static testMethod void testShouldAssignMottakerKlage()
    {
        Case c = createCaseKlage();
        Boolean actual = CaseUtil.isRecieveShipment(c);
        //System.assertEquals(actual, true);
        
        actual = CaseUtil.isSenderShipment(c);
        //System.assertEquals(actual, false);
    }
    
    static testMethod void testAssignAvsenderInfo()
    {
        Account a = createTestAccount();
        Case c = createCaseKlage();
        CaseUtil.assignSenderInfoToCase(c);
        System.assertEquals(a.Name, c.shipper_name__c); // Ola Nordmann
        // Dinesh , commented lin no. 52 on 23 Feb 2017
       // System.assertEquals(a.ShippingStreet, c.shipper_address__c); // Ola Nordmanns vei 1
       // System.assertEquals(a.ShippingCity, c.shipper_postal_address__c); // 0555
       // System.assertEquals(a.ShippingPostalCode, c.shipper_zip_code__c); // Oslo
       // System.assertEquals(a.ShippingCountry, c.Shipper_CountryCode__c); // NO
       // System.assertEquals(null, c.shipper_country__c); // this field is not in use by the IT systems at Posten
        //System.assertEquals(c.Shipper_CountryCode__c, a);
    }
    
    static testMethod void testAssignMottakerInfo()
    {
        Account a = createTestAccount();
        Case c = createCaseKlage();
        CaseUtil.assignRecieverInfoToCase(c);
        // Dinesh , commented line no. 66 on 23 Feb 2017
       // System.assertEquals(a.Name, c.reciever_name__c); // Ola Nordmann
        //System.assertEquals(a.ShippingStreet, c.reciever_address__c); // Ola Nordmanns vei 1
       // System.assertEquals(a.ShippingPostalCode, c.reciever_zip_code__c); // 0555
      //  System.assertEquals(a.ShippingCity, c.reciever_postal_address__c); // Oslo
       // System.assertEquals(a.ShippingCountry, c.Reciever_CountryCode__c); // NO
       // System.assertEquals(null, c.reciever_country__c); // this field is not in use by the IT systems at Posten
        // Reciever_CountryCode__c reciever_countr__c må vel være feil i maintainshipmentcontroller
        
        // Account har bare: Shipping Street, Shipping City, Shipping State/Province, Shipping Zip/Postal Code, Shipping Country
        // I dette tilfellet: Trimveien 12, Horten, NULL, 3188, NO
    }
    
    static testMethod void testMaintainPreviousForwardingAddress()
    {
        map<String, ForwardingAddressChange__c> forwardingMap = new map<String, ForwardingAddressChange__c>();
        list<ForwardingAddressChange__c> forwardings = new list<ForwardingAddressChange__c>();
        forwardings.add(new ForwardingAddressChange__c(number__c = '1', type__c = 'hold'));
        forwardings.add(new ForwardingAddressChange__c(number__c = '2', type__c = 'permanent'));
        forwardings.add(new ForwardingAddressChange__c(number__c = '3', type__c = 'temporary'));
        forwardings.add(new ForwardingAddressChange__c(number__c = '4', type__c = 'hold'));
        forwardings.add(new ForwardingAddressChange__c(number__c = '5', type__c = 'permanent'));
        forwardings.add(new ForwardingAddressChange__c(number__c = '6', type__c = 'temporary'));
        upsert(forwardings);
        
        forwardings = [SELECT id, number__c, type__c FROM ForwardingAddressChange__c WHERE id in :forwardings];
        
        for(ForwardingAddressChange__c fac : forwardings) {
            forwardingMap.put(fac.number__c, fac);
        }
        
        List<Case> cases = new List<Case>();
        cases.add(new Case(subject = '1'));
        cases.add(new Case(subject = '2'));
        cases.add(new Case(subject = '3'));
        cases.add(new Case(subject = '4'));
        cases.add(new Case(subject = '5'));
        cases.add(new Case(subject = '6'));
        upsert cases;
        
        for(Case c : cases) {
            c.change_address_ref_no__c = c.subject;
        }
        
        test.startTest();
            CaseUtil.maintainPreviousForwardingAddress(cases);
        test.stopTest();
        
        for(Case c: cases) {
            system.Assert(forwardingMap.get(c.change_address_ref_no__c) != null);
            ForwardingAddressChange__c fac = forwardingMap.get(c.change_address_ref_no__c);
           // system.assertEquals(fac.id, c.forwardingAddress__c);
          //  system.assert(!KATSutilities.isEmpty(c.produkt__c), 'Produkt is empty, this is wrong, it should contain info');
            if(fac.type__c == 'hold') {
                system.assertEquals('Oppbevaring', c.produkt__c);
            } else if(fac.type__c == 'permanent') {
                system.assertEquals('Varig adresseendring', c.produkt__c);
            } else if(fac.type__c == 'temporary') {
                system.assertEquals('Midlertidig adresseendring', c.produkt__c);
            }
        }
    }
    
    static testMethod void testSearchAccountFromShipmentIdCases()
    {   
        Case c1 = new Case(subject='Test', type='Sending - avsender', Origin='Web - klage', Shipment_identification__c='11223344' );
        insert c1;   
       
        List<Case> cs = [SELECT Id, AccountId, Party_number__c, Shipment_identification__c FROM Case WHERE id = :c1.Id];
           
      //  System.assertNotEquals(cs, null);
      //  System.assertEquals(cs[0].Shipment_identification__c, c1.Shipment_identification__c);
        /* THE ACCOUNT IS LINKED TO THE CASE BY AN @FUTURE METHOD. THEREFORE NOT POSSIBLE TO ASSERT
        System.assertNotEquals(cs[0].AccountId, null);
        System.assertEquals(cs[0].AccountId, KatsTestUtilities.getTestBusinessAccount().Id);
        */
        
        List<ID> caseIds = new List<ID>();
        caseIds.add(cs[0].id);
        test.startTest();
        CaseUtil.searchAccountFromShipmentIdFuture(caseIds);
        test.stopTest();
        
        /*
        * This assert will fail in a non-sandbox-envoironment, as the mock customer is only returned for sandboxes without econnect connection
        * Should rewrite test so that the assert holds independent of environment settings.
        */ 
        if(Organization_environment_settings__c.getInstance(UserInfo.getOrganizationId()) == null)
        {
            List<Case> csAfter = [SELECT Id, Invoice_no__c, AccountId, Party_number__c FROM Case WHERE id = :c1.Id];
          //  System.assertNotEquals(csAfter[0].AccountId, null);
          //  System.assertEquals(csAfter[0].AccountId, KatsTestUtilities.getTestBusinessAccount().Id);           
        }

    }
    
    static testMethod void testSearchAccountFromShipmentNumberCases()
    {
        Case c1=new Case(subject='Test', type='Sending - avsender', Origin='Web - klage', Shipment_number__c='333444' );
        insert c1;     

        List<Case> cs = [SELECT Id, Shipment_number__c, AccountId, Party_number__c FROM Case WHERE id = :c1.Id];
           
     //   System.assertNotEquals(cs, null);
     //   System.assertEquals(cs[0].Shipment_number__c, c1.Shipment_number__c);
        
        List<ID> caseIds = new List<ID>();
        caseIds.add(cs[0].id);
        test.startTest();
        CaseUtil.searchAccountFromShipmentNumberFuture(caseIds);
        test.stopTest();
        
        /*
        * This assert will fail in a non-sandbox-envoironment, as the mock customer is only returned for sandboxes without econnect connection
        * Should rewrite test so that the assert holds independent of environment settings.
        */ 
        if(Organization_environment_settings__c.getInstance(UserInfo.getOrganizationId()) == null)
        {       
            List<Case> csAfter = [SELECT Id, Invoice_no__c, AccountId, Party_number__c FROM Case WHERE id = :c1.Id];
          //  System.assertNotEquals(csAfter[0].AccountId, null);
          //  System.assertEquals(csAfter[0].AccountId, KatsTestUtilities.getTestBusinessAccount().Id);
        }
    }
    
    static testMethod void testSearchAccountFromInvoiceNumberCases()
    {
        Case c1=new Case(subject='Test', type='Sending - avsender', Origin='Web - klage', Invoice_no__c='333444' );
        insert c1; 
        
        List<Case> cs = [SELECT Id, Invoice_no__c, AccountId, Party_number__c FROM Case WHERE id = :c1.Id];
      //  System.assertNotEquals(cs, null);
      //  System.assertEquals(cs[0].Invoice_no__c, c1.Invoice_no__c);
        
        List<ID> caseIds = new List<ID>();
        caseIds.add(cs[0].id);
        test.startTest();
        CaseUtil.searchAccountFromInvoiceNumberFuture(caseIds);
        test.stopTest();
        
        /*
        * This assert will fail in a non-sandbox-envoironment, as the mock customer is only returned for sandboxes without econnect connection
        * Should rewrite test so that the assert holds independent of environment settings.
        */      
        if(Organization_environment_settings__c.getInstance(UserInfo.getOrganizationId()) == null) {    
            List<Case> csAfter = [SELECT Id, Invoice_no__c, AccountId, Party_number__c FROM Case WHERE id = :c1.Id];
           // System.assertNotEquals(csAfter[0].AccountId, null);
          //  System.assertEquals(csAfter[0].AccountId, KatsTestUtilities.getTestBusinessAccount().Id);
        }
    }
    
    static testMethod void testSearchAccountFromAddressRefCases()
    {
        Case c1=new Case(subject='Test', type='Sending - avsender', Origin='Web - klage', change_address_ref_no__c='333444' );
        insert c1;
                
        List<Case> cs = [SELECT Id, change_address_ref_no__c, AccountId, Party_number__c FROM Case WHERE id = :c1.Id];
        
    //    System.assertNotEquals(cs, null);
      //  System.assertEquals(cs[0].change_address_ref_no__c, c1.change_address_ref_no__c);
        
        List<ID> caseIds = new List<ID>();
        caseIds.add(cs[0].id);
        test.startTest();
        CaseUtil.maintainPreviousForwardingAddressFuture(caseIds, true);
        test.stopTest();
        
        /*
        * This assert will fail in a non-sandbox-envoironment, as the mock customer is only returned for sandboxes without econnect connection
        * Should rewrite test so that the assert holds independent of environment settings.
        */      
        if(Organization_environment_settings__c.getInstance(UserInfo.getOrganizationId()) == null) {
            List<Case> csAfter = [SELECT Id, Invoice_no__c, AccountId, Party_number__c FROM Case WHERE id = :c1.Id];
           // System.assertNotEquals(csAfter[0].AccountId, null);
           // System.assertEquals(csAfter[0].AccountId, KatsTestUtilities.getTestBusinessAccount().Id);
        }
    }
    
    // ====================== setup =========================
    private static Case createCaseKlage()
    {
        Account a = createTestAccount();
        upsert a;

        Id rtId = KATSUtilities.getRecordType('complaint');
        Case caseShipmentRecieve = new Case(AccountId = a.Id, RecordTypeId = rtId);
        return caseShipmentRecieve;
    }
    
    private static Account createTestAccount()
    {
        Account a = new Account();
        a.Name = 'Donald Duck';
        a.ShippingStreet = 'Donald veien 123';
        a.ShippingCity = 'Donald Duck';
        a.ShippingCountry = 'NO';
        a.ShippingPostalCode = '1337';
        return a;
        
  //      a.Recipient.PostalCode = '1337';
    //    a.Recipient.Country = 'Noreg';
     //   a.Recipient.CountryCode = 'N';
    }
}