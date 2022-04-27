public class EConnectWrapper_GetCustomerData { 
    
    public postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectResponse { get; set; }
    
    public EConnectWrapper_GetCustomerData(postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectResponse){
        this.eConnectResponse = eConnectResponse;
    }
    
    
    /*public String listType { get{
        if(eConnectResponse.listType == null) { return null; }
        return eConnectResponse.ListType; }
    }*/
    
    public OrganizationParty organizationParty { get{
        if(eConnectResponse == null || eConnectResponse.organizationParty == null) { 
            system.debug('~~EConnectWrapper_GetCustomerData - new businessParty');
            return new organizationParty(); 
            }
            system.debug('~~eConnectResponse.OrganizationParty'+ eConnectResponse.OrganizationParty);
        return new OrganizationParty(eConnectResponse.OrganizationParty); }
    }
    

    
    public PersonParty personParty { get{
        if(eConnectResponse == null || eConnectResponse.personParty == null) { system.debug('~~EConnectWrapper_GetCustomerData - new personParty'+'~~'+eConnectResponse); return new PersonParty(); }
        return new PersonParty(eConnectResponse.PersonParty); }
    }
    
     public ForwardingElement forwardingElements { get{
            if(eConnectResponse == null || eConnectResponse.Forwardings == null) { return new ForwardingElement(); }
            system.debug('~~eConnectResponse.Forwardings'+ eConnectResponse.Forwardings);
            return new ForwardingElement(eConnectResponse.Forwardings); }
        }
          public OrderElement orderElements { get{
          System.debug('~~~eConnectResponse::'+eConnectResponse);
          System.debug('~~~eConnectResponseorder::'+eConnectResponse.Orders);
            if(eConnectResponse.Orders == null) { return new OrderElement(); }
             System.debug('~~~eConnectResponse.Orders::'+eConnectResponse.Orders);
            return new OrderElement(eConnectResponse.Orders); }
        }
        
        public InvoiceElement invoiceElements { get{
            if(eConnectResponse.Invoices == null) { return new InvoiceElement(); }
            System.debug('~~~eConnectResponse.Invoices::'+eConnectResponse.Invoices);
            return new InvoiceElement(eConnectResponse.Invoices); }
        }
    public class OrganizationParty {
        private postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType eConnectResponse { get; set; }
        
        public OrganizationParty(){}
        
        public OrganizationParty(postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType eConnectResponse){
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse); 
        }
        

        
        public String PartyNumber { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.PartyNumber; } }
        public String DigipostID {get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.DigipostID; }}
        public String Status { get{ if(eConnectResponse == null) {return '-'; } return OrganizationStatus(eConnectResponse.StatusCode,eConnectResponse.Status); } }
        public String CustomerNumber { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.CustomerNumber; } }
        public String FiscalCode { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.FiscalCode; } }
        public String MarketName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.MarketName; } }
        public String LegalName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.LegalName; } }
         public String CDHCustomerNumber { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.CDHCustomerNumber; } }
        
        public ForwardingElement forwardingElements { get{
            if(eConnectResponse == null || eConnectResponse.Forwardings == null) { return new ForwardingElement(); }
            return new ForwardingElement(eConnectResponse.Forwardings); }
        }
        
        public OrderElement orderElements { get{
            if(eConnectResponse == null || eConnectResponse.Orders == null) { return new OrderElement(); }
            return new OrderElement(eConnectResponse.Orders); }
        }
        
        public InvoiceElement invoiceElements { get{
            if(eConnectResponse == null || eConnectResponse.Invoices == null) { return new InvoiceElement(); }
            return new InvoiceElement(eConnectResponse.Invoices); }
        }
        
        public CommunicationElement communicationElements { get{
            if(eConnectResponse == null || eConnectResponse.Communications == null) { return new CommunicationElement(); }
            return new CommunicationElement(eConnectResponse.Communications); }
        }
        
        public AddressElement addressElements { get{
            if(eConnectResponse == null || eConnectResponse.Addresses == null) { return new AddressElement(); }
            return new AddressElement(eConnectResponse.Addresses); }
        }
       /* public DivisionElement divisionElements { get{
            if(eConnectResponse == null || eConnectResponse.Divisions == null) { return new DivisionElement(); } 
            return new DivisionElement(eConnectResponse.Divisions); }
        }*/
        
        /*public ContactsElement contactsElements { get{
            if(eConnectResponse == null || eConnectResponse.Contacts == null) { return new ContactsElement(); }
            return new ContactsElement(eConnectResponse.Contacts); }
        }*/
        
    }
    
    public class PersonParty {
        private postenNoEconnectAboCrmCrmgetcustome.CustomerPersonType eConnectResponse { get; set; }
        
        public PersonParty(){}
        
        public PersonParty(postenNoEconnectAboCrmCrmgetcustome.CustomerPersonType eConnectResponse){
            system.debug('EConnectWrapper_GetCustomerData - Getting personParty');
            this.eConnectResponse = eConnectResponse;
        }
        
        public String PartyNumber { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.PartyNumber; } }
        public String DigipostID {get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.DigipostID; }}
        public String StatusCode{get{if(eConnectResponse == null){return '-'; } return eConnectResponse.Status; } }
        public String Status { get{ if(eConnectResponse == null) {return '-'; } return PersonStatus(eConnectResponse.StatusCode,eConnectResponse.Status); } }
        public String CustomerNumber { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.CustomerNumber; } }
        
        public CommunicationElement communicationElements { get{
            if(eConnectResponse == null || eConnectResponse.Communications == null) { return new CommunicationElement(); }
            return new CommunicationElement(eConnectResponse.Communications); }
        }
        
        public AddressElement addressElements { get{
            if(eConnectResponse == null || eConnectResponse.Addresses == null) { return new AddressElement(); }
            return new AddressElement(eConnectResponse.Addresses); }
        }
        
        public ForwardingElement forwardingElements { get{
            if(eConnectResponse == null || eConnectResponse.Forwardings == null) { return new ForwardingElement(); }
            return new ForwardingElement(eConnectResponse.Forwardings); }
        }
        
        public OrderElement orderElements { get{
            if(eConnectResponse == null || eConnectResponse.Orders == null) { return new OrderElement(); }
            return new OrderElement(eConnectResponse.Orders); }
        }
        
        public InvoiceElement invoiceElements { get{
            if(eConnectResponse == null || eConnectResponse.Invoices == null) { return new InvoiceElement(); }
            return new InvoiceElement(eConnectResponse.Invoices); }
        }
            
        public PersonNameType Names { get{
            if(eConnectResponse == null || eConnectResponse.Names == null) { return new PersonNameType(); }
            return new PersonNameType(eConnectResponse.Names); }
        }
    }
    
    public class CommunicationElement {
        private postenNoEconnectAboCrmCrmgetcustome.Communications_element eConnectResponse { get; set; }
        
        public CommunicationElement(){}
        
        public CommunicationElement(postenNoEconnectAboCrmCrmgetcustome.Communications_element eConnectResponse){
            this.eConnectResponse = eConnectResponse;
        }
        
        public CommunicationType[] communicationTypes { set; get{
            communicationTypes = new List<CommunicationType>();
            try {
                if(eConnectResponse != null && eConnectResponse.communication != null) {
                    for(postenNoEconnectAboCrmCrmgetcustome.CommunicationType communication : eConnectResponse.communication) {
                        communicationTypes.add(new CommunicationType(communication));
                    }
                }
                else {
                    communicationTypes.add(new CommunicationType());
                }
            } catch (Exception e){
                system.debug('EConnectWrapper_GetCustomerData - Exception in CommunicationElement');
            }
            
            return communicationTypes; }
        }
    }
    
    public class CommunicationType {
        private postenNoEconnectAboCrmCrmgetcustome.CommunicationType eConnectResponse { get; set; }
        
        public CommunicationType() { }
        
        public CommunicationType(postenNoEconnectAboCrmCrmgetcustome.CommunicationType eConnectResponse){
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        public String PhoneNumber { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.PhoneNumber; } }
        public String MobileNumber { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.MobileNumber; } } 
        
        public String EMailAddress { get{
            if(eConnectResponse == null || String.isBlank(eConnectResponse.EMailAddress)) {return '-'; } 
            
            return KATSutilities.washEmailAddress(eConnectResponse.EMailAddress); }
            set{ EmailAddress = value; }
        }
        
    }
    
    public class AddressElement {
        private postenNoEconnectAboCrmCrmgetcustome.Addresses_element eConnectResponse { get; set; }
        
        public AddressElement(){}
        
        public AddressElement(postenNoEconnectAboCrmCrmgetcustome.Addresses_element eConnectResponse){
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        public AddressType[] addressTypes { set; get{ 
            addressTypes = new List<AddressType>();
            try {
                if(eConnectResponse.Address != null) {
                    for(postenNoEconnectAboCrmCrmgetcustome.AddressType address : eConnectResponse.Address) {
                        addressTypes.add(new AddressType(address));
                    }
                }
            } catch (Exception e) {
                system.debug('EConnectWrapper_GetCustomerData - Exception in AddressElement');
            }
            
            return addressTypes; }
        }
    }
    
    public class AddressType {
        private postenNoEconnectAboCrmCrmgetcustome.AddressType eConnectResponse { get; set; }
        
        public AddressType() { eConnectResponse = null; }
        
        public AddressType(postenNoEconnectAboCrmCrmgetcustome.AddressType eConnectResponse){
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        public String addressType { get {
            if(AddrTYPE != null) {
                if(AddrTYPE.equals('BillingAddress')) {
                    return System.Label.cs_BillingAddress;
                }
                if(AddrTYPE.equals('VisitAddress')) {
                    return System.Label.cs_VisitAddress;
                }
                if(AddrTYPE.equals('DeliveryAddress')) {
                    return System.Label.cs_DeliveryAddress;
                }
                if(AddrTYPE.equals('PostalAddress')) {
                    return System.Label.cs_PostalAddress;
                }
                /*if(AddrTYPE.equals('Caesar')) {
                    return 'Adresse i Caesar';
                }*/
                if(AddrTYPE.equals('XXAD_STORE')) {
                    return 'STORE??';
                }
            }
            return AddrTYPE;
            }
        }
        
        public String AddrTYPE { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.AddrTYPE; } }
        //public String Street { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.Street; } }
        public String BuildingNumber{ get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.BuildingNumber; } }
        public String BuildingName{ get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.BuildingName; } }
        public String StreetName{ get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.StreetName; } }
        public String PostOfficeBox{ get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.PostOfficeBox; } }
        public String PostalCode { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.PostalCode; } }
        public String CityName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.CityName; } }
       // public String MunicipalityName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.MunicipalityName; } }
       // public String MunicipalityCode { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.MunicipalityCode; } }
        public String Country { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.CountryCode; } }
        public String Unit { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.Unit; } }
        
    }
    
    /*public class DivisionElement {
        private postenNoEconnectAboCrmCrmgetcustome.Divisions_element eConnectResponse { get; set; }
        
        public DivisionElement(){ system.debug('EConnectWrapper_GetCustomerData - DivisionElement - noResponse'); eConnectResponse = null; }
        
        public DivisionElement(postenNoEconnectAboCrmCrmgetcustome.Divisions_Element eConnectResponse){
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        public DivisionType[] divisionTypes { set; get {
            divisionTypes = new List<DivisionType>();
            try {
                if(eConnectResponse != null || eConnectResponse.Division != null) {
                    for(postenNoEconnectAboCrmCrmgetcustome.KATS_SakDivisionType division : eConnectResponse.Division) {
                        divisionTypes.add(new DivisionType(division));
                    }
                }
                else {
                    divisionTypes.add(new DivisionType());
                }
            } catch (Exception e) {
                system.debug('Exception in DivisionElement');
            }
            return divisionTypes; }
        }
    }
    
    /*public class DivisionType {
        private postenNoEconnectAboCrmCrmgetcustome.KATS_SakDivisionType eConnectResponse { get; set; }
        
        public DivisionType() {  system.debug('EConnectWrapper_GetCustomerData - DivisionType - noResponse'); eConnectResponse = null;}
        
        public DivisionType(postenNoEconnectAboCrmCrmgetcustome.KATS_SakDivisionType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        //public String DivisionName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.DivisionName; } }
       // public String SegmentName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.SegmentName; } }
       // public String SubSegmentName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.SubSegmentName; } }
        public SalesPersonType SalesPerson { get{ if(eConnectResponse == null) { return new SalesPersonType(); } return new SalesPersonType(eConnectResponse.SalesPerson); } }
        public SalesPersonType OtherSalesPerson{ get { if(eConnectResponse == null) { return new SalesPersonType(); }return new SalesPersonType(eConnectResponse.OtherSalesPerson); } }
        
    }*/
    
  /* public class ContactsElement { CONTACT ELEMENT NOT PRESENT IN NEW WSDL FOR GET THEREFORE COMMENTING THE CLASS
        private postenNoEconnectAboCrmCrmgetcustome.ContactsComplexType eConnectResponse { get; set; }
        
        public ContactsElement() {  system.debug('EConnectWrapper_GetCustomerData - DivisionType - noResponse'); eConnectResponse = null; }
        
        public ContactsElement(postenNoEconnectAboCrmCrmgetcustome.ContactsComplexType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
         public ContactElement[] contactElements { set; get{ 
            contactElements = new List<ContactElement>();
            try {
                if(eConnectResponse != null || eConnectResponse.Contact != null) {
                    for(postenNoEconnectAboCrmCrmgetcustome.ContactComplexType contactElement : eConnectResponse.Contact) {
                        contactElements.add(new ContactElement(contactElement));
                    }
                } else {
                    contactElements.add(new ContactElement());
                }
            } catch (Exception e) {
                system.debug('EConnectWrapper_GetCustomerData - Exception in ContactsElement');
            }
            return contactElements; }
        }
    }*/
    
   /* public class ContactElement {
        private postenNoEconnectAboCrmCrmgetcustome.ContactComplexType eConnectResponse { get; set; }
        
        public ContactElement() { eConnectResponse = null; }
        
        public ContactElement(postenNoEconnectAboCrmCrmgetcustome.ContactComplexType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        public PersonNameType contactName { get{
            if(eConnectResponse.ContactName == null) {
                return new PersonNameType();
            }
            return new PersonNameType(eConnectResponse.ContactName); }
        }
        
        
        public String ContactID { get{if(eConnectResponse == null) {return ''; } return eConnectResponse.ContactID; } }
        public String Department { get{if(eConnectResponse == null) {return '-'; } return eConnectResponse.Department; } }
        public String Title { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.Title; } }
        
        public CommunicationType communicationType { set; get{ 
        //TODO: REVIEW THIS AFTER NEW WSDL STRUCTURE
            try {
                if(eConnectResponse != null || eConnectResponse.communication != null) {
                    CommunicationType = new CommunicationType(eConnectResponse.communication);
                } else {
                    CommunicationType = new CommunicationType();
                }
                
                
            } catch (Exception e) {
                system.debug('Exception in ContactElement');
            }
            return communicationType; }
        }
    }*/
    
        public class InvoiceElement {
        private postenNoEconnectAboCrmCrmgetcustome.Invoices_element eConnectResponse { get; set; }
        
        public InvoiceElement() {  system.debug('EConnectWrapper_GetCustomerData - InvoiceElement - noResponse'); eConnectResponse = null;  }
        
        public InvoiceElement(postenNoEconnectAboCrmCrmgetcustome.Invoices_element eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        public InvoiceType[] invoiceTypes { set; get{
            invoiceTypes = new List<InvoiceType>();
            
            try {
                if(eConnectResponse != null && eConnectResponse.invoice != null) {
                    for(postenNoEconnectAboCrmCrmgetcustome.InvoiceType invoice : eConnectResponse.invoice) {
                        invoiceTypes.add(new InvoiceType(invoice));
                    }
                }
                else {
                    invoiceTypes.add(new InvoiceType());
                }
            } catch (Exception e) {
                system.debug('EConnectWrapper_GetCustomerData - Exception in InvoiceElement');
            }
            
            return invoiceTypes; }
        }
    }
    
    public class InvoiceType {
        private postenNoEconnectAboCrmCrmgetcustome.InvoiceType eConnectResponse { get; set; }
        
        public InvoiceType() { system.debug('EConnectWrapper_GetCustomerData - InvoiceType - noResponse'); eConnectResponse = null; }
        
        public InvoiceType(postenNoEconnectAboCrmCrmgetcustome.InvoiceType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
         public String SourceSystem{ get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.SourceSystem; } }
        public String InvoiceNumber{ get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.InvoiceNumber; } }
        public String InvoiceType { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.InvoiceType; } }
        public Double Sum { get{ if(eConnectResponse == null) {return 0.0; } return eConnectResponse.Sum; } }
        public String OrderedByName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.OrderedByName; } }
        public String OrderedByNumber { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.OrderedByNumber; } }
        public String Status { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.InvoiceStatus; } }
        public String ItellaURI { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.ItellaURI; } }
        public String OEBSURI { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.OEBSURI; } }
        public String DocumentDateTime { get{ if(eConnectResponse == null) {return null; } return String.ValueOf(eConnectResponse.DocumentDateTime);}}
        public String TrxDueDateTime { get{ if(eConnectResponse == null) {return null; } return String.ValueOf(eConnectResponse.TrxDueDateTime);}}
        public String InvoiceId { get{ if(eConnectResponse == null) {return null; } return String.ValueOf(eConnectResponse.InvoiceId);}}
        public String sourceSys { get{ if(eConnectResponse == null) {return null; } return String.ValueOf(eConnectResponse.SourceSystem);}}
        public String UnitNumber { get{ if(eConnectResponse == null) {return null; }if(eConnectResponse.OperatingUnit == null ){return null; }  return String.ValueOf(eConnectResponse.OperatingUnit.UnitNumber);}}
        public String UnitName { get{ if(eConnectResponse == null ) {return null; } if(eConnectResponse.OperatingUnit == null ){return null; }  return String.ValueOf(eConnectResponse.OperatingUnit.UnitName);}}
        public String OrganizationNumber { get{ if(eConnectResponse == null) {return null; } if(eConnectResponse.OperatingUnit == null ){return null; }  return String.ValueOf(eConnectResponse.OperatingUnit.OrganizationNumber);}}
        public String ExternalReference { get{ if(eConnectResponse == null ) {return null; } if(eConnectResponse.OperatingUnit == null ){return null; } return String.ValueOf(eConnectResponse.OperatingUnit.ExternalReference);}}
    }
    
    public class OrderElement {
        private postenNoEconnectAboCrmCrmgetcustome.Orders_element eConnectResponse { get; set; }
        
        public OrderElement() { system.debug('EConnectWrapper_GetCustomerData - OrderElement - noResponse'); eConnectResponse = null; }
        
        public OrderElement(postenNoEconnectAboCrmCrmgetcustome.Orders_element eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        public OrderType[] orderTypes { set; get{
            orderTypes = new List<OrderType>();
            
            try {
                if(eConnectResponse != null && eConnectResponse.order != null) {
                    for(postenNoEconnectAboCrmCrmgetcustome.OrderType order : eConnectResponse.order) {
                        orderTypes.add(new OrderType(order));
                    }
                } 
                else {
                    orderTypes.add(new OrderType());
                }
            } catch (Exception e) {
                system.debug('EConnectWrapper_GetCustomerData - Exception in OrderElement');
            }
            
            return orderTypes; }
        }
    }
    
    public class OrderType {
        private postenNoEconnectAboCrmCrmgetcustome.OrderType eConnectResponse { get; set; }
        
        public OrderType() { system.debug('EConnectWrapper_GetCustomerData - OrderElement - noResponse'); eConnectResponse = null; }
        
        public OrderType(postenNoEconnectAboCrmCrmgetcustome.OrderType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        //added as part of C-07176
        public String SourceSystem{ get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.SourceSystem; } }
        public String OrderNumber{ get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.OrderNumber; } }
        public String OrderType{ get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.OrderType; } }
        public Double Sum { get{ if(eConnectResponse == null) {return 0.0; } return eConnectResponse.Sum; } }
        public String OrderedByName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.OrderedByName; } }
        public String OrderedByNumber { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.OrderedByNumber; } }
        public String OrderStatus{ get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.OrderStatus; } }
        public String OEBSURI { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.OEBSURI; } }
        public String sourceSys { get{ if(eConnectResponse == null) {return null; } return String.ValueOf(eConnectResponse.SourceSystem);}}
    }
    
    public class ForwardingElement {
        private postenNoEconnectAboCrmCrmgetcustome.Forwardings_element eConnectResponse { get; set; }
        
        public ForwardingElement(){ }
        
        public ForwardingElement(postenNoEconnectAboCrmCrmgetcustome.Forwardings_element eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        public ForwardingType[] forwardingTypes { set; get{
            forwardingTypes = new List<ForwardingType>();
            
            try {
                if(eConnectResponse != null && eConnectResponse.forwarding != null) {
                    for(postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwarding : eConnectResponse.forwarding) {
                        forwardingTypes.add(new ForwardingType(forwarding));
                    }
                }
                /*else {
                    forwardingTypes.add(new ForwardingType());
                }*/
            } catch (Exception e) {
                system.debug('EConnectWrapper_GetCustomerData - Exception in ForwardingElement');
            }
            
            return forwardingTypes; }
        }
    }
    
    public class ForwardingType {
        private postenNoEconnectAboCrmCrmgetcustome.ForwardingType eConnectResponse { get; set; }
        
        public ForwardingType() { system.debug('EConnectWrapper_GetCustomerData - ForwardingType - noResponse'); eConnectResponse = null; }
        
        public ForwardingType(postenNoEconnectAboCrmCrmgetcustome.ForwardingType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug('EConnectWrapper_GetCustomerData - ForwardingType - ' + this.eConnectResponse);
        }
        
        public String Number_x { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.ForwardingNumber; } }
        public String Status{get{if(eConnectResponse == null){return '-';} return ForwardingStatus(eConnectResponse.Status);}}
        public String ReferenceOMA { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.ReferenceOMA; } }
        public String Type_x { get{ if(eConnectResponse == null || eConnectResponse.Type_x == '') {return '-'; } 
            if(eConnectResponse.Type_x.toLowerCase() == 'hold') { return 'Oppbevaring'; }
            if(eConnectResponse.Type_x.toLowerCase() == 'permanent') { return 'Varig'; }
            if(eConnectResponse.Type_x.toLowerCase() == 'temporary') { return 'Midlertidig'; }
            return eConnectResponse.Type_x; } }
        public String Source { get{ if(eConnectResponse == null || eConnectResponse.Source == '') {return '-'; }
           
            return ForwardingSource(eConnectResponse.Source); } }
        public String OEBSURI { get{ if(eConnectResponse == null) {return ''; } return eConnectResponse.OEBSURI; } }
        public AddressType FromAddress { get{ if(eConnectResponse == null) { return new AddressType(); }return new AddressType(eConnectResponse.FromAddress); } }
        public AddressType ToAddress { get{ if(eConnectResponse == null) { return new AddressType(); }return  new AddressType(eConnectResponse.ToAddress); } }
        public Date StartDate { get{ if(eConnectResponse == null) {return null; } return eConnectResponse.StartDate; } }
        public Date EndDate { get{ if(eConnectResponse == null) {return null; } return eConnectResponse.EndDate; } }
        public Date HoldDate { get{ if(eConnectResponse == null) {return null; } return eConnectResponse.HoldDate; } }
        public OtherPartiesElement OtherParties { get{ if(eConnectResponse == null) { return new OtherPartiesElement(); } return new OtherPartiesElement(eConnectResponse.OtherParties); } }
        
        //Returns the raw type so embed_caseDetail can use it.
        public String forwardingType { get{ if(eConnectResponse == null || eConnectResponse.Type_x == '') {return '-'; } return eConnectResponse.Type_x.toLowerCase(); } }
    }
    
    public class OtherPartiesElement {
        private postenNoEconnectAboCrmCrmgetcustome.OtherParties_element eConnectResponse { get; set; }
        
         public OtherPartiesElement() { system.debug('EConnectWrapper_GetCustomerData - OtherPartiesElement - noResponse'); eConnectResponse = null; }
        
        public OtherPartiesElement(postenNoEconnectAboCrmCrmgetcustome.OtherParties_element eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        public PersonNameType[] Party { set; get{
            Party = new List<PersonNameType>();
            try {
                if(eConnectResponse != null && eConnectResponse.Party != null) {
                    for(postenNoEconnectAboCrmCrmgetcustome.PersonNameType personName : eConnectResponse.Party) {
                        Party.add(new PersonNameType(personName));
                    }
                } else {
                    Party.add(new PersonNameType());
                }
            } catch(Exception e) {
                system.debug('EConnectWrapper_GetCustomerData - Exception in OtherPartiesElement');
            }
            
            return Party; }
        }
    }
    
    public class SalesPersonType {
        private postenNoEconnectAboCrmCrmgetcustome.SalesPersonType eConnectResponse { get; set; }
       
       public SalesPersonType() { system.debug('EConnectWrapper_GetCustomerData - SalesPersonType - noResponse'); eConnectResponse = null; }
       
        public SalesPersonType(postenNoEconnectAboCrmCrmgetcustome.SalesPersonType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        public PersonNameType Name { get{
            if(eConnectResponse == null) { 
                return new PersonNameType(); 
            } 
            return new PersonNameType(eConnectResponse.SalesPersonName); }
        }
        
        public String PhoneNumber { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.SalesPersonPhoneNumber; } }
        public String Email { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.SalesPersonEmail; } }
    }
    
    public class PersonNameType {
        private postenNoEconnectAboCrmCrmgetcustome.PersonNameType eConnectResponse { get; set; }
        
        public PersonNameType() { system.debug('EConnectWrapper_GetCustomerData - PersonNameType - noResponse'); eConnectResponse = null; }
        
        public PersonNameType(postenNoEconnectAboCrmCrmgetcustome.PersonNameType eConnectResponse) {
            this.eConnectResponse = eConnectResponse;
            system.debug(this.eConnectResponse);
        }
        
        public String FirstName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.FirstName; } }
        public String MiddleName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.MiddleName; } }
        public String LastName { get{ if(eConnectResponse == null) {return '-'; } return eConnectResponse.LastName; } }
        
        public String FullName { get{ 
            String FullName = ''; 
            if(FirstName != null){FullName+=FirstName + ' ';}
            if(MiddleName != null){FullName+=MiddleName + ' ';}
            if(LastName != null){FullName+=LastName;}
            return FullName; } }
    }
    
    public static String PersonStatus(String StatusCode,String StatusValue)
    {
    if(StatusValue=='Gyldig' || StatusValue=='Valid')
        {
            System.debug('@@@inside@@@'+StatusValue);
             StatusValue=System.Label.cs_Valid;
             System.debug('@@@aftercheck@@@'+StatusValue);
         }
        else if(StatusValue=='Død' || StatusValue=='Dead')
             StatusValue=System.Label.cs_Dead;
        else if(StatusValue=='Konkurs' || StatusValue=='Bankrupt')
             StatusValue=System.Label.cs_Bankrupt;
        else if(StatusValue=='Duplikat' || StatusValue=='Duplicate')
             StatusValue=System.Label.cs_Duplicate;
        else if(StatusValue=='Forsvunnet' || StatusValue=='Disappeared')
             StatusValue=System.Label.cs_Disappeared; 
        else if(StatusValue=='Fusjonert' || StatusValue=='Merged')
             StatusValue=System.Label.cs_Merged;   
        else if(StatusValue=='Likvidert' || StatusValue=='Liquidated')
             StatusValue=System.Label.cs_Liquidated; 
        else   if(StatusValue=='Opphørt' || StatusValue=='Ceased to exist')
             StatusValue=System.Label.cs_Ceased_to_exist; 
        else   if(StatusValue=='Aktive' || StatusValue=='Active')
             StatusValue=System.Label.cs_Active;
        else  if(StatusValue=='Inaktive' || StatusValue=='Inactive')
             StatusValue=System.Label.cs_Inactive;  
             System.debug('@@@eConnectData.PersonParty@@end'+StatusValue);
         return StatusValue;
    }
    
     public Static String OrganizationStatus(String StatusCode,String StatusValue)
    {
        if(StatusCode!=null && StatusCode!='')
        {
            cs_BusinessCustomerStatus__c Status= cs_BusinessCustomerStatus__c.getValues(StatusCode);
            if(Status!=null)
                return Status.StatusValue__c;
            else
                return StatusValue;
        }
        else
            return null;
    }
    
    public Static String ForwardingStatus(String Status)
    {
        If(Status.tolowercase()=='expired')
            Status=System.label.cs_Expired;
        else if(Status.tolowercase()=='cancelled')
            Status=System.Label.cs_Cancelled;
        else if(Status.tolowercase()=='future')
            Status=System.label.cs_Future;
        else if(Status.tolowercase()=='effective')
            Status=System.label.cs_Effective;
        else if(Status.tolowercase()=='error')
            Status=System.label.cs_ErrorForwarding;
            
        return Status;
    }
    public Static String ForwardingSource(String Source)
    {
        If(Source.tolowercase()=='phone')
            return System.label.cs_phonef;
        If(Source.tolowercase()=='free')
            return System.label.cs_FREE;
        If(Source.toLowercase()=='form')
            return System.label.cs_Attendence;
        else
            return Source;
    }
}