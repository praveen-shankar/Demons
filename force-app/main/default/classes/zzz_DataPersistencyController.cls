/*
 // CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c   
*/

@isTest
private class zzz_DataPersistencyController {
/*
static {
KatsTestUtilities ktu = new KatsTestUtilities();
  }
  */
    static testMethod void populateBusinessAccount() {
        postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType orgType = mock_Crmgetcustome.getBusinessAccount().OrganizationParty;
        
        Account testAccount = new Account();
        
        Test.startTest();
            testAccount = DataPersistencyController.populateBusinessAccount(testAccount, orgType);
        Test.stopTest();
        
        //system.assertEquals(orgType.DUNSNo, testAccount.DUNS_number__c);
        //system.assertEquals(orgType.Status, testAccount.status__c);
        //system.assertEquals(orgType.FiscalCode, testAccount.Orga__c);
        //system.assertEquals(orgType.LegalName, testAccount.Name);
        
        //system.assertEquals(orgType.Communications.Communication.get(0).PhoneNumber, testAccount.Phone);
    
    }
    

    
    
    
    static testMethod void populatePersonAccount() {
        postenNoEconnectAboCrmCrmgetcustome.CustomerPersonType personType = mock_Crmgetcustome.getPrivateAccount().PersonParty;
        
        Account testAccount = new Account();
        
        Test.startTest();
            testAccount = DataPersistencyController.populatePrivateAccount(testAccount, personType);
        Test.stopTest();
        
        //system.assertEquals(personType.Status, testAccount.status__c);
    }
    
    static testMethod void testSetAccountAddress_1() {
        list <postenNoEconnectAboCrmCrmgetcustome.AddressType> addressList = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Addresses.Address;
        //addressList.get(0).Street = null;
        Account testAccount = new Account();
        
        Test.startTest();
            DataPersistencyController.setAccountAddress(testAccount, addressList, false);
        Test.stopTest();
        
        //system.assertEquals(addressList.get(0).Street, testAccount.BillingStreet);
//        system.assertEquals(addressList.get(0).PostalCode, testAccount.BillingPostalCode);
      //  system.assertEquals(addressList.get(0).CityName, testAccount.BillingCity);
      //  system.assertEquals(addressList.get(0).CountryCode, testAccount.BillingCountry);
        
        //system.assertEquals(addressList.get(1).Street, testAccount.ShippingStreet);
      //  system.assertEquals(addressList.get(1).PostalCode, testAccount.ShippingPostalCode);
      //  system.assertEquals(addressList.get(1).CityName, testAccount.ShippingCity);
      //  system.assertEquals(addressList.get(1).CountryCode, testAccount.ShippingCountry);
    }
    
    static testMethod void testSetAccountAddress_2() {
        list <postenNoEconnectAboCrmCrmgetcustome.AddressType> addressList = mock_Crmgetcustome.getPrivateAccount().PersonParty.Addresses.Address;
        
        Account testAccount = new Account();
        
        Test.startTest();
            DataPersistencyController.setAccountAddress(testAccount, addressList, true);
        Test.stopTest();
        
        //system.assertEquals(addressList.get(0).Street, testAccount.BillingStreet);
        system.assertEquals(addressList.get(0).PostalCode, testAccount.BillingPostalCode);
        system.assertEquals(addressList.get(0).CityName, testAccount.BillingCity);
        system.assertEquals(addressList.get(0).CountryCode, testAccount.BillingCountry);
        
        //system.assertEquals(addressList.get(0).Street, testAccount.ShippingStreet);
        system.assertEquals(addressList.get(0).PostalCode, testAccount.ShippingPostalCode);
        system.assertEquals(addressList.get(0).CityName, testAccount.ShippingCity);
        system.assertEquals(addressList.get(0).CountryCode, testAccount.ShippingCountry);
    }
    static testMethod void testSetAccountAddress_3() {
        list <postenNoEconnectAboCrmCrmgetcustome.AddressType> addressList = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Addresses.Address;
        
        // Shipping address is empty
        //addressList.get(1).Street=null;
        addressList.get(1).PostalCode=null;
        addressList.get(1).CityName=null;
        addressList.get(1).CountryCode=null;
        Account testAccount = new Account();
        
        Test.startTest();
            DataPersistencyController.setAccountAddress(testAccount, addressList, false);
        Test.stopTest();
        // Shipping is null, use postadresse (XXAD_POST)
        //String otheraddress=addressList.get(4).Street + '\r\n '+ addressList.get(4).PostalCode + '\r\n' + addressList.get(4).CityName + '\r\n' + addressList.get(4).Country;
        //addresslist street to be uncommented
        String otheraddress= addressList.get(4).PostalCode + '\r\n' + addressList.get(4).CityName + '\r\n' + addressList.get(4).CountryCode;
        //system.assertEquals(otheraddress, testAccount.other_adress__c);
    }
    
    static testMethod void testSetAccountAddress_4() {
        list <postenNoEconnectAboCrmCrmgetcustome.AddressType> addressList = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Addresses.Address;
        // Shipping address(SHIP_TO) is empty
        //addressList.get(1).Street=null;
        addressList.get(1).PostalCode=null;
        addressList.get(1).CityName=null;
        addressList.get(1).CountryCode=null;
        // Postadresse(XXAD_POST) is empty
        //addressList.get(4).Street=null;
        addressList.get(4).PostalCode=null;
        addressList.get(4).CityName=null;
        addressList.get(4).CountryCode=null;
        Account testAccount = new Account();
        
        Test.startTest();
            DataPersistencyController.setAccountAddress(testAccount, addressList, false);
        Test.stopTest();
        // SHIP_TO and XXAD_POST is empty, use XXAD_VISIT
        //String otheraddress=addressList.get(3).Street + '\r\n '+ addressList.get(3).PostalCode + '\r\n' + addressList.get(3).CityName + '\r\n' + addressList.get(3).Country;
        String otheraddress=addressList.get(3).PostalCode + '\r\n' + addressList.get(3).CityName + '\r\n' + addressList.get(3).CountryCode;
        //system.assertEquals(otheraddress, testAccount.other_adress__c);
    
        
    }
    static testMethod void testSetAccountAddress_5() {
        list <postenNoEconnectAboCrmCrmgetcustome.AddressType> addressList = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Addresses.Address;
        
        // Shipping address(SHIP_TO) is empty
        //addressList.get(1).Street=null;
        addressList.get(1).PostalCode=null;
        addressList.get(1).CityName=null;
        addressList.get(1).CountryCode=null;
        // Postadresse(XXAD_POST) is empty
        //addressList.get(4).Street=null;
        addressList.get(4).PostalCode=null;
        addressList.get(4).CityName=null;
        addressList.get(4).CountryCode=null;
        // Besøksadresse (XXAD_VISIT) is empty
        //addressList.get(3).Street=null;
        addressList.get(3).PostalCode=null;
        addressList.get(3).CityName=null;
        addressList.get(3).CountryCode=null;
        Account testAccount = new Account();
        
        Test.startTest();
            DataPersistencyController.setAccountAddress(testAccount, addressList, false);
        Test.stopTest();
        // SHIP_TO, XXAD_POST and XXAD_VISIT is empty, use BILL_TO
        //String otheraddress=addressList.get(0).Street + '\r\n '+ addressList.get(0).PostalCode + '\r\n' + addressList.get(0).CityName + '\r\n' + addressList.get(0).Country;
        String otheraddress=addressList.get(0).PostalCode + '\r\n' + addressList.get(0).CityName + '\r\n' + addressList.get(0).CountryCode;
        //system.assertEquals(otheraddress, testAccount.other_adress__c);
    
        
    }
    static testMethod void testSetNamePrivateAccount_1() {
        postenNoEconnectAboCrmCrmgetcustome.PersonNameType nameType = mock_Crmgetcustome.getPrivateAccount().PersonParty.Names;
        Account testAccount = new Account();
        
        Test.startTest();
            DataPersistencyController.setNamePrivateAccount(testAccount, nameType);
        Test.stopTest();
        
        String firstName = nameType.FirstName + ' ' + nameType.MiddleName;
        system.assertEquals(nameType.LastName, testAccount.LastName);
        system.assertEquals(firstName, testAccount.FirstName);
    }
    
