/* Created By: Supriya Goel
Date: 17th oct 2016
Test class: crm_ThisYrRevenueOnPartyAccount_Batch   - test class for rev this yr
*/

@isTest()
public class crm_Customersegment_BatchTest{

@testSetup static void setup() {

       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       partyLevelacnt.crm_segment_Active_ParcelsB2C_Customer__c= true;
       partyLevelacnt.crm_segment_Active_PaDoren_Customer_c__c= true;
      
       insert  partyLevelacnt;
       
       }
       
         static testMethod void testrevenueonparty(){
        crm_Customersegment_Batch  acb = new crm_Customersegment_Batch('test'); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
}