/*
Created By:Supriya Goel
Date:20th Aug 2018
Test class for crm_schedulerevenueSegment_batch
*/

@isTest
public class crm_schedulerevenueSegment_batchTest{

    static testMethod void test(){
    System.schedulableContext SC;
    crm_schedulerevenueSegment_batch sch = new crm_schedulerevenueSegment_batch();
    sch.execute(SC);
    }
}