/* Created By: Akshata Asukar
Date: 29th June  2016
Test class: crm_revenueTransformation_batch
*/

@isTest
public class crm_revenueTransformation_CustomTest{

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
    
    Account relationLevelacnt2= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt2.parentId=partyLevelacnt.id;
    relationLevelacnt2.crm_Customer_Number__c='67890';
    relationLevelacnt2.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  relationLevelacnt2;
    
    //create admin user
    User u = crm_TestDataFactory.createUser();
    insert u;
     
    //create product
    Product2 Prod1=crm_TestDataFactory.createProduct();
    prod1.crm_ERP_Product_ID__c ='1545';
    prod1.crm_global_Service_Area__c ='Logistics';
    prod1.crm_global_Service_Group__c ='Air';
    prod1.crm_global_Service_Family__c='Air';
    prod1.New_ERP_Service_ID__c= '1545_new';
    insert Prod1;
    
    Product2 Prod2=crm_TestDataFactory.createProduct();
    prod2.crm_ERP_Product_ID__c ='C201';
    prod2.crm_global_Service_Area__c ='Logistics';
    prod2.crm_global_Service_Group__c ='Express';
    prod2.crm_global_Service_Family__c='Express';
    insert Prod2;
    
    //insert segments
    crm_segment__c segobj1= crm_TestDataFactory.createSegment();
    segobj1.crm_Account__c= relationLevelacnt1.id;
    segobj1.crm_Service_Group__c ='Cargo Domestic';
    segobj1.crm_Sales_Responsible__c =u.id;
    insert segobj1;  
    
    //insert segments
    crm_segment__c segobj2=crm_TestDataFactory.createSegment();
    segobj2.crm_Account__c= partyLevelacnt.id;
    segobj2.crm_Service_Group__c ='Express';
    segobj2.crm_Sales_Responsible__c =u.id;
    insert segobj2;  
    
    crm_segment__c segobj3= crm_TestDataFactory.createSegment();
    segobj3.crm_Account__c= relationLevelacnt1.id;
    segobj3.crm_Service_Group__c ='Post';
    segobj3.crm_Sales_Responsible__c =u.id;
    insert segobj3;  
    
    //insert rev lines in case of update scenario
    crm_Revenue_Line__c revLineObj=new crm_Revenue_Line__c();
    revLineObj.crm_Account__c = relationLevelacnt1.id;
    revLineObj.crm_Product__c = prod1.id;
    revLineObj.crm_Transaction_Date__c =Date.newInstance(2016, 7, 7) ;
    revLineObj.crm_Amount__c = 1000;
    insert revLineObj;
    
    //insert rev lines
    crm_Revenue_Line__c revLineObj1=new crm_Revenue_Line__c();
    revLineObj1.crm_Account__c = relationLevelacnt1.id;
    revLineObj1.crm_Product__c = prod1.id;
    revLineObj1.crm_Transaction_Date__c =Date.newInstance(2016, 8, 7) ;
    revLineObj1.crm_Amount__c = 1000;
    insert revLineObj1;
  
    crm_SalesImport__c saleObj1=crm_TestDataFactory.createSalesImport();
    saleObj1.crm_Customer_Number__c='12345';
    saleObj1.crm_Source__c='BLNOCMP';
    saleObj1.crm_Product__c='1545';
    saleObj1.crm_Invoice_Date__c='07072016';
    saleObj1.crm_Currency__c='NOK';
    saleObj1.crm_Price__c='1000';
    insert saleObj1;
    
    crm_SalesImport__c saleObj2=crm_TestDataFactory.createSalesImport();
    saleObj2.crm_Customer_Number__c='12345';
    saleObj2.crm_Source__c='BLNOCMP';
    saleObj2.crm_Product__c='1545';
    saleObj2.crm_Invoice_Date__c='19072015';
    saleObj2.crm_Currency__c='NOK';
    saleObj2.crm_Price__c='2000';
    insert saleObj2;
    
