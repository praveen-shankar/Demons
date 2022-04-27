/* 
Helper and utility methods for using the eConnect webservices
*/ 
public with sharing class postenNoEconnectUtilities {

    private static final String CLIENT_CERT_NAME;
    private static final String ECONNECT_ENDPOINT_URI;
    private static final String PRODUCTION_ORGNR = '00D20000000BwOIEA0';
    public boolean isProductionEconnectURIInSandbox() {
        return ECONNECT_ENDPOINT_URI.contains('https://econnect.postennorge.no')
            && !PRODUCTION_ORGNR.equals(UserInfo.getOrganizationId());
    }

   private postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerSOAP eConnectSearchCustomer {get; set; }
   
  // private postenNoEconnectServiceV1Searchpart.CRMSearchCustomerPartyPort eConnectSearchParty {get; set; } // Searches in FAR with search criterias
   private postenNoEconnectServiceV1Crmsearchc.CRMSearchCustomerPartyPort  eConnectSearchCustomerParty {get; set; } // Searches in AR,OM,FAR with party number as input
   //public postenNoEconnectServiceV1Crmsearchp.CRMSearchCustomerPartyPort eConnectSearchCustomerParty {get;set;}
     
    private postenNoEconnectServiceV1Crmgetcust eConnectGetCustomer {get; set; }
    
    private postenNoEconnectKatsSearchshipment.KATS_SearchShipmentSOAP eConnectSearchShipment {get; set; }
    private postenNoEconnect20087Katsordereventr.KATS_OrderEventRelease eConnectOrderEventRelease {get; set; }
    private postenNoEconnectT20077Katsshipmentev.KATS_ShipmentEventPort eConnectShipmentEventPort {get; set; }
    private postenNoEconnectKatsPaymentevents.KATS_PaymentEventsPort eConnectPaymentEventsPort {get; set; }
    private postenNoEconnectKatsGetshipment.KATS_GetShipmentSOAP eConnectGetShipment { get; set; }
    private postenNoT20056Katsdunningstopservice.T20056_KATSDunningStopServiceSOAP eConnectUpdateNote { get; set; }
 // Added by Akash
    private cs_postenNoEcServiceV1T50528Sen.SendCreditMemoBasisCRMPort eConnectPaymentInvoicePort {get; set; }
 // Added For Dispute
    recDisputeinvoicecrmToOebs.RecieveDisputeInvoicePortTypeSOAP11BindingQSPort  postenEconnectDisputeInvoice{get;set;}   
    private long timeForRequest;
    private long timeForReply;

    static {
        if(Organization_environment_settings__c.getInstance(UserInfo.getOrganizationId()) == null) {
            CLIENT_CERT_NAME = 'Sandbox';
            ECONNECT_ENDPOINT_URI = 'Sandbox';
            
            String message = 'Ingen tilgang til eConnect!\nIngen Custom Settings for denne sandboxen, anser dette som en Developer Sandbox.';
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        } else {
            CLIENT_CERT_NAME = Organization_environment_settings__c.getInstance(UserInfo.getOrganizationId()).eConnectCertificateName__c;
            ECONNECT_ENDPOINT_URI = Organization_environment_settings__c.getInstance(UserInfo.getOrganizationId()).eConnectEndpointURI__c;
        }
    }
    
    public postenNoEconnectUtilities() {}

    
    public String getCertificateName() {
        return CLIENT_CERT_NAME;
    }
    
    public String getEndpointURI() {
        return ECONNECT_ENDPOINT_URI;
    }

    private postenNoEconnectEc411gheader.TeC411gMessageHeader getSoapHeader(String serviceName) {
        postenNoEconnectEc411gheader.TeC411gMessageHeader header = new postenNoEconnectEc411gheader.TeC411gMessageHeader();
        header.MessageId = getUniqueMessageId();
        header.Action = 'Read'; //Must be a CRUD value (Create, Read, Update, Delete)
        header.Version= '1.0';
        header.SourceSystemTimestamp = System.now();
        header.SourceCompany = '000002 Posten Norge AS';
        header.SourceSystem = 'KATS';
        header.SourceSystemRef = header.MessageId;
        header.SourceSystemUser = KATSutilities.getFullUser(Userinfo.getUserId()).ldap_username__c; //'KRABBES';//Userinfo.getUserName();
        
        if(serviceName == 'getCustomer') {
            header.MessageType = 'T20095_KATSGetCustomer';
        }
        else if(serviceName == 'searchCustomer') {
            header.MessageType = 'T20099_KATSSearchCustomer';   
        }
        else if(serviceName == 'orderEventRelease') {
            header.MessageType = 'T20087_KATSOrderEventRelease';
        }
        else if(serviceName == 'shipmentEvent') {
            header.MessageType = 'T20065_KATSShipmentEventRequest';   
        }
        else if(serviceName == 'sendPayment') {
            header.MessageType = 'T20066_KATSPaymentEvents';   
        }
        else if(serviceName == 'searchShipment') {
            header.MessageType = 'T20081_KATSSearchShipment';   
        }
        else if(serviceName == 'getShipment') {
            header.MessageType = 'T20070_KATSGetShipmentUnit';
        }
        else if(serviceName == 'updateNote') {
            header.MessageType = 'T20056_KATSDunningStopService';
        }

        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'eConnect messageID: ' + header.SourceSystemRef + ' (' + header.MessageType + ')' ));

        return header;
    }
    
    
    public String shipmentEvent(String ShipmentUnitID,String CaseDescription,String UserName,String UsersFullName,String UnitNumber,String PostalCode,String UsersUnitNumber,String EventCode,String ReasonCode,String ActionCode,String RecipientSignature) {
        if(eConnectShipmentEventPort == null) {
            eConnectShipmentEventPort = new postenNoEconnectT20077Katsshipmentev.KATS_ShipmentEventPort();
            eConnectShipmentEventPort.clientCertName_x = CLIENT_CERT_NAME;
            eConnectShipmentEventPort.timeout_x = 35000;
            eConnectShipmentEventPort.endpoint_x = updateHostnameInURI(ECONNECT_ENDPOINT_URI, eConnectShipmentEventPort.endpoint_x);
        }
        eConnectShipmentEventPort.eC4Header = getSoapHeader('shipmentEvent');
        
        system.debug('Calling orderEventRelease on: ' + eConnectShipmentEventPort );
        
        if(test.isRunningTest()) { return eConnectShipmentEventPortStub(this); }      
        return eConnectShipmentEventPort.ShipmentEvent(ShipmentUnitID,CaseDescription,UserName,UsersFullName,UnitNumber,PostalCode,UsersUnitNumber,EventCode,ReasonCode,ActionCode,RecipientSignature);
    }
    
    /*
    *   Release orders (on deviation Cases) that originate from OEBS
    *
    */
    public String orderEventRelease(String OrderLineID,String LogInfo,String KATSUserName,String KATSCaseNumber) {
        //return 'OK';
        if(eConnectOrderEventRelease == null) {
            eConnectOrderEventRelease = new postenNoEconnect20087Katsordereventr.KATS_OrderEventRelease();
            eConnectOrderEventRelease.clientCertName_x = CLIENT_CERT_NAME;
            eConnectOrderEventRelease.timeout_x = 20000;
            eConnectOrderEventRelease.endpoint_x = updateHostnameInURI(ECONNECT_ENDPOINT_URI, eConnectOrderEventRelease.endpoint_x);
        }
        eConnectOrderEventRelease.eC4Header = getSoapHeader('orderEventRelease');
            
        return eConnectOrderEventRelease.OrderEventRelease(OrderLineID,LogInfo,KATSUserName,KATSCaseNumber);
    }
        
        //CR 7176 - CDHCustomerNumber param added in method signature - 10th March 2018
        public postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType getCustomer(String partyNumber,String CDHCustomerNumber,String[] InformationType) {
        startTimer();
        postenNoEconnectServiceV1Crmgetcust.CRMGetCustomerPartyPort customerPort=new postenNoEconnectServiceV1Crmgetcust.CRMGetCustomerPartyPort();
        if(eConnectGetCustomer == null) {
            eConnectGetCustomer = new postenNoEconnectServiceV1Crmgetcust();
            customerPort.clientCertName_x = CLIENT_CERT_NAME;
            customerPort.timeout_x = 50000;
            
           customerPort.endpoint_x=updateHostnameInURI(ECONNECT_ENDPOINT_URI, customerPort.endpoint_x);
         System.debug ('@@@@endpoint_x'+ customerPort.endpoint_x);
        }
        else
        {
            customerPort.clientCertName_x = CLIENT_CERT_NAME;
            customerPort.timeout_x = 50000;
            customerPort.endpoint_x=updateHostnameInURI(ECONNECT_ENDPOINT_URI, customerPort.endpoint_x);
        }
        postenNoEconnectCommonHeaderV1.HeaderType  headerValues=new postenNoEconnectCommonHeaderV1.HeaderType();
        headerValues.MessageId=UserInfo.GetUserId()+String.valueof(System.now());
        headerValues.ServiceName='T50588_CRMGetCustomerParty';
        headerValues.MessageType='REQUEST';
        headerValues.MessageMode='GetCustomerParty';
        headerValues.FirstProcessedTimestamp=System.now();
        headerValues.ProcessedTimestamp=System.now();
        headerValues.SourceSystemTimestamp=System.now();
        headerValues.TargetSystemTimestamp=String.valueof(System.now());
        headerValues.SecurityToken='';
        headerValues.SourceCompany='POS';
        headerValues.SourceSystem='KATS';
        headerValues.SourceSystemUser='';
        headerValues.SourceSystemRef='';
        headerValues.OperationName='GetCustomerParty';
        headerValues.IntergationURI='T50588_CRMGetCustomerParty/Proxy-Services/T50588_CRMGetCustomerParty_PS';
        headerValues.ResubmissionPoint='Proxy-Service';
        customerPort.SOAP_HeaderPart=headervalues;
        system.debug('Calling getCustomer on: ' + eConnectGetCustomer );
        
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType reply;
        
        if(CLIENT_CERT_NAME.equals('Sandbox')) {
           reply = mock_Crmgetcustome.getBusinessAccount();
        } else {
            //String [] InformationType=new String[]{'InvoiceDetails','OrderDetails','ForwardingDetails','CustomerDetails'};
            //reply = customerPort.GetCustomerParty(partyNumber,InformationType);
            reply = customerPort.GetCustomerParty(partyNumber,CDHCustomerNumber,InformationType);//10th March 2018 - CR 7176
            /*if(reply.ServiceException!=null && reply.ServiceException.Error.Size()>0)
            {
                
                throw new CalloutException();
             }*/
        }
        
        stopTimer();
        return reply;
    }
   //Customer Service Phase 2-Akshata 22 Dec
    public List<postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType> SearchPartyCRM(Map<String,String> searchCustomerParams)
    {
    
        postenNoEconnectAboCrmCrmsearchcust.Order_element order=new postenNoEconnectAboCrmCrmsearchcust.Order_element ();
        order.OrderNumber=searchCustomerParams.get('order_number');
        postenNoEconnectAboCrmCrmsearchcust.OUType OperatingUnit1=new postenNoEconnectAboCrmCrmsearchcust.OUType();
        OperatingUnit1.UnitName='';
        OperatingUnit1.UnitNumber='';
        OperatingUnit1.OrganizationNumber='';
        OperatingUnit1.ExternalReference='';
        postenNoEconnectAboCrmCrmsearchcust.InvoiceType invoice=new postenNoEconnectAboCrmCrmsearchcust.InvoiceType();
        invoice.OperatingUnit=OperatingUnit1;
        invoice.InvoiceNumber=searchCustomerParams.get('receivable_number');
        postenNoEconnectAboCrmCrmsearchcust.Forwarding_element  forwarding=new postenNoEconnectAboCrmCrmsearchcust.Forwarding_element();
        forwarding.ForwardingNumber=searchCustomerParams.get('forwardingnumber');
        eConnectSearchCustomerParty=new postenNoEconnectServiceV1Crmsearchc.CRMSearchCustomerPartyPort();
        postenNoEconnectAboCrmCrmsearchcust.CRMSearchCustomerPartyResponseType responselist=new postenNoEconnectAboCrmCrmsearchcust.CRMSearchCustomerPartyResponseType ();
        
       eConnectSearchCustomerParty.endpoint_x =updateHostnameInURI(ECONNECT_ENDPOINT_URI,   eConnectSearchCustomerParty.endpoint_x);
        //eConnectSearchCustomerParty.endpoint_x='http://requestb.in/13b1zwt1';
        if(!test.isrunningtest())
        responselist=eConnectSearchCustomerParty.SearchCustomerParty(order,invoice,forwarding);
        else
        {
        List<postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType> partylist=new List<postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType>();
        responselist.CustomerPartyList=partylist;
        }
        return responselist.CustomerPartyList;
        
    
    }
    //Customer Service Phase 2-Akshata 22 Dec
    postenNoEconnectServiceV1Crmsearchp.SearchPartyFARPort econnectSearchpartyFAR;
    
    public postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType  searchCustomerFAR(Map<String,String> searchCustomerParams)
    {
     postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType reply=new postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType();    
    if(isProductionEconnectURIInSandbox()) {
            String errorMessage = 'Not permitted to call eConnect in production from outside KATS production. Please ensure the custom setting eConnectEndpointURI is correct. ';
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_PostenError1+ System.Label.cs_PostenError2));
            return null;
        }
     if(econnectSearchpartyFAR== null) {
           econnectSearchpartyFAR= new postenNoEconnectServiceV1Crmsearchp.SearchPartyFARPort();
           econnectSearchpartyFAR.clientCertName_x = CLIENT_CERT_NAME;
           econnectSearchpartyFAR.timeout_x = 50000;
           econnectSearchpartyFAR.endpoint_x= updateHostnameInURI(ECONNECT_ENDPOINT_URI, econnectSearchpartyFAR.endpoint_x);
        }
        else
        {
           econnectSearchpartyFAR.clientCertName_x = CLIENT_CERT_NAME;
           econnectSearchpartyFAR.timeout_x = 50000;
           econnectSearchpartyFAR.endpoint_x= updateHostnameInURI(ECONNECT_ENDPOINT_URI, econnectSearchpartyFAR.endpoint_x);
        }
       
    postenNoEconnectCommonHeaderV1.HeaderType header=new  postenNoEconnectCommonHeaderV1.HeaderType();
    header.MessageId='SFDC'+Userinfo.getUserid()+System.now();
    header.ServiceName='T50506_SearchPartyFAR_PS';
    header.MessageType='SearchParty';
    header.MessageMode='REQUEST';
    header.FirstProcessedTimestamp=System.now();
    header.ProcessedTimestamp=System.now();
    header.SourceSystemTimestamp=System.now();
    header.TargetSystemTimestamp=String.valueof(System.now());
    header.SourceCompany='POS';
    header.SourceSystem='KATS';
    header.SourceSystemUser=UserInfo.getUserId();
    header.OperationName='SearchParty';
    header.IntergationURI='T50506_SearchPartyFAR/ProxyServices/T50506_SearchPartyFAR_PS';
    header.ResubmissionPoint='PROXY';
    
    econnectSearchpartyFAR.SOAP_HeaderPart=header;
        
     String partynumber =  searchCustomerParams.get('party_number');
     String PartyName = searchCustomerParams.get('org_name');
    
     String PartyType  = searchCustomerParams.get('party_type');
     System.debug('@@@@PartyType  @@@@'+PartyType  );
     String PersonFirstName = searchCustomerParams.get('person_first_name');
     String PersonLastName = searchCustomerParams.get('person_last_name');
     String OrganizationNumber = searchCustomerParams.get('org_fiscal_reference');
    String NationalIdentificationNumber = searchCustomerParams.get('person_national_identification_number');
    String StreetName = searchCustomerParams.get('address_street_name');
    String BuildingNumberOrPOBox =searchCustomerParams.get('address_house_number');
    String BuildingLetter = searchCustomerParams.get('address_house_letter');
    String CityName = searchCustomerParams.get('address_city');
    String PostalCode  = searchCustomerParams.get('address_postal_code');
    String MunicipalityCode  = searchCustomerParams.get('address_municipality_code');
    String MunicipalityName  = searchCustomerParams.get('address_municipality_name');
    Long beforecall=(System.now()).gettime();
    startTimer();
    //reply=econnectSearchpartyFAR.SearchParty(partynumber,PartyName,PartyType,PersonFirstName,PersonLastName,OrganizationNumber,NationalIdentificationNumber,StreetName,BuildingNumberOrPOBox,BuildingLetter,CityName,PostalCode,MunicipalityCode,MunicipalityName);
    if(CLIENT_CERT_NAME.equals('Sandbox')) {
            if(PartyType == 'Person') {
                reply = mock_KatsSaksearchcustomer.getPrivateSearch();
            } else {
                reply = mock_KatsSaksearchcustomer.getBusinessSearch();
            }
        } else {
            reply =  reply=econnectSearchpartyFAR.SearchParty(partynumber,PartyName,PartyType,PersonFirstName,PersonLastName,OrganizationNumber,NationalIdentificationNumber,StreetName,BuildingNumberOrPOBox,BuildingLetter,CityName,PostalCode,MunicipalityCode,MunicipalityName);
        }
    
    Stoptimer();
    Long received=(System.now()).gettime();
    long timetaken=received-beforecall;
    System.debug('@@@time taked by econnect@@'+timetaken);
    return reply;
    }
    
    
    
  /*  public postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters getCustomer(String partyNumber) {
        startTimer();
        
        if(eConnectGetCustomer == null) {
            eConnectGetCustomer = new postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerSOAP();
            eConnectGetCustomer.clientCertName_x = CLIENT_CERT_NAME;
            eConnectGetCustomer.timeout_x = 20000;
            eConnectGetCustomer.endpoint_x = updateHostnameInURI(ECONNECT_ENDPOINT_URI, eConnectGetCustomer.endpoint_x);
        }
        
        // TODO UPDATE HEADER
        eConnectGetCustomer.SoapHeader = getSoapHeader('getCustomer');
        
        system.debug('Calling getCustomer on: ' + eConnectGetCustomer );
        
        postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters reply;
        
        if(CLIENT_CERT_NAME.equals('Sandbox')) {
            reply = mock_KatsSakgetcustomer.getBusinessAccount();
        } else {
            reply = eConnectGetCustomer.GetCustomer(partyNumber);
        }
        
        stopTimer();
        return reply;
    }
     */
     
   // REFRACTOR AND SPLIT  
 /*public postenNoEconnectAboCustomerpartyV1S1.SearchPartyFARResponseType searchCustomer(map<string, string> searchCustomerParams) {
      postenNoEconnectAboCustomerpartyV1S1.SearchPartyFARResponseType reply;
    
    if(isProductionEconnectURIInSandbox()) {
            String errorMessage = 'Not permitted to call eConnect in production from outside KATS production. Please ensure the custom setting eConnectEndpointURI is correct. ';
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage + System.Label.cs_PostenError2));
            return null;
        }
     if(eConnectSearchParty == null) {
            eConnectSearchParty = new postenNoEconnectServiceV1Searchpart.CRMSearchCustomerPartyPort();
            eConnectSearchParty.clientCertName_x = CLIENT_CERT_NAME;
            eConnectSearchParty.timeout_x = 20000;
            eConnectSearchParty.endpoint_x = updateHostnameInURI(ECONNECT_ENDPOINT_URI, eConnectSearchParty.endpoint_x);
        }
       
        postenNoEconnectCommonHeaderV1.HeaderType headers = new postenNoEconnectCommonHeaderV1.HeaderType();
        
        
        //Setting headers required by eConnect
        headers.MessageId = getUniqueMessageId();
        headers.SourceSystemRef =  UserInfo.getOrganizationId();
        headers.SourceSystemUser = UserInfo.getUserId();
        headers.MessageType = ''; // TBD   
        headers.ServiceName = ''; // TBD
        headers.MessageType = ''; //
        headers.OperationName = 'SearchParty'; // TBD
        headers.IntergationURI = ''; // TBD
        headers.ResubmissionPoint = 'PROXY';
        headers.FirstProcessedTimestamp = System.now();
        headers.ProcessedTimestamp = System.now();
        headers.SourceSystemTimestamp = System.now();
        headers.MessageMode = 'REQUEST';
        headers.SourceSystem = 'CRM';
        headers.SourceCompany = 'POS';
        eConnectSearchParty.SOAP_HeaderPart = headers;       
        
        // Construct search criteria
     /*postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PartyNumber_element PartyNumber = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PartyNumber_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PartyName_element PartyName = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PartyName_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PartyType_element PartyType = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PartyType_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PersonFirstName_element PersonFirstName = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PersonFirstName_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PersonLastName_element PersonLastName = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PersonLastName_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_OrganizationNumber_element OrganizationNumber = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_OrganizationNumber_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_NationalIdentificationNumber_element NationalIdentificationNumber = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_NationalIdentificationNumber_element ();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_StreetName_element StreetName = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_StreetName_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_BuildingNumberOrPOBox_element BuildingNumberOrPOBox = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_BuildingNumberOrPOBox_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_BuildingLetter_element BuildingLetter = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_BuildingLetter_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_CityName_element CityName = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_CityName_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PostalCode_element PostalCode = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_PostalCode_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_MunicipalityCode_element MunicipalityCode = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_MunicipalityCode_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_MunicipalityName_element MunicipalityName = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType_MunicipalityName_element();
      postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType req = new postenNoEconnectAboCustomerpartyV1S.SearchPartyFARRequestType();
    
     String partynumber =  searchCustomerParams.get('party_number');
     String PartyName = searchCustomerParams.get('person_full_name');
     String PartyType  = searchCustomerParams.get('party_type');
     String PersonFirstName = searchCustomerParams.get('person_first_name');
     String PersonLastName = searchCustomerParams.get('person_last_name');
     String OrganizationNumber = searchCustomerParams.get('org_fiscal_reference');
     String NationalIdentificationNumber = searchCustomerParams.get('person_national_identification_number');
    String StreetName = searchCustomerParams.get('address_street_name');
    String BuildingNumberOrPOBox =searchCustomerParams.get('address_house_number');
    String BuildingLetter = searchCustomerParams.get('address_house_letter');
    String CityName = searchCustomerParams.get('address_city');
    String PostalCode  = searchCustomerParams.get('address_postal_code');
    String MunicipalityCode  = searchCustomerParams.get('address_municipality_code');
    String MunicipalityName  = searchCustomerParams.get('address_municipality_name');
   reply = eConnectSearchParty.SearchParty(partynumber, PartyName, PartyType, PersonFirstName, PersonLastName, OrganizationNumber, NationalIdentificationNumber, StreetName, BuildingNumberOrPOBox, BuildingLetter, CityName, PostalCode, MunicipalityCode, MunicipalityName);
   
   return reply;
   }
   */
   /* public postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerOutParameters searchCustomer(string maxNumberOfResults, map<string, string> searchCustomerParams) {
        postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerOutParameters reply;
        if(isProductionEconnectURIInSandbox()) {
            String errorMessage = 'Not permitted to call eConnect in production from outside KATS production. Please ensure the custom setting eConnectEndpointURI is correct. ';
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_PostenError1 + System.Label.cs_PostenError2));
            return null;
        }

        if(eConnectSearchCustomer == null) {
            eConnectSearchCustomer = new postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerSOAP();
            eConnectSearchCustomer.clientCertName_x = CLIENT_CERT_NAME;
            eConnectSearchCustomer.timeout_x = 20000;
            eConnectSearchCustomer.endpoint_x = updateHostnameInURI(ECONNECT_ENDPOINT_URI, eConnectSearchCustomer.endpoint_x);
        }
        eConnectSearchCustomer.SoapHeader = getSoapHeader('searchCustomer');
        
        postenNoEconnectKatsSaksearchcustome.Party_element party = new postenNoEconnectKatsSaksearchcustome.Party_element();
      
        party.PartyType                                 = searchCustomerParams.get('party_type');
        party.PartyNumber                               = searchCustomerParams.get('party_number');
        party.AccountNumber                             = searchCustomerParams.get('account_number');
       
       if( searchCustomerParams.containsKey('person_national_identification_number') || searchCustomerParams.containsKey('person_first_name') || searchCustomerParams.containsKey('person_middle_name') || searchCustomerParams.containsKey('person_last_name') ) {
            party.Person = new postenNoEconnectKatsSaksearchcustome.Person_element();
            party.Person.NationalIdentificationNumber   = searchCustomerParams.get('person_national_identification_number');
            party.Person.PersonFirstName                = searchCustomerParams.get('person_first_name');
            party.Person.PersonMiddleName               = searchCustomerParams.get('person_middle_name');
            party.Person.PersonLastName                 = searchCustomerParams.get('person_last_name');
            system.debug('Search: we have person_element: ' + party.Person);
       }
      
       if( searchCustomerParams.containsKey('org_name') || searchCustomerParams.containsKey('org_fiscal_reference') ){ //|| searchCustomerParams.containsKey('org_contactFirstName') || searchCustomerParams.containsKey('org_contactLastName') ) {
            party.Organization = new postenNoEconnectKatsSaksearchcustome.Organization_element();  
            party.Organization.OrganizationName         = searchCustomerParams.get('org_name');
            party.Organization.FiscalReference          = searchCustomerParams.get('org_fiscal_reference');
          // No contact backend search
          //  party.Organization.ContactFirstName         = searchCustomerParams.get('org_contactFirstName');
          //  party.Organization.ContactLastName          = searchCustomerParams.get('org_contactLastName');
            system.debug('Search: we have Organization_element: ' + party.Organization );
       }
       if( searchCustomerParams.containsKey('address_house_number') || searchCustomerParams.containsKey('address_postal_code') || searchCustomerParams.containsKey('address_city') || 
            searchCustomerParams.containsKey('address_municipality_code') || searchCustomerParams.containsKey('address_municipality_name') || searchCustomerParams.containsKey('address_po_box_number') || 
            searchCustomerParams.containsKey('address_street_name') || searchCustomerParams.containsKey('address_house_letter') ) {
                
            party.RequestAddress = new postenNoEconnectKatsSaksearchcustome.RequestAddress_element();
            party.RequestAddress.HouseNumber                = searchCustomerParams.get('address_house_number');
            party.RequestAddress.PostalCode                 = searchCustomerParams.get('address_postal_code');
            party.RequestAddress.City                       = searchCustomerParams.get('address_city');
            party.RequestAddress.MunicipalityCode           = searchCustomerParams.get('address_municipality_code');
            party.RequestAddress.MunicipalityName           = searchCustomerParams.get('address_municipality_name');
            party.RequestAddress.POBoxNumber                = searchCustomerParams.get('address_po_box_number');
            party.RequestAddress.StreetName                 = searchCustomerParams.get('address_street_name');
            party.RequestAddress.HouseLetter                = searchCustomerParams.get('address_house_letter');
            system.debug('Search: we have RequestAddress: ' + party.RequestAddress );
       }
       if( searchCustomerParams.containsKey('phone') || searchCustomerParams.containsKey('email') ) {
            party.Communications = new postenNoEconnectKatsSaksearchcustome.Communications_element();  
            party.Communications.PhoneNumber            = searchCustomerParams.get('phone');
            party.Communications.EMailAddress           = searchCustomerParams.get('email');
            system.debug('Search: we have Communications_element: ' + party.Communications );
       }
       if( searchCustomerParams.containsKey('order_number') ) {
            party.Order = new postenNoEconnectKatsSaksearchcustome.Order_element();  
            party.Order.OrderNumber                     = searchCustomerParams.get('order_number');
            system.debug('Search: we have Order_element: ' + party.Order );
       }
       if( searchCustomerParams.containsKey('receivable_number') ) {
            party.Receivable = new postenNoEconnectKatsSaksearchcustome.Receivable_element();  
            party.Receivable.ReceivableNumber           = searchCustomerParams.get('receivable_number');
            system.debug('Search: we have Receivable_element: ' + party.Receivable );
       }
       if( searchCustomerParams.containsKey('forwardingnumber') ) {
            party.Forwarding = new postenNoEconnectKatsSaksearchcustome.Forwarding_element();  
            party.Forwarding.ForwardingNumber           = searchCustomerParams.get('forwardingnumber');
            system.debug('Search: we have Forwarding_element: ' + party.Forwarding );
       }

        system.debug('Search: searchCustomer called with params: ' + party);

        system.debug('Calling searchCustomer on: ' + eConnectSearchCustomer );

        startTimer();
        if(CLIENT_CERT_NAME.equals('Sandbox')) {
            if(party.PartyType == 'Person') {
               // reply = mock_KatsSaksearchcustomer.getPrivateSearch();
            } else {
                //reply = mock_KatsSaksearchcustomer.getBusinessSearch();
            }
        } else {
            reply = eConnectSearchCustomer.SearchCustomer(maxNumberOfResults, party);
        }
        stopTimer();
        
        postenNoEconnectSortingUtilities sortingUtil;
        if(searchCustomerParams.get('selectedRevenueArea') == postenNoEconnectSortingUtilities.REVENUE.POST.name()) {
            sortingUtil = new postenNoEconnectSortingUtilities(postenNoEconnectSortingUtilities.REVENUE.POST);
        } else if (searchCustomerParams.get('selectedRevenueArea') == postenNoEconnectSortingUtilities.REVENUE.LOGISTIKK.name()) {
            sortingUtil = new postenNoEconnectSortingUtilities(postenNoEconnectSortingUtilities.REVENUE.LOGISTIKK);
        } else {
            sortingUtil = new postenNoEconnectSortingUtilities(postenNoEconnectSortingUtilities.REVENUE.POST_AND_LOGISTIKK);
        }
        
        //Wish to view these clients afterall. Commented out on request from Erik Aune oct 25th 2012
        //r.CustomerList.Customer = removeUnwantedResults(r.CustomerList.Customer);
        reply.CustomerList.Customer = sortingUtil.sort(reply.CustomerList.Customer);
        
        return reply;
    }*/
    
    public List<postenNoEconnectKatsSaksearchcustome.Customer_element> 
        removeUnwantedResults(List<postenNoEconnectKatsSaksearchcustome.Customer_element> customers) {
            postenNoEconnectKatsSaksearchcustome.Customer_element customer;
            List<postenNoEconnectKatsSaksearchcustome.Customer_element> wantedCustomers = new List<postenNoEconnectKatsSaksearchcustome.Customer_element>();
            if (customers != null) {
            for(Integer i = 0; i < customers.size(); i++) {
                customer = customers.get(i);
                if(
                    !(customerInactive(customer) == 1
                    && Integer.valueOf(customer.Revenues.TotalRevenueCurrentYear_L) == 0
                    && Integer.valueOf(customer.Revenues.TotalRevenuePreviousYear_L) == 0
                    && Integer.valueOf(customer.Revenues.TotalRevenueCurrentYear_P) == 0
                    && Integer.valueOf(customer.Revenues.TotalRevenuePreviousYear_P) == 0)
                ) 
                {
                    // Salesforce List has no remove(Object) and we do not want to manipulate the list we are iterating
                    wantedCustomers.add(customer);
                }
            }
            }
            return wantedCustomers;
        }
    
     public postenNoEconnectKatsGetshipment.ShipmentUnitType getShipment(String ShipmentUnitID) {
        //return mock_KatsGetshipment.getShipment().ShipmentUnit;
        if(eConnectGetShipment == null) {
            eConnectGetShipment = new postenNoEconnectKatsGetshipment.KATS_GetShipmentSOAP();
            eConnectGetShipment.clientCertName_x = CLIENT_CERT_NAME;
            eConnectGetShipment.timeout_x = 20000;
            eConnectGetShipment.endpoint_x = updateHostnameInURI(ECONNECT_ENDPOINT_URI, eConnectGetShipment.endpoint_x);
        }
        eConnectGetShipment.eC4Header = getSoapHeader('getShipment');
        
        system.debug('Calling getShipment on: ' + eConnectGetShipment );
        
        postenNoEconnectKatsGetshipment.ShipmentUnitType reply;
        
        startTimer();
        if(CLIENT_CERT_NAME.equals('Sandbox')) {
            reply = eConnectgetShipmentStub(this);
        } else {
            reply = eConnectGetShipment.GetShipment(ShipmentUnitID);
        }
        stopTimer();
        return reply;
        
    }
     
    public postenNoEconnectKatsSearchshipment.TShipmentUnit[] searchShipment(string maxNumberOfResults, map<string, string> searchShipmentParams) {
        if(isProductionEconnectURIInSandbox()) {
            String errorMessage = 'Not permitted to call eConnect in production from outside KATS production. Please ensure the custom setting eConnectEndpointURI is correct. ';
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_PostenError1+ System.Label.cs_PostenError2));
            return null;
        }

        if(eConnectSearchShipment == null) {
            eConnectSearchShipment = new postenNoEconnectKatsSearchshipment.KATS_SearchShipmentSOAP();
            eConnectSearchShipment.clientCertName_x = CLIENT_CERT_NAME;
            eConnectSearchShipment.timeout_x = 20000;
            eConnectSearchShipment.endpoint_x = updateHostnameInURI(ECONNECT_ENDPOINT_URI, eConnectSearchShipment.endpoint_x);
        }
        eConnectSearchShipment.eC4Header = getSoapHeader('searchShipment');
        
        String ShipmentID               = searchShipmentParams.get('ShipmentID');
        String ShipmentUnitID           = searchShipmentParams.get('ShipmentUnitID');
        Date ShipmentDateTimeFrom       = (searchShipmentParams.containsKey('ShipmentDateTimeFrom')) ? Date.parse(searchShipmentParams.get('ShipmentDateTimeFrom')) : null;        
        Date ShipmentDateTimeTo         = (searchShipmentParams.containsKey('ShipmentDateTimeTo')) ? Date.parse(searchShipmentParams.get('ShipmentDateTimeTo')) : null;        
        String SendersReferenceNumber   = searchShipmentParams.get('SendersReferenceNumber');
        String PartyNumber              = searchShipmentParams.get('PartyNumber');
        String PartyName                = searchShipmentParams.get('PartyName');
        String Product                  = searchShipmentParams.get('Product');
        String City                     = searchShipmentParams.get('City');
        String ShipToPostalCodeFrom         = searchShipmentParams.get('ShipToPostalCodeFrom');
        String ShipToPostalCodeTo   = searchShipmentParams.get('ShipToPostalCodeTo');
        String ShipToCountryCode    = searchShipmentParams.get('ShipToCountryCode');
        Decimal LoadingWeightMeasureFrom= (searchShipmentParams.containsKey('LoadingWeightMeasureFrom')) ? Decimal.valueOf(searchShipmentParams.get('LoadingWeightMeasureFrom')) : null;
        Decimal LoadingWeightMeasureTo  = (searchShipmentParams.containsKey('LoadingWeightMeasureTo')) ? Decimal.valueOf(searchShipmentParams.get('LoadingWeightMeasureTo')) : null;

        system.debug('Following vars prepared for searchShipment call:' + 
                        '\nShipmentID: ' + ShipmentID +
                        '\nShipmentUnitID: ' + ShipmentUnitID + 
                        '\nShipmentDateTimeFrom: ' + ShipmentDateTimeFrom +
                        '\nShipmentDateTimeTo: ' + ShipmentDateTimeTo +
                        '\nSendersReferenceNumber: ' + SendersReferenceNumber +
                        '\nPartyNumber: ' + PartyNumber +
                        '\nPartyName: ' + PartyName +
                        '\nProduct: ' + Product +
                        '\nCity: ' + City +
                        '\nShipToPostalCodeFrom: ' + ShipToPostalCodeFrom +
                        '\nShipToPostalCodeTo: ' + ShipToPostalCodeTo +
                        '\nShipToCountryCode: ' + ShipToCountryCode +
                        '\nLoadingWeightMeasureFrom: ' + LoadingWeightMeasureFrom +
                        '\nLoadingWeightMeasureTo: ' + LoadingWeightMeasureTo);

        system.debug('Calling searchShipment on: ' + eConnectSearchShipment );
        
        postenNoEconnectKatsSearchshipment.TShipmentUnit[] searchResult;
        
        startTimer();
        if(CLIENT_CERT_NAME.equals('Sandbox')) {
            searchResult = eConnectSearchShipmentStub(this);
        } else {
            searchResult = eConnectSearchShipment.SearchShipment(ShipmentID, ShipmentUnitID, ShipmentDateTimeFrom, ShipmentDateTimeTo, SendersReferenceNumber, PartyNumber, PartyName, Product, City, ShipToPostalCodeFrom, ShipToPostalCodeTo, ShipToCountryCode, LoadingWeightMeasureFrom, LoadingWeightMeasureTo);
        }
        stopTimer();
        return searchResult;  
    } 
    
    
    public List<postenNoEconnectKatsPaymentevents.TransactionResponseType> SendPayment(List<postenNoEconnectKatsPaymentevents.TransactionType> transactionsToSubmit) {
        system.debug('Preparing request data structures');
        if(isProductionEconnectURIInSandbox()) {
            String errorMessage = 'Not permitted to call eConnect in production from outside KATS production. Please ensure the custom setting eConnectEndpointURI is correct. ';
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_PostenError1+ System.Label.cs_PostenError2));
            return null;
        }
                
        system.debug('Setting up connection and calling');
        if(eConnectPaymentEventsPort == null) {
            eConnectPaymentEventsPort = new postenNoEconnectKatsPaymentevents.KATS_PaymentEventsPort();
            eConnectPaymentEventsPort.clientCertName_x = CLIENT_CERT_NAME;
            eConnectPaymentEventsPort.timeout_x = 20000;
            eConnectPaymentEventsPort.endpoint_x = updateHostnameInURI(ECONNECT_ENDPOINT_URI, eConnectPaymentEventsPort.endpoint_x);
            
        }
        eConnectPaymentEventsPort.eC4Header = getSoapHeader('sendPayment');
        
        system.debug('Calling sendPayment on: ' + eConnectPaymentEventsPort );
        if(test.isRunningTest()) { return eConnectSendPaymentStub(); }
        return eConnectPaymentEventsPort.SendPayment(transactionsToSubmit);
    }
    




    /*-----------------------Start of Payment Interface----------------*/

    private cs_postenNoEcCommonHeaderV1.HeaderType getSoapHeaderPayment(String serviceName) {
        cs_postenNoEcCommonHeaderV1.HeaderType header = new cs_postenNoEcCommonHeaderV1.HeaderType();
        header.MessageId = getUniqueMessageId();
        System.debug('=========getUniqueMessageId'+header.MessageId);
        //header.Action = 'Read'; //Must be a CRUD value (Create, Read, Update, Delete)
        //header.Version= '1.0';
        //header.SourceSystemTimestamp = System.now();
        header.SourceCompany = '000002 Posten Norge AS';
        header.SourceSystem = 'CRM';
        header.SourceSystemRef = header.MessageId;
        header.SourceSystemUser = KATSutilities.getFullUser(Userinfo.getUserId()).ldap_username__c; //'KRABBES';//Userinfo.getUserName();
        header.ServiceName = 'T50528_SendCreditMemoBasisCRM_PS';
        header.MessageMode = 'REQUEST';
        header.FirstProcessedTimestamp = System.now();
        header.ProcessedTimestamp = System.now();
        header.SourceSystemTimestamp = System.now();
        //header.TargetSystemTimestamp = '';
        //header.SecurityToken = '';
        header.OperationName = 'SendCreditMemoBasisCRM';
        header.IntergationURI = 'T50528_SendCreditMemoBasisCRM/ProxyServices/T50528_SendCreditMemoBasisCRM_PS';
        //header.ResubmissionPoint = '';
        if(serviceName == 'sendPayment') {
            header.MessageType = 'SendCreditMemoBasisCRM';   
        }

        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'eConnect messageID: ' + header.SourceSystemRef + ' (' + header.MessageType + ')' ));

        return header;
    }


    

        public cs_postenNoEcServiceSendcreditmem.CreditMemoBasisCRMRequestReceiptType SendPayment(List<cs_postenNoEcServiceSendcreditmem.ReceivableType> ReceivableList,cs_postenNoEcServiceSendcreditmem.OUType OpUnit) {
        system.debug('Preparing request data structures');
        system.debug('@@ReceivableList'+ ReceivableList);
          system.debug('@@OpUnit'+ OpUnit);
        if(isProductionEconnectURIInSandbox()) {
            String errorMessage = 'Not permitted to call eConnect in production from outside KATS production. Please ensure the custom setting eConnectEndpointURI is correct. ';
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_PostenError1+ System.Label.cs_PostenError2));
            return null;
        }
                
        system.debug('Setting up connection and calling');
        if(eConnectPaymentInvoicePort == null) {
            eConnectPaymentInvoicePort=new cs_postenNoEcServiceV1T50528Sen.SendCreditMemoBasisCRMPort();
            eConnectPaymentInvoicePort.clientCertName_x = CLIENT_CERT_NAME;
            eConnectPaymentInvoicePort.timeout_x = 20000;
            eConnectPaymentInvoicePort.endpoint_x = updateHostnameInURI(ECONNECT_ENDPOINT_URI, eConnectPaymentInvoicePort.endpoint_x);
            //eConnectPaymentInvoicePort.endpoint_x = 'https://test.econnect.postennorge.no/T50528_SendCreditMemoBasisCRM/ProxyServices/T50528_SendCreditMemoBasisCRM_PS?wsdl';
            //eConnectPaymentInvoicePort.endpoint_x = 'http://requestb.in/1bappwx1';
        }
        eConnectPaymentInvoicePort.SOAP_HeaderPart = getSoapHeaderPayment('sendPayment');
        system.debug('Calling sendPayment on: ' + eConnectPaymentInvoicePort );
        //if(test.isRunningTest()) { return eConnectSendPaymentStub(); }
        System.debug('--------------Calling');
        return eConnectPaymentInvoicePort.SendCreditMemoBasisCRM(OpUnit,ReceivableList);
    }


