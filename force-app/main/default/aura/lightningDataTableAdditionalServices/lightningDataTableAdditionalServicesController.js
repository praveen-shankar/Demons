({
    actionOnLoad: function(cmp, event, helper) {
        var fieldsfromobject = cmp.get("v.actualServiceFields");
        var fieldsarray = [];
        for (var pq in fieldsfromobject) {
            fieldsarray.push(fieldsfromobject[pq].crm_API_Name__c);
        }
        for (var x = 0; x < fieldsarray.length; x++) {
            if (fieldsarray.includes("crm_Unit_Price__c"))
                cmp.set("v.showUnitprice", true);
            if (fieldsarray.includes("crm_Discount__c"))
                cmp.set("v.showDiscount", true);
        }
        var pOptions = cmp.get("c.getPicklistFieldsOptions");
        pOptions.setStorable();
        pOptions.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && cmp.isValid()) {
                cmp.set("v.picklistFieldOptions", response.getReturnValue());
                cmp.set("v.displayPicklistComponent", true);
            } else if (state === "INCOMPLETE") {
                console.log("The server did not return a response. The server might be down or the client might be offline");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(pOptions);
    },

    captureInputValuesAdditionalServices: function(cmp, event, helper) {
        var robj = {};
        robj.unitPriceAddSer = cmp.get("v.crm_Unit_Price__c");
        robj.discountAddSer = cmp.get("v.crm_Discount__c");
        robj.productId = cmp.get("v.productId");
        if(cmp.find('lightningPicklistComponentId')) {
        	robj = cmp.find('lightningPicklistComponentId').captureASdataAuraMethodPicklistAddServ(robj);
        }    
        return robj;
    },

    trackInput: function(cmp, event, helper) {
        var unitpricefield = cmp.find("unitprice");
        var discountfield = cmp.find("discount");
        if (!$A.util.isEmpty(cmp.get("v.crm_Discount__c"))) {
        	unitpricefield.set("v.disabled", true);
        } else {
            unitpricefield.set("v.disabled", false);
        }
        if (!$A.util.isEmpty(cmp.get("v.crm_Unit_Price__c"))) {
            discountfield.set("v.disabled", true);
        } else {
            discountfield.set("v.disabled", false);
        }
    }
})