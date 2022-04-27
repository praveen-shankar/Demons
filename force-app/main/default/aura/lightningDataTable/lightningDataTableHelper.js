({
	loadPassivereturn : function(component, event) {
        
      var action = component.get("c.getpassivereturn");  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var status = [];
                
                var areas = response.getReturnValue();
                for ( var key in areas ) {
                    status.push({value:areas[key], key:key});
                    
                }
                
               
                component.set("v.Passivereturnoptions", status);
            }
        });  
         $A.enqueueAction(action); 
},
    
})