/*
Created by :Supriya Goel
Date : 31 may 2017
Scheduler to set party account on events
*/  

global class crm_schedulesetpartyonevent implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new crm_setpartyacccountonevent_batch('test'),100);
   }
}