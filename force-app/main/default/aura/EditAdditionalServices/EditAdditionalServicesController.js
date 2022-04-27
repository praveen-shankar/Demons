({
    doInit : function(component, event, helper) {
        helper.getAdditionalServicescolumns(component, event);
        helper.getAdditionalServicesdata(component,event);
        /*helper.loadConversionFactor(component,event);
        helper.loadDirection(component,event);
        helper.loadLocal(component,event);
        helper.loadPriceList(component,event);
        helper.loadPriceUnit(component,event);
        helper.loadTerminal(component,event);*/
        helper.getAdditionalServices(component,event);
       
    },
    
    SaveEvent : function(component, event, helper) {
        helper.saveAction(component, event)
        
    },
    closeQuickAction: function(component, event, helper) {
        helper.closeQuickActionHelper(component, event);
    },
    
    back: function(component, event, helper) {
        helper.backAction(component, event);
        
    },
    captureadditionalservicesdata : function(cmp,event,helper) {
        var robj = {};
        var unitprice= cmp.find("crm_Unit_Price__c");
        var unitpricevalue=unitprice.get("v.value"); 
                    
        var discount= cmp.find("crm_Discount__c");
        var discountvalue=discount.get("v.value"); 
       
        
        robj.unitPriceAddSer =unitpricevalue; 
        robj.discountAddSer = discountvalue;
        robj.productId = cmp.get("v.oppaddLineitemId");
        
        return robj;
    },
       trackInputDiscount: function(cmp, event, helper) {
        var unitpricefield = cmp.find("crm_Unit_Price__c");
          
        if (!$A.util.isEmpty(cmp.get("v.additionalService[0].crm_Discount__c"))) {
            cmp.set("v.additionalService[0].crm_Unit_Price__c", '');
        	unitpricefield.set("v.disabled", true);
            //cmp.set("v.additionalService[0].crm_Unit_Price__c",cmp.clearReference("v.additionalService[0].crm_Unit_Price__c")); 
        } else {
            unitpricefield.set("v.disabled", false);
        }
           
               
    },
    trackInputUnitPrice: function(cmp, event, helper) {
       
        var discountfield = cmp.find("crm_Discount__c");
           
        if (!$A.util.isEmpty(cmp.get("v.additionalService[0].crm_Unit_Price__c"))) {
            cmp.set("v.additionalService[0].crm_Discount__c", '');
            discountfield.set("v.disabled", true);
           // cmp.set("v.additionalService[0].crm_Discount__c",cmp.clearReference("v.additionalService[0].crm_Discount__c")); 
            //cmp.set("v.additionalService[0].crm_Discount__c", -1);
        } else {
            discountfield.set("v.disabled", false);
        }
    },
      
     
})