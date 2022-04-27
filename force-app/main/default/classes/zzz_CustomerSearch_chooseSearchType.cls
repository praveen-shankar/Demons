@isTest
private class zzz_CustomerSearch_chooseSearchType {
	
	static{
		KatsTestUtilities testUtil = new KatsTestUtilities();
	}
	
	//Using the test Kundekonsulent user as testperson to see if the profile settings are OK
	private User testUser = KatsTestUtilities.getTestKundekonsulentUser();
	
	static testMethod void testCustomerSearch_chooseSearchType_1() {
		Test.setCurrentPage(new PageReference('/apex/CustomerSearch_chooseSearchType'));
		CustomerSearch_chooseSearchType testController;
		
		Test.startTest();
			testController = new CustomerSearch_chooseSearchType();
		Test.stopTest();
		
		system.assertEquals(null, testController.caseId);
	}
	
	static testMethod void testCustomerSearch_chooseSearchType_2() {
		Case testCase = new Case(id='500R0000004JUPa');
		Test.setCurrentPage(new PageReference('/apex/CustomerSearch_chooseSearchType?caseId=' + testCase.id));
		CustomerSearch_chooseSearchType testController;
		
		Test.startTest();
			testController = new CustomerSearch_chooseSearchType();
		Test.stopTest();
		
		system.assertEquals(testCase.id, testController.caseId);
	}
	
	static testMethod void testGoToCase() {
		Case testCase = new Case(id='500R0000004JUPa');
		Test.setCurrentPage(new PageReference('/apex/CustomerSearch_chooseSearchType?caseId=' + testCase.id));
		
		PageReference testResult;
		CustomerSearch_chooseSearchType testController = new CustomerSearch_chooseSearchType();
		
		Test.startTest();
			testResult = testController.goToCase();
		Test.stopTest();
		
		system.assertNotEquals(null, testResult);
	}
	
	static testMethod void testGoToPrivateSearch() {
		Case testCase = new Case(id='500R0000004JUPa');
		Test.setCurrentPage(new PageReference('/apex/CustomerSearch_chooseSearchType?caseId=' + testCase.id));
		
		PageReference testResult;
		CustomerSearch_chooseSearchType testController = new CustomerSearch_chooseSearchType();
		
		Test.startTest();
			testResult = testController.goToPrivateSearch();
		Test.stopTest();
		
		system.assertNotEquals(null, testResult);
	}
	
	static testMethod void testGoToBusinessSearch() {
		Case testCase = new Case(id='500R0000004JUPa');
		Test.setCurrentPage(new PageReference('/apex/CustomerSearch_chooseSearchType?caseId=' + testCase.id));
		
		PageReference testResult;
		CustomerSearch_chooseSearchType testController = new CustomerSearch_chooseSearchType();
		
		Test.startTest();
			testResult = testController.goToBusinessSearch();
		Test.stopTest();
		
		system.assertNotEquals(null, testResult);
	}
}