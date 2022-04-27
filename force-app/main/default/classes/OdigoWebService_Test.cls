@isTest

private class OdigoWebService_Test{
    
    static testMethod void segmentTestBusinessAccount(){
        Test.startTest();
        User u = [Select Id From User Where Alias = 'aadmi'];
        System.runAs(u){
            Account a = new Account(Name = 'Test Account',Phone = '12345678',RecordTypeId = getRecordTypeId('Relation level Customer'),
                                    CRMStatus__c = 'VIP', Sector__c = 'Transportation');
            insert a;
            
            String type = OdigoWebService.getSegmentByCallerId(a.Phone);
            System.assertEquals(type,'VIP_Transportation');
        }
        Test.stopTest();
    }
    
    static testMethod void segmentTestBusinessContact(){
        Test.startTest();
        User u = [Select Id From User Where Alias = 'aadmi'];
        System.runAs(u){
            Account a = new Account(Name = 'Test Account',RecordTypeId = getRecordTypeId('Relation level Customer'),
                                    CRMStatus__c = 'VIP', Sector__c = 'Transportation');
            insert a;
            
            Contact c = new Contact(FirstName = 'Posten', LastName = 'Bring', Email = 'wenfwnjf@aksdkjadksadj.com', Phone = '00234567',
                                    AccountId = a.Id);
            insert c;
            
            String type = OdigoWebService.getSegmentByCallerId(c.Phone);
            System.assertEquals(type,'VIP_Transportation');
        }
        Test.stopTest();
    }
    
    static testMethod void segmentTestBusinessStorkunde(){
        Test.startTest();
        User u = [Select Id From User Where Alias = 'aadmi'];
        System.runAs(u){
            Account a = new Account(Name = 'Test Account',RecordTypeId = getRecordTypeId('Relation level Customer'),
                                    CRMStatus__c = 'Storkunde', Sector__c = 'Transportation');
            insert a;
            
            Contact c = new Contact(FirstName = 'Posten', LastName = 'Bring', Email = 'wenfwnjf@aksdkjadksadj.com', Phone = '456789',
                                    AccountId = a.Id);
            insert c;
            
            String type = OdigoWebService.getSegmentByCallerId(c.Phone);
            System.assertEquals(type,'Storkunde');
        }
        Test.stopTest();
    }
    
    static testMethod void segmentTestBusinessNone(){
        Test.startTest();
        User u = [Select Id From User Where Alias = 'aadmi'];
        System.runAs(u){
            Account a = new Account(Name = 'Test Account',RecordTypeId = getRecordTypeId('Relation level Customer'),
                                    CRMStatus__c = 'Storkunde', Sector__c = 'Transportation');
            insert a;
            
            Contact c = new Contact(FirstName = 'Posten', LastName = 'Bring', Email = 'wenfwnjf@aksdkjadksadj.com',
                                    AccountId = a.Id);
            insert c;
            
            String type = OdigoWebService.getSegmentByCallerId('8423784298742');
            String nos = new Odigo_CustomerInfo().getAllPossiblePhoneNumbers('00123');
            System.assertEquals(type,'NONE');
            System.assertEquals(nos,'00123 OR 0123 OR 123');
        }
        Test.stopTest();
    }
    
    private static Id getRecordTypeId(String name){
        return Schema.SObjectType.Account.getRecordTypeInfosByName().get(name).getRecordTypeId();    
    }

}