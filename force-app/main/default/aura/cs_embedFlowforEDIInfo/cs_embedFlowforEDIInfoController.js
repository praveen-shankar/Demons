({
   init : function (component,event, helper) { 
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        var recordId = component.get("v.recordId");
        //alert("test-init");
        var flowStatus=component.get("v.flowStatus");
       
       	if(component.get("v.isFlowStarted")==true){
           component.set("v.isFlowStarted",false);
           //alert("calling update" +recordId);
           
          helper.updateRecord(component,event,helper);
 
           /*var urlEvent = $A.get("e.force:navigateToSObject");
           urlEvent.setParams({
               		"recordId":recordId,
               		"isredirect":"true"
           			});
           urlEvent.fire();   */
           if(flowStatus!="FINISHED"){
           		//window.location ='/lightning/r/Case/'+recordId+'/view';   
           		window.location.reload(true);
            } 
            component.set("v.flowStatus"," ");  
        }
                   
       var inputVariables = [
			{ name : "recordId", type : "String", value: component.get("v.recordId") }
		];
       //alert("flow input--->"+inputVariables);
       flow.startFlow("Select_EDI_Names_Related_to_EDI_Account",inputVariables);
    },
    
        
    handleStatusChange : function (component, event) {
      //alert(event.getParam("status"));
      if(event.getParam("status") === "STARTED") {
         component.set("v.isFlowStarted",true);
         //alert("isFlowStarted-->"+component.get("v.isFlowStarted"));
         }
      if(event.getParam("status") === "FINISHED") {
         component.set("v.flowStatus","FINISHED");
		 $A.get('e.force:refreshView').fire();       
         }
      },
    
    toggleSection : function(component, event, helper) {
        var ediInfo=component.get("v.ediInfo");
        //alert("toggle1-->"+ediInfo);
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();
        helper.toggleMethod(component, event, helper,sectionDiv,ediInfo);       
    }
})