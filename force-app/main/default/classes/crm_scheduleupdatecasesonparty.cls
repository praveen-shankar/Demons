/*
Created by :Supriya Goel
Date : 22 aug 2019
Schedule to update cases on party */

global class crm_scheduleupdatecasesonparty implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new crm_updateCasesPartyAccountweekly_Batch());   }
}