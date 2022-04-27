({
	 doInit : function(component, event, helper) {
         var action = component.get("c.CreateCaseFromParent");
         action.setParams({
            caseId: component.get("v.recordId")
        });
           action.setCallback(this, function(response) {
           var state = response.getState();
               var storeResponse = response.getReturnValue();
           if (state === "SUCCESS") {
         	            var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "New Case created sucessfully",
                            "message": "Please view the Case details", 
                            "type":"success"
                        
                    });
                        resultsToast.fire();
                		$A.get("e.force:refreshView").fire();
               
               
                var redirect = $A.get("e.force:navigateToSObject");
        
                    // Pass the record ID to the event
                    redirect.setParams({
                        "recordId": storeResponse
                    });
                    
                    // Open the record
                    redirect.fire();
                        
               /* var navLink = component.find("navLink");
                var pageRef = {
                    type: 'standard__recordPage',
                    attributes: {
                        actionName: 'view',
                        objectApiName: 'Case',
                        recordId : storeResponse // change record id. 
                    },
                };
                navLink.navigate(pageRef, true);*/
                     
                    }
             else  if(storeResponse == "error" ) {
                 component.set("v.error", true); 
                 
             }
             
		     
          
        });
        $A.enqueueAction(action);
          
                
    },
})