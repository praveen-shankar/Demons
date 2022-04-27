public class crm_MybringresWrapper{
    
    public String messageName;
    public String messageSubject; 
    public String messageBody;
    public string email;
    public String contactkey;
    public string open;
    public Datetime sentDate;
    public Datetime messageOpenedDate;
       
public static crm_MybringresWrapper parse(String json){
    return (crm_MybringresWrapper) System.JSON.deserialize(json, crm_MybringresWrapper.class);
} 
}