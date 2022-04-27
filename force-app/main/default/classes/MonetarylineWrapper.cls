public class MonetarylineWrapper{
        public String transactionId;
        public String paymentType;
        public String regressType;
        public String forwarder;
        public String carNumber;
        public String accountingUnit;
        public String description;
        public String regressAccount;
        public String invoiceNumber;
        public String lineAmountvalue;
        public String foreignCurrency;
        
         public static MonetarylineWrapper parse(String json){
            return (MonetarylineWrapper) System.JSON.deserialize(json, MonetarylineWrapper.class);
        }
       

}