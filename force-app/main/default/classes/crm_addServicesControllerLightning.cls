//Author - Rajeev Shekhar
//Date - 17-11-2017
//Used by lightning component bundle - addServicesToOpportunity, listOfActualServices


public with sharing class crm_addServicesControllerLightning {
    
    @AuraEnabled
    public static String getCurrentUserProfile(){
        Id profileId=userinfo.getProfileId();
        String profileName = [Select Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName);
        return profileName;
    }
    
    @AuraEnabled
    public static Opportunity getOpportunityDetails(String oppId){
        return [Select Id, Account.Name,AccountId, Account.crm_Organization_number__c, Account.Orga__c, Name, StageName, Type, crm_Opp_Service_Family__c, 
               crm_Opp_Service_Group__c From Opportunity Where Id = :oppId];
    }
    
    @AuraEnabled
    public static List<Product2> getProductsPerFamily(String oppId){
        Opportunity opp = getOpportunityDetails(oppId);
        String sfamily = opp.crm_Opp_Service_Family__c;
        List<Product2> products = new List<Product2>();
        if(String.isNotBlank(sfamily)){
            products = [Select Id, IsActive, Name, crm_New_Service__c, crm_ERP_Product_ID__c, crm_global_Service_Area__c, crm_global_Service_Group__c, crm_global_Service_Family__c, crm_Service_Type__c
                                  From Product2 Where crm_New_Service__c= true And crm_global_Service_Family__c = :sfamily And IsActive = true And crm_Service_Type__c = 'Actual Service' Order By Name ASC];
        }else{
            List<PricebookEntry> pbEntryList = [Select id, Product2Id, Pricebook2Id From PricebookEntry Where Pricebook2.Name =: Label.Combined_PriceBook_Name];
            set<Id> prodIdSet = new set<Id>();
            for(PricebookEntry pbEntry : pbEntryList){
                prodIdSet.add(pbEntry.Product2Id);
            }
            products = [Select Id, IsActive, Name, crm_New_Service__c, crm_ERP_Product_ID__c, crm_global_Service_Area__c, crm_global_Service_Group__c, crm_global_Service_Family__c, crm_Service_Type__c
                                  From Product2 Where Id IN : prodIdSet and crm_Service_Type__c Not IN  ('Surcharge','VAS')  Order By Name ASC];
        }
        
       return products; 
    }
    
    @AuraEnabled
    public static List<Product2> getVASandSurcharges(String asId){
        if(asId != null){
            Set<Id> ids = new Set<Id>();
            for(crm_Product_Relationship__c prs : [Select Id, Actual_service__c, Surcharge__c, VAS__c From crm_Product_Relationship__c Where Actual_service__c = :asId]){
                if(prs.Surcharge__c != null)
                    ids.add(prs.Surcharge__c);
                if(prs.VAS__c != null)
                    ids.add(prs.VAS__c);
            }
    		system.debug('ids:: '+ids);
           return [Select Id, IsActive, ProductCode, Name, crm_ERP_Product_ID__c, crm_global_Service_Area__c, crm_global_Service_Family__c, crm_global_Service_Group__c, crm_Service_Type__c
               From Product2 Where Id IN :ids And IsActive = true And crm_New_Service__c= true Order by crm_Service_Type__c ASC];   
        }
       return null; 
    }
    
    @AuraEnabled
    public static crm_Dynamic_Columns_Add_Opp_Services__c[] getColumnData(String sfamily){
        Map<String,crm_Dynamic_Columns_Add_Opp_Services__c> data = crm_Dynamic_Columns_Add_Opp_Services__c.getAll();
        List<crm_Dynamic_Columns_Add_Opp_Services__c> cols = new List<crm_Dynamic_Columns_Add_Opp_Services__c>();
        
        System.debug(sfamily);
        
       
        for(crm_Dynamic_Columns_Add_Opp_Services__c d : data.values()){
            if(d.crm_Service_Family__c == sfamily){
                cols.add(d);
            }else if(String.isBlank(d.crm_Service_Family__c) && !String.isBlank(d.crm_Service_Type__c)){
                cols.add(d);
            }
        }
        
        System.debug(cols);
       return cols;      
    }
    
    @AuraEnabled
    public static Map<String,List<String>> getPicklistFieldsOptions(){
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.OpportunityLineItem.fields.getMap();
        Map<String,List<String>> fields = new Map<String,List<String>>();
        for(Schema.SObjectField s : fieldMap.values()) {
            Schema.DescribeFieldResult F = s.getDescribe();
            Schema.DisplayType dfr = F.getType();
            if(dfr == Schema.DisplayType.MULTIPICKLIST || dfr == Schema.DisplayType.PICKLIST){
                for(Schema.PicklistEntry val : F.getPicklistValues()){
                    if(!fields.containsKey(F.getName()))
                        fields.put(F.getName(),new List<String>{val.getValue()});
                    else
                        fields.get(F.getName()).add(val.getValue());    
                }
            }
        }
        System.debug('fields------------'+fields);
        
        return fields;
    }
    
    @AuraEnabled
    public static String createLineItems(String json){
        crm_addServicesWrapper wrapper = crm_addServicesWrapper.parse(json);
        Set<Id> productIds = new Set<Id>();
        Map<Id,Id> entrymap = new Map<Id,Id>();
        system.debug('##wrapper'+ wrapper);
        productIds.add(wrapper.asId);
        if(wrapper.additionalServices.size() > 0) {
           for(Integer k=0;k<wrapper.additionalServices.size();k++){ 
                productIds.add(wrapper.additionalServices[k].productId);        
            }
        }
        
         system.debug('##productIds'+ productIds);
        
        String gId = wrapper.asId + String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
        
        Opportunity opp = [Select Pricebook2Id, CurrencyIsoCode From Opportunity Where Id = :wrapper.OppId];
        system.debug('##opp'+ opp);
        PriceBookEntry[] pbentry = [Select Id,Product2Id From PriceBookEntry where Product2Id In :productIds and Pricebook2Id = :opp.Pricebook2Id And CurrencyIsoCode = :opp.CurrencyIsoCode];
        for(PriceBookEntry pb : pbentry) {
            entrymap.put(pb.Product2Id,pb.Id);
        }
        
        system.debug('##entrymap'+ entrymap);
        
        List<OpportunityLineItem> lineADDList = new List<OpportunityLineItem>();
        OpportunityLineItem lineAS = new OpportunityLineItem();
        if(entrymap.containsKey(wrapper.asId))
            lineAS.PriceBookEntryId = entrymap.get(wrapper.asId);
        if(String.isNotBlank(wrapper.freepickup)) {
            if(wrapper.freepickup == 'true')
                lineAS.crm_Free_Pickup__c = true;
            if(wrapper.freepickup == 'false')
                lineAS.crm_Free_Pickup__c = false;    
        }   
        
        
        
          if(String.isNotBlank(wrapper.passiveReturn))
            lineAS.crm_Passive_return__c = wrapper.passiveReturn;
                     
        if(String.isNotBlank(wrapper.conversionfactor))
            lineAS.crm_Conversion_Factor__c = wrapper.conversionfactor;
        if(String.isNotBlank(wrapper.discount))    
            lineAS.crm_Discount__c = Decimal.valueOf(wrapper.discount);
        if(String.isNotBlank(wrapper.asId))
            lineAS.Product2Id = wrapper.asId;
        if(String.isNotBlank(wrapper.direction))
            lineAS.crm_Direction__c = wrapper.direction;
        if(String.isNotBlank(wrapper.standardUnitPrice))
            lineAS.UnitPrice = Decimal.valueOf(wrapper.standardUnitPrice);
        if(String.isNotBlank(wrapper.minimumprice))
            lineAS.crm_Minimum_Price__c = Decimal.valueOf(wrapper.minimumprice);
        if(String.isNotBlank(wrapper.minimumpricepercent))
            lineAS.crm_Minimum_PricePercent__c = Decimal.valueOf(wrapper.minimumpricepercent);
        if(String.isNotBlank(wrapper.oppId))
            lineAS.OpportunityId = wrapper.oppId;
        if(String.isNotBlank(wrapper.terminals))
            lineAS.crm_Terminals__c = wrapper.terminals;
        if(String.isNotBlank(wrapper.agreedItemPrice))
            lineAS.crm_Agreed_Item_Price__c = Decimal.valueOf(wrapper.agreedItemPrice);    
        if(String.isNotBlank(wrapper.estimatedvolume))
            lineAS.crm_Estimated_Volume__c = Decimal.valueOf(wrapper.estimatedvolume);
        if(String.isNotBlank(wrapper.estimatedweight))
            lineAS.crm_Estimated_Weight__c = Decimal.valueOf(wrapper.estimatedweight);            
        if(String.isNotBlank(wrapper.unitprice))
            lineAS.crm_Unit_Price__c = Decimal.valueOf(wrapper.unitprice);
        if(String.isNotBlank(wrapper.priceunit))
            lineAS.crm_Price_Unit__c = wrapper.priceunit;
        if(String.isNotBlank(wrapper.maxweight))
            lineAS.crm_Max_Weight__c = Decimal.valueOf(wrapper.maxweight);
        if(String.isNotBlank(wrapper.minweight))
            lineAS.crm_Min_Weight__c = Decimal.valueOf(wrapper.minweight);  
        if(String.isNotBlank(wrapper.isPayerReceiverorSender))
            lineAS.IsPayerReceiverorSender__c = wrapper.isPayerReceiverorSender;
        if(String.isNotBlank(wrapper.local))
            lineAS.crm_Local__c = wrapper.local;
            lineAS.crm_lineItemsGroupId__c = gId;                
        lineAddList.add(lineAS);
        
        for(Integer i=0;i<wrapper.additionalServices.size();i++) {
            OpportunityLineItem lineADD = new OpportunityLineItem();
            lineADD.crm_Actual_Service__c = wrapper.asId;
            if(entrymap.containsKey(wrapper.additionalServices[i].productId))
                lineADD.PriceBookEntryId = entrymap.get(wrapper.additionalServices[i].productId);
            if(String.isNotBlank(wrapper.additionalServices[i].discountAddSer))    
                lineADD.crm_Discount__c = Decimal.valueOf(wrapper.additionalServices[i].discountAddSer);
            if(String.isNotBlank(wrapper.additionalServices[i].agreedItemPriceAddSer))    
                lineADD.crm_Agreed_Item_Price__c = Decimal.valueOf(wrapper.additionalServices[i].agreedItemPriceAddSer);
            if(String.isNotBlank(wrapper.additionalServices[i].estimatedweightAddSer))    
                lineADD.crm_Estimated_Weight__c = Decimal.valueOf(wrapper.additionalServices[i].estimatedweightAddSer);
            if(String.isNotBlank(wrapper.additionalServices[i].estimatedvolumeAddSer))    
                lineADD.crm_Estimated_Volume__c = Decimal.valueOf(wrapper.additionalServices[i].estimatedvolumeAddSer);            
            if(String.isNotBlank(wrapper.additionalServices[i].terminalsAddSer))
                lineADD.crm_Terminals__c = wrapper.additionalServices[i].terminalsAddSer;    
            if(String.isNotBlank(wrapper.additionalServices[i].productId))
                lineADD.Product2Id = wrapper.additionalServices[i].productId;
            if(String.isNotBlank(wrapper.additionalServices[i].minimumpriceAddSer))
                lineADD.crm_Minimum_Price__c = Decimal.valueOf(wrapper.additionalServices[i].minimumpriceAddSer);
            if(String.isNotBlank(wrapper.additionalServices[i].minimumpricepercentAddSer))
                lineADD.crm_Minimum_PricePercent__c = Decimal.valueOf(wrapper.additionalServices[i].minimumpricepercentAddSer);    
            if(String.isNotBlank(wrapper.oppId))
                lineADD.OpportunityId = wrapper.oppId;
            if(String.isNotBlank(wrapper.additionalServices[i].conversionfactorAddSer))
                lineADD.crm_Conversion_Factor__c = wrapper.additionalServices[i].conversionfactorAddSer;
            if(String.isNotBlank(wrapper.additionalServices[i].directionAddSer))
                lineADD.crm_Direction__c = wrapper.additionalServices[i].directionAddSer;
            if(String.isNotBlank(wrapper.additionalServices[i].localAddSer))
                lineADD.crm_Local__c = wrapper.additionalServices[i].localAddSer;
            if(String.isNotBlank(wrapper.additionalServices[i].isPayerReceiverorSenderAddSer))
            	lineADD.IsPayerReceiverorSender__c = wrapper.additionalServices[i].isPayerReceiverorSenderAddSer;
            if(String.isNotBlank(wrapper.additionalServices[i].priceunitAddSer))
                lineADD.crm_Price_Unit__c = wrapper.additionalServices[i].priceunitAddSer;
            if(String.isNotBlank(wrapper.additionalServices[i].unitPriceAddSer))
                lineADD.crm_Unit_Price__c = Decimal.valueOf(wrapper.additionalServices[i].unitPriceAddSer);
            
           if(String.isNotBlank(wrapper.passiveReturn))
            lineADD.crm_Passive_return__c = wrapper.passiveReturn;
                lineADD.crm_lineItemsGroupId__c = gId;    
            lineAddList.add(lineAdd);        
        }
        
        String rVal = null;
        try{
            if(lineAddList.size()>0)
            	insert lineAddList;
            rval = 'done';
        }Catch(DMLException e) {
            crm_Exception_handler.createExceptionRecords(e);
            rVal = 'Sorry..Something went wrong. Error: ' + e.getMessage();
            if(e.getMessage().contains('Annual Service Value is required for Actual Services')) rval = 'Annual Service Value is required for Actual Services';               
            else if(e.getMessage().contains('Discount cannot be negative')) rval = 'Discount cannot be negative';                
            else if(e.getMessage().contains('Unit Price cannot be negative')) rval = 'Unit Price cannot be negative';                 
            else if(e.getMessage().contains('PricebookEntryId')) rval = 'Please ensure the Services on this Opportunity are configured with the correct Pricebook entries.' + e.getMessage();                           
        }Catch(Exception g) {
            crm_Exception_handler.createExceptionRecordsAnyType(g,opp.Id);
            rVal = 'Sorry..Something went wrong. Error: ' + g.getMessage();
        }
        return rVal;    
    }
    
      @AuraEnabled
    public static Map<String, String> getpassivereturn()
    {
        Map<String, String> options = new Map<String, String>();
        
       Schema.DescribeFieldResult fieldResult =  OpportunityLineItem.crm_Passive_Return__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug('###'+ple);
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        System.debug('###'+options);
        return options;
    }
    
    @TestVisible
    private static String findALLPicklistValues(String terminal){
        List<Schema.PicklistEntry> gd = Schema.getGlobalDescribe().get('opportunitylineitem').getDescribe().fields.getMap().get('crm_terminals__c').getDescribe().getPicklistValues();
        List<String> values = new List<String>();
        for(Schema.PicklistEntry g : gd){
            if(!g.getValue().equalsIgnoreCase('ALL')){
                values.add(g.getValue());
            }    
        }
        if(terminal == 'ALL'){
            return String.join(values,';');
        }
        else{
             return terminal;
        }       
    }

}