({
	 doInit : function(component, event, helper) {
        helper.loadLineItems(component, event);
        helper.loadtransactiondetails(component, event);
        helper.loadcasedetails(component, event);
        helper.loadarticles(component, event);
        helper.loadRegressType(component, event);
        helper.loadOperatingUnit(component, event);
       
    },
    
     onChangearticle: function (component, event, helper) {
		var selectedarticle = event.getSource().get("v.value");
        component.set("v.lineitemrecord.Type__c",selectedarticle);
        component.set("v.type",selectedarticle);
         
         
         },
     closeQuickAction: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId")
            
        });
        navEvt.fire();
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
        
    },
     addline : function(component, event, helper){
        helper.addlinehelper(component, event);
    },
   
})