({
    doInit: function(component) {
        var action = component.get("c.getAllAccounts");
        action.setCallback(this, function(response) {
            var state = response.getState();

            if ((state == "SUCCESS") && (component.isValid())) {

                var records = response.getReturnValue();
                console.log('records' + records);
                component.set("v.AccountsPagination", records);
                component.set("v.totalRecords", records.length);

                // 20 item will display on single screen 
                component.set("v.maxPage", Math.floor((records.length + 99) / 100));
                // By default it will sort by created date 
                var pageNumber = 1;
                var pageRecords = records.slice((pageNumber - 1) * 100, pageNumber * 100);
                component.set("v.AllAccounts", pageRecords);

            } else if (state === 'ERROR')
                console.log("Unknown Error");
        });
        $A.enqueueAction(action);
    },

    sortByName: function(component, event, helper) {
        helper.sortByText(component, "Name");
    },

    sortByorga: function(component, event, helper) {
        helper.sortByOrga(component, "Orga__c");
    },
    sortByCustConGrp: function(component, event, helper) {
        helper.sortByOrga(component, "crm_Conv_Customer_Conversion_Group__c");
    },
    sortByTotRevenue: function(component, event, helper) {
        helper.sortByOrga(component, "crm_Conv_Total_Revenue__c");
    },
    sortByConProcess: function(component, event, helper) {
        helper.sortByOrga(component, "crm_Conv_Conversion_Process__c");
    },
    sortByConHeat: function(component, event, helper) {
        helper.sortByOrga(component, "crm_Conv_Converison_Heat__c");
    },
    sortByStartdate: function(component, event, helper) {
        helper.sortByOrga(component, "crm_Conv_Start_Date__c");
    },
    sortByCustomerState: function(component, event, helper) {
        helper.sortByOrga(component, "crm_conv_Customer_state__c");
    },
    sortByCustomerComment: function(component, event, helper) {
        helper.sortByOrga(component, "crm_conv_Conversion_comment__c");
    },
    sortByCustomerPriceReady: function(component, event, helper) {
        helper.sortByOrga(component, "Customer_Price_Ready__c");
    },
    sortByAgreementProposition: function(component, event, helper) {
        helper.sortByOrga(component, "Agreement_Proposition_Ready__c");
    },
    sortByConversionReady: function(component, event, helper) {
        helper.sortByOrga(component, "Conversion_Ready__c");
    },
    sortByCustomerConverted: function(component, event, helper) {
        helper.sortByOrga(component, "Customer_Converted__c");
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

    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    }
})