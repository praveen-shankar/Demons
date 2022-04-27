({
	 CurrentOpportunity : function(component, event,helper) {
        var action = component.get("c.getOpportunity");
        console.log("Record id",component.get("v.recordId"));
       
        action.setParams({
    		Opportunityid: component.get("v.recordId")
		});   	    
        
        action.setCallback(this, function(response) {
          
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Response 1", response.getReturnValue());
                component.set("v.Opp", response.getReturnValue());
               // component.set("v.selItem", )
               //var result = response.getReturnValue();
                console.log("Check Opportunity", component.get("v.Opp"));
                /*console.log("Type", result.Type);
                if(result.Type == "Renegotiate" && result.crm_Close_Behaviour__c == "Renegotiate"){
                   component.set("v.visibleForRenegotiate", true); 
                }else{
                    component.set("v.visibleForRenegotiate", false); 
                }*/
                
            }
         });  
         $A.enqueueAction(action); 
        
    }, 
    UpdateOpportunityHelper:function(component, event,helper) {
        var newOpportunity = component.get("v.Opp");
        console.log("New Opportunity", component.get("v.Opp"));
	    var action = component.get("c.saveOpportunity");
        
       var userId = component.get("v.selItem.val");
      
       action.setParams({ 
            "Opp": newOpportunity,
            "userId" : userId
        }); 
  // if(( (newOpportunity.Customer_Numbers_for_linked_agreements__c==null  ||newOpportunity.Customer_Numbers_for_linked_agreements__c=='') && newOpportunity.Linked_agreements__c) &&  ((newOpportunity.Customer_Numbers_for_linked_agreements__c!=null  ||newOpportunity.Customer_Numbers_for_linked_agreements__c!='') && !newOpportunity.Linked_agreements__c)){
  // 
   if(( newOpportunity.Customer_Numbers_for_linked_agreements__c==null  ||newOpportunity.Customer_Numbers_for_linked_agreements__c=='') && newOpportunity.Linked_agreements__c)  {
         var errormsg= $A.get("$Label.c.linked_agreements_error_msg");
         //""
              this.handleShowNoticeHelper(component,errormsg);  
                   
           			return false;
        }
        
               action.setCallback(this, function(response) {
               var state = response.getState();
               if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                    if(storeResponse == "success" )
                    {
                       var resultsToast = $A.get("e.force:showToast");
  
                        resultsToast.setParams({
                            "title": "Record Updated sucessfully",
                            "message": "Opportunity Updated Successfully", 
                            "type":"success"
                        });
                     location.reload();   
                
                    resultsToast.fire();
   
            }
       			else  {

              
                    component.set("v.message", storeResponse);
                	component.set("v.Error", true);
                }
               

            }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
            
         }); 
          
         $A.enqueueAction(action);
       
        
    },
    
    searchUserHelper:function(component, event,helper) {
        
        var newOpportunity = component.get("v.Opp");
        var newUserName = component.get("v.XYZ");
        console.log("New UserName", newUserName);
        var action = component.get("c.getUser");       
        action.setParams({ 
            "Username": newUserName
            
        }); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state::'+state);
            if (state === "SUCCESS") {
                console.log("Response 2", response.getReturnValue());
                component.set("v.UserD", response.getReturnValue());
            }
        });
         $A.enqueueAction(action);
   
    },
    
     disableprofile : function(component, event) {
        var action = component.get("c.getprofilename");
      
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.profileflag", response.getReturnValue());
                
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