({
    loadCaseStatus : function(component, event) {
   
         var action = component.get("c.loadCaseStatus");
         action.setParams({
            caseId: component.get("v.recordId")
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                
                var resp = response.getReturnValue();
                var casestatus = [];
                for (var key in resp) {
                    casestatus.push({
                        value: resp[key],
                        key: key
                    });
                }
                 	component.set("v.Status",casestatus);
                  //  component.set("v.Status",false);
                    
               }
            
        });
        $A.enqueueAction(action);
    
	},
    
    updatecase : function(component, event) {
        
        
        var action = component.get("c.SaveCase");
        var caseid=component.get("v.recordId");
       var statusField = component.find("select-01").get("v.value");
     
        var caseRelatedTo =component.get("v.selItem.textId");
       var timeConsumptionUnit =component.find("timeConsumption").get("v.value");
        //Expected Resume Code starts expectedResumed
        var expectedResumedUnit = component.find("expectedResumed").get("v.value");
        //ExpectedResume Code Ends
   
       // timeConsumptionUnit = timeConsumptionUnit.replace(",", ".");
        
          var emailUpdate =component.find("chk1").get("v.value");
          var firstTime = true;
       var notify =component.find("chk3").get("v.value");
          var vip =component.find("chk4").get("v.value");
          var subject =component.find("subj").get("v.value");
          var description =component.find("desc").get("v.value");
           var comment =component.find("commnt").get("v.value");
      
       if(statusField == ''){
           var errormsg= $A.get("$Label.c.cs_Select_status");
         
                    this.handleShowNoticeHelper(component,errormsg);  
                   
           			return false;
                }
        
        if (timeConsumptionUnit=='undefined') {
            
            this.handleShowNoticeHelper(component,"invalid time");
            return false;
             
         }
        //Expected Resumed Code starts
        if(expectedResumedUnit=='undefined'){
            this.handleShowNoticeHelper(component,"invalid time");
        }
        //Expected Resumed code Ends
       
         action.setParams({
            caseId: caseid,
            statusField: statusField,
             caseRelatedTo :caseRelatedTo,
             timeConsumptionUnit :timeConsumptionUnit,
             //Expected Resumed code starts
             expectedResumedUnit :expectedResumedUnit,
             //Expected Resumed code ends
             emailUpdate : emailUpdate,
             firstTime :firstTime,
             notify : notify,
             vip:vip,
             subject :subject,
             description:description,
             comment:comment
        
        });
           action.setCallback(this, function(response) {
          var state = response.getState();
           
            if (state === "SUCCESS" && component.isValid()) {
         	var storeResponse = response.getReturnValue();
                
                          if(storeResponse!= "Success"){
                    this.handleShowNoticeHelper(component,storeResponse);    
           			return false;
                }
               else  if(storeResponse== "Success"){
               var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": $A.get("$Label.c.cs_Case_closed_sucessfully"),
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
    loadCaseDetails :function(component, event) {
   
         var action = component.get("c.loadCaseDetails");
         action.setParams({
            caseId: component.get("v.recordId")
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
              
                if($A.util.isEmpty(response.getReturnValue())){
                    component.set("v.caseclosed",true);
                    this.handleShowNoticeHelper(component, $A.get("$Label.c.cs_Case_already_closed"));    
           			return false;
                                                   
                }else{
                   
                	component.set("v.caseToBeClosed",response.getReturnValue());
                  //  component.set("v.Status",false);
                    
               }
            }  
        });
        $A.enqueueAction(action);
    },
})