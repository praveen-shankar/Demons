({
	 doInit : function(component, event, helper) {
        helper.loadCaseDetails(component, event);
        helper.loadCaseComments(component, event);
                
    },
    closeQuickAction: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId")
            
        });
        navEvt.fire();
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
        
    },
    
    releaseorderAction: function(component, event, helper) {
    
      var action = component.get("c.releaseorderFn");
      var caseId=component.get("v.recordId");
      var reasonField = component.find("reason");
      var reasonValue = reasonField.get("v.value");
      action.setParams({
            caseId: component.get("v.recordId"),
            caseReason: reasonValue 
        });
           action.setCallback(this, function(response) {
          var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
         	var storeResponse = response.getReturnValue(); 
                if(storeResponse == "success" )
                    {
                   
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": $A.get("$Label.c.cs_order_released"),
                    "message": $A.get("$Label.c.cs_Please_view_the_case_details"), 
                    "type":"success"
                    
                });
              
                // Update the UI: close panel, show toast, refresh account page
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
                   
         }     
          
          }
        });
        $A.enqueueAction(action);
             
},
 
    releasecloseAction: function(component, event, helper) {
        
         var action = component.get("c.releaseorderFn");
        var reasonField = component.find("reason");
        var reasonValue = reasonField.get("v.value");
         
       var caseId = component.get("v.recordId");
      
         action.setParams({
            caseId: component.get("v.recordId"),
            caseReason: reasonValue 
        });
        
          action.setCallback(this, function(response) {
          var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
       
         $A.util.addClass(component.find("container1"), 'slds-hide');
         $A.util.addClass(component.find("container2"), 'slds-show');
         component.set("v.showContainer2", true);
                
         	 /*  var vfUrl =  "/" + caseId + "/s?retURL=%2F" + caseId;
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                  "url": vfUrl
                });
                urlEvent.fire() ;*/  	 
              
      
         }     
          
        });
        $A.enqueueAction(action);
        
    },
     handleShowNoticeHelper : function(component, msg) {
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "Attention",
            "message": msg,
            closeCallback: function() {
                $A.get("e.force:closeQuickAction").fire();
            }
        });
    },
    
    
})