/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class zzz_OwnerQuickChangeController {
	static Case c;
	static OwnerQuickChangeController ctrl;
	static User testUser;// = KatsTestUtilities.getTestUser();

	static void init() {
		zzz_OwnerQuickChangeController.createTestUser();
		c = new Case();
		insert c;
		ctrl = new OwnerQuickChangeController(new ApexPages.StandardController(c));
	}

	private static void createTestUser() {
		List<Profile> profiles = [select Id from Profile where name='System Administrator'];
		DateTime timestamp = dateTime.now();
		String appendTimeStamp = timestamp.format('MMddyyyyhhmmss','America/New_York');
		testUser = new User(
			alias='t'+ appendTimeStamp.substring(0,4),
			email='test'+appendTimeStamp+'@posten.capgemini.com.test',
			emailencodingkey='UTF-8', 
      		lastname='Testing', languagelocalekey='en_US',
      		localesidkey='en_US', 
      		profileid = profiles.get(0).Id,
	    	timezonesidkey='America/Los_Angeles',			
      		username='mahoel'+appendTimeStamp+'@posten.capgemini.com.test'
			);
		
		insert testUser;
	}

    static testMethod void testOwnerChange() {
    	init();
    	//testUser = KatsTestUtilities.getTestUser();
    	Test.startTest();
        ctrl.ownerId = testUser.Id;
        ctrl.changeOwner();
        Test.stopTest();
        System.assertEquals(c.OwnerId, testUser.Id, 'Case owner has not changed correctly');
    }
}