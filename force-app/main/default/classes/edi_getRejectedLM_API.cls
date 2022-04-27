//Wrapper for getRejected API EDI
//Author - Rajeev Shekhar
//EdiAdmin 
//07-02-2019

public class edi_getRejectedLM_API{
    public String Status;
    public String SQLCode;
    public String ReturnStatusText;
    public cls_RejectedEDI[] RejectedEDI;

    public class cls_RejectedEDI {
        public String ParcelNumber;
        public String EDIIdent;
        public String RunNumber;
        public String FailureMessage;
        public String Timestamp;
    }

    public static edi_getRejectedLM_API parse(String json){
        return (edi_getRejectedLM_API) System.JSON.deserialize(json, edi_getRejectedLM_API.class);
    }
}