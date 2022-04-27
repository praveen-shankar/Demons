public with sharing class Account_LatestCasesController {
        public List<Case> latestCases { get; set; }       
        public String caseAccountId{ get; set; }
        public String caseId{ get; set; }
        public Case currentCase{ get; set; }
        public boolean isCasesOnAccount{ get; set; }
        public boolean isNoCasesOnAccount{ get; set; }
        public boolean isNoAccountOnCase{ get; set; }
        
        public Account_LatestCasesController(ApexPages.StandardController controller) {
                currentCase = [SELECT Id, AccountId FROM Case WHERE Id = :ApexPages.currentPage().getParameters().get('id') LIMIT 1];
                caseAccountId = currentCase.AccountId;
                latestCases = new List<Case>();
                if(caseAccountId != null && caseAccountId !='') {
                        latestCases = [SELECT c.id, c.Owner.Name, c.CreatedDate, c.CaseNumber, c.Subject, c.RecordType.Name, c.status FROM Case c WHERE c.AccountId = :caseAccountId AND c.id != :currentCase.Id ORDER BY c.CreatedDate DESC LIMIT 10];
                }
                isNoAccountOnCase = (caseAccountId == null);
                isCasesOnAccount = (latestCases.size() != 0);
                isNoCasesOnAccount = (latestCases.size() == 0 && caseAccountId != null);
        }
}