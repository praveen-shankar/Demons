//Wrapper for edi information data to be sent to LM,IM,MB via Econnect
//Author - Rahul Umredkar
//EdiAdmin 
//17-10-2018

public class crm_EdiInformationWrapper{

    public cls_ediInfo EDIInformation;    
    public cls_header Header;
    
    public class cls_ediInfo{
        public String CustomerNumber;
        public String OrganizationNumber;
        public String CustomerSource;
        public Boolean Active;
        public Boolean EDIFilesApproved;
        public Boolean EDIFilesTested;
        public String EDIIdentificator;
        public String E_mail_for_LM_error_notifications;
        public String EndDate;
        public String EquipmentTypeQualifier;
        public String ExpectedNoOfShipmentLetters;
        public String extra1;
        public String extra2;
        public String extra3;
        public Boolean extra4;
        public Boolean extra5;
        public String FileTransfer;
        public String FileTransferDetail;
        public String CompleteEDIIdent;        
        public String InboundMessageType;
        public String IntegrationType;
        public String Kvalificator;
        public Boolean LabelsApproved;
        public String LMReportSelection;
        public String MessageFormat;
        public String NumberSeriesAssignedBy;
        public string SerialNumberDetails;
        public string SerialNumbersAssigned;
        public String OutboundMessageType;
        public String ReturnAddForBulkSplitProduct;
        public String SenderAddForParcelsToNorway;
        public String ServiceFamily;
        public String ServiceFamilyComments;
        public String StartDate;
        public string Status;// new,test phase,in production        
        public String TASolution;
        public String TAVendor;
        public String SalesforceRowId;          
        public String SystemName;//Integration system overview
        public String ActionType;// create,update,delete;
        public cls_MB EdiInformation_MB;           
     }  
     
     public class cls_MB {
        //Special attributes for MB integration
        public String MyBringID;
        public String IdFormat;
        public String IdDomain;
        public String EdiIdentity;
        public String Path;
        public String Prefix;
        public String Type;
        public String IdSubscriber;
     }
     
     public class cls_Header {
        public String MessageId;
        public String MessageType;
        public String MessageMode;
        public String ContextReference;
        public String Action;
        public String Version;
        public String FirstProcessedTimestamp;
        public String ProcessedTimestamp;
        public String SourceSystemTimestamp;
        public String TargetSystemTimestamp;
        public String SecurityToken;
        public String SourceCompany;
        public String SourceSystem;
        public String SourceSystemUser;
        public String SourceSystemRef;
     }  
}