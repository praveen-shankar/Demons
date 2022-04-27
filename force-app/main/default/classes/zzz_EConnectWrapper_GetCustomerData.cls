@isTest
private class zzz_EConnectWrapper_GetCustomerData {

    static testMethod void EConnectWrapper_GetCustomerData_1() {
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectData
            = mock_Crmgetcustome.getPrivateAccount();
        EConnectWrapper_GetCustomerData ew;
        Test.startTest();
            ew = new EConnectWrapper_GetCustomerData(eConnectData);
        Test.stopTest();
        
       // system.assertEquals('', ew.listType); listtype is removed
        system.assertNotEquals(null, ew.organizationParty);
        system.assertNotEquals(null, ew.personParty);
    }
    
    static testMethod void EConnectWrapper_GetCustomerData_2() {
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectData
            = mock_Crmgetcustome.getBusinessAccount();
        EConnectWrapper_GetCustomerData ew;
        Test.startTest();
            ew = new EConnectWrapper_GetCustomerData(eConnectData);
        Test.stopTest();
        
      //  system.assertEquals('', ew.listType); listtype is removed
        system.assertNotEquals(null, ew.personParty);
        system.assertNotEquals(null, ew.organizationParty);
    }
    
    static testMethod void OrganizationParty_1() {
        postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty;
        
        EConnectWrapper_GetCustomerData.OrganizationParty op;
        
        Test.startTest();
            op = new EConnectWrapper_GetCustomerData.OrganizationParty(eConnectData);
        Test.stopTest();
        
        //system.assertEquals(eConnectData.PartyNumber, op.PartyNumber);
        //system.assertEquals(eConnectData.Status, op.Status);
        //system.assertEquals(eConnectData.CustomerNumber, op.CustomerNumber);
        //system.assertEquals(eConnectData.MarketName, op.MarketName);
        //system.assertEquals(eConnectData.LegalName, op.LegalName);
        //system.assertEquals(eConnectData.FiscalCode, op.FiscalCode);
        
        //system.assertNotEquals(null, op.addressElements);
        //system.assertNotEquals(null, op.communicationElements);
        //system.assertNotEquals(null, op.contactsElements);
        //system.assertNotEquals(null, op.divisionElements);
        //system.assertNotEquals(null, op.forwardingElements);
        //system.assertNotEquals(null, op.invoiceElements);
        //system.assertNotEquals(null, op.orderElements);
    }
    
    static testMethod void OrganizationParty_2() {
        EConnectWrapper_GetCustomerData.OrganizationParty op;
        
        Test.startTest();
            op = new EConnectWrapper_GetCustomerData.OrganizationParty();
        Test.stopTest();
        
        system.assertEquals('-', op.PartyNumber);
        system.assertEquals('-', op.Status);
        system.assertEquals('-', op.CustomerNumber);
        //system.assertEquals('-', op.MarketName);
        //system.assertEquals('-', op.LegalName);
        system.assertEquals('-', op.FiscalCode);
        
        system.assertNotEquals(null, op.addressElements);
        system.assertNotEquals(null, op.communicationElements);
        //system.assertNotEquals(null, op.contactsElements);
        //system.assertNotEquals(null, op.divisionElements);
        system.assertNotEquals(null, op.forwardingElements);
        system.assertNotEquals(null, op.invoiceElements);
        system.assertNotEquals(null, op.orderElements);
    }
    
