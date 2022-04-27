@isTest

private class OdigoCaseService_Test{

    static testMethod void testOdigoCaseService(){
        
        Test.startTest();
        User u = [Select Id From User Where Alias = 'aadmi'];
        System.runAs(u){
            
            QueueDetails__c qd = new QueueDetails__c(queue_name__c = 'Test');
            insert qd;
            
            CDS_Service__c ser = new CDS_Service__c(Def_Rec_Type__c = 'Consulting / Information',CDS_Service_Group_Name__c = 'Booking',Odigo__c=true,QueueDetails__c=qd.Id);
            insert ser;
            
            Account a = new Account(Name = 'Test Account',RecordTypeId = getRecordTypeId('Relation level Customer'),
                                    CRMStatus__c = 'VIP', Sector__c = 'Transportation');
            insert a;
            
            Contact c = new Contact(FirstName = 'Posten', LastName = 'Bring', Email = 'wenfwnjf@aksdkjadksadj.com',
                                    AccountId = a.Id, Phone = '99999');
            insert c;
            
            Test.setFixedSearchResults(new List<Id>{c.Id});
            System.debug('Account is: '+a.CRMStatus__c);
            Pagereference pf = OdigoCaseService.OdigoCaseService('Booking','99999','test','test','12313123');
            System.assertNotEquals(pf,null);
        }
        Test.stopTest();
    }
    
    static testMethod void testOdigoCaseService2(){
        Test.startTest();
        User u = [Select Id From User Where Alias = 'aadmi'];
        System.runAs(u){
            CDS_Service__c ser = new CDS_Service__c(Def_Rec_Type__c = 'Consulting / Information',CDS_Service_Group_Name__c = 'Booking',Odigo__c=true);
            insert ser;
            
            Account a = new Account(Name = 'Test Account',RecordTypeId = getRecordTypeId('Relation level Customer'),
                                    CRMStatus__c = 'Storkunde', Sector__c = 'Transportation',Phone = '099999',crm_Updated_by_CDH__c=true);
            insert a;
            
            Contact c = new Contact(FirstName = 'Posten', LastName = 'Bring', Email = 'wenfwnjf@aksdkjadksadj.com',
                                    AccountId = a.Id);
            insert c;
            
            
            
            Test.setFixedSearchResults(new List<Id>{a.Id});
            Pagereference pf = OdigoCaseService.OdigoCaseService('Booking','099999','test','test','12313123');
            System.assertNotEquals(pf,null);
        }    
        Test.stopTest();
        
    }
    
    private static Id getRecordTypeId(String name){
        return Schema.SObjectType.Account.getRecordTypeInfosByName().get(name).getRecordTypeId();    
    }
    
}