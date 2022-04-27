/*
Created By:Supriya Goel
Date: 12 aug 2019
Test class for crm_scheduleresponsiblesellerBatch
*/

@isTest
public class crm_sendfailedcontToMybringSchedulerTest{

    static testMethod void test(){
    System.schedulableContext SC;
    crm_sendfailedcontactstoMybringScheduler sch = new crm_sendfailedcontactstoMybringScheduler();
    sch.execute(SC);
    }
}