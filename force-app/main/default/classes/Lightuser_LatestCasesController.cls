// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
public with sharing class Lightuser_LatestCasesController {
    public List<Case> latestCases { get; set; }
    
    public String caseCaseNumber{ get; set; }
    public String partyNumber{ get; set; }
    public Boolean Isactivelightuser {get;set;}
    
    public Lightuser_LatestCasesController() {
    
    Isactivelightuser =true;
       environment_settings__c env = environment_settings__c.getValues('Isactivelightuser');
        if (env != null && env.value__c == 'false')  {
              Isactivelightuser =false;  
        
        }
        String deviation_casetypeId = KATSutilities.getRecordType('deviation_case');
        String gjenliggTypeId = KATSutilities.getRecordType('Gjenligg');   
        latestCases = new List<Case>();
        partyNumber = ApexPages.currentPage().getParameters().get('partyId');
        if(partyNumber != null && partyNumber!='null') {
            partyNumber = KATSutilities.removeLeadingZeros(partyNumber);
            latestCases = [SELECT c.id, c.deviation_time_of_incident__c,c.Created_by_Unit__r.name, c.Produkt__c, c.Type__c, c.Subject, toLabel(c.RecordType.Name), c.Code_Reason1__r.name, c.Code_Reason2__r.name, c.Code_Event__r.Name, c.CaseNumber, c.status, c.createdDate, c.lastModifiedDate, Account.Name, Account.crm_customer_number__c FROM Case c WHERE c.Account.crm_customer_number__c = :partyNumber ORDER BY c.CreatedDate DESC LIMIT 500];
        } else {
             latestCases = [SELECT c.id,c.deviation_time_of_incident__c, c.Created_by_Unit__r.name, c.Produkt__c, c.Type__c, c.Subject, toLabel(c.RecordType.Name), c.Code_Reason1__r.name, c.Code_Reason2__r.name, c.Code_Event__r.Name, c.CaseNumber, c.status, c.createdDate, c.lastModifiedDate, Account.Name, Account.crm_customer_number__c FROM Case c WHERE (c.Origin='AvT' OR c.Origin='Lightuser') AND (RecordTypeID =:deviation_casetypeId  OR RecordTypeID =:gjenliggTypeId) ORDER BY c.CreatedDate DESC LIMIT 500];
        }
    }
    
    public PageReference seeCase() {
        try {
            String id = [SELECT c.id FROM Case c WHERE c.caseNumber =:caseCaseNumber LIMIT 1].id;
            if(id.length() > 0){
                if(String.isNotBlank(partyNumber)) {
                    return new PageReference('/Lightuser_searchCase?id=' + id + '&partyid=' + partyNumber);
                }
                return new PageReference('/Lightuser_searchCase?id=' + id);
            }
        } catch (Queryexception e) {
            
        }
        return null;
    }
}