    static testMethod void PersonParty_1() {
         postenNoEconnectAboCrmCrmgetcustome.CustomerPersonType eConnectData
            = mock_Crmgetcustome.getPrivateAccount().PersonParty;
        
        EConnectWrapper_GetCustomerData.PersonParty pp;
        
        Test.startTest();
            pp = new EConnectWrapper_GetCustomerData.PersonParty(eConnectData);
        Test.stopTest();
        
        //system.assertEquals(eConnectData.PartyNumber, pp.PartyNumber);
        //system.assertEquals(eConnectData.Status, pp.Status);
        //system.assertEquals(eConnectData.CustomerNumber, pp.CustomerNumber);
        
        //system.assertNotEquals(null, pp.addressElements);
        //system.assertNotEquals(null, pp.communicationElements);
        //system.assertNotEquals(null, pp.forwardingElements);
        //system.assertNotEquals(null, pp.invoiceElements);
        //system.assertNotEquals(null, pp.orderElements);
    }
    
    static testMethod void PersonParty_2() {
        EConnectWrapper_GetCustomerData.PersonParty pp;
        
        Test.startTest();
            pp = new EConnectWrapper_GetCustomerData.PersonParty();
        Test.stopTest();
        
        system.assertEquals('-', pp.PartyNumber);
        system.assertEquals('-', pp.Status);
        system.assertEquals('-', pp.CustomerNumber);
        
        system.assertNotEquals(null, pp.addressElements);
        system.assertNotEquals(null, pp.communicationElements);
    }
    
    static testMethod void CommunicationElement_1() {
        postenNoEconnectAboCrmCrmgetcustome.Communications_element eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Communications;
        
        EConnectWrapper_GetCustomerData.CommunicationElement ce;
        
        Test.startTest();
            ce = new EConnectWrapper_GetCustomerData.CommunicationElement(eConnectData);
        Test.stopTest();
        
        system.assertEquals(false, ce.communicationTypes.isEmpty());
    }
    
    static testMethod void CommunicationElement_2() {
        EConnectWrapper_GetCustomerData.CommunicationElement ce;
        
        Test.startTest();
            ce = new EConnectWrapper_GetCustomerData.CommunicationElement();
        Test.stopTest();
        
        system.assertEquals(false, ce.communicationTypes.isEmpty());
    }
    
    static testMethod void CommunicationType_1() {
        postenNoEconnectAboCrmCrmgetcustome.CommunicationType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Communications.Communication.get(0);
        
        EConnectWrapper_GetCustomerData.CommunicationType ct;
        
        Test.startTest();
            ct = new EConnectWrapper_GetCustomerData.CommunicationType(eConnectData);
        Test.stopTest();
        
        system.assertEquals(eConnectData.PhoneNumber, ct.PhoneNumber);
        system.assertEquals(eConnectData.MobileNumber, ct.MobileNumber);
        system.assertEquals(eConnectData.EMailAddress, ct.EMailAddress);
    }
    
    static testMethod void CommunicationType_2() {
        postenNoEconnectAboCrmCrmgetcustome.CommunicationType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Communications.Communication.get(1);
        
        EConnectWrapper_GetCustomerData.CommunicationType ct;
        
        Test.startTest();
            ct = new EConnectWrapper_GetCustomerData.CommunicationType(eConnectData);
        Test.stopTest();
        
        system.assertEquals(eConnectData.PhoneNumber, ct.PhoneNumber);
        system.assertEquals(null, ct.MobileNumber);
        system.assertEquals('-', ct.EMailAddress);
    }
    
    static testMethod void CommunicationType_3() {
        EConnectWrapper_GetCustomerData.CommunicationType ct;
        
        Test.startTest();
            ct = new EConnectWrapper_GetCustomerData.CommunicationType();
        Test.stopTest();
        
        system.assertEquals('-', ct.PhoneNumber);
        system.assertEquals('-', ct.MobileNumber);
        system.assertEquals('-', ct.EMailAddress);
    }
    
    static testMethod void AddressElement_1() {
        postenNoEconnectAboCrmCrmgetcustome.Addresses_element eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Addresses;
        
        EConnectWrapper_GetCustomerData.AddressElement ae;
        
        Test.startTest();
            ae = new EConnectWrapper_GetCustomerData.AddressElement(eConnectData);
        Test.stopTest();
        
        system.assertEquals(false, ae.addressTypes.isEmpty());
    }
    
