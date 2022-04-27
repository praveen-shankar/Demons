({
    //For Pagination Start
	doInit : function(component, event, helper) 
    {  
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Conversion Process', fieldName: 'crm_Conv_Conversion_Process__c', type: 'Picklist'},
            {label: 'Start Date', fieldName: 'crm_Conv_Start_Date__c', type: 'Date'},
            {label: 'Conversion Heat', fieldName: 'crm_Conv_Converison_Heat__c', type: 'Picklist'},
            {label: 'Customer Price Ready', fieldName: 'Customer_Price_Ready__c', type: 'Checkbox'},
            {label: 'Agreement Proposition Ready', fieldName: 'Agreement_Proposition_Ready__c', type: 'Checkbox'},
            {label: 'CONVERSION READY', fieldName: 'Conversion_Ready__c', type: 'Checkbox'},
            {label: 'Customer Converted', fieldName: 'Customer_Converted__c', type: 'Picklist'}
        ]);
        
        var action = component.get("c.getAllAccounts");
        action.setStorable();
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
    
            if ((state == "SUCCESS") && (component.isValid())) 
            {
                var records = response.getReturnValue();
                console.log('records' + records);
                component.set("v.AllAccounts", records);
                console.log('Response Time: '+((new Date().getTime())-requestInitiatedTime));
                component.set("v.totalPages", Math.ceil(response.getReturnValue().length/component.get("v.pageSize")));
                component.set("v.allData", response.getReturnValue());
                component.set("v.currentPageNumber",1);
                component.set("v.totalRecords" , records.length);
                helper.buildData(component, helper);
                helper.sortBy(component, "Name");
                   
             } 
                
             else if (state === 'ERROR')
             {
                     console.log("Unknown Error");
             }
               
        });
        
        var requestInitiatedTime = new Date().getTime();
        helper.loadConversionProcessPicklist(component, event);
        helper.loadConversionHeatPicklist(component, event);
        helper.loadConvertedCustomerPicklist(component, event);
        //var priceready = component.find("checkConversionReady").get("v.value");
        component.set("v.CustomerPriceSearchKey", null);  
        component.set("v.AgreementPropositionSearchKey", null);  
        component.set("v.ConversionReadySearchKey", null);  
        $A.enqueueAction(action);
		
      
	}, 
    
    reset : function(component, event, helper)
    {
       /*var action = component.get("c.getAllAccounts");
        action.setStorable();
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
    
            if ((state == "SUCCESS") && (component.isValid())) 
            {
                var records = response.getReturnValue();
                console.log('records' + records);
                component.set("v.AllAccounts", records);
                console.log('Response Time: '+((new Date().getTime())-requestInitiatedTime));
                component.set("v.totalPages", Math.ceil(response.getReturnValue().length/component.get("v.pageSize")));
                component.set("v.allData", response.getReturnValue());
                component.set("v.currentPageNumber",1);
                component.set("v.totalRecords" , records.length);
                helper.buildData(component, helper);
                helper.sortBy(component, "Name");
                   
             } 
                
             else if (state === 'ERROR')
             {
                     console.log("Unknown Error");
             }
               
        });
        
        var requestInitiatedTime = new Date().getTime();
        $A.enqueueAction(action);
		
        helper.loadConversionProcessPicklist(component, event);
        helper.loadConversionHeatPicklist(component, event);
        helper.loadConvertedCustomerPicklist(component, event);
        
        component.find('AccountNameId').set('v.value' , '');
        component.find('AccountConversionProcessId').set('v.value' , '');
        component.find('dateSearch').set('v.value' , '');
        component.find('AccountConversionHeatId').set('v.value' , '');
        component.find('AccountConvertedCustomerId').set('v.value' , '');
        component.find('checkCustomerPrice').set('v.value' , false);
        component.find('checkAgreementProposition').set('v.value' , false);
        component.find('checkConversionReady').set('v.value' , false);*/
        
        //Fire the refresh view event to update Account detail view
    	$A.get('e.force:refreshView').fire();
          
    },
    
    onNext : function(component, event, helper) 
    {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    
    onPrev : function(component, event, helper) 
    {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) 
    {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) 
    {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) 
    {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    }, // Pagination End
    
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
    
    //For Sort By Name
    sortByName: function(component, event, helper) {
        helper.sortBy(component, "Name");
    },
    
    //For Sort By Conversion Process
    sortByConversionProcess: function(component, event, helper) {
        helper.sortBy(component, "crm_Conv_Conversion_Process__c");
    },
    
    //For Sort By Start Date
    sortByStartDate: function(component, event, helper) {
        helper.sortBy(component, "crm_Conv_Start_Date__c");
    },
    
    //For Sort By Conversion Heat
    sortByConversionHeat: function(component, event, helper) {
        helper.sortBy(component, "crm_Conv_Converison_Heat__c");
    },
    
    //For Sort By Converted Customer
    sortByConvertedCustomer: function(component, event, helper) {
        helper.sortBy(component, "Customer_Converted__c");
    },
    
    //For Sort By Customer Price Ready
    sortByCustomerPriceReady: function(component, event, helper) {
        helper.sortBy(component, "Customer_Price_Ready__c");
    },
    
    //For Sort By Agreement Proposition Ready
    sortByAgreementProposition: function(component, event, helper) {
        helper.sortBy(component, "Agreement_Proposition_Ready__c");
    },
    
    //For Sort By Conversion Ready
    sortByConversionReady: function(component, event, helper) {
        helper.sortBy(component, "Conversion_Ready__c");
    },
    
    
    
    //For Search 
    keyPressController : function(component, event, helper) 
    {
        var getInputKeyword = component.get("v.SearchKeyWord");
        var getSelectKeyWord = component.find("AccountConversionProcessId").get("v.value"); 
    	var getDateKeyword = component.find("dateSearch").get("v.value");
        var getConversionHeatKeyword = component.find("AccountConversionHeatId").get("v.value");
        var getConvertedKeyword = component.find("AccountConvertedCustomerId").get("v.value");//component.get("v.ConvertedSearchKey");
        var getCustomerPriceKeyword =  component.find("checkCustomerPrice").get("v.value");
        
        var getAgreementPropositionKeyword =  component.find("checkAgreementProposition").get("v.value");
        var getConversionReady =  component.find("checkConversionReady").get("v.value");
        
        //alert(getCustomerPriceKeyword);
        console.log("checked Boolean value: "+getCustomerPriceKeyword);
        var action = component.get("c.fetchAccount");
        
        //set Param to method 
        action.setParams({'searchKeyword' : getInputKeyword,
                         'selectKeyword' : getSelectKeyWord,
                         'dateSearchKeyword' : getDateKeyword,
                          'conversionHeatSearchKeyword' : getConversionHeatKeyword,
                          'convertedSearchKeyword' : getConvertedKeyword,
                          'customerPriceSearchKeyword' : getCustomerPriceKeyword,
                          'agreementPropositionSearchKeyword' : getAgreementPropositionKeyword, 
                          'conversionReadySearchKeyword' : getConversionReady
                         });
        
        //set a callback
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            console.log('state '+state);
             if (state === "SUCCESS") 
             {
                var storeResponse = response.getReturnValue();
                
                 //set searchResult list with return value from server
                 component.set("v.data", storeResponse);
                 component.set("v.allData", response.getReturnValue());
                 component.set("v.currentPageNumber", 1);
                 helper.buildData(component, helper);
                 
             }
        });
        
        // enqueue the Action  
        $A.enqueueAction(action);
    }
})