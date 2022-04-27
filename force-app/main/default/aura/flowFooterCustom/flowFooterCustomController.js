({
    handleChange : function(component, event, helper) {
        // When an option is selected, navigate to the next screen
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        console.log('navigate'+navigate)
        if(response=='saveId'){
            navigate("NEXT");
        }
    }
})