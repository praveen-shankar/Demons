/*
Created by :Supriya Goel
Date : 25th may 2018
Scheduler for  updating person to relation account and mark the field wasPerson = true
*/  

global class crm_scheduleUpdatePersontoRelation implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new crm_UpdatePersontoRelation_Batch('test'),100);
   }
}