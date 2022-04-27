/*
Created by :Supriya Goel
Date :19  july 2016 (Sprint 5)
Scheduler to Delete Temporary revenue data
*/  

global class crm_scheduledeleteRevenuelineTempData implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new crm_deleteRevenuelineTempData(),2000);
   }
}