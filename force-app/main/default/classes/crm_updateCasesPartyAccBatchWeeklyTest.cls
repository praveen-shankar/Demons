/* Created By: Supriya goel 
Date: 22 august 2019
Test class: Test class for crm_updateCasesWithPartyAccount_Batch 
*/


@isTest

public class crm_updateCasesPartyAccBatchWeeklyTest{

    @testSetup static void setup() {
     crm_TestDataFactory.CreateCustomSetting();   
        //create party level account for agreemwet active
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        insert  partyLevelacnt;
        
        Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt.parentId=partyLevelacnt.id;
        insert  relationLevelacnt;
        
        Case caseObj=new Case();
        caseObj.AccountId=relationLevelacnt.id;
        caseObj.Subject='Test Case';
        insert caseObj;
    }
    
      static testMethod void TestUpdateCaseBatch(){
      
       environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
      System.Test.StartTest();
      DataBase.ExecuteBatch(new crm_updateCasesPartyAccountweekly_Batch());
      System.Test.StopTest();
      }
      
      
   
}