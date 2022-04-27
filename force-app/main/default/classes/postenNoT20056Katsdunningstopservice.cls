//Generated by wsdl2apex

public class postenNoT20056Katsdunningstopservice {
    public class Document_element {
        public Date DocumentDate;
        public String DocumentNo;
        public String CustomerNo;
        public String Description;
        public String Type_x;
        public String ExecutiveOfficer;
        public Date FollowUpDate;
        public Boolean ExcludeReminder;
        public Date DueDate;
        public String CompanyCode;
        private String[] DocumentDate_type_info = new String[]{'DocumentDate','http://www.w3.org/2001/XMLSchema','date','1','1','false'};
        private String[] DocumentNo_type_info = new String[]{'DocumentNo','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] CustomerNo_type_info = new String[]{'CustomerNo','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] Type_x_type_info = new String[]{'Type','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] ExecutiveOfficer_type_info = new String[]{'ExecutiveOfficer','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] FollowUpDate_type_info = new String[]{'FollowUpDate','http://www.w3.org/2001/XMLSchema','date','0','1','false'};
        private String[] ExcludeReminder_type_info = new String[]{'ExcludeReminder','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] DueDate_type_info = new String[]{'DueDate','http://www.w3.org/2001/XMLSchema','date','0','1','false'};
        private String[] CompanyCode_type_info = new String[]{'CompanyCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/T20056_KATSDunningStopService/Service/T20056_KATSDunningStopService','false','false'};
        private String[] field_order_type_info = new String[]{'DocumentDate','DocumentNo','CustomerNo','Description','Type_x','ExecutiveOfficer','FollowUpDate','ExcludeReminder','DueDate','CompanyCode'};
    }
    public class Result_element {
        public Boolean Success;
        public String Message;
        public Integer LogEntryNo;
        private String[] Success_type_info = new String[]{'Success','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] LogEntryNo_type_info = new String[]{'LogEntryNo','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/T20056_KATSDunningStopService/Service/T20056_KATSDunningStopService','false','false'};
        private String[] field_order_type_info = new String[]{'Success','Message','LogEntryNo'};
    }
    public class T20056_KATSDunningStopServiceSOAP {
        public String endpoint_x = 'http://localhost:7001/T20056_KATSDunningStopService/ProxyServices/T20056_KATSDunningStopService';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public postenNoEconnectEc411gheader.TeC411gMessageHeader eC4Header;
        private String eC4Header_hns = 'Header=urn:posten.no/eConnect/ec411gHeader';
        private String[] ns_map_type_info = new String[]{'urn:posten.no/eConnect/ec411gHeader', 'postenNoEconnectEc411gheader', 'urn:posten.no/T20056_KATSDunningStopService/Service/T20056_KATSDunningStopService', 'postenNoT20056Katsdunningstopservice'};
        public postenNoT20056Katsdunningstopservice.Result_element UpdateNote(postenNoT20056Katsdunningstopservice.Document_element Document) {
            postenNoT20056Katsdunningstopservice.Documents_element request_x = new postenNoT20056Katsdunningstopservice.Documents_element();
            postenNoT20056Katsdunningstopservice.Result_element response_x;
            request_x.Document = Document;
            Map<String, postenNoT20056Katsdunningstopservice.Result_element> response_map_x = new Map<String, postenNoT20056Katsdunningstopservice.Result_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:posten.no/T20056_KATSDunningStopService/Service/T20056_KATSDunningStopService/NewOperation',
              'urn:posten.no/T20056_KATSDunningStopService/Service/T20056_KATSDunningStopService',
              'Documents',
              'urn:posten.no/T20056_KATSDunningStopService/Service/T20056_KATSDunningStopService',
              'Result',
              'postenNoT20056Katsdunningstopservice.Result_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
    public class Documents_element {
        public postenNoT20056Katsdunningstopservice.Document_element Document;
        private String[] Document_type_info = new String[]{'Document','urn:posten.no/T20056_KATSDunningStopService/Service/T20056_KATSDunningStopService','Document_element','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:posten.no/T20056_KATSDunningStopService/Service/T20056_KATSDunningStopService','false','false'};
        private String[] field_order_type_info = new String[]{'Document'};
    }
}