/*
Created By:Supriya Goel
Date: 23 Jan 2019
Data cleanup  C-08156 Update the mapping so eConnect sends state in BillingState and Country in BillingCountry 

*/

global class crm_customercleanup_Batch implements Database.batchable<sObject>
{    
 
     global Database.QueryLocator start(Database.BatchableContext BC){
     
     String query  ='Select id, billingstate, shippingstate, billingcountry,crm_Shipping_State_Province__c,  crm_Billing_State_Province__c from account  order by createddate asc ';
         
     return database.getquerylocator(query);
     
     
     }
     
     global void execute(Database.BatchableContext BC, List<Account> acntlist) {
         List<Account> AccountListtoupdate = new List<Account>();
         for (Account a: acntlist)      {
            if (a.billingstate == a.billingcountry && a.billingstate!=''){
            a.billingstate='';
            a.crm_Billing_State_Province__c='';
            a.crm_Shipping_State_Province__c ='';
            a.shippingstate='';
            AccountListtoupdate.add(a); 
        }
    }
    
    system.debug('##'+ AccountListtoupdate);
    if (AccountListtoupdate.size()>0) 
        update AccountListtoupdate ;
}
     
    
     
      global void finish(Database.BatchableContext BC) {}
     
  }//end of function