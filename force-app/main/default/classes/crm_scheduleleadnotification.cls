/*
Created by :Supriya Goel
Date : 27 june 2017
Scheduler for lead unhadled leads
*/  

global class crm_scheduleleadnotification implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new crm_batchEmailNotification('test'),100);
   }
}