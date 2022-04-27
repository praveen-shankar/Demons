/*
Created By:Akshata Asukar
Date: 18 October 2016
Test class for crm_scheduleUpdateAgreementStatus
*/

@isTest
public class crm_scheduleUpdateAgreementStatusTest{

    static testMethod void test(){
    
    System.schedulableContext SC;
    crm_scheduleUpdateAgreementStatusBatch   sln = new crm_scheduleUpdateAgreementStatusBatch();
    sln.execute(SC);
    }
}