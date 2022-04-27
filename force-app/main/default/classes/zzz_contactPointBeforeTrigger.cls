// Test Class to cover the Trigger: contactPointBeforeTrigger

@isTest
private class zzz_contactPointBeforeTrigger
{
    static testMethod void testScenario1()
    {
        User u = [Select Id from User Where Alias = 'aadmi'];
        System.runAs(u){
        PostalUnit__c pu1 = new PostalUnit__c();
        pu1.Name = 'Test Postal Unit';
        pu1.street_and_number__c = 'Street and Address';
        pu1.DRM_id__c = 'enhs...9938883';
        pu1.unit_number__c = '99988829';
        pu1.unit_number_in_subsidiary__c = '27276635';
        database.insert(pu1);
        
        System.debug('Postal Unit Id: ' + pu1.Id);

        contactPoint__c cp1 = new contactPoint__c();
        cp1.Name = 'Test Contact Point 1';
        cp1.email__c = 'test@demo.com';
        cp1.phone_number__c = '2 3 4 5 6 7 8';
        cp1.fax__c = '33222233';
        cp1.postal_unit__c = pu1.id;

        Test.startTest();

        database.insert(cp1);

        Test.stopTest();
        }
    
    }


}