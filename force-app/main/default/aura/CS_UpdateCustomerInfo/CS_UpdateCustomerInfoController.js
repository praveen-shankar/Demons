({
	 doInit : function(component, event, helper) {
         var action = component.get("c.UpdateCustomerInfo");
         action.setParams({
            accountId: component.get("v.recordId")
        });
           action.setCallback(this, function(response) {
           var state = response.getState();
           if (state === "SUCCESS") {
         	var storeResponse = response.getReturnValue();
           
                    if(storeResponse == "success" )
                    {
                        component.set("v.updateMessage", true); 
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Account updated sucessfully",
                            "message": "Please view the Account details", 
                            "type":"success"
                        
                    });
                        resultsToast.fire();
                		$A.get("e.force:refreshView").fire();
                     var wasDismissed = $A.get("e.force:closeQuickAction");
                    wasDismissed.fire();
                    }
             else  if(storeResponse == "error" ) {
                 component.set("v.error", true); 
                 
             }
             
		   }     
          
        });
        $A.enqueueAction(action);
          
                
    },
})