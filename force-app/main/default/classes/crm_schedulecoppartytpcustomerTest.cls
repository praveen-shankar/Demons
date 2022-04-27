/*
Created By:Supriyaa Goel
Date: 9 Dec 21016
Test class for crm_schedulecoppartytpcustomer
*/

@isTest
public class crm_schedulecoppartytpcustomerTest{

    static testMethod void test(){
    crm_TestDataFactory.CreateCustomSetting();
    System.schedulableContext SC;
    crm_schedulecoppartytpcustomer sch = new crm_schedulecoppartytpcustomer();
    sch.execute(SC);
    }
}