({

    sortByText: function(component, field) {
        var sortAsc = component.get("v.sortAsc");
        var sortField = component.get("v.sortField");
        var records = component.get("v.AccountsPagination");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a, b) {
            var t1 = a[field].toUpperCase() == b[field].toUpperCase(),
                t2 = (!a[field].toUpperCase() && b[field].toUpperCase()) || (a[field].toUpperCase() < b[field].toUpperCase());
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.AccountsPagination", records);
        this.renderPage(component);
    },

    sortByOrga: function(component, field) {
        var sortAsc = component.get("v.sortAsc");
        var sortField = component.get("v.sortField");
        var records = component.get("v.AccountsPagination");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a, b) {
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.AccountsPagination", records);
        this.renderPage(component);
    },
    
    renderPage: function(component) {
        var records = component.get("v.AccountsPagination");
        var pageNumber = component.get("v.pageNumber");
        var pageRecords = records.slice((pageNumber - 1) * 100, pageNumber * 100);
        component.set("v.AllAccounts", pageRecords);
    }
})