    crm_SalesImport__c saleObj3=crm_TestDataFactory.createSalesImport();
    saleObj3.crm_Customer_Number__c='67890';
    saleObj3.crm_Source__c='BLNOCMP';
    saleObj3.crm_Product__c='C201';
    saleObj3.crm_Invoice_Date__c='09072016';
    saleObj3.crm_Currency__c='NOK';
    saleObj3.crm_Price__c='2000';
    insert saleObj3;
    
    crm_SalesImport__c saleObj4=crm_TestDataFactory.createSalesImport();
    saleObj4.crm_Customer_Number__c='12345';
    saleObj4.crm_Source__c='BLNOCMP';
    saleObj4.crm_Product__c='1545';
    saleObj4.crm_Invoice_Date__c='09072016';
    saleObj4.crm_Currency__c='NOK';
    saleObj4.crm_Price__c='3000';
    insert saleObj4;
    
    
      
    //insert agreement
    crm_Agreement__c agreement= crm_TestDataFactory.createAgreement();
    agreement.crm_Account__c = partyLevelacnt.id;
    agreement.crm_Status__c ='Active';
    agreement.crm_Agreement_Service_Family__c= 'Air';
    agreement.crm_Agreement_Start_Date__c=system.today().addDays(-200);
    agreement.crm_Agreement_end_Date__c=system.today()+10;
    insert agreement;
    
    crm_Agreement__c agreement1= crm_TestDataFactory.createAgreement();
    agreement1.crm_Account__c = partyLevelacnt.id;
    agreement1.crm_Status__c ='Active';
    agreement1.crm_Agreement_Service_Family__c= 'Express';
    agreement1.crm_Agreement_Start_Date__c=system.today().addDays(-200);
    agreement1.crm_Agreement_end_Date__c=system.today()+10;
    insert agreement1;
    
    
}

    testMethod static void revenuTransformationTest()
    {
        List<crm_SalesImport__c> salesData = [Select Id,crm_Customer_Number__c,crm_Source__c,crm_Product__c,crm_Invoice_Date__c,crm_Currency__c,crm_Price__c from crm_SalesImport__c ];
        crm_Revenue_Batch_setting__c  revInstance = new crm_Revenue_Batch_setting__c();
        revInstance.crm_Revenue_Batch_Status__c =true;
        revInstance.Name = 'RevenueBatch';
        insert revInstance;
        System.Test.StartTest();
        crm_revenueTransformationCustom_batch batchObj=new crm_revenueTransformationCustom_batch(salesData.get(2).Id);
        Database.ExecuteBatch(batchObj);
        System.Test.StopTest();
    }
    testMethod static void revenuTransformationconvertedTest(){  
    Account partylevel =[Select id,name,Customer_Converted__c,crm_Customer_Status_Role_3__c from Account where name ='parent test' limit 1 ];
        partylevel.Customer_Converted__c='NotConverted';
        update partylevel;
        
        partylevel.Customer_Converted__c='InPreparation';
        update partylevel;
        
        partylevel.Customer_Converted__c='Converted';
        update partylevel;
    crm_SalesImport__c saleObj5=crm_TestDataFactory.createSalesImport();
    saleObj5.crm_Customer_Number__c='12345';
    saleObj5.crm_Source__c='BLNOCMP';
    saleObj5.crm_Product__c='1545';
    saleObj5.crm_Invoice_Date__c='09072016';
    saleObj5.crm_Currency__c='NOK';
    saleObj5.crm_Price__c='3000';
    insert saleObj5;
         crm_Revenue_Batch_setting__c  revInstance = new crm_Revenue_Batch_setting__c();
        revInstance.crm_Revenue_Batch_Status__c =true;
        revInstance.Name = 'RevenueBatch';
        insert revInstance;
        System.Test.StartTest();
        crm_revenueTransformationCustom_batch batchObj=new crm_revenueTransformationCustom_batch(saleObj5.Id);
        Database.ExecuteBatch(batchObj);
        System.Test.StopTest();
    }
}