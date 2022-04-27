public class crm_newContactWrapper{
    public Boolean usingCustomerNumber;
    public String firstName;
    public String lastName;
    public String userName;
    public String language;
    public String phoneNumber;
    public string createdDateTime ;
    public Map<String,String> additionalDetails;
    
public static crm_newContactWrapper parse(String json){
    return (crm_newContactWrapper) System.JSON.deserialize(json, crm_newContactWrapper.class);
}

 
}