    static testMethod void testSetNamePrivateAccount_2() {
        postenNoEconnectAboCrmCrmgetcustome.PersonNameType nameType = mock_Crmgetcustome.getPrivateAccount().PersonParty.Names;
        nameType.FirstName = null;
        nameType.MiddleName = null;
        nameType.LastName = null;
        
        Account testAccount = new Account();
        
        Test.startTest();
            DataPersistencyController.setNamePrivateAccount(testAccount, nameType);
        Test.stopTest();
        
        system.assertEquals('<Mangler etternavn>', testAccount.LastName);
        system.assertEquals('<Mangler fornavn>', testAccount.FirstName);
    }
    
    static testMethod void testSetNamePrivateAccount_3() {
        postenNoEconnectAboCrmCrmgetcustome.PersonNameType nameType = mock_Crmgetcustome.getPrivateAccount().PersonParty.Names;
        nameType.FirstName = '123456789012345678901234567890'; //30
        nameType.MiddleName = '123456789012345'; //15
        nameType.LastName = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345'; //85
        
        Account testAccount = new Account();
        
        Test.startTest();
            DataPersistencyController.setNamePrivateAccount(testAccount, nameType);
        Test.stopTest();
        
        system.assertEquals('123456789012345678901234567890 123456789', testAccount.FirstName);
        system.assertEquals('12345678901234567890123456789012345678901234567890123456789012345678901234567890', testAccount.LastName);
    }
    
    static testMethod void testPopulateForwardingType() {
         postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwardingType = mock_Crmgetcustome.getPrivateAccount().PersonParty.Forwardings.Forwarding.get(0);
        Id accountId = '00190000001pPvHAAU';
        
        ForwardingAddressChange__c result;
        
        Test.startTest();
            result = DataPersistencyController.populateForwardingType(forwardingType, accountId);
        Test.stopTest();
        
        system.assertEquals(forwardingType.ForwardingNumber, result.Name);
        system.assertEquals(forwardingType.ForwardingNumber, result.number__c);
        system.assertEquals(forwardingType.ReferenceOMA, result.referenceOMA__c);
        system.assertEquals(forwardingType.Type_x, result.type__c);
        system.assertEquals(forwardingType.Source, result.source__c);
        system.assertEquals(forwardingType.OEBSURI, result.oebsuri__c);
        system.assertEquals(forwardingType.StartDate, result.startDate__c);
        system.assertEquals(forwardingType.EndDate, result.endDate__c);
        system.assertEquals(forwardingType.HoldDate, result.holdDate__c);
        //system.assertEquals(forwardingType.ToAddress.Street, result.toStreet__c);
        system.assertEquals(forwardingType.ToAddress.PostalCode, result.toPostalCode__c);
        system.assertEquals(forwardingType.ToAddress.CityName, result.toCity__c);
        //system.assertEquals(forwardingType.FromAddress.Street, result.fromStreet__c);
        system.assertEquals(forwardingType.FromAddress.PostalCode, result.fromPostalCode__c);
        system.assertEquals(forwardingType.FromAddress.CityName, result.fromCity__c);
        system.assertEquals(accountId, result.account__c);
    }
    
    static testMethod void testPopulateForwardingPerson() {
        postenNoEconnectAboCrmCrmgetcustome.PersonNameType forwardingPerson = mock_Crmgetcustome.getPrivateAccount().PersonParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0);
        ForwardingPerson__c result;
        
        Test.startTest();
            result = DataPersistencyController.populateForwardingPerson(forwardingPerson);
        Test.stopTest();
        
