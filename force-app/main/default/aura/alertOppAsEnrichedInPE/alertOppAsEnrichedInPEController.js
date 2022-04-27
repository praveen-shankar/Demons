({
    doInit : function(component, event, helper) {
        var action = component.get("c.getOpportunityNewOrOld");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var resp = response.getReturnValue();
                console.log("Response from server inside doInit is: " + JSON.stringify(resp));
                component.set("v.opprecord",resp);
                helper.verify(component);
            } else {
                component.set("v.showhighlighter1",false);
                component.set("v.showhighlighter2",false);
            }
        });
        $A.enqueueAction(action);
	}
})