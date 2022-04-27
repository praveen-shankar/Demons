/*
Created by :Supriya goel
Date :1 june 2017
Scheduler for crm_revenueTransformationNPBOEBS_batch
*/  

global class crm_schedulerevenueNPBOEBS_batch   implements Schedulable {
    global void execute(SchedulableContext SC) {
    Database.executeBatch(new  crm_revenueTransformationNPBOEBS_batch('test'),100);
   }
}