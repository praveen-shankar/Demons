({
	 doInit : function(component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-show');
         var action = component.get("c.updateCaseDetails");
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
                            "title": $A.get("$Label.c.cs_Case_updated"),
                            "message": $A.get("$Label.c.cs_Please_view_the_case_details"),
                            "type":"success"
                        
                    });
                         resultsToast.fire();
                		$A.get("e.force:refreshView").fire();
                    }
             else  if(storeResponse == "Milestoneerror" ) {
                 component.set("v.milestoneerror", true); 
                 
             }
             
             else  if(storeResponse == "caseclosed" ) {
                component.set("v.openModal", true);
                 
             }
              else  if(storeResponse == "error" ) {
                component.set("v.error", true);
                 
             }
             
              
         }     
          
        });
        $A.enqueueAction(action);
       // $A.util.toggleClass(spinner, 'slds-hide');
        
                
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
    
    starthandling : function(component, event, helper) {
    
         component.set("v.openModal", false);
         var action = component.get("c.starthandlingFn");
         action.setParams({
            caseId: component.get("v.recordId")
        });
          action.setCallback(this, function(response) {
          var state = response.getState();
            
          if (state === "SUCCESS") {
         	var storeResponse = response.getReturnValue();
          	
                    if(storeResponse == "success" )
                    {
                        component.set("v.error", false);
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": $A.get("$Label.c.cs_Case_updated"),
                            "message": $A.get("$Label.c.cs_Please_view_the_case_details"),
                            "type":"success"
                        
                    });
                         resultsToast.fire();
                		$A.get("e.force:refreshView").fire();
                    }
              else  if(storeResponse == "error" ) {
                component.set("v.error", true);
                 
             }
        }     
          
        });
        $A.enqueueAction(action);
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