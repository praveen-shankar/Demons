/* Created By: Supriya Goel
Date:14th may 2019
Test class: crm_setvaluesonpartyforconversion_Batch
*/

@isTest()
public class crm_setvaluesonpartyforconversion_Test{

@testSetup static void setup() {

       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
       
       }
       
        static testMethod void testparty(){
        
        environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        crm_setvaluesonpartyforconversion_Batch acb = new crm_setvaluesonpartyforconversion_Batch('test'); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
}