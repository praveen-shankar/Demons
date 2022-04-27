({
    goBack: function(component, event, helper) {
        var pEvent = component.getEvent("progressIndicatorEvent");
        pEvent.setParams({
            "indicatorStep": "step1"
        });
        pEvent.fire();
    },

    goNextPage: function(component, event, helper) {
        var pEvent = component.getEvent("progressIndicatorEvent2");
        pEvent.setParams({
            "indicatorStep": "step3",
            "additionalServiceEditTableColumns": component.get("v.additionalServiceEditTableColumns")
        });
        pEvent.fire();
        component.find('lightningDataTableCmp').captureASdataAuraMethod(component.get("v.selectedActualServiceId"), component.get("v.OpprecordId"));
    },

    generateInputTablesActualService: function(cmp, event, helper) {
        helper.setSelectedProductNameHelper(cmp,event);
        var asColumnDetail = cmp.get("c.getColumnData");
        asColumnDetail.setParams({
            sfamily: cmp.get("v.servicefamily")
        });
        asColumnDetail.setCallback(this, function(response) {
            var callresult;
            var actualServiceColumnsArray = [];
            var vasSurchargeColumnsArray = [];
            var state = response.getState();
            if (state === "SUCCESS" && cmp.isValid()) {
                callresult = response.getReturnValue();
                for (var z = 0; z < callresult.length; z++) {
                    if (callresult[z].crm_Service_Type__c == 'Actual Service') {
                        actualServiceColumnsArray.push(callresult[z]);
                    } else if (callresult[z].crm_Service_Type__c == 'Additional Service') {
                        vasSurchargeColumnsArray.push(callresult[z]);
                    }
                }
                cmp.set("v.actualserviceEditTableColumns", actualServiceColumnsArray);
                cmp.set("v.additionalServiceEditTableColumns", vasSurchargeColumnsArray);
                cmp.set("v.generateInputTablesVar", true);
            }
        });
        $A.enqueueAction(asColumnDetail);
    },

    actualServiceNavigation: function(cmp) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get("v.selectedActualServiceId"),
            "slideDevName": "detail",
            "isredirect": true
        });
        navEvt.fire();
    },

    closeQuickAction: function(cmp, ev) {
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    },
    
    setSelectedProductName: function(cmp, ev, helper) {
        helper.setSelectedProductNameHelper(cmp,event);
    },
    
    disableNextButton: function(cmp, ev, helper) {
        var params = ev.getParams();
        console.log("disable next event params are " + JSON.stringify(params));
        var nextbutton = cmp.find('nextbutton');
        if(params){
            if(params.UnitPriceValidAS || params.minpriceissueAS || params.discountissueAS || params.minweightissueAS || params.maxweightissueAS || params.minweightgreater){
                nextbutton.set("v.disabled",true);
            } else if(nextbutton.get("v.disabled")) {
                nextbutton.set("v.disabled",false);
            }
        }
    }
})