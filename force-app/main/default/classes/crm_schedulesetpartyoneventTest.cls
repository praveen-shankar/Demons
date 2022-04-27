/*
Created By:Supriya Goel
Date: 9 Dec 21016
Test class for crm_schedulesetpartyonevent 
*/

@isTest
public class crm_schedulesetpartyoneventTest{

    static testMethod void test(){
    crm_TestDataFactory.CreateCustomSetting();
    System.schedulableContext SC;
    crm_schedulesetpartyonevent sch = new crm_schedulesetpartyonevent();
    sch.execute(SC);
    }
}