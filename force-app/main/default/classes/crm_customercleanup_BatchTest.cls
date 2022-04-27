/* Created By: Supriya Goel
Date:23 jan 2019
Test class: crm_customercleanup_Batch  
*/

@isTest()
public class crm_customercleanup_BatchTest {

@testSetup static void setup() {

       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account a= crm_TestDataFactory.createPartylevelAccount();
       a.billingstate='NO';
       a.shippingstate='NO';
       a.crm_Billing_State_Province__c ='NO';
       a.crm_Shipping_State_Province__c ='NO';
       a.billingcountry='NO';
       insert  a;
       
       
      
       
       }
       static testMethod void testmethodaccountset(){
        crm_customercleanup_Batch acb = new crm_customercleanup_Batch(); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
}