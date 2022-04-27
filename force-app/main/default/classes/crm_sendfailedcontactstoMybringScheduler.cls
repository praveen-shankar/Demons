/*
Created by :Supriya Goel
Date :12th august 2019
Schedule contact failed batch to mybring */

global class crm_sendfailedcontactstoMybringScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new crm_sendfailedcontactstoMybringBatch ());
   }
}