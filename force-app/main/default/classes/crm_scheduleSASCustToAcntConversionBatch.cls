/*
Created by :Supriya Goel
Date :19  july 2016 (Sprint 5)
Scheduler for Customer Process Batch
*/  

global class crm_scheduleSASCustToAcntConversionBatch  implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new  crm_SASCustomerToAccountConversionBatch(),100);
   }
}