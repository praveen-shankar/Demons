({
	doInit: function(component, event, helper) {
        
         helper.loadsegment(component, event);
        
    },
     closeQuickAction : function(component, event, helper) {
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    
    
    submit: function(component, event, helper) {
        helper.savesegment(component, event);
    },

})