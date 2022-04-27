public class crm_addServicesWrapper{
        public String asId;
        public String oppId;
        public String agreedItemPrice;
        public String estimatedvolume;
        public String estimatedweight;
        public String priceunit;
        public String unitprice;
        public String minimumpricepercent;
        public String minimumprice;
        public String discount;
        public String conversionfactor;
        public String direction;
        public String terminals;
        public String local;
        public String maxweight;
        public String minweight;
        public String standardUnitPrice;
        public String freepickup;
        public String passiveReturn;
    	public String isPayerReceiverorSender;

        
        public cls_additionalServices[] additionalServices;
        public class cls_additionalServices {
            public String unitPriceAddSer;
            public String discountAddSer;
            public String productId;
            public String agreedItemPriceAddSer;
            public String estimatedvolumeAddSer;
            public String estimatedweightAddSer;
            public String priceunitAddSer;
            public String minimumpricepercentAddSer;
            public String minimumpriceAddSer;
            public String conversionfactorAddSer;
            public String directionAddSer;
            public String terminalsAddSer;
            public String localAddSer;
            public String isPayerReceiverorSenderAddSer;
        }
        public static crm_addServicesWrapper parse(String json){
            return (crm_addServicesWrapper) System.JSON.deserialize(json, crm_addServicesWrapper.class);
        }

    }