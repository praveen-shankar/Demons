// Test Class to cover the Trigger: ContactpersonUnitTrigger

@isTest
private class zzz_ContactpersonUnitTrigger
{
    static testMethod void testScenario1()
    {
        User u = [Select Id from User Where Alias = 'aadmi'];
        System.runAs(u){
        PostalUnit__c pu1 = new PostalUnit__c();
        pu1.Name = 'Test Postal Unit 1';
        pu1.street_and_number__c = 'Street and Address';
        pu1.DRM_id__c = 'enhs...99388831';
        pu1.unit_number__c = '999888291';
        pu1.unit_number_in_subsidiary__c = '272766351';
        database.insert(pu1);
        
        System.debug('Postal Unit Id: ' + pu1.Id);
        List<Unit_Contact__c> units = new List<Unit_Contact__c>();
        Unit_Contact__c cp1 = new Unit_Contact__c();
        cp1.Name = 'Test Contact Point 1';
        cp1.email__c = 'test@demo.com';
        cp1.cell_phone__c = '2 3 4 5 6 7 8';
        cp1.phone__c = '2 3 4 5 6 7 8';
        cp1.postal_unit__c = pu1.id;
        units.add(cp1);
        
        Unit_Contact__c cp2 = new Unit_Contact__c();
        cp2.Name = 'Test Contact Point 2';
        cp2.email__c = 'test@demo.com';
        cp2.phone__c = '2 3 4 5 6 7 8';
        cp2.postal_unit__c = pu1.id;
        units.add(cp2);

        Test.startTest();

        database.insert(units);

        Test.stopTest();
        }
    
    }


}