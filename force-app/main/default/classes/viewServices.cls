public with sharing class viewServices {

    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> fetchOppLineRecord(String recordId){

   
    // public static List<OpportunityLineItem> fetchOppLineRecord(String recordId){
    String recordIdOpp=recordId.replace('"','');

    // Map<Id,OpportunityLineItem> mapSObj = new Map<Id,OpportunityLineItem>();
    // mapSObj.putAll(OpportunityLineItem);
        //   mapSObj= [select Id,crm_Actual_Service__c,crm_Product_Name__c from OpportunityLineItem where OpportunityId=:recordIdOpp and crm_Opp_Prod_Type__c='Actual Service'];
        List<OpportunityLineItem> OppLineList = [select Id,crm_Actual_Service__c,crm_Product_Name__c,crm_lineItemsGroupId__c from OpportunityLineItem where OpportunityId=:recordIdOpp and crm_Opp_Prod_Type__c='Actual Service'];      
    
        Set<String> abc=new Set<String>();
        List<OpportunityLineItem> OppUpdated =new List<OpportunityLineItem>();
        // List<OpportunityLineItem> OppUpdated1 =new List<OpportunityLineItem>();
// List<List<OpportunityLineItem>> ListOfList=new List<List<OpportunityLineItem>>();
         for(OpportunityLineItem a : OppLineList){
            // OppUpdated1.add(a);
             if(!abc.contains(a.crm_Product_Name__c)){
            
        abc.add(a.crm_Product_Name__c);
        OppUpdated.add(a);
      }

    //   ListOfList.add(OppUpdated);
    //   ListOfList.add(OppUpdated1);

      System.debug('8305499 OppUpdated'+OppUpdated );
    
                }

                return OppUpdated;
            }


      //Method to fetch all the related product configuration
        @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> fetchProductConfig(String actualServiceId,String recordId){
    String modifiedactualServiceId=actualServiceId.replace('"','');
    String recordIdOpp=recordId.replace('"','');
        List<OpportunityLineItem> OppLineList = [select id,Name,crm_Actual_Service__c,crm_Product_Name__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c,crm_Min_Weight__c,crm_Max_Weight__c,crm_Discount__c,UnitPrice,crm_Conversion_Factor__c,crm_lineItemsGroupId__c,CreatedDate from OpportunityLineItem where  OpportunityId=:recordIdOpp and crm_Actual_Service__c=:modifiedactualServiceId and crm_Opp_Prod_Type__c='Actual Service'];      
              return OppLineList; 

    }      

        // mapSObj
        //  List<> CombinedProductData=new List<GroupProducts>();
        // Set<OpportunityLineItem> InitialData = new Set<OpportunityLineItem>();

        // InitialData.addAll(OppLineList);
        // List<OpportunityLineItem> UpdatedList = new List<OpportunityLineItem>();
        // UpdatedList.addAll(InitialData);
        // List<OpportunityLineItem> noDupes = new List<OpportunityLineItem>(new Set<OpportunityLineItem>(UpdatedList));


        // for(Integer i=0;i<OppLineList.size();i++){
        //     InitialList.add(OppLineList[i].crm_Actual_Service__c);

        //     if(OppLineList[i].crm_Actual_Service__c==OppLineList[i].crm_Actual_Service__c){


        //     }

        // }
        
        //   return OppLineList; 
  



    // public class GroupProducts{
    //   public  Id OpportunityId {get; set;}
    //   public  String UnitPrice {get; set;}
    //   public  String crmDiscountC {get; set;}
    //   public  String crmActualServiceC {get; set;}
    //   public  String Pricebook2Id {get; set;}
    //   public  String CurrencyIsoCode{get;set;}
    //   public  String PricebookToEntryId{get;set;}
    // }

    // @AuraEnabled(cacheable=true)
    // public static List<OpportunityLineItem> fetchOppLineRecord(String recordId){
    // String recordIdOpp=recordId.replace('"','');
    //     List<OpportunityLineItem> OppLineList = [select id,Name,crm_Product_Name__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c,crm_Min_Weight__c,crm_Max_Weight__c,crm_lineItemsGroupId__c from OpportunityLineItem where OpportunityId=:recordIdOpp and crm_Opp_Prod_Type__c='Actual Service'];      
    //           return OppLineList; 

    // }

    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> fetchOppLineRecordAdditionalService(String grplineItemId,String recordId){
    String recordIdOpp=recordId.replace('"','');
    String modgrplineItemId=grplineItemId.replace('"','');
        List<OpportunityLineItem> OppLineList = [select id,Name,crm_Product_Name__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c,UnitPrice,crm_Discount__c,crm_Min_Weight__c,crm_Max_Weight__c from OpportunityLineItem where OpportunityId=:recordIdOpp and crm_lineItemsGroupId__c=:modgrplineItemId and (crm_Opp_Prod_Type__c='Surcharge' or crm_Opp_Prod_Type__c='VAS')];
              return OppLineList; 

    }

    @AuraEnabled
    public static List<Product2> fetchDynamicFieldsConditions(String ActualServiceIdMain){
        
        String actualServiceIdMainVar= ActualServiceIdMain.replace('"','');
        try {
            List<Product2> dynamicCheckList = [Select Id, Name,	Minimum_Price_check__c,
            Free_PickUp_Check__c,
            Passive_Return_Check__c,
            Weight_Interval_From_Check__c,
            Weight_Interval_To_Check__c,
            Local_Domestic_Check__c,
            Conversion_Factor_Check__c,
            Is_Payer_Receiver_or_Sender_Check__c,
            Terminals_Check__c,
            Direction_Terminals_Check__c,Annual_Service_Value_Check__c,
            Discount_Check__c From Product2 where Id =:actualServiceIdMainVar and isActive=true and crm_Service_Type__c ='Actual Service' ];      
            return dynamicCheckList;  
        } catch (Exception e) {
            System.debug('Error'+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    // @AuraEnabled(cacheable=true)
    // public static string deleteActualService(){
    //     String  abcd='deleteActualService';
    //     try {
    //     //  String   abcd='deleteActualService';
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    //     return abcd;
    // }


    @AuraEnabled
    public static List<OpportunityLineItem> deleteActualService(String rowId,String recordId){
        List<OpportunityLineItem> conObjItem = new   List<OpportunityLineItem>();
        String recordIdOpp=recordId.replace('"','');
        String rowIdnew=rowId.replace('"','');
      List<OpportunityLineItem> conObjList = [select id,Name,crm_Product_Name__c,crm_lineItemsGroupId__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c from OpportunityLineItem where Id=:rowIdnew];
        // List<OpportunityLineItem> conObjList = [select id,Name,crm_Actual_Service__c,PricebookEntryId,crm_Product_Name__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c,UnitPrice,crm_Discount__c,crm_Min_Weight__c,crm_Max_Weight__c from OpportunityLineItem where OpportunityId=:recordIdOpp and crm_lineItemsGroupId__c=:modgrplineItemId];
      List<OpportunityLineItem> allSerList =[select id,Name,crm_Product_Name__c,crm_lineItemsGroupId__c from OpportunityLineItem where crm_lineItemsGroupId__c=:conObjList[0].crm_lineItemsGroupId__c];
      for(OpportunityLineItem con:allSerList){
        conObjItem.add(con);
      }
      if(conObjItem.size()>0){
          try{
            delete conObjItem;           
          }
          catch (Exception exp) {
            throw new AuraHandledException(exp.getMessage());
        }
      }
      return fetchOppLineRecord(recordId);
    }

    @AuraEnabled
    public static List<OpportunityLineItem> cloneActualService(String actualserviceID,String grplineItemId,String recordId){
        List<OpportunityLineItem> conObjItem = new   List<OpportunityLineItem>();
     
        String recordIdOpp=recordId.replace('"','');
        String modgrplineItemId=grplineItemId.replace('"','');
            List<OpportunityLineItem> OppLineList = [select id,Name,crm_Actual_Service__c,PricebookEntryId,crm_Product_Name__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c,UnitPrice,crm_Discount__c,crm_Min_Weight__c,crm_Max_Weight__c from OpportunityLineItem where OpportunityId=:recordIdOpp and crm_lineItemsGroupId__c=:modgrplineItemId ];
                //   return OppLineList; 
    //   List<OpportunityLineItem> conObjList = [select id,Name,crm_Product_Name__c,crm_lineItemsGroupId__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c from OpportunityLineItem where Id=:rowId];
   String grpLineItemIdnew= recordIdOpp+ String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
    //   List<OpportunityLineItem> allSerList =[select id,Name,crm_Product_Name__c,crm_lineItemsGroupId__c from OpportunityLineItem where crm_lineItemsGroupId__c=:conObjList[0].crm_lineItemsGroupId__c];
      for(OpportunityLineItem con:OppLineList){
          OpportunityLineItem abc=new OpportunityLineItem();
         
         // abc.Name=con.Name;
         // abc.crm_Product_Name__c=con.crm_Product_Name__c;
        //  abc.crm_Actual_Service__r.Name=con.crm_Actual_Service__r.Name;
        //  abc.crm_Opp_Prod_Type__c=con.crm_Opp_Prod_Type__c;
          abc.UnitPrice=con.UnitPrice;
          abc.crm_Discount__c=con.crm_Discount__c;
          abc.crm_Min_Weight__c=con.crm_Min_Weight__c;
          abc.crm_Max_Weight__c=con.crm_Max_Weight__c;
          abc.PricebookEntryId=con.PricebookEntryId;    
          abc.OpportunityId=recordIdOpp;
          abc.crm_Actual_Service__c=con.crm_Actual_Service__c;
          abc.Id=null;
          abc.crm_lineItemsGroupId__c =grpLineItemIdnew;
        conObjItem.add(abc);
      }
      if(conObjItem.size()>0){
          try{
            insert conObjItem;           
          }
          catch (Exception exp) {
              System.debug('Error 8305499228'+exp.getMessage());
            throw new AuraHandledException(exp.getMessage());

        }
      }
      String recordactualServiceId=actualserviceID.replace('"','');
      
      return fetchProductConfig(recordactualServiceId,recordId);
    }

//Update the records on OpportuntiyLineItem using Lightning Data Table starts
// @AuraEnabled
// public static List<OpportunityLineItem> UpdateActualService(String actualserviceID,String grplineItemId,String recordId){
//     List<OpportunityLineItem> conObjItem = new   List<OpportunityLineItem>();
 
//     String recordIdOpp=recordId.replace('"','');
//     String modgrplineItemId=grplineItemId.replace('"','');
//         List<OpportunityLineItem> OppLineList = [select id,Name,crm_Actual_Service__c,PricebookEntryId,crm_Product_Name__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c,UnitPrice,crm_Discount__c,crm_Min_Weight__c,crm_Max_Weight__c from OpportunityLineItem where OpportunityId=:recordIdOpp and crm_lineItemsGroupId__c=:modgrplineItemId ];
//             //   return OppLineList; 
// //   List<OpportunityLineItem> conObjList = [select id,Name,crm_Product_Name__c,crm_lineItemsGroupId__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c from OpportunityLineItem where Id=:rowId];
// String grpLineItemIdnew= recordIdOpp+ String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
// //   List<OpportunityLineItem> allSerList =[select id,Name,crm_Product_Name__c,crm_lineItemsGroupId__c from OpportunityLineItem where crm_lineItemsGroupId__c=:conObjList[0].crm_lineItemsGroupId__c];
//   for(OpportunityLineItem con:OppLineList){
//       OpportunityLineItem abc=new OpportunityLineItem();
     
//      // abc.Name=con.Name;
//      // abc.crm_Product_Name__c=con.crm_Product_Name__c;
//     //  abc.crm_Actual_Service__r.Name=con.crm_Actual_Service__r.Name;
//     //  abc.crm_Opp_Prod_Type__c=con.crm_Opp_Prod_Type__c;
//       abc.UnitPrice=con.UnitPrice;
//       abc.crm_Discount__c=con.crm_Discount__c;
//       abc.crm_Min_Weight__c=con.crm_Min_Weight__c;
//       abc.crm_Max_Weight__c=con.crm_Max_Weight__c;
//       abc.PricebookEntryId=con.PricebookEntryId;    
//       abc.OpportunityId=recordIdOpp;
//       abc.crm_Actual_Service__c=con.crm_Actual_Service__c;
//       abc.Id=null;
//       abc.crm_lineItemsGroupId__c =grpLineItemIdnew;
//     conObjItem.add(abc);
//   }
//   if(conObjItem.size()>0){
//       try{
//         insert conObjItem;           
//       }
//       catch (Exception exp) {
//           System.debug('Error 8305499228'+exp.getMessage());
//         throw new AuraHandledException(exp.getMessage());

//     }
//   }
//   String recordactualServiceId=actualserviceID.replace('"','');
  
//   return fetchProductConfig(recordactualServiceId,recordId);
// }

@AuraEnabled
public static string updateActualService(Object data) {
    List<OpportunityLineItem> contactsForUpdate = (List<OpportunityLineItem>) JSON.deserialize(
         JSON.serialize(data),
         List<OpportunityLineItem>.class
    );
    try {
        update contactsForUpdate;
        return 'Success: contacts updated successfully';
    }
    catch (Exception e) {
        return 'The following exception has occurred: ' + e.getMessage();
    }
}

//Update the record on OpportuntiyLineItem using Lightning Data Table ends




}


// cloneActualService



    // @AuraEnabled
    // public static List<OpportunityLineItem> deleteActualService(String rowId,String recordId){
    //     List<OpportunityLineItem> conObjItem = new   List<OpportunityLineItem>();
    //   List<OpportunityLineItem> conObjList = [select id,Name,crm_Product_Name__c,crm_lineItemsGroupId__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c from OpportunityLineItem where Id=:rowId];
      
    //   List<OpportunityLineItem> allSerList =[select id,Name,crm_Product_Name__c,crm_lineItemsGroupId__c from OpportunityLineItem where crm_lineItemsGroupId__c=:conObjList.crm_lineItemsGroupId__c];
    //   for(OpportunityLineItem con:conObjList){
    //     conObjItem.add(con);
    //   }
    //   if(conObjItem.size()>0){
    //       try{
    //         delete conObjItem;           
    //       }
    //       catch (Exception exp) {
    //         throw new AuraHandledException(exp.getMessage());
    //     }
    //   }
    //   return fetchOppLineRecord(recordId);
    // }