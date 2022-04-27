@isTest
public class crm_updateCasesWithProduct_BatchTest{

    testMethod static void updateCasesWithProduct1()
    {    
        crm_TestDataFactory.CreateCustomSetting();
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Account a = KatsTestUtilities.getTestBusinessAccount();
        id prodFamRecId = [select id from recordType where developerName='Product_Family' and sobjectType='Service_Product__c'].id;
        Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware');
        insert prod;
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId,Product2Id__c = prod.id);/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert pf1;
        Date d = System.today().addYears(-2);
        
        Case c1 = new Case(createdDate= d, subject='TEST', accountId=a.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com', ownerId = testUser.Id);
        
        c1.Service_Product__c = pf1.id;
        c1.ProductId = prod.id;
        insert c1;
      
        System.Test.startTest();
        crm_updateCasesWithServiceProduct_Batch batchObj=new crm_updateCasesWithServiceProduct_Batch(true,true,2014);
        DataBase.executebatch(batchObj);
        System.Test.StopTest();
    }

    testMethod static void updateCasesWithProduct2()
    {    
        crm_TestDataFactory.CreateCustomSetting();
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Account a = KatsTestUtilities.getTestBusinessAccount();
        //id prodFamRecId = KATSutilities.getRecordType('Product_Family');
        id prodFamRecId = [select id from recordType where developerName='Product_Family' and sobjectType='Service_Product__c'].id;
                Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware');
        insert prod;
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId,Product2Id__c = prod.id);/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert pf1;
        Date d = System.today().addYears(-4);
        
        Case c1 = new Case(createdDate= d, subject='TEST', accountId=a.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com', ownerId = testUser.Id);
        
        c1.Service_Product__c = pf1.id;
        c1.ProductId = prod.id;
        insert c1;
      
        System.Test.startTest();
        crm_updateCasesWithServiceProduct_Batch batchObj=new crm_updateCasesWithServiceProduct_Batch(true,true,2012);
        DataBase.executebatch(batchObj);
        System.Test.StopTest();
    }

}