/*
Created by :Supriya Goel
Date : 31 jan 2019
Schedule case deletee records */

global class crm_schedulercasedeleterecords implements Schedulable {
    global void execute(SchedulableContext SC) {
            Database.executeBatch(new Case_DeleteRecords_Batch());
   }
}