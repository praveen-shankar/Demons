({
	doInit: function(component, event, helper) {
        
         helper.loadsegmentcompleted(component, event);
        
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
})