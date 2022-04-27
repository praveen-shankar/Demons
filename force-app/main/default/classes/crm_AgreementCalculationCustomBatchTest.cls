/* 
Created By: Supriya Goel
Date: Sprint 5
Test class: Test class for the Controller Apex Class  crm_AgreementCalculationBatch  to calaculate Agreement Contract Conversion %
*/

@isTest
public class crm_AgreementCalculationCustomBatchTest{

    @testSetup static void setup() {
        
        crm_TestDataFactory.CreateCustomSetting();
        //create party level account
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        insert  partyLevelacnt;
      
    }
    static testMethod void testcalculation(){
        
        //fetch party level account
        Account partyLevelacnt= [Select id, name from Account where name ='parent test' limit 1];
        System.assertequals(partyLevelacnt.Name,'parent test');
        
         //create agreement
        crm_Agreement__c agrobj1 = crm_TestDataFactory.createAgreement();
        agrobj1.crm_Account__c =partyLevelacnt.Id;
        agrobj1.crm_Agreement_Start_Date__c = System.today().adddays(-10);
        agrobj1.crm_Agreement_End_Date__c = System.today().adddays(20);
        agrobj1.crm_Agreement_Increased_Contract_Value__c=200;
        agrobj1.crm_Annual_Contract_Value__c =600;
        agrobj1.crm_Realized_Contract_Value__c=50;
        agrobj1.crm_Status__c='Active';
        insert agrobj1; 
        
        crm_Agreement__c agrobj2 = crm_TestDataFactory.createAgreement();
        agrobj2.crm_Account__c =partyLevelacnt.Id;
        agrobj2.crm_Agreement_Start_Date__c = System.today().adddays(-10);
        agrobj2.crm_Agreement_End_Date__c = System.today().adddays(20);
        agrobj2.crm_Agreement_Increased_Contract_Value__c=200;
        agrobj2.crm_Annual_Contract_Value__c =600;
        agrobj2.crm_Realized_Contract_Value__c=0;
        agrobj2.crm_Status__c='Active';
        insert agrobj2; 
        
        System.assertequals(agrobj1.crm_Realized_Contract_Value__c,50);        
              
        crm_AgreementCalculationCustomBatch  acb = new crm_AgreementCalculationCustomBatch (agrobj1.id);
         crm_AgreementCalculationCustomBatch  acb1 = new crm_AgreementCalculationCustomBatch(agrobj2.id);
        System.Test.startTest();
        Database.executeBatch(acb); 
         Database.executeBatch(acb1);       
        System.Test.stopTest(); 
    
    }
 
}