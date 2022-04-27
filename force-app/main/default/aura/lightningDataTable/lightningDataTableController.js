({
    
   
    actionOnLoad: function(cmp, event, helper) {
         console.log('serviceFamily---onload-');
        var disabledFieldForSalesAndSmb = cmp.get("c.getCurrentUserProfile");
        var serviceFamily = cmp.get("v.servicefamily");
        console.log('serviceFamily----'+serviceFamily);
        disabledFieldForSalesAndSmb.setCallback(this, function(response) {
        var state = response.getState();
            if (state === "SUCCESS" && cmp.isValid()) {
                var currentProfileName = response.getReturnValue();
                console.log('currentProfileName---onload-----'+currentProfileName);
                //if(serviceFamily == $A.get("$Label.c.DigitollOpenStatus") && (currentProfileName == $A.get("$Label.c.DigitollOpenStatus") || currentProfileName == $A.get("$Label.c.DigitollOpenStatus"))){
                if(serviceFamily == $A.get("$Label.c.CargoDomesticNorway")  && (currentProfileName == $A.get("$Label.c.Guest_CRM_Sales_User") || currentProfileName == $A.get("$Label.c.Guest_CRM_Sales_User_SMB"))){

                    cmp.set("v.passiveReturnEnabled" , true);
                    cmp.set("v.freePickUpEnabled" , false);
                }
                else if(serviceFamily != $A.get("$Label.c.CargoDomesticNorway") && (currentProfileName == $A.get("$Label.c.Guest_CRM_Sales_User") || currentProfileName == $A.get("$Label.c.Guest_CRM_Sales_User_SMB"))){
 					cmp.set("v.passiveReturnEnabled" , false);
                    cmp.set("v.freePickUpEnabled" , true);
                }
                else{
                    cmp.set("v.passiveReturnEnabled" , false);
                    cmp.set("v.freePickUpEnabled" , false);
                }
                
                 console.log('passiveReturnEnabled---onload-----'+cmp.get("v.passiveReturnEnabled"));
                console.log('freePickUpEnabled---onload-----'+cmp.get("v.freePickUpEnabled"));
            } 
        });
                $A.enqueueAction(disabledFieldForSalesAndSmb);
        
        var pOptions = cmp.get("c.getPicklistFieldsOptions");
        helper.loadPassivereturn(cmp,event);   
       
        pOptions.setStorable();
       
        pOptions.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && cmp.isValid()) {
                cmp.set("v.picklistFieldOptions", response.getReturnValue());
                console.log('response.getReturnValue()--------'+JSON.stringify(response.getReturnValue()));
                cmp.set("v.displayPicklistComponent", true);
            } else if (state === "INCOMPLETE") {
                console.log("The server did not return a response. The server might be down or the client might be offline");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(pOptions);
    },

    captureInputData: function(cmp, event, helper) {
        var params = event.getParam('arguments');
        var totalObjAS = {};
        if (params) {
            totalObjAS.asId = params.actualServiceId;
            totalObjAS.oppId = params.oppId;
        }
        var obj = cmp.get("v.actualServiceFields");
        var cobj = [];
        for (var key in obj) {
            var iobj = obj[key];
            if (!$A.util.isEmpty(iobj.crm_Value__c)) {
                var rep;
                if (iobj.crm_API_Name__c == "crm_Minimum_PricePercent__c") {
                    rep = "minimumpricepercent";
                    totalObjAS[rep] = iobj.crm_Value__c;
                } else if (iobj.crm_API_Name__c == "crm_Minimum_Price__c") {
                    rep = "minimumprice";
                    totalObjAS[rep] = iobj.crm_Value__c;
                } else if (iobj.crm_API_Name__c == "crm_Discount__c") {
                    rep = "discount";
                    totalObjAS[rep] = iobj.crm_Value__c;
                } else if (iobj.crm_API_Name__c == "crm_Unit_Price__c") {
                    rep = "unitprice";
                    totalObjAS[rep] = iobj.crm_Value__c;
                } else if (iobj.crm_API_Name__c == "crm_Estimated_Volume__c") {
                    rep = "estimatedvolume";
                    totalObjAS[rep] = iobj.crm_Value__c;
                } else if (iobj.crm_API_Name__c == "crm_Estimated_Weight__c") {
                    rep = "estimatedweight";
                    totalObjAS[rep] = iobj.crm_Value__c;
                } else if (iobj.crm_API_Name__c == "crm_Agreed_Item_Price__c") {
                    rep = "agreedItemPrice";
                    totalObjAS[rep] = iobj.crm_Value__c;
                }
            }
        }
        let allfieldsOnCmp = cmp.find("inputfield");
        for(let cmpindex of allfieldsOnCmp) {
            let namecmp = cmpindex.get("v.name");
            if(namecmp === 'WeightIntervalFrom')
                totalObjAS.minweight = cmpindex.get("v.value");
            if(namecmp === 'WeightIntervalTo')
                totalObjAS.maxweight = cmpindex.get("v.value");
            if(namecmp === 'standardUnitPrice')
                totalObjAS.standardUnitPrice = cmpindex.get("v.value");
        }
        if(cmp.find('freepickupflag').get("v.checked")) {
            totalObjAS.freepickup = "true";
        } else {
            totalObjAS.freepickup = "false";
        }
        
        var passivereturn='';
        passivereturn=cmp.find('crm_Passive_Return__c').get("v.value");
        
        totalObjAS.passivereturn = passivereturn;
        
       /*  if(cmp.find('passivereturnflag').get("v.checked")) {
            totalObjAS.passivereturn = "true";
        } else {
            totalObjAS.passivereturn = "false";
        }*/
        cmp.set("v.capturedTotalObjectAS", totalObjAS);
        var childComponentIdCheck = cmp.find('lightningPicklistComponentId');
        if(!$A.util.isEmpty(childComponentIdCheck)){
            cmp.find('lightningPicklistComponentId').captureASdataAuraMethodPicklist(totalObjAS);
        }
        
    },

    handleInputError: function(cmp, event, helper) {
        var fields = cmp.find("inputfield");
        var dEvent = cmp.getEvent("disableSave");
        var fieldsfilter = [];
        fieldsfilter = fields.filter(function(el) {
            if (!$A.util.isEmpty(el.get("v.value")))
                return el;
        });
        fieldsfilter.forEach(function(element, index) {
            var validity = element.get("v.validity");
            if (element.get("v.name") === 'crm_Discount__c') {
                if (validity.rangeOverflow || validity.rangeUnderflow || validity.typeMismatch || validity.badInput) {
                    dEvent.setParam("discountissueAS", true);
                } else {
                    dEvent.setParam("discountissueAS", false);
                }
            }
            if (element.get("v.name") === 'crm_Minimum_Price__c') {
                if (validity.rangeOverflow || validity.rangeUnderflow || validity.typeMismatch || validity.badInput) {
                    dEvent.setParam("minpriceissueAS", true);
                } else {
                    dEvent.setParam("minpriceissueAS", false);
                }
            }
            if (element.get("v.name") === 'standardUnitPrice') {
                if (validity.rangeOverflow || validity.rangeUnderflow || validity.typeMismatch || validity.badInput) {
                    dEvent.setParam("UnitPriceValidAS", true);
                } else {
                    dEvent.setParam("UnitPriceValidAS", false);
                }
            }
            if (element.get("v.name") === 'WeightIntervalFrom') {
                if (validity.rangeOverflow || validity.rangeUnderflow || validity.typeMismatch || validity.badInput) {
                    dEvent.setParam("minweightissueAS", true);
                } else {
                    dEvent.setParam("minweightissueAS", false);
                }
            }
            if (element.get("v.name") === 'WeightIntervalTo') {
                let allweightcmp = cmp.find('inputfield');
                let fromweightfound = allweightcmp.find(function(element) {
                    return element.get("v.name") === 'WeightIntervalFrom';
                });
                if(parseFloat(element.get("v.value")) < parseFloat(fromweightfound.get("v.value"))) {
                    dEvent.setParam("minweightgreater", true);
                    //element.setCustomValidity("Please check weight intervals");
                    //element.reportValidity();
                    //fromweightfound.setCustomValidity("Please check weight intervals");
                    //fromweightfound.reportValidity();
                } else {
                    dEvent.setParam("minweightgreater", false);
                    //element.setCustomValidity("");
                    //element.reportValidity();
                    //fromweightfound.setCustomValidity("");
                    //fromweightfound.reportValidity();
                }
                if (validity.rangeOverflow || validity.rangeUnderflow || validity.typeMismatch || validity.badInput) {
                    dEvent.setParam("maxweightissueAS", true);
                } else {
                    dEvent.setParam("maxweightissueAS", false);
                }
            }
        });
        dEvent.fire();
    }
})