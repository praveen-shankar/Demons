@isTest
private class zzz_postenNoEconnectUtilities {
 
    /*******************
    *** TEST METHODS ***
    *******************/
    
    private static testMethod void loadFinalVariables_1() {
        String CLIENT_CERT_NAME = 'Sandbox';
        String ECONNECT_ENDPOINT_URI = 'Sandbox';
        
        delete Organization_environment_settings__c.getall().values();
        
        Test.startTest();
            postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        Test.stopTest();
        
        system.assertEquals(CLIENT_CERT_NAME, eConnect.getCertificateName());
        system.assertEquals(ECONNECT_ENDPOINT_URI, eConnect.getEndpointURI());
    }
    
    private static testMethod void loadFinalVariables_2() {
        String CLIENT_CERT_NAME = 'testCertificate';
        String ECONNECT_ENDPOINT_URI = 'testURI';
        String SANDBOX_NAME = 'TestSandbox';
        String ENVIRONMENT_TYPE = 'Test';
        
        delete Organization_environment_settings__c.getall().values();
        
        Organization_environment_settings__c testSetting = new Organization_environment_settings__c();
            testSetting.Name = UserInfo.getOrganizationId();
            testSetting.eConnectCertificateName__c = CLIENT_CERT_NAME;
            testSetting.eConnectEndpointURI__c = ECONNECT_ENDPOINT_URI;
            testSetting.Sandbox_name__c = SANDBOX_NAME;
            testSetting.Environment_type__c =  ENVIRONMENT_TYPE;
        insert testSetting;
        
        Test.startTest();
            postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        Test.stopTest();
        
        system.assertEquals(CLIENT_CERT_NAME, eConnect.getCertificateName());
        system.assertEquals(ECONNECT_ENDPOINT_URI, eConnect.getEndpointURI());
    }
    
    private static testMethod void loadFinalVariables_3() {
        String CLIENT_CERT_NAME = 'testCertificate';
        String ECONNECT_ENDPOINT_URI = 'testURI';
        String SANDBOX_NAME = 'TestSandbox';
        String ENVIRONMENT_TYPE = 'Test';
        
        delete Organization_environment_settings__c.getall().values();
        
        Organization_environment_settings__c testSetting1 = new Organization_environment_settings__c();
            testSetting1.Name = UserInfo.getOrganizationId();
            testSetting1.eConnectCertificateName__c = CLIENT_CERT_NAME;
            testSetting1.eConnectEndpointURI__c = ECONNECT_ENDPOINT_URI;
            testSetting1.Sandbox_name__c = SANDBOX_NAME;
            testSetting1.Environment_type__c =  ENVIRONMENT_TYPE;
        insert testSetting1;
        
        Organization_environment_settings__c testSetting2 = new Organization_environment_settings__c();
            testSetting2.Name = '00D20000000TESTabc';
            testSetting2.eConnectCertificateName__c = 'prodCertificate';
            testSetting2.eConnectEndpointURI__c = 'prodURI';
            testSetting2.Sandbox_name__c = 'ProdOrg';
            testSetting2.Environment_type__c =  'PROD';
        insert testSetting2;
        
        Test.startTest();
            postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        Test.stopTest();
        
        system.assertEquals(CLIENT_CERT_NAME, eConnect.getCertificateName());
        system.assertEquals(ECONNECT_ENDPOINT_URI, eConnect.getEndpointURI());
        system.assertNotEquals(testSetting2.eConnectCertificateName__c, eConnect.getCertificateName());
        system.assertNotEquals(testSetting2.eConnectEndpointURI__c, eConnect.getEndpointURI());
    }
    
    private static testMethod void isProductionEconnectURIInSandbox() {
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        
        Test.startTest();
            Boolean actual = eConnect.isProductionEconnectURIInSandbox();
        Test.stopTest();
        
        system.assert(false == actual, 'this test should be successful in QA/sandboxes! Check the eConnectEndpointURI is pointing to correct eConnect environment');
    }
    
    /*
    static testMethod void searchShipment() {
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        params.put('ShipmentID', 'testValue');
        params.put('ShipmentUnitID', 'testValue');
        
        eConnect.SearchShipment('10', params); 
    }
    */

