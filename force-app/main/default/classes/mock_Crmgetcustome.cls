public with sharing class mock_Crmgetcustome {
    
    private static final postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType  businessAccount;
    private static final postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType  privateAccount;
    private static final postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType  emptyAccount;
    public static final postenNoEconnectAboCrmCrmgetcustome.OperatingUnit_element OperatingUnitValue=new postenNoEconnectAboCrmCrmgetcustome.OperatingUnit_element();
    static {
        emptyAccount = new postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType ();
        //emptyAccount.ListType = '';
        emptyAccount.OrganizationParty = null;
        emptyAccount.PersonParty = null;
        
        businessAccount = new postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType ();
        
        //businessAccount.ListType = '';
        businessAccount.PersonParty = null;
        businessAccount.OrganizationParty = new postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType();
        
        businessAccount.OrganizationParty.PartyNumber = 'QQQQQ1234567AAAAAA';
        businessAccount.OrganizationParty.DUNSNo = '987654321';
        businessAccount.OrganizationParty.Status = 'Gyldig';
        businessAccount.OrganizationParty.CustomerNumber = 'QASA7654321G';
        
        businessAccount.OrganizationParty.Communications = new postenNoEconnectAboCrmCrmgetcustome.Communications_element();
        businessAccount.OrganizationParty.Communications.Communication = new list<postenNoEconnectAboCrmCrmgetcustome.CommunicationType>();
            businessAccount.OrganizationParty.Communications.Communication.add(new postenNoEconnectAboCrmCrmgetcustome.CommunicationType());
                businessAccount.OrganizationParty.Communications.Communication.get(0).PhoneNumber = '12345678';
                businessAccount.OrganizationParty.Communications.Communication.get(0).MobileNumber = '87654321';
                businessAccount.OrganizationParty.Communications.Communication.get(0).EMailAddress = 'test@test.com';
            businessAccount.OrganizationParty.Communications.Communication.add(new postenNoEconnectAboCrmCrmgetcustome.CommunicationType());
                businessAccount.OrganizationParty.Communications.Communication.get(1).PhoneNumber = '12345678';
                businessAccount.OrganizationParty.Communications.Communication.get(1).MobileNumber = null;
                businessAccount.OrganizationParty.Communications.Communication.get(1).EMailAddress = null;
        
        businessAccount.OrganizationParty.Addresses = new postenNoEconnectAboCrmCrmgetcustome.Addresses_element();
        businessAccount.OrganizationParty.Addresses.Address = new list<postenNoEconnectAboCrmCrmgetcustome.AddressType>();
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectAboCrmCrmgetcustome.AddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(0).AddrTYPE = 'BillingAddress'; // Fakturaadresse
                businessAccount.OrganizationParty.Addresses.Address.get(0).StreetName = 'AddressLine1 0 A';
                businessAccount.OrganizationParty.Addresses.Address.get(0).PostalCode = 'PostalCode0';
                businessAccount.OrganizationParty.Addresses.Address.get(0).CityName = 'CityName0';
               // businessAccount.OrganizationParty.Addresses.Address.get(0).MunicipalityName = 'MunicipalityName0';
               // businessAccount.OrganizationParty.Addresses.Address.get(0).MunicipalityCode = 'MunicipalityCode0';
                businessAccount.OrganizationParty.Addresses.Address.get(0).CountryCode = 'Country0';
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectAboCrmCrmgetcustome.AddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(1).AddrTYPE = 'DeliveryAddress'; //Shippingadresse
                businessAccount.OrganizationParty.Addresses.Address.get(1).StreetName = 'AddressLine11';
                businessAccount.OrganizationParty.Addresses.Address.get(1).PostalCode = 'PostCode1';
                businessAccount.OrganizationParty.Addresses.Address.get(1).CityName = 'CityName1';
                //businessAccount.OrganizationParty.Addresses.Address.get(1).MunicipalityName = 'MunicipalityName1';
                //businessAccount.OrganizationParty.Addresses.Address.get(1).MunicipalityCode = 'MunicipalityCode1';
                businessAccount.OrganizationParty.Addresses.Address.get(1).CountryCode = 'Country1';
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectAboCrmCrmgetcustome.AddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(2).AddrTYPE = 'TEST';
                businessAccount.OrganizationParty.Addresses.Address.get(2).StreetName = 'AddressLine12';
                businessAccount.OrganizationParty.Addresses.Address.get(2).PostalCode = 'PostCode2';
                businessAccount.OrganizationParty.Addresses.Address.get(2).CityName = 'CityName2';
                //businessAccount.OrganizationParty.Addresses.Address.get(2).MunicipalityName = 'MunicipalityName2';
                ///businessAccount.OrganizationParty.Addresses.Address.get(2).MunicipalityCode = 'MunicipalityCode2';
                businessAccount.OrganizationParty.Addresses.Address.get(2).CountryCode = 'Country2';
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectAboCrmCrmgetcustome.AddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(3).AddrTYPE = 'PostalAddress';// Besøksadresse
                businessAccount.OrganizationParty.Addresses.Address.get(3).StreetName = 'AddressLine13';
                businessAccount.OrganizationParty.Addresses.Address.get(3).PostalCode = 'PostalCode3';
                businessAccount.OrganizationParty.Addresses.Address.get(3).CityName = 'CityName-Besøksadresse';
                //businessAccount.OrganizationParty.Addresses.Address.get(3).MunicipalityName = 'MunicipalityName3';
                //businessAccount.OrganizationParty.Addresses.Address.get(3).MunicipalityCode = 'MunicipalityCode3';
                businessAccount.OrganizationParty.Addresses.Address.get(3).CountryCode = 'Country3';
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectAboCrmCrmgetcustome.AddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(4).AddrTYPE = 'PostalAddress';// Postadresse
                businessAccount.OrganizationParty.Addresses.Address.get(4).StreetName = 'AddressLine14';
                businessAccount.OrganizationParty.Addresses.Address.get(4).PostalCode = 'PostalCode4';
                businessAccount.OrganizationParty.Addresses.Address.get(4).CityName = 'CityName-Postadresse';
                //businessAccount.OrganizationParty.Addresses.Address.get(4).MunicipalityName = 'MunicipalityName4';
                //businessAccount.OrganizationParty.Addresses.Address.get(4).MunicipalityCode = 'MunicipalityCode4';
                businessAccount.OrganizationParty.Addresses.Address.get(4).CountryCode = 'Country4';
            
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectAboCrmCrmgetcustome.AddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(5).AddrTYPE = 'Caesar';// Adresse i caesar
                businessAccount.OrganizationParty.Addresses.Address.get(5).StreetName = 'AddressLine15';
                businessAccount.OrganizationParty.Addresses.Address.get(5).PostalCode = 'PostalCode5';
                businessAccount.OrganizationParty.Addresses.Address.get(5).CityName = 'CityName-Caesar';
                //businessAccount.OrganizationParty.Addresses.Address.get(5).MunicipalityName = 'MunicipalityName5';
                //businessAccount.OrganizationParty.Addresses.Address.get(5).MunicipalityCode = 'MunicipalityCode5';
                businessAccount.OrganizationParty.Addresses.Address.get(5).CountryCode = 'Country5';
        
        businessAccount.OrganizationParty.Forwardings = new postenNoEconnectAboCrmCrmgetcustome.Forwardings_element();
        businessAccount.OrganizationParty.Forwardings.Forwarding = new list<postenNoEconnectAboCrmCrmgetcustome.ForwardingType>();
            businessAccount.OrganizationParty.Forwardings.Forwarding.add(new postenNoEconnectAboCrmCrmgetcustome.ForwardingType());
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ForwardingNumber = 'B000001';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ReferenceOMA = 'ReferenceOMA';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).Type_x = 'hold';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).Source = 'form';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OEBSURI = 'OEBSURI';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.AddrTYPE = 'AddrTYPE';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.StreetName = 'AddressLine1';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.CityName = 'CityName';
                   // businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.MunicipalityName = 'MunicipalityName';
                    //businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.CountryCode = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.AddrTYPE = 'AddrTYPE';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.StreetName = 'AddressLine1';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.CityName = 'CityName';
                    //businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.MunicipalityName = 'MunicipalityName';
                    //businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.CountryCode = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).StartDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).EndDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).HoldDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties = new postenNoEconnectAboCrmCrmgetcustome.OtherParties_element();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties.Party = new list<postenNoEconnectAboCrmCrmgetcustome.PersonNameType>();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties.Party.add(new postenNoEconnectAboCrmCrmgetcustome.PersonNameType());
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).LastName = 'LastName';
            businessAccount.OrganizationParty.Forwardings.Forwarding.add(new postenNoEconnectAboCrmCrmgetcustome.ForwardingType());
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ForwardingNumber = 'B000002';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ReferenceOMA = 'ReferenceOMA';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).Type_x = 'permanent';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).Source = 'Source';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OEBSURI = 'OEBSURI';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.AddrTYPE = 'AddrTYPE';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.StreetName = 'AddressLine1';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.CityName = 'CityName';
                    //businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.MunicipalityName = 'MunicipalityName';
                    //businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.CountryCode = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.AddrTYPE = 'AddrTYPE';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.StreetName = 'AddressLine1';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.CityName = 'CityName';
                    //businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.MunicipalityName = 'MunicipalityName';
                    //businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.CountryCode = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).StartDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).EndDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).HoldDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties = new postenNoEconnectAboCrmCrmgetcustome.OtherParties_element();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties.Party = new list<postenNoEconnectAboCrmCrmgetcustome.PersonNameType>();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties.Party.add(new postenNoEconnectAboCrmCrmgetcustome.PersonNameType());
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).LastName = 'LastName';
            businessAccount.OrganizationParty.Forwardings.Forwarding.add(new postenNoEconnectAboCrmCrmgetcustome.ForwardingType());
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ForwardingNumber = 'B000003';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ReferenceOMA = 'ReferenceOMA';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).Type_x = 'temporary';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).Source = 'Source';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OEBSURI = 'OEBSURI';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.AddrTYPE = 'AddrTYPE';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.StreetName = 'AddressLine1';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.CityName = 'CityName';
                    //businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.MunicipalityName = 'MunicipalityName';
                    //businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.CountryCode = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.AddrTYPE = 'AddrTYPE';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.StreetName = 'AddressLine1';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.CityName = 'CityName';
                    //businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.MunicipalityName = 'MunicipalityName';
                    //businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.CountryCode = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).StartDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).EndDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).HoldDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties = new postenNoEconnectAboCrmCrmgetcustome.OtherParties_element();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties.Party = new list<postenNoEconnectAboCrmCrmgetcustome.PersonNameType>();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties.Party.add(new postenNoEconnectAboCrmCrmgetcustome.PersonNameType());
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).LastName = 'LastName';
        
        businessAccount.OrganizationParty.Orders = new postenNoEconnectAboCrmCrmgetcustome.Orders_element();
        businessAccount.OrganizationParty.Orders.Order = new list<postenNoEconnectAboCrmCrmgetcustome.OrderType>();
            businessAccount.OrganizationParty.Orders.Order.add(new postenNoEconnectAboCrmCrmgetcustome.OrderType());
                businessAccount.OrganizationParty.Orders.Order.get(0).OrderNumber = 'Number_x';
                businessAccount.OrganizationParty.Orders.Order.get(0).OrderType = 'OrderType';
                businessAccount.OrganizationParty.Orders.Order.get(0).Sum = 10.10;
                businessAccount.OrganizationParty.Orders.Order.get(0).OrderedByName = 'OrderedByName';
                businessAccount.OrganizationParty.Orders.Order.get(0).OrderedByNumber = 'OrderedByNumber';
                businessAccount.OrganizationParty.Orders.Order.get(0).OrderStatus = 'Status';
                businessAccount.OrganizationParty.Orders.Order.get(0).OEBSURI = 'OEBSURI';
        
        businessAccount.OrganizationParty.Invoices = new postenNoEconnectAboCrmCrmgetcustome.Invoices_element();
        businessAccount.OrganizationParty.Invoices.Invoice = new list<postenNoEconnectAboCrmCrmgetcustome.InvoiceType>();
            businessAccount.OrganizationParty.Invoices.Invoice.add(new postenNoEconnectAboCrmCrmgetcustome.InvoiceType());
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).InvoiceNumber = 'Number_x';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).InvoiceType = 'AddrTYPE';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).Sum = 10.10;
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).OrderedByName = 'OrderedByName';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).OrderedByNumber = 'OrderedByNumber';
               // businessAccount.OrganizationParty.Invoices.Invoice.get(0).Status = 'Status';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).ItellaURI = 'ItellaURI';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).OEBSURI = 'OEBSURI';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).DocumentDateTime=System.today();
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).TrxDueDateTime=System.today();
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).InvoiceId='InvoiceId';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).SourceSystem='sourceSys';
              
                OperatingUnitValue.UnitNumber='number';
                OperatingUnitValue.UnitName='UnitName';
                OperatingUnitValue.OrganizationNumber='OrganizationNumber';
                OperatingUnitValue.ExternalReference='ExternalReference';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).OperatingUnit=OperatingUnitValue;
                businessAccount.OrganizationParty.FiscalCode = '123456789';
                businessAccount.OrganizationParty.MarketName = 'MarketName';
                businessAccount.OrganizationParty.LegalName = 'LegalName';
        
      /*  businessAccount.OrganizationParty.Divisions = new postenNoEconnectAboCrmCrmgetcustome.Divisions_element();
        businessAccount.OrganizationParty.Divisions.Division = new list<postenNoEconnectAboCrmCrmgetcustome.KATS_SakDivisionType>();
            businessAccount.OrganizationParty.Divisions.Division.add(new postenNoEconnectAboCrmCrmgetcustome.KATS_SakDivisionType());
                businessAccount.OrganizationParty.Divisions.Division.get(0).DivisionName = 'POST';
                businessAccount.OrganizationParty.Divisions.Division.get(0).SegmentName = 'SegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(0).SubSegmentName = 'SubSegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.Name = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakPersonNameType();
                        businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.Name.FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.Name.MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.Name.LastName = 'LastName';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.PhoneNumber = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.Email = 'test@test.com';
                businessAccount.OrganizationParty.Divisions.Division.get(0).OtherSalesPerson = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(0).OtherSalesPerson.Name = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakPersonNameType();
                        businessAccount.OrganizationParty.Divisions.Division.get(0).OtherSalesPerson.Name.FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Divisions.Division.get(0).OtherSalesPerson.Name.MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Divisions.Division.get(0).OtherSalesPerson.Name.LastName = 'LastName';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).OtherSalesPerson.PhoneNumber = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).OtherSalesPerson.Email = 'test@test.com';
                businessAccount.OrganizationParty.Divisions.Division.get(0).CRMInactive = 0;
                businessAccount.OrganizationParty.Divisions.Division.get(0).CRMStatus = 0;
                businessAccount.OrganizationParty.Divisions.Division.get(0).CustomerStatus = 0;
                businessAccount.OrganizationParty.Divisions.Division.get(0).Number_x = 'Number_x';
                businessAccount.OrganizationParty.Divisions.Division.get(0).SOW = 0;
                businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport = new postenNoEconnectAboCrmCrmgetcustome.SalesSupportType();
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportID = 0;
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportFirstName = 'SalesSupportFirstName';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportSurname = 'SalesSupportSurname';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportPhone = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportEmail = 'test@test.com';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportMobilePhone = '87654321';
            businessAccount.OrganizationParty.Divisions.Division.add(new postenNoEconnectAboCrmCrmgetcustome.KATS_SakDivisionType());
                businessAccount.OrganizationParty.Divisions.Division.get(1).DivisionName = 'LOGISTICS';
                businessAccount.OrganizationParty.Divisions.Division.get(1).SegmentName = 'SegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(1).SubSegmentName = 'SubSegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.Name = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakPersonNameType();
                        businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.Name.FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.Name.MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.Name.LastName = 'LastName';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.PhoneNumber = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.Email = 'test@test.com';
                businessAccount.OrganizationParty.Divisions.Division.get(1).OtherSalesPerson = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(1).OtherSalesPerson.Name = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakPersonNameType();
                        businessAccount.OrganizationParty.Divisions.Division.get(1).OtherSalesPerson.Name.FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Divisions.Division.get(1).OtherSalesPerson.Name.MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Divisions.Division.get(1).OtherSalesPerson.Name.LastName = 'LastName';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).OtherSalesPerson.PhoneNumber = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).OtherSalesPerson.Email = 'test@test.com';
                businessAccount.OrganizationParty.Divisions.Division.get(1).CRMInactive = 1;
                businessAccount.OrganizationParty.Divisions.Division.get(1).CRMStatus = 1;
                businessAccount.OrganizationParty.Divisions.Division.get(1).CustomerStatus = 1;
                businessAccount.OrganizationParty.Divisions.Division.get(1).Number_x = 'Number_x';
                businessAccount.OrganizationParty.Divisions.Division.get(1).SOW = 0;
                businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport = new postenNoEconnectAboCrmCrmgetcustome.SalesSupportType();
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportID = 0;
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportFirstName = 'SalesSupportFirstName';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportSurname = 'SalesSupportSurname';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportPhone = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportEmail = 'test@test.com';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportMobilePhone = '87654321';
            businessAccount.OrganizationParty.Divisions.Division.add(new postenNoEconnectAboCrmCrmgetcustome.KATS_SakDivisionType());
                businessAccount.OrganizationParty.Divisions.Division.get(2).DivisionName = 'LOGISTIKK';
                businessAccount.OrganizationParty.Divisions.Division.get(2).SegmentName = 'SegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(2).SubSegmentName = 'SubSegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.Name = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakPersonNameType();
                        businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.Name.FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.Name.MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.Name.LastName = 'LastName';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.PhoneNumber = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.Email = 'test@test.com';
                businessAccount.OrganizationParty.Divisions.Division.get(2).OtherSalesPerson = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(2).OtherSalesPerson.Name = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakPersonNameType();
                        businessAccount.OrganizationParty.Divisions.Division.get(2).OtherSalesPerson.Name.FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Divisions.Division.get(2).OtherSalesPerson.Name.MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Divisions.Division.get(2).OtherSalesPerson.Name.LastName = 'LastName';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).OtherSalesPerson.PhoneNumber = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).OtherSalesPerson.Email = 'test@test.com';
                businessAccount.OrganizationParty.Divisions.Division.get(2).CRMInactive = 1;
                businessAccount.OrganizationParty.Divisions.Division.get(2).CRMStatus = 1;
                businessAccount.OrganizationParty.Divisions.Division.get(2).CustomerStatus = 1;
                businessAccount.OrganizationParty.Divisions.Division.get(2).Number_x = 'Number_x';
                businessAccount.OrganizationParty.Divisions.Division.get(2).SOW = 0;
                businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport = new postenNoEconnectAboCrmCrmgetcustome.SalesSupportType();
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportID = 0;
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportFirstName = 'SalesSupportFirstName';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportSurname = 'SalesSupportSurname';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportPhone = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportEmail = 'test@test.com';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportMobilePhone = '87654321';
        
        businessAccount.OrganizationParty.Contacts =  new postenNoEconnectAboCrmCrmgetcustome.ContactsComplexType();
        businessAccount.OrganizationParty.Contacts.Contact = new list<postenNoEconnectAboCrmCrmgetcustome.ContactComplexType>();
            businessAccount.OrganizationParty.Contacts.Contact.add(new postenNoEconnectAboCrmCrmgetcustome.ContactComplexType());
                businessAccount.OrganizationParty.Contacts.Contact.get(0).ContactID = 'ContactID';
                businessAccount.OrganizationParty.Contacts.Contact.get(0).ContactName = new postenNoEconnectAboCrmCrmgetcustome.KATS_SakPersonNameType();
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).ContactName.FirstName = 'FirstName';
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).ContactName.MiddleName = 'MiddleName';
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).ContactName.LastName = 'LastName';
                businessAccount.OrganizationParty.Contacts.Contact.get(0).Department = 'Department';
                businessAccount.OrganizationParty.Contacts.Contact.get(0).Title = 'Title';
                businessAccount.OrganizationParty.Contacts.Contact.get(0).Communication = new postenNoEconnectAboCrmCrmgetcustome.CommunicationType();
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).Communication.PhoneNumber = '12345678';
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).Communication.MobileNumber = '87654321';
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).Communication.EMailAddress = 'test@test.com';
            */    
      /*  businessAccount.OrganizationParty.Revenues =  new postenNoEconnectAboCrmCrmgetcustome.RevenueType();
        businessAccount.OrganizationParty.Revenues.TotalRevenueCurrentYear_L = 500.0;
        businessAccount.OrganizationParty.Revenues.TotalRevenueCurrentYear_P = 600.0;
        businessAccount.OrganizationParty.Revenues.TotalRevenuePreviousYear_L = 700.0;
        businessAccount.OrganizationParty.Revenues.TotalRevenuePreviousYear_P = 800.0;*/
        
        
        privateAccount = new postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType ();
        
        //privateAccount.ListType = '';
        privateAccount.PersonParty = new postenNoEconnectAboCrmCrmgetcustome.CustomerPersonType();
          privateAccount.PersonParty.PartyNumber = 'QQQQQ7654321SQS';
        privateAccount.PersonParty.Status = 'Gyldig';
        privateAccount.PersonParty.CustomerNumber = 'QAQA1234567p';
        privateAccount.PersonParty.Communications = new postenNoEconnectAboCrmCrmgetcustome.Communications_element();
        privateAccount.PersonParty.Addresses = new postenNoEconnectAboCrmCrmgetcustome.Addresses_element();
        privateAccount.PersonParty.Addresses.Address = new list<postenNoEconnectAboCrmCrmgetcustome.AddressType>();
            privateAccount.PersonParty.Addresses.Address.add(new postenNoEconnectAboCrmCrmgetcustome.AddressType());
                privateAccount.PersonParty.Addresses.Address.get(0).AddrTYPE =  'PostalAddress';
                privateAccount.PersonParty.Addresses.Address.get(0).StreetName = 'AddressLine10';
                privateAccount.PersonParty.Addresses.Address.get(0).PostalCode = 'PostalCode0';
                privateAccount.PersonParty.Addresses.Address.get(0).CityName = 'CityName0';
               // privateAccount.PersonParty.Addresses.Address.get(0).MunicipalityName = 'MunicipalityName0';
               // privateAccount.PersonParty.Addresses.Address.get(0).MunicipalityCode = 'MunicipalityCode0';
                privateAccount.PersonParty.Addresses.Address.get(0).CountryCode = 'Country0';
            privateAccount.PersonParty.Addresses.Address.add(new postenNoEconnectAboCrmCrmgetcustome.AddressType());
                privateAccount.PersonParty.Addresses.Address.get(1).AddrTYPE =  'TEST';
                privateAccount.PersonParty.Addresses.Address.get(1).StreetName = 'AddressLine11';
                privateAccount.PersonParty.Addresses.Address.get(1).PostalCode = 'PostalCode1';
                privateAccount.PersonParty.Addresses.Address.get(1).CityName = 'CityName1';
               // privateAccount.PersonParty.Addresses.Address.get(1).MunicipalityName = 'MunicipalityName1';
               // privateAccount.PersonParty.Addresses.Address.get(1).MunicipalityCode = 'MunicipalityCode1';
                privateAccount.PersonParty.Addresses.Address.get(1).CountryCode = 'Country1';
        
        privateAccount.PersonParty.Forwardings = new postenNoEconnectAboCrmCrmgetcustome.Forwardings_element();
        privateAccount.PersonParty.Forwardings.Forwarding = new list<postenNoEconnectAboCrmCrmgetcustome.ForwardingType>();
            privateAccount.PersonParty.Forwardings.Forwarding.add(new postenNoEconnectAboCrmCrmgetcustome.ForwardingType());
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).ForwardingNumber = 'P000001';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).ReferenceOMA = 'ReferenceOMA';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).Type_x = 'hold';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).Source = 'form';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).OEBSURI = 'OEBSURI';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.AddrTYPE = 'AddrTYPE';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.StreetName = 'AddressLine1';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.CityName = 'CityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.MunicipalityName = 'MunicipalityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.CountryCode = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.AddrTYPE = 'AddrTYPE';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.StreetName = 'AddressLine1';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.CityName = 'CityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.MunicipalityName = 'MunicipalityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.CountryCode = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).StartDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).EndDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).HoldDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties = new postenNoEconnectAboCrmCrmgetcustome.OtherParties_element();
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties.Party = new list<postenNoEconnectAboCrmCrmgetcustome.PersonNameType>();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties.Party.add(new postenNoEconnectAboCrmCrmgetcustome.PersonNameType());
                        privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).FirstName = 'FirstName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).LastName = 'LastName';
            privateAccount.PersonParty.Forwardings.Forwarding.add(new postenNoEconnectAboCrmCrmgetcustome.ForwardingType());
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).ForwardingNumber = 'P000002';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).ReferenceOMA = 'ReferenceOMA';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).Type_x = 'permanent';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).Source = 'Source';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).OEBSURI = 'OEBSURI';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.AddrTYPE = 'AddrTYPE';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.StreetName = 'AddressLine1';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.CityName = 'CityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.MunicipalityName = 'MunicipalityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.CountryCode = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.AddrTYPE = 'AddrTYPE';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.StreetName = 'AddressLine1';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.CityName = 'CityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.MunicipalityName = 'MunicipalityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.CountryCode = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).StartDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).EndDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).HoldDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties = new postenNoEconnectAboCrmCrmgetcustome.OtherParties_element();
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties.Party = new list<postenNoEconnectAboCrmCrmgetcustome.PersonNameType>();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties.Party.add(new postenNoEconnectAboCrmCrmgetcustome.PersonNameType());
                        privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).FirstName = 'FirstName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).LastName = 'LastName';
            privateAccount.PersonParty.Forwardings.Forwarding.add(new postenNoEconnectAboCrmCrmgetcustome.ForwardingType());
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).ForwardingNumber = 'P000003';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).ReferenceOMA = 'ReferenceOMA';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).Type_x = 'temporary';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).Source = 'Source';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).OEBSURI = 'OEBSURI';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.AddrTYPE = 'AddrTYPE';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.StreetName = 'AddressLine1';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.CityName = 'CityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.MunicipalityName = 'MunicipalityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.CountryCode = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress = new postenNoEconnectAboCrmCrmgetcustome.AddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.AddrTYPE = 'AddrTYPE';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.StreetName = 'AddressLine1';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.CityName = 'CityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.MunicipalityName = 'MunicipalityName';
                    //privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.CountryCode = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).StartDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).EndDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).HoldDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties = new postenNoEconnectAboCrmCrmgetcustome.OtherParties_element();
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties.Party = new list<postenNoEconnectAboCrmCrmgetcustome.PersonNameType>();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties.Party.add(new postenNoEconnectAboCrmCrmgetcustome.PersonNameType());
                        privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).FirstName = 'FirstName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).LastName = 'LastName';
        
        privateAccount.PersonParty.Orders = new postenNoEconnectAboCrmCrmgetcustome.Orders_element();
        privateAccount.PersonParty.Invoices = new postenNoEconnectAboCrmCrmgetcustome.Invoices_element();
        privateAccount.PersonParty.Invoices.Invoice = new list<postenNoEconnectAboCrmCrmgetcustome.InvoiceType>();
            privateAccount.PersonParty.Invoices.Invoice.add(new postenNoEconnectAboCrmCrmgetcustome.InvoiceType());
                privateAccount.PersonParty.Invoices.Invoice.get(0).InvoiceNumber = 'Number_x';
                privateAccount.PersonParty.Invoices.Invoice.get(0).InvoiceType = 'AddrTYPE';
                privateAccount.PersonParty.Invoices.Invoice.get(0).Sum = 10.10;
                privateAccount.PersonParty.Invoices.Invoice.get(0).OrderedByName = 'OrderedByName';
                privateAccount.PersonParty.Invoices.Invoice.get(0).OrderedByNumber = 'OrderedByNumber';
                //privateAccount.PersonParty.Invoices.Invoice.get(0).Status = 'Status';
                privateAccount.PersonParty.Invoices.Invoice.get(0).ItellaURI = 'ItellaURI';
                privateAccount.PersonParty.Invoices.Invoice.get(0).OEBSURI = 'OEBSURI';
                
                OperatingUnitValue.UnitNumber='number';
                OperatingUnitValue.UnitName='UnitName';
                OperatingUnitValue.OrganizationNumber='OrganizationNumber';
                OperatingUnitValue.ExternalReference='ExternalReference';
                privateAccount.PersonParty.Invoices.Invoice.get(0).OperatingUnit=OperatingUnitValue;
        privateAccount.PersonParty.Names = new postenNoEconnectAboCrmCrmgetcustome.PersonNameType();
            privateAccount.PersonParty.Names.FirstName = 'FirstName';
            privateAccount.PersonParty.Names.LastName = 'LastName';
            privateAccount.PersonParty.Names.MiddleName = 'MiddleName';
        
        privateAccount.OrganizationParty = null;
        
    }
    
    public class mock_businessAccount implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
            
                response.put('response_x', mock_KatsSakgetcustomer.getBusinessAccount());
        }
    }
    
    public class mock_privateAccount implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
            
                response.put('response_x', mock_KatsSakgetcustomer.getPrivateAccount());
        }
    }
    
    public class mock_emptyAccount implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
            
                response.put('response_x', mock_KatsSakgetcustomer.getEmptyAccount());
        }
    }
    
    public static postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType  getEmptyAccount() {
        return emptyAccount;
    }
    
    public static postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType  getBusinessAccount() {
        return businessAccount;
    }
    
    public static postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType  getPrivateAccount() {
        return privateAccount;
    }
    
    
}