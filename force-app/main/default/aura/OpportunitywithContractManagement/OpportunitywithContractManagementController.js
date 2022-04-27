({
      doInit : function(component, event, helper) {
          helper.CurrentOpportunity(component,event,helper);
          helper.disableprofile(component,event);
      },
	 
             
    UpdateOpportunity:function(component, event, helper){
        console.log('update opportunity',component.get("v.Opp"));
        helper.UpdateOpportunityHelper(component,event,helper);
    },
    
    searchUser:function(component, event, helper){
         console.log('update user',component.get("v.XYZ"));
        helper.searchUserHelper(component,event,helper);
        
    },
       
})