/* Created By: Supriya
Test class: crm_revenueSegment_batch
*/

@isTest
public class crm_revenueSegmentdaily_batchTest{

@testSetup static void setup() {
    
    //create party level account   
    
    crm_TestDataFactory.CreateCustomSetting();
    Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
    partyLevelacnt.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  partyLevelacnt; 
    
    //create relation level accounts  
    Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt1.parentId=partyLevelacnt.id;
    relationLevelacnt1.crm_Customer_Number__c='12345';
    relationLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  relationLevelacnt1;
    
     //create admin user
    User u = crm_TestDataFactory.createUser();
    u.firstname='Test';
    u.lastname='Test';
    insert u;
     
    //create product
    Product2 Prod1=crm_TestDataFactory.createProduct();
    prod1.crm_ERP_Product_ID__c ='C200';
    prod1.crm_global_Service_Area__c ='Logistics';
    prod1.crm_global_Service_Group__c ='Air';
    prod1.crm_global_Service_Family__c='Air';
    insert Prod1;
    
     Product2 Prod4=crm_TestDataFactory.createProduct();
    prod4.crm_ERP_Product_ID__c ='C204';
    prod4.crm_global_Service_Area__c ='Logistics';
    prod4.crm_global_Service_Group__c ='Warehousing';
    prod4.crm_global_Service_Family__c='lager';
    insert Prod4;
    
    
    
    //insert segments
    crm_segment__c segobj1= crm_TestDataFactory.createSegment();
    segobj1.crm_Account__c= relationLevelacnt1.id;
    segobj1.crm_Service_Group__c ='Air';
    segobj1.crm_Sales_Responsible__c =u.id;
    insert segobj1;  
    
    crm_segment__c segobj4= crm_TestDataFactory.createSegment();
    segobj4.crm_Account__c= partyLevelacnt.id;
    segobj4.crm_Service_Group__c ='Warehousing';
    segobj4.crm_Sales_Responsible__c =u.id;
    insert segobj4; 
   
     //insert rev lines in case of update scenario
    crm_Revenue_Line__c revLineObj=new crm_Revenue_Line__c();
    revLineObj.crm_Account__c = relationLevelacnt1.id;
    revLineObj.crm_Product__c = prod1.id;
    revLineObj.crm_Transaction_Date__c = Date.newInstance(Date.Today().Year(), Date.Today().Month(), Date.Today().day());
    revLineObj.crm_Amount__c = 1000;
    insert revLineObj;
    
   
   
    
    crm_Revenue_Line__c revLineObj4=new crm_Revenue_Line__c();
    revLineObj4.crm_Account__c = relationLevelacnt1.id;
    revLineObj4.crm_Product__c = prod4.id;
    revLineObj4.crm_Transaction_Date__c =Date.newInstance(Date.Today().Year(), Date.Today().Month(), Date.Today().day());
     insert revLineObj4;
    

    
    }
    
    testMethod static void revenuTransformationTest()
    {
        System.Test.StartTest();
        crm_revenueSegmentdaily_batch batchObj=new crm_revenueSegmentdaily_batch('test');
        Database.ExecuteBatch(batchObj);
        System.Test.StopTest();
    }
    
    }