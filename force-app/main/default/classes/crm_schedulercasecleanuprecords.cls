/*
Created by :Supriya Goel
Date : 19th sept 2018
Schedule case clean up records */

global class crm_schedulercasecleanuprecords implements Schedulable {
    global void execute(SchedulableContext SC) {
            Database.executeBatch(new Case_CleanUpRecords());
   }
}