/*
Created By:Supriya Goel
Date: 14th Feb 2018
Test class for schedule contact count
*/

@isTest
public class crm_scheduleContactCountTest{

    static testMethod void test(){
    crm_TestDataFactory.CreateCustomSetting();
    System.schedulableContext SC;
    crm_scheduleContactCount sch = new crm_scheduleContactCount();
    sch.execute(SC);
    }
}