    static testMethod void AddressElement_2() {
        EConnectWrapper_GetCustomerData.AddressElement ae;
        
        Test.startTest();
            ae = new EConnectWrapper_GetCustomerData.AddressElement();
        Test.stopTest();
        
        system.assertEquals(true, ae.addressTypes.isEmpty());
    }
    
    static testMethod void AddressType_1() {
        postenNoEconnectAboCrmCrmgetcustome.AddressType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Addresses.Address.get(0);
        
        EConnectWrapper_GetCustomerData.AddressType at;
        
        Test.startTest();
            at = new EConnectWrapper_GetCustomerData.AddressType(eConnectData);
        Test.stopTest();
        
        system.assertEquals('BillingAddress', at.addressType);
        system.assertEquals('BillingAddress', at.AddrType);
        //system.assertEquals(eConnectData.Street, at.Street);
        system.assertEquals(eConnectData.PostalCode, at.PostalCode);
        system.assertEquals(eConnectData.CityName, at.CityName);
       // system.assertEquals(eConnectData.MunicipalityName, at.MunicipalityName);
       // system.assertEquals(eConnectData.MunicipalityCode, at.MunicipalityCode);
        system.assertEquals(eConnectData.CountryCode, at.Country);
    }
    
    static testMethod void AddressType_2() {
        postenNoEconnectAboCrmCrmgetcustome.AddressType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Addresses.Address.get(1);
        
        EConnectWrapper_GetCustomerData.AddressType at;
        
        Test.startTest();
            at = new EConnectWrapper_GetCustomerData.AddressType(eConnectData);
        Test.stopTest();
        // Dinesh , commented line n0.233 on 23 Feb 2017
        //system.assertEquals('DeliveryAddress', at.addressType);
        system.assertEquals('DeliveryAddress', at.AddrType);
       // system.assertEquals(eConnectData.AddressLine1, at.AddressLine1);
        system.assertEquals(eConnectData.PostalCode, at.PostalCode);
        system.assertEquals(eConnectData.CityName, at.CityName);
        //system.assertEquals(eConnectData.MunicipalityName, at.MunicipalityName);
        //system.assertEquals(eConnectData.MunicipalityCode, at.MunicipalityCode);
        system.assertEquals(eConnectData.CountryCode, at.Country);
    }
    
    static testMethod void AddressType_3() {
        postenNoEconnectAboCrmCrmgetcustome.AddressType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Addresses.Address.get(2);
        
        EConnectWrapper_GetCustomerData.AddressType at;
        
        Test.startTest();
            at = new EConnectWrapper_GetCustomerData.AddressType(eConnectData);
        Test.stopTest();
        
        system.assertEquals('TEST', at.addressType);
        system.assertEquals('TEST', at.AddrType);
       // system.assertEquals(eConnectData.AddressLine1, at.AddressLine1);
        system.assertEquals(eConnectData.PostalCode, at.PostalCode);
        system.assertEquals(eConnectData.CityName, at.CityName);
        //system.assertEquals(eConnectData.MunicipalityName, at.MunicipalityName);
        //system.assertEquals(eConnectData.MunicipalityCode, at.MunicipalityCode);
        system.assertEquals(eConnectData.CountryCode, at.Country);
    }
    
    static testMethod void AddressType_4() {
        EConnectWrapper_GetCustomerData.AddressType at;
        
        Test.startTest();
            at = new EConnectWrapper_GetCustomerData.AddressType();
        Test.stopTest();
        
        system.assertEquals('-', at.addressType);
        system.assertEquals('-', at.AddrType);
       // system.assertEquals('-', at.AddressLine1);
        system.assertEquals('-', at.PostalCode);
        system.assertEquals('-', at.CityName);
        //system.assertEquals('-', at.MunicipalityName);
        //system.assertEquals('-', at.MunicipalityCode);
        system.assertEquals('-', at.Country);
    }
    
