({
	afterRender: function (component, helper) {
    this.superAfterRender();
    window.setTimeout(
        $A.getCallback(function () {
            $A.get("e.force:closeQuickAction").fire();
        }), 500
    );
}
})