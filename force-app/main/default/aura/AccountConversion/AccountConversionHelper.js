({
        CurrentAccount : function(component, event) {
        var action = component.get("c.getAccount");
        
       
        action.setParams({
    		Accountid: component.get("v.recordId")
		});   	    
        
        action.setCallback(this, function(response) {
          
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.Acc", response.getReturnValue());
                
            }
         });  
         $A.enqueueAction(action); 
        
    }, 
    
	loadConnectedagreementoptions : function(component, event) {
        var action = component.get("c.getConnectedAgreement"); 
               
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var ConversionProcess = [];
                
                var areas = response.getReturnValue();
				ConversionProcess.push({value:'', key:''});
                
                for ( var key in areas ) {
                    ConversionProcess.push({value:areas[key], key:key});
                    
                }
                component.set("v.Connectedagreement", ConversionProcess);
                
                
            }
        });  
        $A.enqueueAction(action);   
        
    }, 
    
    
    loadConversionProcessOptions : function(component, event) {
        var action = component.get("c.getCoversionProcess"); 
               
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var ConversionProcess = [];
                
                var areas = response.getReturnValue();
				ConversionProcess.push({value:'', key:''});
                
                for ( var key in areas ) {
                    ConversionProcess.push({value:areas[key], key:key});
                    
                }
                component.set("v.ConversionProcessOptions", ConversionProcess);
                
                
            }
        });  
        $A.enqueueAction(action);   
        
    }, 
    
   
        loadConversionHeatOptions : function(component, event) {
        var action = component.get("c.getConverisonHeat"); 
               
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var ConHeat = [];
                
                var areas = response.getReturnValue();
                ConHeat.push({value:'', key:''});
                
                for ( var key in areas ) {
                    ConHeat.push({value:areas[key], key:key});
                    
                }
                component.set("v.ConvHeatOptions", ConHeat);
                
                
            }
        });  
        $A.enqueueAction(action);   
        
    }, 
    
    loadCustomerGrp: function(component, event) {
        var action = component.get("c.getConvCustomerConversionGroupc"); 
               
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var Customergrp = [];
                
                var areas = response.getReturnValue();
                
                Customergrp.push({value:'', key:''});
                for ( var key in areas ) {
                    
                    Customergrp.push({value:areas[key], key:key});
                    
                }
                component.set("v.CustomerGroup", Customergrp);
                
                
            }
        });  
        $A.enqueueAction(action);   
        
    },
    
    loadCustomerStatus: function(component, event) {
        var action = component.get("c.getCustomerStatus"); 
               
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var CustomerStatus = [];
                
                var areas = response.getReturnValue();
                
                CustomerStatus.push({value:'', key:''});
                for ( var key in areas ) {
                    
                    CustomerStatus.push({value:areas[key], key:key});
                    
                }
                component.set("v.CustomerStatus", CustomerStatus);
                
                
            }
        });  
        $A.enqueueAction(action);   
        
    },
    
    loadCustomerStateOptions: function(component, event) {
        var action = component.get("c.getCustomerState"); 
               
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var CustSate = [];
                
                var areas = response.getReturnValue();
                CustSate.push({value:'', key:''});
                
                for ( var key in areas ) {
                    CustSate.push({value:areas[key], key:key});
                    
                }
                component.set("v.ConversionStateOptions", CustSate);
               
            }
        });  
        $A.enqueueAction(action);   
        
    }, 

   
    
    readonly : function(component, event) {
        var action = component.get("c.getConversionFlag");
        var ab = component.get("v.recordId");
       
        action.setParams({
    		Accountid: component.get("v.recordId")
		});   	    
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.flag", response.getReturnValue());
                
            }
         });  
         $A.enqueueAction(action); 
        
    }, 
    
        disableprofile : function(component, event) {
        var action = component.get("c.getprofilename");
        var ab = component.get("v.recordId");
       
        action.setParams({
    		Accountid: component.get("v.recordId")
		});   	    
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.profileflag", response.getReturnValue());
                
            }
         });  
         $A.enqueueAction(action); 
        
    }, 
 
    hideComponent : function(component, event) {
            var action = component.get("c.gethidecomponent");
            var ab = component.get("v.recordId");
           
            action.setParams({
                Accountid: component.get("v.recordId")
            });   	    
            
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.show", response.getReturnValue());
                    
                }
             });  
             $A.enqueueAction(action); 
            
        }, 
    
    loadEdiStatusOptions : function(component, event) {
        var action = component.get("c.getEDIStatus"); 
               
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var EdiStatus = [];
                
                var areas = response.getReturnValue();
				EdiStatus.push({value:'', key:''});
                
                for ( var key in areas ) {
                    EdiStatus.push({value:areas[key], key:key});
                    
                }
                component.set("v.EdiStatus", EdiStatus);
                
            }
        });  
        $A.enqueueAction(action);   
        
    }, 
    
    loadApiStatusOptions : function(component, event) {
        var action = component.get("c.getApiStatus"); 
               
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var ApiStatus = [];
                
                var areas = response.getReturnValue();
				ApiStatus.push({value:'', key:''});
                
                for ( var key in areas ) {
                    ApiStatus.push({value:areas[key], key:key});
                    
                }
                component.set("v.ApiStatus", ApiStatus);
                
            }
        });  
        $A.enqueueAction(action);   
        
    }, 
         
    
    
})