/*----------------------End of payment interface*--------------------/
   


/*-----------------------Start of Dispute Interface----------------*/

    private postenNoEconnectCommonHeaderV1D.HeaderType getSoapHeaderDispute(String serviceName) {
        postenNoEconnectCommonHeaderV1D.HeaderType header = new postenNoEconnectCommonHeaderV1D.HeaderType();
        header.MessageId = getUniqueMessageId();
        System.debug('=========getUniqueMessageId'+header.MessageId);
        //header.Action = 'Read'; //Must be a CRUD value (Create, Read, Update, Delete)
        //header.Version= '1.0';
        //header.SourceSystemTimestamp = System.now();
        header.SourceCompany = '000002 Posten Norge AS';
        header.SourceSystem = 'CRM';
        header.SourceSystemRef = header.MessageId;
        header.SourceSystemUser = KATSutilities.getFullUser(Userinfo.getUserId()).ldap_username__c; //'KRABBES';//Userinfo.getUserName();
        header.ServiceName = 'T50526_ReceiveDisputeInvoiceCRM_To_OEBS';
        //Bhavani
        header.MessageMode = 'REQUEST';
        header.FirstProcessedTimestamp = System.now();
        header.ProcessedTimestamp = System.now();
        header.SourceSystemTimestamp = System.now();
        //header.TargetSystemTimestamp = '';
        //header.SecurityToken = '';
        header.OperationName = 'T50526_ReceiveDisputeInvoiceCRM_To_OEBS';
        header.IntergationURI = 'T50526_ReceiveDisputeInvoiceCRM_To_OEBS/ProxyServices/T50526_ReceiveDisputeInvoiceCRM_To_OEBS_PS';
        //header.ResubmissionPoint = '';
        if(serviceName == 'createDispute') {
            header.MessageType = 'SendCreditMemoBasisCRM';   
        }

        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'eConnect messageID: ' + header.SourceSystemRef + ' (' + header.MessageType + ')' ));

        return header;
    }

    
    public postenNoEconnectDisputeinvoic.DisputeInvoiceResponseType sendDispute(postenNoEconnectDisputeinvoic.OUType OperatingUnit,Integer Invoice_Id,String InvoiceNumber,Date DisputeDate,Decimal DisputeAmount,String Comments,String ReasonCode){
        if(isProductionEconnectURIInSandbox()) {
            String errorMessage = 'Not permitted to call eConnect in production from outside KATS production. Please ensure the custom setting eConnectEndpointURI is correct. ';
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_PostenError1+ System.Label.cs_PostenError2));
            return null;
        }
        system.debug('Setting up connection and calling');
        if(postenEconnectDisputeInvoice == null) {
            postenEconnectDisputeInvoice = new recDisputeinvoicecrmToOebs.RecieveDisputeInvoicePortTypeSOAP11BindingQSPort ();
            postenEconnectDisputeInvoice.clientCertName_x = CLIENT_CERT_NAME;
            postenEconnectDisputeInvoice.timeout_x = 20000;
            postenEconnectDisputeInvoice.endpoint_x = updateHostnameInURI(ECONNECT_ENDPOINT_URI, postenEconnectDisputeInvoice.endpoint_x);
            //postenEconnectDisputeInvoice.endpoint_x = 'https://test.econnect.postennorge.no/T50528_SendCreditMemoBasisCRM/ProxyServices/T50528_SendCreditMemoBasisCRM_PS?wsdl';
            //postenEconnectDisputeInvoice.endpoint_x = 'http://requestb.in/14bjibu1';
        }
        crm_nps_settings_sales__c nps = crm_nps_settings_sales__c.getValues('eConnect ICC');
        postenEconnectDisputeInvoice.inputHttpHeaders_x = new Map<String,String>();
        postenEconnectDisputeInvoice.inputHttpHeaders_x.put('Authorization',createBasicAuthentication(nps.Username__c,nps.Password__c));
        postenEconnectDisputeInvoice.SOAP_HeaderPart = getSoapHeaderDispute('createDispute');

        system.debug('Calling sendPayment on: ' + postenEconnectDisputeInvoice );
        //if(test.isRunningTest()) { return eConnectSendPaymentStub(); }

        System.debug('--------------Calling');
        return postenEconnectDisputeInvoice.ReceiveDisputeInvoice(OperatingUnit,Invoice_Id,InvoiceNumber,DisputeDate,DisputeAmount,Comments, ReasonCode);
    }


    //User Authorization
    private String createBasicAuthentication(String username, string password){
        Blob b = Blob.valueOf(username + ':' + password);   
        String encodedValue = EncodingUtil.base64Encode(b);   
        return 'Basic ' + encodedValue;
    } 

