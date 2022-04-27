({
    doInit : function(component, event, helper) {
        helper.getSegmentList(component, event);
        helper.loadmonth(component, event);
        helper.loadresponsibleseller(component, event);
       
    },
    
    setproposedmanager : function(component, event, helper) {
        
         helper.setproposedmanager(component, event);
     
    },
    
     capturefictioussegmentdata : function(cmp,event,helper) {
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
         
        var proposedresponsibleSeller = cmp.find("proposedresponsibleSeller");
        var proposedresponsibleSellervalue = proposedresponsibleSeller.get("v.value");  
         
       var proposedresponsibleSellermanager= cmp.find("proposedSellermanager");
        var proposedresponsibleSellermanagervalue = proposedresponsibleSellermanager.get("v.value");
           
        // alert ('proposedresponsibleSellermanagervalue'+proposedresponsibleSellermanagervalue);
          //alert ('responsibleSellermanagervalue'+responsibleSellermanagervalue);
       
        robj.month =monthvalue; 
      //  robj.year = yearvalue;
        robj.responsibleSeller = responsibleSellervalue; 
        robj.responsibleSellermanager =  responsibleSellermanagervalue; 
        robj.proposedresponsibleSeller= proposedresponsibleSellervalue; 
        robj.proposedresponsibleSellermanager= proposedresponsibleSellermanagervalue; 
        robj.serviceGroupvalue = serviceGroupvalue;
        robj.reasonofchange = reasonvalue; 
        robj.segId = cmp.get("v.segId");
        robj.flag=0;
      
        
        return robj;
    }
})