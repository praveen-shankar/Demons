({
	handleSelectedActualServiceHelper : function(component,event) {
		var asEvent = component.getEvent("listOfActualServiceEvent");
        var selected = event.getSource().get("v.value");
        if($A.util.isUndefined(selected) && !$A.util.isEmpty(component.get("v.product2options"))){ //for first load
        	selected = component.get("v.product2options")[0].Id;
        }
        asEvent.setParams({
            "selectedActualServiceId": selected,
            "showAddSerButtonOnTop": false,
            "resetAddServicescallback": true,
            "product2List": component.get("v.product2options")
        });
        asEvent.fire();
	},
    
    autoLoadActualServicesHelper : function(cmp,event){
        var product2details = cmp.get("c.getProductsPerFamily");
        product2details.setParams({
            oppId: cmp.get("v.opportunityId")
        });
        product2details.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && cmp.isValid()) {
                var resp = response.getReturnValue();
                cmp.set("v.product2options", resp);
                if($A.util.isEmpty(resp)){
                    cmp.set("v.noProdMsg","No Actual Services are related to this Service Family.");
                }
                this.handleSelectedActualServiceHelper(cmp,event);
            }
        });
        $A.enqueueAction(product2details);
    }
})