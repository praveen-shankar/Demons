/*
Created By:Akshata Asukar
Date: 19 July 21016
Test class for crm_scheduleUpdateAgreementStatus
*/

@isTest
public class crm_scheduledeleteRevlineTempDataTest{


        static testMethod void test(){
      
        System.schedulableContext SC;
        crm_scheduledeleteRevenuelineTempData sln = new crm_scheduledeleteRevenuelineTempData();
        sln.execute(SC);
        
        }

}