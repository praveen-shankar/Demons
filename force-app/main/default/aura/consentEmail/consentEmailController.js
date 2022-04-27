({
    sendMail: function(component, event, helper) {
        
        var getEmail = component.get("v.email");
        var getSubject = component.get("v.subject");
        var getbody = component.get("v.body");
        
            helper.sendHelper(component, getEmail, getSubject, getbody);
        
    },

    closeMessage: function(component, event, helper) {
        component.set("v.mailStatus", false);
        component.set("v.email", null);
        component.set("v.subject", null);
        component.set("v.body", null);
        $A.get("e.force:closeQuickAction").fire(); 
    },
    
  
           
     doInit : function(component, event, helper) {
         
         helper.loadEmail(component,event);
         helper.loadBody(component,event);
         helper.loadSubject(component,event);
     }, 
    
})