({
	doInit : function(component, event, helper) {
        console.log('Inside component');
        console.log('record Id inside lightning component --> '+ component.get("v.recordId"));
        var action = component.get('c.updateErrorField');
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
        	var state = response.getState();
            if(state === "SUCCESS"){
                console.log("Sucessful apex call");
                console.log('Response Value --> ' + response.getReturnValue());
                var returnVal = response.getReturnValue();
                var showError;
                var showSuccess;
                var Message;
                if(response.getReturnValue() != null){
                    if(returnVal.startsWith("Success") || returnVal.startsWith("Suksess")){
                        showSuccess = true;
                        Message = returnVal;
                        component.set('v.showSuccess', showSuccess);
                    }
                    else{
                        showError = true;
                        Message = returnVal;
                        component.set('v.showError', showError);
                        window.alert(Message);
                	}
                }
                else{
                    showError = false;
                    showSuccess = false;
                }
                component.set('v.Message', Message);
                
            }
            else{
                console.log('Error occured in apex call');
            }
        });
        $A.enqueueAction(action);
	},
    
    handleClose : function(component, event, helper) {
        component.set('v.showError', false);
        component.set('v.showSuccess', false);
        console.log('Inside close');
        console.log('Updated showError --> '+ component.get('v.showError'));
        console.log('Updated showSuccess --> '+ component.get('v.showSuccess'));
    }
})