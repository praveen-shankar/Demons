//Generated by wsdl2apex

public class postenNoEconnectCommonHeaderV1D {
    public class HeaderType {
        public String MessageId;
        public String ServiceName;
        public String MessageType;
        public String MessageMode;
        public DateTime FirstProcessedTimestamp;
        public DateTime ProcessedTimestamp;
        public DateTime SourceSystemTimestamp;
        public String TargetSystemTimestamp;
        public String SecurityToken;
        public String SourceCompany;
        public String SourceSystem;
        public String SourceSystemUser;
        public String SourceSystemRef;
        public String OperationName;
        public String IntergationURI;
        public String ResubmissionPoint;
        private String[] MessageId_type_info = new String[]{'MessageId','urn:posten.no/eConnect/Common/Header/v1',null,'1','1','false'};
        private String[] ServiceName_type_info = new String[]{'ServiceName','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','false'};
        private String[] MessageType_type_info = new String[]{'MessageType','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','false'};
        private String[] MessageMode_type_info = new String[]{'MessageMode','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','false'};
        private String[] FirstProcessedTimestamp_type_info = new String[]{'FirstProcessedTimestamp','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','false'};
        private String[] ProcessedTimestamp_type_info = new String[]{'ProcessedTimestamp','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','false'};
        private String[] SourceSystemTimestamp_type_info = new String[]{'SourceSystemTimestamp','urn:posten.no/eConnect/Common/Header/v1',null,'1','1','false'};
        private String[] TargetSystemTimestamp_type_info = new String[]{'TargetSystemTimestamp','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','true'};
        private String[] SecurityToken_type_info = new String[]{'SecurityToken','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','false'};
        private String[] SourceCompany_type_info = new String[]{'SourceCompany','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','false'};
        private String[] SourceSystem_type_info = new String[]{'SourceSystem','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','false'};
        private String[] SourceSystemUser_type_info = new String[]{'SourceSystemUser','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','false'};
        private String[] SourceSystemRef_type_info = new String[]{'SourceSystemRef','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','false'};
        private String[] OperationName_type_info = new String[]{'OperationName','urn:posten.no/eConnect/Common/Header/v1',null,'1','1','false'};
        private String[] IntergationURI_type_info = new String[]{'IntergationURI','urn:posten.no/eConnect/Common/Header/v1',null,'1','1','false'};
        private String[] ResubmissionPoint_type_info = new String[]{'ResubmissionPoint','urn:posten.no/eConnect/Common/Header/v1',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/eConnect/Common/Header/v1','true','true'};
        private String[] field_order_type_info = new String[]{'MessageId','ServiceName','MessageType','MessageMode','FirstProcessedTimestamp','ProcessedTimestamp','SourceSystemTimestamp','TargetSystemTimestamp','SecurityToken','SourceCompany','SourceSystem','SourceSystemUser','SourceSystemRef','OperationName','IntergationURI','ResubmissionPoint'};
    }
}