/* Created By: Supriya goel
Date: 24th may 2018
Test class: crm_UpdatePersontoRelation_Batch
*/

@isTest
public class crm_UpdatePersontoRelation_BatchTest{

@testSetup static void setup() {
    
    //create party level account   
    
    crm_TestDataFactory.CreateCustomSetting();
    
    Id privateRecordtypeid  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Privat').getRecordTypeId();
    Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
    partyLevelacnt.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  partyLevelacnt; 
    
    Account privateAcnt= new Account();
    privateAcnt.FirstName='Private firstname';
    privateAcnt.LastName ='Private lastname';
    privateAcnt.recordtypeid=  privateRecordtypeid;
    insert privateAcnt;    
    
    
     //create product
    Product2 Prod1=crm_TestDataFactory.createProduct();
    prod1.crm_ERP_Product_ID__c ='C200';
    prod1.crm_global_Service_Area__c ='Logistics';
    prod1.crm_global_Service_Group__c ='Air';
    prod1.crm_global_Service_Family__c='Air';
    insert Prod1;
    
    crm_Revenue_Line__c revLineObj=new crm_Revenue_Line__c();
    revLineObj.crm_Account__c = privateAcnt.id;
    revLineObj.crm_Product__c = Prod1.id;
    revLineObj.crm_Transaction_Date__c = Date.newInstance(Date.Today().Year(), Date.Today().Month(), Date.Today().day());
    revLineObj.crm_Amount__c = 1000;
    insert revLineObj;
    
    }
    
    
     testMethod static void updatePrivateAccountTest()
    {
       
        Test.StartTest();
        crm_UpdatePersontoRelation_Batch  batchObj=new crm_UpdatePersontoRelation_Batch('test');
        Database.ExecuteBatch(batchObj);
        Test.StopTest();
    }
    
 }