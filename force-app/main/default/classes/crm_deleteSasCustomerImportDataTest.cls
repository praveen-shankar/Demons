/*
Created By:Akshata Asukar
Date: 28 June 2016
Test class for crm_deleteTempData 
*/

@isTest
public class crm_deleteSasCustomerImportDataTest
{
   @testSetup static void setup() 
   {
       crm_SAS_Customer_Import__c  obj=crm_TestDataFactory.createSaSCustomerImport();
       obj.crm_Processed__c=true;
       insert obj;
   }
   
   testMethod static void DeleteTempTest()
   {    
        System.Test.startTest();
        environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        
        crm_deleteSASCustomerImportData batchObj=new crm_deleteSASCustomerImportData('test');
        DataBase.executebatch(batchObj,10);
        System.Test.StopTest();
        
        List<crm_SAS_Customer_Import__c> sasList=[Select id,name,crm_Processed__c from crm_SAS_Customer_Import__c where crm_Processed__c=true];
        System.AssertEquals(0,sasList.Size());
   }
}