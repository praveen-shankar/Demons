({
	afterRender : function(component,helper){
        this.superAfterRender();  
        //alert("render test");
        //component.set("v.sectionOpen",false);
        
              
        var action = component.get("c.getEDIInfo");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ediInfo", response.getReturnValue());
                //alert(response.getReturnValue());
                var ediInfo=response.getReturnValue();
                var sectionDiv = component.find("ediSection").getElement(); 
        		helper.toggleMethod(component, event, helper,sectionDiv,ediInfo); 
                }
        });
        $A.enqueueAction(action);
        }
})