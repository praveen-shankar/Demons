/*
Created By:Supriya Goel
Date: 9th Jan 2018
Test class for crm_scheduleCreateAgreementBatch
*/

@isTest
public class crm_scheduleCreateAgreementBatchTest{

    static testMethod void test(){
    crm_TestDataFactory.CreateCustomSetting();
    System.schedulableContext SC;
    crm_scheduleCreateAgreementBatch sch = new crm_scheduleCreateAgreementBatch();
    sch.execute(SC);
    }
}