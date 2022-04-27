@IsTest
public class Crm_DigitollResponseHandlerTest {
	static testMethod void testDigitollResponse() {
		String json = '['+
		'{'+
		'    \"orderId\": 32,'+
		'    \"personId\": 354682,'+
		'    \"consignmentNumber\": \"Sales00\",'+
		'    \"customerReference\": null,'+
		'    \"orderInfoToCustomer\": {'+
		'        \"ConsignorName\": \"Amazon\",'+
		'        \"ConsignorCountry\": \"US\",'+
		'        \"CurrencyConversionDate\": \"2020-08-05\",'+
		'        \"NatureOfTransaction\": 31,'+
		'        \"GoodsWeight\": 10.0,'+
		'        \"GoodsAmount\": 100.0,'+
		'        \"PostageAmount\": 0.0,'+
		'        \"PostageVAT\": 0.0,'+
		'        \"GoodsItem\": ['+
		'            {'+
		'                \"GoodsItemNumber\": 1,'+
		'                \"GoodsDescription\": \"Dress\",'+
		'                \"CountryOfOrigin\": \"NO\",'+
		'                \"OriginalCurrencyCode\": \"NOK\",'+
		'                \"CurrencyConversionRate\": 1.0,'+
		'                \"GoodsWeight\": 10.0,'+
		'                \"GoodsAmount\": 100.0,'+
		'                \"DutiesAmount\": 8.0,'+
		'                \"VATAmount\": 27.0'+
		'            },'+
		'            {'+
		'                \"GoodsItemNumber\": 2,'+
		'                \"GoodsDescription\": \"Dress\",'+
		'                \"CountryOfOrigin\": \"NO\",'+
		'                \"OriginalCurrencyCode\": \"NOK\",'+
		'                \"CurrencyConversionRate\": 1.0,'+
		'                \"GoodsWeight\": 10.0,'+
		'                \"GoodsAmount\": 100.0,'+
		'                \"DutiesAmount\": 8.0,'+
		'                \"VATAmount\": 27.0'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"receiverName\": \"Salesforce\",'+
		'    \"status\": {'+
		'        \"statusCode\": \"OPEN\",'+
		'        \"statusDescription\": \"Open order, not paid\",'+
		'        \"valid\": true'+
		'    },'+
		'    \"orderType\": \"digitoll\",'+
		'    \"accountingLossStatus\": null,'+
		'    \"statusReason\": \"Order was initiated as status: [OPEN]\",'+
		'    \"transactionId\": null,'+
		'    \"totalGrossAmount\": 100.0,'+
		'    \"currencyCode\": \"SEK\",'+
		'    \"orderSourceId\": \"ENRICHER\",'+
		'    \"updatedBy\": null,'+
		'    \"sourceReference\": \"1\",'+
		'    \"orderDate\": \"2020-09-08\",'+
		'    \"dueDate\": \"2020-08-20\",'+
		'    \"receiverPhone\": {'+
		'        \"countryCode\": \"+47\",'+
		'        \"phoneNumber\": \"123456\"'+
		'    },'+
		'    \"receiverEmail\": \"A.b@norge.com\",'+
		'    \"receiverAddressLine1\": \"Storgata 1A\",'+
		'    \"receiverAddressLine2\": \"Venstre inngang\",'+
		'    \"receiverPostalCode\": \"0101\",'+
		'    \"receiverCity\": \"Oslo\",'+
		'    \"receiverCountryCode\": \"NO\",'+
		'    \"lines\": ['+
		'        {'+
		'            \"lineNumber\": 1,'+
		'            \"item\": {'+
		'                \"itemCode\": \"15681\",'+
		'                \"itemDescription\": \"Forenklet fortolling brev\",'+
		'                \"valid\": true'+
		'            },'+
		'            \"lineDescription\": \"Fancy Clips\",'+
		'            \"quantity\": 2,'+
		'            \"quantityUOM\": \"2\",'+
		'            \"unitNetPrice\": 10.0,'+
		'            \"lineNetAmount\": 10.0,'+
		'            \"totalLineAmount\": 10.0,'+
		'            \"tax\": {'+
		'                \"taxCode\": \"3\",'+
		'                \"taxDescription\": \"MVA høy sats\",'+
		'                \"taxPercent\": 25.0,'+
		'                \"validTaxCode\": true'+
		'            },'+
		'            \"taxAmount\": 25.0'+
		'        },'+
		'        {'+
		'            \"lineNumber\": 2,'+
		'            \"item\": {'+
		'                \"itemCode\": \"102345\",'+
		'                \"itemDescription\": \"Utlagt Toll Lav grense\",'+
		'                \"valid\": true'+
		'            },'+
		'            \"lineDescription\": \"Customs Declaration\",'+
		'            \"quantity\": 2,'+
		'            \"quantityUOM\": \"2\",'+
		'            \"unitNetPrice\": 10.0,'+
		'            \"lineNetAmount\": 10.0,'+
		'            \"totalLineAmount\": 10.0,'+
		'            \"tax\": {'+
		'                \"taxCode\": \"3\",'+
		'                \"taxDescription\": \"MVA høy sats\",'+
		'                \"taxPercent\": 25.0,'+
		'                \"validTaxCode\": true'+
		'            },'+
		'            \"taxAmount\": 25.0'+
		'        }'+
		'    ]'+
		'}'+
		']';
		List<Crm_DigitollResponseHandler> obj = Crm_DigitollResponseHandler.parse(json);
		System.assert(obj != null);
	}
}