/* Created By: Supriya Goel
Date: 9th nov 2018
Test class: Test class for crm_MovecontactstoPartyTest 
*/

@isTest
public class crm_MovecontactstoPartyTest {

 @testSetup static void setup() {
 
    //create party level account
       crm_TestDataFactory.CreateCustomSetting();
         //BusinessStreet, BusinessCity, BillingState, BusinessPostalCode,  BusinessCountry,
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       partyLevelacnt.crm_Count_of_Relation_level_Accounts__c=1;
       insert  partyLevelacnt;
     
      Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partyLevelacnt.id;
       relationlevelacnt1.crm_Primary_Customer_Account__c=true;
       insert  relationLevelacnt1;
     
     partyLevelacnt.crm_Count_of_Relation_level_Accounts__c =1;
     update partyLevelacnt;
       
       Contact con=new Contact();
       con.lastname='testmaping';
       con.email='Testmapping@cap.com';
       con.AccountId=relationlevelacnt1.id;
       con.crm_contact_type__c ='Sales';
       insert con;
     
             
 }
 
    static TestMethod void testMovecontactstoParty()
    {
        System.Test.StartTest();
        Database.executeBatch(new crm_MovecontactstoParty ('test'));
        System.Test.StopTest();
    }
    
    }