/*
Created By:Supriya Goel
Date: 29 March 21016 (Sprint 3)
Send a notification to agreement owner if the revenue(realized contract value =0) 30 days after the agreement start date

 we have created a checkbox which will be set to true if the revenue is not generated.
 this will trigger the workflow to send mail to agreement owner
 the notification end date is  a formula field which calculates when the mail should be sent

*/

global class crm_NoRevenueAgreementNotification implements Database.batchable<sObject>,Database.Stateful{
    public string callback = '';
    global crm_NoRevenueAgreementNotification (String callback){
         this.callback = callback;   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select  crm_Send_Mail_to_owner__c,crm_Notification_end_date__c,crm_Status__c,crm_Realized_Contract_Value__c from crm_Agreement__c  where crm_Status__c= \'Active\' and crm_Notification_end_date__c = TODAY and crm_Realized_Contract_Value__c in (0, null) and crm_Send_Mail_to_owner__c=false ';
        return Database.getQueryLocator(query);                    
        }

      
    global void execute(Database.BatchableContext BC, List<crm_Agreement__c> agrlist) {
        for(crm_Agreement__c  agr : agrlist){  agr.crm_Send_Mail_to_owner__c=true;  }//end of for   
        
        try{ if (agrlist.size()>0 ){    Database.update (agrlist, false); }}catch(Exception e) {crm_Exception_handler.createExceptionRecords(e);}  
        
    }
                   
    global void finish(Database.BatchableContext BC) {
    
    String str = '';
        AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
        
        if(callback != '' && callback != null)
                  str += callback + '\n';
        if(a != null && a.size() > 0){
                    str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
                }
        
        
        if(!Test.IsRunningTest())
            Database.executeBatch(new crm_MovecontactstoParty(str), 1);
        
    } 

}