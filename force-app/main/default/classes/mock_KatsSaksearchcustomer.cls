public with sharing class mock_KatsSaksearchcustomer {
    private static final postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType emptySearch;
    private static final postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType privateSearch;
    private static final postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType businessSearch;
    
    static {
            emptySearch = new postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType();
            postenNoEconnectAboCustomerpartyV1.PartyMasterType EmptyParty = new postenNoEconnectAboCustomerpartyV1.PartyMasterType();
            List<postenNoEconnectAboCustomerpartyV1.PartyMasterType> EmptyList = new List<postenNoEconnectAboCustomerpartyV1.PartyMasterType>();
            EmptyList.add(EmptyParty);
            emptySearch.PartyMaster=EmptyList;
        
            privateSearch = new postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType();
            postenNoEconnectAboCustomerpartyV1.PartyMasterType PersonParty = new postenNoEconnectAboCustomerpartyV1.PartyMasterType();
            List<postenNoEconnectAboCustomerpartyV1.PartyMasterType> PersonPartyList = new List<postenNoEconnectAboCustomerpartyV1.PartyMasterType>();
            postenNoEconnectAboCustomerpartyV1.PartyNameType name=new postenNoEconnectAboCustomerpartyV1.PartyNameType();
            List<postenNoEconnectAboCustomerpartyV1.PartyNameType> nameList=new List<postenNoEconnectAboCustomerpartyV1.PartyNameType>();
            name.PartyName= 'FirstName LastName';
            nameList.add(name);   
            PersonParty.Name=nameList;
            PersonParty.PartyType ='Person';
            postenNoEconnectAboCustomerpartyV1.PartyIdType partyId=new postenNoEconnectAboCustomerpartyV1.PartyIdType();
            List<String> partynumberlist=new List<String>();
            partynumberList.add('7654321');
            partyId.PartyNumber=partynumberlist;
            PersonParty.PartyIds=partyId;
            postenNoEconnectAboCustomerpartyV1.StatusType statusinfo=new postenNoEconnectAboCustomerpartyV1.StatusType();
            statusinfo.Status='Gyldig';
            Statusinfo.StatusCode='01';
            
            PersonParty.Status=statusinfo;
            List<postenNoEconnectAboCustomerpartyV1.LocationType> locationTypeList=new List<postenNoEconnectAboCustomerpartyV1.LocationType>();
            postenNoEconnectAboCustomerpartyV1.LocationType locationinfo=new postenNoEconnectAboCustomerpartyV1.LocationType();
            List<postenNoEconnectAboCustomerpartyV1.AddressType> AddressTypeList=new List<postenNoEconnectAboCustomerpartyV1.AddressType>();
            postenNoEconnectAboCustomerpartyV1.AddressType address=new postenNoEconnectAboCustomerpartyV1.AddressType();
            address.StreetName = 'Test Street';
            address.PostalCode = '123456';
            address.CityName = 'City';
            AddressTypeList.add(address);
            locationinfo.Address=AddressTypeList;
            locationTypeList.add(locationinfo);
            PersonParty.location=locationTypeList;
            PersonPartyList.add(PersonParty);
            privateSearch.PartyMaster=PersonPartyList;
            
            businessSearch = new postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType();
            postenNoEconnectAboCustomerpartyV1.PartyMasterType businessParty = new postenNoEconnectAboCustomerpartyV1.PartyMasterType();
            List<postenNoEconnectAboCustomerpartyV1.PartyMasterType> businessPartyList = new List<postenNoEconnectAboCustomerpartyV1.PartyMasterType>();
            postenNoEconnectAboCustomerpartyV1.PartyNameType bname=new postenNoEconnectAboCustomerpartyV1.PartyNameType();
            List<postenNoEconnectAboCustomerpartyV1.PartyNameType> bnameList=new List<postenNoEconnectAboCustomerpartyV1.PartyNameType>();
            bname.PartyName= 'LegalName';
            bnameList.add(name);   
            businessParty.Name=nameList;
            businessParty.PartyType ='Organization';
            postenNoEconnectAboCustomerpartyV1.PartyIdType bpartyId=new postenNoEconnectAboCustomerpartyV1.PartyIdType();
            List<String> bpartynumberlist=new List<String>();
            bpartynumberList.add('1234567');
            bpartyId.PartyNumber=bpartynumberlist;
            businessParty.PartyIds=bpartyId;
            postenNoEconnectAboCustomerpartyV1.StatusType bstatusinfo=new postenNoEconnectAboCustomerpartyV1.StatusType();
            bstatusinfo.Status='Gyldig';
            bStatusinfo.StatusCode='01';
            
            businessParty.Status=bstatusinfo;
            List<postenNoEconnectAboCustomerpartyV1.LocationType> blocationTypeList=new List<postenNoEconnectAboCustomerpartyV1.LocationType>();
            postenNoEconnectAboCustomerpartyV1.LocationType blocationinfo=new postenNoEconnectAboCustomerpartyV1.LocationType();
            List<postenNoEconnectAboCustomerpartyV1.AddressType> bAddressTypeList=new List<postenNoEconnectAboCustomerpartyV1.AddressType>();
            postenNoEconnectAboCustomerpartyV1.AddressType baddress=new postenNoEconnectAboCustomerpartyV1.AddressType();
            baddress.StreetName = 'Test Street';
            baddress.PostalCode = '123456';
            baddress.CityName = 'City';
            AddressTypeList.add(baddress);
            locationinfo.Address=bAddressTypeList;
            locationTypeList.add(blocationinfo);
            businessParty.location=blocationTypeList;
            businessPartyList.add(businessParty);
            businessSearch.PartyMaster=businessPartyList;
        
       /* businessSearch = new postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerOutParameters();
        businessSearch.TotalNumberOfRecords = 1;
        businessSearch.CustomerList = new postenNoEconnectKatsSaksearchcustome.CustomerList_element();
        businessSearch.CustomerList.Customer = new list<postenNoEconnectKatsSaksearchcustome.Customer_element>();
        businessSearch.CustomerList.Customer.add(new postenNoEconnectKatsSaksearchcustome.Customer_element());
        businessSearch.CustomerList.Customer.get(0).PartyNumber = '1234567';
        businessSearch.CustomerList.Customer.get(0).Status = 'Gyldig';
        businessSearch.CustomerList.Customer.get(0).PartyType = 'Organization';
        businessSearch.CustomerList.Customer.get(0).PartyName = 'LegalName';
        businessSearch.CustomerList.Customer.get(0).FiscalReference = '';
        businessSearch.CustomerList.Customer.get(0).ResponseAddress = new postenNoEconnectKatsSaksearchcustome.ResponseAddress_element();
        businessSearch.CustomerList.Customer.get(0).ResponseAddress.AddressType = 'AddressType';
        businessSearch.CustomerList.Customer.get(0).ResponseAddress.AddressName = 'AddressName';
        businessSearch.CustomerList.Customer.get(0).ResponseAddress.DwellingNumber = 'DwellingNumber';
        businessSearch.CustomerList.Customer.get(0).ResponseAddress.PostalCode = 'PostalCode';
        businessSearch.CustomerList.Customer.get(0).ResponseAddress.City = 'City';
        businessSearch.CustomerList.Customer.get(0).Division = new list<postenNoEconnectKatsSaksearchcustome.Division_element>();
        businessSearch.CustomerList.Customer.get(0).Division.add(new postenNoEconnectKatsSaksearchcustome.Division_element());
        businessSearch.CustomerList.Customer.get(0).Division.get(0).DivisionName ='DivisionName';
        businessSearch.CustomerList.Customer.get(0).Division.get(0).SalesPerson ='SalesPerson';
        businessSearch.CustomerList.Customer.get(0).Division.get(0).OtherSalesPerson ='OtherSalesPerson';
        businessSearch.CustomerList.Customer.get(0).Division.get(0).CRMInactive = 0;
        businessSearch.CustomerList.Customer.get(0).Division.get(0).CRMStatus = 0;
        businessSearch.CustomerList.Customer.get(0).Division.get(0).CustomerStatus = 0;
        businessSearch.CustomerList.Customer.get(0).Division.get(0).Number_x = 'Number_x';
        businessSearch.CustomerList.Customer.get(0).Division.get(0).SOW = 0;
        businessSearch.CustomerList.Customer.get(0).Division.get(0).SalesSupport = new postenNoEconnectKatsSaksearchcustome.SalesSupportType();
        businessSearch.CustomerList.Customer.get(0).TurnoverFlag = false;
        businessSearch.CustomerList.Customer.get(0).Revenues = new postenNoEconnectKatsSaksearchcustome.RevenueType();
        businessSearch.CustomerList.Customer.get(0).Revenues.TotalRevenuePreviousYear_L = 100.00;
        businessSearch.CustomerList.Customer.get(0).Revenues.TotalRevenueCurrentYear_L = 100.00;
        businessSearch.CustomerList.Customer.get(0).Revenues.TotalRevenuePreviousYear_P = 100.00;
        businessSearch.CustomerList.Customer.get(0).Revenues.TotalRevenueCurrentYear_P = 100.00;*/
    }
    
    public class emptySearch implements WebServiceMock {
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
                
                response.put('response_x', getEmptySearch()); 
        }
    }
    
    public class privateSearch implements WebServiceMock {
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
                
                response.put('response_x', getPrivateSearch()); 
        }
    }
    
    public class businessSearch implements WebServiceMock {
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
                
                response.put('response_x', getBusinessSearch()); 
        }
    }
    
    public static postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType getEmptySearch() {
        return emptySearch;
    }
    
    public static postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType getPrivateSearch() {
        return privateSearch;
    }
    
    public static postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType getBusinessSearch() {
        return businessSearch;
    }
}