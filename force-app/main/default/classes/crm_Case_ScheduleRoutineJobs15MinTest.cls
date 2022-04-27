@isTest
public class crm_Case_ScheduleRoutineJobs15MinTest{

    testMethod static void ScheduleRoutineJobs1()
    {    
        crm_TestDataFactory.CreateCustomSetting();
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Account a = KatsTestUtilities.getTestBusinessAccount();
        id prodFamRecId = [select id from recordType where developerName='Product_Family' and sobjectType='Service_Product__c'].id;//KATSutilities.getRecordType('Product_Family')
                Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware');
        insert prod;
        list<QueueDetails__c> qdList;
        qdList = new list<QueueDetails__c>();
        qdList.add(new QueueDetails__c(queue_name__c='Test' + ' ' + System.now(),ownerId =  testUser.Id ,queue_deadline__c = 360)); // bh.Id
        insert qdList;
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId,Product2Id__c = prod.id);/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        insert pf1;
        Date d = System.today().addYears(-2);
        
        Case c1 = new Case(createdDate= d,To_be_Closed__c=true, subject='', accountId=a.id, description = '', SuppliedEmail='SuppliedEmail@test.com', ownerId = testUser.Id);
        
        c1.Service_Product__c = pf1.id;
        c1.ProductId = prod.id;
        insert c1;
        Case c2 = new Case(createdDate= d,To_be_Closed__c=true, subject='TEST',recordTypeId = KATSutilities.getRecordType('deviation_case'),Origin = 'OEBS',OEBS_Order_Status__c = 'Release failed', accountId=a.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com', ownerId = testUser.Id);
        
        c2.Service_Product__c = pf1.id;
        c2.ProductId = prod.id;
        insert c2;
      
        System.Test.startTest();
        Case_ScheduleRoutineJobs15Min.startOrderReleaseScheduler_15min();
        String CRON1 = '0 0 * * * ?';
        Case_ScheduleRoutineJobs15Min.startOrderReleaseScheduler(10, CRON1);
        System.Test.StopTest();
    }
    
    testMethod static void ScheduleRoutineJobs2()
    {    
        crm_TestDataFactory.CreateCustomSetting();
        User testUser = KatsTestUtilities.getTestKundekonsulentUser();
        Account a = KatsTestUtilities.getTestBusinessAccount();
        id prodFamRecId = [select id from recordType where developerName='Product_Family' and sobjectType='Service_Product__c'].id;
                Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware');
        insert prod;
        list<QueueDetails__c> qdList;
        qdList = new list<QueueDetails__c>();
        qdList.add(new QueueDetails__c(queue_name__c='Test' + ' ' + System.now(),ownerId =  testUser.Id ,queue_deadline__c = 360)); // bh.Id
        insert qdList;
        Service_Product__c pf1 = new Service_Product__c(Name='MyTestProductFamily',recordTypeId = prodFamRecId,Product2Id__c = prod.id);/*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                insert pf1;
        Date d = System.today().addYears(-2);
        
        Case c1 = new Case(createdDate= d,To_be_Closed__c=true, subject='', accountId=a.id, description = '', SuppliedEmail='SuppliedEmail@test.com', ownerId = testUser.Id);
        
        c1.Service_Product__c = pf1.id;
        c1.ProductId = prod.id;
        insert c1;
        Case c2 = new Case(createdDate= d,status='SPAM',To_be_Closed__c=true, subject='TEST',recordTypeId = KATSutilities.getRecordType('deviation_case'),Origin = 'OEBS',OEBS_Order_Status__c = 'Release failed', accountId=a.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com', ownerId = testUser.Id,isanonymized__c = false,Closeddate = System.now());
        
        c2.Service_Product__c = pf1.id;
        c2.ProductId = prod.id;
        insert c2;
      
        Case_anonymisation_day_schedule__c c = new Case_anonymisation_day_schedule__c();
        c.Day__c = 'Friday';
        c.End_Time__c='06.00';
        c.Start_Time__c='00.00';
        c.Name = 'Friday';
        insert c;
        Case_Anonymisation_Days__c cc = new Case_Anonymisation_Days__c();
        cc.Name= 'Default';
        cc.Number_Of_Days__c = 00.00;
        insert cc;
        
        System.Test.startTest();
        Case_CleanUpRecordsScheduler.startCase_CleanUpRecordsScheduler_15min();
        String CRON1 = '0 0 * * * ?';

        Case_CleanUpRecordsScheduler.startCase_CleanUpRecordsScheduler(10, CRON1);
        System.Test.StopTest();
    }
}