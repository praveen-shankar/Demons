@isTest
private class zzz_ContextLogger {

	
	static testMethod void testLogCaseErrors() {
		// setup
		Case c = new Case();
		insert c;
		Integer numberOfLogItems = 11;
		String errorDescription = 'Something happened';
		
		List<ContextLogger.LogItem> logItems = new List<ContextLogger.LogItem>();
		
		for(Integer i = 0; i < numberOfLogItems; i++) {
			logItems.add(new ContextLogger.LogItem(c, errorDescription));
		}		

		Test.startTest();
		ContextLogger.log(logItems);
		Test.stopTest();
		
		// asserts
		List<CaseComment> caseComments = [select CommentBody from CaseComment where parentId = :c.Id];
		System.assert(caseComments.size() == numberOfLogItems, 'Number of CaseComments = ' + caseComments.size() + ' created should match numberOfLogItems = ' + numberOfLogItems);
		CaseComment caseComment;
		for(Integer i = 0; i < caseComments.size(); i++) {
			caseComment = caseComments.get(i);
			System.assert(caseComment.CommentBody == errorDescription, 'caseComments[' + i + '].CaseComment.CommentBody should be ' + errorDescription + ' but is ' + caseComment.CommentBody);
		}
	}
}