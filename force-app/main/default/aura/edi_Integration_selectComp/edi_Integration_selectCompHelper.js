({
	performCallout : function(component) {
		var action = component.get("c.process");
        action.setParams({
            recordId: component.get("v.recordId"),
            systemName: component.get("v.systemselected")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.showspinner",false);
            if (state === "SUCCESS" && component.isValid()) {
                let resp = response.getReturnValue();
                if ($A.util.isEmpty(resp)) {
                    component.set("v.showerror",true);
                    component.set("v.errormessage","The server returned an empty response. Please try again.");
                } else {                    
                    console.log("Response from Apex: " + JSON.stringify(resp));
                    if(resp.status === 'OK') {
                        $A.get('e.force:refreshView').fire();
                        this.toastEvent(component,"Success!",$A.get("$Label.c.edi_integrationSuccessToast"),"success");
                    } else {
                        component.set("v.showerror",true);
                        component.set("v.errormessage",resp.message);
                        this.toastEvent(component,"Error!",$A.get("$Label.c.edi_integrationFailureToast"),"error");
                    }    
                }
            } else if (state === "INCOMPLETE") {
                console.log("The server did not return a response. The server might be down or the client might be offline");
                component.set("v.showerror",true);
                component.set("v.errormessage","The server did not return a response. The server might be down or the client might be offline");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        component.set("v.showerror",true);
                        component.set("v.errormessage",errors[0].message);
                    }
                }
            }
        });
        
        $A.enqueueAction(action);
	},

    toastEvent : function(component,title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message + ' ' + component.get("v.systemselected"),
            "type": type
        });
        toastEvent.fire();
    },
    
    loadData : function(component,subscribeAgain) {
        var action = component.get("c.getInitialData");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            const empApi = component.find('empApi');
            if (state === "SUCCESS" && component.isValid()) {
                let resp = response.getReturnValue();
                if ($A.util.isEmpty(resp)) {
                } else {                    
                    console.log("Response from Apex on page load: " + JSON.stringify(resp));
                    component.set("v.edirecord",resp);
                    const subscription = component.get('v.subscription');
                    if(subscribeAgain) {
                        empApi.subscribe("/event/EDI_Event__e", -1, $A.getCallback(eventReceived => {
                            console.log('Event received '+JSON.stringify(eventReceived));
                            var payloadId = eventReceived.data.payload.RecordId__c;
                            if(payloadId === component.get("v.recordId")) {
                                this.loadData(component,false);
                            }
                        }))
                        .then(subscription => {
                            console.log('Subscribed to channel ', subscription.channel);
                            component.set('v.subscription', subscription);
                        });
                    }    
                    if(resp.EDI_System_Status__r === undefined) {
                        component.set("v.noSystemConfigured",true);
                        component.find("selectcomp").set("v.disabled",true);
                    } else {
                        component.set("v.noSystemConfigured",false);
                        component.find("selectcomp").set("v.disabled",false);
                        let LMfound = resp.EDI_System_Status__r.find(function(element) {
  							return element.System_Name__c === "LM";
						});
                        if(resp.Status__c === "PhaseOut" && LMfound != undefined && LMfound.System_Name__c === "LM") {
                        	component.set("v.showsystemLM",false);
                            component.find("selectcomp").set("v.value","");
                            component.find("transferbutton").set("v.disabled",true);
                            component.find("transferbutton").set("v.label",$A.get("$Label.c.edi_transferButton"));
                            component.find("selectcomp").set("v.title",$A.get("$Label.c.edi_phasedOutMsgLM"));
                        }    
                    }
                    if(resp.Imported_Data__c) {
                        component.set("v.importedData",true);
                        component.set("v.noSystemConfigured",false);
                        component.find("selectcomp").set("v.disabled",true);
                    }
                    if(!resp.Imported_Data__c && (resp.Status__c === "New" || resp.Status__c === "OnHold" || resp.Status__c === "Terminated" || resp.Disqualified_for_Integration__c)) {
                        component.find("selectcomp").set("v.disabled",true);
                        if(resp.Disqualified_for_Integration__c)
                        	component.find("selectcomp").set("v.title",$A.get("$Label.c.edi_msgPhaseOutToNew"));
                        else
                            component.find("selectcomp").set("v.title",$A.get("$Label.c.edi_msgDisabledIntegration"));
                    }
                    let systemsMap = this.arrayToMap(resp.EDI_System_Status__r);
                    component.set("v.systemsmap",systemsMap);
                    if(!$A.util.isEmpty(systemsMap)) {
                        console.log('Map of systems: ' + JSON.stringify(systemsMap));
                        let systemsMapArray = Object.values(systemsMap);
                        console.log('systemsMapArray is '+systemsMapArray);      
                        var tf = function(sm) {
  							return sm === false;
						};
                        var finalVal = systemsMapArray.some(tf);
                        console.log('finalVal is '+finalVal);    
                        if(!resp.Imported_Data__c && !resp.Disqualified_for_Integration__c && (resp.Status__c === "Production" || resp.Status__c === "Testing") &&
                           finalVal)
                            component.set("v.highlighterCondition",true);
                        else component.set("v.highlighterCondition",false);     
                    }
                }
            } else if (state === "INCOMPLETE") {
                console.log("The server did not return a response. The server might be down or the client might be offline");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    arrayToMap : function(listvalues) {
        let x;
        let obj = {};
        let notManualSystems = ['LM','MB'];
        if(!$A.util.isEmpty(listvalues)) {
            for(x=0;x<listvalues.length;x++) {
                if(notManualSystems.includes(listvalues[x].System_Name__c)) {
                	obj[listvalues[x].System_Name__c + '_'] = listvalues[x].Message_Sent_After_Data_Change__c;
                }
                else {
                	obj[listvalues[x].System_Name__c + '_manual'] = listvalues[x].Manual_Integration_Confirmation__c;
                }    
            }
        }    
       return obj; 
    },
                            
    onSelectChangeHelper : function(component, event) {
		let sval = component.find("selectcomp").get("v.value");
        component.set("v.errormessage","");
        component.set("v.showerror",false);
        if($A.util.isEmpty(sval)) {
            component.find("transferbutton").set("v.disabled",true);
			component.find("transferbutton").set("v.label",$A.get("$Label.c.edi_transferButton"));            
        } else {
            component.find("transferbutton").set("v.disabled",false);
            component.find("transferbutton").set("v.label",$A.get("$Label.c.edi_transferButtonDynamic") + ' ' + sval);
        }
        component.set("v.systemselected",sval);
	}                        
})