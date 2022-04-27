({
    proceed : function(component, event, helper) {
		var edimodelevent = $A.get("e.c:edi_integrationConfirmation_event");
        edimodelevent.setParams({
            "message" : "proceed"
        });
        edimodelevent.fire();
	}
})