/* 
Created By: Supriya Goel
Date: 22 feb  2016
Test class: Test class for the segment related list
*/

@isTest
public class crm_AccountSegmentControllerTest{

    @testSetup static void setup() {
        
        crm_TestDataFactory.CreateCustomSetting();
        //create party level account
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        insert  partyLevelacnt;

        //create relation level account
        Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt.parentId=partyLevelacnt.id;
        relationLevelacnt.CustomerTeam__c = 'Test';
        insert  relationLevelacnt;

        Product2 Prod2=crm_TestDataFactory.createProduct();
        Prod2.crm_ERP_Product_ID__c ='2945';
        Prod2.crm_global_Service_Area__c ='Post';
        Prod2.crm_global_Service_Group__c ='Post';
        Prod2.crm_global_Service_Family__c='Bilagsretur';
        insert Prod2;
        
      }
    
    static testMethod void displaytasksforAccounts(){
       System.Test.startTest();
        
        User u = crm_TestDataFactory.createUser();
        insert u;
        System.runAs(u){
            //fetch party account
            Account partyLevelacnt= [Select id, name from Account where name ='parent test' limit 1];
            System.assertequals(partyLevelacnt.Name,'parent test');
            
            //fetch relation account
            Account relationLevelacnt= [Select id, name from Account where name ='test account' limit 1];
            System.assertequals(relationLevelacnt.Name,'test account');
            
            Product2 Prod1=crm_TestDataFactory.createProduct();
            prod1.crm_ERP_Product_ID__c ='C200';
            prod1.crm_global_Service_Area__c ='Logistics';
            prod1.crm_global_Service_Group__c ='Air';
            prod1.crm_global_Service_Family__c='Air';
            insert Prod1;
            //insert segment
            
            //create segments
            crm_Segment__c segobj1= new crm_Segment__c ();
            segobj1.crm_Account__c= relationLevelacnt.id;
            segobj1.crm_Service_Group__c ='Cargo Domestic';
            segobj1.crm_Sales_Responsible__c =u.id;
            insert segobj1; 
            
            crm_Segment__c segobj2= new crm_Segment__c ();
            segobj2.crm_Account__c= relationLevelacnt.id;
            segobj2.crm_Service_Group__c ='Post';
            segobj2.crm_Sales_Responsible__c =u.id;
            insert segobj2;  
            
            crm_AccountSegmentController AAC = new crm_AccountSegmentController(new ApexPages.StandardController(relationLevelacnt));
            
            PageReference pr= Page.cs_Segment_List;
            System.Test.setCurrentPage(pr);
        }
        System.Test.stopTest();    
    }
    
}