({
    //To Get All Opportunities
    getAllOpportunities: function(component, event, helper) {
        var action = component.get("c.fetchOpportunities");
        component.set("v.showspinner", true);
        console.log("action is: " + action);
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("State: " + state);
            component.set("v.showspinner", false);
            if ((state == "SUCCESS") && (component.isValid())) {
                var records = response.getReturnValue();
                console.log('records: ' + records);
                component.set("v.AllOpportunities", records);
            } else if (state === 'ERROR') {
                console.log("Unknown Error");
            }
        });
        $A.enqueueAction(action);
    }
})