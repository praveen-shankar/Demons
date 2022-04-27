({
	 getSegmentToBeApproved: function(component, event) {
     var action = component.get("c.getSegmentToBeApproved");
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                
                if($A.util.isEmpty(response.getReturnValue())){
                    component.set("v.showerror",true);
                 
                }else{
                	component.set("v.getSegmentToBeApproved",response.getReturnValue());
                     }
            }  
        });
        $A.enqueueAction(action);
    },
})