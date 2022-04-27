public with sharing class markCommentAsReadController {
	Case exCase;
    PageReference pageRef;

    public markCommentAsReadController(ApexPages.StandardController controller) {
        this.exCase = (Case)controller.getRecord();
        exCase = [select id, case_new_Comment__c, unread_action__c from Case where id =:exCase.id];
    }
    public PageReference loadData(){
        exCase.case_new_Comment__c = false;

        // Update for change C-02380
        if(exCase.unread_action__c == false)
        {
            exCase.hidden_preview_email__c = null;
        }

        // Committing changes
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