        system.assertEquals(forwardingPerson.FirstName, result.firstName__c);
        system.assertEquals(forwardingPerson.MiddleName, result.middleName__c);
        system.assertEquals(forwardingPerson.LastName, result.lastName__c);
        system.assertEquals(forwardingPerson.FirstName + ' ' + forwardingPerson.LastName, result.name);
    }
    
    static testMethod void testConnectForwardingPersonMapToForwardingTypeList() {
        ForwardingAddressChange__c fac = new ForwardingAddressChange__c();
        fac.number__c = '123456';
        insert fac;
        list<ForwardingAddressChange__c> facList = new list<ForwardingAddressChange__c>();
        facList.add(fac);
        
        ForwardingPerson__c fp = new ForwardingPerson__c();
            fp.firstName__c = 'firstName';
            fp.middleName__c = 'middleName';
            fp.lastName__c = 'lastName';
            fp.Name = fp.firstName__c + ' ' + fp.lastName__c;
        list<ForwardingPerson__c> fpList = new list<ForwardingPerson__c>();
        fpList.add(fp);
        
        map<string, list<ForwardingPerson__c>> fpMap = new map<string, list<ForwardingPerson__c>>();
        fpMap.put(fac.number__c,fpList);
        
        list<ForwardingPerson__c> result;
        
        Test.startTest();
            result = DataPersistencyController.ConnectForwardingPersonMapToForwardingTypeList(fpMap, facList);
        Test.stopTest();
        
        system.assertEquals(1, result.size());
        system.assertEquals(fac.id, result.get(0).forwardingAddress__c);
    }
    
    static testMethod void maintainAccountEconnectResult() {
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectOutParameters = mock_Crmgetcustome.getBusinessAccount();
        
        Account testAccount;
        
        Test.startTest();
            testAccount = DataPersistencyController.maintainAccount(eConnectOutParameters);
        Test.stopTest();
        
        system.assertEquals(eConnectOutParameters.OrganizationParty.PartyNumber, testAccount.crm_customer_number__c);
    }
    
    static testMethod void maintainAccountEmptyEconnectResult() {
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectOutParameters = mock_Crmgetcustome.getPrivateAccount();
        eConnectOutParameters.OrganizationParty = null;
        eConnectOutParameters.PersonParty = null;
        
        Account testAccount;
        
        Test.startTest();
            testAccount = DataPersistencyController.maintainAccount(eConnectOutParameters);
        Test.stopTest();
        
        system.assertEquals(null, testAccount);
    }
    
    static testMethod void maintainPrivateAccount() {
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectOutParameters = mock_Crmgetcustome.getPrivateAccount();
        postenNoEconnectAboCrmCrmgetcustome.CustomerPersonType personData =  eConnectOutParameters.PersonParty;
        Account testAccount = null;
        Test.startTest();
            testAccount = DataPersistencyController.maintainPrivateAccount(personData);
        test.stopTest();
        
        system.assertEquals(personData.Names.FirstName + ' ' + personData.Names.MiddleName, testAccount.FirstName);
        system.assertEquals(personData.Names.LastName, testAccount.LastName);
        
        for(postenNoEconnectAboCrmCrmgetcustome.AddressType address : personData.Addresses.Address) {
            if(address.AddrTYPE == 'PostalAddress') {
                system.assertEquals(address.CityName, testAccount.BillingCity);
                system.assertEquals(address.CountryCode, testAccount.BillingCountry);
                system.assertEquals(address.PostalCode, testAccount.BillingPostalCode);
                //system.assertEquals(address.Street, testAccount.BillingStreet);
                
                system.assertEquals(address.CityName, testAccount.ShippingCity);
                system.assertEquals(address.CountryCode, testAccount.ShippingCountry);
                system.assertEquals(address.PostalCode, testAccount.ShippingPostalCode);
                //system.assertEquals(address.Street, testAccount.ShippingStreet);
            }
        }
        
        //system.assertEquals(personData.Status, testAccount.status__c);
    }
    
    //TODO: Find a good test for inserting phone number!
    static testMethod void maintainBusinessAccount() {
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectOutParameters = mock_Crmgetcustome.getBusinessAccount();
        postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType organizationData =  eConnectOutParameters.OrganizationParty;
        
        Account testAccount = null;
        
        Test.startTest();
            testAccount = DataPersistencyController.maintainOrganizationAccount(organizationData);
        test.stopTest();
        
        system.assertEquals(testAccount.crm_customer_number__c, organizationData.PartyNumber);
        system.assertEquals(testAccount.status_update__c, 'Ready for update');
        system.assertEquals(testAccount.Name, organizationData.LegalName);
        
        for(postenNoEconnectAboCrmCrmgetcustome.AddressType address : organizationData.Addresses.Address) {
            if(address.AddrTYPE == 'BILL_TO') {
                system.assertEquals(testAccount.BillingCity, address.CityName);
                system.assertEquals(testAccount.BillingCountry, address.CountryCode);
                system.assertEquals(testAccount.BillingPostalCode, address.PostalCode);
                //system.assertEquals(testAccount.BillingStreet, address.Street);
            }
            if(address.AddrTYPE == 'SHIP_TO') {
                system.assertEquals(testAccount.ShippingCity, address.CityName);
                system.assertEquals(testAccount.ShippingCountry, address.CountryCode);
                system.assertEquals(testAccount.ShippingPostalCode, address.PostalCode);
                //system.assertEquals(testAccount.ShippingStreet, address.Street);
            }
        }
    }
    
    static testMethod void testGetAccountNonExistingCustomer() {
        
        String randomSeed = '' + system.now();
        
        Test.startTest();
            Account testPrivateAccount = DataPersistencyController.getAccount('p'+randomSeed, true);
            Account testbusinessAccount = DataPersistencyController.getAccount('b'+randomSeed, false);
        Test.stopTest();
        
        testPrivateAccount = [SELECT LastName, crm_customer_number__c, status_update__c FROM Account WHERE id = :testPrivateAccount.id];
        testbusinessAccount = [SELECT Name, crm_customer_number__c, status_update__c FROM Account WHERE id = :testbusinessAccount.id];
        
        //test private
        system.assertEquals('p'+randomSeed, testPrivateAccount.crm_customer_number__c);
        //system.assertEquals('Klar for oppdatering', testPrivateAccount.status_update__c);
        system.assertEquals('_', testPrivateAccount.LastName);
        
        //test business
        system.assertEquals('b'+randomSeed, testbusinessAccount.crm_customer_number__c);
        //system.assertEquals('Klar for oppdatering', testbusinessAccount.status_update__c); // Commenting as part of Sales Migration 07 Nov 
        system.assertEquals('_', testbusinessAccount.Name);
    }
    
    static testMethod void testGetAccountExistingCustomer() {
        String randomSeed = '' + system.now();
        
        Account testPrivateAccount = new Account(LastName = 'TestPrivate', crm_customer_number__c = 'p'+randomSeed, status_update__c ='Aldri oppdatert');
        Account testbusinessAccount = new Account(Name = 'TestBusiness', crm_customer_number__c = 'b'+randomSeed, status_update__c ='Aldri oppdatert');
        
        upsert testPrivateAccount;
        upsert testbusinessAccount;
        
        Test.startTest();
            DataPersistencyController.getAccount('p'+randomSeed, true);
            DataPersistencyController.getAccount('b'+randomSeed, false);
        Test.stopTest();
        
        testPrivateAccount = [SELECT LastName, crm_customer_number__c, status_update__c FROM Account WHERE id = :testPrivateAccount.id];
        testbusinessAccount = [SELECT Name, crm_customer_number__c, status_update__c FROM Account WHERE id = :testbusinessAccount.id];
        
        //test private
        system.assertEquals('p'+randomSeed, testPrivateAccount.crm_customer_number__c);
        //system.assertEquals('Klar for oppdatering', testPrivateAccount.status_update__c);
        system.assertEquals('TestPrivate', testPrivateAccount.LastName);
        
        //test business
        system.assertEquals('b'+randomSeed, testbusinessAccount.crm_customer_number__c);
        //system.assertEquals('Klar for oppdatering', testbusinessAccount.status_update__c); Commenting as part of Sales Migration 07 Nov
        system.assertEquals('TestBusiness', testbusinessAccount.Name);
    }
    
    static testMethod void maintainForwardingAddress() {
        //Get moc data of an eConnect call
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectOutParameters = mock_Crmgetcustome.getPrivateAccount();
        
        //Create map of the forwarding addresses in the eConnect moc data, we use the data for a private customer in this test
        map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType> mapForwardings = new map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType>();
        for(postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwarding : eConnectOutParameters.PersonParty.Forwardings.Forwarding) {
            mapForwardings.put(forwarding.Forwardingnumber, forwarding);
        }
        
        //Create a dummy account for the test
        Account acc = KatsTestUtilities.getTestPrivateAccount();//[SELECT id, LastName FROM Account WHERE crm_customer_number__c = :eConnectOutParameters.PersonParty.PartyNumber];
        //= new Account(lastName = eConnectOutParameters.PersonParty.Names.LastName, crm_customer_number__c = eConnectOutParameters.PersonParty.PartyNumber);
        //upsert acc;
        
        list<ForwardingAddressChange__c> forwardingsToTest = new list<ForwardingAddressChange__c>();
        //Run the test
        test.startTest();
            forwardingsToTest = DataPersistencyController.maintainForwardingTypes(acc.id, eConnectOutParameters.PersonParty.Forwardings.Forwarding);
        test.stopTest();
        
        //Get the forwrding persons from the test run
        map<string, list<ForwardingPerson__c>> mapFP = new map<string, list<ForwardingPerson__c>>();
        for(ForwardingPerson__c fp : [SELECT id, forwardingAddress__c FROM ForwardingPerson__c WHERE forwardingAddress__c in:forwardingsToTest]){
            if(mapFP.containsKey(fp.forwardingAddress__c)){
                mapFP.get(fp.forwardingAddress__c).add(fp);
            } else {
                list<ForwardingPerson__c> newFpList = new list<ForwardingPerson__c>();
                newFpList.add(fp);
                mapFP.put(fp.forwardingAddress__c, newFpList);
            }
        }
        
        //Assert checks
        Integer numberOfForwardingsToGenerate = eConnectOutParameters.PersonParty.Forwardings.Forwarding.size();
        Integer resultNumberOfForwardings = forwardingsToTest.size();
        system.assertEquals(numberOfForwardingsToGenerate, resultNumberOfForwardings, 'The list sizes are not equal! supposed to end up with '
                            + numberOfForwardingsToGenerate
                            + ' forwardings, but got '
                            + resultNumberOfForwardings);

        for(ForwardingAddressChange__c fac : forwardingsToTest) {
            postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwardingType = mapForwardings.get(fac.number__c);
            
            system.assertEquals(forwardingType.ForwardingNumber, fac.name);
            system.assertEquals(forwardingType.ForwardingNumber, fac.number__c);
            system.assertEquals(forwardingType.ReferenceOMA, fac.referenceOMA__c);
            system.assertEquals(forwardingType.Type_x, fac.type__c);
            system.assertEquals(forwardingType.Source, fac.source__c);
            system.assertEquals(forwardingType.OEBSURI, fac.oebsuri__c);
            system.assertEquals(forwardingType.StartDate, fac.startDate__c);
            system.assertEquals(forwardingType.EndDate, fac.endDate__c);
            system.assertEquals(forwardingType.HoldDate, fac.holdDate__c);
            
            //system.assertEquals(forwardingType.ToAddress.Street, fac.toStreet__c);
            system.assertEquals(forwardingType.ToAddress.PostalCode, fac.toPostalCode__c);
            system.assertEquals(forwardingType.ToAddress.CityName, fac.toCity__c);
            
            //system.assertEquals(forwardingType.FromAddress.Street, fac.fromStreet__c);
            system.assertEquals(forwardingType.FromAddress.PostalCode, fac.fromPostalCode__c);
            system.assertEquals(forwardingType.FromAddress.CityName, fac.fromCity__c);
            
            system.assertEquals(acc.id, fac.account__c);
            
            if(forwardingType.OtherParties != null && forwardingType.OtherParties.party != null) {
                list<ForwardingPerson__c> listFP =  mapFP.get(fac.id);
                
                Integer numberOfPersonsToGenerate = forwardingType.OtherParties.party.size();
                Integer resultNumberOfPersons = listFP.size();
                system.assertEquals(numberOfPersonsToGenerate, resultNumberOfPersons, 'The list sizes are not equal! supposed to end up with '
                                + numberOfPersonsToGenerate
                                + ' persons, but got '
                                + resultNumberOfPersons);
            }
        }
    }
    
    //Tests if running the method twice would create doubles, tests only the size of the lists not the data
    static testMethod void maintainForwardingAddressTwoRuns() {
        //Get moc data of an eConnect call
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectOutParameters = mock_Crmgetcustome.getPrivateAccount();
        
        //Create map of the forwarding addresses in the eConnect moc data, we use the data for a private customer in this test
        map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType> mapForwardings = new map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType>();
        for(postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwarding : eConnectOutParameters.PersonParty.Forwardings.Forwarding) {
            mapForwardings.put(forwarding.ForwardingNumber, forwarding);
        }
        
        //Create a dummy account for the test
        Account acc = KatsTestUtilities.getTestPrivateAccount();//new Account(lastName = eConnectOutParameters.PersonParty.Names.LastName, crm_customer_number__c = eConnectOutParameters.PersonParty.PartyNumber);
        //upsert acc;
        
        //Run the test
        test.startTest();
            DataPersistencyController.maintainForwardingTypes(acc.id, eConnectOutParameters.PersonParty.Forwardings.Forwarding);
            DataPersistencyController.maintainForwardingTypes(acc.id, eConnectOutParameters.PersonParty.Forwardings.Forwarding);
        test.stopTest();
        
        //Get the forwardings from the test run
        list<ForwardingAddressChange__c> forwardingsToTest = [SELECT id, number__c FROM ForwardingAddressChange__c WHERE account__c = :acc.id];
        
        //Get the forwarding persons from the test run
        map<string, list<ForwardingPerson__c>> mapFP = new map<string, list<ForwardingPerson__c>>();
        for(ForwardingPerson__c fp : [SELECT id, forwardingAddress__c FROM ForwardingPerson__c WHERE forwardingAddress__c in:forwardingsToTest]){
            if(mapFP.containsKey(fp.forwardingAddress__c)){
                mapFP.get(fp.forwardingAddress__c).add(fp);
            } else {
                list<ForwardingPerson__c> newFpList = new list<ForwardingPerson__c>();
                newFpList.add(fp);
                mapFP.put(fp.forwardingAddress__c, newFpList);
            }
        }
        
        //Assert checks
        Integer numberOfForwardingsToGenerate = eConnectOutParameters.PersonParty.Forwardings.Forwarding.size();
        Integer resultNumberOfForwardings = forwardingsToTest.size();
        system.assertEquals(numberOfForwardingsToGenerate, resultNumberOfForwardings, 'The list sizes are not equal! supposed to end up with '
                            + numberOfForwardingsToGenerate
                            + ' forwardings, but got '
                            + resultNumberOfForwardings);

        for(ForwardingAddressChange__c fac : forwardingsToTest) {
            postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwardingType = mapForwardings.get(fac.number__c);
            list<ForwardingPerson__c> listFP =  mapFP.get(fac.id);
            if(forwardingType.OtherParties != null && forwardingType.OtherParties.party != null) {
                Integer numberOfPersonsToGenerate = forwardingType.OtherParties.party.size();
                Integer resultNumberOfPersons = listFP.size();
                system.assertEquals(numberOfPersonsToGenerate, resultNumberOfPersons, 'The list sizes are not equal! supposed to end up with '
                                + numberOfPersonsToGenerate
                                + ' persons, but got '
                                + resultNumberOfPersons);
            }
        }
    }

        static testMethod void maintainForwardingAddressTwoRunsMyTest1() {
        //Get moc data of an eConnect call
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectOutParameters = mock_Crmgetcustome.getPrivateAccount();
        
        //Create map of the forwarding addresses in the eConnect moc data, we use the data for a private customer in this test
        map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType> mapForwardings = new map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType>();
        for(postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwarding : eConnectOutParameters.PersonParty.Forwardings.Forwarding) {
            mapForwardings.put(forwarding.ForwardingNumber, forwarding);
        }
        
        //Create a dummy account for the test
        Account acc = KatsTestUtilities.getTestPrivateAccount();//new Account(lastName = eConnectOutParameters.PersonParty.Names.LastName, crm_customer_number__c = eConnectOutParameters.PersonParty.PartyNumber);
        
        //Run the test
        test.startTest();
            postenNoEconnectAboCrmCrmgetcustome.AddressType add = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
            String[] InformationType=new String[]{'CustomerDetails'};
            add.AddrType = 'BILL_TO';
            List<postenNoEconnectAboCrmCrmgetcustome.AddressType> addList = new List<postenNoEconnectAboCrmCrmgetcustome.AddressType>();
            addList.add(add);
            DataPersistencyController.maintainForwardingTypes(acc.id, eConnectOutParameters.PersonParty.Forwardings.Forwarding);
            DataPersistencyController.maintainForwardingTypes(acc.id, eConnectOutParameters.PersonParty.Forwardings.Forwarding);
            DataPersistencyController.maintainForwarding('89789789');
            DataPersistencyController.maintainAccount(acc);
            DataPersistencyController.maintainAccount('89789789',InformationType);
            DataPersistencyController.updateAccount(acc.id);
            DataPersistencyController.populateBusinessAccount(acc,null);
            DataPersistencyController.maintainPrivateAccount(null);
            DataPersistencyController.populateBusinessAccount(acc,null);
            DataPersistencyController.setAccountAddress(acc,addList,false);
            add.AddrType = 'SHIP_TO';
            DataPersistencyController.setAccountAddress(acc,addList,false);
            DataPersistencyController.getAccount('89789789',false);
            DataPersistencyController.persistAccount(acc);
        test.stopTest();
        
        //Get the forwardings from the test run
        list<ForwardingAddressChange__c> forwardingsToTest = [SELECT id, number__c FROM ForwardingAddressChange__c WHERE account__c = :acc.id];
        
        //Get the forwarding persons from the test run
        map<string, list<ForwardingPerson__c>> mapFP = new map<string, list<ForwardingPerson__c>>();
        for(ForwardingPerson__c fp : [SELECT id, forwardingAddress__c FROM ForwardingPerson__c WHERE forwardingAddress__c in:forwardingsToTest]){
            if(mapFP.containsKey(fp.forwardingAddress__c)){
                mapFP.get(fp.forwardingAddress__c).add(fp);
            } else {
                list<ForwardingPerson__c> newFpList = new list<ForwardingPerson__c>();
                newFpList.add(fp);
                mapFP.put(fp.forwardingAddress__c, newFpList);
            }
        }
        
        //Assert checks
        Integer numberOfForwardingsToGenerate = eConnectOutParameters.PersonParty.Forwardings.Forwarding.size();
        Integer resultNumberOfForwardings = forwardingsToTest.size();
        system.assertEquals(numberOfForwardingsToGenerate, resultNumberOfForwardings, 'The list sizes are not equal! supposed to end up with '
                            + numberOfForwardingsToGenerate
                            + ' forwardings, but got '
                            + resultNumberOfForwardings);

        for(ForwardingAddressChange__c fac : forwardingsToTest) {
            postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwardingType = mapForwardings.get(fac.number__c);
            list<ForwardingPerson__c> listFP =  mapFP.get(fac.id);
            if(forwardingType.OtherParties != null && forwardingType.OtherParties.party != null) {
                Integer numberOfPersonsToGenerate = forwardingType.OtherParties.party.size();
                Integer resultNumberOfPersons = listFP.size();
                system.assertEquals(numberOfPersonsToGenerate, resultNumberOfPersons, 'The list sizes are not equal! supposed to end up with '
                                + numberOfPersonsToGenerate
                                + ' persons, but got '
                                + resultNumberOfPersons);
            }
        }
    }  

        static testMethod void maintainForwardingAddressTwoRunsMyTest2() {
        //Get moc data of an eConnect call
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectOutParameters = mock_Crmgetcustome.getPrivateAccount();
        
        //Create map of the forwarding addresses in the eConnect moc data, we use the data for a private customer in this test
        map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType> mapForwardings = new map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType>();
        for(postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwarding : eConnectOutParameters.PersonParty.Forwardings.Forwarding) {
            mapForwardings.put(forwarding.ForwardingNumber, forwarding);
        }
        
        //Create a dummy account for the test
        Account acc = KatsTestUtilities.getTestPrivateAccount();//new Account(lastName = eConnectOutParameters.PersonParty.Names.LastName, crm_customer_number__c = eConnectOutParameters.PersonParty.PartyNumber);
        acc.crm_Account_Inserted__c = true;
            update acc;
        //Run the test
        Case cas = new Case(Subject = 'Test Case',hidden_is_package_with_edi__c =false, AccountId = acc.Id,Shipment_identification__c= '12121',LM_First_hendelser_EventDate__c =date.today());
            insert cas;
            postenNoEconnectKatsGetshipment.ShipmentUnitType data = new postenNoEconnectKatsGetshipment.ShipmentUnitType();
            data.PostingTerminal = new  postenNoEconnectKatsGetshipment.AddressTerminalType() ;
            data.CurrentCity  = new  postenNoEconnectKatsGetshipment.AddressType ();
            data.ShipToAddress = new  postenNoEconnectKatsGetshipment.AddressType ();
            data.ShipToAddress.Street = 'test';
            data.Insurance = new  postenNoEconnectKatsGetshipment.InsuranceType ();
            data.ShipmentDescription = new  postenNoEconnectKatsGetshipment.ShipmentDescription ();
            
            data.Events = new postenNoEconnectKatsGetshipment.Events_element ();
            data.Events.Event = new List<postenNoEconnectKatsGetshipment.ShipmentEventType>();
            postenNoEconnectKatsGetshipment.ShipmentEventType  eve = new postenNoEconnectKatsGetshipment.ShipmentEventType();
            data.Events.Event.add(eve);
            
            data.Sender = new postenNoEconnectKatsGetshipment.ShipmentPartyAddress ();
            data.Recipient = new postenNoEconnectKatsGetshipment.ShipmentPartyAddress ();
            data.ValueAddedServices = new postenNoEconnectKatsGetshipment.ValueAddedServices_element ();
            data.ValueAddedServices.ValueAddedService = new List<postenNoEconnectKatsGetshipment.ValueAddedService>();
            data.SortingMachineInfo = new postenNoEconnectKatsGetshipment.SortingMachineInfo_element ();
            data.SortingMachineInfo.SortingInfo = new List<postenNoEconnectKatsGetshipment.SortingInfo_element>();
            
            
        test.startTest();
            postenNoEconnectAboCrmCrmgetcustome.AddressType add = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
            add.AddrType = 'BILL_TO';
            String[] InformationType=new String[]{'CustomerDetails'};
            List<postenNoEconnectAboCrmCrmgetcustome.AddressType> addList = new List<postenNoEconnectAboCrmCrmgetcustome.AddressType>();
            addList.add(add);
            DataPersistencyController.maintainForwardingTypes(acc.id, eConnectOutParameters.PersonParty.Forwardings.Forwarding);
            DataPersistencyController.maintainForwardingTypes(acc.id, eConnectOutParameters.PersonParty.Forwardings.Forwarding);
            DataPersistencyController.maintainForwarding('89789789');
            DataPersistencyController.maintainAccount(acc);
            DataPersistencyController.maintainAccount('89789789',InformationType);
            DataPersistencyController.updateAccount(acc.id);
            DataPersistencyController.populateBusinessAccount(acc,null);
            DataPersistencyController.maintainPrivateAccount(null);
            DataPersistencyController.populateBusinessAccount(acc,null);
            DataPersistencyController.setAccountAddress(acc,addList,false);
            add.AddrType = 'SHIP_TO';
            DataPersistencyController.setAccountAddress(acc,addList,false);
            DataPersistencyController.getAccount('89789789',false);
            DataPersistencyController.persistAccount(acc);
            //DataPersistencyController.validateEmail('abc@gmail.com');
            DataPersistencyController.maintainShipmentOnRegisteredCase(cas);
            System.debug('~~~data::'+data+'case::'+cas);
            //DataPersistencyController.maintainShipmentOnRegisteredCase(data,cas);
            DataPersistencyController.maintainShipmentOnRegisteredCase(data,cas,true);
            DataPersistencyController.maintainShipmentSender(data,cas);
            DataPersistencyController.maintainShipmentSender(cas);
            DataPersistencyController.maintainShipmentReciever(data,cas);
            DataPersistencyController.maintainShipmentReciever(cas);
            eve.EventCode = 'Q';
            eve.EventName = 'utlevert';
            eve.CaseDescription = '01';
            eve.UnitNumber = '01';
            eve.PostalCode = '01';
            eve.UserName = '01';
            eve.Date_x = System.now();
            eve.EtterregDate = System.now();
            eve.CountryCode = '01';
            eve.Country = '01';
            eve.Cause = '01';
            eve.Action = '01';
            eve.FreeText = '01';
            eve.ShipmentUnitID = '01';
            eve.StationID = '01';
            eve.ReceivedBy = '01';
            eve.Signature = '01';
            eve.SendtBy = '01';
            eve.ReceiverCity = '01';
            cas.LM_First_hendelser_EventDate__c = eve.Date_x.date();
            
            DataPersistencyController.maintainShipmentEvent(cas,data.Events.Event);
            
            update cas;
        test.stopTest();
        
        //Get the forwardings from the test run
        list<ForwardingAddressChange__c> forwardingsToTest = [SELECT id, number__c FROM ForwardingAddressChange__c WHERE account__c = :acc.id];
        
        //Get the forwarding persons from the test run
        map<string, list<ForwardingPerson__c>> mapFP = new map<string, list<ForwardingPerson__c>>();
        for(ForwardingPerson__c fp : [SELECT id, forwardingAddress__c FROM ForwardingPerson__c WHERE forwardingAddress__c in:forwardingsToTest]){
            if(mapFP.containsKey(fp.forwardingAddress__c)){
                mapFP.get(fp.forwardingAddress__c).add(fp);
            } else {
                list<ForwardingPerson__c> newFpList = new list<ForwardingPerson__c>();
                newFpList.add(fp);
                mapFP.put(fp.forwardingAddress__c, newFpList);
            }
        }
        
        //Assert checks
        Integer numberOfForwardingsToGenerate = eConnectOutParameters.PersonParty.Forwardings.Forwarding.size();
        Integer resultNumberOfForwardings = forwardingsToTest.size();
        system.assertEquals(numberOfForwardingsToGenerate, resultNumberOfForwardings, 'The list sizes are not equal! supposed to end up with '
                            + numberOfForwardingsToGenerate
                            + ' forwardings, but got '
                            + resultNumberOfForwardings);

        for(ForwardingAddressChange__c fac : forwardingsToTest) {
            postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwardingType = mapForwardings.get(fac.number__c);
            list<ForwardingPerson__c> listFP =  mapFP.get(fac.id);
            if(forwardingType.OtherParties != null && forwardingType.OtherParties.party != null) {
                Integer numberOfPersonsToGenerate = forwardingType.OtherParties.party.size();
                Integer resultNumberOfPersons = listFP.size();
                system.assertEquals(numberOfPersonsToGenerate, resultNumberOfPersons, 'The list sizes are not equal! supposed to end up with '
                                + numberOfPersonsToGenerate
                                + ' persons, but got '
                                + resultNumberOfPersons);
            }
        }
    }
    
