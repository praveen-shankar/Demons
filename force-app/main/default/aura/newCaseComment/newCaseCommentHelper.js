({
    doinit : function(component,event,helper){
      
   
    },
	savecomment : function(cmp,event,helper) {
		 var recId=cmp.get("v.CaseId");
        var bodytext;
        bodytext = cmp.find('Body').get('v.value');
        var publicvalue = cmp.find('Public').get('v.checked');
      //  alert("Checked"+bodytext);
      //  alert("Checked"+publicvalue);
         if(bodytext == undefined){
             console.log('Blank body');
           var errormsg= "Please fill required fields";
         
                    this.handleShowNoticeHelper(cmp,errormsg);  
                   
           			return false;
                }
      
        var action = cmp.get('c.insertcomment');
        action.setParams({
            caseId: recId,
            bodytext: bodytext,
            publicvalue: publicvalue
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse=='true')
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": 'Success',
                        "message": 'Case comment inserted successfully',
                        "type":"success"
                        
                    });
                    resultsToast.fire();
                    var redirect = $A.get("e.force:navigateToSObject");
                    
                    // Pass the record ID to the event
                    redirect.setParams({
                        "recordId": recId
                    });
                    
                    // Open the record
                    redirect.fire(); 
                    
                }
                else
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": 'Error',
                        "message": 'Case comment cannot be inserted',
                        "type":"error"
                        
                    });
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire(); 
                }
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        
        $A.enqueueAction(action);
        
    },
    updatecomment : function(cmp,event,helper) {
         var caserecId=cmp.get("v.CaseId");
		var recId=cmp.get("v.CasecommentId");
        var bodytext = cmp.find('Body').get('v.value');
        var publicvalue = cmp.find('Public').get('v.checked');
        //alert(bodytext);
         if(bodytext == undefined){
             console.log('Blank body');
           var errormsg= "Please fill required fields";
         
                    this.handleShowNoticeHelper(cmp,errormsg);  
                   
           			return false;
                }
      
        var action = cmp.get('c.updatecomment');
        action.setParams({
            caseId: recId,
            bodytext: bodytext,
            publicvalue: publicvalue
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse=='true')
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": 'Success',
                        "message": 'Case comment updated successfully',
                        "type":"success"
                        
                    });
                    resultsToast.fire();
                    var redirect = $A.get("e.force:navigateToSObject");
                    
                    // Pass the record ID to the event
                    redirect.setParams({
                        "recordId": caserecId
                    });
                    
                    // Open the record
                    redirect.fire(); 
                     
                    
                }
                else
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": 'Error',
                        "message": 'Case comment cannot be updated',
                        "type":"error"
                        
                    });
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire(); 
                }
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        
        $A.enqueueAction(action);
        
    },
    
    handleShowNoticeHelper : function(cmp, msg) {
        cmp.find('notifLib').showNotice({
            "variant": "error",
            "header": "Attention",
            "message": msg,
            closeCallback: function() {
                $A.get("e.force:closeQuickAction").fire();
            }
        });
    }
	
})