/*
Created by :Supriya Goel
Date : 27 june 2017
Scheduler revenue last year on Party and relation
*/  

global class crm_schedulerevlastyear implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new crm_CalculateRevenueOnPartyAccount_Batch('test'),100);
   }
}