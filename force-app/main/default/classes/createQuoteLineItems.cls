public with sharing class createQuoteLineItems {

//<-----//Add QuoteLineItems Starts//----->

//delete multiple contact record in LWC
@AuraEnabled(cacheable=true)
public static List<Product2> fetchProduct2Record(String tabselectedapi,String searchKey){

//Code for Search Functionality starts here

List<Product2> conList = new List<Product2>();
String strgkeyword = '%'+searchKey+'%';

//Code for Search Functionality ends here

String filterTabValue=tabselectedapi;
System.debug('Apex class value of FilterTabValue' + filterTabValue);

System.debug('Apex class value of tabselectedapi' + tabselectedapi);

 String TabName=filterTabValue.replace('"','');

     if (TabName=='All') {

       //For Search Functionality starts
       String actualService='Actual Service';
        string query = 'Select Id,Name,crm_global_Service_Group__c,Minimum_Price_check__c,Free_PickUp_Check__c,Passive_Return_Check__c,Weight_Interval_From_Check__c,Weight_Interval_To_Check__c,Local_Domestic_Check__c,Conversion_Factor_Check__c,Is_Payer_Receiver_or_Sender_Check__c,Terminals_Check__c,Direction_Terminals_Check__c,Annual_Service_Value_Check__c,Discount_Check__c From Product2 where isActive=true and crm_Service_Type__c =:actualService'; 
       if(!String.isEmpty(searchKey)){
            query += ' AND Name LIKE \'%'+searchKey+'%\'';
       }
       conList = Database.query(query);
       return conList;
       //For Search Functionality ends

     } else If(TabName!='All') {
        string query ='Select Id, Name,crm_global_Service_Group__c,	Minimum_Price_check__c,Free_PickUp_Check__c,Passive_Return_Check__c,Weight_Interval_From_Check__c,Weight_Interval_To_Check__c,Local_Domestic_Check__c,Conversion_Factor_Check__c,Is_Payer_Receiver_or_Sender_Check__c,Terminals_Check__c,Direction_Terminals_Check__c,Annual_Service_Value_Check__c,Discount_Check__c From Product2 where SF_II_ServiceType__c=:TabName and isActive=true ';
      if(!String.isEmpty(searchKey)){
         query += ' AND Name LIKE \'%'+searchKey+'%\'';
    }
      conList = Database.query(query);
     return conList;

     } else {
       return null;
     }
    
}

public class DataTableWrapper{
 @AuraEnabled
 public String Name;
 @AuraEnabled
 public String crmGlobalServiceGroupC;
 @AuraEnabled
 public String Id;
}

//Get picklist Values ends
@AuraEnabled(cacheable=true)
public static List<String> getPickListValuesIntoList(){
List<String> pickListValuesList= new List<String>();
Schema.DescribeFieldResult fieldResult = Product2.SF_II_ServiceType__c.getDescribe();

List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
for( Schema.PicklistEntry pickListVal : ple){
pickListValuesList.add(pickListVal.getLabel());
}     
System.debug('pickListValuesList '+pickListValuesList);
return pickListValuesList;
}
//Get picklist Values ends

//<-----//Add QuoteLineItems Ends//----->//

//<-----//ConfigureService Start//----->//

@AuraEnabled(cacheable=true)
public static List<Quote> fetchPricebook2Id(String recordId)
{
    // Notice how all of the double quotes (except for the one inside the replacement
//   string literal) have turned into single quotes
String quoteID=recordId.replace('"','');
    List<Quote> Pricebook2IdList =         
    [Select Opportunity.Pricebook2Id,Pricebook2Id, Opportunity.CurrencyIsoCode,CurrencyIsoCode From Quote Where Id = :quoteID];
    return Pricebook2IdList;
}

@AuraEnabled
public static List<PriceBookEntry> fetchPriceBookEntryId(String productId,String Pricebook2Id,String CurrencyIsoCode)
{
    String a=productId;
    String b=Pricebook2Id;
    String c=CurrencyIsoCode;
    // Notice how all of the double quotes (except for the one inside the replacement
//   string literal) have turned into single quotes

System.debug('Inside Apex - productId:'+a+'Pricebook2Id:'+b+'CurrencyIsoCode:'+c);
     List<PriceBookEntry> PriceBookEntryList =         
   [Select Id,Product2Id From PriceBookEntry where Product2Id = :a and Pricebook2Id = :b and CurrencyIsoCode = :c];
   System.debug('PriceBookEntryList'+PriceBookEntryList);  
   return PriceBookEntryList;
}

//<-----//ConfigureService Ends//------>//

//<-----//Additional Services Component Starts here//------>//

    //     @AuraEnabled(cacheable=true)
    //     public static List<Opportunity> fetchPricebook2Id(String recordId)
    //     {
    //         // Notice how all of the double quotes (except for the one inside the replacement
    // //   string literal) have turned into single quotes
    //     String opportunityId=recordId.replace('"','');
    //         List<Opportunity> Pricebook2IdList =         
    //         [Select Pricebook2Id, CurrencyIsoCode From Opportunity Where Id = :opportunityId];
    //         return Pricebook2IdList;
    //     }

    @AuraEnabled(Cacheable=false)
    public static boolean createOliRecord(String addSerData,String currentactualServiceId,String lineItemsGroupId){

        System.debug('addSerData--'+addSerData);
        System.debug('currentactualServiceId--'+currentactualServiceId);
        System.debug('lineItemsGroupId--'+lineItemsGroupId);
      
        List<OtherContact> OLIList = (List<OtherContact>)System.JSON.deserializeStrict(addSerData,List<OtherContact>.class);
          
        System.debug('OLIList'+OLIList);  
             List<QuoteLineItem> OLItemData = new List<QuoteLineItem>();
             String actualServiceId=currentactualServiceId.replace('"','');
          
             String gId = lineItemsGroupId;
          
            for(OtherContact Oli_loc: OLIList)
             {
                
                QuoteLineItem addSerDetails = new QuoteLineItem();
                 
                String Pricebook2Id=Oli_loc.Pricebook2Id;
            
                String productIds=Oli_loc.crmActualServiceC;
            
                String CurrencyIsoCode=Oli_loc.CurrencyIsoCode;
             
                System.debug('Pricebook2Id+productIds+CurrencyIsoCode'+Pricebook2Id +' '+ productIds +' '+ CurrencyIsoCode );
                PriceBookEntry[] pbentry = [Select Id,Product2Id From PriceBookEntry where Product2Id =:productIds and Pricebook2Id = :Pricebook2Id And CurrencyIsoCode = :CurrencyIsoCode];
                String PricebookToEntryId=pbentry[0].Id;
                addSerDetails.QuoteId=Oli_loc.OpportunityId;
                if(Oli_loc.UnitPrice!=''){
                addSerDetails.UnitPrice=Integer.valueof(Oli_loc.UnitPrice.trim());
            }else if(Oli_loc.UnitPrice==''){
                addSerDetails.UnitPrice=0;
            }
            if(Oli_loc.crmDiscountC!=''){
                addSerDetails.Discount=Integer.valueof(Oli_loc.crmDiscountC.trim());
            }else if(Oli_loc.crmDiscountC==''){
                addSerDetails.Discount=0;
            }
                addSerDetails.Product2Id=Oli_loc.crmActualServiceC;         
                addSerDetails.Group_Line_Item_Id__c = gId;     
             
                addSerDetails.PricebookEntryId=PricebookToEntryId;
                addSerDetails.Quantity=1;

                OLItemData.add(addSerDetails);         

             }
             try {
            
                   insert OLItemData;
                   return true;
                } catch (Exception e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                    throw new AuraHandledException(e.getMessage());
                   
                }
              
  
    }

    //Properties should reflect the objects in the array for the deserialization to work
private class OtherContact{
    Id OpportunityId {get; set;}
    String UnitPrice {get; set;}
    String crmDiscountC {get; set;}
    String crmActualServiceC {get; set;}
    String Pricebook2Id {get; set;}
    String CurrencyIsoCode{get;set;}
    String PricebookToEntryId{get;set;}
}


    @AuraEnabled(cacheable=true)
    public static List<Product_Relation__c> AdditionalServices(String currentactualServiceId)
    {
        // Notice how all of the double quotes (except for the one inside the replacement
//   string literal) have turned into single quotes

    String actualServiceId=currentactualServiceId.replace('"','');
        List<Product_Relation__c> listadditionalService =  
     
        [select id,Name,Additional_Service__c,Add_Service_ERP_ID__c,Actual_Service_ERP_ID__c,Additional_Service__r.Name,ProductNameERP__c from Product_Relation__c where Service__c=:actualServiceId and Additional_Service_Type__c='Vas'];
        return listadditionalService;
    }

    @AuraEnabled(cacheable=true)
    public static List<Product_Relation__c> AdditionalServicesSurcharge(String currentactualServiceId)
    {
        // Notice how all of the double quotes (except for the one inside the replacement
//   string literal) have turned into single quotes
// String temp = str.replace('"','');
    
    String actualServiceId=currentactualServiceId.replace('"','');
        List<Product_Relation__c> listadditionalServiceSurcharge =  
       [select id,Name,Additional_Service__c,Add_Service_ERP_ID__c,Actual_Service_ERP_ID__c,Additional_Service__r.Name,ProductNameERP__c from Product_Relation__c where Service__c=:actualServiceId and Additional_Service_Type__c='Surcharge'];
        return listadditionalServiceSurcharge;
    }

    //<-----//Additional Services Component Ends here//------>//

}