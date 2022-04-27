@isTest
private class zzz_PostalUnit_AutoCompleteController {
	/* TODO: Write proper testing when logic is landed. This test has sole focus on line coverage */
    static testMethod void coverageTest() {
    	PostalUnit_AutoCompleteController pu = new PostalUnit_AutoCompleteController();
    	System.currentPageReference().getParameters().put('aname', 'abc');
    	pu.avoidRefresh();
    	pu.clearValues();
    	pu.getHasnoresults();
    	pu.getHasparams();
    	pu.searchSuggestions();
    	pu.getResultsname();
    }
}