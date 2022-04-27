// This is a test class for code coverage of FixPhoneInPostalUnitsContact

@isTest

private class zzz_FixPhoneInPostalUnitsContact
{
    static testMethod void testScenario1() 
    {
    	PostalUnit__c pu1 = new PostalUnit__c();
        pu1.Name = 'Test Postal Unit';
        pu1.street_and_number__c = 'Street and Address';
        pu1.DRM_id__c = 'enhs...9938883';
        pu1.unit_number__c = '99988829';
        pu1.unit_number_in_subsidiary__c = '27276635';
        database.insert(pu1);

        List<contactPoint__c> cpList = new List<contactPoint__c>();

        for(Integer i = 0; i < 200; i++)
        {
        	contactPoint__c cpDemo = new contactPoint__c();
        	cpDemo.Name = 'Test Contact Point' + String.valueOf(i+1);
	        cpDemo.email__c = 'test@demo.com';
	        cpDemo.phone_number__c = '2 3 4 5 6 7 8';
	        cpDemo.fax__c = '33222233';
	        cpDemo.postal_unit__c = pu1.id;

	        cpList.add(cpDemo);
        }

        database.insert(cpList);

        
    	Test.startTest();

    	FixPhoneInPostalUnitsContact fix = new FixPhoneInPostalUnitsContact('SELECT Id, Name, email__c, fax__c, phone_number__c FROM contactPoint__c');
    	Database.executeBatch(fix);

    	Test.stopTest();
    
    
    }



}