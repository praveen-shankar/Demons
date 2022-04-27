({
	 loadCaseDetails: function(component, event) {
         var action = component.get("c.loadCaseDetails");
         action.setParams({
            caseId: component.get("v.recordId")
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                if($A.util.isEmpty(response.getReturnValue())){
                     component.set("v.nocase", true); 
                 }else{
                  	component.set("v.caseToBeReleased",response.getReturnValue());
                 }
            }  
        });
        $A.enqueueAction(action);
        
        
		
	},
        
     loadCaseComments: function(component, event) {
         var action = component.get("c.loadCaseComments");
         action.setParams({
            caseId: component.get("v.recordId")
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
              
                if($A.util.isEmpty(response.getReturnValue())){
                   component.set("v.nocaseComments",true);   
                                                   
                }else{
                	component.set("v.caseComments",response.getReturnValue());
                    component.set("v.nocaseComments",false);
                    
               }
            }  
        });
        $A.enqueueAction(action);
        
        
		
	},
    
    
})