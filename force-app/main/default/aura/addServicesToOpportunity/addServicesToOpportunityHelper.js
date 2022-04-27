({
    oppDetailhelper: function(cmp, event) {
        $A.util.addClass(cmp.find("container2"),'slds-hide');
        $A.util.addClass(cmp.find("container3"),'slds-hide');
        var oppdetail = cmp.get("c.getOpportunityDetails");
        oppdetail.setParams({
            oppId: cmp.get("v.recordId")
        });
        oppdetail.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && cmp.isValid()) {
                cmp.set("v.opp", response.getReturnValue());
                cmp.set("v.servicefamily", cmp.get("v.opp.crm_Opp_Service_Family__c"));
                cmp.set("v.partyrecordId", cmp.get("v.opp.AccountId"));
                cmp.set("v.listofactualserviceflag", true);
                if(cmp.get("v.opp").StageName == 'Closed Won'){
                    this.handleShowNoticeHelper(cmp,"Warning: You cannot add services when an Opportunity is already Closed Won!");    
                }
            } else if (state === "INCOMPLETE") {
                console.log("The server did not return a response. The server might be down or the client might be offline");
                this.handleShowNoticeHelper(cmp,"Please refresh and try again");
            } else if (state === "ERROR") {
                var errors = response.getError();
                this.handleShowNoticeHelper(cmp,"Please refresh and try again");
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(oppdetail);
    },
	
    handleShowNoticeHelper : function(component, msg) {
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "Attention",
            "message": msg,
            closeCallback: function() {
                $A.get("e.force:closeQuickAction").fire();
            }
        });
    },
    
    proceedToStepTwoHelper: function(cmp, ev) {
        cmp.find("indicator").set("v.currentStep", "step2");
        cmp.set("v.saveerror", cmp.clearReference("v.saveerror"));
        $A.util.addClass(cmp.find("container1"), 'slds-hide');
        $A.util.addClass(cmp.find("container3"), 'slds-hide');
        $A.util.removeClass(cmp.find("container2"), 'slds-hide');
    },

    proceedToStepThreeHelper: function(cmp, ev) {
        cmp.find("indicator").set("v.currentStep", "step3");
        cmp.set("v.additionalServicesFields", ev.getParam("additionalServiceEditTableColumns"));
        $A.util.addClass(cmp.find("container1"), 'slds-hide');
        $A.util.addClass(cmp.find("container2"), 'slds-hide');
        cmp.set("v.showContainer3", true);
        $A.util.removeClass(cmp.find("container3"), 'slds-hide');
    },

    proceedToStepOneHelper: function(cmp, ev) {
        cmp.find("indicator").set("v.currentStep", ev.getParam("indicatorStep"));
        $A.util.addClass(cmp.find("container2"), 'slds-hide');
        $A.util.addClass(cmp.find("container3"), 'slds-hide');
        $A.util.removeClass(cmp.find("container1"), 'slds-hide');
    },

    orgNavigationHelper: function(cmp) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get("v.partyrecordId"),
            "slideDevName": "detail",
            "isredirect": true
        });
        navEvt.fire();
    },

    handleSelectedActualServiceHelper: function(cmp, event) {
        var results = event.getParams();
        cmp.set("v.selectedActualServiceIdFromList", results.selectedActualServiceId);
        cmp.set("v.showAddSerButton", results.showAddSerButtonOnTop);
        cmp.set("v.product2optionsTopLevel", results.product2List);
        cmp.set("v.showContainer2", true);
        this.resetAddServicescallbackTopChangeHelper(cmp);
    },

    queryAdditionalServicesHelper: function(cmp, event) {
        var addser = cmp.get("c.getVASandSurcharges");
        addser.setParams({
            asId: cmp.get("v.selectedActualServiceIdFromList")
        });
        addser.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && cmp.isValid()) {
                var resp = response.getReturnValue();
                var isEmptyObj = $A.util.isEmpty(resp);
                if (isEmptyObj) {
                    cmp.set("v.showTable", false);
                    cmp.set("v.showAddSerButton", true);
                    cmp.set("v.showMsgWhnNoAddSer", "NO ADDITIONAL SERVICES ASSOCIATED WITH THIS ACTUAL SERVICE");
                } else {
                    cmp.set('v.vasSurColumns', [{
                        label: 'Name',
                        fieldName: 'Name',
                        type: 'text',
                        sortable: true
                    }, {
                        label: 'Type',
                        fieldName: 'crm_Service_Type__c',
                        type: 'text',
                        sortable: true
                    }, {
                        label: 'Service ID',
                        fieldName: 'ProductCode',
                        type: 'text',
                        sortable: true
                    }                            
                    ]);
                    cmp.set("v.showTable", true);
                    cmp.set("v.showMsgWhnNoAddSer", cmp.clearReference("v.showMsgWhnNoAddSer"));
                    cmp.set("v.showAddSerButton", true);
                }
                cmp.set('v.additionalservicesList', resp);
                cmp.set('v.additionalservicesListBackup', resp);
            }
        });
        $A.enqueueAction(addser);
    },

    handleSelectedAddServicesHelper: function(cmp, event) {
        var allSelectedAddServiceIds = [];
        var allSelectedAddServiceRecords = [];
        var selectedRows = event.getParam('selectedRows');
        for (var i = 0; i < selectedRows.length; i++) {
            allSelectedAddServiceIds.push({
                value: selectedRows[i].Id
            });
            allSelectedAddServiceRecords.push(selectedRows[i]);
        }
        cmp.set("v.allSelectedVASSurchargeIds", allSelectedAddServiceIds);
        cmp.set("v.allSelectedVASSurchargeRecords", allSelectedAddServiceRecords);
    },

    resetAddServicescallbackTopChangeHelper: function(cmp) {
        cmp.set("v.additionalservicesList", cmp.clearReference("v.additionalservicesList"));
        cmp.set("v.showTable", false);
        cmp.set("v.showMsgWhnNoAddSer", cmp.clearReference("v.showMsgWhnNoAddSer"));
        cmp.set("v.allSelectedVASSurchargeIds", cmp.clearReference("v.allSelectedVASSurchargeIds"));
        cmp.set("v.allSelectedVASSurchargeRecords", cmp.clearReference("v.allSelectedVASSurchargeRecords"));
    },

    closeQuickActionHelper: function(cmp, ev) {
        $A.get("e.force:closeQuickAction").fire();
    },

    asArray: function(component) {
        if (Array.isArray(component))
            return component;
        else
            return component ? [component] : [];
    },

    saveHelper: function(cmp, ev) {
        cmp.set("v.showspinner", true);
        var asData = cmp.get("v.capturedASDetails");
        var children = cmp.find('lightningDataTableAdditionalServicesId');
        var allAddSer = [];
        if(!$A.util.isEmpty(children)){
        if ($A.util.isArray(children)) {
            for (var ik in children) {
                allAddSer.push(children[ik].captureAddSerdataAuraMethod());
                console.log('allAddSer---1'+allAddSer);
            }
        } else {
            allAddSer.push(children.captureAddSerdataAuraMethod());
            
             console.log('allAddSer---2'+allAddSer);
        }}
        asData.additionalServices = allAddSer;
        var saveAction = cmp.get("c.createLineItems");
        var tosend = JSON.stringify(asData);
        console.log("Final services to insert : " + tosend);
        saveAction.setParams({
            json: tosend
        });
        saveAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && cmp.isValid()) {
                var resp = response.getReturnValue();
                if (resp == 'done') {
                    cmp.set("v.showspinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The records have been inserted successfully.",
                        "type": "success"
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                } else {
                    cmp.set("v.showspinner", false);
                    cmp.set("v.saveerror", resp);
                }
            } else {
                cmp.set("v.showspinner", false);
                cmp.set("v.saveerror", "Error: Unknown exception. This is embarrassing but please contact Admin.");
            }
        });
        $A.enqueueAction(saveAction);
    },

    handleinputActualServiceDataHelper: function(cmp, event) {
        cmp.set("v.capturedASDetails", event.getParams().capturedObjectAS);
    },
    
    sortDataHelper: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.additionalservicesList");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortByHelper(fieldName, reverse))
        cmp.set("v.additionalservicesList", data);
    },
    
    sortByHelper: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})