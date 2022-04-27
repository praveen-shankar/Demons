/*
Created by :Supriya Goel
Date: 11 feb 2018
Modified by Rajeev Shekhar on 13-11-2018
*/

public class crm_addproducttopricebookHelper{

    public static void addPricebookentries(List<Product2> productList) {
        Set<Id> prodSet  = new Set<Id>();
        Map<Id,Product2> ProdMap = new Map<Id,Product2>(productList);
        List<CurrencyType> currencyCodes = [SELECT ISOCode FROM CurrencyType WHERE IsActive=TRUE];
        Id stdPbId = null;
        if(Test.IsRunningTest()) {stdPbId = Test.getStandardPricebookId();}
        else {stdPbId = [Select Id from Pricebook2 Where IsStandard = true Limit 1].Id;}        
        prodSet = ProdMap.keySet();
        
        //define the standart price for the product
        List<PricebookEntry> PricebookEntryListStd = new List<PricebookEntry>();  
        for(String str : prodSet){                        
            for(CurrencyType c :currencyCodes){        
                PricebookEntry pb= new PricebookEntry();
                pb.Pricebook2Id = stdPbId;
                pb.Product2Id = str;
                pb.UnitPrice = 0;
                pb.IsActive = true;
                pb.CurrencyIsoCode= c.ISOCode;
                PricebookEntryListStd.add(pb);            
            }
        } 
        
        if (PricebookEntryListStd.size() > 0) {
            insert PricebookEntryListStd;
        }    
        
        
        //insert into custom pricebooks        
        List<PricebookEntry> PricebookEntryListCustom = new List<PricebookEntry>(); 
        Map<String,PriceBook2> pb2Map = new Map<String,PriceBook2>();        
        for(PriceBook2 pb2 : [Select Id, Name From PriceBook2 Where isActive = true])
            pb2Map.put(pb2.Name,pb2);
                    
        for(String str : prodSet){        
            String sfName= ProdMap.get(str).crm_global_Service_Family__c; 
            if(String.isNotBlank(sfName)){
                Pricebook2 pricebook = pb2Map.containsKey(sfname) ? pb2Map.get(sfname) : null;                
                if(pricebook != null) {
                    for(CurrencyType c :currencyCodes){            
                        PricebookEntry pb1 = new PricebookEntry();
                        pb1.Pricebook2Id = pricebook.id ;
                        pb1.Product2Id = str;
                        pb1.unitprice = 0;
                        pb1.isActive = true;
                        pb1.CurrencyIsoCode= c.ISOCode;
                        PricebookEntryListCustom.add(pb1);
                    }
                }                             
            }        
        }  
        
        if (PricebookEntryListCustom.size() > 0) {       
            insert PricebookEntryListCustom;
        }            
    }
}