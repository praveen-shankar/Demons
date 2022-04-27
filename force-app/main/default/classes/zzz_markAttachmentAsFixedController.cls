@isTest
private class zzz_markAttachmentAsFixedController {
	
	static Case c;
	static markAttachmentAsFixedController ctrl;
		
	static void init() {
		c = new Case(subject = 'Test case', description = 'test', attachment_from_email_failed__c = true); 
		insert c;
			
		c = [select id, attachment_from_email_failed__c from Case where id=:c.id];
		system.assertEquals(true, c.attachment_from_email_failed__c);
			
		PageReference pageRef = Page.markAttachmentAsFixed;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', c.id);
			
		ctrl = new markAttachmentAsFixedController(new ApexPages.StandardController(c));
	}
		
	static testMethod void testMarkAttachmentAsFixed() { 
		init();
			
		Test.startTest(); 
		ctrl.loadData(); 
		String caseId = ctrl.getExCaseId();
		Test.stopTest();
			
		c = [select id, attachment_from_email_failed__c from Case where id=:c.id];
		System.assert(c.attachment_from_email_failed__c == false, 'Attachment failure flag should be set to false.');
		System.assert((c.id == null) || (c.id == caseId), 'Retreived case id should match actual case id.');
	}

}