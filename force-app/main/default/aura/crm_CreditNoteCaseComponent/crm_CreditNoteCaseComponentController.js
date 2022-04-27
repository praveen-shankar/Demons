({
    doInit : function(component, event) {
        var ArrCreditNoteServer_Selection = [];
        var spiltservers = [];
        var splitServerLabelAndName = [];
        var AttributeServer_Selection = component.get("v.Server_Selection");
        var strCreditNoteServer_Selection = $A.get("$Label.c.CreditNote_Server_Selection");
        console.log(strCreditNoteServer_Selection);
        spiltservers = strCreditNoteServer_Selection.split('$$$');
        for(var i=0;i<spiltservers.length;i++){
            var splitServerLabelAndName = spiltservers[i].split('###');
            console.log(splitServerLabelAndName);
             ArrCreditNoteServer_Selection.push({value: splitServerLabelAndName[1], label:splitServerLabelAndName[0]
                                                 });
             console.log(ArrCreditNoteServer_Selection);
        }
        component.set("v.Server_Selection" , ArrCreditNoteServer_Selection);
        
        var action = component.get("c.getUIThemeDescription");
        action.setCallback(this, function(a) {
            component.set("v.strTheme", a.getReturnValue());
            var currentTheme = component.get("v.strTheme");

            if(a.getReturnValue()=='Theme3'){
            	component.set("v.isClassicTheme" , true);
                var checkthemeval  = component.get("v.isClassicTheme");

            }else if(a.getReturnValue()=='Theme4d'){
            	component.set("v.isClassicTheme" , false);
                var checkthemeval  = component.get("v.isClassicTheme");

            }
        });
        $A.enqueueAction(action);
    },
	fnDoSubmit : function(component, event, helper) {
		var customerName = component.get("v.strCustomerName");
        var orderNumber = component.get("v.intOrderNumber");
        var shipmentNumber = component.get("v.intShipmentNumber");
        var phoneNumber = component.get("v.intPhoneNumber");
        var email = component.get("v.strEmail");
        var customerNumber = component.get("v.strEmail");
        var currentTheme = component.get("v.strTheme");
        
        component.set("v.isRefundDisabled", true);
        component.set("v.isSuccessModalOpen", false);
        component.set("v.isModalOpen", false);
        component.set("v.btnCancelTransactionIsDisabled", true);
        helper.hlpcloseModel(component, event, helper);

        if($A.util.isEmpty(customerName) && $A.util.isEmpty(orderNumber) && $A.util.isEmpty(shipmentNumber) 
           && $A.util.isEmpty(phoneNumber) && $A.util.isEmpty(email)){
            helper.hlpShowMsg(component,$A.get("$Label.c.CreditNote_ValidateBlank"),$A.get("$Label.c.CreditNote_Error"),$A.get("$Label.c.Search_Result"));
        }
        else{ 
            var server_Selection = component.get("v.Server_Selection_value");
            console.log('server_Selection-----------'+server_Selection);
            if(server_Selection == 'Digitoll'){
                console.log('server_Selection---22--------'+server_Selection);
                var digitollAction = component.get("c.getDigitollResposnseData");
                digitollAction.setParams({  "orderId" : orderNumber ,
                                    "consignmentNumber" : shipmentNumber ,
                                    "phoneNumber" : phoneNumber
                                 });
                digitollAction.setCallback(this, function(response) {
                    helper.hlpResponseHandler(component,response);
                });
                $A.enqueueAction(digitollAction);
            }
            else{
                var action = component.get("c.setAttribute");
            
                action.setParams({ "customerName" : customerName,
                                    "orderNumber" : orderNumber ,
                                    "shipmentNumber" : shipmentNumber ,
                                    "phoneNumber" : phoneNumber ,
                                    "customerEmail" : email
                                 });
               
                action.setCallback(this, function(response) {
                helper.hlpResponseHandler(component,response);
                });
                $A.enqueueAction(action);
            }
        }
	},
    fnBackToSearch : function(component, event, helper) {
         component.set("v.isSuccessModalOpen", false);
        helper.hlpcloseModel(component, event, helper);
        helper.hlpHideTableDiv(component,event,helper);
    },
    resetInputVal : function(component, event, helper) {
    //Validating all input fields together by providing the same aureid 'field' 
        component.set("v.isModalOpen", false);
        helper.hlpResetValues(component, event, helper);
    },
    
    fnRedirectToParent: function(component, event, helper) {
		helper.hlPRedirectToParent(component,event,helper);
	},
    
    fnOnKeyPressValidate: function(component, event, helper) {
        var customerName = component.get("v.strCustomerName");
        var orderNumber = component.get("v.intOrderNumber");
        var shipmentNumber = component.get("v.intShipmentNumber");
        var phoneNumber = component.get("v.intPhoneNumber");
        var email = component.get("v.strEmail");
        var customerNumber = component.get("v.strCustomerNumber");
        
        helper.hlpcloseModel(component, event, helper);
        if($A.util.isEmpty(customerName) && $A.util.isEmpty(orderNumber) && $A.util.isEmpty(shipmentNumber) 
           && $A.util.isEmpty(phoneNumber) && $A.util.isEmpty(email) && $A.util.isEmpty(customerNumber)){
            component.set("v.isResetDisabled", true);
        }
        else{
            component.set("v.isResetDisabled", false);
        }
	},
    fnRadioChanged: function(component, event, helper) {
        
		var isResetDisabled;
        var selected = event.getSource().get("v.text");
        var digitollTransactionStatus  = component.get("v.digitollTransactionStatus");
        var btnCancelTransactionIsDisabled  = component.get("v.btnCancelTransactionIsDisabled");
        
        helper.hlpcloseModel(component, event, helper);
        component.set("v.selectedRefundData", selected);
        component.set("v.isSuccessModalOpen", false);
        component.set("v.isModalOpen", false);
     	component.set("v.isRefundDisabled", false);
        component.set("v.btnCancelTransactionIsDisabled", false);
        for(var key in selected.value){
            
            if(selected.value[key].key == 'status'){
                component.set("v.digitollTransactionStatus" ,selected.value[key].value ); 
                 console.log('selected.value[key].value ==== '+selected.value[key].value );
            }
        }
    },
    
    fnSendRefundData: function(component, event, helper) {
        component.set("v.isRefundDisabled", true);
        component.set("v.isSuccessModalOpen", false);
        component.set("v.isModalOpen", false);
        var selectedRefundData = component.get("v.selectedRefundData");
        var jwtAccessToken = component.get("v.jwtAccessToken");
        var currentTheme = component.get("v.strTheme");
        var mapSelectedData = [];
        var mapModifyselectedRefundData = component.get("v.mapModifyselectedRefundData");
        var recordId = component.get("v.recordId");
        var server_Selection = component.get("v.Server_Selection_value");
        var digitollTransactionStatus = component.get("v.digitollTransactionStatus");
        helper.hlpcloseModel(component, event, helper);
        
        console.log('selectedRefundData==== '+JSON.stringify(selectedRefundData.value));
        
        for(var key in selectedRefundData.value){
             console.log('selectedRefundData.value[key].key==== '+selectedRefundData.value[key].key);
            //mapSelectedData.push(selectedRefundData.value[key].key,selectedRefundData.value[key].value);
            mapModifyselectedRefundData[selectedRefundData.value[key].key] = selectedRefundData.value[key].value;
           
        }
        component.set("v.mapModifyselectedRefundData" , mapModifyselectedRefundData);
        console.log('mapModifyselectedRefundData==== '+JSON.stringify(mapModifyselectedRefundData));
        
       
        console.log('server_Selection-----------'+server_Selection);
        if(server_Selection == $A.get("$Label.c.DigitollAsText")){
            if(digitollTransactionStatus == $A.get("$Label.c.DigitollOpenStatus")){
                component.set("v.strErrorSuccessMessage",$A.get("$Label.c.DigitollOpenToCreditedErrMsg"));
                component.set("v.ErrorTitle",$A.get("$Label.c.CreditNote_Error") + "!");
                component.set("v.isModalOpen", true);
                component.set("v.isRefundDisabled", false);
            }
            else if(digitollTransactionStatus == $A.get("$Label.c.DigitollCreditedStatus")){
                
                component.set("v.strErrorSuccessMessage",$A.get("$Label.c.DigitollCreditedToCreditedErrMsg"));
                component.set("v.ErrorTitle",$A.get("$Label.c.CreditNote_Error") + "!");
                component.set("v.isModalOpen", true);
                component.set("v.isRefundDisabled", false);
            }
            else if(digitollTransactionStatus == $A.get("$Label.c.DigitollCancelledStatus")){
                
                component.set("v.strErrorSuccessMessage",$A.get("$Label.c.DigitollCancelledToCreditedErrMsg"));
                component.set("v.ErrorTitle",$A.get("$Label.c.CreditNote_Error") + "!");
                component.set("v.isModalOpen", true);
                component.set("v.isRefundDisabled", false);
            }
            else if(digitollTransactionStatus == $A.get("$Label.c.DigitollPaidStatus")){
                var privateBasenAction = component.get("c.selectedData");
            	privateBasenAction.setParams({"selectedRefundData" : mapModifyselectedRefundData,
                          "recordId" : recordId,
                          "jwtAccessToken" : ""
                         });
        		privateBasenAction.setCallback(this, function(response) {
                
          		helper.hlpRefundCallbackHandler(component, response);
                component.set("v.isRefundDisabled", false);
                });
                $A.enqueueAction(privateBasenAction);
            }
        }
        else{
            var action = component.get("c.selectedData");
            action.setParams({"selectedRefundData" : mapModifyselectedRefundData,
                          "recordId" : recordId,
                          "jwtAccessToken" : jwtAccessToken
                         });
        	action.setCallback(this, function(response) {
                
          		helper.hlpRefundCallbackHandler(component, response);
                 component.set("v.isRefundDisabled", false);
                
        	});
        	$A.enqueueAction(action);
        }
        
    } ,

    fnCancelTransactionPrivateBasen: function(component, event, helper) {
        component.set("v.isSuccessModalOpen", false);
        component.set("v.isModalOpen", false);
        component.set("v.isRefundDisabled", true);
        component.set("v.btnCancelTransactionIsDisabled", true);

        console.log('fnCancelTransactionPrivateBasen==== ');
        var recordId = component.get("v.recordId");
        var selectedRefundData = component.get("v.selectedRefundData");
        var digitollTransactionStatus = component.get("v.digitollTransactionStatus");
        var mapModifyselectedRefundData = component.get("v.mapModifyselectedRefundData");
        helper.hlpcloseModel(component, event, helper);
        
        console.log('selectedRefundData==== '+JSON.stringify(selectedRefundData.value));
        
        for(var key in selectedRefundData.value){
             console.log('selectedRefundData.value[key].key==== '+selectedRefundData.value[key].key);
            mapModifyselectedRefundData[selectedRefundData.value[key].key] = selectedRefundData.value[key].value;
           
        }
        component.set("v.mapModifyselectedRefundData" , mapModifyselectedRefundData);
        console.log('mapModifyselectedRefundData==== '+JSON.stringify(mapModifyselectedRefundData));
        if(digitollTransactionStatus == $A.get("$Label.c.DigitollCreditedStatus")){
            
            component.set("v.strErrorSuccessMessage",$A.get("$Label.c.DigitollCreditedToCancelledErrMsg"));
            component.set("v.ErrorTitle",$A.get("$Label.c.CreditNote_Error") + "!");
            component.set("v.isModalOpen", true);
            helper.hlpEnableButton(component, event, helper);
            
            
        }
        else if(digitollTransactionStatus == $A.get("$Label.c.DigitollPaidStatus")){
            component.set("v.strErrorSuccessMessage",$A.get("$Label.c.DigitollPaidToCancelledErrMsg"));
            component.set("v.ErrorTitle",$A.get("$Label.c.CreditNote_Error") + "!");
            component.set("v.isModalOpen", true);
             helper.hlpEnableButton(component, event, helper);
        }
        else if(digitollTransactionStatus == $A.get("$Label.c.DigitollCancelledStatus")){
            component.set("v.strErrorSuccessMessage",$A.get("$Label.c.DigitollCancelledToCancelledErrMsg"));
            component.set("v.ErrorTitle",$A.get("$Label.c.CreditNote_Error") + "!");
            component.set("v.isModalOpen", true);
             helper.hlpEnableButton(component, event, helper);
            
        }else if(digitollTransactionStatus == $A.get("$Label.c.DigitollOpenStatus")){
             console.log('digitollTransactionStatus==inside== '+mapModifyselectedRefundData);
            var action = component.get("c.cancelTransactionPrivateBasen");
            action.setParams({"selectedOpenData" : mapModifyselectedRefundData,
                              "recordId" : recordId
                             });
            action.setCallback(this, function(response) {
                 //helper.hlpRefundCallbackHandler(component, response);
                 if(response.getReturnValue() == 'OK'){
                     component.set("v.strErrorSuccessMessage",$A.get("$Label.c.Digitoll_CancelTransactionSucess"));
                     component.set("v.isSuccessModalOpen", true);  
                     var testErrorsuccessmsg = component.get("v.strErrorSuccessMessage")
                     
                     var scrollOptions = {
                         left: 0,
                         top: 0,
                         behavior: 'smooth'
                     }
                     window.scrollTo(scrollOptions);
                 }   
                else{
                    component.set("v.strErrorSuccessMessage",$A.get("$Label.c.Digitoll_CancelTransactionDeclined"));
                    component.set("v.ErrorTitle",$A.get("$Label.c.CreditNote_Error") + "!");
                    component.set("v.isModalOpen", true);
                    
                    var scrollOptions = {
                        left: 0,
                        top: 0,
                        behavior: 'smooth'
                    }
                    window.scrollTo(scrollOptions);
                }
                 helper.hlpEnableButton(component, event, helper);
            });
            $A.enqueueAction(action);
         
    	}
        
      
   	}, 
	
	closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   }, 
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      component.set("v.isModalOpen", false);
   }

})