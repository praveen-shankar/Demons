/* Created By: Supriya Goel
Date: 25th july  2016
Test class: segment trigger test class
*/
@isTest
public class crm_segmentTriggerHelperTest {

@testSetup static void setup() {
   
    crm_TestDataFactory.CreateCustomSetting();       
    Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
    insert  partyLevelacnt; 
     //create admin user
           
     User u = crm_TestDataFactory.createUser();
     insert u;
      
    Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt1.parentId=partyLevelacnt.id;
    insert  relationLevelacnt1;
   
     //create product
    
    Product2 Prod1=crm_TestDataFactory.createProduct();
    prod1.crm_ERP_Product_ID__c ='C200';
    prod1.crm_global_Service_Area__c ='Logistics';
    prod1.crm_global_Service_Group__c ='Air';
    prod1.crm_global_Service_Family__c='Air';
    insert Prod1;
   
    //insert segment
    
    crm_Segment__c segobj1= new crm_Segment__c ();
    segobj1.crm_Account__c= relationLevelacnt1.id;
    segobj1.crm_Service_Group__c ='Cargo Domestic';
    segobj1.crm_Sales_Responsible__c =u.id;
    insert segobj1; 
    
    crm_Segment__c segobj2= new crm_Segment__c ();
    segobj2.crm_Account__c= relationLevelacnt1.id;
    segobj2.crm_Service_Group__c ='Post';
    segobj2.crm_Sales_Responsible__c =u.id;
    insert segobj2;  
        
    //insert rev lines
    crm_Revenue_Line__c revLineObj=new crm_Revenue_Line__c();
    revLineObj.crm_Account__c = relationLevelacnt1.id;
    revLineObj.crm_Product__c = prod1.id;
    revLineObj.crm_Transaction_Date__c =system.today();
    revLineObj.crm_Amount__c = 1000;
    insert revLineObj;
   
}

    testMethod static void segmentTest()
    {
        User u= [Select id from user where email = 'admin@test.com'];
        User u1 = crm_TestDataFactory.createSalesUser();
        insert u1;
        
        list<crm_segment__c> segobj=[Select crm_Sales_Responsible__c from crm_segment__c where crm_Sales_Responsible__c =:u.id];
        segobj[0].crm_Sales_Responsible__c =u1.id;
        update segobj[0];
        
        segobj[1].crm_Sales_Responsible__c =u1.id;
        update segobj[1];
    }
}