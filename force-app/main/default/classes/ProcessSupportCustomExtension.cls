public with sharing class ProcessSupportCustomExtension {
        List<ProcessSupport__c> prc;
        
    public ProcessSupportCustomExtension(ApexPages.StandardController controller) {

    }
    public String getSupportName(){
        return System.currentPagereference().getParameters().get('subject');
    }
    public String getSupportDescription(){   
        if (prc.size() > 0){
            return prc[0].Description__c;
        }
        return '';
    }
    public List<ProcessSupport__c> getProcessSupports(){
        return [select Name, Description__c from ProcessSupport__c order by Name limit 100];
    }
    public void loadData(){
        prc = [Select Description__c from ProcessSupport__c where name = :System.currentPagereference().getParameters().get('subject') limit 1];
    }
}