static testMethod void maintainForwardingAddressTwoRunsMyTest3() {
        //Get moc data of an eConnect call
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectOutParameters = mock_Crmgetcustome.getPrivateAccount();
        
        //Create map of the forwarding addresses in the eConnect moc data, we use the data for a private customer in this test
        map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType> mapForwardings = new map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType>();
        for(postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwarding : eConnectOutParameters.PersonParty.Forwardings.Forwarding) {
            mapForwardings.put(forwarding.ForwardingNumber, forwarding);
        }
        
        //Create a dummy account for the test
            Account acc = KatsTestUtilities.getTestPrivateAccount();//new Account(lastName = eConnectOutParameters.PersonParty.Names.LastName, crm_customer_number__c = eConnectOutParameters.PersonParty.PartyNumber);
            //acc.crm_customer_number__c = '89789789';
            //update acc;
        //Run the test
        Case cas = new Case(Subject = 'Test Case', hidden_is_package_with_edi__c = false, Shipment_identification__c= '12121');
            insert cas;
    
            postenNoEconnectKatsGetshipment.ShipmentUnitType data = new postenNoEconnectKatsGetshipment.ShipmentUnitType();
            data.PostingTerminal = new  postenNoEconnectKatsGetshipment.AddressTerminalType() ;
            data.CurrentCity  = new  postenNoEconnectKatsGetshipment.AddressType ();
            data.ShipToAddress = new  postenNoEconnectKatsGetshipment.AddressType ();
            data.ShipToAddress.Street = 'test';
            data.Insurance = new  postenNoEconnectKatsGetshipment.InsuranceType ();
            data.ShipmentDescription = new  postenNoEconnectKatsGetshipment.ShipmentDescription ();
            
            data.Events = new postenNoEconnectKatsGetshipment.Events_element ();
            data.Events.Event = new List<postenNoEconnectKatsGetshipment.ShipmentEventType>();
            postenNoEconnectKatsGetshipment.ShipmentEventType  eve = new postenNoEconnectKatsGetshipment.ShipmentEventType();
            data.Events.Event.add(eve);
            
            data.Sender = new postenNoEconnectKatsGetshipment.ShipmentPartyAddress ();
            data.Sender.PartyNumber ='89789789';
            data.Recipient = new postenNoEconnectKatsGetshipment.ShipmentPartyAddress ();
            data.Recipient.PartyNumber ='89789789';
            data.ValueAddedServices = new postenNoEconnectKatsGetshipment.ValueAddedServices_element ();
            data.ValueAddedServices.ValueAddedService = new List<postenNoEconnectKatsGetshipment.ValueAddedService>();
            data.SortingMachineInfo = new postenNoEconnectKatsGetshipment.SortingMachineInfo_element ();
            data.SortingMachineInfo.SortingInfo = new List<postenNoEconnectKatsGetshipment.SortingInfo_element>();
            postenNoEconnectKatsGetshipment.ValueAddedService vas = new postenNoEconnectKatsGetshipment.ValueAddedService();
            vas.ServiceName = 'testSe';
            data.ValueAddedServices.ValueAddedService.add(vas);
            
        test.startTest();
            postenNoEconnectAboCrmCrmgetcustome.AddressType add = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
            add.AddrType= 'BILL_TO';
            List<postenNoEconnectAboCrmCrmgetcustome.AddressType> addList = new List<postenNoEconnectAboCrmCrmgetcustome.AddressType>();
            addList.add(add);
            LM_Shipment_Event__c oldEvents = new LM_Shipment_Event__c();
            oldEvents.EventCode__c='';
            oldEvents.date__c = System.today();
            oldEvents.case__c = cas.Id;
            insert oldEvents;
            String[] InformationType=new String[]{'CustomerDetails'};
            //DataPersistencyController.maintainForwardingTypes(acc.id, eConnectOutParameters.PersonParty.Forwardings.Forwarding);
            //DataPersistencyController.maintainForwardingTypes(acc.id, eConnectOutParameters.PersonParty.Forwardings.Forwarding);
            DataPersistencyController.maintainForwarding('89789789');
            //DataPersistencyController.maintainAccount(acc);
            DataPersistencyController.maintainAccount('89789789',InformationType);
            //DataPersistencyController.updateAccount(acc.id);
            DataPersistencyController.populateBusinessAccount(acc,null);
            DataPersistencyController.maintainPrivateAccount(null);
            //DataPersistencyController.populateBusinessAccount(acc,null);
            //DataPersistencyController.setAccountAddress(acc,addList,false);
            add.AddrType= 'SHIP_TO';
            //DataPersistencyController.setAccountAddress(acc,addList,false);
            //DataPersistencyController.getAccount('89789789',false);
            //DataPersistencyController.persistAccount(acc);
            //DataPersistencyController.validateEmail('abc@gmail.com');
            DataPersistencyController.maintainShipmentOnRegisteredCase(cas);
            //DataPersistencyController.maintainShipmentOnRegisteredCase(data,cas);
            DataPersistencyController.maintainShipmentOnRegisteredCase(data,cas,true);
            DataPersistencyController.maintainShipmentSender(data,cas);
            DataPersistencyController.maintainShipmentSender(cas);
            DataPersistencyController.maintainShipmentReciever(data,cas);
            DataPersistencyController.maintainShipmentReciever(cas);
            eve.EventCode = 'Q';
            eve.EventName = 'innleveringsregistrert';
            eve.CaseDescription = '01';
            eve.UnitNumber = '01';
            eve.PostalCode = '01';
            eve.UserName = '01';
            eve.Date_x = System.now();
            eve.EtterregDate = System.now();
            eve.CountryCode = '01';
            eve.Country = '01';
            eve.Cause = '01';
            eve.Action = '01';
            eve.FreeText = '01';
            eve.ShipmentUnitID = '01';
            eve.StationID = '01';
            eve.ReceivedBy = '01';
            eve.Signature = '01';
            eve.SendtBy = '01';
            eve.ReceiverCity = '01';
            
            DataPersistencyController.maintainShipmentEvent(cas,data.Events.Event);
            
            eve.EventCode = 'Q';
            eve.EventName = 'innleveringsregistrert';
            eve.CaseDescription = '01';
            eve.UnitNumber = '01';
            eve.PostalCode = '01';
            eve.UserName = '01';
            eve.Date_x = System.now();
            eve.EtterregDate = System.now();
            eve.CountryCode = '01';
            eve.Country = '01';
            eve.Cause = '01';
            eve.Action = '01';
            eve.FreeText = '01';
            eve.ShipmentUnitID = '01';
            eve.StationID = '01';
            eve.ReceivedBy = '01';
            eve.Signature = '01';
            eve.SendtBy = '01';
            eve.ReceiverCity = '01';
            
            test.stopTest();



    }
    
    
    static Testmethod void teststatus()
    {
       /* List<cs_PersonCustomerStatus__c> personsettingList=new List<cs_PersonCustomerStatus__c>();
        
        cs_PersonCustomerStatus__c rec1=new cs_PersonCustomerStatus__c ();
        rec1.Name='01';
        rec1.StatusValue__c='Valid';
        personsettingList.add(rec1);
        
        insert personsettingList;
        
        List<cs_BusinessCustomerStatus__c> businesssettingList=new List<cs_BusinessCustomerStatus__c>();
        
        cs_BusinessCustomerStatus__c rec2=new cs_BusinessCustomerStatus__c();
        rec2.Name='02';
        rec2.StatusValue__c='Valid';
        businesssettingList.add(rec2);
        
        insert businesssettingList;
        
        */
        
        DataPersistencyController.PersonStatus('01','Gyldig');
        DataPersistencyController.OrganizationStatus('02','Gyldig');
        DataPersistencyController.PersonStatus('03','TestStatus');
        DataPersistencyController.OrganizationStatus('03','TestStatus');
    }
    
   static testmethod void testemail()
   {
       DataPersistencyController.validateEmail('mailto:test@test.com');
   }
   
   static testmethod void Testforwarding()
   {
   
      postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType mockBusinessAccount=mock_Crmgetcustome.getbusinessAccount();
      Account testBusinessAccount =new Account();
      testBusinessAccount = new Account();
      testBusinessAccount.Name = mockBusinessAccount.OrganizationParty.LegalName;
      testBusinessAccount.crm_customer_number__c = '89789789';
      testBusinessAccount.Orga__c = mockBusinessAccount.OrganizationParty.CustomerNumber;
      testBusinessAccount.Phone = mockBusinessAccount.OrganizationParty.Communications.Communication.get(0).PhoneNumber;
      testBusinessAccount.BillingStreet = mockBusinessAccount.OrganizationParty.Addresses.Address.get(0).StreetName;
      testBusinessAccount.BillingCity = mockBusinessAccount.OrganizationParty.Addresses.Address.get(0).CityName;
      testBusinessAccount.BillingPostalCode = mockBusinessAccount.OrganizationParty.Addresses.Address.get(0).PostalCode;
      testBusinessAccount.BillingCountry = mockBusinessAccount.OrganizationParty.Addresses.Address.get(0).CountryCode ;
      testBusinessAccount.ShippingStreet = mockBusinessAccount.OrganizationParty.Addresses.Address.get(1).StreetName;
      testBusinessAccount.ShippingCity = mockBusinessAccount.OrganizationParty.Addresses.Address.get(1).CityName;
      testBusinessAccount.ShippingPostalCode = mockBusinessAccount.OrganizationParty.Addresses.Address.get(1).PostalCode;
      testBusinessAccount.ShippingCountry = mockBusinessAccount.OrganizationParty.Addresses.Address.get(1).CountryCode ;
      Id recordtype=[Select id from Recordtype where developername='business_account' and SobjectType='Account' limit 1].id;
      testBusinessAccount.RecordTypeid=recordtype;
    insert testBusinessAccount;
       DataPersistencyController.maintainAdressAndForwarding('89789789');
       
   }
    
    static testmethod void Testevent() {
        
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectOutParameters = mock_Crmgetcustome.getPrivateAccount();
        
        //Create map of the forwarding addresses in the eConnect moc data, we use the data for a private customer in this test
        map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType> mapForwardings = new map<String, postenNoEconnectAboCrmCrmgetcustome.ForwardingType>();
        for(postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwarding : eConnectOutParameters.PersonParty.Forwardings.Forwarding) {
            mapForwardings.put(forwarding.ForwardingNumber, forwarding);
        }
        
        //Create a dummy account for the test
        Account acc = KatsTestUtilities.getTestPrivateAccount();//new Account(lastName = eConnectOutParameters.PersonParty.Names.LastName, crm_customer_number__c = eConnectOutParameters.PersonParty.PartyNumber);
        acc.crm_Account_Inserted__c = true;
            update acc;
        //Run the test
        Case cas = new Case(Subject = 'Test Case',hidden_is_package_with_edi__c =false, AccountId = acc.Id,Shipment_number__c= '12121');
            insert cas;
            postenNoEconnectKatsGetshipment.ShipmentUnitType data = new postenNoEconnectKatsGetshipment.ShipmentUnitType();
            data.PostingTerminal = new  postenNoEconnectKatsGetshipment.AddressTerminalType() ;
            data.CurrentCity  = new  postenNoEconnectKatsGetshipment.AddressType ();
            data.ShipToAddress = new  postenNoEconnectKatsGetshipment.AddressType ();
            data.ShipToAddress.Street = 'test';
            data.Insurance = new  postenNoEconnectKatsGetshipment.InsuranceType ();
            data.ShipmentDescription = new  postenNoEconnectKatsGetshipment.ShipmentDescription ();
            
            data.Events = new postenNoEconnectKatsGetshipment.Events_element ();
            data.Events.Event = new List<postenNoEconnectKatsGetshipment.ShipmentEventType>();
            postenNoEconnectKatsGetshipment.ShipmentEventType  eve = new postenNoEconnectKatsGetshipment.ShipmentEventType();
            data.Events.Event.add(eve);
            
            data.Sender = new postenNoEconnectKatsGetshipment.ShipmentPartyAddress ();
            data.Recipient = new postenNoEconnectKatsGetshipment.ShipmentPartyAddress ();
            data.ValueAddedServices = new postenNoEconnectKatsGetshipment.ValueAddedServices_element ();
            data.ValueAddedServices.ValueAddedService = new List<postenNoEconnectKatsGetshipment.ValueAddedService>();
            data.SortingMachineInfo = new postenNoEconnectKatsGetshipment.SortingMachineInfo_element ();
            data.SortingMachineInfo.SortingInfo = new List<postenNoEconnectKatsGetshipment.SortingInfo_element>();
            
            
        test.startTest();
            postenNoEconnectAboCrmCrmgetcustome.AddressType add = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
            add.AddrType = 'BILL_TO';
            String[] InformationType=new String[]{'CustomerDetails'};
            List<postenNoEconnectAboCrmCrmgetcustome.AddressType> addList = new List<postenNoEconnectAboCrmCrmgetcustome.AddressType>();
            addList.add(add);
            DataPersistencyController.maintainForwardingTypes(acc.id, eConnectOutParameters.PersonParty.Forwardings.Forwarding);
            DataPersistencyController.maintainForwardingTypes(acc.id, eConnectOutParameters.PersonParty.Forwardings.Forwarding);
            DataPersistencyController.maintainForwarding('89789789');
            DataPersistencyController.maintainAccount(acc);
            DataPersistencyController.maintainAccount('89789789',InformationType);
            DataPersistencyController.updateAccount(acc.id);
            DataPersistencyController.populateBusinessAccount(acc,null);
            DataPersistencyController.maintainPrivateAccount(null);
            DataPersistencyController.populateBusinessAccount(acc,null);
            DataPersistencyController.setAccountAddress(acc,addList,false);
            add.AddrType = 'SHIP_TO';
            DataPersistencyController.setAccountAddress(acc,addList,false);
            DataPersistencyController.getAccount('89789789',false);
            DataPersistencyController.persistAccount(acc);
            //DataPersistencyController.validateEmail('abc@gmail.com');
            DataPersistencyController.maintainShipmentOnRegisteredCase(cas);
           // DataPersistencyController.maintainShipmentOnRegisteredCase(data,cas);
            DataPersistencyController.maintainShipmentOnRegisteredCase(data,cas,true);
            DataPersistencyController.maintainShipmentSender(data,cas);
            DataPersistencyController.maintainShipmentSender(cas);
            DataPersistencyController.maintainShipmentReciever(data,cas);
            DataPersistencyController.maintainShipmentReciever(cas);
            eve.EventCode = 'T';
            eve.EventName = 'FORHÅNDSMELDT';
            eve.CaseDescription = '01';
            eve.UnitNumber = '01';
            eve.PostalCode = '01';
            eve.UserName = '01';
            eve.Date_x = System.now();
            eve.EtterregDate = System.now();
            eve.CountryCode = '01';
            eve.Country = '01';
            eve.Cause = '01';
            eve.Action = '01';
            eve.FreeText = '01';
            eve.ShipmentUnitID = '01';
            eve.StationID = '01';
            eve.ReceivedBy = '01';
            eve.Signature = '01';
            eve.SendtBy = '01';
            eve.ReceiverCity = '01';
            data.Events.Event.add(eve);
            cas.LM_First_hendelser_EventDate__c = eve.Date_x.date();
            
            DataPersistencyController.maintainShipmentEvent(cas,data.Events.Event);
            
            update cas;
        test.stopTest();
    }
    
}