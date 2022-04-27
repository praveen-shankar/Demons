/* Created By: Supriya Goel
Date:18th dec 2018
Test class: crm_revenueAgreementcustom_batch Test class 
*/

@isTest
public class crm_revenueAgreementCustom_batchTest{
 //create party level account   
 
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
    
    
       //insert rev lines in case of update scenario
    crm_Revenue_Line__c revLineObj=new crm_Revenue_Line__c();
    revLineObj.crm_Account__c = relationLevelacnt1.id;
    revLineObj.crm_Product__c = prod1.id;
    revLineObj.crm_Transaction_Date__c = system.today().addDays(-2);
    revLineObj.crm_Amount__c = 1000;
    insert revLineObj;
    
    //insert rev lines
    crm_Revenue_Line__c revLineObj1=new crm_Revenue_Line__c();
    revLineObj1.crm_Account__c = relationLevelacnt1.id;
    revLineObj1.crm_Product__c = prod2.id;
    revLineObj1.crm_Transaction_Date__c =system.today().addDays(-3);
    revLineObj1.crm_Amount__c = 1000;
    insert revLineObj1;    
    
    

    }
    
      testMethod static void revenueagreementTest()
    {
    
        environment_settings__c datesetting = new environment_settings__c();
        datesetting.Name = 'Revenue_Agreement_transaction_days';
        datesetting.Value__c = '550';
        insert datesetting;
        
        List<crm_Revenue_Line__c > listRevenueLine = [Select id , crm_Transaction_Date__c from crm_Revenue_Line__c ];
        
        System.debug('listRevenueLine------'+listRevenueLine);
        environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        System.Test.StartTest();
        crm_revenueAgreementCustom_batch batchObj=new crm_revenueAgreementCustom_batch(listRevenueLine.get(0).id);
        Database.ExecuteBatch(batchObj);
        System.Test.StopTest();
    }
}