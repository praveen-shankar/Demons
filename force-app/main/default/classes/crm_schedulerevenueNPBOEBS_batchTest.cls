/*
Created By:Supriya goel
Date: 1 june 2017
Test class for crm_schedulerevenueNPBOEBS_batch
*/

@isTest
public class crm_schedulerevenueNPBOEBS_batchTest{

    static testMethod void test(){
    
    crm_Revenue_Batch_setting__c  revInstance = new crm_Revenue_Batch_setting__c();
        revInstance.crm_Revenue_Batch_Status__c =false;
        revInstance.Name = 'RevenueBatchNPBOEBS';
        insert revInstance;
    
    System.schedulableContext SC;
    crm_schedulerevenueNPBOEBS_batch sln = new crm_schedulerevenueNPBOEBS_batch();
    sln.execute(SC);
    }
}