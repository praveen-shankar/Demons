/*
Created By:Akshata Asukar
Date: 28 June 2016
Test class for crm_deleteTempData 
*/

@isTest
public class crm_deleteRevenuelinenpbDataTest
{
   @testSetup static void setup() 
   {
        crm_SalesImport_npboebs__c  saleObj=new crm_SalesImport_npboebs__c ();
        saleObj.crm_Customer_Number__c='929292';
        saleObj.crm_Source__c='BLNOCMP';
        saleObj.crm_Product__c='1202';
        saleObj.crm_Invoice_Date__c='09072016';
        saleObj.crm_Currency__c='NOK';
        saleObj.crm_Price__c='21265';
        
        insert saleObj; 
        saleObj.crm_Processed__c= true;
        update saleObj;
   }
   
   testMethod static void DeleteTempTest()
   {    
        System.Test.startTest();
        crm_deleteRevenuelinenpbData batchObj=new crm_deleteRevenuelinenpbData('test');
        DataBase.executebatch(batchObj,10);
        System.Test.StopTest();
        List<crm_SalesImport_npboebs__c> revList=[Select id,name,crm_Processed__c from crm_SalesImport_npboebs__c  where crm_Processed__c=true];
        System.AssertEquals(0,revList.Size());
       
   }
}