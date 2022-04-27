({
    getSegmentList: function(component, event) {
        
        var action = component.get("c.getSegmentList");
        
        action.setParams({
            'segId': component.get("v.segId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is 0 ,display no record found message on screen.
                
                if (storeResponse.length > 0) {
                    
                    component.set("v.segmentlist", storeResponse);
                    
                    
                }
                
            }
            
            
        });
        $A.enqueueAction(action);
    },
    
    loadmonth: function(component, event) {
        var action = component.get("c.getmonth");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var resp = response.getReturnValue();
			
                var monthoptions=[];
               
                  for (var key in resp) {
                    
                    monthoptions.push({
                        value: resp[key],
                        key: key
                    });
                }
              
                component.set("v.monthoptions", monthoptions);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadyear: function(component, event) {
        var action = component.get("c.getyear");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var yearoptions = [];
                var resp = response.getReturnValue();
                for (var key in resp) {
                    yearoptions.push({
                        value: resp[key],
                        key: key
                    });
                }
                component.set("v.yearoptions", yearoptions);
               
            }
        });
        $A.enqueueAction(action);
    },
    
    
})