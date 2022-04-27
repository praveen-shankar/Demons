@isTest
public with sharing class zzz_cti_CasePriority {
    
    private static Group lowPriorityQueue;
    private static Group highPriorityQueue;
    
    static {
        //QueueDetails__c qd1 = [select OwnerId, queue_deadline__c from QueueDetails__c where queue_name__c='Bedriftskunder'];
        lowPriorityQueue = KatsTestUtilities.getLowPriTestQueue(); //[select Id from Group where Id = :qd1.OwnerId];
        //QueueDetails__c qd2 = [select OwnerId, queue_deadline__c from QueueDetails__c where queue_deadline__c < :qd1.queue_deadline__c limit 1];
        highPriorityQueue = KatsTestUtilities.getHiPriTestQueue(); // [select Id from Group where Id = :qd2.OwnerId];
    }
    
    static testMethod void testIsCaseCtiDeadlineExpired() {
        //Group queue = KatsTestUtilities.getTestQueue();
        Case oldCase = createCaseOnQueue(lowPriorityQueue);
        
        oldCase.cti_deadline__c = null;
        Boolean result = cti_CasePriority.isCaseCtiDeadlineExpired(oldCase, oldCase);
        System.assertEquals(result, true);
        cti_CasePriority.resetCtiDeadlineOnCase(oldCase);
        result = cti_CasePriority.isCaseCtiDeadlineExpired(oldCase, oldCase);
        System.assertEquals(result, false);
        Case newCase = [select Id, OwnerId, cti_deadline__c from Case where Id = :oldCase.Id];
        Test.startTest();
        changeQueue(newCase, highPriorityQueue);
        cti_CasePriority.resetCtiDeadlineOnCase(newCase);

        result = cti_CasePriority.isCaseCtiDeadlineExpired(oldCase, newCase);
        System.assertEquals(result, true);
        //System.assertEquals(''+oldCase.cti_deadline__c, 'oldCase.cti_deadline__c');
        //System.assertEquals(''+newCase.cti_deadline__c, 'oldCase.cti_deadline__c');
        System.assertNotEquals(oldCase.cti_deadline__c, newCase.cti_deadline__c);
        Group queue = KatsTestUtilities.getTestQueue();

        Case caseWithoutBusinessHours = createCaseOnQueue(queue);
        Test.stopTest();        
        caseWithoutBusinessHours = [select Id, cti_deadline__c, OwnerId from Case where Id = :caseWithoutBusinessHours.Id];
        result = cti_CasePriority.isCaseCtiDeadlineExpired(caseWithoutBusinessHours, caseWithoutBusinessHours);
        System.assertEquals(result, false);
        
    }
    
    static testMethod void testCaseChangeQueueFromLowToHigh() {
        Case oldCase = createCaseOnQueue(lowPriorityQueue);
        Case newCase = [select OwnerId from Case where Id = :oldCase.Id];
        Test.startTest();
        oldCase = [select OwnerId, cti_deadline__c from Case where Id = :oldCase.Id];
        changeQueue(newCase, highPriorityQueue);
        Test.stopTest();
        newCase = [select cti_deadline__c from Case where Id = :oldCase.Id];
        //System.assertEquals(oldCase.cti_deadline__c, newCase.cti_deadline__c);
        System.assert(oldCase.cti_deadline__c > newCase.cti_deadline__c);
        //cti_CasePriority.resetCtiDeadlineOnCase(newCase);
    }
    
    static testMethod void testCaseChangeQueueFromHighToLow() {
        Case oldCase = createCaseOnQueue(highPriorityQueue);
        Case newCase = [select OwnerId from Case where Id = :oldCase.Id];
        Test.startTest();
        oldCase = [select OwnerId, cti_deadline__c from Case where Id = :oldCase.Id];
        changeQueue(newCase, lowPriorityQueue);
        Test.stopTest();
        newCase = [select cti_deadline__c from Case where Id = :oldCase.Id];
        System.assert(oldCase.cti_deadline__c < newCase.cti_deadline__c);
    }
    
    static testMethod void testResetCaseCtiDeadline() {
        Group queue = KatsTestUtilities.getTestQueue();
        Case c = createCaseOnQueue(queue);
        cti_CasePriority.resetCtiDeadlineOnCase(c);

        Datetime dateExpected = Datetime.now().addMinutes(359);
        System.assert(c.cti_deadline__c != null);
        System.assert(dateExpected <= c.cti_deadline__c);
    }
    
    static testMethod void testAddHoursToCaseCTIDeadline() {
        Group queue = KatsTestUtilities.getTestQueue();
        Case c = createCaseOnQueue(queue);
        integer minutes = 60;
        cti_CasePriority.addMinutesToCaseWithRespectToBusinessHours(c, minutes);
        Datetime dateExpected = Datetime.now().addMinutes(59);
        System.assert(c.cti_deadline__c != null);
        
        System.assert(dateExpected <= c.cti_deadline__c, 'dateExpected (' + String.valueOf(dateExpected) + ') <= cti_deadline__c ' + String.valueOf(c.cti_deadline__c));
    }
    
    static Case createCaseOnQueue(Group queue) {
        Case c = new Case(Assigned_to_CTI__c = false, Assigned_to_CTI_Agent__c = true, OwnerId = queue.Id);
        insert c;
        return c;
    }
    
    static private void changeQueue(Case c, Group g) {
        c.OwnerId = g.Id;
        update c;
    }
}