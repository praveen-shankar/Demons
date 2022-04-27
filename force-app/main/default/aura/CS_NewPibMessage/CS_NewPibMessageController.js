({
	 doInit : function(component, event, helper) {
        helper.loadtemplates(component, event);
        helper.loadCaseDetails(component, event);
        helper.loadstatus(component, event);
		
	},
    
      onChangetemplate: function (component, event, helper) {
		var selectedTemplate = event.getSource().get("v.value");
         component.set("v.selectedTemplate",selectedTemplate);
         
          var action = component.get("c.loadTemplatedetails");
         action.setParams({
            caseId: component.get("v.recordId"),
             templateId : selectedTemplate
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
              
                if($A.util.isEmpty(response.getReturnValue())){
                   
                                                   
                }else{
                   
                	component.set("v.pibobj",response.getReturnValue());
                  //  component.set("v.Status",false);
                    
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
     addPIB : function(component, event, helper){
        helper.addPIBhelper(component, event);
    },
    
   

})