    static testMethod void postenNoEconnectKatsSakgetcustomer() {
     
        new postenNoEconnectKatsSakgetcustomer.KATS_SakInvoiceType ();
        new postenNoEconnectKatsSakgetcustomer.KATS_SakAgreementType ();
        new postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerInParameters ();
        new postenNoEconnectKatsSakgetcustomer.Orders_element();
        new postenNoEconnectKatsSakgetcustomer.OtherParties_element();
        new postenNoEconnectKatsSakgetcustomer.KATS_SakCustomerOrganizationType();
        new postenNoEconnectKatsSakgetcustomer.KATS_SakOrderType();
        new postenNoEconnectKatsSakgetcustomer.KATS_SakForwardingType();
        new postenNoEconnectKatsSakgetcustomer.Forwardings_element();
        new postenNoEconnectKatsSakgetcustomer.KATS_SakCustomerPersonType();
        new postenNoEconnectKatsSakgetcustomer.Invoices_element();
        new postenNoEconnectKatsSakgetcustomer.KATS_SakCommunicationType();
        new postenNoEconnectKatsSakgetcustomer.Communications_element();
        new postenNoEconnectKatsSakgetcustomer.Divisions_element();
        new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType(); 
        new postenNoEconnectKatsSakgetcustomer.KATS_SakCaseType(); 
        new postenNoEconnectKatsSakgetcustomer.KATS_SakDivisionType(); 
        new postenNoEconnectKatsSakgetcustomer.KATS_SakSalesPersonType();
        new postenNoEconnectKatsSakgetcustomer.ContactsComplexType();
        new postenNoEconnectKatsSakgetcustomer.KATS_SakActivityType();
        new postenNoEconnectKatsSakgetcustomer.KATS_SakCommunicationType();
        new postenNoEconnectKatsSakgetcustomer.KATS_SakCommunicationType();
        //new postenNoEconnectKatsSakgetcustomer.KATS_SakCustomerType();
        //Updating test class for get customer- 30-12-2016
        new postenNoEconnectAboCrmCrmgetcustome.InvoiceType ();
        new postenNoEconnectAboCrmCrmgetcustome.AgreementType ();
        //new postenNoEconnectAboCrmCrmgetcustome.GetCustomerInParameters ();
        new postenNoEconnectAboCrmCrmgetcustome.Orders_element();
        new postenNoEconnectAboCrmCrmgetcustome.OtherParties_element();
        new postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType();
        new postenNoEconnectAboCrmCrmgetcustome.OrderType();
        new postenNoEconnectAboCrmCrmgetcustome.ForwardingType();
        new postenNoEconnectAboCrmCrmgetcustome.Forwardings_element();
        new postenNoEconnectAboCrmCrmgetcustome.CustomerPersonType();
        new postenNoEconnectAboCrmCrmgetcustome.Invoices_element();
        new postenNoEconnectAboCrmCrmgetcustome.CommunicationType();
        new postenNoEconnectAboCrmCrmgetcustome.Communications_element();
       // new postenNoEconnectAboCrmCrmgetcustome.Divisions_element();
        new postenNoEconnectAboCrmCrmgetcustome.PersonNameType(); 
        new postenNoEconnectAboCrmCrmgetcustome.CaseType(); 
        //new postenNoEconnectAboCrmCrmgetcustome.DivisionType(); 
        new postenNoEconnectAboCrmCrmgetcustome.SalesPersonType();
       // new postenNoEconnectAboCrmCrmgetcustome.ContactsComplexType();
        new postenNoEconnectAboCrmCrmgetcustome.ActivityType();
        new postenNoEconnectAboCrmCrmgetcustome.CommunicationType();
        new postenNoEconnectAboCrmCrmgetcustome.CommunicationType();
        
        //Wrapper class
        String a = ''; 
        new EConnectWrapper_GetCustomerData(new postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType());
        EConnectWrapper_GetCustomerData.PersonParty person = new EConnectWrapper_GetCustomerData.PersonParty(new postenNoEconnectAboCrmCrmgetcustome.CustomerPersonType());
        EConnectWrapper_GetCustomerData.OrganizationParty organization = new EConnectWrapper_GetCustomerData.OrganizationParty(new postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType());
        EConnectWrapper_GetCustomerData.CommunicationElement communicationElement = new EConnectWrapper_GetCustomerData.CommunicationElement(new postenNoEconnectAboCrmCrmgetcustome.Communications_element());
            List<EConnectWrapper_GetCustomerData.CommunicationType> ct = communicationElement.communicationTypes;
        EConnectWrapper_GetCustomerData.CommunicationType communication = new EConnectWrapper_GetCustomerData.CommunicationType(new postenNoEconnectAboCrmCrmgetcustome.CommunicationType());
        EConnectWrapper_GetCustomerData.AddressElement addressElement = new EConnectWrapper_GetCustomerData.AddressElement(new postenNoEconnectAboCrmCrmgetcustome.Addresses_element());
            List<EConnectWrapper_GetCustomerData.AddressType> addressType = addressElement.addressTypes;
        EConnectWrapper_GetCustomerData.AddressType address = new EConnectWrapper_GetCustomerData.AddressType(new postenNoEconnectAboCrmCrmgetcustome.AddressType());
       /* EConnectWrapper_GetCustomerData.DivisionElement divisionElement = new EConnectWrapper_GetCustomerData.DivisionElement(new postenNoEconnectKatsSakgetcustomer.Divisions_Element());
            List<EConnectWrapper_GetCustomerData.DivisionType> divisionType = divisionElement.divisionTypes;
        new EConnectWrapper_GetCustomerData.DivisionType(new postenNoEconnectKatsSakgetcustomer.KATS_SakDivisionType() );
        EConnectWrapper_GetCustomerData.ContactsElement ContactsElement = new EConnectWrapper_GetCustomerData.ContactsElement( new postenNoEconnectKatsSakgetcustomer.ContactsComplexType() );
            List<EConnectWrapper_GetCustomerData.ContactElement> ContactElement = ContactsElement.contactElements;
        new EConnectWrapper_GetCustomerData.ContactElement( new postenNoEconnectKatsSakgetcustomer.ContactComplexType() );*/
        EConnectWrapper_GetCustomerData.SalesPersonType salesPerson = new EConnectWrapper_GetCustomerData.SalesPersonType( new postenNoEconnectAboCrmCrmgetcustome.SalesPersonType() );
        EConnectWrapper_GetCustomerData.PersonNameType nameType = new EConnectWrapper_GetCustomerData.PersonNameType( new postenNoEconnectAboCrmCrmgetcustome.PersonNameType() );
        new EConnectWrapper_GetCustomerData.ForwardingElement( new postenNoEconnectAboCrmCrmgetcustome.Forwardings_element() );
        EConnectWrapper_GetCustomerData.ForwardingType forwarding = new EConnectWrapper_GetCustomerData.ForwardingType( new postenNoEconnectAboCrmCrmgetcustome.ForwardingType() );
        EConnectWrapper_GetCustomerData.OrderElement OrderElement = new EConnectWrapper_GetCustomerData.OrderElement( new postenNoEconnectAboCrmCrmgetcustome.Orders_element() );
            List<EConnectWrapper_GetCustomerData.OrderType> order = OrderElement.orderTypes;
        EConnectWrapper_GetCustomerData.OrderType orderType = new EConnectWrapper_GetCustomerData.OrderType ( new postenNoEconnectAboCrmCrmgetcustome.OrderType() );
        new EConnectWrapper_GetCustomerData.InvoiceElement ( new postenNoEconnectAboCrmCrmgetcustome.Invoices_element() );
        EConnectWrapper_GetCustomerData.InvoiceType invoice = new EConnectWrapper_GetCustomerData.InvoiceType ( new postenNoEconnectAboCrmCrmgetcustome.InvoiceType() );
        new EConnectWrapper_GetCustomerData.OtherPartiesElement ( new postenNoEconnectAboCrmCrmgetcustome.OtherParties_element() );
    }
    static testMethod void postenNoEconnectKatsSaksearchcustome() {
        new postenNoEconnectKatsSaksearchcustome.Person_element();
        new postenNoEconnectKatsSaksearchcustome.CustomerList_element();
        new postenNoEconnectKatsSaksearchcustome.Order_element();
        new postenNoEconnectKatsSaksearchcustome.Party_element();
        new postenNoEconnectKatsSaksearchcustome.Communications_element();
        new postenNoEconnectKatsSaksearchcustome.Forwarding_element();
        new postenNoEconnectKatsSaksearchcustome.Division_element();
        new postenNoEconnectKatsSaksearchcustome.Receivable_element();
        new postenNoEconnectKatsSaksearchcustome.Customer_element();
        new postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerInParameters();
        new postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerOutParameters();
        new postenNoEconnectKatsSaksearchcustome.RequestAddress_element();
        new postenNoEconnectKatsSaksearchcustome.ResponseAddress_element();
        new postenNoEconnectKatsSaksearchcustome.Organization_element();
    }

