({
      loadtemplates: function(component, event) {
         var action = component.get("c.loadtemplates");
         
            action.setCallback(this, function(response) {
            var state = response.getState();
           if($A.util.isEmpty(response.getReturnValue())){
                     component.set("v.nolines", true); 
                 }else{
                   
                var articles = [];
                var response = response.getReturnValue();
                for(var key in response){
                    articles.push({value:response[key], key:key});
                }
                                  
                  	component.set("v.allowedTemplates",articles);
                 }
              
        });
        $A.enqueueAction(action);
  	
	},
    
    
     loadstatus: function(component, event) {
         var action = component.get("c.getStatus");
         
            action.setCallback(this, function(response) {
            var state = response.getState();
           if($A.util.isEmpty(response.getReturnValue())){
                     component.set("v.nolines", true); 
                 }else{
                   
                var articles = [];
                var response = response.getReturnValue();
             
                for(var key in response){
                    articles.push({value:response[key], key:key});
                }
                           
                  	component.set("v.allowedStatus",articles);
                 }
              
        });
        $A.enqueueAction(action);
  	
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
                   
                                                   
                }else{
                   
                	component.set("v.caseobj",response.getReturnValue());
                  //  component.set("v.Status",false);
                    
               }
            }  
        });
        $A.enqueueAction(action);
    },
    
    addPIBhelper : function(component, event) {
     var subject='';
     var emailbody='';
     var notifydistrictmanager='';
     var status='';
     var isValid = true;
        
     subject=  component.find("subject").get("v.value"); 
     emailbody=  component.find("desc").get("v.value");
     notifydistrictmanager =  component.find("notifymanagerchk").get("v.value");   
     status = component.find("statusid").get("v.value");
     if(status=='None')
     {
           this.handleShowNoticeHelper(component,'Select status');   
           isValid=false;
           return false;
         
     }
        
      var action = component.get("c.addPIBfn");
         action.setParams({
            caseId: component.get("v.recordId"),
            subject:subject,
            emailbody : emailbody,
            notifydistrictmanager:  notifydistrictmanager, 
            status:status
             
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
                    "title": $A.get("$Label.c.PIB_message_created"),
                    "message": $A.get("$Label.c.View_PIB_Details"), 
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
               // $A.get("e.force:closeQuickAction").fire();
            }
        });
    },
	
        
})