//Date - 15th jan 2018
//edit services


public with sharing class crm_editServicesControllerLightning {
    
    @AuraEnabled
    public static List<opportunitylineitem> getOpportunityServices(String oppId){
        List<opportunitylineitem> oppLineItems = new List<opportunitylineitem> ();
        oppLineItems=  [Select id,crm_Actual_Service__c,Product2Id, Product2.Name,IsPayerReceiverorSender__c,crm_Minimum_Price__c,crm_Terminals__c, crm_Minimum_PricePercent__c,crm_Unit_Price__c,Discount, Description, ListPrice, OpportunityId, ProductCode, Quantity ,UnitPrice,Subtotal,crm_Agreed_Item_Price__c,crm_Discount__c, crm_Price_List_Business_Delivery__c  ,crm_Conversion_Factor__c, crm_Direction__c,PricebookEntryId, crm_Local__c , crm_Passive_return__c   from opportunitylineitem where opportunityId = :oppId];
        System.debug('###LineItems' + oppLineItems);
        return oppLineItems;
    }
    
    
    @AuraEnabled
    public static List<opportunitylineitem> editOpportunity(String oppLineitemId){
        List<opportunitylineitem> oppLineItem= [Select id,crm_Max_Weight__c, crm_Min_Weight__c, crm_Free_Pickup__c,IsPayerReceiverorSender__c, crm_lineItemsGroupId__c,crm_Actual_Service__c,Product2Id, Product2.Name,crm_Minimum_Price__c,crm_Terminals__c, crm_Minimum_PricePercent__c,crm_Unit_Price__c,Discount,crm_Price_Unit__c ,Description, ListPrice, OpportunityId, ProductCode, Quantity ,UnitPrice,Subtotal,crm_Agreed_Item_Price__c,crm_Discount__c, crm_Price_List_Business_Delivery__c  ,crm_Conversion_Factor__c, crm_Direction__c,PricebookEntryId, crm_Local__c, crm_Passive_return__c    from opportunitylineitem where Id = :oppLineitemId];
        
    /*   
        if(oppLineItem[0].crm_Actual_Service__c!=null) {  //means user has edited  additional services  //get the acctual servive
            oppLineItem=[Select id,crm_Actual_Service__c,Product2Id, Product2.Name,crm_Minimum_Price__c,crm_Terminals__c, crm_Minimum_PricePercent__c,crm_Unit_Price__c,Discount, crm_Price_Unit__c,Description, ListPrice, OpportunityId, ProductCode, Quantity ,UnitPrice,Subtotal,crm_Agreed_Item_Price__c,crm_Discount__c, crm_Price_List_Business_Delivery__c  ,crm_Conversion_Factor__c, crm_Direction__c,PricebookEntryId, crm_Local__c   from opportunitylineitem where Product2Id = :oppLineItem[0].crm_Actual_Service__c ];
            
        }*/
         
        return oppLineItem;    
        
    }
    
    @AuraEnabled
    public static List<opportunitylineitem> getAdditionalServices(String oppLineitemId){
       System.debug('@@@oppLineitemId'+ oppLineitemId);   
        OpportunityLineItem  oppLineItem = [Select Id,crm_lineItemsGroupId__c, crm_Actual_Service__c, Product2Id  from OpportunityLineItem where id=:oppLineitemId];    
      
         List<opportunitylineitem> additionaloppLineItem = new List<opportunitylineitem>();
       // if(oppLineItem.crm_Actual_Service__c==null) {   //means user has ckicked on main services
            additionaloppLineItem=[Select Id,crm_lineItemsGroupId__c, crm_Actual_Service__c,Product2Id, Product2.Name,crm_Passive_return__c ,crm_Minimum_Price__c,crm_Terminals__c, crm_Minimum_PricePercent__c,crm_Unit_Price__c,Discount,crm_Price_Unit__c, Description, ListPrice, OpportunityId, ProductCode, Quantity ,UnitPrice,Subtotal,crm_Agreed_Item_Price__c,crm_Discount__c, crm_Price_List_Business_Delivery__c  ,crm_Conversion_Factor__c, crm_Direction__c,PricebookEntryId, crm_Local__c   from opportunitylineitem where crm_lineItemsGroupId__c = :oppLineItem.crm_lineItemsGroupId__c and crm_Actual_Service__c!=null];
           
       // }
        
     /* else {
            //means user has edited  additional  service
            additionaloppLineItem= [Select Id,crm_Actual_Service__c,Product2Id, Product2.Name,crm_Minimum_Price__c,crm_Terminals__c, crm_Minimum_PricePercent__c,crm_Unit_Price__c,Discount,crm_Price_Unit__c, Description, ListPrice, OpportunityId, ProductCode, Quantity ,UnitPrice,Subtotal,crm_Agreed_Item_Price__c,crm_Discount__c, crm_Price_List_Business_Delivery__c  ,crm_Conversion_Factor__c, crm_Direction__c,PricebookEntryId, crm_Local__c   from opportunitylineitem where crm_Actual_Service__c = :oppLineItem.crm_Actual_Service__c];
           

        }*/
        
        system.debug('!!!additionaloppLineItem'+ additionaloppLineItem);
        return additionaloppLineItem;    
        
    }
    @AuraEnabled
    public static crm_Dynamic_Columns_Add_Opp_Services__c[] getActualServicesData(String oppLineitemId){
        System.debug('##'+ oppLineitemId); 
        OpportunityLineItem  oppLineItem = [Select id, OpportunityId  from OpportunityLineItem where id=:oppLineitemId];
        System.debug('##'+ oppLineItem);
        Opportunity Opp =[Select id, crm_Opp_Service_Family__c from Opportunity where id=:oppLineItem.OpportunityId];
        System.debug('##'+ Opp);
        
        Map<String,crm_Dynamic_Columns_Add_Opp_Services__c> data = crm_Dynamic_Columns_Add_Opp_Services__c.getAll();
        List<crm_Dynamic_Columns_Add_Opp_Services__c> cols = new List<crm_Dynamic_Columns_Add_Opp_Services__c>();
        for(crm_Dynamic_Columns_Add_Opp_Services__c d : data.values()){
            if(d.crm_Service_Family__c == Opp.crm_Opp_Service_Family__c && d.crm_Service_Type__c =='Actual Service'){
                cols.add(d);
            }
        }
        
        System.debug('##'+ cols);
        return cols;      
    }
    
    @AuraEnabled
    public static crm_Dynamic_Columns_Add_Opp_Services__c[] getAdditionalServicesData(String oppLineitemId){
        System.debug('##'+ oppLineitemId); 
        OpportunityLineItem  oppLineItem = [Select id, OpportunityId  from OpportunityLineItem where id=:oppLineitemId];
        System.debug('##'+ oppLineItem);
        Opportunity Opp =[Select id, crm_Opp_Service_Family__c from Opportunity where id=:oppLineItem.OpportunityId];
        System.debug('##'+ Opp);
        
        
        Map<String,crm_Dynamic_Columns_Add_Opp_Services__c> data = crm_Dynamic_Columns_Add_Opp_Services__c.getAll();
        List<crm_Dynamic_Columns_Add_Opp_Services__c> cols = new List<crm_Dynamic_Columns_Add_Opp_Services__c>();
        for(crm_Dynamic_Columns_Add_Opp_Services__c d : data.values()){
            if(d.crm_Service_Family__c == Opp.crm_Opp_Service_Family__c && d.crm_Service_Type__c !='Actual Service'){
                cols.add(d);
            }
        }
        
        System.debug('##'+ cols);
        return cols;      
    }
    
    //list oopplineitems -. columns
    //cobversion factor
    //
    
    @AuraEnabled
    public static Map<String, String> getConversionFactor()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  OpportunityLineItem.crm_Conversion_Factor__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug('###'+ple);
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        System.debug('###'+options);
        return options;
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
    
    @AuraEnabled
    public static Map<String, String> getDirection()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  OpportunityLineItem.crm_Direction__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug('###'+ple);
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        System.debug('###'+options);
        return options;
    }
    
    @AuraEnabled
    public static Map<String, String> getLocal()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  OpportunityLineItem.crm_Local__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug('###'+ple);
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        System.debug('###'+options);
        return options;
    }
    
    @AuraEnabled
    public static Map<String, String> getPriceList()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  OpportunityLineItem.crm_Price_List_Business_Delivery__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug('###'+ple);
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        System.debug('getPriceList###'+options);
        return options;
    }
    @AuraEnabled
    public static Map<String, String> getPriceUnit()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  OpportunityLineItem.crm_Price_Unit__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug('###'+ple);
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        System.debug('###'+options);
        return options;
    }
    @AuraEnabled
    public static Map<String, String> getTerminal()
    {
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  OpportunityLineItem.crm_Terminals__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug('###'+ple);
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        System.debug('###'+options);
        return options;
    }
    
    @AuraEnabled
    public static Map<String, String> getIsPayerReceiverorSender()
    {
        Map<String, String> options = new Map<String, String>();
        System.debug('### Entered getIsPayerReceiverorSender------'+options);
       //Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult =  OpportunityLineItem.IsPayerReceiverorSender__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug('### getIsPayerReceiverorSender----------------- '+ple);
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getLabel(), f.getValue());
        }  
        System.debug('getIsPayerReceiverorSender options-----------'+options);
        return options;
    }
    
    
  /*  @AuraEnabled
    public static List<OpportunityLineItem> editOpportunitylineitem (String opplineitemId, String conversionFactor, String direction,Decimal  minpricepercentvalue, Decimal Minpricevalue, Decimal discountvalue, String pricelist,Decimal unitpricevalue, String priceunit , String terminal, String local){
        List<OpportunityLineItem> lineitemslist=  new List<OpportunityLineItem>();
        OpportunityLineItem newLine= new OpportunityLineItem();
        newLine.id = opplineitemId;
        newLine.crm_Conversion_Factor__c = conversionFactor;
        newLine.crm_Direction__c = direction;
        newLine.crm_Minimum_PricePercent__c= minpricepercentvalue;
        newLine.crm_Minimum_Price__c= Minpricevalue;
        newLine.crm_Discount__c = discountvalue;
        newLine.crm_Price_List_Business_Delivery__c=pricelist;
        
        newLine.crm_Unit_Price__c= unitpricevalue;
        System.debug('##priceunit'+priceunit);
        newLine.crm_Price_Unit__c = priceunit;
        newLine.crm_Terminals__c = terminal;
        newLine.crm_Local__c= local;
        lineitemslist.add(newLine);
        update lineitemslist;
        return lineitemslist;
      
    }*/
    
    @AuraEnabled
    public static List<Opportunitylineitem> getAddservices(String oppLineitemId){
        System.debug('%%%' + oppLineitemId);
        
         List<opportunitylineitem> oppLineItem= [Select Id,crm_Actual_Service__c,Product2Id, Product2.Name,crm_Minimum_Price__c,crm_Terminals__c, crm_Minimum_PricePercent__c,crm_Unit_Price__c,Discount,crm_Price_Unit__c ,Description, ListPrice, OpportunityId, ProductCode, Quantity ,UnitPrice,Subtotal,crm_Agreed_Item_Price__c,crm_Discount__c, crm_Price_List_Business_Delivery__c  ,crm_Conversion_Factor__c, crm_Direction__c,PricebookEntryId, crm_Local__c, crm_Passive_return__c    from opportunitylineitem where Id = :oppLineitemId];
         System.debug('%%%' + oppLineItem);
       return oppLineItem;
    }
    
    @AuraEnabled
    public static String updateLineItems(String json){
        
        System.debug('&&&&json'+ json);
        
        crm_addServicesWrapper wrapper = crm_addServicesWrapper.parse(json);
          System.debug('&&&&wrapper'+ wrapper);
        List<OpportunityLineItem> lineADDList = new List<OpportunityLineItem>();
        
         OpportunityLineItem lineAS = new OpportunityLineItem();
        if(String.isNotBlank(wrapper.asId))
            lineAS.id = wrapper.asId;
        if(String.isNotBlank(wrapper.conversionfactor))
            lineAS.crm_Conversion_Factor__c = wrapper.conversionfactor;
        if(String.isNotBlank(wrapper.discount))    
            lineAS.crm_Discount__c = Decimal.valueOf(wrapper.discount);
        else 
              lineAS.crm_Discount__c = null;
         if(String.isNotBlank(wrapper.unitprice))    
            lineAS.UnitPrice= Decimal.valueOf(wrapper.unitprice);
        else
            lineAS.UnitPrice= null;
        
          if(String.isNotBlank(wrapper.minweight))    
            lineAS.crm_Min_Weight__c= Decimal.valueOf(wrapper.minweight);
        else 
             lineAS.crm_Min_Weight__c= null;
            
        if(String.isNotBlank(wrapper.maxweight))    
            lineAS.crm_Max_Weight__c= Decimal.valueOf(wrapper.maxweight);
        else
          lineAS.crm_Max_Weight__c= null;
        
        if(String.isNotBlank(wrapper.freepickup))    
            lineAS.crm_Free_Pickup__c = Boolean.valueOf (wrapper.freepickup);
            
        if(String.isNotBlank(wrapper.passiveReturn))    
            lineAS.crm_Passive_Return__c = wrapper.passiveReturn;
      
        
        
        if(String.isNotBlank(wrapper.direction))
            lineAS.crm_Direction__c = wrapper.direction;
        
        if(String.isNotBlank(wrapper.isPayerReceiverorSender))
            lineAS.IsPayerReceiverorSender__c = wrapper.isPayerReceiverorSender;
        
        if(String.isNotBlank(wrapper.minimumprice))
            lineAS.crm_Minimum_Price__c = Decimal.valueOf(wrapper.minimumprice);
        else
           lineAS.crm_Minimum_Price__c =null;
        
        if(String.isNotBlank(wrapper.minimumpricepercent))
            lineAS.crm_Minimum_PricePercent__c = Decimal.valueOf(wrapper.minimumpricepercent);
        else
            lineAS.crm_Minimum_PricePercent__c= null; 
       /* if(String.isNotBlank(wrapper.oppId))
            lineAS.OpportunityId = wrapper.oppId;*/
        if(String.isNotBlank(wrapper.terminals))
            lineAS.crm_Terminals__c = wrapper.terminals;      
        if(String.isNotBlank(wrapper.unitprice))
            lineAS.crm_Unit_Price__c = Decimal.valueOf(wrapper.unitprice);
        if(String.isNotBlank(wrapper.priceunit))
            lineAS.crm_Price_Unit__c = wrapper.priceunit;
        if(String.isNotBlank(wrapper.local))
            lineAS.crm_Local__c = wrapper.local;                
        lineAddList.add(lineAS);
        //update additional services 
        for(Integer i=0;i<wrapper.additionalServices.size();i++) {
            OpportunityLineItem lineADD = new OpportunityLineItem();
            lineAdd.id = wrapper.additionalServices[i].productId;
           
            if(String.isNotBlank(wrapper.additionalServices[i].discountAddSer))    
                lineADD.crm_Discount__c = Decimal.valueOf(wrapper.additionalServices[i].discountAddSer);
            else
                lineADD.crm_Discount__c = null;
           
           
            if(String.isNotBlank(wrapper.additionalServices[i].unitPriceAddSer))
                lineADD.crm_Unit_Price__c = Decimal.valueOf(wrapper.additionalServices[i].unitPriceAddSer);
            else
                 lineADD.crm_Unit_Price__c = null;
            
          if(String.isNotBlank(wrapper.passiveReturn))    
            lineADD.crm_Passive_Return__c = wrapper.passiveReturn;
           System.debug('##lineAdd' +lineAdd)    ;     
            lineAddList.add(lineAdd);        
        }
        
         String rVal = null;
        try{
            update lineAddList;
            rval = 'done';
        }Catch(DMLException e) {
            System.debug(e);
            crm_Exception_handler.createExceptionRecords(e);
            rVal = 'Sorry..Something went wrong. Error: ' + e.getMessage();
        }Catch(Exception g) {
            System.debug(g);
            crm_Exception_handler.createExceptionRecordsAnyType(g,wrapper.oppId);
            rVal = 'Sorry..Something went wrong. Error: ' + g.getMessage();
        }
        return rVal; 
    }
    
    
}