    /*static testMethod void DivisionElement_1() {
        postenNoEconnectAboCrmCrmgetcustome.Divisions_element eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Divisions;
        
        EConnectWrapper_GetCustomerData.DivisionElement de;
        
        Test.startTest();
            de = new EConnectWrapper_GetCustomerData.DivisionElement(eConnectData);
        Test.stopTest();
        
        system.assertEquals(false, de.divisionTypes.isEmpty());
    }
    
    static testMethod void DivisionElement_2() {
        EConnectWrapper_GetCustomerData.DivisionElement de;
        
        Test.startTest();
            de = new EConnectWrapper_GetCustomerData.DivisionElement();
        Test.stopTest();
        
        system.assertEquals(true, de.divisionTypes.isEmpty());
    }
    
    static testMethod void DivisionType_1() {
        postenNoEconnectAboCrmCrmgetcustome.DivisionType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Divisions.Division.get(0);
        
        EConnectWrapper_GetCustomerData.DivisionType dt;
        
        Test.startTest();
            dt = new EConnectWrapper_GetCustomerData.DivisionType(eConnectData);
        Test.stopTest();
        
        system.assertEquals(eConnectData.DivisionName, dt.DivisionName);
        system.assertEquals(eConnectData.SegmentName, dt.SegmentName);
        system.assertEquals(eConnectData.SubSegmentName, dt.SubSegmentName);
    }
    
    static testMethod void DivisionType_2() {
        EConnectWrapper_GetCustomerData.DivisionType dt;
        
        Test.startTest();
            dt = new EConnectWrapper_GetCustomerData.DivisionType();
        Test.stopTest();
        
        system.assertEquals('-', dt.DivisionName);
        system.assertEquals('-', dt.SegmentName);
        system.assertEquals('-', dt.SubSegmentName);
    }
    
    static testMethod void ContactsElement_1() {
        postenNoEconnectAboCrmCrmgetcustome.ContactsComplexType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Contacts;
        
        EConnectWrapper_GetCustomerData.ContactsElement ce;
        
        Test.startTest();
            ce = new EConnectWrapper_GetCustomerData.ContactsElement(eConnectData);
        Test.stopTest();
        
        system.assertEquals(false, ce.contactElements.isEmpty());
    }
    
    static testMethod void ContactsElement_2() {
        EConnectWrapper_GetCustomerData.ContactsElement ce;
        
        Test.startTest();
            ce = new EConnectWrapper_GetCustomerData.ContactsElement();
        Test.stopTest();
        
        system.assertEquals(true, ce.contactElements.isEmpty());
    }
    
    static testMethod void ContactElement_1() {
        postenNoEconnectAboCrmCrmgetcustome.ContactComplexType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Contacts.Contact.get(0);
        
        EConnectWrapper_GetCustomerData.ContactElement ce;
        
        Test.startTest();
            ce = new EConnectWrapper_GetCustomerData.ContactElement(eConnectData);
        Test.stopTest();
        
        system.assertEquals(eConnectData.ContactID ,ce.ContactID);
        system.assertEquals(eConnectData.Department ,ce.Department);
        system.assertEquals(eConnectData.Title ,ce.Title);
    }
    
    static testMethod void ContactElement_2() {
        EConnectWrapper_GetCustomerData.ContactElement ce;
        
        Test.startTest();
            ce = new EConnectWrapper_GetCustomerData.ContactElement();
        Test.stopTest();
        
        system.assertEquals('' ,ce.ContactID);
        system.assertEquals('-' ,ce.Department);
        system.assertEquals('-' ,ce.Title);
    }
    */
    static testMethod void InvoiceElement_1() {
        postenNoEconnectAboCrmCrmgetcustome.Invoices_element eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Invoices;
        
        EConnectWrapper_GetCustomerData.InvoiceElement ie;
        
        Test.startTest();
            ie = new EConnectWrapper_GetCustomerData.InvoiceElement(eConnectData);
        Test.stopTest();
        
        system.assertEquals(false, ie.invoiceTypes.isEmpty());
    }
    
