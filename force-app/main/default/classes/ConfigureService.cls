public with sharing class ConfigureService {
    @AuraEnabled(cacheable=true)
        public static List<Opportunity> fetchPricebook2Id(String recordId)
        {
            // Notice how all of the double quotes (except for the one inside the replacement
    //   string literal) have turned into single quotes
        String opportunityId=recordId.replace('"','');
            List<Opportunity> Pricebook2IdList =         
            [Select Pricebook2Id, CurrencyIsoCode From Opportunity Where Id = :opportunityId];
            return Pricebook2IdList;
        }

        // @AuraEnabled(cacheable=true)
        // public static List<PriceBookEntry>fetchPriceBookEntryId(String productId,String Pricebook2Id,String CurrencyIsoCode){
        //     List<PriceBookEntry> PriceBookEntryList=
        //     [Select Id,Product2Id From PriceBookEntry where Product2Id =:productId and Pricebook2Id = :Pricebook2Id And CurrencyIsoCode = :CurrencyIsoCode];
        // return PriceBookEntryList;
        // }

        @AuraEnabled
        public static List<PriceBookEntry> fetchPriceBookEntryId(String productId,String Pricebook2Id,String CurrencyIsoCode)
        {
            String a=productId;
            String b=Pricebook2Id;
            String c=CurrencyIsoCode;
            // Notice how all of the double quotes (except for the one inside the replacement
    //   string literal) have turned into single quotes
        // String opportunityId=recordId.replace('"','');
        System.debug('Inside Apex - productId:'+a+'Pricebook2Id:'+b+'CurrencyIsoCode:'+c);
             List<PriceBookEntry> PriceBookEntryList =         
           [Select Id,Product2Id From PriceBookEntry where Product2Id = :a and Pricebook2Id = :b and CurrencyIsoCode = :c];
           System.debug('PriceBookEntryList'+PriceBookEntryList);  
           return PriceBookEntryList;
        }
}