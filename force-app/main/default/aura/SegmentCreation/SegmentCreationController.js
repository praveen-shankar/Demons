({
	doInit: function(component, event, helper) {
        var action = component.get("c.getOpportunityserviceGroups");
        action.setParams({
            acctId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                if($A.util.isEmpty(response.getReturnValue())){
                    component.set("v.noOptionsFound",true);
                }else{
                	component.set("v.serviceGroups",response.getReturnValue());
                     }
            }  
        });
        $A.enqueueAction(action);
    },
    
     closeQuickAction : function(component, event, helper) {
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    
    
    submit: function(component, event, helper) {
         var action = component.get("c.saveSegments");
         var serviceGrps = component.get("v.serviceGroups");
         var selectedLists = [];
         for(var i=0;i<serviceGrps.length;i++){
            if(serviceGrps[i].selected == true){
                selectedLists.push(serviceGrps[i].sgroup);
            }
        } 
        
         action.setParams({
            acctId: component.get("v.recordId"),
            selectedLists:selectedLists
            
        });
       
            action.setCallback(this, function(response) {
            var state = response.getState();
           
            if(state === "SUCCESS") {
                var resp = response.getReturnValue(); 
                 var resp = response.getReturnValue(); 
                    
                    
                    if(resp.length===0)
                    {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Segments created sucessfully",
                    "message": "Please refer the segments", 
                    "type":"success"
                    
                });
                
                // Update the UI: close panel, show toast, refresh account page
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                 navEvt.setParams({
                  "recordId": component.get("v.recordId"),
                  "slideDevName": "related"
                });
                navEvt.fire();
            }
                
                else if(resp.length>0){
                    component.set("v.errorLogs",response.getReturnValue());
                component.set("v.showerror",true);
                    
                }
           else if (state === "ERROR") {
                console.log('Problem saving segment, response state: ' + state);
            }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
            }
        });
        
        
        $A.enqueueAction(action);
       
    }
                               
    
})