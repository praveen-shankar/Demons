({
    loadAccountoptions: function(component, event) {
        var action = component.get("c.getAccountOptions");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var resp = response.getReturnValue();
                var relationaccounts = [];
                var index = 0;
                for (var key in resp) {
                    var obj = {
                        value: resp[key],
                        key: key
                    };
                    if (index === 0) {
                        obj.selected = true;
                        if(key) component.find("AccountId").set("v.value", key);
                    }
                    relationaccounts.push(obj);
                    index++;
                }
                component.set("v.accountOptions", relationaccounts);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadfunctionalarea: function(component, event) {
        var action = component.get("c.getfunctionalarea");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var functionalarea = [];
                var areas = response.getReturnValue();
                for (var key in areas) {
                    functionalarea.push({
                        value: areas[key],
                        key: key
                    });
                }
                component.set("v.functionalareaOptions", functionalarea);
                console.log("v.functionalareaOptions" + functionalarea);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadstatus: function(component, event) {
        var action = component.get("c.getstatus");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var status = [];
                var areas = response.getReturnValue();
                for (var key in areas) {
                    status.push({
                        value: areas[key],
                        key: key
                    });
                }
                component.set("v.statusOptions", status);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadfunctionaldecisionlevel: function(component, event) {
        var action = component.get("c.getfunctionaldecisionlevel");
        action.setCallback(this, function(response) {
            var state = response.getState();
			
            if (state === "SUCCESS" && component.isValid()) {
               
                var resp = response.getReturnValue();
				 var decisionlevel = [];
				  var index = 0;
				 /* for (var key in resp) {
                    var obj = {
                        value: resp[key],
                        key: key
                    };*/
                      
                   for (var key in resp) {
                    decisionlevel.push({
                        value: resp[key],
                        key: key
                    });
                }
                   /* if (index === 0) {
                        obj.selected = true;
                        if(key) component.find("crm_functional_decision_level__c").set("v.value", key);
                    }*/
                   // decisionlevel.push(obj);
                   // index++;
               // }//
               
                component.set("v.functionaldecisionlevelOptions", decisionlevel);
            }
        });
        $A.enqueueAction(action);
    }
})