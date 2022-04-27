@isTest
private class zzz_Lightuser_CaseCommentsController {
	/* TODO: Write proper testing when logic is landed. This test has sole focus on line coverage */
    static testMethod void coverageTest() {
    	
    	Case c = new Case();
    	upsert c;
    	ApexPages.currentPage().getParameters().put('id', c.id);
    	Lightuser_CaseCommentsController lc = new Lightuser_CaseCommentsController();
    	
    	CaseComment caseComment = new CaseComment();
        caseComment.CommentBody = 'test';
    	
    	lc.caseId = c.Id;
    	lc.NewComment();
    	List<Lightuser_CaseCommentsController.cComments> comments = lc.comments;
    }
}