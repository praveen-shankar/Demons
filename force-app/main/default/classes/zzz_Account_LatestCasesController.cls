@isTest
private class zzz_Account_LatestCasesController {

    static testMethod void alccTest() {
    
       Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
          
        Account acct = new Account(Name='Test', recordtypeid=RecordTypeId);
        upsert acct;
        Integer numberOfCasesOnAccount = 10;
        List<Case> cs = new List<Case>();
        
        for (Integer i = 0; i < numberOfCasesOnAccount; i++) {
            cs.add(new Case(Subject = 'Test Case' + i, AccountId = acct.Id));
        }
        upsert cs;
        
        Case testCase = cs[0];
        
        ApexPages.currentPage().getParameters().put('id',testCase.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(testCase);
        Account_LatestCasesController alcc = new Account_LatestCasesController(stdController);

        System.assertEquals(alcc.isCasesOnAccount,TRUE);
        System.assertEquals(alcc.currentCase.Id,testCase.Id);
        if(numberOfCasesOnAccount<12){
            System.assertEquals(alcc.latestCases.size(), numberOfCasesOnAccount - 1);
        } else {
            System.assertEquals(alcc.latestCases.size(), 10);
        }

    }
        
}