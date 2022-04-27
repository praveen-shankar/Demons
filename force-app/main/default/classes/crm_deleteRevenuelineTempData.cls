/*
Created By:Supriya Goel
Date: 21 june 2016 (Sprint 5)
delete records from Temp data
*/

global class crm_deleteRevenuelineTempData implements Database.batchable<sObject>,Database.Stateful{
        
    global crm_deleteRevenuelineTempData (){
       
    }
    //get all processed data 
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT crm_Processed__c FROM crm_SalesImport__c WHERE crm_Processed__c = true';
        return Database.getQueryLocator(query);                      
    }

      
    global void execute(Database.BatchableContext BC, List<crm_SalesImport__c> sales_import) {
        
        try{   
            delete sales_import;
        }catch(Exception e) { crm_Exception_handler.createExceptionRecords(e);}
        
    }
                   
    global void finish(Database.BatchableContext BC) {
       String str = '';
            AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:BC.getJobId()];
            if(a != null && a.size() > 0){
                    str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
            }
        
            if(!Test.IsRunningTest())
                Database.executeBatch(new crm_deleteRevenuelinenpbData(str));
        
        } 
    

}