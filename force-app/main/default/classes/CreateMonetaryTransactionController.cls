public with sharing class CreateMonetaryTransactionController {

    public List<SelectOption> options{get;set;}
    public Id recordTypId {get;set;}
    public String caseId {get;set;}
    public Case Cas{get;set;}
    public Monetary_Transaction__c trans{get;set;}

    public CreateMonetaryTransactionController(ApexPages.StandardSetController controller) {
    Cas = [Select CaseNumber,id,RecordTypeid,RecordType.DeveloperName from Case where id=: apexpages.currentpage().getparameters().get('id') limit 1];
    caseId = Cas.CaseNumber;
    List<RecordType> recordTypeList = [select developerName,id,toLabel(Name) from RecordType where SObjectTYpe='Monetary_Transaction__c' and isactive= true order by LastModifiedDate asc];
    Set<RecordType> recordTypeSet = new Set<RecordType>();
    for(RecordType rtyp : recordTypeList ){
        
        recordTypeSet.Add(rtyp);
      
        }
    System.debug('recordTypeSet==============='+recordTypeSet);

        options = new List<SelectOption>();
        for(RecordType rd : recordTypeSet)
        {
            options.add(new SelectOption(rd.id,rd.Name));
        }
        

    }




    public PageReference ContinueToCase(){
        PageReference pf = new PageReference('/a07/e?RecordType='+recordTypId+'&CF'+System.Label.cs_MonetaryCase+'='+caseId+'&retURL='+apexpages.currentpage().getparameters().get('id'));
        System.debug('=================pf'+pf);
        return pf;   
    }

}