({
	//To Get Opportunities Service Group
    doInit : function(component, event, helper) {
        helper.getOpportunitiesServiceGroup(component, event, helper);
        helper.loadresponsibleseller(component, event, helper);
        
    },
    
    //Get Selected Opportunities Service Group 
    getSelectedOppServiceGroup : function(component, event, helper)
    {
    	helper.getSelectedOppServiceGroup(component, event, helper);
	}, 
    
    //Get Selected Responsible Seller 
    getSelectedResponsibleSeller : function(component, event, helper)
    {
    	helper.getSelectedResponsibleSeller(component, event, helper);
	},
    
    //Save Segment
    save : function(component, event, helper)
    {
        helper.saveSegment(component, event, helper);
    }, 
    
    //Cancel Segment
    cancel : function(component, event, helper)
    {
        helper.cancelSegment(component, event, helper);
    }
    
})