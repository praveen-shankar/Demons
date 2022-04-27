/*
Created by :Supriya 
Date :10 nov 2016 (Sprint 5)
Scheduler for revenue on relation for both this and last yr
*/  

global class crm_scheduleRevOnRelationAcnt_Batch  implements Schedulable {
    global void execute(SchedulableContext SC) {
    String status='Batch execution started for relation account ';
        Database.executeBatch(new  crm_ThisYrRevenueOnRelationAccount_Batch(status),100);
   }
}