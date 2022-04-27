/*
Created by :Akshata Asukar
Date :18 October 2016 (Sprint 5)
Scheduler for UpdateAgreementStatusBatch
*/  

global class crm_scheduleUpdateAgreementStatusBatch   implements Schedulable {
    global void execute(SchedulableContext SC) {
    String status='Batch execution started';
        Database.executeBatch(new  crm_UpdateAgreementStatusBatch(status),100);
   }
}