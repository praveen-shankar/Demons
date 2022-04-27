@isTest
public class zzz_WaveAgreementMonthlyBatchTest {

    @testSetup static void setup() {
        
        crm_TestDataFactory.CreateCustomSetting();
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        insert  partyLevelacnt; 
    
        //create relation level accounts  
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
        
        Product2 Prod2=crm_TestDataFactory.createProduct();
        prod2.crm_ERP_Product_ID__c ='C201';
        prod2.crm_global_Service_Area__c ='Logistics';
        prod2.crm_global_Service_Group__c ='Express';
        prod2.crm_global_Service_Family__c='Express';
        insert Prod2;
        
         //insert agreement
        crm_Agreement__c agreement= crm_TestDataFactory.createAgreement();
        agreement.crm_Account__c = partyLevelacnt.id;
        agreement.crm_Status__c ='Active';
        agreement.crm_Agreement_Service_Family__c= 'Air';
        agreement.crm_Agreement_Start_Date__c=system.today().addDays(-5);
        agreement.crm_Agreement_end_Date__c=system.today()+10;
        insert agreement;
        
        crm_Agreement__c agreement1= crm_TestDataFactory.createAgreement();
        agreement1.crm_Account__c = partyLevelacnt.id;
        agreement1.crm_Status__c ='Active';
        agreement1.crm_Agreement_Service_Family__c= 'Express';
        agreement1.crm_Agreement_Start_Date__c=system.today().addDays(-5);
        agreement1.crm_Agreement_end_Date__c=system.today()+10;
        insert agreement1;
        
    }
    
    testMethod static void WaveAgreementMonthlyBatchTest()
    {
        System.Test.StartTest();
        WaveAgreementMonthlyBatch batchObj=new WaveAgreementMonthlyBatch();
        Database.ExecuteBatch(batchObj);
        System.Test.StopTest();
    }
}