    static testMethod void postenNoEconnectEc411gheader() {
        new postenNoEconnectEc411gheader.Property_element();
    }    

    @isTest
    public static void testRemoveUnwantedSearchResults() {
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        postenNoEconnectKatsSaksearchcustome.Customer_element customer1 = new postenNoEconnectKatsSaksearchcustome.Customer_element();
        postenNoEconnectKatsSaksearchcustome.Customer_element customer2 = new postenNoEconnectKatsSaksearchcustome.Customer_element();
        postenNoEconnectKatsSaksearchcustome.Customer_element customer3 = new postenNoEconnectKatsSaksearchcustome.Customer_element();
        postenNoEconnectKatsSaksearchcustome.Customer_element customer4 = new postenNoEconnectKatsSaksearchcustome.Customer_element();
        postenNoEconnectKatsSaksearchcustome.RevenueType rev1 = new postenNoEconnectKatsSaksearchcustome.RevenueType();
        postenNoEconnectKatsSaksearchcustome.RevenueType rev2 = new postenNoEconnectKatsSaksearchcustome.RevenueType();
        postenNoEconnectKatsSaksearchcustome.RevenueType rev3 = new postenNoEconnectKatsSaksearchcustome.RevenueType();
        postenNoEconnectKatsSaksearchcustome.RevenueType rev4 = new postenNoEconnectKatsSaksearchcustome.RevenueType();
        postenNoEconnectKatsSaksearchcustome.CustomerList_element customers = new postenNoEconnectKatsSaksearchcustome.CustomerList_element();
        
        customers.Customer = new List<postenNoEconnectKatsSaksearchcustome.Customer_element>();
        rev1.TotalRevenueCurrentYear_L = 0.0;
        rev1.TotalRevenuePreviousYear_L = 0.0;
        rev1.TotalRevenueCurrentYear_P = 0.0;
        rev1.TotalRevenuePreviousYear_P = 0.0;
        customer1.Division = new postenNoEconnectKatsSaksearchcustome.Division_element[]{new postenNoEconnectKatsSaksearchcustome.Division_element()};
        customer1.Division[0].CRMInactive = 1;
        customer1.Revenues = rev1;
        customer1.PartyName = 'My test company';
        customers.Customer.add(customer1);

        rev2.TotalRevenueCurrentYear_L = 0.0;
        rev2.TotalRevenuePreviousYear_L = 0.0;
        rev2.TotalRevenueCurrentYear_P = 0.0;
        rev2.TotalRevenuePreviousYear_P = 0.0;
        customer2.Division = new postenNoEconnectKatsSaksearchcustome.Division_element[]{new postenNoEconnectKatsSaksearchcustome.Division_element()};
        customer2.Division[0].CRMInactive = 1;
        customer2.Revenues = rev2;
        customer2.PartyName = 'My test company';
        customers.Customer.add(customer2);

        rev3.TotalRevenueCurrentYear_L = 0.0;
        rev3.TotalRevenuePreviousYear_L = 0.0;
        rev3.TotalRevenueCurrentYear_P = 0.0;
        rev3.TotalRevenuePreviousYear_P = 0.0;
        customer3.PartyName = 'My test company';
        customer3.Division = new postenNoEconnectKatsSaksearchcustome.Division_element[]{new postenNoEconnectKatsSaksearchcustome.Division_element()};
        customer3.Division[0].CRMInactive = 0;
        customer3.Revenues = rev3;
        customers.Customer.add(customer3);
        
        rev4.TotalRevenueCurrentYear_L = 0.0;
        rev4.TotalRevenuePreviousYear_L = 200;
        rev4.TotalRevenueCurrentYear_P = 0.0;
        rev4.TotalRevenuePreviousYear_P = 200;
        customer4.PartyName = 'My test company';
        customer4.Division = new postenNoEconnectKatsSaksearchcustome.Division_element[]{new postenNoEconnectKatsSaksearchcustome.Division_element()};
        customer4.Division[0].CRMInactive = 1;
        customer4.Revenues = rev4;
        customers.Customer.add(customer4);
        
        Test.startTest();
        customers.Customer = eConnect.removeUnwantedResults(customers.Customer);
        Test.stopTest();
        System.assertEquals(2, customers.Customer.size(), 'Only two customers should remain: customer1 and customer2 should be removed');
        System.assertEquals(customers.Customer.get(0), customer3, 'customer1 should be removed');
        System.assertEquals(customers.Customer.get(1), customer4, 'customer2 should be removed');
    }

}