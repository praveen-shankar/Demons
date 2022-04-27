/* Created By: Supriya goel
Date: 21 july 2016
Test class: Test class for crm_AgreementRevenueValueBatch
*/

@isTest
public class crm_AgreementRevenueValueBatchTest{
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
               
        //create agreement
        crm_Agreement__c agrobj1 = crm_TestDataFactory.createAgreement();
        agrobj1.crm_Account__c =partyLevelacnt.Id;
        agrobj1.crm_Agreement_Increased_Contract_Value__c=200;
        agrobj1.crm_Annual_Contract_Value__c =600;
        agrobj1.crm_Agreement_Start_Date__c = System.today();
        agrobj1.crm_Agreement_End_Date__c = System.today().adddays(90);
        agrobj1.crm_Status__c ='Active';
        insert agrobj1;  
         
        //create agreement
        crm_Agreement__c agrobj2 = crm_TestDataFactory.createAgreement();
        agrobj2.crm_Account__c =partyLevelacnt.Id;
        agrobj2.crm_Agreement_Increased_Contract_Value__c=200;
        agrobj2.crm_Annual_Contract_Value__c =600;
        agrobj2.crm_Agreement_Start_Date__c = System.today().adddays(-700);
        agrobj2.crm_Agreement_End_Date__c = System.today().adddays(2);
        agrobj2.crm_Status__c ='Active';
        insert agrobj2;  
        
        //create agreement
      /*  crm_Agreement__c agrobj3 = crm_TestDataFactory.createAgreement();
        agrobj3.crm_Account__c =partyLevelacnt.Id;
        agrobj3.crm_Agreement_Increased_Contract_Value__c=200;
        agrobj3.crm_Annual_Contract_Value__c =600;
        agrobj3.crm_Agreement_Start_Date__c = System.today().addDays(-60);
        agrobj3.crm_Agreement_End_Date__c = System.today().addDays(120);
        agrobj3.crm_Status__c ='Active';
        insert agrobj3;*/
            
        //create revenue line          
        crm_Revenue_Line__c revLineObj1=crm_TestDataFactory.createRevenueLine();
        revLineObj1.crm_Account__c = relationLevelacnt.id;
        revLineObj1.crm_Product__c= prdobj.id;
        revLineObj1.crm_Amount__c = 500;
        revLineObj1.crm_Agreement__c = agrobj1.id; 
        revLineObj1.crm_Revenue_Type__c= 'New';
        revLineObj1.crm_Transaction_Date__c = System.today().adddays(3);
        insert revLineObj1;
       
       //create revenue line
      
        crm_Revenue_Line__c revLineObj2=crm_TestDataFactory.createRevenueLine();
        revLineObj2.crm_Account__c = relationLevelacnt.id;
        revLineObj2.crm_Product__c= prdobj.id;
        revLineObj2.crm_Amount__c = 500;
        revLineObj2.crm_Agreement__c = agrobj2.id; 
        revLineObj2.crm_Revenue_Type__c= 'New';
        revLineObj2.crm_Transaction_Date__c = System.today().addDays(-700);
        insert revLineObj2;
        
        crm_Revenue_Line__c revLineObj3=crm_TestDataFactory.createRevenueLine();
        revLineObj3.crm_Account__c = relationLevelacnt.id;
        revLineObj3.crm_Product__c= prdobj.id;
        revLineObj3.crm_Amount__c = 600;
        revLineObj3.crm_Agreement__c = agrobj1.id; 
        revLineObj2.crm_Revenue_Type__c= 'Existing';
        revLineObj3.crm_Transaction_Date__c = System.today().adddays(-110);
        insert revLineObj3;
        
        
        crm_Revenue_Line__c revLineObj4=crm_TestDataFactory.createRevenueLine();
        revLineObj4.crm_Account__c = relationLevelacnt.id;
        revLineObj4.crm_Product__c= prdobj.id;
        revLineObj4.crm_Amount__c = 500;
        revLineObj4.crm_Agreement__c = agrobj2.id; 
        revLineObj4.crm_Revenue_Type__c= 'Existing';
        revLineObj4.crm_Transaction_Date__c = System.today().addDays(-100);
        insert revLineObj4;
        
         crm_Revenue_Line__c revLineObj5=crm_TestDataFactory.createRevenueLine();
        revLineObj5.crm_Account__c = relationLevelacnt.id;
        revLineObj5.crm_Product__c= prdobj.id;
        revLineObj5.crm_Amount__c = 500;
        revLineObj5.crm_Agreement__c = agrobj2.id; 
        revLineObj5.crm_Revenue_Type__c= 'Existing';
        revLineObj5.crm_Transaction_Date__c = System.today().addDays(-100);
        insert revLineObj5;
        
         crm_Revenue_Line__c revLineObj6=crm_TestDataFactory.createRevenueLine();
        revLineObj6.crm_Account__c = relationLevelacnt.id;
        revLineObj6.crm_Product__c= prdobj.id;
        revLineObj6.crm_Amount__c = 500;
        revLineObj6.crm_Agreement__c = agrobj2.id; 
        revLineObj6.crm_Revenue_Type__c= 'New';
        revLineObj6.crm_Transaction_Date__c =  Date.newInstance(2018, 3, 16);
        insert revLineObj6;
        
         crm_Revenue_Line__c revLineObj7=crm_TestDataFactory.createRevenueLine();
        revLineObj7.crm_Account__c = relationLevelacnt.id;
        revLineObj7.crm_Product__c= prdobj.id;
        revLineObj7.crm_Amount__c = 700;
        revLineObj7.crm_Agreement__c = agrobj2.id; 
        revLineObj7.crm_Revenue_Type__c= 'New';
        revLineObj7.crm_Transaction_Date__c =  Date.newInstance(2018, 3, 16);
        insert revLineObj7;
        
        //for year 2019
        //
         //create revenue line          
      /*  crm_Revenue_Line__c revLineObj8=crm_TestDataFactory.createRevenueLine();
        revLineObj8.crm_Account__c = relationLevelacnt.id;
        revLineObj8.crm_Product__c= prdobj.id;
        revLineObj8.crm_Amount__c = 500;
        revLineObj8.crm_Agreement__c = agrobj3.id; 
        revLineObj8.crm_Revenue_Type__c= 'New';
        revLineObj8.crm_Transaction_Date__c = System.today().addDays(-60);
        insert revLineObj8;*/
        
       }

    static TestMethod void testRevenueValue()
    {
        
        crm_AgreementRevenueValueBatch  acb = new crm_AgreementRevenueValueBatch('test'); 
        System.Test.startTest();
        Database.executeBatch(acb); 
        System.Test.stopTest(); 
    }    
    
}