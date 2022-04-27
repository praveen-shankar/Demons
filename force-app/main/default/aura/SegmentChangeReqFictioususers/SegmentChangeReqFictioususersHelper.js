({
     loadsegment: function(component, event) {
     var action = component.get("c.getSegments");
        action.setParams({
            acctId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                
                if($A.util.isEmpty(response.getReturnValue())){
                    component.set("v.noSegmentsFound",true);
                    
                    this.handleShowNoticeHelpernogrps(component,"Change request is already iniatiated for all the service groups!");   
                  
                    
                }else{
                	component.set("v.segmentList",response.getReturnValue());
                     }
            }  
        });
        $A.enqueueAction(action);
    },
    
     handleShowNoticeHelper : function(component, msg) {
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "User input Error",
            "message": msg,
            /*closeCallback: function() {
                $A.get("e.force:closeQuickAction").fire();
            }*/
        });
    },
    
    handleShowNoticeHelpernogrps : function(component, msg) {
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "No service Group",
            "message": msg,
            closeCallback: function() {
                $A.get("e.force:closeQuickAction").fire();
            }
        });
    },

    
     savesegment: function(component, event) {
     var action = component.get("c.savesegment");
        action.setParams({
            acctId: component.get("v.recordId")
        });
         
        var segmentdata = component.find('segment');
        var allsegments = [];
        if ($A.util.isArray(segmentdata)) {
           for (var ik in segmentdata) {
             
               allsegments.push(segmentdata[ik].capturefictioussegmentdata()); 
           }
        } 
        else
        	allsegments.push(segmentdata.capturefictioussegmentdata());
         var d = new Date();
		 var currentMonth = d.getMonth()+1;
         var currentYear=d.getFullYear();
         
      
         var counter =0;
       
         for (var i in allsegments) {
        
             if (allsegments[i].proposedresponsibleSeller!= 'None'){
               
                 if (allsegments[i].month=='None'  ){//|| allsegments[i].year=='None'
              	 this.handleShowNoticeHelper(component,'Please select month');
              	 return false;	
                 }
             	/*if(currentMonth > allsegments[i].month  && currentYear >= allsegments[i].year) {
                   
               	 this.handleShowNoticeHelper(component,'Date selected should be greater than today');
          		return false;	
                     } */
                
                 
                 if(allsegments[i].proposedresponsibleSeller == allsegments[i].responsibleSeller){
                     
                      this.handleShowNoticeHelper(component,'Current and Proposed responsible sellers are same.Please select a different user '); 
                        return false;	
                 }
                
                    if (typeof(allsegments[i].responsibleSellermanager) =='undefined' ) {
                    	 this.handleShowNoticeHelper(component,'Manager not defined for current Sales responsible '); 
                        return false;	
                    }
                 
                  if (allsegments[i].proposedresponsibleSellermanager == null ){
                    	 this.handleShowNoticeHelper(component,'Manager not defined for proposed Sales responsible '); 
                        return false;	
                    }
                
             counter= counter+1;
             }//end o proposedresponsibleSeller
           /*else
               
             {
                 if (counter==0){
                  this.handleShowNoticeHelper(component,'Please select Proposed responsible seller , month and year'); 
                        return false;	
                 }
                     
             }*/
                 
             }

         if (counter==0){
                  this.handleShowNoticeHelper(component,'Please select Proposed responsible seller , month '); 
                        return false;	
                 }
                   
        var mainservice={};
        mainservice.accountId= component.get("v.recordId");
         
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
                    "title": "Segments Request Change created sucessfully",
                    "message": "Please refer Change requests", 
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
                console.log('Problem saving segment, response state: ' + state);
            }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
            }
        });
        $A.enqueueAction(saveAction);
    },
    
})