    static testMethod void InvoiceElement_2() {
        EConnectWrapper_GetCustomerData.InvoiceElement ie;
        
        Test.startTest();
            ie = new EConnectWrapper_GetCustomerData.InvoiceElement();
        Test.stopTest();
        
        system.assertEquals(false, ie.invoiceTypes.isEmpty());
    }
    
    static testMethod void InvoiceType_1() {
        postenNoEconnectAboCrmCrmgetcustome.InvoiceType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Invoices.Invoice.get(0);
        
        EConnectWrapper_GetCustomerData.InvoiceType it;
        
        Test.startTest();
            it = new EConnectWrapper_GetCustomerData.InvoiceType(eConnectData);
        Test.stopTest();
        
        system.assertEquals(eConnectData.InvoiceNumber , it.InvoiceNumber );
        system.assertEquals(eConnectData.InvoiceType , it.InvoiceType );
        system.assertEquals(eConnectData.Sum, it.Sum);
        system.assertEquals(eConnectData.OrderedByName, it.OrderedByName);
        system.assertEquals(eConnectData.OrderedByNumber, it.OrderedByNumber);
        system.assertEquals(eConnectData.InvoiceStatus, it.Status);
        system.assertEquals(eConnectData.ItellaURI, it.ItellaURI);
        system.assertEquals(eConnectData.OEBSURI, it.OEBSURI);
        system.assertEquals(String.valueof(eConnectData.DocumentDateTime), it.DocumentDateTime);
        system.assertEquals(String.valueof(eConnectData.TrxDueDateTime ), it.TrxDueDateTime );
        system.assertEquals(String.valueof(eConnectData.InvoiceId ), it.InvoiceId );
        system.assertEquals(String.valueof(eConnectData.SourceSystem), it.sourceSys );
        system.assertEquals(String.ValueOf(eConnectData.OperatingUnit.UnitNumber), it.UnitNumber );
        system.assertEquals(String.ValueOf(eConnectData.OperatingUnit.UnitName), it.UnitName);
        system.assertEquals(String.ValueOf(eConnectData.OperatingUnit.OrganizationNumber ), it.OrganizationNumber );
        system.assertEquals(String.ValueOf(eConnectData.OperatingUnit.ExternalReference ), it.ExternalReference );
    }
    
    static testMethod void InvoiceType_2() {
        EConnectWrapper_GetCustomerData.InvoiceType it;
        
        Test.startTest();
            it = new EConnectWrapper_GetCustomerData.InvoiceType();
        Test.stopTest();
        
        system.assertEquals('-', it.InvoiceNumber);
        system.assertEquals('-', it.InvoiceType);
        system.assertEquals(0.0, it.Sum);
        system.assertEquals('-', it.OrderedByName);
        system.assertEquals('-', it.OrderedByNumber);
        system.assertEquals('-', it.Status);
        system.assertEquals('-', it.ItellaURI);
        system.assertEquals('-', it.OEBSURI);
    }
    
    static testMethod void OrderElement_1() {
        postenNoEconnectAboCrmCrmgetcustome.Orders_element eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Orders;
        
        EConnectWrapper_GetCustomerData.OrderElement oe;
        
        Test.startTest();
            oe = new EConnectWrapper_GetCustomerData.OrderElement(eConnectData);
        Test.stopTest();
        
        system.assertEquals(false, oe.orderTypes.isEmpty());
    }
    
    static testMethod void OrderElement_2() {
        EConnectWrapper_GetCustomerData.OrderElement oe;
        
        Test.startTest();
            oe = new EConnectWrapper_GetCustomerData.OrderElement();
        Test.stopTest();
        
        system.assertEquals(false, oe.orderTypes.isEmpty());
    }
    
