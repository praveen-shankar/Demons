public class Lightuser_Controller {

    public Boolean Isactivelightuser {get;set;}
    
    public Lightuser_Controller (){
    Isactivelightuser =true;
       environment_settings__c env = environment_settings__c.getValues('Isactivelightuser');
        if (env != null && env.value__c == 'false')  {
              Isactivelightuser =false;  
        
        }
    
    }
    public PageReference latestCases() {
        String partyNumber = ApexPages.currentPage().getParameters().get('partyId');
        if(partyNumber != null) {
            return new PageReference('/Lightuser_LatestCases?partyid=' + partyNumber);
        }
        return new PageReference ('/Lightuser_LatestCases');
    }
    
    public PageReference createCase() {
        String partyNumber = ApexPages.currentPage().getParameters().get('partyId');
        if(partyNumber != null) {
            return new PageReference('/Lightuser_CreateCase?partyid=' + partyNumber);
        }
        return new PageReference('/Lightuser_CreateCase');
    }
    
    public PageReference searchCase() {
        String partyNumber = ApexPages.currentPage().getParameters().get('partyId');
        if(partyNumber != null) {
            return new PageReference('/Lightuser_searchCase?partyid=' + partyNumber);
        }
        return new PageReference('/Lightuser_searchCase');
    }
    
    public PageReference searchCustomer() {
        String partyNumber = ApexPages.currentPage().getParameters().get('partyId');
        if(partyNumber != null) {
            return new PageReference('/Lightuser_searchCustomer?partyid=' + partyNumber);
        }
        return new PageReference('/Lightuser_searchCustomer');
    }
    
    public PageReference createReport(){
        String partyNumber = ApexPages.currentPage().getParameters().get('partyId');
        if(partyNumber != null) {
            return new PageReference('/Lightuser_ReportWizard?partyid=' + partyNumber);
        }
        return new PageReference('/Lightuser_ReportWizard');
    }
    
   
   public String userManual {
    get{ 
        try{return environment_settings__c.getValues('link_lightuser_manual').value__c;}
        catch(Exception e){return '_blank'; }
        }
    set;
   }
}