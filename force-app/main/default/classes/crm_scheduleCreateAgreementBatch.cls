/*
Created by :Supriya 
Date :9th Jan 2018
Scheduler for create agreement batch
*/  

global class crm_scheduleCreateAgreementBatch  implements Schedulable {
    global void execute(SchedulableContext SC) {
    String status='Create Agreement Batch execution';
        Database.executeBatch(new  crm_createAgreementBatch(status),1);
   }
}