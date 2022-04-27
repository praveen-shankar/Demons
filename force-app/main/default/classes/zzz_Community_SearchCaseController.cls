@isTest
private class zzz_Community_SearchCaseController {
    /* TODO: Write proper testing when logic is landed. This test has sole focus on line coverage */
    static testMethod void coverageTest() {
        Case c = new Case();
        upsert c;
        
        c = [SELECT id, caseNumber FROM Case WHERE id = :c.id LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('cid',c.id);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(new Case());
        Community_SearchCaseController cc = new Community_SearchCaseController(stdController);
        
        cc.caseCaseNumber = c.CaseNumber;
        cc.getSingleView(c.caseNumber);
        cc.getSingleView('xxxxxx'); // Testing exception
        
        cc.searchForCases();
        cc.getHasCaseSearchResults();
        cc.getIsSingleView();
        cc.clearSearch();
        cc.getProxyObject();
        cc.validateUser();
       
    }
    static testmethod void testAddSearchTerm(){
        
       // String q=Lightuser_SearchCaseController.addSearchTern('', '');
     
    }

    static testMethod void testSearchCases(){
        Case c=new Case();
        insert c;
        ApexPages.StandardController stdController = new ApexPages.StandardController(new Case());
        Community_SearchCaseController cc = new Community_SearchCaseController(stdController);
        cc.c=c;
        
        
        cc.postalCodeRange='1222-1255';
        cc.searchCases(10);
        
        cc.postalCodeRange='1222,1223,1226';
        cc.searchCases(10);
        
        pageReference pr=cc.exportResultToExcel();
        system.assert(pr!=null);
        
        Boolean isSingleView= cc.getIsSingleView();
        System.assertEquals(isSingleView, false);
        ApexPages.currentPage().getParameters().put('id',c.id);
        isSingleView= cc.getIsSingleView();
        System.assertEquals(isSingleView, true);
        
    }
}