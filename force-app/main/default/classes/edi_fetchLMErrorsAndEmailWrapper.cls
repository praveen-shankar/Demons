//Wrapper for getRejected API EDI
//Author - Rajeev Shekhar
//EdiAdmin 
//05-02-2019

public class edi_fetchLMErrorsAndEmailWrapper{

    public cls_ediInfo EDIDetails;    
    public cls_header Header;
    
    public class cls_ediInfo{
        public String StartDateTime;
        public String BrokerID;
        public String CompanyCode;
        public String ReturnStatus;
        public String ReturnStatusText;
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