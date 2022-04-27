/* Created By: Supriya Goel
Date: 17th oct 2016
Test class: crm_ThisYrRevenueOnPartyAccount_Batch   - test class for rev this yr
*/

@isTest()
public class crm_ThisYrRevenueOnPartyAccnt_BatchTest{

@testSetup static void setup() {

       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
       
       //create relation level account
       Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt.parentId=partyLevelacnt.id;
       insert  relationLevelacnt;
       
       //create product
        Product2 prdobj = crm_TestDataFactory.createProduct();
        prdobj.crm_ERP_Product_ID__c ='123' ;
        prdobj.crm_global_Service_Area__c='Logistics';
        prdobj.crm_global_Service_Group__c ='Linehaul';
        prdobj.crm_global_Service_Family__c ='Linehaul';
        prdobj.IsActive = true;
        insert prdobj;
       
       //create revenue line
        crm_Revenue_Line__c revLineObj1=crm_TestDataFactory.createRevenueLine();
        revLineObj1.crm_Account__c = relationLevelacnt.id;
        revLineObj1.crm_Product__c= prdobj.id;
        revLineObj1.crm_Amount__c = 500;
        revLineObj1.crm_Transaction_Date__c = System.today();
        insert revLineObj1;
    
      //create revenue line
      
        crm_Revenue_Line__c revLineObj2=crm_TestDataFactory.createRevenueLine();
        revLineObj2.crm_Account__c = relationLevelacnt.id;
        revLineObj2.crm_Product__c= prdobj.id;
        revLineObj2.crm_Amount__c = 500;
        revLineObj2.crm_Transaction_Date__c = System.today();
        insert revLineObj2;

       }

    static testMethod void testrevenueonparty(){
        crm_ThisYrRevenueOnPartyAccount_Batch  acb = new crm_ThisYrRevenueOnPartyAccount_Batch('test'); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
}