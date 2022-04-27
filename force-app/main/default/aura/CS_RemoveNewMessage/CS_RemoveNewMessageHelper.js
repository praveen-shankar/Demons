({
	removeMessage : function(component,event,helper) {
         var action = component.get("c.getselectedCases"); 
        action.setCallback(this, function(response) {
           var state = response.getState();
           if (state === "SUCCESS") {
         	var storeResponse = response.getReturnValue();
           
                    if(storeResponse == "true" )
                    {
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Case updated sucessfully",
                            "message": "Please view the case details", 
                            "type":"success"
                        
                    });
                         resultsToast.fire();
                		$A.get("e.force:refreshView").fire();
                    }
		
	}
        }); $A.enqueueAction(action);
    }
})