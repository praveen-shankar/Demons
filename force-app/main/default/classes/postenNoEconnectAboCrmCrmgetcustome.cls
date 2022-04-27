public class postenNoEconnectAboCrmCrmgetcustome {
    public class AgreementType {
        public String AgreementNumber;
        public String AgreementTitle;
        public String SalesPersonName;
        public String Contact;
        public String AgreementType;
        public String OEBSURI;
        private String[] AgreementNumber_type_info = new String[]{'AgreementNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] AgreementTitle_type_info = new String[]{'AgreementTitle','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] SalesPersonName_type_info = new String[]{'SalesPersonName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Contact_type_info = new String[]{'Contact','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] AgreementType_type_info = new String[]{'AgreementType','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] OEBSURI_type_info = new String[]{'OEBSURI','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'AgreementNumber','AgreementTitle','SalesPersonName','Contact','AgreementType','OEBSURI'};
    }
    public class Addresses_element {
        public postenNoEconnectAboCrmCrmgetcustome.AddressType[] Address;
        private String[] Address_type_info = new String[]{'Address','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'Address'};
    }
    public class CustomerOrganizationType {
        public String PartyNumber;
        public String DigipostID;
        public String DigiPostIDFlag;
        public String CDHCustomerNumber;
        public String DUNSNo;
        public String Status;
        public String StatusCode;
        public String CustomerNumber;
        public postenNoEconnectAboCrmCrmgetcustome.Communications_element Communications;
        public postenNoEconnectAboCrmCrmgetcustome.Addresses_element Addresses;
        public postenNoEconnectAboCrmCrmgetcustome.Forwardings_element Forwardings;
        public postenNoEconnectAboCrmCrmgetcustome.Orders_element Orders;
        public postenNoEconnectAboCrmCrmgetcustome.Invoices_element Invoices;
        public String FiscalCode;
        public String MarketName;
        public String LegalName;
        private String[] PartyNumber_type_info = new String[]{'PartyNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] DigipostID_type_info = new String[]{'DigipostID','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] DigiPostIDFlag_type_info = new String[]{'DigiPostIDFlag','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] CDHCustomerNumber_type_info = new String[]{'CDHCustomerNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] DUNSNo_type_info = new String[]{'DUNSNo','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Status_type_info = new String[]{'Status','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] StatusCode_type_info = new String[]{'StatusCode','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] CustomerNumber_type_info = new String[]{'CustomerNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','true'};
        private String[] Communications_type_info = new String[]{'Communications','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Addresses_type_info = new String[]{'Addresses','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Forwardings_type_info = new String[]{'Forwardings','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Orders_type_info = new String[]{'Orders','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Invoices_type_info = new String[]{'Invoices','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] FiscalCode_type_info = new String[]{'FiscalCode','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] MarketName_type_info = new String[]{'MarketName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] LegalName_type_info = new String[]{'LegalName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'PartyNumber','DigipostID','DigiPostIDFlag','CDHCustomerNumber','DUNSNo','Status','StatusCode','CustomerNumber','Communications','Addresses','Forwardings','Orders','Invoices','FiscalCode','MarketName','LegalName'};
    }
    public class Forwardings_element {
        public postenNoEconnectAboCrmCrmgetcustome.ForwardingType[] Forwarding;
        private String[] Forwarding_type_info = new String[]{'Forwarding','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'Forwarding'};
    }
    public class Orders_element {
        public postenNoEconnectAboCrmCrmgetcustome.OrderType[] Order;
        private String[] Order_type_info = new String[]{'Order','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'Order'};
    }
    public class OrderType {
        public String SourceSystem;
        public String OrderNumber;
        public String OrderType;
        public Double Sum;
        public String OrderedByName;
        public String OrderedByNumber;
        public String OrderStatus;
        public String OEBSURI;
        private String[] SourceSystem_type_info = new String[]{'SourceSystem','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] OrderNumber_type_info = new String[]{'OrderNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] OrderType_type_info = new String[]{'OrderType','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] Sum_type_info = new String[]{'Sum','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] OrderedByName_type_info = new String[]{'OrderedByName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] OrderedByNumber_type_info = new String[]{'OrderedByNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] OrderStatus_type_info = new String[]{'OrderStatus','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] OEBSURI_type_info = new String[]{'OEBSURI','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'SourceSystem','OrderNumber','OrderType','Sum','OrderedByName','OrderedByNumber','OrderStatus','OEBSURI'};
    }
    public class CRMGetCustomerPartyRequestType {
        public String PartyNumber;
        public String CDHCustomerNumber;
        public String[] InformationType;
        private String[] PartyNumber_type_info = new String[]{'PartyNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] CDHCustomerNumber_type_info = new String[]{'CDHCustomerNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] InformationType_type_info = new String[]{'InformationType','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'PartyNumber','CDHCustomerNumber','InformationType'};
    }
    public class PersonNameType {
        public String FirstName;
        public String MiddleName;
        public String LastName;
        private String[] FirstName_type_info = new String[]{'FirstName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] MiddleName_type_info = new String[]{'MiddleName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','true'};
        private String[] LastName_type_info = new String[]{'LastName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'FirstName','MiddleName','LastName'};
    }
    public class Invoices_element {
        public postenNoEconnectAboCrmCrmgetcustome.InvoiceType[] Invoice;
        private String[] Invoice_type_info = new String[]{'Invoice','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'Invoice'};
    }
    public class CustomerPersonType {
        public String PartyNumber;
        public String DigipostID;
        public String DigiPostIDFlag;
        public String CDHCustomerNumber;
        public String Status;
        public String StatusCode;
        public String CustomerNumber;
        public postenNoEconnectAboCrmCrmgetcustome.Communications_element Communications;
        public postenNoEconnectAboCrmCrmgetcustome.Addresses_element Addresses;
        public postenNoEconnectAboCrmCrmgetcustome.Forwardings_element Forwardings;
        public postenNoEconnectAboCrmCrmgetcustome.Orders_element Orders;
        public postenNoEconnectAboCrmCrmgetcustome.Invoices_element Invoices;
        public postenNoEconnectAboCrmCrmgetcustome.PersonNameType Names;
        private String[] PartyNumber_type_info = new String[]{'PartyNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] DigipostID_type_info = new String[]{'DigipostID','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] DigiPostIDFlag_type_info = new String[]{'DigiPostIDFlag','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] CDHCustomerNumber_type_info = new String[]{'CDHCustomerNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] Status_type_info = new String[]{'Status','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] StatusCode_type_info = new String[]{'StatusCode','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] CustomerNumber_type_info = new String[]{'CustomerNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','true'};
        private String[] Communications_type_info = new String[]{'Communications','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Addresses_type_info = new String[]{'Addresses','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Forwardings_type_info = new String[]{'Forwardings','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Orders_type_info = new String[]{'Orders','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Invoices_type_info = new String[]{'Invoices','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Names_type_info = new String[]{'Names','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'PartyNumber','DigipostID','DigiPostIDFlag','CDHCustomerNumber','Status','StatusCode','CustomerNumber','Communications','Addresses','Forwardings','Orders','Invoices','Names'};
    }
    public class ActivityType {
        public String ActivityNumber;
        public String ActivityName;
        public String ActivityStatus;
        private String[] ActivityNumber_type_info = new String[]{'ActivityNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] ActivityName_type_info = new String[]{'ActivityName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] ActivityStatus_type_info = new String[]{'ActivityStatus','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'ActivityNumber','ActivityName','ActivityStatus'};
    }
    public class CRMGetCustomerPartyResponseType {
        public postenNoEconnectAboCrmCrmgetcustome.CustomerPersonType PersonParty;
        public postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType OrganizationParty;
        public postenNoEconnectAboCrmCrmgetcustome.Forwardings_element Forwardings;
        public postenNoEconnectAboCrmCrmgetcustome.Orders_element Orders;
        public postenNoEconnectAboCrmCrmgetcustome.Invoices_element Invoices;
        public postenNoEconnectAboCrmCrmgetcustome.ServiceExceptionType ServiceException;
        private String[] PersonParty_type_info = new String[]{'PersonParty','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] OrganizationParty_type_info = new String[]{'OrganizationParty','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] Forwardings_type_info = new String[]{'Forwardings','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Orders_type_info = new String[]{'Orders','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Invoices_type_info = new String[]{'Invoices','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] ServiceException_type_info = new String[]{'ServiceException','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'PersonParty','OrganizationParty','Forwardings','Orders','Invoices','ServiceException'};
    }
    public class CustomerType {
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class Error_element {
        public String ErrorCode;
        public String ErrorType;
        public String ErrorSource;
        public String ErrorDescription;
        public String OriginatingErrorDescription;
        private String[] ErrorCode_type_info = new String[]{'ErrorCode','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] ErrorType_type_info = new String[]{'ErrorType','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] ErrorSource_type_info = new String[]{'ErrorSource','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] ErrorDescription_type_info = new String[]{'ErrorDescription','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] OriginatingErrorDescription_type_info = new String[]{'OriginatingErrorDescription','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'ErrorCode','ErrorType','ErrorSource','ErrorDescription','OriginatingErrorDescription'};
    }
    public class ForwardingType {
        public String ForwardingNumber;
        public String ReferenceOMA;
        public String Type_x;
        public String Status;
        public String Source;
        public String OEBSURI;
        public postenNoEconnectAboCrmCrmgetcustome.AddressType FromAddress;
        public postenNoEconnectAboCrmCrmgetcustome.AddressType ToAddress;
        public Date StartDate;
        public Date EndDate;
        public Date HoldDate;
        public postenNoEconnectAboCrmCrmgetcustome.OtherParties_element OtherParties;
        private String[] ForwardingNumber_type_info = new String[]{'ForwardingNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] ReferenceOMA_type_info = new String[]{'ReferenceOMA','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Type_x_type_info = new String[]{'Type','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] Status_type_info = new String[]{'Status','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] Source_type_info = new String[]{'Source','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] OEBSURI_type_info = new String[]{'OEBSURI','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] FromAddress_type_info = new String[]{'FromAddress','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] ToAddress_type_info = new String[]{'ToAddress','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] StartDate_type_info = new String[]{'StartDate','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] EndDate_type_info = new String[]{'EndDate','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] HoldDate_type_info = new String[]{'HoldDate','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] OtherParties_type_info = new String[]{'OtherParties','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'ForwardingNumber','ReferenceOMA','Type_x','Status','Source','OEBSURI','FromAddress','ToAddress','StartDate','EndDate','HoldDate','OtherParties'};
    }
    public class InvoiceType {
        public String SourceSystem;
        public String InvoiceId;
        public String InvoiceNumber;
        public String InvoiceType;
        public Double Sum;
        public String OrderedByName;
        public String OrderedByNumber;
        public String InvoiceStatus;
        public String ItellaURI;
        public String OEBSURI;
        public Date DocumentDateTime;
        public postenNoEconnectAboCrmCrmgetcustome.OperatingUnit_element OperatingUnit;
        public String TrxClass;
        public Date TrxDueDateTime;
        public String Currency_x;
        public String AmountDueRemaining;
        public String DunningLevel;
        public Date LastDunningDate;
        public String AccountDescription;
        public String DisputedFlag;
        public Decimal DisputedAmount;
        public String DisputedReason;
        private String[] SourceSystem_type_info = new String[]{'SourceSystem','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] InvoiceId_type_info = new String[]{'InvoiceId','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] InvoiceNumber_type_info = new String[]{'InvoiceNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] InvoiceType_type_info = new String[]{'InvoiceType','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] Sum_type_info = new String[]{'Sum','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] OrderedByName_type_info = new String[]{'OrderedByName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] OrderedByNumber_type_info = new String[]{'OrderedByNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] InvoiceStatus_type_info = new String[]{'InvoiceStatus','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] ItellaURI_type_info = new String[]{'ItellaURI','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] OEBSURI_type_info = new String[]{'OEBSURI','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] DocumentDateTime_type_info = new String[]{'DocumentDateTime','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] OperatingUnit_type_info = new String[]{'OperatingUnit','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] TrxClass_type_info = new String[]{'TrxClass','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] TrxDueDateTime_type_info = new String[]{'TrxDueDateTime','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Currency_x_type_info = new String[]{'Currency','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] AmountDueRemaining_type_info = new String[]{'AmountDueRemaining','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] DunningLevel_type_info = new String[]{'DunningLevel','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] LastDunningDate_type_info = new String[]{'LastDunningDate','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] AccountDescription_type_info = new String[]{'AccountDescription','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] DisputedFlag_type_info = new String[]{'DisputedFlag','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] DisputedAmount_type_info = new String[]{'DisputedAmount','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] DisputedReason_type_info = new String[]{'DisputedReason','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'SourceSystem','InvoiceId','InvoiceNumber','InvoiceType','Sum','OrderedByName','OrderedByNumber','InvoiceStatus','ItellaURI','OEBSURI','DocumentDateTime','OperatingUnit','TrxClass','TrxDueDateTime','Currency_x','AmountDueRemaining','DunningLevel','LastDunningDate','AccountDescription','DisputedFlag','DisputedAmount','DisputedReason'};
    }
    public class CommunicationType {
        public String PhoneNumber;
        public String MobileNumber;
        public String EMailAddress;
        private String[] PhoneNumber_type_info = new String[]{'PhoneNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] MobileNumber_type_info = new String[]{'MobileNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] EMailAddress_type_info = new String[]{'EMailAddress','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'PhoneNumber','MobileNumber','EMailAddress'};
    }
    public class SalesPersonType {
        public postenNoEconnectAboCrmCrmgetcustome.PersonNameType SalesPersonName;
        public String SalesPersonPhoneNumber;
        public String SalesPersonEmail;
        private String[] SalesPersonName_type_info = new String[]{'SalesPersonName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] SalesPersonPhoneNumber_type_info = new String[]{'SalesPersonPhoneNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] SalesPersonEmail_type_info = new String[]{'SalesPersonEmail','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'SalesPersonName','SalesPersonPhoneNumber','SalesPersonEmail'};
    }
    public class Communications_element {
        public postenNoEconnectAboCrmCrmgetcustome.CommunicationType[] Communication;
        private String[] Communication_type_info = new String[]{'Communication','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'Communication'};
    }
    public class CitySubDivisionNameType {
        public Integer Sequence;
        public String SequenceName;
        public String languageID;
        private String[] Sequence_att_info = new String[]{'Sequence'};
        private String[] SequenceName_att_info = new String[]{'SequenceName'};
        private String[] languageID_att_info = new String[]{'languageID'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class CaseType {
        public String CaseNumber;
        public String CaseName;
        public String CaseStatus;
        private String[] CaseNumber_type_info = new String[]{'CaseNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] CaseName_type_info = new String[]{'CaseName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] CaseStatus_type_info = new String[]{'CaseStatus','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'CaseNumber','CaseName','CaseStatus'};
    }
    public class CodeType {
        public String listID;
        public String listAgencyID;
        public String listAgencyName;
        public String listName;
        public String listVersionID;
        public String Name;
        public String languageID;
        public String listURI;
        public String listSchemeURI;
        private String[] listID_att_info = new String[]{'listID'};
        private String[] listAgencyID_att_info = new String[]{'listAgencyID'};
        private String[] listAgencyName_att_info = new String[]{'listAgencyName'};
        private String[] listName_att_info = new String[]{'listName'};
        private String[] listVersionID_att_info = new String[]{'listVersionID'};
        private String[] Name_att_info = new String[]{'Name'};
        private String[] languageID_att_info = new String[]{'languageID'};
        private String[] listURI_att_info = new String[]{'listURI'};
        private String[] listSchemeURI_att_info = new String[]{'listSchemeURI'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class AddressType {
        public String ID;
        public String AttentionOfName;
        public String CareOfName;
        public String BuildingNumber;
        public String BuildingName;
        public String StreetName;
        public String Unit;
        public String PostOfficeBox;
        public postenNoEconnectAboCrmCrmgetcustome.CitySubDivisionNameType CitySubDivisionName;
        public postenNoEconnectAboCrmCrmgetcustome.CodeType CitySubDivsionCode;
        public String CityName;
        public String CountryCode;
        public String PostalCode;
        public String AddrTYPE;
        private String[] ID_type_info = new String[]{'ID','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] AttentionOfName_type_info = new String[]{'AttentionOfName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] CareOfName_type_info = new String[]{'CareOfName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] BuildingNumber_type_info = new String[]{'BuildingNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] BuildingName_type_info = new String[]{'BuildingName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] StreetName_type_info = new String[]{'StreetName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] Unit_type_info = new String[]{'Unit','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] PostOfficeBox_type_info = new String[]{'PostOfficeBox','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] CitySubDivisionName_type_info = new String[]{'CitySubDivisionName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] CitySubDivsionCode_type_info = new String[]{'CitySubDivsionCode','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] CityName_type_info = new String[]{'CityName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] CountryCode_type_info = new String[]{'CountryCode','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] PostalCode_type_info = new String[]{'PostalCode','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','1','false'};
        private String[] AddrTYPE_att_info = new String[]{'AddrTYPE'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'ID','AttentionOfName','CareOfName','BuildingNumber','BuildingName','StreetName','Unit','PostOfficeBox','CitySubDivisionName','CitySubDivsionCode','CityName','CountryCode','PostalCode'};
    }
    public class OperatingUnit_element {
        public String UnitName;
        public String UnitNumber;
        public String OrganizationNumber;
        public String ExternalReference;
        private String[] UnitName_type_info = new String[]{'UnitName','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] UnitNumber_type_info = new String[]{'UnitNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] OrganizationNumber_type_info = new String[]{'OrganizationNumber','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] ExternalReference_type_info = new String[]{'ExternalReference','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'UnitName','UnitNumber','OrganizationNumber','ExternalReference'};
    }
    public class OtherParties_element {
        public postenNoEconnectAboCrmCrmgetcustome.PersonNameType[] Party;
        private String[] Party_type_info = new String[]{'Party','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'Party'};
    }
    public class ServiceExceptionType {
        public postenNoEconnectAboCrmCrmgetcustome.Error_element[] Error;
        private String[] Error_type_info = new String[]{'Error','urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/ABO/CRM/CRMGetCustomerParty/v1','true','false'};
        private String[] field_order_type_info = new String[]{'Error'};
    }
}