    static testMethod void OrderType_1() {
        postenNoEconnectAboCrmCrmgetcustome.OrderType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Orders.Order.get(0);
        
        EConnectWrapper_GetCustomerData.OrderType ot;
        
        Test.startTest();
            ot = new EConnectWrapper_GetCustomerData.OrderType(eConnectData);
        Test.stopTest();
        
        system.assertEquals(eConnectData.OrderNumber, ot.OrderNumber);
        system.assertEquals(eConnectData.OrderType, ot.OrderType);
        system.assertEquals(eConnectData.Sum, ot.Sum);
        system.assertEquals(eConnectData.OrderedByName, ot.OrderedByName);
        system.assertEquals(eConnectData.OrderedByNumber, ot.OrderedByNumber);
        system.assertEquals(eConnectData.OrderStatus, ot.OrderStatus);
        system.assertEquals(eConnectData.OEBSURI, ot.OEBSURI);
    }
    
    static testMethod void OrderType_2() {
        EConnectWrapper_GetCustomerData.OrderType ot;
        
        Test.startTest();
            ot = new EConnectWrapper_GetCustomerData.OrderType();
        Test.stopTest();
        
        system.assertEquals('-', ot.OrderNumber);
        system.assertEquals('-', ot.OrderType);
        system.assertEquals(0.0, ot.Sum);
        system.assertEquals('-', ot.OrderedByName);
        system.assertEquals('-', ot.OrderedByNumber);
        system.assertEquals('-', ot.OrderStatus);
        system.assertEquals('-', ot.OEBSURI);
    }
    
    static testMethod void ForwardingElement_1() {
        postenNoEconnectAboCrmCrmgetcustome.Forwardings_element eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Forwardings;
        
        EConnectWrapper_GetCustomerData.ForwardingElement fe;
        
        Test.startTest();
            fe = new EConnectWrapper_GetCustomerData.ForwardingElement(eConnectData);
        Test.stopTest();
        
        system.assertEquals(false, fe.forwardingTypes.isEmpty());
    }
    
    static testMethod void ForwardingElement_2() {
        EConnectWrapper_GetCustomerData.ForwardingElement fe;
        
        Test.startTest();
            fe = new EConnectWrapper_GetCustomerData.ForwardingElement();
        Test.stopTest();
        
        system.assertEquals(true, fe.forwardingTypes.isEmpty());
    }
    
    static testMethod void ForwardingType_1() {
        postenNoEconnectAboCrmCrmgetcustome.ForwardingType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Forwardings.Forwarding.get(0);
        
        EConnectWrapper_GetCustomerData.ForwardingType ft;
        
        Test.startTest();
            ft = new EConnectWrapper_GetCustomerData.ForwardingType(eConnectData);
        Test.stopTest();
        
        system.assertEquals(eConnectData.ForwardingNumber, ft.Number_x);
        system.assertEquals(eConnectData.ReferenceOMA, ft.ReferenceOMA);
        system.assertEquals('Oppbevaring', ft.Type_x);
        system.assertEquals('Form', ft.Source);
        system.assertEquals(eConnectData.OEBSURI, ft.OEBSURI);
        system.assertEquals(eConnectData.StartDate, ft.StartDate);
        system.assertEquals(eConnectData.EndDate, ft.EndDate);
        system.assertEquals(eConnectData.HoldDate, ft.HoldDate);
        system.assertEquals(eConnectData.Type_x.toLowerCase(), ft.forwardingType);
    }
    
