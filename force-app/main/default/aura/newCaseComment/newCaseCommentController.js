({
    doinit : function(component, event, helper)
    {        
        var recId=component.get("v.CasecommentId"); 
      var action = component.get("c.loadCasecommentDetails");
         action.setParams({
            casecommentId: recId
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
              
                                   
                	component.set("v.Casecommentobj",response.getReturnValue());
              //  alert(JSON.stringify(response.getReturnValue()));
                var resp = response.getReturnValue();
                console.log('&& publish &&'+resp.IsPublished);
                  //  component.set("v.Status",false);
                    // alert("published"+component.get("v.Casecommentobj.CommentBody"));
                   // alert("published"+component.get("v.Casecommentobj.IsPublished"));
               }
            }  
        );
         $A.enqueueAction(action);
        var action = component.get("c.loadCaseDetails");
         var recId1=component.get("v.CaseId");
         action.setParams({
            caseId: recId1
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {             
                                   
                	component.set("v.Caseobj",response.getReturnValue());
              //  alert(JSON.stringify(response.getReturnValue()));
                var resp = response.getReturnValue();
                console.log(resp);
              
               }
            }  
        );
        $A.enqueueAction(action);
    },
    cancel : function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId" : component.get("v.CaseId")
        });
        navEvt.fire();
        
    },
    save : function(cmp,event,helper){
         var recId=cmp.get("v.CasecommentId");
        //alert(recId);
        if(recId == null)
        {
           helper.savecomment(cmp,event,helper);
        }
        else
        {
  			
            // alert('Updating comment');
            helper.updatecomment(cmp,event,helper);
        }
      
    }
       
})