//Author: Rajeev Shekhar
//Agreement master phase 2
//Used by CustomViewOpportunityServices lightning component

public with sharing class crm_customOpportunityServicesView{

    @AuraEnabled
    public static List<OpportunityServiceWrapper> getLineItems(String oppId){
        List<OpportunityServiceWrapper> wrapper = new List<OpportunityServiceWrapper>();
        Map<String,List<OpportunityLineItem>> amap = new Map<String,List<OpportunityLineItem>>();
        
        Opportunity opp = [SELECT Id, Name, StageName, Type, AccountId, CurrencyIsoCode, Account.Name From Opportunity Where Id = :oppId];
        OpportunityLineItem[] allitems = [Select Id,crm_Product_Name__c,UnitPrice,OpportunityId,Opportunity.CurrencyIsoCode,crm_Actual_Service__c,crm_Actual_Service__r.Name,crm_Actual_Service__r.ProductCode,crm_Discount__c,Product2.Name,Product2.crm_ERP_Product_ID__c,
                                          crm_Conversion_Factor__c,crm_ProductCode__c,crm_Direction__c,crm_Item_Type__c,crm_lineItemsGroupId__c,crm_Local__c,crm_Minimum_Price__c,crm_Minimum_PricePercent__c,Product2.crm_Service_Type__c,crm_Discount_text__c,
                                          crm_Free_Pickup__c,IsPayerReceiverorSender__c,crm_Passive_return__c ,crm_Max_Weight__c,crm_Min_Weight__c,
                                          crm_Opp_Prod_Type__c,crm_Record_URL__c,crm_Price_Unit__c,crm_Terminals__c,crm_Unit_Price__c,crm_Actual_Service__r.crm_ERP_Product_ID__c,crm_Actual_Service__r.crm_Service_Type__c
                                          From OpportunityLineItem
                                          Where OpportunityId = :oppId Order by CreatedDate DESC];        
        
        for(OpportunityLineItem o : allitems){
           if(o.crm_Actual_Service__c != null && o.crm_lineItemsGroupId__c != null && o.Product2.crm_Service_Type__c != 'Actual Service'){ 
               if(!amap.containsKey(o.crm_lineItemsGroupId__c))
                   amap.put(o.crm_lineItemsGroupId__c,new List<OpportunityLineItem>{o});
               else
                   amap.get(o.crm_lineItemsGroupId__c).add(o);
           }             
        }
        
        for(OpportunityLineItem ol : allitems){
            if(ol.crm_Actual_Service__c == null && ol.Product2.crm_Service_Type__c == 'Actual Service'){
                if(amap.containsKey(ol.crm_lineItemsGroupId__c))    
                    wrapper.add(new OpportunityServiceWrapper(ol,amap.get(ol.crm_lineItemsGroupId__c),opp));
                else
                    wrapper.add(new OpportunityServiceWrapper(ol,null,opp));
            }
        }
        
    return wrapper;
    }
    
    @AuraEnabled
    public static List<Product2> getVASandSurcharges(String asId){
        Set<Id> ids = new Set<Id>();
        for(crm_Product_Relationship__c prs : [Select Id, Actual_service__c, Surcharge__c, VAS__c From crm_Product_Relationship__c Where Actual_service__c = :asId]){
            if(prs.Surcharge__c != null)
                ids.add(prs.Surcharge__c);
            if(prs.VAS__c != null)
                ids.add(prs.VAS__c);
        }

       return [Select Id, ProductCode, IsActive, Name, crm_ERP_Product_ID__c, crm_global_Service_Area__c, crm_global_Service_Family__c, crm_global_Service_Group__c, crm_Service_Type__c
               From Product2 Where Id IN :ids And IsActive = true And crm_New_Service__c= true Order by Name ASC];   
    }
    
    @AuraEnabled
    public static String addLineItem(Map<String,String> attributes){
        String returnValue = null;
        if(attributes.containsKey('actualServiceId')){
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.crm_Actual_Service__c = attributes.get('actualServiceId');
            if(attributes.containsKey('oppId'))
                oli.OpportunityId = attributes.get('oppId');    
            if(attributes.containsKey('UnitPrice'))    
                oli.crm_Unit_Price__c = Decimal.valueOf(attributes.get('UnitPrice'));
            if(attributes.containsKey('additionalServiceId')){
                Opportunity opp = [Select Id, Pricebook2Id, CurrencyISOCode from Opportunity Where Id = :attributes.get('oppId') Limit 1];    
                PriceBookEntry[] pbentry = [Select Id,Product2Id From PriceBookEntry where Product2Id = :attributes.get('additionalServiceId') 
                                          and Pricebook2Id = :opp.Pricebook2Id And CurrencyIsoCode = :opp.CurrencyIsoCode Limit 1];
                oli.Product2Id = attributes.get('additionalServiceId');
                if(pbentry.size() > 0)
                oli.PriceBookEntryId = pbentry[0].Id;
            }    
            if(attributes.containsKey('Discount'))    
                oli.crm_Discount__c = Decimal.valueOf(attributes.get('Discount'));
            if(attributes.containsKey('groupId'))    
                oli.crm_lineItemsGroupId__c = attributes.get('groupId');
            try{
                insert oli;
                returnValue = 'done';
            }Catch(Exception e){
                returnValue = e.getMessage();
            }
            
        }else {
            returnValue = 'NO_ACTUAL_SERVICE_CONNECTED_TO_ADDITIONAL_SERVICE';
        }    
    return returnValue;
    }
    
    @AuraEnabled
    public static String deleteLineItems(List<String> ids){
        String returnValue = null;
        if(ids.size() > 0){
            try{
                delete [Select Id From OpportunityLineItem Where Id In :ids];
                returnValue = 'done';
            }Catch(Exception e){
                returnValue = e.getMessage();
            }
        }
       return returnValue; 
    }
    
    @AuraEnabled
    public static String cloneLineItems(String gId){
        List<sObject> cloned = new List<sObject>();
        String returnValue = null;
        String grId = null;
        
        OpportunityLineItem[] allitems = [Select Id,PriceBookEntryId,UnitPrice,crm_Product_Name__c,OpportunityId,crm_Actual_Service__c,crm_Actual_Service__r.Name,crm_Actual_Service__r.ProductCode,crm_Discount__c,Product2.Name,Product2.crm_ERP_Product_ID__c,
                                  crm_Conversion_Factor__c,crm_ProductCode__c,crm_Direction__c,crm_Item_Type__c,crm_lineItemsGroupId__c,crm_Local__c,crm_Minimum_Price__c,crm_Minimum_PricePercent__c,Product2.crm_Service_Type__c,crm_Max_Weight__c,crm_Min_Weight__c,
                                  crm_Opp_Prod_Type__c,crm_Record_URL__c,crm_Price_Unit__c,crm_Terminals__c,crm_Unit_Price__c,crm_Actual_Service__r.crm_ERP_Product_ID__c,crm_Actual_Service__r.crm_Service_Type__c
                                  From OpportunityLineItem
                                  Where crm_lineItemsGroupId__c = :gId];
        
        for(OpportunityLineItem o : allitems){
            if(o.Product2.crm_Service_Type__c == 'Actual Service'){
                grId = o.Id + String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));    
            }
        }
                                                                    
        for(OpportunityLineItem o : allitems){
            sObject sobj = o.clone(false,false,false,false);
            sobj.put('crm_lineItemsGroupId__c',grId);
            cloned.add(sobj);
        }                          
        
        try{
            insert cloned;
            String newid = null;
            for(sObject o : cloned){
                OpportunityLineItem op = (OpportunityLineItem) o;
                if(op.Product2.crm_Service_Type__c == 'Actual Service'){
                    newid = op.Id;
                    break;
                }    
            }
            returnValue = 'done-'+newid;
        }Catch(Exception e){
            returnValue = e.getMessage();
        }
                                      
     return returnValue;
    }
    
    public class OpportunityServiceWrapper{
        @AuraEnabled public OpportunityLineItem actualservice;
        @AuraEnabled public List<OpportunityLineItem> additionalServices;
        @AuraEnabled public Opportunity opportunityDetail;
        
        public OpportunityServiceWrapper(OpportunityLineItem actualservice,List<OpportunityLineItem> additionalServices,Opportunity opportunityDetail){
            this.actualservice = actualservice;
            this.additionalServices = additionalServices;
            this.opportunityDetail = opportunityDetail;
        }
    }

}