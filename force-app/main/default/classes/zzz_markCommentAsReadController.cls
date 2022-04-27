@isTest
private class zzz_markCommentAsReadController {
	static Case c;
	static markCommentAsReadController ctrl;
	
	static void init() {
		c = new Case(subject = 'Test case', description = 'test', case_new_Comment__c = true); 
		insert c;
		
		c = [select id, case_new_Comment__c from Case where id=:c.id];
		system.assertEquals(true, c.case_new_Comment__c);
		
		PageReference pageRef = Page.markCommentAsRead;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', c.id);
		
		ctrl = new markCommentAsReadController(new ApexPages.StandardController(c));
	}
		
	static testMethod void testMarkCommentAsRead() { 
		init();
		
		Test.startTest(); 
		ctrl.loadData(); 
		String caseId = ctrl.getExCaseId();
		Test.stopTest();
		
		c = [select id, case_new_Comment__c from Case where id=:c.id];
		System.assert(c.case_new_Comment__c == false, 'New comment flag should be set to false.');
		System.assert((c.id == null) || (c.id == caseId), 'Retreived case id should match actual case id.');
	}

}