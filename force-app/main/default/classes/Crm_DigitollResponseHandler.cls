public class Crm_DigitollResponseHandler {

	public class OrderInfoToCustomer {
		public String ConsignorName;
		public String ConsignorCountry;
		public String CurrencyConversionDate;
		public Integer NatureOfTransaction;
		public Double GoodsWeight;
		public Double GoodsAmount;
		public Double PostageAmount;
		public Double PostageVAT;
		public List<GoodsItem> GoodsItem;
	}

	public class Status {
		public String statusCode;
		public String statusDescription;
		public Boolean valid;
	}

	public class Item {
		public String itemCode;
		public String itemDescription;
		public Boolean valid;
	}

	public Integer orderId;
	public Integer personId;
	public String consignmentNumber;
	public String customerReference;
	public OrderInfoToCustomer orderInfoToCustomer;
	public String receiverName;
	public Status status;
	public String orderType;
	public String accountingLossStatus;
	public String statusReason;
	public String transactionId;
	public Double totalGrossAmount;
	public String currencyCode;
	public String orderSourceId;
	public String sourceReference;
	public String orderDate;
	public String dueDate;
	public ReceiverPhone receiverPhone;
	public String receiverEmail;
	public String receiverAddressLine1;
	public String receiverAddressLine2;
	public String receiverPostalCode;
	public String receiverCity;
	public String receiverCountryCode;
    public String paymentType; // Adding new field - Payment Type
	public List<Lines> lines;

	public class GoodsItem {
		public Integer GoodsItemNumber;
		public String GoodsDescription;
		public String CountryOfOrigin;
		public String OriginalCurrencyCode;
		public Double OriginalGoodsAmount;
		public Double CurrencyConversionRate;
		public Double GoodsWeight;
		public Double GoodsAmount;
		public Double DutiesAmount;
		public Double VATAmount;
	}

	public class ReceiverPhone {
		public String countryCode;
		public String phoneNumber;
	}

	public class Tax {
		public String taxCode;
		public String taxDescription;
		public Double taxPercent;
		public Boolean validTaxCode;
	}

	public class Lines {
		public Integer lineNumber;
		public Item item;
		public String lineDescription;
		public Integer quantity;
		public String quantityUOM;
		public Double unitNetPrice;
		public Double lineNetAmount;
		public Double totalLineAmount;
		public Tax tax;
		public Double taxAmount;
	}
	
	public static List<Crm_DigitollResponseHandler> parse(String json) {
        
		return (List<Crm_DigitollResponseHandler>) System.JSON.deserialize(json, List<Crm_DigitollResponseHandler>.class);
	}
    
}