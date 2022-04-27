/*
Created By:Supriya Goel
Date: 27 june 2017
Test class for 
*/

@isTest
public class crm_schedulerevlastyearTest{

    static testMethod void test(){
    crm_TestDataFactory.CreateCustomSetting();
    System.schedulableContext SC;
    crm_schedulerevlastyear sch = new crm_schedulerevlastyear();
    sch.execute(SC);
    }
}