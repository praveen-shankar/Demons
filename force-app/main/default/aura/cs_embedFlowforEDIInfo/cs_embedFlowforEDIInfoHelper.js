({
	toggleMethod : function(component, event, helper,sectionDiv,ediInfo) {
		 //alert("toggle2-->"+ediInfo);
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        //var secInfo=component.get("v.sectionOpen");
		
        //alert("Toggle@@@--div--->"+sectionDiv+"--state--->"+sectionState+"ediInfo---->"+ediInfo);
        if(ediInfo==null){
           sectionState = -1; 
        }
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
	},
    
    updateRecord : function (component,event,helper){
        var flowStatus=component.get("v.flowStatus");
        //alert("Update--->"+ component.get("v.flowStatus")+"test---->"+test);
        if(flowStatus!="FINISHED"){
        //alert("Update2"+ component.get("v.flowStatus"));
        var action = component.get("c.updateEDIInfo");
        action.setParams({"caseId": component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
        var state = response.getState();
        //alert("update state---------->"+state);
        if(state == "SUCCESS"){
            var c = response.getReturnValue();  
            //$A.get("e.force:refreshView").fire();
        } else {
            console.log('There was a problem : '+response.getError());
        }
            
        });
    $A.enqueueAction(action);
        }
    }
})