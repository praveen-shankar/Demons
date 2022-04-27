/* Created By: Supriya Goel
Date: 13th sept
Test class: crm_CountRelationAccounts_Batch 
*/

@isTest()
public class crm_CountRelationAccounts_BatchTest{

@testSetup static void setup() {

      crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
       
       //create relation level account
       Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt.parentId=partyLevelacnt.id;
       insert  relationLevelacnt;

       }

    static testMethod void testrevenueonparty(){
        Account partylevel =[Select id,name from Account where name ='parent test' limit 1 ];
             
       Account relationlevel =[Select id,name from Account where name ='test account' limit 1 ];
       relationlevel.parentid= partylevel.id ;
       update relationlevel;
       
       Account partylevel2 = crm_TestDataFactory.createPartylevelAccount();
       insert  partylevel2 ;
       
       //create relation level account
       Account relationlevel2 = crm_TestDataFactory.createRelationlevelAccount();
       relationlevel2.parentId=partylevel2.id;
       insert  relationlevel2;
       
       Account partylevel3 = crm_TestDataFactory.createPartylevelAccount();
       insert  partylevel3 ;
       
       relationlevel2.parentId=partylevel.id;
       update relationlevel2;
       
        delete relationlevel2;
        crm_CountRelationAccounts_Batch  acb = new crm_CountRelationAccounts_Batch('test'); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        System.Test.stopTest(); 
    }
}