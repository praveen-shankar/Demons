public with sharing class Account_DunsCasesController {
    public List<Case> latestDunsCases { get; set; }
    public Account currentAccount{ get; set; }
    public Integer numberOfCasesOnAccounts{ get; set; }
    public Integer numberOfRowsInView{ get; set; }
    public Boolean isInlinePage{ get; set; }
    public Boolean isDunsNumberOnAccount{ get; set; }
    
    public Account_DunsCasesController(ApexPages.StandardController controller) {
        currentAccount = [SELECT Id, DUNS_number__c, Name FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('id') LIMIT 1];
        if(currentAccount.DUNS_number__c == null || currentAccount.DUNS_number__c ==''){
            isDunsNumberOnAccount = FALSE;
            numberOfCasesOnAccounts = 0;
            numberOfRowsInView = 0;
            latestDunsCases = null;
            isInlinePage = TRUE;
        } else {
            isDunsNumberOnAccount = TRUE;
            List<Account> accts = [SELECT a.Id, a.DUNS_number__c FROM Account a WHERE a.DUNS_number__c = :currentAccount.DUNS_number__c];
            List<Id> AccountIds = new List<Id>();  
            for(Account a: accts){
                AccountIds.add(a.id);  
            }
            latestDunsCases = [SELECT c.id, c.CreatedDate, c.CaseNumber, c.Subject, toLabel(c.RecordType.Name), c.status, c.AccountId, c.Account.Name, c.Account.crm_Customer_Number__c FROM Case c WHERE c.AccountId = :AccountIds ORDER BY c.CreatedDate DESC LIMIT 500];  
            numberOfCasesOnAccounts = latestDunsCases.size();
            isInlinePage = ApexPages.currentPage().getUrl().endsWith('inline=1');
            numberOfRowsInView = isInlinePage ? 10 : numberOfCasesOnAccounts;
        }
    }
}