/* 
Created By: Dinesh Kumar
Date: 1st april  2016
Test class: Test class for the Controller class for vf page for all open activities
*/

@isTest
public class crm_AccountActivitiesControllerTest{

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
    
    static testMethod void displaytasksforAccounts(){
        System.Test.startTest();
        //fetch party account
        Account partyLevelacnt= [Select id, name from Account where name ='parent test' limit 1];
        System.assertequals(partyLevelacnt.Name,'parent test');

        //fetch relation account
        Account relationLevelacnt= [Select id, name from Account where name ='test account' limit 1];
        System.assertequals(relationLevelacnt.Name,'test account');

        //create task for accounts
        task t = crm_TestDataFactory.createtask();
        t.whatid=relationLevelacnt.id;
        insert t;

        task t1 = crm_TestDataFactory.createtask();
        t1.whatid=partyLevelacnt.id;
        insert t1;

        crm_AccountActivitiesController AAC = new crm_AccountActivitiesController (new ApexPages.StandardController(partyLevelacnt));

        PageReference pr= Page.crm_account_activities_page;
        System.Test.setCurrentPage(pr);
        System.Test.stopTest();    
        }
      
    }