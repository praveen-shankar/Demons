({
    editOpportunity: function(component, event) {
        
        var action = component.get("c.editOpportunity");
        
        action.setParams({
            'oppLineitemId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is 0 ,display no record found message on screen.
                
                if (storeResponse.length > 0) {
                    //set id ..
                    
                    component.set("v.actualServiceValue", storeResponse);
                    component.set("v.opplineitemId",storeResponse[0].Id );
                    component.set("v.oppId",storeResponse[0].OpportunityId );
                    
                    var fieldsfromobject = storeResponse; // component.get("v.servicesColumns");
                    
                    var fieldsarray = [];
                    for(var pq in fieldsfromobject) {
                        fieldsarray.push(fieldsfromobject[pq].crm_Terminals__c);
                    }
                    
                    var  fullString = JSON.stringify(fieldsarray);                  
                    var fullArray = [];
                    fullArray = fullString.split(';');                    
                    //alert("fullArray " + fullArray);                    
                    var tArrLen = fullArray.length;
                    //alert("len"+fullArray.length);
                    var tList = [];                                        
                    for (var i = 0; i < tArrLen; i++) {
                        //  alert("~~open"+fullArray[i].indexOf("["));
                        // alert("~~close"+fullArray[i].indexOf("]"));
                        if(fullArray[i].indexOf("[")!=-1)
                        {
                            //alert("fullArray i " + fullArray[i].substring(2))
                            
                            // alert("tlist"+tList);
                            var subStr = fullArray[i].substring(2);
                            
                            if(subStr.indexOf("]")!=-1)
                            {
                                // alert("in else");
                                tList.push({value:subStr.substring(0,subStr.length-2), key:i}); 
                            }
                            else
                            {
                                tList.push({value:subStr, key:i});
                            }
                            
                        }
                        
                        else if(fullArray[i].indexOf("]")!=-1)
                        {
                            //alert("~~inside elsif"+fullArray[i].indexOf("]"));
                            //alert("fullArray j " + fullArray[i].substring(0,fullArray[i].length-2))
                            tList.push({value:fullArray[i].substring(0,fullArray[i].length-2), key:i});
                        }
                            else
                            {                            
                                tList.push({value:fullArray[i], key:i});
                            }
                    }
                    
                    //  alert("tList " + tList);
                    component.set("v.actualServiceTerminalValue", tList);
                    //alert("actualServiceTerminalValue " + component.get("v.actualServiceTerminalValue"));
                    console.log("actualServiceTerminalValue " + component.get("v.actualServiceTerminalValue"));
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getAdditionalServices: function(component, event) {
        
        var action = component.get("c.getAdditionalServices");
        
        action.setParams({
            'oppLineitemId': component.get("v.recordId")
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
    
    getServicescolumns: function(component, event) {
        
        var action = component.get("c.getActualServicesData");
        action.setParams({
            'oppLineitemId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is 0 ,display no record found message on screen.
                
                if (storeResponse.length > 0) {
                    
                    component.set("v.servicesColumns", storeResponse);
                    var fieldsfromobject = storeResponse; // component.get("v.servicesColumns");
                    
                    var fieldsarray = [];
                    for(var pq in fieldsfromobject) {
                        fieldsarray.push(fieldsfromobject[pq].crm_API_Name__c);
                    }
                    
                    for(var x=0;x<fieldsarray.length;x++) {
                        if(fieldsarray.includes("crm_Minimum_Price__c"))
                            component.set("v.showMinimumPrice",true);
                        if(fieldsarray.includes("crm_Minimum_PricePercent__c"))
                            component.set("v.showMininumPricePercent",true);
                        
                        if(fieldsarray.includes("crm_Conversion_Factor__c"))
                            component.set("v.showConversionFactor",true);
                        
                        if(fieldsarray.includes("crm_Direction__c"))
                            component.set("v.showDirection",true);
                        
                        if(fieldsarray.includes("crm_Local__c"))
                            component.set("v.showLocal",true);
                        if(fieldsarray.includes("crm_Price_List_Business_Delivery__c"))
                            component.set("v.showPriceList",true);
                        if(fieldsarray.includes("crm_Price_Unit__c"))
                            component.set("v.showPriceUnit",true);
                        
                        if(fieldsarray.includes("crm_Terminals__c"))
                            component.set("v.showTerminal",true);
                        
                        
                        if(fieldsarray.includes("crm_Unit_Price__c"))
                            component.set("v.showUnitPrice",true);
                        
                        
                        if(fieldsarray.includes("crm_Discount__c"))
                            component.set("v.showDiscount",true);
                        
                        if(fieldsarray.includes("IsPayerReceiverorSender__c"))
                            component.set("v.showIsPayerReceiverorSender",true);
                        
                        
                        
                    }
                }
                
            }
            
            
        });
        $A.enqueueAction(action);
    },   	
    
    
    closeQuickActionHelper: function(component, event) {
        /*
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.oppId"),
            "slideDevName": "related"
        });
        navEvt.fire();
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
        =============*/
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'view',
                recordId: component.get("v.oppId")
            }
        };
        navService.navigate(pageReference,true);
       // location.reload();
       
        /* var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get("v.oppId"),
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                    location.reload();*/
        
    },
    
    nextstep: function(component, event) {
        
        // component.set("v.showContainer1", false);
        // debugger;
        $A.util.removeClass(component.find("container2"), 'slds-hide');
        $A.util.addClass(component.find("container1"), 'slds-hide');
    },
    
    loadConversionFactor : function(component, event) {
        
        var action = component.get("c.getConversionFactor");  
        console.log("out1 areaa");
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
        console.log("out1 areaa");
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
    
     loadPassivereturn : function(component, event) {
        
      var action = component.get("c.getpassivereturn");  
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var status = [];
                
                var areas = response.getReturnValue();
                for ( var key in areas ) {
                    status.push({value:areas[key], key:key});
                    
                }
                component.set("v.Passivereturnoptions", status);
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
    
    loadIsPayerReceiverorSender : function(component, event) {
        debugger;
        var action2 = component.get("c.getIsPayerReceiverorSender");  
        //alert('asdasdasd');
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var status = [];
                
                var areas = response.getReturnValue();
                //alert('response.getReturnValue()-----'+response.getReturnValue());
                for ( var key in areas ) {
                    status.push({value:areas[key], key:key});
                    
                }
                component.set("v.IsPayerReceiverorSenderOptions", status);
            }
        });  
        $A.enqueueAction(action2); 
    },
    backAction: function(component, event) {
        
        $A.util.removeClass(component.find("container1"), 'slds-hide');
        $A.util.addClass(component.find("container2"), 'slds-hide');
    },
    
    saveAction:function (component, event){
        var discount= '';
        discount= component.find("crm_Discount__c");
        var discountvalue='';
        discountvalue= discount.get("v.value"); 
        
        var minprice= '';
        minprice=component.find("crm_Minimum_Price__c");
        var Minpricevalue='';
        Minpricevalue= minprice.get("v.value"); 
               
        var unitprice= '';
        unitprice= component.find("UnitPrice");
        var unitpricevalue='';
        unitpricevalue=unitprice.get("v.value"); 
               
        var minweight= '';
        minweight= component.find("minweight");
        var minweightvalue='';
        minweightvalue= minweight.get("v.value"); 
        
        var maxweight= '';
        maxweight= component.find("maxweight");
        var maxweightvalue='';
        maxweightvalue= maxweight.get("v.value"); 
              
        var conversionFactor='';
        conversionFactor=component.get("v.actualServiceValue[0].crm_Conversion_Factor__c");
        
        var passivereturn='';
        passivereturn=component.get("v.actualServiceValue[0].crm_Passive_Return__c");
        var direction= '';
        direction=component.get("v.actualServiceValue[0].crm_Direction__c");
       
        var terminal= '';
        terminal= component.get("v.actualServiceValue[0].crm_Terminals__c");  
       	
        var isPayerReceiverorSender = '';
        isPayerReceiverorSender = component.get("v.actualServiceValue[0].IsPayerReceiverorSender__c");  
       
        var local= '';
        local = component.get("v.actualServiceValue[0].crm_Local__c");
              
        var mainservice={};
        mainservice.asId= component.get("v.opplineitemId");
        mainservice.oppId='';
        mainservice.discount= discountvalue;
        mainservice.minimumprice= Minpricevalue;
        mainservice.unitprice= unitpricevalue;
        mainservice.minweight = minweightvalue;
        mainservice.maxweight = maxweightvalue;
        mainservice.local= local;
        mainservice.conversionfactor= conversionFactor;
        mainservice.direction= direction;
        mainservice.terminals= terminal;
        mainservice.passivereturn = passivereturn;
        mainservice.isPayerReceiverorSender = isPayerReceiverorSender;
       
        if(component.find('freepickupflag').get("v.checked")) {
            mainservice.freepickup = "true";
        } else {
            mainservice.freepickup = "false";
        }
        
        /* if(component.find('passivereturnflag').get("v.checked")) {
            mainservice.passivereturn = "true";
        } else {
            mainservice.passivereturn = "false";
        }*/
       var allAddSer = [];
       if (!$A.util.isUndefined(component.find('EditAdditionalServices'))){
        var children = component.find('EditAdditionalServices');
       
   
        if ($A.util.isArray(children)) {
           for (var ik in children) {
               allAddSer.push(children[ik].captureadditionalservicesdata()); 
           }
        } 
        else
        	allAddSer.push(children.captureadditionalservicesdata());
       }  
        mainservice.additionalServices = allAddSer; 
        var saveAction = component.get("c.updateLineItems");
       
        var tosend = JSON.stringify(mainservice);
        saveAction.setParams({
            'json': tosend
        });
        
        console.log(tosend);
       
            
        saveAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var resp = response.getReturnValue();
                if (resp == 'done') {
                 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The records have been updated successfully.",
                        "type": "success"
                    });
                    
                    
                    
                    $A.get("e.force:closeQuickAction").fire();
                    toastEvent.fire();
                    //$A.get('e.force:refreshView').fire();
                    
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get("v.oppId"),
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                    //location.reload();
                } 
                else {
                    
                    component.set("v.saveerror", resp);
                }
            } 
        });
        $A.enqueueAction(saveAction);
        
        
    },
    
})