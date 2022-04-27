public with sharing class AdditionalServiceslwc {
    // public AdditionalServiceslwc() {
        // @AuraEnabled
        // public static List<OpportunityLineItem> saveContactData(String contactDataString){
        //     List<OpportunityLineItem> contactList = (List<OpportunityLineItem>)System.JSON.deserializeStrict(contactDataString, List<OpportunityLineItem>.Class);
        //     Database.insert(contactList);
        //     return contactList;
        // }

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
        // public static void testMethodjs(String abc){
        //     String abcd=abc;
        //     System.debug('Method output'+abcd);
        // }

    //     @AuraEnabled(cacheable=true)
    //    public static List<OpportunityLineItem> createOliRecord(String abc){

    //     // List<OpportunityLineItem> ListOLI = new List<OpportunityLineItem>();
    //     // ListOLI=oliList;
    //     System.debug('ListOLI: - '+ListOLI);

    //    System.debug('***: - '+oliList);

    //    return oliList;
    //    }

    @AuraEnabled(Cacheable=false)
    public static boolean createOliRecord(String addSerData,String currentactualServiceId,String lineItemsGroupId){

        System.debug('addSerData--'+addSerData);
        System.debug('currentactualServiceId--'+currentactualServiceId);
        System.debug('lineItemsGroupId--'+lineItemsGroupId);
        // try {
            // List<OpportunityLineItem> OLIList = (List<OpportunityLineItem>)System.JSON.deserializeStrict(addSerData,List<OpportunityLineItem>.class);
           List<OtherContact> OLIList = (List<OtherContact>)System.JSON.deserializeStrict(addSerData,List<OtherContact>.class);
            // List<OpportunityLineItem> OLIList =  new List<OpportunityLineItem>(addSerData,List<OpportunityLineItem>.class);
            // OLIList = addSerData,List<OpportunityLineItem>.class;
             System.debug('OLIList'+OLIList);  
             List<OpportunityLineItem> OLItemData = new List<OpportunityLineItem>();
             String actualServiceId=currentactualServiceId.replace('"','');
            //  String gId = actualServiceId + String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
            
             String gId = lineItemsGroupId;
             //  for(Integer i=0;i<OLIList.size();i++)
            for(OtherContact Oli_loc: OLIList)
             {
                // List<OpportunityLineItem> OLItemData = new List<OpportunityLineItem>();
                // for (OpportunityLineItem ol_loc : oLI){
             OpportunityLineItem addSerDetails = new OpportunityLineItem();
                 
                    
                

                String Pricebook2Id=Oli_loc.Pricebook2Id;
                // OLItemData.add(Pricebook2Id);
                String productIds=Oli_loc.crmActualServiceC;
                // OLItemData.add(productIds);
                String CurrencyIsoCode=Oli_loc.CurrencyIsoCode;
                // OLItemData.add(CurrencyIsoCode);
                System.debug('Pricebook2Id+productIds+CurrencyIsoCode'+Pricebook2Id +' '+ productIds +' '+ CurrencyIsoCode );
                PriceBookEntry[] pbentry = [Select Id,Product2Id From PriceBookEntry where Product2Id =:productIds and Pricebook2Id = :Pricebook2Id And CurrencyIsoCode = :CurrencyIsoCode];
                String PricebookToEntryId=pbentry[0].Id;
                // OLItemData.add(PricebookToEntryId);
                addSerDetails.OpportunityId=Oli_loc.OpportunityId;
                if(Oli_loc.UnitPrice!=''){
                addSerDetails.UnitPrice=decimal.valueof(Oli_loc.UnitPrice.trim());
            }
            if(Oli_loc.crmDiscountC!=''){
                addSerDetails.crm_Discount__c=decimal.valueof(Oli_loc.crmDiscountC.trim());
            }else if(Oli_loc.crmDiscountC==''){
                addSerDetails.crm_Discount__c=0;
            }
                addSerDetails.crm_Actual_Service__c=Oli_loc.crmActualServiceC;         
                addSerDetails.crm_lineItemsGroupId__c = gId;     
                // addSerDetails.Pricebook2Id=Oli_loc.Pricebook2Id;
                // addSerDetails.CurrencyIsoCode=oliList[i].CurrencyIsoCode;
                addSerDetails.PricebookEntryId=PricebookToEntryId;



                OLItemData.add(addSerDetails);
              
               

             }
             try {
                //    insert OLItemData;
                   insert OLItemData;
                   return true;
                } catch (Exception e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                    throw new AuraHandledException(e.getMessage());
                   
                }
              
                    // return false;
               
        // PriceBookEntry[] pbentry = [Select Id,Product2Id From PriceBookEntry where Product2Id In :productIds and Pricebook2Id = :opp.Pricebook2Id And CurrencyIsoCode = :opp.CurrencyIsoCode];
            
        // } catch (Exception e) {
            // throw new AuraHandledException(e.getMessage());
            
            // return e.getMessage();
        // }
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

    // 'crm_Discount__c': crm_Discount__c,
    // 'UnitPrice': UnitPrice,
    //   'crm_Minimum_Price__c' : this.strMinimumPrice,
    //   'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
    //   'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
    // 'OpportunityId': OpportunityId,
    // 'crm_Actual_Service__c': crm_Actual_Service__c,
    // 'Pricebook2Id' : this.Pricebook2Idvalue
    // String UnitPrice {get; set;}
    //   'crm_Minimum_Price__c' : this.strMinimumPrice,
    //   'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
    //   'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
    // String OpportunityId {get; set;}
 

//     @AuraEnabled(cacheable=true)
// public static List<> createOliRecord(String otherContactsString) {
//     List<OtherContact> otherContacts = (List<OtherContact>) JSON.deserialize(otherContactsString, List<OtherContact>);
//     // TO DO
//     // ResponseData responseData = new ResponseData();
//     // System.debug('Sizearray'+otherContactsString.Size());
//         System.debug('param: '+ otherContacts);
//         System.debug('otherContacts'+otherContacts)
//         // return responseData;
//     return otherContacts;
// }


    





        // @AuraEnabled
        // public static List<Contact> saveContactData(String contactDataString){
        //     List<Contact> contactList = (List<Contact>)System.JSON.deserializeStrict(contactDataString, List<Contact>.Class);
        //     Database.insert(contactList);
        //     return contactList;
        // }





    // }
    @AuraEnabled(cacheable=true)
    public static List<Product_Relation__c> AdditionalServices(String currentactualServiceId)
    {
        // Notice how all of the double quotes (except for the one inside the replacement
//   string literal) have turned into single quotes
// String temp = str.replace('"','');
    // String actualservicetype=currentactualservicetype;
    // String actualservicetype= currentactualservicetype.replace('"','');
    // String actualServiceId=currentactualServiceId;
    String actualServiceId=currentactualServiceId.replace('"','');
        List<Product_Relation__c> listadditionalService =  
        // [select id,Name,Additional_Service__c,(select id,name from Product2) from Product_Relation__c where Service__c=:actualServiceId and Additional_Service_Type__c=:actualservicetype];
        // [select id,Name,Additional_Service__c,Additional_Service__r.Name from Product_Relation__c where Service__c=:actualServiceId and Additional_Service_Type__c=:actualservicetype];
// [select id,(select id,Name,Additional_Service__c,Additional_Service__r.Name from Product_Relation__c where Service__c=:actualServiceId and Additional_Service_Type__c=:actualservicetype),Name from Product2]
        [select id,Name,Additional_Service__c,Add_Service_ERP_ID__c,Actual_Service_ERP_ID__c,Additional_Service__r.Name,ProductNameERP__c from Product_Relation__c where Service__c=:actualServiceId and Additional_Service_Type__c='Vas'];
        return listadditionalService;
    }

    @AuraEnabled(cacheable=true)
    public static List<Product_Relation__c> AdditionalServicesSurcharge(String currentactualServiceId)
    {
        // Notice how all of the double quotes (except for the one inside the replacement
//   string literal) have turned into single quotes
// String temp = str.replace('"','');
    // String actualservicetype=currentactualservicetype;
    // String actualservicetype= currentactualservicetype.replace('"','');
    // String actualServiceId=currentactualServiceId;
    String actualServiceId=currentactualServiceId.replace('"','');
        List<Product_Relation__c> listadditionalServiceSurcharge =  
        // [select id,Name,Additional_Service__c,(select id,name from Product2) from Product_Relation__c where Service__c=:actualServiceId and Additional_Service_Type__c=:actualservicetype];
        // [select id,Name,Additional_Service__c,Additional_Service__r.Name from Product_Relation__c where Service__c=:actualServiceId and Additional_Service_Type__c=:actualservicetype];
// [select id,(select id,Name,Additional_Service__c,Additional_Service__r.Name from Product_Relation__c where Service__c=:actualServiceId and Additional_Service_Type__c=:actualservicetype),Name from Product2]
        [select id,Name,Additional_Service__c,Add_Service_ERP_ID__c,Actual_Service_ERP_ID__c,Additional_Service__r.Name,ProductNameERP__c from Product_Relation__c where Service__c=:actualServiceId and Additional_Service_Type__c='Surcharge'];
        return listadditionalServiceSurcharge;
    }
}