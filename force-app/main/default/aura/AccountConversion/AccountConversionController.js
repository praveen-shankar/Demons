({
    
    doInit : function(component, event, helper) {
        
        helper.CurrentAccount(component,event);
        helper.loadCustomerStatus(component,event);
        helper.loadCustomerGrp(component,event);
        helper.loadConversionProcessOptions(component,event);
        helper.loadConversionHeatOptions(component,event);
        helper.loadCustomerStateOptions(component,event);
        helper.loadConnectedagreementoptions(component,event);
        helper.disableprofile(component,event);
        helper.readonly(component,event);
        helper.hideComponent(component,event);
        helper.loadEdiStatusOptions(component,event); 
        helper.loadApiStatusOptions(component,event);     

        
    },
    
    dateUpdate : function(component, event, helper) {
      var startdate = component.get("v.Acc.crm_Conv_Start_Date__c");
        var enddate = component.get("v.Acc.crm_Conv_End_Date__c");
        if(enddate < startdate){
            console.log('Error');
            component.set("v.message", 'Start Date can not be later than End Date');   
            component.set("v.Error", true);
            
        }
        
    },    
    
    
    UpdateAccount:function(component, event, helper){
        console.log('update account');
        var newAccount = component.get("v.Acc");
	    var action = component.get("c.getAccountRecord");
   
        action.setParams({ 
            "Acct": newAccount
       
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state::'+state);
            if (state === "SUCCESS") {
                var resultsToast = $A.get("e.force:showToast");
                var homeEvent = $A.get("e.force:navigateToSObject");
                
                                
                        resultsToast.setParams({
                            "title": "Record Updated sucessfully",
                            "message": "Account Updated Successfully", 
                            "type":"success"
                        });
                        
                
             	homeEvent.setParams({
       				  "recordId":component.get("v.recordId"),
      				"slideDevName": "Detail"
                    
   					 });   

                        resultsToast.fire();
                        $A.get("e.force:refreshView").fire();
                         homeEvent.fire();
                
            }
       		else if (state === "ERROR"){

                var errors = action.getError();
                if(errors[0] && errors[0].message){// To show other type of exceptions
                    component.set("v.message", errors[0].message);
                	component.set("v.Error", true);
                }
                if(errors[0] && errors[0].pageErrors) {// To show DML exceptions
            		component.set("v.message", errors[0].pageErrors[0].message);   
                		component.set("v.Error", true);
			}

            }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
            
         }); 
          
         $A.enqueueAction(action);
       
        
    },
     Cancel : function(component, event, helper) {
        
        component.set("v.Acc.crm_Conv_Customer_Conversion_Group__c", null);
        component.set("v.Acc.crm_Conv_Conversion_Process__c", null);
         component.set("v.Acc.crm_Conv_Converison_Heat__c", null);
         component.set("v.Acc.crm_Conv_Order_Channel__c", null);
         component.set("v.Acc.crm_Conv_Total_Revenue__c", null);
         component.set("v.Acc.crm_conv_Customer_state__c", null);
         component.set("v.Acc.crm_Conv_Start_Date__c", null);
         component.set("v.Acc.crm_Conv_End_Date__c", null);
         component.set("v.Acc.crm_Conv_Other__c", null);
         component.set("v.Acc.crm_conv_Conversion_comment__c", null);
         component.set("v.Acc.crm_cov_ListOrg_no_in_group__c", null);
         component.set("v.Acc.crm_conv_Count_Org_No_in_group__c", null);
        // $A.enqueueAction(action); 
         
    },
    
    closeMessage: function(component, event, helper) {
        component.set("v.Error", false);
        
        $A.get("e.force:closeQuickAction").fire(); 
    },

})