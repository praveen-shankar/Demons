//Wrapper class to create customer conversion JSOn request
//Author: Rajeev Shekhar
//Date: 03-April-2018

public class crm_convertCustomerWrapper {
    public cls_party party;
    public cls_account[] accounts;
    
    public class cls_party {
        public String name;
        public String organizationNumber;
        public String conversionStatus;
        public String conversionDate;
        public String customerSource;
        public String sourceCompany;
        public String partyNumber;
    }
    
    public class cls_account {
        public String name;
        public String accountNumber;
        public cls_crossReferences[] accountCrossReferences;
    }
    
    public class cls_crossReferences {
        public String originSystem;
        public String originReference;
        public String status;
    }
}