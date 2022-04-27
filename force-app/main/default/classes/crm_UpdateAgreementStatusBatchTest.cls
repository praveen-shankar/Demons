/* Created By: Akshata Asukar
Date: 29th June  2016
Test class: crm_UpdateAgreementStatusBatchTest
*/

@isTest
public class crm_UpdateAgreementStatusBatchTest{

@testSetup static void setup() {

    crm_TestDataFactory.CreateCustomSetting(); 
    Account partyLevelacnt=crm_TestDataFactory.createPartylevelAccount();

    //create agreement
    crm_Agreement__c parentagreement= crm_TestDataFactory.createAgreement();
    parentagreement.crm_Account__c = partyLevelacnt.id;
    parentagreement.crm_Status__c ='Draft';
    insert parentagreement; 

    //create agreement
    crm_Agreement__c agreement= crm_TestDataFactory.createAgreement();
    agreement.crm_Account__c = partyLevelacnt.id;
    agreement.crm_Parent_Agreement__c =parentagreement.id;
    agreement.crm_Status__c ='Draft';
    agreement.crm_Agreement_Start_Date__c= system.today();
    agreement.crm_Agreement_End_Date__c= system.today().addDays(5);
    insert agreement;
    
    
    }

    testMethod static void UpdateAggrementTest()
    {    
      
        System.Test.startTest();
        crm_UpdateAgreementStatusBatch batchObj=new crm_UpdateAgreementStatusBatch('test');
        DataBase.executebatch(batchObj);
        System.Test.StopTest();
    }

}