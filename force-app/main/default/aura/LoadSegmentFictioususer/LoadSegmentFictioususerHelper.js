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
    
    loadresponsibleseller: function(component, event) {
        var action = component.get("c.getresponsibleseller");
        action.setCallback(this, function(response) {
            var state = response.getState();
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
    },
    
    setproposedmanager: function(component, event) {
    
       var proposedresponsibleSellerID= component.find("proposedresponsibleSeller").get("v.value");
     
       
        var action = component.get("c.getproposedmanagerId");
        action.setParams({
            'proposedresponsibleSellerID': component.find("proposedresponsibleSeller").get("v.value")
        });
       
          //set a callback
        action.setCallback(this, function(response)
        {
            var state = response.getState();
           
             if (state === "SUCCESS") 
             {
                var storeResponse = response.getReturnValue();
                
                
                 //set searchResult list with return value from server
                 component.set("v.proposedresponsibleSellermanager", storeResponse);
             }
        });
        $A.enqueueAction(action);  
    }
    
    
})