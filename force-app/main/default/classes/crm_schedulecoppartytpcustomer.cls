/*
Created by :Supriya Goel
Date : 9 dec 2016 
Scheduler to copy party number to customer number of account
*/  

global class crm_schedulecoppartytpcustomer implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new crm_coppartytpcustomer_Batch(),100);
   }
}