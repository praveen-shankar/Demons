({
    doInit : function(component, event, helper) {
       debugger;
        //alert('in doinit'+ component.get("v.rid"));
        component.set("v.recordId", component.get("v.rid"));       
        $A.util.addClass(component.find("container2"), 'slds-hide');
        helper.editOpportunity(component,event);
        helper.getServicescolumns(component, event);
        helper.loadConversionFactor(component,event);
        helper.loadDirection(component,event);
        helper.loadLocal(component,event);
        helper.loadPassivereturn(component,event);
        helper.loadPriceList(component,event);
        helper.loadPriceUnit(component,event);
        helper.loadTerminal(component,event);
        helper.loadIsPayerReceiverorSender(component,event);
        helper.getAdditionalServices(component,event);
        
    },
    
    closeQuickAction: function(component, event, helper) {
        helper.closeQuickActionHelper(component, event);
    },
    
    Next: function(component, event, helper) {
        helper.nextstep(component, event);
    },
    back: function(component, event, helper) {
        helper.backAction(component, event);
       
    },
    saveAll:  function(component, event, helper) {
        helper.saveAction(component, event);
      },
    
    handleInputError : function(cmp, event, helper) {
      	//alert('inside');
        var dEvent = cmp.getEvent("disableSave");
        
        var discount = cmp.find('crm_Discount__c');
        var discountValid = discount.get("v.validity");
                 
        if (discountValid.rangeOverflow || discountValid.rangeUnderflow || discountValid.typeMismatch || discountValid.badInput) {
            dEvent.setParam("discountissueAS", true);
        } else {
            dEvent.setParam("discountissueAS", false);
        }
        
        var minPrice= cmp.find('crm_Minimum_Price__c');
        var minPriceValid = minPrice.get("v.validity");
                   
        if (minPriceValid.rangeOverflow || minPriceValid.rangeUnderflow || minPriceValid.typeMismatch || minPriceValid.badInput) {
            dEvent.setParam("minpriceissueAS", true);
        } else {
            dEvent.setParam("minpriceissueAS", false);
        }
        
        var UnitPrice= cmp.find('UnitPrice');
        var UnitPriceValid = UnitPrice.get("v.validity");
        var UnitPriceValue= UnitPrice.get("v.value");
       
        if (UnitPriceValue == '' ) {
            dEvent.setParam("UnitPriceValidAS", true);
        } else {
            dEvent.setParam("UnitPriceValidAS", false);
        }
       var fromweight = cmp.find('minweight');
        var fromweightValid = fromweight.get("v.validity");
        //alert('fromweightValid :'+fromweightValid);
        var toweight = cmp.find('maxweight');
        var toweightValid = toweight.get("v.validity");
        //alert('toweightValid'+toweightValid);
       
        if (event.getSource().get("v.name") === 'WeightIntervalFrom') {
         		//alert('if fromweightValid :'+fromweightValid);
                if (fromweightValid.rangeOverflow || fromweightValid.rangeUnderflow || fromweightValid.typeMismatch || fromweightValid.badInput) {
                    dEvent.setParam("minpriceissueAS", true);
                    //dEvent.fire();
                    //return;
                
                } else {
                     dEvent.setParam("minweightissueAS", false);
                     //dEvent.fire();
                    //return;
                }
            }
        
        if (event.getSource().get("v.name") === 'WeightIntervalTo') {
             if (toweightValid.rangeOverflow || toweightValid.rangeUnderflow || toweightValid.typeMismatch || toweightValid.badInput) {
                    dEvent.setParam("maxweightissueAS", true);

                } else {
                    dEvent.setParam("maxweightissueAS", false);
                  
                }
            }
        
      if (event.getSource().get("v.name") === 'WeightIntervalFrom') {
        if(parseFloat(toweight.get("v.value")) < parseFloat(fromweight.get("v.value"))) {
              dEvent.setParam("minweightgreater", true);
                   
                   
                } else {
                    dEvent.setParam("minweightgreater", false);
                                     
                }
      }    
             
        dEvent.fire();
    },
    
   
    disableNextButton: function(cmp, ev, helper) {
        var params = ev.getParams();
        var nextbutton = cmp.find('nextbutton');
      
        if(params){
            if(params.minpriceissueAS || params.discountissueAS || params.minweightissueAS || params.maxweightissueAS || params.UnitPriceValidAS || params.minweightgreater){
                nextbutton.set("v.disabled",true);
            } else if(nextbutton.get("v.disabled")) {
                nextbutton.set("v.disabled",false);
            }
        }
    },
      
})