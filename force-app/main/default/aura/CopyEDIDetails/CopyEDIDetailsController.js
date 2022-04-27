({
    doInit: function(component, event, helper) { 
     helper.ShowEdiContent(component,event);
    },
    
    searchAction: function(component, event, helper) {
        helper.searchActionHelper(component, event);
    },

    resetAction: function(component, event, helper) {
        helper.resetActionHelper(component, event);
    },

    copyAction: function(component, event, helper) {
        helper.copyActionHelper(component, event);
    },

    cancelAction: function(component, event, helper) {
        helper.cancelActionHelper(component, event);
    },

    radioChange: function(component, event, helper) {
        helper.radioChangeHelper(component, event);
    },

    inputChange: function(component, event, helper) {
        helper.inputChangeHelper(component, event);
    },

    resetAction: function(component, event, helper) {
        helper.resetActionHelper(component, event);
    },
    
    // New functions 
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    },

    selectAllCheckbox: function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var listOfAllAccounts = component.get("v.listOfAllAccounts");
        var PaginationList = component.get("v.PaginationList");

        for (var i = 0; i < listOfAllAccounts.length; i++) {
            if (selectedHeaderCheck == true) {
                listOfAllAccounts[i].isChecked = true;
                component.set("v.selectedCount", listOfAllAccounts.length);
            } else {
                listOfAllAccounts[i].isChecked = false;
                component.set("v.selectedCount", 0);
            }
            updatedAllRecords.push(listOfAllAccounts[i]);
        }

        for (var i = 0; i < PaginationList.length; i++) {
            if (selectedHeaderCheck == true) {
                PaginationList[i].isChecked = true;
            } else {
                PaginationList[i].isChecked = false;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set("v.listOfAllAccounts", updatedAllRecords);
        component.set("v.PaginationList", updatedPaginationList);
    },

    checkboxSelect: function(component, event, helper) {
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.selectedCount");
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
            component.find("selectAllId").set("v.value", false);
        }
        component.set("v.selectedCount", getSelectedNumber);

        if (getSelectedNumber == component.get("v.totalRecordsCount")) {
            component.find("selectAllId").set("v.value", true);
        }
    },

    getSelectedRecords: function(component, event, helper) {
        var allRecords = component.get("v.listOfAllAccounts");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].isChecked) {
                selectedRecords.push(allRecords[i].objAccount);
            }
        }

        var action = component.get("c.performAction");
        var selAcc = JSON.stringify(selectedRecords);
        var EDIList = [];
        action.setParams({
            SelectedAccRecords: selAcc,
            CurrentID: component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.Spinner", false);
            if (state === "SUCCESS" && component.isValid()) {
                var EDIList = component.get("v.EdiList");
                var res = response.getReturnValue();
                console.log('Cloned response: ' + JSON.stringify(response.getReturnValue()));
	             if (res.length > 0) {
                 for (var i = 0; i < res.length; i++) {
                     if( !$A.util.isEmpty(EDIList)){
						   EDIList.push(res[i]);
                     }
                     else{
                         EDIList =[];
                         EDIList.push(res[i]);
                     }
                  } 
					 component.set("v.EdiList", EDIList);
                                        
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Cloned EDI records created Successfully",
                        "type": "success"
                    });
                    toastEvent.fire();
                } else {
                    var ediList = [];
                    component.set("v.EdiList", ediList);
                }
            } else if (state === "ERROR") {
                var errors = action.getError();

                if (errors[0] && errors[0].message) { // To show other type of exceptions
                    component.set("v.message", errors[0].message);
                    component.set("v.Error", true);

                }
                if (errors[0] && errors[0].pageErrors) { // To show DML exceptions
                    component.set("v.message", errors[0].pageErrors[0].message);
                    component.set("v.Error", true);

                }

            } else if (state === "INCOMPLETE") {
                component.set("v.message", "The server did not return a response. The server might be down or the client might be offline");
                component.set("v.Error", true);
            }
        });
        $A.enqueueAction(action);
        component.set("v.Spinner", true);
    },

    closeMessage: function(component, event, helper) {
        component.set("v.Error", false);
        $A.get("e.force:closeQuickAction").fire();
    },
    
    toastEvent: function(component, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
})