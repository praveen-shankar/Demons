({
    //To Get All Opportunities Service Group 
    getOpportunitiesServiceGroup: function(component, event, helper) {
        var action = component.get("c.getAllOpportunitiesServiceGroup");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state: ' + state);
            if (state === "SUCCESS" && component.isValid()) {
                var opportunitiesServiceGroupArray = [];
                var opportunitiesServiceGroupResponse = response.getReturnValue();
                for (var key in opportunitiesServiceGroupResponse) {
                    
                    opportunitiesServiceGroupArray.push({
                        value: opportunitiesServiceGroupResponse[key],
                        key: key
                    });
                }
               
                component.set("v.OpportunitiesServiceGroup", opportunitiesServiceGroupArray);
                console.log("Opportunities Service Group Array" + opportunitiesServiceGroupArray);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadresponsibleseller: function(component, event) {
        var action = component.get("c.getresponsibleseller");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert("response for load responsible seller: "+response.getState());
            if (state === "SUCCESS" && component.isValid()) {
                var responsibleselleroptions = [];
                var resp = response.getReturnValue();
                for (var key in resp) {
                    responsibleselleroptions.push({
                        value: resp[key],
                        key: key
                    });
                }
                component.set("v.responsibleselleroptions", responsibleselleroptions);
            }
        });
        $A.enqueueAction(action);
    },
    
    //Get Selected Opportunities Service Group 
    getSelectedOppServiceGroup: function(component, event) {
        alert('Code to be written');
    },
    
    //Get Selected Responsible Seller 
    getSelectedResponsibleSeller: function(component, event) {
        alert('Code to be written');
    },
    
    //Action On Save Button
    saveSegment: function(component, event) {
        
        
        var segmentdata = component.find('segment');
        var allsegments = [];
        if ($A.util.isArray(segmentdata)) {
            for (var ik in segmentdata) {
                
                allsegments.push(segmentdata[ik].capturesegmentdata());
            }
        } else
            allsegments.push(segmentdata.capturesegmentdata());
         var counter =0;
        for (var i in allsegments) {
            //alert(allsegments[i].chkServiceGroupvalue);
            // alert(allsegments[i].proposedresponsibleSeller);
            
            if (allsegments[i].chkServiceGroupvalue == true && allsegments[i].proposedresponsibleSeller == '')
                
            {
                this.handleShowNoticeHelper(component, 'Please select reaponsible seller');
                return false;
            }
            if(allsegments[i].chkServiceGroupvalue == false && allsegments[i].proposedresponsibleSeller != ''){
               this.handleShowNoticeHelper(component, 'Please select the Serviuce Group checkbox');
                return false;  
                
            }
            counter= counter+1;
        }
         if (counter==0){
                  this.handleShowNoticeHelper(component,'Please select Proposed responsible seller , month '); 
                        return false;	
         }
        
        var mainservice={};
        //mainservice.accountId= '0010E00000TT1Nx';
        mainservice.accountId=component.get("v.recordId");
        
        mainservice.reqchangesegments = allsegments; 
        
        var saveAction = component.get("c.savesegment");
        var tosend = JSON.stringify(mainservice);
        
            
        saveAction.setParams({
            json: tosend
        });
        
        saveAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
             
                if(storeResponse.length===0)
                {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Responsible seller Created sucessfully",
                        "message": "Please refer the related list for responsible seller ", 
                        "type":"success"
                        
                    });
                    
                    // Update the UI: close panel, show toast, refresh account page
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                    
                    
                } else if(storeResponse.length>0){
                    component.set("v.errorLogs",storeResponse);
                    
                    
                }
                    else if (state === "ERROR") {
                        console.log('Problem saving responsible seller, response state: ' + state);
                    }
                        else {
                            console.log('Unknown problem, response state: ' + state);
                        }
            }
        });
        $A.enqueueAction(saveAction);
    },
    
    handleShowNoticeHelper: function(component, msg) {
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "No Seller",
            "message": msg,
            closeCallback: function() {
                //$A.get("e.force:closeQuickAction").fire();
            }
        });
    },
    
    //Action On Cancel Button
    cancelSegment: function(component, event) {
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})