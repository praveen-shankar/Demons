/* Created By: Supriya Goel
Date:19th oct 2018
Test class: crm_setaccountonagreement_Batch  
*/

@isTest()
public class crm_setaccountonagreement_BatchTest {

@testSetup static void setup() {

       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
       
       //create relation level account
       Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt.parentId=partyLevelacnt.id;
       relationLevelacnt.crm_customer_number__c  ='123456789';
       insert  relationLevelacnt;
       
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partyLevelacnt.id;
       relationLevelacnt1.crm_customer_number__c  ='1234567890';
       insert  relationLevelacnt1;
       
       cs_agreement_details__c obj1= new cs_agreement_details__c();
       obj1.AccountNumberText__c ='123456789';
       obj1.Account_updated__c=false;
       insert obj1;
       
       cs_agreement_details__c obj2= new cs_agreement_details__c();
       obj2.AccountNumberText__c ='1234567899';
       obj2.Account_updated__c=false;
       insert obj2;
       
       }
       static testMethod void testmethodaccountset(){
        crm_setaccountonagreement_Batch acb = new crm_setaccountonagreement_Batch (); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
}