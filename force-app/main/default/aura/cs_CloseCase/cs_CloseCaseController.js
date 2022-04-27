({
	doInit : function(component, event, helper) {
       helper.loadCaseStatus(component, event);
       helper.loadCaseDetails(component,event);
        var caseid= component.get("v.recordId");
        
        component.set("v.caseId",caseid);
       		
	},
    Save : function(component, event, helper){
        helper.updatecase(component, event);
    },
       
        closeQuickAction: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId")
            
        });
        navEvt.fire();
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
        
    },
})