public class crm_CreditNote_ResponseHandler {
    @AuraEnabled
    public String userName;
    @AuraEnabled
    public String phoneNumber;
    @AuraEnabled
    public String emailAddress;
    @AuraEnabled
    public String transactionDate;
    @AuraEnabled
    public String transactionAmount;
    @AuraEnabled
    public String transactionId;
    @AuraEnabled
    public String orderNumber;
    @AuraEnabled
    public String shipmentNumber;
    @AuraEnabled
    public Boolean isRefund;
    //Adding New Payment Type
    @AuraEnabled
    public String paymentProvider;

    
    public static List<crm_CreditNote_ResponseHandler> parse(String json) {
       
        return (List<crm_CreditNote_ResponseHandler>) System.JSON.deserialize(json, List<crm_CreditNote_ResponseHandler>.class);
    }
}