/*
Created By:Akshata Asukar
Date: 28 June 2016
Test class for crm_deleteTempData 
*/

@isTest
public class crm_deleteRevenuelineTempDataTest
{
   @testSetup static void setup() 
   {
       crm_SalesImport__c obj=crm_TestDataFactory.createSalesImport();
       obj.crm_Processed__c=true;
       insert obj;
   }
   
   testMethod static void DeleteTempTest()
   {    
        System.Test.startTest();
        crm_deleteRevenuelineTempData batchObj=new crm_deleteRevenuelineTempData();
        DataBase.executebatch(batchObj,10);
        System.Test.StopTest();
        List<crm_SalesImport__c> revList=[Select id,name,crm_Processed__c from crm_SalesImport__c where crm_Processed__c=true];
        System.AssertEquals(0,revList.Size());
       
   }
}