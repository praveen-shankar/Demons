({
	fetchCustomers : function(component,event) {
        var action = component.get("c.getCustomers");
        action.setParams({
            ContactId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                component.set("v.customers", response);
            }
         });  
         $A.enqueueAction(action);
        
	}
})