/*-----------------------End of Dispute Interface----------------*/






    public postenNoT20056Katsdunningstopservice.Result_element UpdateNote(String CompanyCode, String CustomerNo, String Description, Date DocumentDate, String DocumentNo, Boolean ExcludeReminder, String Type_x, String ExecutiveOfficer) {
        system.debug('Preparing request data structures');
        
        postenNoT20056Katsdunningstopservice.Document_element doc = new postenNoT20056Katsdunningstopservice.Document_element();
        
        doc.CompanyCode         = CompanyCode;
        doc.CustomerNo          = CustomerNo;
        doc.Description         = Description;
        doc.DocumentDate        = DocumentDate;
        doc.DocumentNo          = DocumentNo;
        doc.ExcludeReminder     = ExcludeReminder;
        doc.Type_x              = Type_x;
        doc.ExecutiveOfficer    = ExecutiveOfficer;

        system.debug('Setting up connection and calling');
        if(test.isRunningTest()) { return eConnectUpdateNoteStub(this); }
        
        if(eConnectUpdateNote == null) {
            eConnectUpdateNote = new postenNoT20056Katsdunningstopservice.T20056_KATSDunningStopServiceSOAP();
            eConnectUpdateNote.clientCertName_x = CLIENT_CERT_NAME;
            eConnectUpdateNote.timeout_x = 20000;
            eConnectUpdateNote.endpoint_x = updateHostnameInURI(ECONNECT_ENDPOINT_URI, eConnectUpdateNote.endpoint_x);
        }
        eConnectUpdateNote.eC4Header = getSoapHeader('updateNote');
        
        system.debug('Calling updateNote on: ' + eConnectUpdateNote );
        system.debug('Sending fields: ' + doc);
        return eConnectUpdateNote.UpdateNote(doc);
    }

    /*********************
    *** HELPER METHODS ***
    *********************/
    public String updateHostnameInURI(String newHostname, String uri) {
        String newUri = uri.replaceFirst('http(s)?://[a-zA-Z0-9:_.]*/?', newHostname);
        return newUri;
    }
    private String getUniqueMessageId() {
        String uniqueString = system.now().format('yMd:HmsS') + Userinfo.getUserName() + Crypto.getRandomLong();
        return EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', Blob.valueOf(uniqueString)));    
    }
    private void startTimer() {
       timeForRequest = System.now().getTime();
    }
    private void stopTimer() {
       timeForReply = System.now().getTime();
       KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'eConnect response time: ' + ((long)(timeForReply - timeForRequest)) + 'ms' ));
    }
    public Integer customerInactive (postenNoEconnectKatsSaksearchcustome.Customer_element customer) {
        Integer customerInactive = 0;
        
        if (customer != null && customer.Division != null) {
            for (postenNoEconnectKatsSaksearchcustome.Division_element divisions: customer.Division) {
            if (divisions.CRMInactive == 1) customerInactive = 1;
            }
        }
        
        return customerInactive;
    }
    

