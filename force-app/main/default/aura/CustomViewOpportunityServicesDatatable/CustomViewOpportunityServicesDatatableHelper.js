({
    cloneAction: function(component, event, cAction) {
        component.set("v.showspinner", true);
        var cloneAction = component.get("c.cloneLineItems");
        cloneAction.setParams({
            gId: component.get("v.data.actualservice.crm_lineItemsGroupId__c")
        });
        cloneAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var resp = response.getReturnValue();
                var respArray = resp.split('-');
                if (respArray[0] == 'done') {
                    component.set("v.showspinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The records have been cloned successfully..",
                        "type": "success",
                        "duration": 5000
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    if (cAction === 'cloneedit') {
                        this.editAction(component, event, respArray[1]);
                    }
                } else {
                    component.set("v.showspinner", false);
                    component.set("v.exceptionMessage", resp);
                }
            }
        });
        $A.enqueueAction(cloneAction);
    },
	
    handleRowActionHelper: function(component, event) {
        var row = event.getParam('row');
        var pbody;
        $A.createComponent("c:lightningPopOverAdditionalServices", {
                data: row
            },
            function(content, status) {
                if (status === "SUCCESS") {
                    pbody = content;
                    component.find('overlayLib').showCustomModal({
                        body: pbody,
                        header: "DETAILS",
                        showCloseButton: true,
                        closeCallback: function() {
                        }
                    })
                }
            });
    },
    
    addAction: function(component, event) {
        var ev = component.getEvent("CustomViewOpportunityAddEvent");
        ev.setParams({
            openModal: true,
            productId: component.get("v.data.actualservice.Product2Id"),
            groupId: component.get("v.data.actualservice.crm_lineItemsGroupId__c")
        });
        ev.fire();
    },

    editAction: function(component, event, newId) {
        debugger;
        var passId = $A.util.isUndefinedOrNull(newId) ? component.get("v.data.actualservice.Id") : newId;
       /* var pageReference = {
            type: "standard__component",
            attributes: {
                "componentName": "c__EditServicesforOpportunity"
            },
            state: {
                "recordId": passId
            }
        };
        component.find("navigationService").navigate(pageReference);*/
       // alert(passId);
          var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:EditServicesforOpportunity",
            //You can pass attribute value from Component1 to Component2
            componentAttributes :{   "rid" : passId }
        });
        navigateEvent.fire();
    },


    deleteAction: function(component, event) {
        var deleteIds = component.get("v.idsTodelete");
        if ($A.util.isEmpty(deleteIds)) {
            component.find('notifLib').showNotice({
                "variant": "warning",
                "header": "Attention!",
                "message": "You need to select atleast one record in the table for deletion to happen.",
                closeCallback: function() {

                }
            });
        } else {
            this.deleteHelper(component, event);
        }
    },

    deleteAllAction: function(component, event) {
        var data = component.get("v.data");
        var ids = [];
        for (var key in data) {
            if (key == 'actualservice') {
                ids.push(data[key].Id);
            } else if (key == 'additionalServices') {
                for (var i = 0; i < data[key].length; i++) {
                    ids.push(data[key][i].Id);
                }
            }
        }
        component.set("v.idsTodelete", ids);
        component.set("v.openModal", true);
    },

    viewAction: function(component, event) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.data.actualservice.Id"),
            "slideDevName": "detail"
        });
        navEvt.fire();
    },

    deleteHelper: function(component, event) {
        component.set("v.showspinner", true);
        var deleteAction = component.get("c.deleteLineItems");
        deleteAction.setParams({
            ids: component.get("v.idsTodelete")
        });
        deleteAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var resp = response.getReturnValue();
                if (resp == 'done') {
                    component.set("v.showspinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The records have been deleted successfully.",
                        "type": "success"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                } else {
                    component.set("v.showspinner", false);
                    component.set("v.exceptionMessage", resp);
                }
            }
        });
        $A.enqueueAction(deleteAction);
    },

    qviewAction: function(component, event) {
        var pbody;
        $A.createComponent("c:lightningPopOver", {
                data: component.get("v.data")
            },
            function(content, status) {
                if (status === "SUCCESS") {
                    pbody = content;
                    component.find('overlayLib').showCustomModal({
                        body: pbody,
                        header: "DETAILS",
                        showCloseButton: true,
                        closeCallback: function() {
                        }
                    })
                }
            });
    }
})