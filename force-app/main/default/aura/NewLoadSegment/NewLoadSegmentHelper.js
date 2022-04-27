({
    //To Get All Opportunities Service Group 
    getOpportunitiesServiceGroup : function(component, event, helper) 
    {
        var action = component.get("c.getAllOpportunitiesServiceGroup");
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               console.log('state: '+state);
                               if (state === "SUCCESS" && component.isValid()) 
                               {
                                   var opportunitiesServiceGroupArray = [];
                                   var opportunitiesServiceGroupResponse = response.getReturnValue();
                                   for (var key in opportunitiesServiceGroupResponse) 
                                   {
                                       opportunitiesServiceGroupArray.push({
                                           value: opportunitiesServiceGroupResponse[key],
                                           key: key
                                       });
                                   }
                                   component.set("v.OpportunitiesServiceGroup", opportunitiesServiceGroupArray);
                                   console.log("Opportunities Service Group Array" + opportunitiesServiceGroupArray);
                               }
                           });
        $A.enqueueAction(action);
    },
    
    //To Get Responsible Seller
    loadresponsibleseller : function(component, event) 
    {
        var action = component.get("c.getresponsibleseller");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert("response for load responsible seller: "+response.getState());
            if (state === "SUCCESS" && component.isValid()) {
                var responsibleselleroptions = [];
                var resp = response.getReturnValue();
                for (var key in resp) {
                    responsibleselleroptions.push({
                        value: resp[key],
                        key: key
                    });
                }
                component.set("v.responsibleselleroptions", responsibleselleroptions);               
            }
        });
        $A.enqueueAction(action);
    }
})