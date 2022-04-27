/* Created By: Supriya Goel
Date: 27th nov 2018
Test class:crm_setaccountoncase_Batch   
*/

@isTest()
public class crm_setaccountoncase_BatchTest{

    static testMethod void testpartyoncase(){
        
       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
       
       //create relation level account
       Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt.parentId=partyLevelacnt.id;
       insert  relationLevelacnt;
         Case testCase1 = new Case(
          Produkt__c = 'testProduct',
            Type__c = 'testType',
            Subject = 'testCase1',
            status = 'New',
            AccountId = relationLevelacnt.id
        );
        
         insert testCase1;
        
        System.debug('test class' + testCase1);
        crm_setaccountoncase_Batch acb = new crm_setaccountoncase_Batch(); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
    
    }