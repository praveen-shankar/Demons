({
    doInit : function(component) {
        var action = component.get("c.getAllAccounts");
        action.setCallback(this, function(response){
            var state = response.getState();
             console.log('aaa'+state);
            if ((state == "SUCCESS") && (component.isValid())) {
                  console.log('component'+component);
                var records = response.getReturnValue();
                console.log('records'+records);
                component.set("v.AccountsPagination",records);
                  component.set("v.totalRecords",records.length);
               
                // 20 item will display on single screen 
                component.set("v.maxPage", Math.floor((records.length+99)/100));
                // By default it will sort by created date 
                  var pageNumber = 1;
                var pageRecords = records.slice((pageNumber-1)*100, pageNumber*100);
                component.set("v.AllAccounts", pageRecords);
                
            }
            
            else if(state === 'ERROR')
                console.log("Unknown Error");
        });
        $A.enqueueAction(action);
    },
    
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
   
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    
}
    
})