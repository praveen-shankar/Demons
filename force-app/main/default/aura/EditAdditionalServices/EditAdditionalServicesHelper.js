({
     getAdditionalServices: function(component, event) {
        
        var action = component.get("c.getAdditionalServices");
        
        action.setParams({
            'oppLineitemId': component.get("v.oppaddLineitemId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is 0 ,display no record found message on screen.
               
                if (storeResponse.length > 0) {
                
                    component.set("v.additionalServiceValue", storeResponse);
                   
                    
                }
                
            }
            
            
        });
        $A.enqueueAction(action);
    },
    
   
	getAdditionalServicesdata: function(component, event) {
        
        var action = component.get("c.getAddservices");
        
       
       
        action.setParams({
            'oppLineitemId': component.get("v.oppaddLineitemId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is 0 ,display no record found message on screen.
               
                console.log('aaa'+storeResponse) ;
                if (storeResponse.length > 0) {
                    
                    component.set("v.additionalService", storeResponse);
                    
                    
                }
                
            }
            
            
        });
        $A.enqueueAction(action);
    },
    
    getAdditionalServicescolumns: function(component, event) {
        
        var action = component.get("c.getAdditionalServicesData");
        action.setParams({
            'oppLineitemId': component.get("v.oppaddLineitemId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is 0 ,display no record found message on screen.
                
                if (storeResponse.length > 0) {
                    
                    component.set("v.additionalServicesColumns", storeResponse);
                    var fieldsfromobject = storeResponse; // component.get("v.servicesColumns");
                    
                    var fieldsarray = [];
                    for(var pq in fieldsfromobject) {
                        fieldsarray.push(fieldsfromobject[pq].crm_API_Name__c);
                    }
                    
                    for(var x=0;x<fieldsarray.length;x++) {
                      
                       
                        if(fieldsarray.includes("crm_Unit_Price__c"))
                            component.set("v.showUnitPrice",true);
                        
                        
                        if(fieldsarray.includes("crm_Discount__c"))
                            component.set("v.showDiscount",true);
                        
                    }
                    
                    
                }
                
            }
            
            
        });
        $A.enqueueAction(action);
    },
    
    loadConversionFactor : function(component, event) {
        
        var action = component.get("c.getConversionFactor");  
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var status = [];
                
                var areas = response.getReturnValue();
                for ( var key in areas ) {
                    status.push({value:areas[key], key:key});
                    
                }
                component.set("v.ConversionFactorOptions", status);
            }
        });  
        $A.enqueueAction(action); 
    },
    
    loadLocal : function(component, event) {
        
        var action = component.get("c.getLocal");  
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var status = [];
                
                var areas = response.getReturnValue();
                for ( var key in areas ) {
                    status.push({value:areas[key], key:key});
                    
                }
                component.set("v.LocalOptions", status);
            }
        });  
        $A.enqueueAction(action); 
    },
    
    loadDirection : function(component, event) {
        
        var action = component.get("c.getDirection");  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var status = [];
                
                var areas = response.getReturnValue();
                for ( var key in areas ) {
                    status.push({value:areas[key], key:key});
                    
                }
                component.set("v.DirectionOptions", status);
            }
        });  
        $A.enqueueAction(action); 
    },
    
    LoadLocal : function(component, event) {
        
        var action = component.get("c.getLocal");  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var status = [];
                
                var areas = response.getReturnValue();
                for ( var key in areas ) {
                    status.push({value:areas[key], key:key});
                    
                }
                component.set("v.LocalOptions", status);
            }
        });  
        $A.enqueueAction(action); 
    },
    loadPriceList : function(component, event) {
        
        var action = component.get("c.getPriceList");  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var status = [];
                
                var areas = response.getReturnValue();
                for ( var key in areas ) {
                    status.push({value:areas[key], key:key});
                    
                }
                component.set("v.PricelistOptions", status);
            }
        });  
        $A.enqueueAction(action); 
    },
    loadPriceUnit : function(component, event) {
        
        var action = component.get("c.getPriceUnit");  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var status = [];
                
                var areas = response.getReturnValue();
                for ( var key in areas ) {
                    status.push({value:areas[key], key:key});
                    
                }
                component.set("v.PriceUnitOptions", status);
            }
        });  
        $A.enqueueAction(action); 
    },
    loadTerminal : function(component, event) {
        
        var action = component.get("c.getTerminal");  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var status = [];
                
                var areas = response.getReturnValue();
                for ( var key in areas ) {
                    status.push({value:areas[key], key:key});
                    
                }
                component.set("v.TerminalOptions", status);
            }
        });  
        $A.enqueueAction(action); 
    },
    
      closeQuickActionHelper: function(component, event) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
     backAction: function(component, event) {
         $A.util.removeClass(component.find("container1"), 'slds-hide');
         $A.util.addClass(component.find("container2"), 'slds-hide');
    },
    
    
})