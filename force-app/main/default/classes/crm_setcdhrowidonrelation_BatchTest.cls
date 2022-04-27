/* Created By: Supriya Goel
Date: 14th may 2019 
Test class: crm_setcdhrowidonrelation_Batch
*/

@isTest()
public class crm_setcdhrowidonrelation_BatchTest{

@testSetup static void setup() {

       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
      
       insert  partyLevelacnt;
       
       //create relation level account
       Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt.parentId=partyLevelacnt.id;
       relationLevelacnt.crm_CDH_RowId__c ='123';
       insert  relationLevelacnt;
       
       }
       
        static testMethod void testparty(){
        crm_setcdhrowidonrelation_Batch acb = new crm_setcdhrowidonrelation_Batch('test'); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
}