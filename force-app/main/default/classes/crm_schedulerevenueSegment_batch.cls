/*
Created by :Supriya Goel
Date : 7th may 2019
schecule revenuesegmnent batch */

global class crm_schedulerevenueSegment_batch implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new crm_revenueSegmentdaily_batch(''));
   }
}