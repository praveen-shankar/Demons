({
    handleChange: function(component, event, helper) {
        var changeValue = event.getParam("value");
        component.set("v.recordtypeid", changeValue);
    },

    doInit: function(component, event, helper) {
        var t0 = performance.now();
        var action = component.get("c.getTransactionRecordTypes");
        action.setParams({
            caseid: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                if ($A.util.isEmpty(response.getReturnValue())) {
                    component.set("v.noOptionsFound", true);
                } else {
                    var t1 = performance.now();
                    console.log("Call to server took " + (t1 - t0) + " milliseconds.");
                    component.set("v.options", response.getReturnValue());
                    component.set("v.preselected",response.getReturnValue()[0].value);
                    component.set("v.recordtypeid",response.getReturnValue()[0].value);
                    console.log("Record Types from Apex: " + JSON.stringify(component.get("v.options")));                    
                }
            } else if (state === "INCOMPLETE") {
                component.set("v.recordErrorOnload", response.getReturnValue());
                console.log("The server did not return a response. The server might be down or the client might be offline");
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.recordErrorOnload", response.getReturnValue());
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    cancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },

    next: function(component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Monetary_Transaction__c",
            "recordTypeId": component.get("v.recordtypeid"),
            "defaultFieldValues": {
                'case__c': component.get("v.recordId"),
            }
        });
        $A.get("e.force:closeQuickAction").fire();
        createRecordEvent.fire();
    }
});