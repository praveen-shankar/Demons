({
    sendHelper: function(component, getEmail, getSubject, getbody) {
        
        var action = component.get("c.sendMailMethod");
        
        action.setParams({
            'mMail': getEmail,
            'mSubject': getSubject,
            'mbody': getbody,
            contactid: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
				console.log('~~storeResponse::'+storeResponse);
                component.set("v.mailStatus", true);
            }
 
        });
        $A.enqueueAction(action);
      
    },
	
	loadEmail : function(component, event) {
	
		var action = component.get("c.getContact");	
      	action.setParams({
    		contactid: component.get("v.recordId")
		});   	    
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.email", response.getReturnValue());               
                
            }
         });
		$A.enqueueAction(action);
	},
	
	loadBody : function(component, event) {
	
		var action = component.get("c.getBody");
        action.setParams({
    		contactid: component.get("v.recordId")
			});   
         
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.body", response.getReturnValue());                
            }
         }); 
        
        $A.enqueueAction(action); 
	
	},
	
	loadSubject : function(component, event) {
	
		var action = component.get("c.getsubject");
         
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.subject", response.getReturnValue());                
            }
         }); 
        
        $A.enqueueAction(action); 
	
	},
})