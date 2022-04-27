/* Created By: Supriya Goel
Date: 28th nov 2016
Test class: Test class for my crm_createcontactcontroller
*/

@isTest
public class crm_MapContactsToPrimaryRelationTest{

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
       con.AccountId=partyLevelacnt.id;
       con.crm_contact_type__c ='Sales';
       insert con;
     
       Contact con1=new Contact();
       con1.lastname='testmaping';
       con1.email='Testmapping@cap.com';
       con1.AccountId=partyLevelacnt.id;
       con1.crm_contact_type__c='Sales/Customer Service';
       insert con1;
     
      Contact con2=new Contact();
       con2.lastname='testmaping';
       con2.email='Testmapping@cap.com';
       con2.AccountId=partyLevelacnt.id;
       con2.crm_contact_type__c='Customer Service';
       insert con2;
       
     
       
 }
 
    static TestMethod void testMapContactTorelation()
    {
        System.Test.StartTest();
        Database.executeBatch(new crm_MapContactsToPrimaryRelation());
        System.Test.StopTest();
    }
    
    }