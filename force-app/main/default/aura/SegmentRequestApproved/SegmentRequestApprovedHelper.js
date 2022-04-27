({
	 loadsegmentapproved: function(component, event) {
     var action = component.get("c.getSegmentApproved");
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(response.getReturnValue());
            if (state === "SUCCESS" && component.isValid()) {
                
                if($A.util.isEmpty(response.getReturnValue())){
                    component.set("v.showerror",true);
                    
                    //this.handleShowNoticeHelpernogrps(component,"Change request is already iniatiated for all the service groups!");   
                  
                    
                }else{
                	component.set("v.segmentListApproved",response.getReturnValue());
                     }
            }  
        });
        $A.enqueueAction(action);
    },
    
   handleShowNoticeHelper : function(component, msg) {
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "User input Error",
            "message": msg,
            /*closeCallback: function() {
                $A.get("e.force:closeQuickAction").fire();
            }*/
        });
    },
})