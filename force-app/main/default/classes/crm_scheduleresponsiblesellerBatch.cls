/*
Created by :Supriya Goel
Date : 20th Aug 2018
Schedule segment request change batch as per the Posten */

global class crm_scheduleresponsiblesellerBatch implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new crm_updateresponsibleseller_Batch(),1);
   }
}