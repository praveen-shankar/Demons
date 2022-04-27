({
	 loadsegmentnotapproved: function(component, event) {
     var action = component.get("c.getSegmentNotApproved");
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                
                if($A.util.isEmpty(response.getReturnValue())){
                    component.set("v.showerror",true);
                 
                }else{
                	component.set("v.segmentListnotApproved",response.getReturnValue());
                     }
            }  
        });
        $A.enqueueAction(action);
    },
})