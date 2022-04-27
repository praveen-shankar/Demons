({
	/*
     * this function will build table data
     * based on current page selection
     * */
    buildData : function(component, helper) 
    {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        
        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
            	data.push(allData[x]);
            }
        }
        component.set("v.data", data);
   
        component.set("v.totalRecords" , allData.length);
        component.set("v.totalPages", Math.ceil(allData.length/pageSize));
        helper.generatePageList(component, pageNumber);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList : function(component, pageNumber)
    {
        pageNumber =  parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
         var allData = component.get("v.allData");
        
        var pageSize = component.get("v.pageSize");
        totalPages= Math.ceil(allData.length/pageSize);
        
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
                 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },
    
    
    loadConversionProcessPicklist : function(component, event) 
    {
        var action = component.get("c.getConversionProcessPicklist");
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) 
            {
                var conversionProcessArray = [];
                var conversionProcessResponse = response.getReturnValue();
                for (var key in conversionProcessResponse) 
                {
                    conversionProcessArray.push({
                        value: conversionProcessResponse[key],
                        key: key
                    });
                }
                component.set("v.SelectKeyWord", conversionProcessArray);
                console.log("ConversionProcessPicklist" + conversionProcessArray);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadConversionHeatPicklist: function(component, event) 
    {
        var action = component.get("c.getConversionHeatPicklist");
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) 
            {
                var conversionHeatArray = [];
                var conversionHeatResponse = response.getReturnValue();
                for (var key in conversionHeatResponse) 
                {
                    conversionHeatArray.push({
                        value: conversionHeatResponse[key],
                        key: key
                    });
                }
                component.set("v.ConversionHeatSearchKey", conversionHeatArray);
                console.log("ConversionProcessPicklist" + conversionHeatArray);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadConvertedCustomerPicklist: function(component, event) 
    {
        var action = component.get("c.getConvertedCustomerPicklist");
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) 
            {
                var convertedCustomerArray = [];
                var convertedCustomerResponse = response.getReturnValue();
                for (var key in convertedCustomerResponse) 
                {
                    convertedCustomerArray.push({
                        value: convertedCustomerResponse[key],
                        key: key
                    });
                }
                component.set("v.ConvertedSearchKey", convertedCustomerArray);
                console.log("convertedCustomerPicklist" + convertedCustomerArray);
            }
        });
        $A.enqueueAction(action);
    },
    
    //For Sort By Fields
    sortBy: function(component, field) 
    {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.data");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.data", records);
    }
})