({
	 doInit : function(component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-show');
         var action = component.get("c.checkDuplicatenumbers");
         action.setParams({
            caseId: component.get("v.recordId")
        });
           action.setCallback(this, function(response) {
           var state = response.getState();
           if (state === "SUCCESS") {
         	var storeResponse = response.getReturnValue();
               
                  
                 component.set("v.duplicateErrorFlag", true); 
                 component.set("v.duplicateError", storeResponse);  
            
               
           }
                 });
        $A.enqueueAction(action);
          	
	},
})