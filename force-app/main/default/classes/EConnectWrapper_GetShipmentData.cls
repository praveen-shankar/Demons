public with sharing class EConnectWrapper_GetShipmentData {

    public postenNoEconnectKatsGetshipment.ShipmentUnitType eConnectResponse { get; set; }
    
    
    public ShipmentUnitType shipmentUnitType { get {
        system.debug('EConnectWrapper_GetShipmentData - shipmentUnitType');
        if(eConnectResponse == null) { system.debug('EConnectWrapper_GetShipmentData - new shipmentUnitType'); return new ShipmentUnitType(); }
        return new ShipmentUnitType(eConnectResponse); }
    }
    
    public EConnectWrapper_GetShipmentData(postenNoEconnectKatsGetshipment.ShipmentUnitType eConnectResponse) {
        this.eConnectResponse = eConnectResponse;
    }
        
    public class ShipmentUnitType {
        postenNoEconnectKatsGetshipment.ShipmentUnitType eConnectResponse { get; set; }
        
        public shipmentUnitType() { system.debug('EConnectWrapper_GetShipmentData - shipmentUnitType - no response'); eConnectResponse = null; }
        
        public shipmentUnitType(postenNoEconnectKatsGetshipment.ShipmentUnitType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - shipmentUnitType - ' + this.eConnectResponse);
        }
        
        public String ShipmentUnitID { get{ if(eConnectResponse == null || eConnectResponse.ShipmentUnitID == '') { return '-'; } return eConnectResponse.ShipmentUnitID; } }
        public String RelabledShipmentUnitID { get{ if(eConnectResponse == null || eConnectResponse.ShipmentSequence == '') { return '-'; } return eConnectResponse.RelabledShipmentUnitID; } }
        public String ShipmentID { get{ if(eConnectResponse == null || eConnectResponse.RelabledShipmentUnitID == '') { return '-'; } return eConnectResponse.ShipmentID; } }
        public String ShipmentSequence { get{ if(eConnectResponse == null || eConnectResponse.ShipmentSequence == '') { return '-'; } return eConnectResponse.ShipmentSequence; } }
        public String SpecialFreight { get{ if(eConnectResponse == null || eConnectResponse.SpecialFreight == '') { return '-'; } return eConnectResponse.SpecialFreight; } }
        public String ProductName { get{ if(eConnectResponse == null || eConnectResponse.ProductName == '') { return '-'; } return eConnectResponse.ProductName; } }
        public String ProductCode { get{ if(eConnectResponse == null || eConnectResponse.ProductCode == '') { return '-'; } return eConnectResponse.ProductCode; } }
        public String NewProductCode { get{ if(eConnectResponse == null || eConnectResponse.NewProductCode == '') { return '-'; } return eConnectResponse.NewProductCode; } }
        public String NewProductName { get{ if(eConnectResponse == null || eConnectResponse.NewProductName == '') { return '-'; } return eConnectResponse.NewProductName; } }
        public String SenderReference { get{ if(eConnectResponse == null || eConnectResponse.SenderReference == '') { return '-'; } return eConnectResponse.SenderReference; } }
        public String RecipientReference { get{ if(eConnectResponse == null || eConnectResponse.RecipientReference == '') { return '-'; } return eConnectResponse.RecipientReference; } }
        public String DelieverySignature { get{ if(eConnectResponse == null || eConnectResponse.DelieverySignature == '') { return '-'; } return eConnectResponse.DelieverySignature; } }
        public DateTime ShipmentDateTime { get{ if(eConnectResponse == null || eConnectResponse.ShipmentDateTime == null) { return null; } return eConnectResponse.ShipmentDateTime; } }
        
        public AddressTerminalType PostingTerminal { get{ if(eConnectResponse == null || eConnectResponse.PostingTerminal == null) { return new AddressTerminalType(); } return new AddressTerminalType(eConnectResponse.PostingTerminal); } }
        public AddressType CurrentCity { get{ if(eConnectResponse == null || eConnectResponse.CurrentCity == null) { return new AddressType(); } return new AddressType(eConnectResponse.CurrentCity); } }
        public AddressType ShipToAddress { get{ if(eConnectResponse == null || eConnectResponse.ShipToAddress == null) { return new AddressType(); } return new AddressType(eConnectResponse.ShipToAddress); } }
        public InsuranceType Insurance { get{ if(eConnectResponse == null || eConnectResponse.Insurance == null) { return new InsuranceType(); } return new InsuranceType(eConnectResponse.Insurance); } }
        public ShipmentDescription ShipmentDescription { get{ if(eConnectResponse == null || eConnectResponse.ShipmentDescription == null) { return new ShipmentDescription(); } return new ShipmentDescription(eConnectResponse.ShipmentDescription); } }
        public ValueAddedServices_element ValueAddedServices { get{ if(eConnectResponse == null || eConnectResponse.ValueAddedServices == null) { return new ValueAddedServices_element(); } return new ValueAddedServices_element(eConnectResponse.ValueAddedServices); } }
        public SortingMachineInfo_element SortingMachineInfo { get{ if(eConnectResponse == null || eConnectResponse.SortingMachineInfo == null) { return new SortingMachineInfo_element(); } return new SortingMachineInfo_element(eConnectResponse.SortingMachineInfo); } }
        public Events_element Events { get{ if(eConnectResponse == null || eConnectResponse.Events == null) { return new Events_element(); } return new Events_element(eConnectResponse.Events); } }
        public ShipmentPartyAddress Sender { get{ if(eConnectResponse == null || eConnectResponse.Sender == null) { return new ShipmentPartyAddress(); } return new ShipmentPartyAddress(eConnectResponse.Sender); } }
        public ShipmentPartyAddress Recipient { get{ if(eConnectResponse == null || eConnectResponse.CurrentCity == null) { return new ShipmentPartyAddress(); } return new ShipmentPartyAddress(eConnectResponse.Recipient); } }
    }
    
    public class AddressTerminalType {
        postenNoEconnectKatsGetshipment.AddressTerminalType eConnectResponse { get; set; }
        
        public AddressTerminalType() { system.debug('EConnectWrapper_GetShipmentData - AddressTerminalType - no response'); eConnectResponse = null; }
        
        public AddressTerminalType(postenNoEconnectKatsGetshipment.AddressTerminalType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - AddressTerminalType - ' + this.eConnectResponse);
        }
        
        public String Street { get{ if(eConnectResponse == null || eConnectResponse.Street == '') { return '-'; } return eConnectResponse.Street; } }
        public String PostalCode { get{ if(eConnectResponse == null || eConnectResponse.PostalCode == '') { return '-'; } return eConnectResponse.PostalCode; } }
        public String City { get{ if(eConnectResponse == null || eConnectResponse.City == '') { return '-'; } return eConnectResponse.City; } }
        public String MunicipalityName { get{ if(eConnectResponse == null || eConnectResponse.MunicipalityName == '') { return '-'; } return eConnectResponse.MunicipalityName; } }
        public String MunicipalityCode { get{ if(eConnectResponse == null || eConnectResponse.MunicipalityCode == '') { return '-'; } return eConnectResponse.MunicipalityCode; } }
        public String Country { get{ if(eConnectResponse == null || eConnectResponse.Country == '') { return '-'; } return eConnectResponse.Country; } }
        public String CountryCode { get{ if(eConnectResponse == null || eConnectResponse.CountryCode == '') { return '-'; } return eConnectResponse.CountryCode; } }
        public String type_x { get{ if(eConnectResponse == null || eConnectResponse.type_x == '') { return '-'; } return eConnectResponse.type_x; } }
        
        public String UnitNumber { get{ if(eConnectResponse == null || eConnectResponse.UnitNumber == '') { return '-'; } return eConnectResponse.UnitNumber; } }
        public String UnitName { get{ if(eConnectResponse == null || eConnectResponse.UnitName == '') { return '-'; } return eConnectResponse.UnitName; } }
    }
    
    public class InsuranceType {
        postenNoEconnectKatsGetshipment.InsuranceType eConnectResponse { get; set; }
        
        public InsuranceType() { system.debug('EConnectWrapper_GetShipmentData - InsuranceType - no response'); eConnectResponse = null; }
        
        public InsuranceType(postenNoEconnectKatsGetshipment.InsuranceType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - InsuranceType - ' + this.eConnectResponse);
        }
        
        public String DeclaredValueAmount { get{ if(eConnectResponse == null || eConnectResponse.DeclaredValueAmount == null) { return '-'; } return eConnectResponse.DeclaredValueAmount; } }
        public String Description { get{ if(eConnectResponse == null || eConnectResponse.Description == null) { return '-'; } return eConnectResponse.Description; } }
    }
    
    public class ShipmentDescription {
        postenNoEconnectKatsGetshipment.ShipmentDescription eConnectResponse { get; set; }
        
        public ShipmentDescription() { system.debug('EConnectWrapper_GetShipmentData - ShipmentDescription - no response'); eConnectResponse = null; }
        
        public ShipmentDescription(postenNoEconnectKatsGetshipment.ShipmentDescription eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - ShipmentDescription - ' + this.eConnectResponse);
        }
        
        public String Description { get{ if(eConnectResponse == null || eConnectResponse.Description == '') { return ''; } return eConnectResponse.Description; } }
        public String WeightMeasure { get{ if(eConnectResponse == null || eConnectResponse.WeightMeasure == '') { return '0'; } return eConnectResponse.WeightMeasure; } }
        public String HeightMeasure { get{ if(eConnectResponse == null || eConnectResponse.HeightMeasure == '') { return '0'; } return eConnectResponse.HeightMeasure; } }
        public String LengthMeasure { get{ if(eConnectResponse == null || eConnectResponse.LengthMeasure == '') { return '0'; } return eConnectResponse.LengthMeasure; } }
        public String WidthMeasure { get{ if(eConnectResponse == null || eConnectResponse.WidthMeasure == '') { return '0'; } return eConnectResponse.WidthMeasure; } }
    }
    
    public class ValueAddedServices_element {
        postenNoEconnectKatsGetshipment.ValueAddedServices_element eConnectResponse { get; set; }
        
        public ValueAddedServices_element() { system.debug('EConnectWrapper_GetShipmentData - ValueAddedServices_element - no response'); eConnectResponse = null; }
        
        public ValueAddedServices_element(postenNoEconnectKatsGetshipment.ValueAddedServices_element eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - ValueAddedServices_element - ' + this.eConnectResponse);
        }
        
        public ValueAddedService[] valueAddedService { set; get{
            valueAddedService = new List<ValueAddedService>();
            try{
                if(eConnectResponse != null && eConnectResponse.ValueAddedService != null) {
                    system.debug('EConnectWrapper_GetShipmentData - adding ValueAddedService');
                    for(postenNoEconnectKatsGetshipment.valueAddedService service : eConnectResponse.valueAddedService) {
                        valueAddedService.add(new valueAddedService(service));
                    }
                } else {
                    valueAddedService.add(new valueAddedService());
                }
            } catch (Exception ex) {
                system.debug('EConnectWrapper_GetShipmentData - ValueAddedServices_element - ' + ex.getMessage());
            }
            return valueAddedService;}
        }
    }
    
    public class ValueAddedService {
        postenNoEconnectKatsGetshipment.ValueAddedService eConnectResponse { get; set; }
        
        public ValueAddedService() { system.debug('EConnectWrapper_GetShipmentData - ValueAddedService - no response'); eConnectResponse = null; }
        
        public ValueAddedService(postenNoEconnectKatsGetshipment.ValueAddedService eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - ValueAddedService - ' + this.eConnectResponse);
        }
    
// OUT OF SCOPE =>      public String Status { get{ if(eConnectResponse == null || eConnectResponse.Status == null) { return '-'; } return eConnectResponse.Status; } }
        public String ServiceName { get{ if(eConnectResponse == null || eConnectResponse.ServiceName == null) { return '-'; } return eConnectResponse.ServiceName; } }
        public String CoDAmount { get{ if(eConnectResponse == null || eConnectResponse.CoDAmount == null) { return '-'; } return eConnectResponse.CoDAmount; } }
        public String BankAccountNumber { get{
            if(eConnectResponse == null || eConnectResponse.BankAccountNumber == null) { return '-'; }
            if(eConnectResponse.BankAccountNumber.length() == 11){
                return eConnectResponse.BankAccountNumber.substring(0, 4) + '.' + eConnectResponse.BankAccountNumber.substring(4, 6) + '.' + eConnectResponse.BankAccountNumber.substring(6);
            }
            return eConnectResponse.BankAccountNumber; 
        } }
    }
    
    public class SortingMachineInfo_element {
        postenNoEconnectKatsGetshipment.SortingMachineInfo_element eConnectResponse { get; set; }
        
        public SortingMachineInfo_element() { system.debug('EConnectWrapper_GetShipmentData - SortingMachineInfo_element - no response'); eConnectResponse = null; }
        
        public SortingMachineInfo_element(postenNoEconnectKatsGetshipment.SortingMachineInfo_element eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - SortingMachineInfo_element - ' + this.eConnectResponse);
        }
        
        public SortingInfo_element[] SortingInfo { set; get{
            SortingInfo = new List<SortingInfo_element>();
            try{
                if(eConnectResponse != null && eConnectResponse.SortingInfo != null) {
                    system.debug('EConnectWrapper_GetShipmentData - adding ValueAddedService');
                    for(postenNoEconnectKatsGetshipment.SortingInfo_element info : eConnectResponse.SortingInfo) {
                        SortingInfo.add(new SortingInfo_element(info));
                    }
                } else {
                    SortingInfo.add(new SortingInfo_element());
                }
            } catch (Exception ex) {
                system.debug('EConnectWrapper_GetShipmentData - SortingMachineInfo_element - ' + ex.getMessage());
            }
            return SortingInfo;}
        }
        
    }
    
    public class SortingInfo_element {
        postenNoEconnectKatsGetshipment.SortingInfo_element eConnectResponse { get; set; }
        
        public SortingInfo_element() { system.debug('EConnectWrapper_GetShipmentData - SortingInfo_element - no response'); eConnectResponse = null; }
        
        public SortingInfo_element(postenNoEconnectKatsGetshipment.SortingInfo_element eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - SortingInfo_element - ' + this.eConnectResponse);
        }
        
        public String BoardNumber { get{ if(eConnectResponse == null || eConnectResponse.BoardNumber == null) { return '-'; } return eConnectResponse.BoardNumber; } }
        public String Ramp { get{ if(eConnectResponse == null || eConnectResponse.Ramp == null) { return '-'; } return eConnectResponse.Ramp; } }
        public String SortingDate { get{ if(eConnectResponse == null || eConnectResponse.SortingDate == null) { return '-'; } return eConnectResponse.SortingDate.left(10); } }
        public String SortingTime { get{ if(eConnectResponse == null || eConnectResponse.SortingTime == null) { return '-'; } return eConnectResponse.SortingTime.left(8); } }
    }
    
    public class Events_element {
        postenNoEconnectKatsGetshipment.Events_element eConnectResponse { get; set; }
        
        public Events_element() { system.debug('EConnectWrapper_GetShipmentData - Events_element - no response'); eConnectResponse = null; }
        
        public Events_element(postenNoEconnectKatsGetshipment.Events_element eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - Events_element - ' + this.eConnectResponse);
        }
        
        public ShipmentEventType[] ShipmentEventType { set; get{
            ShipmentEventType = new List<ShipmentEventType>();
            try{
                if(eConnectResponse != null && eConnectResponse.Event != null) {
                    system.debug('EConnectWrapper_GetShipmentData - Events_element - adding ShipmentEventType');
                    for(postenNoEconnectKatsGetshipment.ShipmentEventType Event : eConnectResponse.Event) {
                        ShipmentEventType.add(new ShipmentEventType(Event));
                    }
                } else {
                    ShipmentEventType.add(new ShipmentEventType());
                }
            } catch (Exception ex) {
                system.debug('EConnectWrapper_GetShipmentData - Events_element - ' + ex.getMessage());
            }
            return ShipmentEventType;}
        }
    }
    
    public class ShipmentEventType {
        postenNoEconnectKatsGetshipment.ShipmentEventType eConnectResponse { get; set; }
        
        public ShipmentEventType() { system.debug('EConnectWrapper_GetShipmentData - ShipmentEventType - no response'); eConnectResponse = null; }
        
        public ShipmentEventType(postenNoEconnectKatsGetshipment.ShipmentEventType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - ShipmentEventType - ' + this.eConnectResponse);
        }
        
        public String EventCode { get{ if(eConnectResponse == null || eConnectResponse.EventCode == '') { return '-'; } return eConnectResponse.EventCode; } }
        public String EventName { get{ if(eConnectResponse == null || eConnectResponse.EventName == '') { return '-'; } return eConnectResponse.EventName; } }
        public String CaseDescription { get{ if(eConnectResponse == null || eConnectResponse.CaseDescription == '') { return '-'; } return eConnectResponse.CaseDescription; } }
        public String UnitNumber { get{ if(eConnectResponse == null || eConnectResponse.UnitNumber == '') { return '-'; } return eConnectResponse.UnitNumber; } }
        public String PostalCode { get{ if(eConnectResponse == null || eConnectResponse.PostalCode == '') { return '-'; } return eConnectResponse.PostalCode; } }
        public String UserName { get{ if(eConnectResponse == null || eConnectResponse.UserName == '') { return '-'; } return eConnectResponse.UserName; } }
        public String ShowDate_x { get {return String.valueOfGmt(Date_x);}}
        public DateTime Date_x { get{ if(eConnectResponse == null || eConnectResponse.Date_x == null) { return null; } return eConnectResponse.Date_x; } }
        public DateTime EtterregDate { get{ if(eConnectResponse == null || eConnectResponse.EtterregDate == null) { return null; } return eConnectResponse.EtterregDate; } }
        public String CountryCode { get{ if(eConnectResponse == null || eConnectResponse.CountryCode == '') { return '-'; } return eConnectResponse.CountryCode; } }
        public String Country { get{ if(eConnectResponse == null || eConnectResponse.Country == '') { return '-'; } return eConnectResponse.Country; } }
        public String Cause { get{ if(eConnectResponse == null || eConnectResponse.Cause == '') { return '-'; } return eConnectResponse.Cause; } }
        public String Action { get{ if(eConnectResponse == null || eConnectResponse.Action == '') { return '-'; } return eConnectResponse.Action; } }
        public String FreeText { get{ if(eConnectResponse == null || eConnectResponse.FreeText == '') { return '-'; } return eConnectResponse.FreeText; } }
        public String ShipmentUnitID { get{ if(eConnectResponse == null || eConnectResponse.ShipmentUnitID == '') { return '-'; } return eConnectResponse.ShipmentUnitID; } }
        public String ReceivedBy { get{ if(eConnectResponse == null || eConnectResponse.ReceivedBy == '') { return '-'; } return eConnectResponse.ReceivedBy; } }
        public String Signature { get{ if(eConnectResponse == null || eConnectResponse.Signature == '') { return '-'; } return eConnectResponse.Signature; } }
        public String SendtBy { get{ if(eConnectResponse == null || eConnectResponse.SendtBy == '') { return '-'; } return eConnectResponse.SendtBy; } }
        public String ReceiverCity { get{ if(eConnectResponse == null || eConnectResponse.ReceiverCity == '') { return '-'; } return eConnectResponse.ReceiverCity; } }
        public String ShelfID { get{ if(eConnectResponse == null || eConnectResponse.ShelfID== '') { return '-'; } return eConnectResponse.ShelfID; } }
        public String StationID { get{ if(eConnectResponse == null || eConnectResponse.StationID == '') { return '-'; } return eConnectResponse.StationID; } }
    }
    
    public class ShipmentPartyAddress {
        postenNoEconnectKatsGetshipment.ShipmentPartyAddress eConnectResponse { get; set; }
        
        public ShipmentPartyAddress() { system.debug('EConnectWrapper_GetShipmentData - ShipmentPartyAddress - no response'); eConnectResponse = null; }
        
        public ShipmentPartyAddress(postenNoEconnectKatsGetshipment.ShipmentPartyAddress eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - ShipmentPartyAddress - ' + this.eConnectResponse);
        }
        
        public String Street { get{ if(eConnectResponse == null || eConnectResponse.Street == '') { return '-'; } return eConnectResponse.Street; } }
        public String PostalCode { get{ if(eConnectResponse == null || eConnectResponse.PostalCode == '') { return '-'; } return eConnectResponse.PostalCode; } }
        public String City { get{ if(eConnectResponse == null || eConnectResponse.City == '') { return '-'; } return eConnectResponse.City; } }
        public String MunicipalityName { get{ if(eConnectResponse == null || eConnectResponse.MunicipalityName == '') { return '-'; } return eConnectResponse.MunicipalityName; } }
        public String MunicipalityCode { get{ if(eConnectResponse == null || eConnectResponse.MunicipalityCode == '') { return '-'; } return eConnectResponse.MunicipalityCode; } }
        public String Country { get{ if(eConnectResponse == null || eConnectResponse.Country == '') { return '-'; } return eConnectResponse.Country; } }
        public String CountryCode { get{ if(eConnectResponse == null || eConnectResponse.CountryCode == '') { return '-'; } return eConnectResponse.CountryCode; } }
        public String type_x { get{ if(eConnectResponse == null || eConnectResponse.type_x == '') { return '-'; } return eConnectResponse.type_x; } }
         
        public String PartyNumber { get{ if(eConnectResponse == null || eConnectResponse.PartyNumber == '') { return ''; } return KATSutilities.removeLeadingZeros(eConnectResponse.PartyNumber); } }
        public String FullName { get{ if(eConnectResponse == null || eConnectResponse.FullName == '') { return '-'; } return eConnectResponse.FullName; } }
    }
    
    public class AddressType {
        postenNoEconnectKatsGetshipment.AddressType eConnectResponse { get; set; }
        
        public AddressType() { system.debug('EConnectWrapper_GetShipmentData - AddressType - no response'); eConnectResponse = null; }
        
        public AddressType(postenNoEconnectKatsGetshipment.AddressType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetShipmentData - AddressType - ' + this.eConnectResponse);
        }
        
        public String Street { get{ if(eConnectResponse == null || eConnectResponse.Street == '') { return '-'; } return eConnectResponse.Street; } }
        public String PostalCode { get{ if(eConnectResponse == null || eConnectResponse.PostalCode == '') { return '-'; } return eConnectResponse.PostalCode; } }
        public String City { get{ if(eConnectResponse == null || eConnectResponse.City == '') { return '-'; } return eConnectResponse.City; } }
        public String MunicipalityName { get{ if(eConnectResponse == null || eConnectResponse.MunicipalityName == '') { return '-'; } return eConnectResponse.MunicipalityName; } }
        public String MunicipalityCode { get{ if(eConnectResponse == null || eConnectResponse.MunicipalityCode == '') { return '-'; } return eConnectResponse.MunicipalityCode; } }
        public String Country { get{ if(eConnectResponse == null || eConnectResponse.Country == '') { return '-'; } return eConnectResponse.Country; } }
        public String CountryCode { get{ if(eConnectResponse == null || eConnectResponse.CountryCode == '') { return '-'; } return eConnectResponse.CountryCode; } }
        public String type_x { get{ if(eConnectResponse == null || eConnectResponse.type_x == '') { return '-'; } return eConnectResponse.type_x; } }
    }
    
    static testMethod void coverageTest() {
        postenNoEconnectKatsGetshipment.ShipmentUnitType unit = mock_KatsGetshipment.getShipment().ShipmentUnit;
        
        EConnectWrapper_GetShipmentData wrapper = new EConnectWrapper_GetShipmentData(unit);
        
        String ShipmentUnitID = wrapper.shipmentUnitType.ShipmentUnitID;
        String RelabledShipmentUnitID  = wrapper.shipmentUnitType.RelabledShipmentUnitID;
        String ShipmentID = wrapper.shipmentUnitType.ShipmentID;
        String ShipmentSequence = wrapper.shipmentUnitType.ShipmentSequence;
        String SpecialFreight = wrapper.shipmentUnitType.SpecialFreight;
        String ProductName = wrapper.shipmentUnitType.ProductName;
        String ProductCode = wrapper.shipmentUnitType.ProductCode;
        String NewProductCode = wrapper.shipmentUnitType.NewProductCode;
        String NewProductName = wrapper.shipmentUnitType.NewProductName;
        String SenderReference = wrapper.shipmentUnitType.SenderReference;
        String RecipientReference = wrapper.shipmentUnitType.RecipientReference;
        
        EConnectWrapper_GetShipmentData.AddressTerminalType PostingTerminal = wrapper.shipmentUnitType.PostingTerminal;
        EConnectWrapper_GetShipmentData.AddressType CurrentCity = wrapper.shipmentUnitType.CurrentCity;
        EConnectWrapper_GetShipmentData.AddressType ShipToAddress = wrapper.shipmentUnitType.ShipToAddress;
        EConnectWrapper_GetShipmentData.InsuranceType Insurance = wrapper.shipmentUnitType.Insurance;
        EConnectWrapper_GetShipmentData.ShipmentDescription ShipmentDescription = wrapper.shipmentUnitType.ShipmentDescription;
        EConnectWrapper_GetShipmentData.ValueAddedServices_element ValueAddedServices = wrapper.shipmentUnitType.ValueAddedServices;
        List<EConnectWrapper_GetShipmentData.ValueAddedService> ValueAddedService = ValueAddedServices.valueAddedService;
        String DelieverySignature = wrapper.shipmentUnitType.DelieverySignature;
        EConnectWrapper_GetShipmentData.SortingMachineInfo_element SortingMachineInfo = wrapper.shipmentUnitType.SortingMachineInfo;
        List<EConnectWrapper_GetShipmentData.SortingInfo_element> SortingInfo_element = SortingMachineInfo.SortingInfo;
        DateTime ShipmentDateTime = wrapper.shipmentUnitType.ShipmentDateTime;
        EConnectWrapper_GetShipmentData.Events_element Events = wrapper.shipmentUnitType.Events;
        List<EConnectWrapper_GetShipmentData.ShipmentEventType> ShipmentEventType = Events.ShipmentEventType;
        EConnectWrapper_GetShipmentData.ShipmentPartyAddress Sender = wrapper.shipmentUnitType.Sender;
        EConnectWrapper_GetShipmentData.ShipmentPartyAddress Recipient = wrapper.shipmentUnitType.Recipient;
    }
    
    
    
}