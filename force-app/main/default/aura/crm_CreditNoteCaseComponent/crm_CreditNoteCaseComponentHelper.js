({
	hlpShowMsg : function(component,msg ,type, title) {
        console.log('currentTheme-----show msg---------'+component + '' +msg + '--'+type + '--' + title);

    	var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title+"!",
            "message": msg,
            "type" : type.toLowerCase()
        });
        toastEvent.fire();
	},
    
    hlpResponseHandler: function(component,response){
        console.log('hlpResponseHandler----------------------');
		var state = response.getState();
        console.log('responseResult-01---------------'+JSON.stringify(response.getReturnValue()));
        console.log('responseResult-02---------------'+JSON.stringify(response.getReturnValue().responseTableData));
        if (state === "SUCCESS") {
            var transactionDetails = [];
            var responseResult = response.getReturnValue().responseTableData;
            var headersLabels = response.getReturnValue().headersLabels;
            var jwtAccessToken = response.getReturnValue().accessJWTToken;
            console.log('responseResult-03---------------'+JSON.stringify(responseResult));
            
            if(!$A.util.isEmpty(responseResult)){
                
                for(var iterationNoKey in responseResult){
                    console.log('iterationNoKey====='+iterationNoKey);
                    var keyValuePairMap = [];
                     for(var keyValuePairKey in responseResult[iterationNoKey]){
                         console.log('keyValuePairKey====='+keyValuePairKey);
                    	 keyValuePairMap.push({value:responseResult[iterationNoKey][keyValuePairKey], key:keyValuePairKey
                                                 });
                	}
                    transactionDetails.push({value:keyValuePairMap, key:iterationNoKey});

                }
                console.log('transactionDetails-03---------------'+JSON.stringify(transactionDetails));
                component.set("v.responseResult", transactionDetails);
                component.set("v.headersLabels", headersLabels);
                component.set("v.jwtAccessToken", jwtAccessToken);
               this.hlpShowTableDiv(component);
            }
            else {
                component.set("v.strErrorSuccessMessage",$A.get("$Label.c.CreditNote_NoRecordError"));
                component.set("v.ErrorTitle",$A.get("$Label.c.Search_Result") + "!");
                component.set("v.isModalOpen", true);
                
                var scrollOptions = {
                    left: 0,
                    top: 0,
                    behavior: 'smooth'
                }
                window.scrollTo(scrollOptions);
            }
        } 
    },
    
    hlpRefundCallbackHandler : function(component , response){
         console.log('hlpRefundCallbackHandler-----------------');
         var mapModifyselectedRefundData = component.get("v.mapModifyselectedRefundData");
        var recordId = component.get("v.recordId");
        var server_Selection = component.get("v.Server_Selection_value");
        var strRetrunStatus = [];
        console.log('response.getReturnValue()----------=-----------'+response.getReturnValue());
        strRetrunStatus = response.getReturnValue().split('@@');
         console.log('strRetrunStatus--[0]----------------'+strRetrunStatus[0]);
         console.log('strRetrunStatus--[1]----------------'+strRetrunStatus[1]);
         if(strRetrunStatus[0].trim() == 'OK'){
             console.log('strRetrunStatus--[1]-----enter if-----------'+strRetrunStatus[1]);
             if(server_Selection == $A.get("$Label.c.DigitollAsText")){
            	var privateBasenAction = component.get("c.digitollSelectedData");
             	 privateBasenAction.setParams({"selectedRefundData" : mapModifyselectedRefundData,
                          "recordId" : recordId,
                          "CreditNoteId" : strRetrunStatus[1].trim()
                         });
                 privateBasenAction.setCallback(this, function(response) {
                 console.log('strRetrunStatus--[1]-----enter 2nd respomnse----------'+response.getReturnValue());

                 	if(response.getReturnValue() == 'OK'){
                        console.log('ok-----enter 2nd if-----------'+response.getReturnValue());
                        //helper.hlpRefundCallbackHandler(component, response);
                         component.set("v.strErrorSuccessMessage",$A.get("$Label.c.CreditNote_RefundInitiated"));
                         component.set("v.isSuccessModalOpen", true);  
                         var testErrorsuccessmsg = component.get("v.strErrorSuccessMessage")
                         
                         var scrollOptions = {
                             left: 0,
                             top: 0,
                             behavior: 'smooth'
                         }
                         window.scrollTo(scrollOptions);
                    }
                });
                $A.enqueueAction(privateBasenAction);	
            
             	}else{
                 
                  component.set("v.strErrorSuccessMessage",$A.get("$Label.c.CreditNote_RefundInitiated"));
                  component.set("v.isSuccessModalOpen", true);  
                  var testErrorsuccessmsg = component.get("v.strErrorSuccessMessage")
                  var scrollOptions = {
                             left: 0,
                             top: 0,
                             behavior: 'smooth'
                   }
                   window.scrollTo(scrollOptions);
            	}
                 
         	}
        	else{
                component.set("v.strErrorSuccessMessage",$A.get("$Label.c.CreditNote_RefundDeclinedError"));
                component.set("v.ErrorTitle",$A.get("$Label.c.CreditNote_Error") + "!");
                component.set("v.isModalOpen", true);
                
                var scrollOptions = {
                    left: 0,
                    top: 0,
                    behavior: 'smooth'
                }
                window.scrollTo(scrollOptions);
        	}
    	},
    
    hlpShowTableDiv: function(component){
        
        console.log('hlpShowTableDiv------------------------');
        var searchDiv = document.getElementsByClassName("searchDiv");
        searchDiv[0].style.display = 'none';
        var back_table_button = document.getElementsByClassName("back_table_button");
        back_table_button[0].style.display = 'block';
        var responsetableRecord = document.getElementsByClassName("responsetableRecord");
        responsetableRecord[0].style.display = 'block';
            
	},
	hlpHideTableDiv: function(component,event,helper){
     
      	var searchDiv = document.getElementsByClassName("searchDiv");
        searchDiv[0].style.display = 'block';
        var responsetableRecord = document.getElementsByClassName("responsetableRecord");
        responsetableRecord[0].style.display = 'none';
    	var back_table_button = document.getElementsByClassName("back_table_button");
        back_table_button[0].style.display = 'none';
    
	},
    hlPRedirectToParent : function (component, event, helper) {
    	var currentRecordId = component.get("v.recordId");
        var currentTheme = component.get("v.strTheme");
		console.log('hlPRedirectToParent');
        console.log('currentTheme----------'+currentTheme);
            //if(currentTheme == 'Theme3' || currentTheme =='Theme2'){

                self.close();
   				window.parent.location.href="/" +currentRecordId;
                
            /*}else if(currentTheme == 'Theme4d'){
        		var navEvt = $A.get("e.force:navigateToSObject");
                var RecordIdTest = component.get("v.recordId")
               
                    navEvt.setParams({
                        "recordId": component.get("v.recordId")
                    });
                
                    navEvt.fire();
            }   */ 
	},
    hlpopenModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
       this.hlpTimeout(component, event, helper);
   },
 
   hlpcloseModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
   hlpTimeout : function (component, event, helper) {
        console.log('Test timeout----------------------------');
    	setTimeout(function myFunction(){
			component.set("v.isModalOpen", false);
		}, 3000);
	},
    hlpResetValues : function (component, event, helper) {
    	component.set("v.strCustomerName", "");
        component.set("v.intOrderNumber", "");
        component.set("v.intShipmentNumber", "");
        component.set("v.intPhoneNumber", "");
        component.set("v.strEmail", "");
        component.set("v.strCustomerNumber", "");
        component.set("v.isResetDisabled", true);
	},
    hlpEnableButton : function (component, event, helper) {
        component.set("v.isRefundDisabled", false);
        component.set("v.btnCancelTransactionIsDisabled", false);
	}
    
})