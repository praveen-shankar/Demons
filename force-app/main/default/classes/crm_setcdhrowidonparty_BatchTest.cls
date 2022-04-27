/* Created By: Supriya Goel
Date: 14th may 2019 
Test class: crm_setcdhrowidonparty_Batch
*/

@isTest()
public class crm_setcdhrowidonparty_BatchTest{

@testSetup static void setup() {

       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       partyLevelacnt.crm_CDH_RowId__c ='123';
       insert  partyLevelacnt;
       
       //create relation level account
       Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt.parentId=partyLevelacnt.id;
       insert  relationLevelacnt;
       
       }
       
        static testMethod void testparty(){
        crm_setcdhrowidonparty_Batch acb = new crm_setcdhrowidonparty_Batch('test'); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
}