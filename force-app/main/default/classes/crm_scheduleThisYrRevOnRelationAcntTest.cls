/*
Created By:Supriya Goel
Date: 9 Dec 21016
Test class for crm_schedulecoppartytpcustomer
*/

@isTest
public class crm_scheduleThisYrRevOnRelationAcntTest{

    static testMethod void test(){
    crm_TestDataFactory.CreateCustomSetting();
    System.schedulableContext SC;
    crm_scheduleRevOnRelationAcnt_Batch sch = new crm_scheduleRevOnRelationAcnt_Batch();
    sch.execute(SC);
    }
}