    static testMethod void ForwardingType_2() {
        postenNoEconnectAboCrmCrmgetcustome.ForwardingType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Forwardings.Forwarding.get(1);
        
        EConnectWrapper_GetCustomerData.ForwardingType ft;
        
        Test.startTest();
            ft = new EConnectWrapper_GetCustomerData.ForwardingType(eConnectData);
        Test.stopTest();
        
        system.assertEquals(eConnectData.ForwardingNumber, ft.Number_x);
        system.assertEquals(eConnectData.ReferenceOMA, ft.ReferenceOMA);
        system.assertEquals('Varig', ft.Type_x);
        system.assertEquals(eConnectData.Source, ft.Source);
        system.assertEquals(eConnectData.OEBSURI, ft.OEBSURI);
        system.assertEquals(eConnectData.StartDate, ft.StartDate);
        system.assertEquals(eConnectData.EndDate, ft.EndDate);
        system.assertEquals(eConnectData.HoldDate, ft.HoldDate);
        system.assertEquals(eConnectData.Type_x.toLowerCase(), ft.forwardingType);
    }
    
    static testMethod void ForwardingType_3() {
        postenNoEconnectAboCrmCrmgetcustome.ForwardingType eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Forwardings.Forwarding.get(2);
        
        EConnectWrapper_GetCustomerData.ForwardingType ft;
        
        Test.startTest();
            ft = new EConnectWrapper_GetCustomerData.ForwardingType(eConnectData);
        Test.stopTest();
        
        system.assertEquals(eConnectData.ForwardingNumber, ft.Number_x);
        system.assertEquals(eConnectData.ReferenceOMA, ft.ReferenceOMA);
        system.assertEquals('Midlertidig', ft.Type_x);
        system.assertEquals(eConnectData.Source, ft.Source);
        system.assertEquals(eConnectData.OEBSURI, ft.OEBSURI);
        system.assertEquals(eConnectData.StartDate, ft.StartDate);
        system.assertEquals(eConnectData.EndDate, ft.EndDate);
        system.assertEquals(eConnectData.HoldDate, ft.HoldDate);
        system.assertEquals(eConnectData.Type_x.toLowerCase(), ft.forwardingType);
    }
    
    static testMethod void ForwardingType_4() {
        EConnectWrapper_GetCustomerData.ForwardingType ft;
        
        Test.startTest();
            ft = new EConnectWrapper_GetCustomerData.ForwardingType();
        Test.stopTest();
        
        system.assertEquals('-', ft.Number_x);
        system.assertEquals('-', ft.ReferenceOMA);
        system.assertEquals('-', ft.Type_x);
        system.assertEquals('-', ft.Source);
        system.assertEquals('', ft.OEBSURI);
        system.assertEquals(null, ft.StartDate);
        system.assertEquals(null, ft.EndDate);
        system.assertEquals(null, ft.HoldDate);
        system.assertEquals('-', ft.forwardingType);
    }
    
    static testMethod void OtherPartiesElement_1() {
        postenNoEconnectAboCrmCrmgetcustome.OtherParties_element eConnectData
            = mock_Crmgetcustome.getBusinessAccount().OrganizationParty.Forwardings.Forwarding.get(0).OtherParties;
        
        
        EConnectWrapper_GetCustomerData.OtherPartiesElement ope;
        
        Test.startTest();
            ope = new EConnectWrapper_GetCustomerData.OtherPartiesElement(eConnectData);
        Test.stopTest();
        
        system.assertEquals(false, ope.Party.isEmpty());
    }
    
    static testMethod void OtherPartiesElement_2() {
        EConnectWrapper_GetCustomerData.OtherPartiesElement ope;
        
        Test.startTest();
            ope = new EConnectWrapper_GetCustomerData.OtherPartiesElement();
        Test.stopTest();
        
        system.assertEquals(false, ope.Party.isEmpty());
    }
    
