@isTest
private class zzz_Lightuser_Controller {
    /* TODO: Write proper testing when logic is landed. This test has sole focus on line coverage */
    static testMethod void coverageTest() {
        Lightuser_Controller lc = new Lightuser_Controller();
        PageReference pr;
        boolean empty;
        
        pr=lc.latestCases();
        
        pr = lc.createCase();
        
        pr = lc.searchCase();
        pr= lc.searchCustomer();
        pr=lc.createReport();
        
    }
    
      static testMethod void coverageTest_2() {
        Lightuser_Controller lc = new Lightuser_Controller();
        PageReference pr;
        boolean empty;
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account a=new Account(Name='Freia AS');
        a.recordtypeid= recordtypeid;
        Insert a;
        Case c=new Case(AccountID=a.id);
        insert c;
        ApexPages.currentPage().getParameters().put('partyId', a.id);
        pr=lc.latestCases();
        pr = lc.createCase();
        pr = lc.searchCase();
        pr= lc.searchCustomer();
        pr=lc.createReport();
    }
}