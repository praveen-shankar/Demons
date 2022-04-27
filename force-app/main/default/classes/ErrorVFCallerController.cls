public class ErrorVFCallerController {
    
    /*public case caseObj;
    public string case_Id;
    public Boolean showAlert {get;set;}
    
    public ErrorVFCallerController(ApexPages.standardController stdController){
        this.case_Id = stdController.getId();
    }*/
    
    @AuraEnabled
    public static String updateErrorField(Id recId){
        String errorMessage;
        String recordId = recId;
        system.debug('recId --> ' + recId);
        system.debug('recordId --> ' + recordId);
        if(recordId.startsWith('001')){
            errorMessage = updateAccountFields(recordId);
        }
        /*else if(recordId.startsWith('500')){
            errorMessage = updateCaseFields(recordId);
        }*/
        return errorMessage;
    }
    
/*    public static String updateCaseFields(String caseId){
        Case c = [Select Id, Trigger_Callout_Status__c, Trigger_Callout_Message__c from case where id = :caseId];
        system.debug('CaseId --> ' + caseId);
        system.debug('case record --> '+ c);
        String messageToUI;
        if(c.Callout_Status__c!=null){
            c.Callout_Status__c = null;
            update c;
            messageToUI = '';
        }
        return messageToUI;    
    }
*/  
    public static String updateAccountFields(String accountId){
        Account acc = [Select Id, Trigger_Callout_Status__c, Trigger_Callout_Message__c from Account where id = :accountId];
        system.debug('accountId --> ' + accountId);
        system.debug('Account record --> '+ acc);
        
        String messageToUI;
        if(acc.Trigger_Callout_Status__c == 'Error' && acc.Trigger_Callout_Message__c != null){
            messageToUI = acc.Trigger_Callout_Message__c;
            acc.Trigger_Callout_Message__c = null;
            update acc;
        }
        else if(acc.Trigger_Callout_Status__c == 'Success' && acc.Trigger_Callout_Message__c != null){
            messageToUI = acc.Trigger_Callout_Message__c;
            acc.Trigger_Callout_Message__c = null;
            update acc;
        }
        return messageToUI;    
    }
}