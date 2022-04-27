public with sharing class createCaseFromEmailController {
    Case exCase;
    Case newCase;
    List<EmailMessage> emaillist;
    PageReference pageRef;
    Boolean done = false;

    public createCaseFromEmailController(ApexPages.StandardController controller) {
        this.exCase = (Case)controller.getRecord();
        if(exCase != null){
            exCase = [select id, Accountid, Contactid, RecordTypeId, EntitlementId, BusinessHoursId, Division__c, hidden_queue_response_email__c from Case where id =:exCase.id];
        }
    } 
    
    public PageReference loadData(){
        emaillist = [select id, subject, TextBody, CreatedDate from EmailMessage where Parentid = :exCase.id ORDER BY CreatedDate DESC limit 1];
        for(EmailMessage em : emaillist){
            newCase = new Case(RecordTypeId = exCase.RecordTypeId, 
                                Subject = em.subject, 
                                Description = em.TextBody, 
                                Accountid=exCase.accountid, 
                                Contactid = exCase.contactid,
                                EntitlementId = exCase.EntitlementId,
                                BusinessHoursId = exCase.BusinessHoursId, 
                                Division__c = exCase.Division__c,
                                hidden_queue_response_email__c = exCase.hidden_queue_response_email__c
                                );  
            
            insert newCase;
            done = true;
        }
        if(done){
            pageRef = new PageReference('/'+getNewCaseId());        
            pageRef.setRedirect(true);      
        }
        if(!done){
            pageRef = new PageReference('/'+getExCaseId());        
            pageRef.setRedirect(true);
        }
        
        return pageRef;
    }
    public String getNewCaseId(){
        String ret = '';
        if(newCase != null){
            ret = newCase.id;
        }
        return ret;
    }
    public String getExCaseId(){
        String ret = '';
        if(exCase != null){
            ret = exCase.id;
        }
        return ret;
    }        
}