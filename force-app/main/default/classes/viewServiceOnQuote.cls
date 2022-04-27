public with sharing class viewServiceOnQuote {

    @AuraEnabled(cacheable=true)
    public static List<QuoteLineItem> fetchOppLineRecord(String recordId){

   
   
    String recordIdOpp=recordId.replace('"','');

  
        // List<OpportunityLineItem> OppLineList = [select Id,crm_Actual_Service__c,crm_Product_Name__c,crm_lineItemsGroupId__c from QuoteLineItem where OpportunityId=:recordIdOpp and crm_Opp_Prod_Type__c='Actual Service'];      
        List<quoteLineItem> OppLineList =   [select id,QuoteId,Product2Id, OpportunityLineItem.crm_Actual_Service__c,OpportunityLineItem.crm_Product_Name__c,ProductNamefromOppLineItem__c,Group_Line_Item_Id__c,Product_Name__c,OpportunityLineItem.crm_lineItemsGroupId__c,OpportunityLineItem.crm_Opp_Prod_Type__c,Product_Type__c from QuoteLineItem where QuoteId=:recordIdOpp and Product_Type__c ='Actual Service'];
        Set<String> abc=new Set<String>();
        List<QuoteLineItem> OppUpdated =new List<QuoteLineItem>();

         for(QuoteLineItem a : OppLineList){
        
             if(!abc.contains(a.Product_Name__c)){
            
        abc.add(a.Product_Name__c);
        OppUpdated.add(a);
      }

  

      System.debug('8305499 OppUpdated'+OppUpdated );
    
                }

                return OppUpdated;
            }


      //Method to fetch all the related product configuration
        @AuraEnabled(cacheable=true)
    public static List<quoteLineItem> fetchProductConfig(String recordId,String actualServiceId){
    String modifiedactualServiceId=actualServiceId.replace('"','');
    String recordIdOpp=recordId.replace('"','');
        // List<OpportunityLineItem> OppLineList = [select id,Name,crm_Actual_Service__c,crm_Product_Name__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c,crm_Min_Weight__c,crm_Max_Weight__c,crm_lineItemsGroupId__c from OpportunityLineItem where  OpportunityId=:recordIdOpp and crm_Actual_Service__c=:modifiedactualServiceId and crm_Opp_Prod_Type__c='Actual Service'];      
        
        // List<quoteLineItem> OppLineList = [select Id,OpportunityLineItem.crm_Actual_Service__c,opportunityLineItem.crm_Product_Name__c,ProductNamefromOppLineItem__c,opportunityLineItem.crm_lineItemsGroupId__c, opportunityLineItem.crm_Opp_Prod_Type__c,opportunityLineItem.UnitPrice,opportunityLineItem.crm_Discount__c,opportunityLineItem.crm_Min_Weight__c,opportunityLineItem.crm_Max_Weight__c from quoteLineItem where QuoteId=:recordIdOpp and OpportunityLineItem.crm_Actual_Service__c=:modifiedactualServiceId and opportunityLineItem.crm_Opp_Prod_Type__c='Actual Service'];      

        List<quoteLineItem> OppLineList = [select Id,OpportunityLineItem.crm_Actual_Service__c,opportunityLineItem.crm_Product_Name__c,crm_Conversion_Factor__c,crm_Terminals__c,IsPayerReceiverorSender__c,Passive_Return__c,crm_Local__c,crm_Free_PickUp__c,crm_Minimum_Price__c,ProductNamefromOppLineItem__c,Group_Line_Item_Id__c,crm_Direction__c,OpportunityLineItem.crm_lineItemsGroupId__c, Product_Type__c,UnitPrice,Discount,crm_Min_Weight__c,	crm_Max_Weight__c from quoteLineItem where QuoteId=:recordIdOpp and Product2Id=:modifiedactualServiceId and Product_Type__c='Actual Service'];      
        
        // select id,OpportunityLineItem.crm_Actual_Service__c,opportunityLineItem.crm_Product_Name__c,ProductNamefromOppLineItem__c,opportunityLineItem.crm_Opp_Prod_Type__c,opportunityLineItem.UnitPrice,opportunityLineItem.crm_Discount__c,opportunityLineItem.crm_Min_Weight__c,opportunityLineItem.crm_Max_Weight__c from quoteLineItem where QuoteId=:recordIdOpp and OpportunityLineItem.crm_Actual_Service__c=:modifiedactualServiceId and crm_Opp_Prod_Type__c='Actual Service']
        return OppLineList; 

    }      

@AuraEnabled(Cacheable=true)
public static List<quoteLineItem> fetchOpportunityRecordId(String recordId){
  try {
    String recordIdOpp=recordId.replace('"','');
   
    List<quoteLineItem> OppLineList = [select id, OpportunityId__c from QuoteLineItem where QuoteId =:recordIdOpp];
  
    return OppLineList; 
  } catch (Exception e) {
    throw new AuraHandledException(e.getMessage());
  }
}

    @AuraEnabled(cacheable=true)
    public static List<QuoteLineItem> fetchOppLineRecordAdditionalService(String grplineItemId,String recordId){
    String recordIdOpp=recordId.replace('"','');
    String modgrplineItemId=grplineItemId.replace('"','');
        // List<OpportunityLineItem> OppLineList = [select id,Name,crm_Product_Name__c,crm_Actual_Service__r.Name,crm_Opp_Prod_Type__c,UnitPrice,crm_Discount__c,crm_Min_Weight__c,crm_Max_Weight__c from OpportunityLineItem where OpportunityId=:recordIdOpp and crm_lineItemsGroupId__c=:modgrplineItemId and (crm_Opp_Prod_Type__c='Surcharge' or crm_Opp_Prod_Type__c='VAS')];
        List<QuoteLineItem> OppLineList = [select id,Product2Id,	Product_Name__c,ProductNamefromOppLineItem__c,Group_Line_Item_Id__c,Product_Type__c,UnitPrice,Discount,crm_Min_Weight__c,crm_Max_Weight__c from quoteLineItem where QuoteId=:recordIdOpp and Group_Line_Item_Id__c=:modgrplineItemId and (Product_Type__c='Surcharge' or Product_Type__c='VAS')];
   
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



    @AuraEnabled
    public static List<QuoteLineItem> deleteActualService(String rowId,String recordId){
      String recordIdOpp=recordId.replace('"','');
      String rowIdnew=rowId.replace('"','');
        List<QuoteLineItem> conObjItem = new   List<QuoteLineItem>();
      List<QuoteLineItem> conObjList = [select id,Product_Name__c,Group_Line_Item_Id__c,OpportunityLineItem.crm_Opp_Prod_Type__c from quotelineitem where Id=:rowIdnew];
      
      List<QuoteLineItem> allSerList =[select id,Product_Name__c,Group_Line_Item_Id__c from QuoteLineItem where Group_Line_Item_Id__c=:conObjList[0].Group_Line_Item_Id__c];
      for(QuoteLineItem con:allSerList){
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
    return  allSerList;
    //   return fetchOppLineRecord(recordId);
    }

    @AuraEnabled
    public static List<QuoteLineItem> cloneActualService(String actualserviceID,String grplineItemId,String recordId){
        List<QuoteLineItem> conObjItem = new   List<QuoteLineItem>();
     
        String recordIdOpp=recordId.replace('"','');
        String modgrplineItemId=grplineItemId.replace('"','');
          // abc.QuoteId=con.id;
            List<QuoteLineItem> OppLineList = [select id,Quantity,QuoteId,Product_Name__c,Product2Id,PricebookEntryId,Product_Type__c,UnitPrice,Discount,crm_Min_Weight__c,crm_Max_Weight__c,Group_Line_Item_Id__c from QuoteLineItem where QuoteId=:recordIdOpp and Group_Line_Item_Id__c=:modgrplineItemId ];
        
        String grpLineItemIdnew= recordIdOpp+ String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
      for(QuoteLineItem con:OppLineList){
        QuoteLineItem abc=new QuoteLineItem();
         
          abc.PricebookEntryId=con.PricebookEntryId;
          abc.QuoteId=con.QuoteId;
          abc.UnitPrice=con.UnitPrice;
          abc.Discount=con.Discount;
          abc.crm_Min_Weight__c=con.crm_Min_Weight__c;
          abc.crm_Max_Weight__c=con.crm_Max_Weight__c;
          abc.Quantity = con.Quantity ;
          
          

          // abc.PricebookEntryId=con.PricebookEntryId;    
          // abc.OpportunityId__c=recordIdOpp;
          // abc.Product2Id=con.Product2Id;
        
          abc.Id=null;
          abc.Group_Line_Item_Id__c =grpLineItemIdnew;
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
      return OppLineList;
    //   return fetchProductConfig(recordactualServiceId,recordId);
    }
}