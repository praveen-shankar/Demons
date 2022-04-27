/*
Created By:Akshata Asukar
Date: 19 July 21016
Test class for crm_scheduleUpdateAgreementStatus
*/

@isTest
public class crm_scheduleSASCustToAcntConversionTest{

    static testMethod void test(){
    
    System.schedulableContext SC;
    crm_scheduleSASCustToAcntConversionBatch sln = new crm_scheduleSASCustToAcntConversionBatch();
    sln.execute(SC);
    }
}