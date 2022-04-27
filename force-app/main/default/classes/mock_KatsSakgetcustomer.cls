public with sharing class mock_KatsSakgetcustomer {
    
    private static final postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters businessAccount;
    private static final postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters privateAccount;
    private static final postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters emptyAccount;
    
    static {
        emptyAccount = new postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters();
        emptyAccount.ListType = '';
        emptyAccount.OrganizationParty = null;
        emptyAccount.PersonParty = null;
        
        businessAccount = new postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters();
        
        businessAccount.ListType = '';
        businessAccount.PersonParty = null;
        businessAccount.OrganizationParty = new postenNoEconnectKatsSakgetcustomer.KATS_SakCustomerOrganizationType();
        
        businessAccount.OrganizationParty.PartyNumber = 'QQQQQ1234567AAAAAA';
        businessAccount.OrganizationParty.DUNSNo = '987654321';
        businessAccount.OrganizationParty.Status = 'Gyldig';
       // businessAccount.OrganizationParty.CustomerNumber = 'QASA7654321G';
       businessAccount.OrganizationParty.CustomerNumber = 'QASA76543123';
        
        businessAccount.OrganizationParty.Communications = new postenNoEconnectKatsSakgetcustomer.Communications_element();
        businessAccount.OrganizationParty.Communications.Communication = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakCommunicationType>();
            businessAccount.OrganizationParty.Communications.Communication.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakCommunicationType());
                businessAccount.OrganizationParty.Communications.Communication.get(0).PhoneNumber = '12345678';
                businessAccount.OrganizationParty.Communications.Communication.get(0).MobileNumber = '87654321';
                businessAccount.OrganizationParty.Communications.Communication.get(0).EMailAddress = 'test@test.com';
            businessAccount.OrganizationParty.Communications.Communication.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakCommunicationType());
                businessAccount.OrganizationParty.Communications.Communication.get(1).PhoneNumber = '12345678';
                businessAccount.OrganizationParty.Communications.Communication.get(1).MobileNumber = null;
                businessAccount.OrganizationParty.Communications.Communication.get(1).EMailAddress = null;
        
        businessAccount.OrganizationParty.Addresses = new postenNoEconnectKatsSakgetcustomer.Addresses_element();
        businessAccount.OrganizationParty.Addresses.Address = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType>();
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(0).Type_x = 'BILL_TO'; // Fakturaadresse
                businessAccount.OrganizationParty.Addresses.Address.get(0).Street = 'Street 0 A';
                businessAccount.OrganizationParty.Addresses.Address.get(0).PostalCode = 'PostalCode0';
                businessAccount.OrganizationParty.Addresses.Address.get(0).City = 'City0';
                businessAccount.OrganizationParty.Addresses.Address.get(0).MunicipalityName = 'MunicipalityName0';
                businessAccount.OrganizationParty.Addresses.Address.get(0).MunicipalityCode = 'MunicipalityCode0';
                businessAccount.OrganizationParty.Addresses.Address.get(0).Country = 'Country0';
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(1).Type_x = 'SHIP_TO'; //Shippingadresse
                businessAccount.OrganizationParty.Addresses.Address.get(1).Street = 'Street1';
                businessAccount.OrganizationParty.Addresses.Address.get(1).PostalCode = 'PostCode1';
                businessAccount.OrganizationParty.Addresses.Address.get(1).City = 'City1';
                businessAccount.OrganizationParty.Addresses.Address.get(1).MunicipalityName = 'MunicipalityName1';
                businessAccount.OrganizationParty.Addresses.Address.get(1).MunicipalityCode = 'MunicipalityCode1';
                businessAccount.OrganizationParty.Addresses.Address.get(1).Country = 'Country1';
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(2).Type_x = 'TEST';
                businessAccount.OrganizationParty.Addresses.Address.get(2).Street = 'Street2';
                businessAccount.OrganizationParty.Addresses.Address.get(2).PostalCode = 'PostCode2';
                businessAccount.OrganizationParty.Addresses.Address.get(2).City = 'City2';
                businessAccount.OrganizationParty.Addresses.Address.get(2).MunicipalityName = 'MunicipalityName2';
                businessAccount.OrganizationParty.Addresses.Address.get(2).MunicipalityCode = 'MunicipalityCode2';
                businessAccount.OrganizationParty.Addresses.Address.get(2).Country = 'Country2';
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(3).Type_x = 'XXAD_VISIT';// Besøksadresse
                businessAccount.OrganizationParty.Addresses.Address.get(3).Street = 'Street3';
                businessAccount.OrganizationParty.Addresses.Address.get(3).PostalCode = 'PostalCode3';
                businessAccount.OrganizationParty.Addresses.Address.get(3).City = 'City-Besøksadresse';
                businessAccount.OrganizationParty.Addresses.Address.get(3).MunicipalityName = 'MunicipalityName3';
                businessAccount.OrganizationParty.Addresses.Address.get(3).MunicipalityCode = 'MunicipalityCode3';
                businessAccount.OrganizationParty.Addresses.Address.get(3).Country = 'Country3';
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(4).Type_x = 'XXAD_POST';// Postadresse
                businessAccount.OrganizationParty.Addresses.Address.get(4).Street = 'Street4';
                businessAccount.OrganizationParty.Addresses.Address.get(4).PostalCode = 'PostalCode4';
                businessAccount.OrganizationParty.Addresses.Address.get(4).City = 'City-Postadresse';
                businessAccount.OrganizationParty.Addresses.Address.get(4).MunicipalityName = 'MunicipalityName4';
                businessAccount.OrganizationParty.Addresses.Address.get(4).MunicipalityCode = 'MunicipalityCode4';
                businessAccount.OrganizationParty.Addresses.Address.get(4).Country = 'Country4';
            
            businessAccount.OrganizationParty.Addresses.Address.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType());
                businessAccount.OrganizationParty.Addresses.Address.get(5).Type_x = 'Caesar';// Adresse i caesar
                businessAccount.OrganizationParty.Addresses.Address.get(5).Street = 'Street5';
                businessAccount.OrganizationParty.Addresses.Address.get(5).PostalCode = 'PostalCode5';
                businessAccount.OrganizationParty.Addresses.Address.get(5).City = 'City-Caesar';
                businessAccount.OrganizationParty.Addresses.Address.get(5).MunicipalityName = 'MunicipalityName5';
                businessAccount.OrganizationParty.Addresses.Address.get(5).MunicipalityCode = 'MunicipalityCode5';
                businessAccount.OrganizationParty.Addresses.Address.get(5).Country = 'Country5';
        
        businessAccount.OrganizationParty.Forwardings = new postenNoEconnectKatsSakgetcustomer.Forwardings_element();
        businessAccount.OrganizationParty.Forwardings.Forwarding = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakForwardingType>();
            businessAccount.OrganizationParty.Forwardings.Forwarding.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakForwardingType());
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).Number_x = 'B000001';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ReferenceOMA = 'ReferenceOMA';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).Type_x = 'hold';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).Source = 'form';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OEBSURI = 'OEBSURI';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.Type_x = 'Type_x';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.Street = 'Street';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.City = 'City';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.MunicipalityName = 'MunicipalityName';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).FromAddress.Country = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.Type_x = 'Type_x';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.Street = 'Street';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.City = 'City';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.MunicipalityName = 'MunicipalityName';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).ToAddress.Country = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).StartDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).EndDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).HoldDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties = new postenNoEconnectKatsSakgetcustomer.OtherParties_element();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties.Party = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType>();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties.Party.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType());
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).LastName = 'LastName';
            businessAccount.OrganizationParty.Forwardings.Forwarding.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakForwardingType());
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).Number_x = 'B000002';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ReferenceOMA = 'ReferenceOMA';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).Type_x = 'permanent';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).Source = 'Source';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OEBSURI = 'OEBSURI';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.Type_x = 'Type_x';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.Street = 'Street';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.City = 'City';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.MunicipalityName = 'MunicipalityName';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).FromAddress.Country = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.Type_x = 'Type_x';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.Street = 'Street';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.City = 'City';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.MunicipalityName = 'MunicipalityName';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).ToAddress.Country = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).StartDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).EndDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).HoldDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties = new postenNoEconnectKatsSakgetcustomer.OtherParties_element();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties.Party = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType>();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties.Party.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType());
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).LastName = 'LastName';
            businessAccount.OrganizationParty.Forwardings.Forwarding.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakForwardingType());
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).Number_x = 'B000003';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ReferenceOMA = 'ReferenceOMA';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).Type_x = 'temporary';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).Source = 'Source';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OEBSURI = 'OEBSURI';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.Type_x = 'Type_x';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.Street = 'Street';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.City = 'City';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.MunicipalityName = 'MunicipalityName';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).FromAddress.Country = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.Type_x = 'Type_x';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.Street = 'Street';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.PostalCode = 'PostalCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.City = 'City';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.MunicipalityName = 'MunicipalityName';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).ToAddress.Country = 'Country';
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).StartDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).EndDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).HoldDate = Date.today();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties = new postenNoEconnectKatsSakgetcustomer.OtherParties_element();
                businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties.Party = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType>();
                    businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties.Party.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType());
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).LastName = 'LastName';
        
        businessAccount.OrganizationParty.Orders = new postenNoEconnectKatsSakgetcustomer.Orders_element();
        businessAccount.OrganizationParty.Orders.Order = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakOrderType>();
            businessAccount.OrganizationParty.Orders.Order.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakOrderType());
                businessAccount.OrganizationParty.Orders.Order.get(0).Number_x = 'Number_x';
                businessAccount.OrganizationParty.Orders.Order.get(0).Type_x = 'Type_x';
                businessAccount.OrganizationParty.Orders.Order.get(0).Sum = 10.10;
                businessAccount.OrganizationParty.Orders.Order.get(0).OrderedByName = 'OrderedByName';
                businessAccount.OrganizationParty.Orders.Order.get(0).OrderedByNumber = 'OrderedByNumber';
                businessAccount.OrganizationParty.Orders.Order.get(0).Status = 'Status';
                businessAccount.OrganizationParty.Orders.Order.get(0).OEBSURI = 'OEBSURI';
        
        businessAccount.OrganizationParty.Invoices = new postenNoEconnectKatsSakgetcustomer.Invoices_element();
        businessAccount.OrganizationParty.Invoices.Invoice = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakInvoiceType>();
            businessAccount.OrganizationParty.Invoices.Invoice.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakInvoiceType());
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).Number_x = 'Number_x';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).Type_x = 'Type_x';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).Sum = 10.10;
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).OrderedByName = 'OrderedByName';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).OrderedByNumber = 'OrderedByNumber';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).Status = 'Status';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).ItellaURI = 'ItellaURI';
                businessAccount.OrganizationParty.Invoices.Invoice.get(0).OEBSURI = 'OEBSURI';
            
        businessAccount.OrganizationParty.FiscalCode = '123456789';
        businessAccount.OrganizationParty.MarketName = 'MarketName';
        businessAccount.OrganizationParty.LegalName = 'LegalName';
        
        businessAccount.OrganizationParty.Divisions = new postenNoEconnectKatsSakgetcustomer.Divisions_element();
        businessAccount.OrganizationParty.Divisions.Division = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakDivisionType>();
            businessAccount.OrganizationParty.Divisions.Division.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakDivisionType());
                businessAccount.OrganizationParty.Divisions.Division.get(0).DivisionName = 'POST';
                businessAccount.OrganizationParty.Divisions.Division.get(0).SegmentName = 'SegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(0).SubSegmentName = 'SubSegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson = new postenNoEconnectKatsSakgetcustomer.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.Name = new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType();
                        businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.Name.FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.Name.MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.Name.LastName = 'LastName';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.PhoneNumber = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesPerson.Email = 'test@test.com';
                businessAccount.OrganizationParty.Divisions.Division.get(0).OtherSalesPerson = new postenNoEconnectKatsSakgetcustomer.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(0).OtherSalesPerson.Name = new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType();
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
                businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport = new postenNoEconnectKatsSakgetcustomer.SalesSupportType();
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportID = 0;
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportFirstName = 'SalesSupportFirstName';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportSurname = 'SalesSupportSurname';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportPhone = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportEmail = 'test@test.com';
                    businessAccount.OrganizationParty.Divisions.Division.get(0).SalesSupport.SalesSupportMobilePhone = '87654321';
            businessAccount.OrganizationParty.Divisions.Division.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakDivisionType());
                businessAccount.OrganizationParty.Divisions.Division.get(1).DivisionName = 'LOGISTICS';
                businessAccount.OrganizationParty.Divisions.Division.get(1).SegmentName = 'SegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(1).SubSegmentName = 'SubSegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson = new postenNoEconnectKatsSakgetcustomer.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.Name = new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType();
                        businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.Name.FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.Name.MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.Name.LastName = 'LastName';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.PhoneNumber = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesPerson.Email = 'test@test.com';
                businessAccount.OrganizationParty.Divisions.Division.get(1).OtherSalesPerson = new postenNoEconnectKatsSakgetcustomer.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(1).OtherSalesPerson.Name = new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType();
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
                businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport = new postenNoEconnectKatsSakgetcustomer.SalesSupportType();
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportID = 0;
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportFirstName = 'SalesSupportFirstName';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportSurname = 'SalesSupportSurname';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportPhone = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportEmail = 'test@test.com';
                    businessAccount.OrganizationParty.Divisions.Division.get(1).SalesSupport.SalesSupportMobilePhone = '87654321';
            businessAccount.OrganizationParty.Divisions.Division.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakDivisionType());
                businessAccount.OrganizationParty.Divisions.Division.get(2).DivisionName = 'LOGISTIKK';
                businessAccount.OrganizationParty.Divisions.Division.get(2).SegmentName = 'SegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(2).SubSegmentName = 'SubSegmentName';
                businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson = new postenNoEconnectKatsSakgetcustomer.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.Name = new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType();
                        businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.Name.FirstName = 'FirstName';
                        businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.Name.MiddleName = 'MiddleName';
                        businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.Name.LastName = 'LastName';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.PhoneNumber = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesPerson.Email = 'test@test.com';
                businessAccount.OrganizationParty.Divisions.Division.get(2).OtherSalesPerson = new postenNoEconnectKatsSakgetcustomer.KATS_SakSalesPersonType();
                    businessAccount.OrganizationParty.Divisions.Division.get(2).OtherSalesPerson.Name = new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType();
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
                businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport = new postenNoEconnectKatsSakgetcustomer.SalesSupportType();
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportID = 0;
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportFirstName = 'SalesSupportFirstName';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportSurname = 'SalesSupportSurname';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportPhone = '12345678';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportEmail = 'test@test.com';
                    businessAccount.OrganizationParty.Divisions.Division.get(2).SalesSupport.SalesSupportMobilePhone = '87654321';
        
        businessAccount.OrganizationParty.Contacts =  new postenNoEconnectKatsSakgetcustomer.ContactsComplexType();
        businessAccount.OrganizationParty.Contacts.Contact = new list<postenNoEconnectKatsSakgetcustomer.ContactComplexType>();
            businessAccount.OrganizationParty.Contacts.Contact.add(new postenNoEconnectKatsSakgetcustomer.ContactComplexType());
                businessAccount.OrganizationParty.Contacts.Contact.get(0).ContactID = 'ContactID';
                businessAccount.OrganizationParty.Contacts.Contact.get(0).ContactName = new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType();
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).ContactName.FirstName = 'FirstName';
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).ContactName.MiddleName = 'MiddleName';
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).ContactName.LastName = 'LastName';
                businessAccount.OrganizationParty.Contacts.Contact.get(0).Department = 'Department';
                businessAccount.OrganizationParty.Contacts.Contact.get(0).Title = 'Title';
                businessAccount.OrganizationParty.Contacts.Contact.get(0).Communication = new postenNoEconnectKatsSakgetcustomer.KATS_SakCommunicationType();
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).Communication.PhoneNumber = '12345678';
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).Communication.MobileNumber = '87654321';
                    businessAccount.OrganizationParty.Contacts.Contact.get(0).Communication.EMailAddress = 'test@test.com';
                
        businessAccount.OrganizationParty.Revenues =  new postenNoEconnectKatsSakgetcustomer.RevenueType();
        businessAccount.OrganizationParty.Revenues.TotalRevenueCurrentYear_L = 500.0;
        businessAccount.OrganizationParty.Revenues.TotalRevenueCurrentYear_P = 600.0;
        businessAccount.OrganizationParty.Revenues.TotalRevenuePreviousYear_L = 700.0;
        businessAccount.OrganizationParty.Revenues.TotalRevenuePreviousYear_P = 800.0;
        
        
        privateAccount = new postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters();
        
        privateAccount.ListType = '';
        privateAccount.PersonParty = new postenNoEconnectKatsSakgetcustomer.KATS_SakCustomerPersonType();
        privateAccount.PersonParty.PartyNumber = 'QQQQQ7654321SQS';
        privateAccount.PersonParty.Status = 'Gyldig';
        //privateAccount.PersonParty.CustomerNumber = 'QAQA1234567p';
         privateAccount.PersonParty.CustomerNumber = 'QAQA1234567pxyz';
        privateAccount.PersonParty.Communications = new postenNoEconnectKatsSakgetcustomer.Communications_element();
        privateAccount.PersonParty.Addresses = new postenNoEconnectKatsSakgetcustomer.Addresses_element();
        privateAccount.PersonParty.Addresses.Address = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType>();
            privateAccount.PersonParty.Addresses.Address.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType());
                privateAccount.PersonParty.Addresses.Address.get(0).Type_x =  'XXAD_POST';
                privateAccount.PersonParty.Addresses.Address.get(0).Street = 'Street0';
                privateAccount.PersonParty.Addresses.Address.get(0).PostalCode = 'PostalCode0';
                privateAccount.PersonParty.Addresses.Address.get(0).City = 'City0';
                privateAccount.PersonParty.Addresses.Address.get(0).MunicipalityName = 'MunicipalityName0';
                privateAccount.PersonParty.Addresses.Address.get(0).MunicipalityCode = 'MunicipalityCode0';
                privateAccount.PersonParty.Addresses.Address.get(0).Country = 'Country0';
            privateAccount.PersonParty.Addresses.Address.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType());
                privateAccount.PersonParty.Addresses.Address.get(1).Type_x =  'TEST';
                privateAccount.PersonParty.Addresses.Address.get(1).Street = 'Street1';
                privateAccount.PersonParty.Addresses.Address.get(1).PostalCode = 'PostalCode1';
                privateAccount.PersonParty.Addresses.Address.get(1).City = 'City1';
                privateAccount.PersonParty.Addresses.Address.get(1).MunicipalityName = 'MunicipalityName1';
                privateAccount.PersonParty.Addresses.Address.get(1).MunicipalityCode = 'MunicipalityCode1';
                privateAccount.PersonParty.Addresses.Address.get(1).Country = 'Country1';
        
        privateAccount.PersonParty.Forwardings = new postenNoEconnectKatsSakgetcustomer.Forwardings_element();
        privateAccount.PersonParty.Forwardings.Forwarding = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakForwardingType>();
            privateAccount.PersonParty.Forwardings.Forwarding.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakForwardingType());
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).Number_x = 'P000001';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).ReferenceOMA = 'ReferenceOMA';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).Type_x = 'hold';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).Source = 'form';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).OEBSURI = 'OEBSURI';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.Type_x = 'Type_x';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.Street = 'Street';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.City = 'City';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.MunicipalityName = 'MunicipalityName';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).FromAddress.Country = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.Type_x = 'Type_x';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.Street = 'Street';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.City = 'City';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.MunicipalityName = 'MunicipalityName';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).ToAddress.Country = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).StartDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).EndDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).HoldDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties = new postenNoEconnectKatsSakgetcustomer.OtherParties_element();
                privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties.Party = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType>();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties.Party.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType());
                        privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).FirstName = 'FirstName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(0).OtherParties.Party.get(0).LastName = 'LastName';
            privateAccount.PersonParty.Forwardings.Forwarding.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakForwardingType());
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).Number_x = 'P000002';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).ReferenceOMA = 'ReferenceOMA';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).Type_x = 'permanent';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).Source = 'Source';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).OEBSURI = 'OEBSURI';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.Type_x = 'Type_x';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.Street = 'Street';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.City = 'City';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.MunicipalityName = 'MunicipalityName';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).FromAddress.Country = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.Type_x = 'Type_x';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.Street = 'Street';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.City = 'City';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.MunicipalityName = 'MunicipalityName';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).ToAddress.Country = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).StartDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).EndDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).HoldDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties = new postenNoEconnectKatsSakgetcustomer.OtherParties_element();
                privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties.Party = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType>();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties.Party.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType());
                        privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).FirstName = 'FirstName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(1).OtherParties.Party.get(0).LastName = 'LastName';
            privateAccount.PersonParty.Forwardings.Forwarding.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakForwardingType());
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).Number_x = 'P000003';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).ReferenceOMA = 'ReferenceOMA';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).Type_x = 'temporary';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).Source = 'Source';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).OEBSURI = 'OEBSURI';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.Type_x = 'Type_x';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.Street = 'Street';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.City = 'City';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.MunicipalityName = 'MunicipalityName';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).FromAddress.Country = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress = new postenNoEconnectKatsSakgetcustomer.KATS_SakAddressType();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.Type_x = 'Type_x';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.Street = 'Street';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.PostalCode = 'PostalCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.City = 'City';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.MunicipalityName = 'MunicipalityName';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.MunicipalityCode = 'MunicipalityCode';
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).ToAddress.Country = 'Country';
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).StartDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).EndDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).HoldDate = Date.today();
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties = new postenNoEconnectKatsSakgetcustomer.OtherParties_element();
                privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties.Party = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType>();
                    privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties.Party.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType());
                        privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).FirstName = 'FirstName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).MiddleName = 'MiddleName';
                        privateAccount.PersonParty.Forwardings.Forwarding.get(2).OtherParties.Party.get(0).LastName = 'LastName';
        
        privateAccount.PersonParty.Orders = new postenNoEconnectKatsSakgetcustomer.Orders_element();
        privateAccount.PersonParty.Invoices = new postenNoEconnectKatsSakgetcustomer.Invoices_element();
        privateAccount.PersonParty.Invoices.Invoice = new list<postenNoEconnectKatsSakgetcustomer.KATS_SakInvoiceType>();
            privateAccount.PersonParty.Invoices.Invoice.add(new postenNoEconnectKatsSakgetcustomer.KATS_SakInvoiceType());
                privateAccount.PersonParty.Invoices.Invoice.get(0).Number_x = 'Number_x';
                privateAccount.PersonParty.Invoices.Invoice.get(0).Type_x = 'Type_x';
                privateAccount.PersonParty.Invoices.Invoice.get(0).Sum = 10.10;
                privateAccount.PersonParty.Invoices.Invoice.get(0).OrderedByName = 'OrderedByName';
                privateAccount.PersonParty.Invoices.Invoice.get(0).OrderedByNumber = 'OrderedByNumber';
                privateAccount.PersonParty.Invoices.Invoice.get(0).Status = 'Status';
                privateAccount.PersonParty.Invoices.Invoice.get(0).ItellaURI = 'ItellaURI';
                privateAccount.PersonParty.Invoices.Invoice.get(0).OEBSURI = 'OEBSURI';
        
        privateAccount.PersonParty.Names = new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType();
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
    
    public static postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters getEmptyAccount() {
        return emptyAccount;
    }
    
    public static postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters getBusinessAccount() {
        return businessAccount;
    }
    
    public static postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters getPrivateAccount() {
        return privateAccount;
    }
}