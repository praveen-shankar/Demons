({
	doInit: function(component, event, helper) {
        
         helper.getSegmentToBeApproved(component, event);
        
    },
    
     selectall: function(component, event, helper) {
        var checkvalue = component.find("selectAllvalues").get("v.value"); 
       
      
        var checkContact = component.find("selectedvalue"); 
      
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
   
    approverecords: function(component, event, helper) {
      
    var action = component.get("c.approverecordsfn");
    var segmentdata1 = component.get("v.getSegmentToBeApproved");
    
    var selectedLists1 = [];
    for(var i=0;i<segmentdata1.length;i++){
           
            if(segmentdata1[i].selected == true){
                selectedLists1.push(segmentdata1[i].Id);
            }
        } 
    
         if(selectedLists1.length == 0){
            alert('Please select the records to approve');
            //this.handleShowNoticeHelper(component,"Please select records for processing "); 
            return false;	
        }
        
         action.setParams({
           selectedLists1:selectedLists1
            
        });
        
         
           action.setCallback(this, function(response) {
           var state = response.getState();
         
            if(state === "SUCCESS") {
                var resp = response.getReturnValue(); 
               // alert(resp);
               if(resp.length>0)
                    {
                             location.reload();
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