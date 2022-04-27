/* Created By: Akshata Asukar
Date: Sprint 3
Test class: Test class for crm_updateCasesWithPartyAccount_Batch 
*/


@isTest

public class crm_updateCasesWithPartyAccBatchTest{

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
      DataBase.ExecuteBatch(new crm_updateCasesWithPartyAccount_Batch(2017,1));
      System.Test.StopTest();
      }
      
      
      static testMethod void TestUpdateCaseBatch2(){
       environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
      System.Test.StartTest();
      DataBase.ExecuteBatch(new crm_updateCasesWithPartyAccount_Batch(System.today().year(),System.today().month()));
      System.Test.StopTest();
      }
}