    static testMethod void SalesPersonType_1() {
        postenNoEconnectAboCrmCrmgetcustome.SalesPersonType eConnectData
            = new postenNoEconnectAboCrmCrmgetcustome.SalesPersonType();
        eConnectData.SalesPersonEmail= 'test@test.com';
        eConnectData.SalesPersonPhoneNumber= '12345678';
        
        
        EConnectWrapper_GetCustomerData.SalesPersonType spt;
        
        Test.startTest();
            spt = new EConnectWrapper_GetCustomerData.SalesPersonType(eConnectData);
        Test.stopTest();
        
        system.assertEquals(eConnectData.SalesPersonPhoneNumber, spt.PhoneNumber);
        system.assertEquals(eConnectData.SalesPersonEmail, spt.Email);
    }
    
    static testMethod void SalesPersonType_2() {
        EConnectWrapper_GetCustomerData.SalesPersonType spt;
        
        Test.startTest();
            spt = new EConnectWrapper_GetCustomerData.SalesPersonType();
        Test.stopTest();
        
        system.assertEquals('-', spt.PhoneNumber);
        system.assertEquals('-', spt.Email);
    }
    
    static testMethod void PersonNameType_1() {
        postenNoEconnectAboCrmCrmgetcustome.PersonNameType eConnectData
            = new postenNoEconnectAboCrmCrmgetcustome.PersonNameType();
        
        eConnectData.FirstName = 'FirstName';
        eConnectData.MiddleName = 'MiddleName';
        eConnectData.LastName = 'LastName';
        
        EConnectWrapper_GetCustomerData.PersonNameType pnt;
        
        Test.startTest();
            pnt = new EConnectWrapper_GetCustomerData.PersonNameType(eConnectData);
        Test.stopTest();
        
        system.assertEquals(eConnectData.FirstName, pnt.FirstName);
        system.assertEquals(eConnectData.MiddleName, pnt.MiddleName);
        system.assertEquals(eConnectData.LastName, pnt.LastName);
        system.assertEquals(eConnectData.FirstName + ' ' + eConnectData.MiddleName + ' ' +eConnectData.LastName, pnt.FullName);
    }
    
    static testMethod void PersonNameType_2() {
        EConnectWrapper_GetCustomerData.PersonNameType pnt;
        
        Test.startTest();
            pnt = new EConnectWrapper_GetCustomerData.PersonNameType();
        Test.stopTest();
        
        system.assertEquals('-', pnt.FirstName);
        system.assertEquals('-', pnt.MiddleName);
        system.assertEquals('-', pnt.LastName);
        system.assertEquals('- - -', pnt.FullName);
    }
    static testMethod void Status() {
        EConnectWrapper_GetCustomerData.PersonStatus('01','Valid');
        EConnectWrapper_GetCustomerData.PersonStatus('01','Dead');
        EConnectWrapper_GetCustomerData.PersonStatus('01','Bankrupt');
        EConnectWrapper_GetCustomerData.PersonStatus('01','Duplicate');
        EConnectWrapper_GetCustomerData.PersonStatus('01','Disappeared');
        EConnectWrapper_GetCustomerData.PersonStatus('01','Merged');
        EConnectWrapper_GetCustomerData.PersonStatus('01','Liquidated');
        EConnectWrapper_GetCustomerData.PersonStatus('01','Ceased to exist');
        EConnectWrapper_GetCustomerData.PersonStatus('01','Active');
        EConnectWrapper_GetCustomerData.PersonStatus('01','Inactive');
    }
    
     static testMethod void ForwardingStatus() {
         EConnectWrapper_GetCustomerData.ForwardingStatus('expired');
         EConnectWrapper_GetCustomerData.ForwardingStatus('cancelled');
         EConnectWrapper_GetCustomerData.ForwardingStatus('future');
         EConnectWrapper_GetCustomerData.ForwardingStatus('effective');
         EConnectWrapper_GetCustomerData.ForwardingStatus('error');
     }
     static testMethod void ForwardingSource() {
         EConnectWrapper_GetCustomerData.ForwardingSource('phone');
         EConnectWrapper_GetCustomerData.ForwardingSource('free');
         EConnectWrapper_GetCustomerData.ForwardingSource('form');
        
     }
}