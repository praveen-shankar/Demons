({
	setSelectedProductNameHelper : function(cmp,event) {
        var selectedProduct = cmp.get("v.product2options");
        var selectedProductName;
        for (var i = 0; i < selectedProduct.length; i++) {
            if (selectedProduct[i].Id == cmp.get("v.selectedActualServiceId")) {
                selectedProductName = selectedProduct[i].Name;
                break;
            }
        }
        cmp.set("v.selectedActualServiceName", selectedProductName);		
	}
})