/************************************
*** TEST METHODS (eConnect stubs) ***
************************************/    
    private static postenNoT20056Katsdunningstopservice.Result_element eConnectUpdateNoteStub(PostenNoEconnectUtilities utilitiesInstance) {       
        
        postenNoT20056Katsdunningstopservice.Result_element eConnectReply = new postenNoT20056Katsdunningstopservice.Result_element();
        
        eConnectReply.Success       = true;
        eConnectReply.Message       = 'message';
        eConnectReply.LogEntryNo    = 1;
        
        return eConnectReply; 
    }
    
    private static postenNoEconnectKatsSearchshipment.TShipmentUnit[] eConnectSearchShipmentStub(PostenNoEconnectUtilities utilitiesInstance) {
        
        list<postenNoEconnectKatsSearchshipment.TShipmentUnit> reply = new list<postenNoEconnectKatsSearchshipment.TShipmentUnit>();
        reply.add(new postenNoEconnectKatsSearchshipment.TShipmentUnit());
        reply.get(0).ShipmentUnitID = 'TestShipmentUnitId';
        reply.get(0).ShipUnitSequenceID = 'TestShipUnitSequenceID';
        reply.get(0).ShipmentDateTime = system.now();
        reply.get(0).ValueAddedService = true;
        reply.get(0).LoadingWeightMeasure = 12.12;
        reply.get(0).Product = 'TestProduct';
        reply.get(0).NameSender = 'TestNameSender';
        reply.get(0).NameRecipient = 'TestNameRecipient';
        reply.get(0).ShipToStreetAddress = 'TestShipToStreetAddress';
        reply.get(0).PostalCode = '0000';
        reply.get(0).City = 'TestCity';
        
        reply.add(new postenNoEconnectKatsSearchshipment.TShipmentUnit());
        reply.get(1).ShipmentUnitID = 'TestShipmentUnitId2';
        reply.get(1).ShipUnitSequenceID = 'TestShipUnitSequenceID2';
        reply.get(1).ShipmentDateTime = system.now();
        reply.get(1).ValueAddedService = true;
        reply.get(1).LoadingWeightMeasure = 12.12;
        reply.get(1).Product = 'TestService_Product__c';
        reply.get(1).NameSender = 'TestNameSender2';
        reply.get(1).NameRecipient = 'TestNameRecipient2';
        reply.get(1).ShipToStreetAddress = 'TestShipToStreetAddress2';
        reply.get(1).PostalCode = '0001';
        reply.get(1).City = 'TestCity2';
        
        
        return reply;
    }
    
    
    public static postenNoEconnectKatsGetshipment.ShipmentUnitType eConnectgetShipmentStub(PostenNoEconnectUtilities utilitiesInstance) {
        
        postenNoEconnectKatsGetshipment.ShipmentUnitType reply = new postenNoEconnectKatsGetshipment.ShipmentUnitType();
        
        reply.ShipmentUnitID = '000000000000000000';
        reply.RelabledShipmentUnitID = '111111111111111111';
        reply.ShipmentID = '222222222222222222';
        reply.ShipmentSequence = '333333333333333333';
        reply.SpecialFreight =
        reply.ProductName = 'test product';
        reply.ProductCode = '9999';
        reply.NewProductCode = '8888';
        reply.NewProductName = 'new test product';
        reply.SenderReference = 'sender';
        reply.RecipientReference = 'reciever';
        reply.DelieverySignature = 'signature';
        reply.ShipmentDateTime = datetime.newInstance(2000, 1, 1, 12, 0, 0);
        
        reply.PostingTerminal
            = new postenNoEconnectKatsGetshipment.AddressTerminalType();
            reply.PostingTerminal.Street = 'Terminal Street';
            reply.PostingTerminal.PostalCode  = '0000';
            reply.PostingTerminal.City = 'Terminal City';
            reply.PostingTerminal.MunicipalityName = 'Terminal Municipality';
            reply.PostingTerminal.MunicipalityCode = '9999';
            reply.PostingTerminal.Country = 'Norway';
            reply.PostingTerminal.CountryCode = '47';
            reply.PostingTerminal.type_x = 'Terminal type';
            reply.PostingTerminal.UnitNumber = '0000';
            reply.PostingTerminal.UnitName = 'Test unit';
            
        reply.CurrentCity
            = new postenNoEconnectKatsGetshipment.AddressType();
            reply.CurrentCity.Street = 'Current city Street';
            reply.CurrentCity.PostalCode  = '0000';
            reply.CurrentCity.City = 'Current city City';
            reply.CurrentCity.MunicipalityName = 'Current city Municipality';
            reply.CurrentCity.MunicipalityCode = '9999';
            reply.CurrentCity.Country = 'Norway';
            reply.CurrentCity.CountryCode = '47';
            reply.CurrentCity.type_x = 'Current city type';
            
        reply.ShipToAddress
            = new postenNoEconnectKatsGetshipment.AddressType();
            reply.ShipToAddress.Street = 'Ship to Street';
            reply.ShipToAddress.PostalCode  = '0000';
            reply.ShipToAddress.City = 'Ship to City';
            reply.ShipToAddress.MunicipalityName = 'Ship to Municipality';
            reply.ShipToAddress.MunicipalityCode = '9999';
            reply.ShipToAddress.Country = 'Norway';
            reply.ShipToAddress.CountryCode = '47';
            reply.ShipToAddress.type_x = 'Ship to type';
            
        reply.Insurance
            = new postenNoEconnectKatsGetshipment.InsuranceType();
            reply.Insurance.DeclaredValueAmount = '100';
            reply.Insurance.Description = 'Insurance description';
            
        reply.ShipmentDescription
            = new postenNoEconnectKatsGetshipment.ShipmentDescription();
            reply.ShipmentDescription.Description = 'ShipmentUnit description';
            reply.ShipmentDescription.WeightMeasure = '100';
            reply.ShipmentDescription.HeightMeasure = '10';
            reply.ShipmentDescription.LengthMeasure = '10';
            reply.ShipmentDescription.WidthMeasure = '10';
            
        reply.ValueAddedServices = new postenNoEconnectKatsGetshipment.ValueAddedServices_element();
        reply.ValueAddedServices.ValueAddedService
            = new list<postenNoEconnectKatsGetshipment.ValueAddedService>();
            reply.ValueAddedServices.ValueAddedService.add(new postenNoEconnectKatsGetshipment.ValueAddedService());
            
            reply.ValueAddedServices.ValueAddedService.get(0).Status = 'Test status';
            reply.ValueAddedServices.ValueAddedService.get(0).ServiceName = 'Test Service Name';
            reply.ValueAddedServices.ValueAddedService.get(0).CoDAmount = '100';
            reply.ValueAddedServices.ValueAddedService.get(0).BankAccountNumber = '1234567890123';
        
        reply.SortingMachineInfo = new postenNoEconnectKatsGetshipment.SortingMachineInfo_element();
        reply.SortingMachineInfo.SortingInfo
            = new list<postenNoEconnectKatsGetshipment.SortingInfo_element>();
            reply.SortingMachineInfo.SortingInfo.add(new postenNoEconnectKatsGetshipment.SortingInfo_element());
            reply.SortingMachineInfo.SortingInfo.add(new postenNoEconnectKatsGetshipment.SortingInfo_element());
                        
            reply.SortingMachineInfo.SortingInfo.get(0).BoardNumber = '10';
            reply.SortingMachineInfo.SortingInfo.get(0).Ramp = '10';
            reply.SortingMachineInfo.SortingInfo.get(0).BoardNumber = '20';
            reply.SortingMachineInfo.SortingInfo.get(0).Ramp = '20';
        
        reply.Events = new postenNoEconnectKatsGetshipment.Events_element();
        reply.Events.Event
            = new list<postenNoEconnectKatsGetshipment.ShipmentEventType>();
            reply.Events.Event.add(new postenNoEconnectKatsGetshipment.ShipmentEventType());
            reply.Events.Event.add(new postenNoEconnectKatsGetshipment.ShipmentEventType());
            reply.Events.Event.add(new postenNoEconnectKatsGetshipment.ShipmentEventType());
            
            reply.Events.Event.get(0).EventCode = 'Event code';
            reply.Events.Event.get(0).EventName = 'Event 1';
            reply.Events.Event.get(0).CaseDescription = 'Case description';
            reply.Events.Event.get(0).UnitNumber = '0000';
            reply.Events.Event.get(0).PostalCode = '1234';
            reply.Events.Event.get(0).UserName = 'User name';
            reply.Events.Event.get(0).Date_x = datetime.newInstance(2000, 1, 1, 12, 0, 0);
            reply.Events.Event.get(0).EtterregDate = datetime.newInstance(2001, 1, 1, 12, 0, 0);
            reply.Events.Event.get(0).CountryCode = '47';
            reply.Events.Event.get(0).Country = 'Norway';
            reply.Events.Event.get(0).Cause = 'None';
            reply.Events.Event.get(0).Action = 'Action';
            reply.Events.Event.get(0).FreeText = 'This is an event';
            reply.Events.Event.get(0).ShipmentUnitID = reply.ShipmentUnitID;
            reply.Events.Event.get(0).ReceivedBy = 'Test';
            reply.Events.Event.get(0).Signature = 'Signature';
            reply.Events.Event.get(0).SendtBy = 'Test user';
            reply.Events.Event.get(0).ReceiverCity = 'Test City';
            reply.Events.Event.get(0).StationID = 'Station id 1';
            
            reply.Events.Event.get(1).EventCode = 'Event code';
            reply.Events.Event.get(1).EventName = 'Event 2';
            reply.Events.Event.get(1).CaseDescription = 'Case description';
            reply.Events.Event.get(1).UnitNumber = '0000';
            reply.Events.Event.get(1).PostalCode = '1234';
            reply.Events.Event.get(1).UserName = 'User name';
            reply.Events.Event.get(1).Date_x = datetime.newInstance(2000, 1, 1, 12, 0, 0);
            reply.Events.Event.get(1).EtterregDate = datetime.newInstance(2001, 1, 1, 12, 0, 0);
            reply.Events.Event.get(1).CountryCode = '47';
            reply.Events.Event.get(1).Country = 'Norway';
            reply.Events.Event.get(1).Cause = 'None';
            reply.Events.Event.get(1).Action = 'Action';
            reply.Events.Event.get(1).FreeText = 'This is an event';
            reply.Events.Event.get(1).ShipmentUnitID = reply.ShipmentUnitID;
            reply.Events.Event.get(1).ReceivedBy = 'Test';
            reply.Events.Event.get(1).Signature = 'Signature';
            reply.Events.Event.get(1).SendtBy = 'Test user';
            reply.Events.Event.get(1).ReceiverCity = 'Test City';
            reply.Events.Event.get(1).StationID = 'Station id 2';
            
            reply.Events.Event.get(2).EventCode = 'Event code';
            reply.Events.Event.get(2).EventName = 'Event 3';
            reply.Events.Event.get(2).CaseDescription = 'Case description';
            reply.Events.Event.get(2).UnitNumber = '0000';
            reply.Events.Event.get(2).PostalCode = '1234';
            reply.Events.Event.get(2).UserName = 'User name';
            reply.Events.Event.get(2).Date_x = datetime.newInstance(2000, 1, 1, 12, 0, 0);
            reply.Events.Event.get(2).EtterregDate = datetime.newInstance(2001, 1, 1, 12, 0, 0);
            reply.Events.Event.get(2).CountryCode = '47';
            reply.Events.Event.get(2).Country = 'Norway';
            reply.Events.Event.get(2).Cause = 'None';
            reply.Events.Event.get(2).Action = 'Action';
            reply.Events.Event.get(2).FreeText = 'This is an event';
            reply.Events.Event.get(2).ShipmentUnitID = reply.ShipmentUnitID;
            reply.Events.Event.get(2).ReceivedBy = 'Test';
            reply.Events.Event.get(2).Signature = 'Signature';
            reply.Events.Event.get(2).SendtBy = 'Test user';
            reply.Events.Event.get(2).ReceiverCity = 'Test City';
            reply.Events.Event.get(2).StationID = 'Station id 3';
        
        reply.Sender
            = new postenNoEconnectKatsGetshipment.ShipmentPartyAddress();
            reply.Sender.Street = 'Sender street';
            reply.Sender.PostalCode = '2345';
            reply.Sender.City = 'Sender City';
            reply.Sender.MunicipalityName = 'Sender Municipality';
            reply.Sender.MunicipalityCode = '9999';
            reply.Sender.Country = 'Norway';
            reply.Sender.CountryCode = '47';
            reply.Sender.type_x = 'Type';
            reply.Sender.PartyNumber = '1234567';
            reply.Sender.FullName = 'Sender Account';
        
        reply.Recipient
            = new postenNoEconnectKatsGetshipment.ShipmentPartyAddress();
            reply.Recipient.Street = 'Reciever street';
            reply.Recipient.PostalCode = '2345';
            reply.Recipient.City = 'Reciever City';
            reply.Recipient.MunicipalityName = 'Reciever Municipality';
            reply.Recipient.MunicipalityCode = '9999';
            reply.Recipient.Country = 'Norway';
            reply.Recipient.CountryCode = '47';
            reply.Recipient.type_x = 'Type';
            reply.Recipient.PartyNumber = '0000';
            reply.Recipient.FullName = 'Reciever Account';
        return reply;
        
    }

    private static String eConnectShipmentEventPortStub(PostenNoEconnectUtilities utilitiesInstance) {
        return 'OK';
    }
    
    public static postenNoEconnectKatsPaymentevents.TransactionResponseType[] eConnectSendPaymentStub() {
        List<postenNoEconnectKatsPaymentevents.TransactionResponseType> reply = new List<postenNoEconnectKatsPaymentevents.TransactionResponseType>();
        reply.add(new postenNoEconnectKatsPaymentevents.TransactionResponseType());
        reply.get(0).KATSTransactionID = 'TransTestId';
        reply.get(0).Status = 'OK';
        return reply;
    }
    
    
}