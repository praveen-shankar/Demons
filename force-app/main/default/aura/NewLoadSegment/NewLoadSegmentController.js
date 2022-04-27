({
    //To Get Opportunities Service Group
    doInit : function(component, event, helper) {
        helper.getOpportunitiesServiceGroup(component, event, helper);
        helper.loadresponsibleseller(component, event, helper);
    },
    
    capturesegmentdata : function(cmp,event,helper) 
    {
        var robj = {};
        var chkServiceGroup= cmp.find("chkServiceGroup");
        var chkServiceGroupvalue=chkServiceGroup.get("v.value");         
        var serviceGroup= cmp.find("serviceGroup");
        var serviceGroupvalue=serviceGroup.get("v.value");
        var proposedresponsibleSeller = cmp.find("proposedresponsibleSeller");
        var proposedresponsibleSellervalue = proposedresponsibleSeller.get("v.value"); 
        robj.serviceGroupvalue = serviceGroupvalue;
        robj.chkServiceGroupvalue = chkServiceGroupvalue;
        robj.proposedresponsibleSeller= proposedresponsibleSellervalue; 
        
        return robj;
    }
})