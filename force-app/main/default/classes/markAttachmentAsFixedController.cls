public with sharing class markAttachmentAsFixedController {
	Case exCase;
    PageReference pageRef;

    public markAttachmentAsFixedController(ApexPages.StandardController controller) {
        this.exCase = (Case)controller.getRecord();
        exCase = [select id, attachment_from_email_failed__c from Case where id =:exCase.id];
    }
    public PageReference loadData(){
        exCase.attachment_from_email_failed__c = false;
        upsert exCase;
        if(exCase != null){
            pageRef = new PageReference('/'+getExCaseId());        
            pageRef.setRedirect(true);
        }
        
        return pageRef;
    }
    public String getExCaseId(){
        String ret = '';
        if(exCase != null){
            ret = exCase.id;
        }
        return ret;
    }
}