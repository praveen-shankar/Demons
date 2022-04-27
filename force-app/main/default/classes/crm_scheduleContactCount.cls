/*
Created by :Supriya Goel
Date : 14th Feb 2018
Schedule Contact count batch to run weekly */

global class crm_scheduleContactCount implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new crm_ContactCount_Batch('test'));
   }
}