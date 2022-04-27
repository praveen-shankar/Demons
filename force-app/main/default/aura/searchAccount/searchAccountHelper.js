({
    SearchHelper: function(component, event) {
        var action = component.get("c.fetchAccount");
        var input=component.get("v.Name");
       // alert(input.trim());
        action.setParams({
            'Name': input.trim()
           
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is 0 ,display no record found message on screen.
                if (storeResponse.length === 0){
                   component.set("v.resetFlag", false);
                }
                else{
                   component.set("v.resetFlag", true);
                }
                
                 component.set("v.searchResultAll", storeResponse);
               
                // 20 item will display on single screen 
                component.set("v.maxPage", Math.floor((storeResponse.length+9)/10));
                // By default it will sort by created date 
                  var pageNumber = 1;
                var pageRecords = storeResponse.slice((pageNumber-1)*10, pageNumber*10);
               component.set("v.searchResult", pageRecords);
                
               
            }
 
        });
        $A.enqueueAction(action);
 
    },
    
      
    sortByText : function(component, field) {
        var sortAsc = component.get("v.sortAsc");
        var sortField = component.get("v.sortField");
        var records = component.get("v.searchResult");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field].toUpperCase() == b[field].toUpperCase(),
                t2 = (!a[field].toUpperCase() && b[field].toUpperCase()) || (a[field].toUpperCase() < b[field].toUpperCase());
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.searchResult", records);
        },
    
     sortByOrga : function(component, field) {
        var sortAsc = component.get("v.sortAsc");
        var sortField = component.get("v.sortField");
        var records = component.get("v.searchResult");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.searchResult", records);
       
    },
    
     renderPage: function(component) {
        var records = component.get("v.searchResultAll");
        var pageNumber = component.get("v.pageNumber");
        var pageRecords = records.slice((pageNumber-1)*10, pageNumber*10);
        component.set("v.searchResult", pageRecords);
    },
    
    search : function(cmp,event) {
        var searchkey = cmp.find("Name").get("v.value");
        var originallist = cmp.get("v.searchResult"); 
        var filteredlist = [];
        for(var key in originallist) {
            var item = originallist[key];
            if(item.Name.toLowerCase().includes(searchkey.toLowerCase())){
                filteredlist.push(item);
            }           
        }
        if(!$A.util.isEmpty(filteredlist))
        	cmp.set("v.searchResult",filteredlist);
        else
            cmp.set("v.searchResult",cmp.get("v.searchResult"));
    }
     
})