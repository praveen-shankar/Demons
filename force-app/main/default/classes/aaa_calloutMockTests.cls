/*

    CalloutTests must run before the other tests or 
    else they will return this error:
        System.CalloutException: You have uncommitted work pending. Please commit or rollback before calling out

*/
@isTest
private class aaa_calloutMockTests {

    static testMethod void postenNoEconnectKatsOrderEventRelease_1() {
        Test.setMock(WebServiceMock.class, new mock_Katsordereventr.mock_OK());
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        
        String OrderLineID = 'orderId';
        String LogInfo = 'logInfo';
        String KATSUserName = 'UserName';
        String KATSCaseNumber = '000000';
        
        String result;
        
        Test.startTest();
            result = eConnect.orderEventRelease(OrderLineID, LogInfo, KATSUserName, KATSCaseNumber);
        Test.stopTest();
        
        system.assertEquals('OK', result);
    }
    
    static testMethod void postenNoEconnectKatsOrderEventRelease_2() {
        Test.setMock(WebServiceMock.class, new mock_Katsordereventr.mock_FAILED());
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        
        String OrderLineID = 'orderId';
        String LogInfo = 'logInfo';
        String KATSUserName = 'UserName';
        String KATSCaseNumber = '000000';
        
        String result;
        
        Test.startTest();
            result = eConnect.orderEventRelease(OrderLineID, LogInfo, KATSUserName, KATSCaseNumber);
        Test.stopTest();
        
        system.assertEquals('FAILED', result);
    }
    
    static testMethod void postenNoEconnectKatsGetshipmen_1() {
        Test.setMock(WebServiceMock.class, new mock_KatsGetshipment.mock_shipment());
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        
        Test.startTest();
            eConnect.getShipment('000000000000000000');
        Test.stopTest();
    }
    
    static testMethod void postenNoEconnectKatsGetshipmen_2() {
        Test.startTest();
            mock_KatsGetshipment.getShipment();
        Test.stopTest();
    }
    
    static testMethod void postenNoKatsHelloworld_1() {
        Test.setMock(WebServiceMock.class, new mock_KatsHelloworld.mock_helloWorld());
        postenNoKatsHelloworld.NewPort helloWorld = new postenNoKatsHelloWorld.NewPort();
        
        String result;
        
        Test.startTest();
            result = helloWorld.getResponse('hello');
        Test.stopTest();
        
        system.assertEquals('TEST', result);
    }
    
    static testMethod void postenNoKatsHelloworld_2() {
        Test.startTest();
             mock_KatsHelloworld.getHelloWorld();
        Test.stopTest();
    }
    
    static testMethod void postenNoEconnectKatsSakgetcustomer_1() {
        Test.setMock(WebServiceMock.class, new mock_Crmgetcustome.mock_businessAccount());
        
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        String[] InfromationType=new String[]{'CustomerDetails'};
        Test.startTest();
            eConnect.getCustomer('1234567','1234567',InfromationType);
        Test.stopTest();
    }
    
    static testMethod void postenNoEconnectKatsSakgetcustomer_2() {
        Test.setMock(WebServiceMock.class, new mock_Crmgetcustome.mock_privateAccount());
        
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
       String[] InfromationType=new String[]{'CustomerDetails'};
        Test.startTest();
            eConnect.getCustomer('1234567','1234567',InfromationType);
        Test.stopTest();
    }
    
    static testMethod void postenNoEconnectKatsSakgetcustomer_3() {
        Test.setMock(WebServiceMock.class, new mock_Crmgetcustome.mock_emptyAccount());
        
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        
       String[] InfromationType=new String[]{'CustomerDetails'};
        Test.startTest();
            eConnect.getCustomer('1234567','1234567',InfromationType);
        Test.stopTest();
    }
    
    static testMethod void postenNoEconnectKatsSaksearchcustome_1() {
        Test.setMock(WebServiceMock.class, new mock_KatsSaksearchcustomer.privateSearch());
        
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
         map<string, string> searchCustomerParams = new map<string, string>();
        searchCustomerParams.put('party_type', 'Organization');
        searchCustomerParams.put('party_number', 'party_number');
        searchCustomerParams.put('account_number', 'account_number');
        searchCustomerParams.put('person_national_identification_number', 'person_national_identification_number');
        searchCustomerParams.put('person_first_name', 'person_first_name');
        searchCustomerParams.put('person_middle_name', 'person_middle_name');
        searchCustomerParams.put('person_last_name', 'person_last_name');
        searchCustomerParams.put('org_name', 'org_name');
        searchCustomerParams.put('org_fiscal_reference', 'org_fiscal_reference');
        searchCustomerParams.put('org_contactFirstName', 'org_contactFirstName');
        searchCustomerParams.put('org_contactLastName', 'org_contactLastName');
        searchCustomerParams.put('address_house_number', 'address_house_number');
        searchCustomerParams.put('address_postal_code', 'address_postal_code');
        searchCustomerParams.put('address_city', 'address_city');
        searchCustomerParams.put('address_municipality_code', 'address_municipality_code');
        searchCustomerParams.put('address_municipality_name', 'address_municipality_name');
        searchCustomerParams.put('address_po_box_number', 'address_po_box_number');
        searchCustomerParams.put('address_street_name', 'address_street_name');
        searchCustomerParams.put('address_house_letter', 'address_house_letter');
        searchCustomerParams.put('phone', 'phone');
        searchCustomerParams.put('email', 'email');
        Test.startTest();
            econnect.searchCustomerFAR(searchCustomerParams);
        Test.stopTest();
    }
    
