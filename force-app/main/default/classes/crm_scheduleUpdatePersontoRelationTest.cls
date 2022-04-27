/*
Created By:Supriya Goel
Date: 25th may 2018
Test class for crm_scheduleUpdatePersontoRelation
*/

@isTest
public class crm_scheduleUpdatePersontoRelationTest{

    static testMethod void test(){
    crm_TestDataFactory.CreateCustomSetting();
    System.schedulableContext SC;
    crm_scheduleUpdatePersontoRelation sch = new crm_scheduleUpdatePersontoRelation();
    sch.execute(SC);
    }
}