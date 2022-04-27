/* Created By: Supriya
Date: 14th feb 2018
Test class: Test class for the crm_CreatePartyForRelationWithRevenue
*/

@isTest
public class crm_CreatePartyForRelationWithRevTest {

 @testSetup static void setup() {
    crm_TestDataFactory.CreateCustomSetting();
    
      //create relation level accounts  
        Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt1.crm_Customer_Number__c='123456blnoc';
        relationLevelacnt1.orga__c='1234567';        
        relationLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        insert  relationLevelacnt1;
        
        Account relationLevelacnt2= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt2.orga__c='44555';
        relationLevelacnt2.crm_Customer_Number__c='123456';
        relationLevelacnt2.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        insert  relationLevelacnt2;
        
        Account relationLevelacnt3= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt3.orga__c='5566';
        relationLevelacnt3.crm_Customer_Number__c='1234567blnoc';
        relationLevelacnt3.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        relationLevelacnt3.crm_Revenue_This_Year__c=900;
        insert  relationLevelacnt3;
        
             //create product
    Product2 Prod1=crm_TestDataFactory.createProduct();
    prod1.crm_ERP_Product_ID__c ='C200';
    prod1.crm_global_Service_Area__c ='Logistics';
    prod1.crm_global_Service_Group__c ='Air';
    prod1.crm_global_Service_Family__c='Air';
    insert Prod1;
    
    Product2 Prod2=crm_TestDataFactory.createProduct();
    prod2.crm_ERP_Product_ID__c ='C201';
    prod2.crm_global_Service_Area__c ='Logistics';
    prod2.crm_global_Service_Group__c ='Express';
    prod2.crm_global_Service_Family__c='Express';
    insert Prod2;
        
          //insert rev lines in case of update scenario
    crm_Revenue_Line__c revLineObj=new crm_Revenue_Line__c();
    revLineObj.crm_Account__c = relationLevelacnt1.id;
    revLineObj.crm_Product__c = prod1.id;
    revLineObj.crm_Transaction_Date__c = system.today().addDays(-2);
    revLineObj.crm_Amount__c = 1000;
    insert revLineObj;
    
    //insert rev lines
    crm_Revenue_Line__c revLineObj1=new crm_Revenue_Line__c();
    revLineObj1.crm_Account__c = relationLevelacnt2.id;
    revLineObj1.crm_Product__c = prod2.id;
    revLineObj1.crm_Transaction_Date__c =system.today().addDays(-2);
    revLineObj1.crm_Amount__c = 1000;
    insert revLineObj1;  
    
    crm_Revenue_Line__c revLineObj2=new crm_Revenue_Line__c();
    revLineObj2.crm_Account__c = relationLevelacnt3.id;
    revLineObj2.crm_Product__c = prod2.id;
    revLineObj2.crm_Transaction_Date__c =system.today().addDays(-2);
    revLineObj2.crm_Amount__c = 1000;
    insert revLineObj2;    
        
        }
        
         testMethod static void methodTest(){
            System.Test.StartTest();
            crm_CreatePartyForRelationWithRevenue  batchObj=new crm_CreatePartyForRelationWithRevenue('test');
            Database.ExecuteBatch(batchObj);
            System.Test.StopTest();
         
         
         }
    


}