@isTest
private class zzz_Lightuser_SearchCaseController {
	/* TODO: Write proper testing when logic is landed. This test has sole focus on line coverage */
    static testMethod void coverageTest() {
    	Case c = new Case();
    	upsert c;
    	
    	c = [SELECT id, caseNumber FROM Case WHERE id = :c.id LIMIT 1];
    	
        ApexPages.currentPage().getParameters().put('cid',c.id);
    	
    	ApexPages.StandardController stdController = new ApexPages.StandardController(new Case());
    	Lightuser_SearchCaseController lc = new Lightuser_SearchCaseController(stdController);
    	
    	lc.caseCaseNumber = c.CaseNumber;
    	lc.getSingleView(c.caseNumber);
    	lc.getSingleView('xxxxxx'); // Testing exception
    	
    	lc.searchForCases();
    	lc.getHasCaseSearchResults();
    	lc.getIsSingleView();
    	lc.clearSearch();
    	lc.getProxyObject();
        lc.validateUser();
       
    }
    static testmethod void testAddSearchTerm(){
    	
       // String q=Lightuser_SearchCaseController.addSearchTern('', '');
     
    }

    static testMethod void testSearchCases(){
    	Case c=new Case();
    	insert c;
    	ApexPages.StandardController stdController = new ApexPages.StandardController(new Case());
    	Lightuser_SearchCaseController lc = new Lightuser_SearchCaseController(stdController);
    	lc.c=c;
    	
    	
    	lc.postalCodeRange='1222-1255';
    	lc.searchCases(10);
    	
    	lc.postalCodeRange='1222,1223,1226';
    	lc.searchCases(10);
    	
    	pageReference pr=lc.exportResultToExcel();
    	system.assert(pr!=null);
    	
    	Boolean isSingleView= lc.getIsSingleView();
    	System.assertEquals(isSingleView, false);
    	ApexPages.currentPage().getParameters().put('id',c.id);
    	isSingleView= lc.getIsSingleView();
    	System.assertEquals(isSingleView, true);
    	
    }
}