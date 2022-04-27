({
	 doInit : function(component, event, helper) {
          var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-show');
         var action = component.get("c.closeInquiryFn");
         action.setParams({
            caseId: component.get("v.recordId")
        });
           action.setCallback(this, function(response) {
           var state = response.getState();
           if (state === "SUCCESS") {
         	var storeResponse = response.getReturnValue();
           
                    if(storeResponse == "success" )
                    {
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": $A.get("$Label.c.cs_Close_case_success"), 
                            "message": $A.get("$Label.c.cs_Please_view_the_case_details"),  
                            "type":"success"
                        
                    });
                         resultsToast.fire();
                		$A.get("e.force:refreshView").fire();
                    }
                      
             else  if(storeResponse == "caseclosed" ) {
                component.set("v.closederror", true);
                 
             }
                }     
          
        });
        $A.enqueueAction(action);
         
    },
      showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
		

})