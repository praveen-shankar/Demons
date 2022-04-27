//Wrapper class to create Agreement data to be sent to production system via eConnect
//Author - Rajeev Shekhar
//Agreement Phase 2 project
//Date 13-11-2017

public class crm_agreementIntegrationServicesWrapper {
    
    public cls_agreement agreementInformation;//opportunity as agreement

    public class cls_agreement{
        public String agreementId;
        public String agreementName;
        public String agreementStartDate;
        public String agreementEndDate;
        public String agreementStatus;
        public String agreementServiceGroup;
        public String exceptionsToStandardPriceAdjustmentDate;
        public Boolean exceptionsToStandardPriceAdjustment;
       //PA14012021 public String priceAdjustmentStartDate;
        public String currencyCode;
        public String agreementType;//New, upsell, cross sell or renegotiate
        public String agreementServiceFamily;
        public cls_party party; //party account detail
        public List<cls_services> services; //List of services connected to Opportunity
        public String agreementInheritedFrom;
        public String agreementAggregatorId;
        public String agreementAggregatorName;
        public String actionType;
        //17731 Shell Agreement
        //public String copyExistingAgreementInPE;
    }
    
    public class cls_party{
        public String party_Id;
        public String party_Name;
        public List<cls_customer> accounts; //relation level accounts connected to party
    }
    
    public class cls_customer{
        public String customer_number;
        public String customerName;
        public String customerSource;
    }
    
    public class cls_services{
        public String serviceName;//Name of Product
        public String actualServiceId;
        public String salesforceLineID;
        public Decimal fromWeight;
        public Decimal toWeight;
        public Boolean freePickup;
        public String  passiveReturn;
        public String additionalServiceID;
        public String relatedActualServiceId;//For VAS and Surcharge, mention the Actual Service Id it is connected to
        public String serviceType;//Service type
        public String serviceFamily;
        public Decimal discountPercentage;
        public String discountTypeRegion;//local, domestic, all or cross border
        public Decimal minimumPrice;
        public String terminals;//"|" separated in case of multi value
        public Decimal unitPrice;
        public String direction;//Inbound or Outbound
        public String conversionFactor;
        public cls_systems[] distributionSystems;
        public String priceListForBusinessDelivery;
        public List<cls_services> additionalServices;
       //PA14012021 public Decimal standardPriceAdjustment;
       //PA14012021  public Decimal customPriceAdjustment;
        //PA14012021  public String decimalRoundOffPosition;
         public String isPayerReceiverorSender;
         
    }
    
    public class cls_systems{
        public String distributionSystem;
    }
    
}