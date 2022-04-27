({
    doInit : function(component, event, helper) {
        helper.getSegmentList(component, event);
        helper.loadmonth(component, event);
       // helper.loadyear(component, event);
    },
    
     capturesegmentdata : function(cmp,event,helper) {
        var robj = {};
         var serviceGroup= cmp.find("serviceGroup");
         var serviceGroupvalue=serviceGroup.get("v.value");
         
        var month= cmp.find("month");
        var monthvalue=month.get("v.value"); 
        
       /* var year = cmp.find("year");
        var yearvalue = year.get("v.value"); */
         
        var reason = cmp.find("Reason_for_Change__c");
        var reasonvalue = reason.get("v.value"); 
      
        var responsibleSeller = cmp.find("responsibleSeller");
        var responsibleSellervalue = responsibleSeller.get("v.value"); 
         
        var responsibleSellermanager = cmp.find("responsibleSellermanager");
        var responsibleSellermanagervalue = responsibleSellermanager.get("v.value"); 
         
        var responsibleSellermanagerstatus = cmp.find("responsibleSellermanagerstatus");
        var responsibleSellermanagerstatusvalue = responsibleSellermanagerstatus.get("v.value"); 
       
        var proposedresponsibleSeller = cmp.find("proposedresponsibleSeller");
        var proposedresponsibleSellervalue = proposedresponsibleSeller.get("v.selItem.val");  
         
       
        var proposedresponsibleSellermanagervalue = proposedresponsibleSeller.get("v.selItem.managerid");
        var proposedresponsibleSellermanagervaluestatus = proposedresponsibleSeller.get("v.selItem.manageridstatus");
       
          //alert ('responsibleSellermanagervalue'+responsibleSellermanagervalue);
       
        robj.month =monthvalue; 
      //  robj.year = yearvalue;
        robj.responsibleSeller = responsibleSellervalue; 
        robj.responsibleSellermanager =  responsibleSellermanagervalue; 
        robj.responsibleSellermanagerstatusvalue= responsibleSellermanagerstatusvalue; 
        robj.proposedresponsibleSeller= proposedresponsibleSellervalue; 
        robj.proposedresponsibleSellermanager= proposedresponsibleSellermanagervalue; 
        robj.proposedresponsibleSellermanagervaluestatus= proposedresponsibleSellermanagervaluestatus; 
        robj.serviceGroupvalue = serviceGroupvalue;
        robj.reasonofchange = reasonvalue; 
        robj.segId = cmp.get("v.segId");
        robj.flag=0;
              
        return robj;
    }
})