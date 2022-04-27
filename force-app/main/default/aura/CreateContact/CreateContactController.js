({
    createcontact: function(component, event, helper) {
        var newContact = component.get("v.contactrecord");
        var action = component.get("c.createRecord");
        action.setParams({
            "conObject": newContact
        });
        var isValid = true;
        var lastnamefield = component.find("lastname");
        var lastnamevalue = lastnamefield.get("v.value");
        var emailfield = component.find("email");
        var emailvalue = emailfield.get("v.value");
        var Accountfield = component.find("AccountId");
        //var accountvalue = Accountfield.get("v.value");
        var accountvalue = component.get("v.contactrecord.AccountId");
        var ErrorString = '';
        // Account check
        if ($A.util.isEmpty(accountvalue) || accountvalue == 'None') {
            if (ErrorString != '') ErrorString += '. Please select Customer Department';
            else ErrorString += 'Please select Customer Department';
            isValid = false;
        } else {
            isValid = true;
        }
        // last name check
        if ($A.util.isEmpty(lastnamevalue)) {
            if (ErrorString != '') ErrorString += ' ,lastname';
            else ErrorString += 'Enter lastname';
            isValid = false;
        } else {
            isValid = true;
        }
        // email check
        if ($A.util.isEmpty(emailvalue)) {
            if (ErrorString != '') ErrorString += ' and email';
            else ErrorString += 'Enter email';
            isValid = false;
        } else {
            isValid = true;
        }
        if (isValid) {
            component.set("v.showSpinner", true);
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    component.set("v.showSpinner", false);
                    if (resp.length === 0) {
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Contact created sucessfully",
                            "message": "Please refer the contact",
                            "type": "success"
                        });
                        // Update the UI: close panel, show toast, refresh account page
                        $A.get("e.force:closeQuickAction").fire();
                        resultsToast.fire();
                        $A.get("e.force:refreshView").fire();
                    } else if (resp.length > 0) {
                        component.set("v.DuplicateRecords", resp);
                        component.set("v.hasDuplicateRecords", true);
                        component.set("v.showSpinner", false);
                    }
                }
                //sucees and length=0 //contact insert 
                else if (state === "ERROR") {
                    console.log('Problem saving contact, response state: ' + state);
                    component.set("v.showSpinner", false);
                } else {
                    console.log('Unknown problem, response state: ' + state);
                    component.set("v.showSpinner", false);
                }
            });
        }
        $A.enqueueAction(action);
    },

    cancel: function(component, event, helper) {
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },

    onAccountchange: function(component, event, helper) {
        var Accountid = event.getSource().get("v.value");
    },

    redirectToSobject: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        var selectedItem = event.currentTarget;
        var IdP = selectedItem.dataset.record;
        navEvt.setParams({
            "recordId": IdP,
            "slideDevName": "Detail"
        });
        navEvt.fire();
    },

    doinit: function(component, event, helper) {
        helper.loadAccountoptions(component, event);
        helper.loadfunctionalarea(component, event);
        helper.loadstatus(component, event);
        helper.loadfunctionaldecisionlevel(component, event);
    },

    createduplicatecontact: function(component, event, helper) {
        var newContact = component.get("v.contactrecord");
        var action = component.get("c.createDuplicateRecord");
        action.setParams({
            "conObject": newContact,
            "accountId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            // var noofrecords= resp.length();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                // Prepare a toast UI message
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Contact created sucessfully",
                    "message": "Please refer the contact",
                    "type": "success"
                });
                // Update the UI: close panel, show toast, refresh account page
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
            } else if (state === "ERROR") {
                console.log('Problem saving contact, response state: ' + state);
            } else {
                console.log('Unknown problem, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
    }
})