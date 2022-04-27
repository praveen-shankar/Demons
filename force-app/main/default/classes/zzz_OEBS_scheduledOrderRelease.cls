@istest
private class zzz_OEBS_scheduledOrderRelease 
{
    public static String test1 = '0 15 * * * ?';

    @isTest
    static void Testschedule()
    {
    //Test.starttest();
    case c = new case();
    c.Origin = 'OEBS';
        c.recordTypeId = KATSutilities.getRecordType('deviation_case');
        c.OEBS_Order_Status__c = 'Release failed'; 
    insert c;
    
   Test.starttest();
    //string test1='0 15 * * * ?';
    
    OEBS_scheduledOrderRelease oebs = new OEBS_scheduledOrderRelease();
    string jobid = System.schedule('OEBS Release' ,test1, oebs);
    CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];
         OEBS_scheduledOrderRelease.startOrderReleaseScheduler_15min();
          system.assertnotequals(c.id,null);
          system.assertEquals(test1, ct.CronExpression);
          system.assertEquals(0, ct.TimesTriggered);
          system.assertEquals('OEBS',
        [SELECT id, Origin FROM case WHERE id = :c.id].Origin);
        LIST<case> c1=[SELECT Id FROM case where Origin
                               = 'OEBS'];
       System.assertNOTEquals(c1.size(),0);
       test.stoptest();
     
     
    
    }
}