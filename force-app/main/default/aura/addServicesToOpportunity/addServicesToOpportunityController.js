({
    doInit: function(component, event, helper) {
        helper.oppDetailhelper(component, event);
    },

    proceedToStepTwo: function(component, event, helper) {
        helper.proceedToStepTwoHelper(component, event);
    },

    proceedToStepThree: function(component, event, helper) {
        helper.proceedToStepThreeHelper(component, event);
    },

    proceedToStepOne: function(component, event, helper) {
        helper.proceedToStepOneHelper(component, event);
    },

    handleLoadOfActualServices: function(component, event, helper) {
        helper.handleLoadOfActualServicesHelper(component, event);
    },

    orgNavigation: function(component, event, helper) {
        helper.orgNavigationHelper(component);
    },

    queryAdditionalServices: function(component, event, helper) {
        helper.queryAdditionalServicesHelper(component, event);
    },

    handleSelectedAddServices: function(component, event, helper) {
       
        helper.handleSelectedAddServicesHelper(component, event);
    },

    handleSelectedActualService: function(component, event, helper) {
        helper.handleSelectedActualServiceHelper(component, event);
    },

    handleinputActualServiceData: function(component, event, helper) {
        helper.handleinputActualServiceDataHelper(component, event);
    },

    resetAddServicescallbackTopChange: function(component, event, helper) {
        helper.resetAddServicescallbackTopChangeHelper(component, event);
    },

    closeQuickAction: function(component, event, helper) {
        helper.closeQuickActionHelper(component, event);
    },

    save: function(component, event, helper) {
        helper.saveHelper(component, event);
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortDataHelper(cmp, fieldName, sortDirection);
    },
    
    disableSaveButton: function(component,event,helper) {
        helper.disableSaveButtonHelper(component,event);
    }
})