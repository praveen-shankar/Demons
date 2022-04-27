({
    handleedimodelevent : function(component, event, helper) {
        var message = event.getParam("message");
        if(message === 'proceed' && !$A.util.isEmpty(component.get('v.modalPromise'))) { 
            component.get('v.modalPromise').then(
    		function (modal) {
        		modal.close();
    		});
            component.set("v.showspinner",true);
        	component.set("v.showerror",false);
        	component.set("v.errormessage","");
        	helper.performCallout(component);
        } else {
            var rEvent = $A.get("force:refreshView");
            if(rEvent) rEvent.fire();
        }
    },
    
    onSelectChange : function(component, event, helper) {
		helper.onSelectChangeHelper(component,event);
	},
    
    showConfirmationModel : function(component, event, helper) {
        /*var modalBody;
        $A.createComponent("c:edi_integrationConfirmation_model", {},
           function(content, status, errorMessage) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   var mref = component.find('overlayLib').showCustomModal({
                       header: "Confirmation",
                       body: modalBody, 
                       showCloseButton: true
                   });
                   component.set("v.modalPromise", mref);
               }                               
           });*/
        component.set("v.openModal", true);
    },
    
    doInit : function(component, event, helper) {
        helper.loadData(component,$A.util.isEmpty(component.get("v.subscription")));
    },
    
    confirmationAction: function(component, event, helper) {
        var action = event.getSource().get("v.name");
        component.set("v.openModal", false);
        if (action === 'approveProcess') {
            component.set("v.showspinner",true);
        	component.set("v.showerror",false);
        	component.set("v.errormessage","");
        	helper.performCallout(component);
        } else if (action === 'cancelProcess') {
        
        }
    },
})