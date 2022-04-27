({
    init: function(component, event, helper) {
        var rowactions = [
            { label: 'QuickView', name: 'qview' }
        ];
        component.set('v.columns', [
            {
                label: 'Name',
                fieldName: 'crm_Product_Name__c',
                type: 'text',
                cellAttributes: { alignment: 'left' }
            },
            {
                label: 'Type',
                fieldName: 'crm_Opp_Prod_Type__c',
                type: 'text',
                initialWidth: 120,
                cellAttributes: { alignment: 'left' }
            },
            {
                label: 'Discount %',
                fieldName: 'crm_Discount_text__c',
                type: 'text',
                initialWidth: 120,
                cellAttributes: { alignment: 'center' }
            },
            {
             	type: 'action', typeAttributes: { rowActions: rowactions }
            }
        ]);
    },
	
    handleRowAction: function(component, event, helper) {
    	helper.handleRowActionHelper(component, event);    
    },
    
    rowAction: function(component, event) {
        var selectedRows = event.getParam('selectedRows');
        var ids = [];
        for (var i = 0; i < selectedRows.length; i++) {
            ids.push(selectedRows[i].Id);
        }
        component.set("v.idsTodelete", ids);
    },

    decideDeleteAllAction: function(component, event, helper) {
        var action = event.getSource().get("v.name");
        component.set("v.openModal", false);
        if (action === 'approveDeleteAll') {
            helper.deleteHelper(component, event);
        } else if (action === 'cancelDeleteAll') {
            component.set("v.idsTodelete", component.clearReference("v.idsTodelete"));
        }
    },

    buttonActions: function(component, event, helper) {
        var value = event.getParam("value");
        switch (value) {
            case "viewaction":
                helper.viewAction(component, event);
                break;
            case "qviewaction":
                helper.qviewAction(component, event);
                break;    
            case "addaction":
                helper.addAction(component, event);
                break;
            case "editaction":
                debugger;
                
                helper.editAction(component, event);
                break;
            case "deleteaction":
                helper.deleteAction(component, event);
                break;
            case "deleteallaction":
                helper.deleteAllAction(component, event);
                break;
            case "clone":
                helper.cloneAction(component, event, "clone");
                break;
            case "cloneedit":
                helper.cloneAction(component, event, "cloneedit");
                break;
            default:
                console.log("No_Action_Defined_Closing_Modal");
                $A.get("e.force:closeQuickAction").fire();
                break;
        }
    }
})