({
	doInit : function(component, event, helper) {
		helper.fetchCustomers(component,event);
	},
    
    onChangeHandler : function(component, event, helper){
        if(component.get("v.selectedCustomer") == ""){
            component.set("v.mybringRole", null);
            console.log('response - '+ component.get("v.mybringRole"));
        }
        else
        {
            var action = component.get("c.getRoles");
        action.setParams({
            AccountId : component.get("v.selectedCustomer"),
            ContactId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                component.set("v.mybringRole", response);
                console.log('response - '+ response);
            }
         });  
         $A.enqueueAction(action);
        }
    }
})