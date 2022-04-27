({
    Search: function(component, event, helper) {
       	var nameField = component.find("Name");
        var nameValue = nameField.get("v.value");
        
             
        if (nameValue == '' || nameValue == null)   {
           alert('Enter Search Keyword.');
        } else {
            
                    helper.SearchHelper(component, event);
        }
           
       },
       
  
    Reset: function(component, event, helper) {
        component.set("v.searchResult",component.clearReference("v.searchResult"));
        console.log("val:"+component.get("v.searchResult"));
        var nameField = component.find("Name");
        nameField.set("v.value",null);
        //helper.SearchHelper(component, event);
       
        //component.set("v.Spinner", false);
        component.set("v.resetFlag", true); 	
        			
   
},
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    
},
 
    
   /* Setflag: function(component, event) {
        component.set("v.Message", true);
    },*/
    sortByName: function(component, event, helper) {
        helper.sortByText(component, "Name");
    },
    
    sortByorga:function(component, event, helper){
      helper.sortByOrga(component, "Orga__c");  
       },
    sortBycompanyName:function(component, event, helper){
      helper.sortByOrga(component, "crm_Company_Group_Name__c");  
      },
    sortByPostcode:function(component, event, helper){
      helper.sortByOrga(component, "crm_bus_addr_Zip_Code__c");  
       },
    sortByCity:function(component, event, helper){
      helper.sortByOrga(component, "crm_bus_addr_City__c");  
      },
    sortByNoofDept:function(component, event, helper){
      helper.sortByOrga(component, "crm_Count_of_Relation_level_Accounts__c");  
       },
    sortByRevThisYr:function(component, event, helper){
      helper.sortByOrga(component, "crm_Revenue_This_Year__c");  
       },
    sortByRevLastYr:function(component, event, helper){
      helper.sortByOrga(component, "crm_Revenue_Last_Year__c");  
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
    redirectToSobject: function (component, event, helper) {
        var selectedItem = event.currentTarget;
        var IdP = selectedItem.dataset.record;
        var navEvt = $A.get("e.force:navigateToSObject");
        
        navEvt.setParams({
            "recordId":IdP,
            "slideDevName": "Detail",
            "target": "_blank"
        }); 
        
        navEvt.fire(); 
        
},
    
    keyCheck : function(component, event, helper){
        var nameField = component.find("Name");
        var nameValue = nameField.get("v.value");
    if (event.keyCode == 13)
    {
     
        event.preventDefault();
        if (nameValue == '' || nameValue == null) 
        {
           alert('Enter Search Keyword.');
        } 
        else 
        {
           helper.SearchHelper(component, event);
        }
    }    
},
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   }, 
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
    
     search : function(component, event, helper) {
        var nameField = component.find("Name");
        var nameValue = nameField.get("v.value"); 
       if (event.keyCode == 13)
    {
        
        event.preventDefault();
        if (nameValue == '' || nameValue == null) 
        {
           alert('Enter Search Keyword.');
        } 
        else 
        {
           helper.SearchHelper(component, event);
        }
    } 
         else 
        helper.search(component, event);
    }
   
})