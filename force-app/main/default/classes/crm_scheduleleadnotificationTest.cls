/*
Created By:Supriya Goel
Date: 27 june 2017
Test class for 
*/

@isTest
public class crm_scheduleleadnotificationTest{

    static testMethod void test(){
    crm_TestDataFactory.CreateCustomSetting();
    System.schedulableContext SC;
    crm_scheduleleadnotification sch = new crm_scheduleleadnotification();
    sch.execute(SC);
    }
}