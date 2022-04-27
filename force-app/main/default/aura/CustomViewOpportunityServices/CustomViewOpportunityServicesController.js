({
    handleAddEvent: function(component, event, helper) {
        helper.handleAddEventHelper(component, event);
    },

    init: function(component, event, helper) {
        helper.doInitHelper(component);
    },

    getSelectedName: function(component, event, helper) {
        helper.getSelectedNameHelper(component, event);
    },

    cancelModal: function(component, event, helper) {
        helper.cancelModalHelper(component, event);
    },

    save: function(component, event, helper) {
        helper.saveHelper(component, event);
    },

    selectOnChange: function(component, event, helper) {
        helper.selectOnChangeHelper(component, event);
    },
    
    trackInput: function(component, event, helper) {
        helper.trackInputHelper(component, event);
    }
})