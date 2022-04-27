({
    doInitHelper: function(component) {
        component.set("v.data", component.clearReference("v.data"));
        var action = component.get("c.getLineItems");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                if ($A.util.isEmpty(response.getReturnValue())) {
                    component.set("v.noservicesadded", true);
                } else {
                    var t2 = performance.now();
                    console.log("Call to server took " + (t2 - t1) + " milliseconds.");
                     console.log("###" + JSON.stringify(response.getReturnValue()));
                    component.set("v.data", response.getReturnValue());
                    component.set("v.noservicesadded", false);
                }
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
        var t1 = performance.now();
        $A.enqueueAction(action);
    },

    handleAddEventHelper: function(component, event) {
        var openmodal = event.getParam("openModal");
        var productId = event.getParam("productId");
        var groupId = event.getParam("groupId");
        component.set("v.childasId", productId);
        component.set("v.childasgroupId", groupId);
        var query = component.get("c.getVASandSurcharges");
        query.setParams({
            asId: productId
        });
        query.setCallback(this, function(response) {
            component.set("v.openModal", openmodal);
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                component.set("v.pdata", response.getReturnValue());
            }
        });


        $A.enqueueAction(query);
    },

    cancelModalHelper: function(component, event) {
        component.set("v.Discount", component.clearReference("v.Discount"));
        component.set("v.UnitPrice", component.clearReference("v.UnitPrice"));
        component.set("v.saveerror", component.clearReference("v.saveerror"));
        component.set("v.openModal", false);
    },

    saveHelper: function(component, event) {
        component.set("v.showspinner", true);
        var saveData = component.get("v.saveData");
        saveData['additionalServiceId'] = component.get("v.selectedValue");
        saveData['actualServiceId'] = component.get("v.childasId");
        saveData['Discount'] = component.get("v.Discount");
        saveData['UnitPrice'] = component.get("v.UnitPrice");
        saveData['oppId'] = component.get("v.recordId");
        saveData['groupId'] = component.get("v.childasgroupId");
        var addItems = component.get("c.addLineItem");
        addItems.setParams({
            attributes: saveData
        });
        addItems.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var resp = response.getReturnValue();
                if (resp == 'done') {
                    component.set("v.showspinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The records have been inserted successfully.",
                        "type": "success"
                    });
                    toastEvent.fire();
                    //component.set("v.openModal",false);
                    this.cancelModalHelper(component, event);
                    $A.get('e.force:refreshView').fire();
                } else if (resp == 'NO_ACTUAL_SERVICE_CONNECTED_TO_ADDITIONAL_SERVICE') {
                    component.set("v.showspinner", false);
                    component.set("v.saveerror", resp);
                    console.log("Response from Server: " + resp);
                } else {
                    component.set("v.showspinner", false);
                    component.set("v.saveerror", resp);
                    console.log("Response from Server: " + resp);
                }

            } else {
                component.set("v.showspinner", false);
                component.set("v.saveerror", 'Please contact System Admin!!');
                console.log("Response from Server: " + response.getReturnValue());
            }
        });
        $A.enqueueAction(addItems);
    },

    selectOnChangeHelper: function(component, event) {
        component.set("v.selectedValue", event.getSource().get("v.value"));
    },
    
    trackInputHelper: function(cmp, event, helper) {
        var unitpricefield = cmp.find("unitprice");
        var discountfield = cmp.find("discount");
        if (!$A.util.isEmpty(cmp.get("v.Discount"))) {
        	unitpricefield.set("v.disabled", true);
        } else {
            unitpricefield.set("v.disabled", false);
        }
        if (!$A.util.isEmpty(cmp.get("v.UnitPrice"))) {
            discountfield.set("v.disabled", true);
        } else {
            discountfield.set("v.disabled", false);
        }
    }
})