    static testMethod void postenNoEconnectKatsSaksearchcustome_2() {
        Test.setMock(WebServiceMock.class, new mock_KatsSaksearchcustomer.businessSearch());
         postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
         map<string, string> searchCustomerParams = new map<string, string>();
        searchCustomerParams.put('party_type', 'Organization');
        searchCustomerParams.put('party_number', 'party_number');
        searchCustomerParams.put('account_number', 'account_number');
        searchCustomerParams.put('person_national_identification_number', 'person_national_identification_number');
        searchCustomerParams.put('person_first_name', 'person_first_name');
        searchCustomerParams.put('person_middle_name', 'person_middle_name');
        searchCustomerParams.put('person_last_name', 'person_last_name');
        searchCustomerParams.put('org_name', 'org_name');
        searchCustomerParams.put('org_fiscal_reference', 'org_fiscal_reference');
        searchCustomerParams.put('org_contactFirstName', 'org_contactFirstName');
        searchCustomerParams.put('org_contactLastName', 'org_contactLastName');
        searchCustomerParams.put('address_house_number', 'address_house_number');
        searchCustomerParams.put('address_postal_code', 'address_postal_code');
        searchCustomerParams.put('address_city', 'address_city');
        searchCustomerParams.put('address_municipality_code', 'address_municipality_code');
        searchCustomerParams.put('address_municipality_name', 'address_municipality_name');
        searchCustomerParams.put('address_po_box_number', 'address_po_box_number');
        searchCustomerParams.put('address_street_name', 'address_street_name');
        searchCustomerParams.put('address_house_letter', 'address_house_letter');
        searchCustomerParams.put('phone', 'phone');
        searchCustomerParams.put('email', 'email');
        Test.startTest();
            econnect.searchCustomerFAR(searchCustomerParams);
        Test.stopTest();
    }
    
    static testMethod void postenNoEconnectKatsSaksearchcustome_3() {
        Test.startTest();
            mock_KatsSaksearchcustomer.getBusinessSearch();
            mock_KatsSaksearchcustomer.getPrivateSearch();
            mock_Crmgetcustome.getPrivateAccount();
        Test.stopTest();
    }
    
    static testMethod void cti_CustomerInfo_getAccount() {
        Test.setMock(WebServiceMock.class, new mock_KatsSaksearchcustomer.emptySearch());
        
        cti_CustomerInfo customerInfo = new cti_CustomerInfo();
        
        //Test.startTest();
           // Account theAccount = customerInfo.getAccountByAPhoneNumber('abcdefg');
        //Test.stopTest();
        //System.assert(theAccount == null);
    }
     static testmethod void testsearchpartycrm()
    {
        Map<String,String> searchparams=new Map<String,String>();
        postenNoEconnectUtilities econnect=new postenNoEconnectUtilities();
        searchparams.put('order_number','ordernumber');
        searchparams.put('receivable_number','receivable');
        searchparams.put('forwardingnumber','forwarding');
        econnect.SearchPartyCRM(searchparams);
    }
    
    /*
    static testMethod void testShipmentOverviewComponent() {
        Test.setMock(WebServiceMock.class, new mock_KatsGetshipment.mock_shipment());
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        List<ShipmentWrapper> wrapperList = new List<ShipmentWrapper>();
        
        map<String, String> searchShipmentParams = new map<String, String>();
        searchShipmentParams.put('ShipmentID', 'Test');     
        
        List<postenNoEconnectKatsSearchshipment.TShipmentUnit> econnectReply = eConnect.searchShipment('10', searchShipmentParams);
        for (postenNoEconnectKatsSearchshipment.TShipmentUnit replyElement : econnectReply){
            wrapperList.add(new ShipmentWrapper(replyElement, 
                                                    new EConnectWrapper_GetShipmentData(eConnect.getShipment(replyElement.ShipmentUnitID))));
        }
        
        ShipmentOverviewComponent component = new ShipmentOverviewComponent();
        
        component.populateShipmentMap(wrapperList);
        
        System.assertEquals(wrapperList.size(), component.shipmentMap.size());
        
        component.currentShipmentUnitID = wrapperList.get(0).ShipmentUnitID;
        
        component.showShipmentDetails();
        
        system.assertEquals(wrapperList.get(0).wrapper, component.wrapper);
    }*/
}