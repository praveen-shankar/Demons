({
	doInit: function(component, event, helper) {
       
        var recordId = component.get("v.recordId");
        console.log('recordId------'+recordId);
        if(!$A.util.isEmpty(recordId)){
        	component.set("v.sectionVisible", true);	
        }
		
        var action = component.get("c.getPiklistValues");
        action.setParams({"oppId" : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var picklistData ;
                var oppStageName;
                var listUnselectedRelationCustomers = [];
                for ( var key in result ) {
                    picklistData = result[key];
                    oppStageName = key;
                    
                    console.log('oppStageName----'+oppStageName);
                }
                
                 console.log('picklistData----'+picklistData);
                
                for (var i = 0; i < picklistData.length; i++) {
                    listUnselectedRelationCustomers.push({
                        label: picklistData[i],
                        value: picklistData[i]
                    });
                }
                component.set("v.listUnselectedRelationCustomers", listUnselectedRelationCustomers);
                if(oppStageName == 'Closed Won'){
                    component.set("v.isClosedWon", true);
                }else{
                    component.set("v.isClosedWon", false);
                }
                
            }
        });
        var getCustomerNumberForOpp = component.get("c.getCustomerNumberForOpportunity");
        getCustomerNumberForOpp.setParams({"oppId" : recordId });
        getCustomerNumberForOpp.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result get selected'+result);
                
                //var listselectedRelationCustomers = [];
                
                component.set("v.listSelectedRelationCustomers", response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
         $A.enqueueAction(getCustomerNumberForOpp);
    },
    
    handleGenreChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
         
        //Update the Selected Values  
        component.set("v.listSelectedRelationCustomers", selectedValues);
        console.log('Selectd Genre-' + selectedValues);
    },
    
    getRelationCustomers: function (component, event, helper) {
        
        //var multiSelectDiv = component.find("multiSelectDiv");
        //var customerTextBox = document.getElementsByClassName("customerTextBox");
        //customerTextBox[0].style.display = 'none';
        var multiSelectDiv = document.getElementsByClassName("multiSelectDiv");
        multiSelectDiv[0].style.display = 'block';
       
    },

    fnGetSelectedCustomers: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        var selectedValues = component.get("v.listSelectedRelationCustomers");
        var spinner = component.find("opportunityUpdateSpinner");
        
        console.log('Selectd Genre-' + selectedValues);
        //component.set("v.isClosedWon", true);
        component.set("v.spinner", true);	

       /*var customerTextBox = document.getElementsByClassName("customerTextBox");
       // customerTextBox[0].style.display = 'block';
        var multiSelectDiv = document.getElementsByClassName("multiSelectDiv");
        multiSelectDiv[0].style.display = 'none';*/
        var getselected = component.get("c.getSelectedCustomers");
        getselected.setParams({"oppId" : recordId, "listselectedCustomers" : selectedValues});
        getselected.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
             helper.showToast({
                        "title": $A.get("$Label.c.Multi_Select_Success"),
                        "type": "success",
                        "message": $A.get("$Label.c.Success_RelationCustomersAddedToOpp")
                    });
                 
            }else{
                helper.showToast({
                        "title": $A.get("$Label.c.Multi_Select_Error"),
                        "type": "error",
                        "message": $A.get("$Label.c.Error_RelationCustomersAddedToOpp")
                    });
                
            }
            //component.set("v.isClosedWon", false);
             component.set("v.spinner", false);	
            
        });
        
        $A.enqueueAction(getselected);
        
        
    },
    fnCancel: function (component, event, helper) {
    	//var customerTextBox = document.getElementsByClassName("customerTextBox");
        //customerTextBox[0].style.display = 'block';
        /*var multiSelectDiv = document.getElementsByClassName("multiSelectDiv");
        multiSelectDiv[0].style.display = 'none';*/
	}
})