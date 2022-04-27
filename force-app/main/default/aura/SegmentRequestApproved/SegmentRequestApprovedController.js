({
	doInit: function(component, event, helper) {
        
         helper.loadsegmentapproved(component, event);
        
    },
     selectall: function(component, event, helper) {
        var checkvalue = component.find("selectAll").get("v.value");  
      
        var checkContact = component.find("selected"); 
      
        if(checkvalue == true){
            for(var i=0; i<checkContact.length; i++){
                checkContact[i].set("v.value",true);
            }
        }
        else{ 
            for(var i=0; i<checkContact.length; i++){
                checkContact[i].set("v.value",false);
            }
        }
    },
    
    
     redirectToSobject: function (component, event, helper) {
    var navEvt = $A.get("e.force:navigateToSObject");
        
          var selectedItem = event.currentTarget;
      var IdP = selectedItem.dataset.record;
    navEvt.setParams({
      "recordId":IdP,
      "slideDevName": "Detail"
    });
    navEvt.fire();
},
    
    submit: function(component, event, helper) {
      
        //helper.initiateBatch(component, event);
          var action = component.get("c.initiateBatch");
          var segmentdata = component.get("v.segmentListApproved");
        //alert('gsafg'+ segmentdata);	
        var selectedLists = [];
         for(var i=0;i<segmentdata.length;i++){
           
            if(segmentdata[i].selected == true){
                selectedLists.push(segmentdata[i].Id);
            }
        } 
        if(selectedLists.length == 0){
            alert('error')
            //this.handleShowNoticeHelper(component,"Please select records for processing "); 
            //return false;	
        }
        
       
        
        action.setParams({
           selectedLists:selectedLists
            
        });
       
            action.setCallback(this, function(response) {
            var state = response.getState();
           
            if(state === "SUCCESS") {
                var resp = response.getReturnValue(); 
                                   if(resp.length===0)
                    {
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Success",
                    "message": "Batch job done successfully", 
                    "type":"success"
                    
                });
                
                // Update the UI: close panel, show toast, refresh account page
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
                /*var navEvt = $A.get("e.force:navigateToSObject");
                 navEvt.setParams({
                  "recordId": component.get("v.recordId"),
                  "slideDevName": "related"
                });
                navEvt.fire();*/
            }
                
                else if(resp.length>0){
                    component.set("v.showerror",true);
               
                    
                }
           else if (state === "ERROR") {
                console.log('Problem saving segment, response state: ' + state);
            }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
            }
        });
        
        
        $A.enqueueAction(action);
       
    
        
    },
    
   
})