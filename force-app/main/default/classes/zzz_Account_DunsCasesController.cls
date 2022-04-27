@isTest
public with sharing class zzz_Account_DunsCasesController {
    
    
    static testMethod void adccTest() {
        List<Account> accList = new List<Account>();
        List<Case> cs = new List<Case>();
        
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
          
        for (Integer i = 0; i < 2; i++){
            Account acct = new Account(Name='Test', DUNS_number__c = '123', recordtypeid= RecordTypeId);
          //  Account acct = new Account(Name='Test', DUNS_number__c = '123');
            upsert acct;
            accList.add(acct);
            for (Integer j = 0; j < 10; j++) {
                cs.add(new Case(Subject = 'Test Case' + i, AccountId = acct.Id));
            }
        }
        upsert cs;
            
        Account testAccount = accList[0];
        Test.setCurrentPage(new PageReference('/apex/Account_DunsCases'));
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',testAccount.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        Account_DunsCasesController adcc = new Account_DunsCasesController(stdController);

        System.assertEquals(adcc.numberOfCasesOnAccounts,20);
        System.assertEquals(adcc.currentAccount.Id, testAccount.Id);
        Test.stopTest();
    }
    
        
    static testMethod void noDunsNumberTest() {
        Account testAccount = new Account(Name='Test');
        upsert testAccount;

        Test.setCurrentPage(new PageReference('/apex/Account_DunsCases'));
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',testAccount.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        Account_DunsCasesController adcc = new Account_DunsCasesController(stdController);

        System.assertEquals(adcc.numberOfCasesOnAccounts,0);
        System.assertEquals(adcc.isDunsNumberOnAccount, FALSE);
        Test.stopTest();
    }
}