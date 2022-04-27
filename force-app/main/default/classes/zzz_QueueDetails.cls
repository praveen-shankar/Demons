@isTest
private class zzz_QueueDetails {

    static testMethod void coverageTest() {
        
        QueueDetails__c qd = new QueueDetails__c();
        qd.queue_name__c = 'name';
        insert qd;
        
        qd.queue_name__c = 'name new';
		update qd;
    }
}