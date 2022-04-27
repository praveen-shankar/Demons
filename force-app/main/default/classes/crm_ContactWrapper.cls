public class crm_ContactWrapper{
    public String firstName;
    public String lastName;
    public String userEmail;
    public String aggreedMarketingActivities;
    public String declinedMarketingActivities;
    public String agreedToEmail;
    public String agreedToSms;
    public String agreedToMybring;
    public String marketingActivitiesLastUpdate;
    public String salesforceStatus;
    public String mybringStatus;
    public String mobileCountryCode;
    public String mobileNumber;
    public String phoneNumber;
    public String workingArea;
    public String userLanguage;
    public String lastUpdatedTime;
    public String mybringUserId;
    public String salesforceUserId;
    public String createdDateTime;
    public String lastLoginDateTime;
    public List<cls_customer> customers; //relation level accounts connected to party

public static crm_ContactWrapper parse(String json){
    return (crm_ContactWrapper) System.JSON.deserialize(json, crm_ContactWrapper.class);
}

  public class cls_customer{
        public String customerMasterNumber;
        public String sourceSystem;
        public Set<String> possibleCustomerNumbers; //relation level accounts connected to party
        public List<String> ROLES;
    }
}