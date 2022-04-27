({
    lightningPicklistInit: function(component, event, helper) {
        var fields = component.get("v.actualServiceFields");
        var allfields = component.get("v.picklistoptions");
        var picklist = [];
        var picklistfiltered = {};
        for (var k = 0; k < fields.length; k++) {
            if (fields[k].crm_Type__c == 'picklist')
                picklist.push(fields[k].crm_API_Name__c);
        }
        for (var key in allfields) {
            if (picklist.includes(key))
                picklistfiltered[key] = allfields[key];
            console.log('picklistfiltered'+picklistfiltered[key]);
        }
        component.set("v.picklistoptionsfiltered", picklistfiltered);
                 

    },

    captureInputDataPicklist: function(component, event, helper) {
        var params = event.getParam('arguments').capturedAsFromParent;
        params.local = component.get("v.crm_Local__c");
        params.conversionfactor = component.get("v.crm_Conversion_Factor__c");
        params.direction = component.get("v.crm_Direction__c");
        params.priceunit = component.get("v.crm_Price_Unit__c");
        params.terminals = component.get("v.crm_Terminals__c");
        params.isPayerReceiverorSender = component.get("v.IsPayerReceiverorSender__c");
        var eve = component.getEvent("lightningDataTableEventAS");
        eve.setParams({
            "capturedObjectAS": params
        });
        eve.fire();
    },

    captureInputDataPicklistAdditionalServices: function(component, event, helper) {
        var params = event.getParam('arguments').capturedAsFromParentAddServ;
        params.localAddSer = component.get("v.crm_Local__c");
        params.conversionfactorAddSer = component.get("v.crm_Conversion_Factor__c");
        params.directionAddSer = component.get("v.crm_Direction__c");
        params.priceunitAddSer = component.get("v.crm_Price_Unit__c");
        params.terminalsAddSer = component.get("v.crm_Terminals__c");
        params.isPayerReceiverorSenderAddSer = component.get("v.IsPayerReceiverorSender__c");
        return params;
    },
    
    terminalChange: function(component, event, helper) {
        var terminals = component.get("v.crm_Terminals__c");
        if(terminals && terminals.includes('ALL')) {
            event.getSource().set("v.multiple",false);
            component.set("v.crm_Terminals__c",'ALL');
        } else {
            event.getSource().set("v.multiple",true);
        }
    }
})