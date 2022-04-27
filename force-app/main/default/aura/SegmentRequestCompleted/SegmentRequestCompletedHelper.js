({
	 loadsegmentcompleted: function(component, event) {
     var action = component.get("c.getSegmentCompleted");
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                
                if($A.util.isEmpty(response.getReturnValue())){
                    component.set("v.showerror",true);
                 
                }else{
                	component.set("v.segmentListCompleted",response.getReturnValue());
                     }
            }  
        });
        $A.enqueueAction(action);
    },
})