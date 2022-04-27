/*
Created By:Supriya Goel
Date:20th Aug 2018
Test class for crm_scheduleresponsiblesellerBatch
*/

@isTest
public class crm_scheduleresponsiblesellerBatchTest{

    static testMethod void test(){
    System.schedulableContext SC;
    crm_scheduleresponsiblesellerBatch sch = new crm_scheduleresponsiblesellerBatch();
    sch.execute(SC);
    }
}