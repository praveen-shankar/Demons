({
    searchActionHelper: function(component, event) {
        var newPartyName = component.get("v.partyName");
        var newOrganisationName = component.get("v.organizationNumber");
        let partyradioval = component.find("partyradio").get("v.checked");
        let relationradioval = component.find("relationradio").get("v.checked");
        let acctType;
        if (partyradioval)
            acctType = 'party';
        else if (relationradioval)
            acctType = 'relation';
        var searchaction = component.get("c.getCustomers");
        
        searchaction.setParams({
            name: component.get("v.partyName"),
            acctType: acctType,
            orgNo: component.get("v.organizationNumber")
        });
        searchaction.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.Spinner", false);
            if (state === "SUCCESS" && component.isValid()) {
                console.log('response: ' + JSON.stringify(response.getReturnValue()));
                var oRes = response.getReturnValue();
                if (oRes.length > 0) {
                    component.set('v.listOfAllAccounts', oRes);
                    var pageSize = component.get("v.pageSize");
                    var totalRecordsList = oRes;
                    var totalLength = totalRecordsList.length;
                    component.set("v.totalRecordsCount", totalLength);
                    component.set("v.startPage", 0);
                    component.set("v.endPage", pageSize - 1);
                    
                    var PaginationLst = [];
                    for (var i = 0; i < pageSize; i++) {
                        if (component.get("v.listOfAllAccounts").length > i) {
                            PaginationLst.push(oRes[i]);
                        }
                    }
                    component.set('v.PaginationList', PaginationLst);
                    component.set("v.selectedCount", 0);
                    component.set("v.resetFlag", true);
                    component.set("v.currentPage", 1);
                    //use Math.ceil() to Round a number upward to its nearest integer
                    component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));
                    
                } else {
                    var accountlist = [];
                    component.set("v.resetFlag", false);
                    component.set("v.listOfAllAccounts", accountlist);
                    component.set("v.PaginationList", accountlist);
                }
                
            } else if (state === "INCOMPLETE") {
                component.set("v.message", "The server did not return a response. The server might be down or the client might be offline");
                component.set("v.Error", true);
                
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
            }
        });
        $A.enqueueAction(searchaction);
        component.set("v.Spinner", true);
    },
    
    radioChangeHelper: function(component, event) {
        let partyradioval = component.find("partyradio");
        let relationradioval = component.find("relationradio");
        let cmp = event.getSource();
        if (cmp.get("v.name") == 'partyradio' && cmp.get("v.checked"))
            relationradioval.set("v.checked", false)
            else if (cmp.get("v.name") == 'relationradio' && cmp.get("v.checked"))
                partyradioval.set("v.checked", false)
                },
    
    inputChangeHelper: function(component, event) {
        var orgInputValue = component.find("orgnoinput");
        var inputValue = component.find("nameinput");
        var searchButton = component.find("searchbtn");
        if((!$A.util.isEmpty(orgInputValue.get("v.value"))) || (!$A.util.isEmpty(inputValue.get("v.value")))) {
            searchButton.set('v.disabled', false);    
        } else {
            searchButton.set('v.disabled', true);
        }
    },
    
    resetActionHelper: function(component, event) {
        if(!$A.util.isEmpty(component.find('nameinput')))
            component.find('nameinput').set('v.value', ' ');
        if(!$A.util.isEmpty(component.find('orgnoinput')))
            component.find('orgnoinput').set('v.value', ' ');
        if(!$A.util.isEmpty(component.find('searchbtn')))
            component.find("searchbtn").set('v.disabled', true);
        if(!$A.util.isEmpty(component.find('copybtn')))
            component.find("copybtn").set('v.disabled', true);
        component.set("v.PaginationList", null);
        component.set("v.listOfAllAccounts", null);
        component.set("v.EdiList", null);
        component.set("v.resetFlag", true);
    },
    
    copyActionHelper: function(component, event) {
        
    },
    
    cancelActionHelper: function(component, event) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "Detail"
        });
        navEvt.fire();
    },
    
    // navigate to next pagination record set   
    next: function(component, event, sObjectList, end, start, pageSize) { 
        var Paginationlist = [];
        var counter = 0;
        for (var i = end + 1; i < end + pageSize + 1; i++) {
            if (sObjectList.length > i) {
                if (component.find("selectAllId").get("v.value")) {
                    Paginationlist.push(sObjectList[i]);
                } else {
                    Paginationlist.push(sObjectList[i]);
                }
            }
            counter++;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        component.set('v.PaginationList', Paginationlist);
    },
    
    // navigate to previous pagination record set   
    previous: function(component, event, sObjectList, end, start, pageSize) { 
        var Paginationlist = [];
        var counter = 0;
        for (var i = start - pageSize; i < start; i++) {
            if (i > -1) {
                if (component.find("selectAllId").get("v.value")) {
                    Paginationlist.push(sObjectList[i]);
                } else {
                    Paginationlist.push(sObjectList[i]);
                }
                counter++;
            } else {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        component.set('v.PaginationList', Paginationlist);
    },
    
    ShowEdiContent: function(component, event) {
        var action = component.get("c.getprofilename");
        component.set("v.Spinner", true);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Spinner", false);
                component.set("v.showEDIContent", response.getReturnValue());
                console.log('show edi '+component.get("v.showEDIContent"));
                if(component.get("v.showEDIContent") === true) {
                    component.find("accesscheckmessage").set('v.value','');
                } else {
                    var staticLabel = $A.get("$Label.c.edi_InsufficientPrivileges");
                    component.find("accesscheckmessage").set('v.value',staticLabel);
                }    
            }
            else if (state === "INCOMPLETE") {
                component.set("v.message", "The server did not return a response. The server might be down or the client might be offline");
                component.set("v.Error", true);
                
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
            }               
        });  
        $A.enqueueAction(action);         
    }, 
})