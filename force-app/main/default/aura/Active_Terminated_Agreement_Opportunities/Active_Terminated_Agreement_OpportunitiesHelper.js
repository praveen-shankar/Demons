({
	hlpRemoveOpportunity : function( cmp, event, helper) {
        debugger;
		var OpportunitySelectedForDelete =  cmp.get('v.OpportunityDeleteRecordId');

        console.log('OpportunitySelectedForDelete------------'+JSON.stringify(OpportunitySelectedForDelete));
                     
            var action = cmp.get("c.getOpportunityRecordToDelete");
            
                action.setParams({ "oppId" : OpportunitySelectedForDelete
                                  
                                 });
               
                action.setCallback(this, function(response) {
               		var state = response.getState();
					var DeletedResult = $A.get("e.force:showToast");
                    if (state === "SUCCESS") {
                        console.log("Response 1", response.getReturnValue());
                       helper.hlpShowMsg(cmp,$A.get("$Label.c.delete_Success_Message") ,$A.get("$Label.c.delete_message_status"), $A.get("$Label.c.delete_Success_Message_Tiltle"));
                       /* DeletedResult.setParams({
                            "title": $A.get("$Label.c.delete_Success_Message_Tiltle"),
                            "message": $A.get("$Label.c.delete_Success_Message"), 
                            "type": $A.get("$Label.c.delete_message_status")
                        });
                        location.reload();   
                    	DeletedResult.fire();*/
                         
                     
                    }else if(state === "ERROR"){
                         console.log("Response 2", response.getReturnValue());
                            helper.hlpShowMsg(cmp,$A.get("$Label.c.opp_Delete_Error_Message") ,$A.get("$Label.c.Opp_Delete_Error_Status"), $A.get("$Label.c.opp_Delete_Error_Title"));
                        /*DeletedResult.setParams({
                            "title": $A.get("$Label.c.opp_Delete_Error_Title"),
                            "message": $A.get("$Label.c.opp_Delete_Error_Message"), 
                            "type": $A.get("$Label.c.Opp_Delete_Error_Status")
                        });
                        
                    	DeletedResult.fire();
                        location.reload();  */ 
                    }
                    
                        
                });
               $A.enqueueAction(action);
        
        // Figure out which action was called
         //  component.set('v.OpportunityDeleteRecordId',OpportunitySelectedForDelete );
         /* var actionClicked = event.getSource().getLocalId();
          
          var navigate = cmp.get('v.navigateFlow');
          navigate(actionClicked);*/
	},
    
     sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.tabledata");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.tabledata", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
     hlpShowMsg : function(component,msg ,type, title) {
        console.log('currentTheme-----show msg---------'+component + '' +msg + '--'+type + '--' + title);

    	var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title+"!",
            "message": msg,
            "type" : type.toLowerCase()
        });
        location.reload();  
        toastEvent.fire();
	},
})