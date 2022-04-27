({
	loadLineItems: function(component, event) {
         var action = component.get("c.loadLineItems");
         action.setParams({
            monetarytransId: component.get("v.recordId")
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                if($A.util.isEmpty(response.getReturnValue())){
                     component.set("v.nolines", true); 
                 }else{
                  	component.set("v.transactionlineitems",response.getReturnValue());
                 }
            }  
        });
        $A.enqueueAction(action);
  	
	},
    
    loadtransactiondetails: function(component, event) {
         var action = component.get("c.loadtransaction");
         action.setParams({
            monetarytransId: component.get("v.recordId")
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                if($A.util.isEmpty(response.getReturnValue())){
                     component.set("v.nolines", true); 
                 }else{
                     var responseval =  response.getReturnValue() ;
                      if(typeof(responseval.Service_Product__c)  == 'undefined' )
                        this.handleShowNoticeHelperclose(component,$A.get("$Label.c.cs_Article_Extension_if_error11")); 
                  	component.set("v.transaction",response.getReturnValue());
                 }
            }  
        });
        $A.enqueueAction(action);
  	
	},
    loadcasedetails: function(component, event) {
         var action = component.get("c.loadcase");
         action.setParams({
            monetarytransId: component.get("v.recordId")
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
               //alert('resp'+JSON.stringify(response.getReturnValue()));
                if($A.util.isEmpty(response.getReturnValue())){
                     this.handleShowNoticeHelperclose(component,$A.get("$Label.c.cs_Article_Extension_if_error3"));    
                     component.set("v.nocase", true); 
                 }else{
                    var responseval =  response.getReturnValue() ;
                 //alert(JSON.stringify(response.getReturnValue()));
                 
                    if(typeof(responseval.AccountId)  == 'undefined' )
                        this.handleShowNoticeHelperclose(component,$A.get("$Label.c.cs_Article_Extension_if_error1"));  
                    // if(responseval.Account.status__c!='Active' &&  responseval.Account.status__c!='Valid')
                      //    this.handleShowNoticeHelperclose(component,$A.get("$Label.c.cs_Article_Extension_if_error2"));  
                     
                  	component.set("v.transcase",response.getReturnValue());
                 }
            }  
        });
        $A.enqueueAction(action);
  	
	},
     loadarticles: function(component, event) {
         var action = component.get("c.getAllowedArticles");
        
         action.setParams({
            monetarytransId: component.get("v.recordId")
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
              
                if($A.util.isEmpty(response.getReturnValue())){
                   this.handleShowNoticeHelperclose(component,$A.get("$Label.c.cs_Article_Extension_if_error4"));   
                 }else{
                     
                var articles = [];
                var response = response.getReturnValue();
                for(var key in response){
                    articles.push({value:response[key], key:key});
                }
               
                  	component.set("v.allowedarticles",articles);
                 }
            }  
        });
        $A.enqueueAction(action);
  	
	},
    
      loadRegressType: function(component, event) {
         var action = component.get("c.getRegressType");
       
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var articles = [];
                var response = response.getReturnValue();
                for(var key in response){
                    articles.push({value:response[key], key:key});
                }
               
                  	component.set("v.RegressType",articles);
                
            }  
        });
        $A.enqueueAction(action);
  	
	},
    
     loadOperatingUnit: function(component, event) {
         var action = component.get("c.getOperatingUnit");
         action.setParams({
            monetarytransId: component.get("v.recordId")
        });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
              
                if($A.util.isEmpty(response.getReturnValue())){
                   this.handleShowNoticeHelperclose(component,$A.get("$Label.c.cs_Article_Extension_if_error4"));   
                 }else{
                     
                var articles = [];
                var response = response.getReturnValue();
                for(var key in response){
                    articles.push({value:response[key], key:key});
                }
               
                  	component.set("v.OperatingUnit",articles);
                 }
            }  
        });
        $A.enqueueAction(action);
  	
	},
    
    handleShowNoticeHelper : function(component, msg) {
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "Attention",
            "message": msg,
            closeCallback: function() {
               // $A.get("e.force:closeQuickAction").fire();
            }
        });
    },
    
    
    handleShowNoticeHelperclose : function(component, msg) {
        component.find('notifLib').showNotice({
            "variant": "error",
            "header": "Attention",
            "message": msg,
            closeCallback: function() {
                $A.get("e.force:closeQuickAction").fire();
            }
        });
    },
    
     addlinehelper : function(component, event) {
     
      var regressType='';
      var forwarder = '';
      var carNumber ='';
      var accountingUnit = '';   
     
      var invoiceNumber = '';
      var lineAmount = '';
      var foreignCurrency = '';
          var isValid = true;
            
   if(component.get("v.lineitemrecord.Type__c") == 'Regress' ){
      regressType=component.find("Regress_type__c").get("v.value");  
      forwarder=  component.find("transporter__c").get("v.value");
      carNumber =  component.find("car_number__c").get("v.value"); 
      accountingUnit= component.find("cs_Accounting_Unit__c").get("v.value");  
          
     /* regressAccount=  component.get("v.selItem.textId"); 
       if(component.get("v.selItem.textId") == null )   {   
            this.handleShowNoticeHelper(component,$A.get("$Label.c.cs_Regres_customer_missing"));
            isValid=false;  
           
             return false;
          
         }*/
       
   }
         var accountunit ='';
         if(component.get("v.lineitemrecord.Type__c") == 'Manuell Behandling' ){
             invoiceNumber = component.find("Invoice_number__c").get("v.value");  
              accountunit = component.find("cs_Accounting_Unit__c");
              accountingUnit= component.find("cs_Accounting_Unit__c").get("v.value");  
            
         }
         
         if(component.get("v.lineitemrecord.Type__c") == 'Kompensasjon'  || component.get("v.lineitemrecord.Type__c")  == 'Erstatning' || component.get("v.lineitemrecord.Type__c") =='Refusjon' ){
            accountingUnit= component.find("cs_Accounting_Unit__c").get("v.value");  
           
         }
       
        lineAmount= component.find("Line_Amount__c");
        var lineAmountvalue=lineAmount.get("v.value"); 
          lineAmountvalue = lineAmountvalue.replace(",", ".");
      
         if(accountingUnit==''){
         this.handleShowNoticeHelper(component,$A.get("$Label.c.cs_select_accounting_unit"));   
             isValid=false;
            return false;
           
         }
         
         if (lineAmountvalue=='undefined') {
            
            this.handleShowNoticeHelper(component,$A.get("$Label.c.cs_Invalid_or_blank_amount"));
            isValid=false;  
            return false;
             
         }
         
     
      var translinedetails={};
        translinedetails.transactionId=component.get("v.recordId");
        translinedetails.paymentType=component.get("v.lineitemrecord.Type__c");
        translinedetails.regressType= regressType;
        translinedetails.forwarder= forwarder;
        translinedetails.carNumber= carNumber;
        translinedetails.accountingUnit = accountingUnit;
       // translinedetails.regressAccount= regressAccount;
        translinedetails.invoiceNumber= invoiceNumber;
        translinedetails.lineAmountvalue= lineAmountvalue;
        translinedetails.foreignCurrency= foreignCurrency;   
   
     
       if(isValid){  
        var action = component.get("c.savetransactionline");  
       
        var tosend = JSON.stringify(translinedetails);
        action.setParams({
            'json': tosend
        });
       
        action.setCallback(this, function(response) {
          var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
         	var storeResponse = response.getReturnValue();
     
                if(storeResponse!= "success"){
                    this.handleShowNoticeHelper(component,storeResponse);    
           			return false;
                }
               else  if(storeResponse== "success"){
               var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": $A.get("$Label.c.cs_Successful_transaction"),
                    "message": $A.get("$Label.c.cs_View_transaction_details"), 
                    "type":"success"
                    
                });
               
                // Update the UI: close panel, show toast, refresh account page
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
                      
         }     
            }    
        });
           
          }
         
        $A.enqueueAction(action);
         
    
    },
    
    
    
	
})