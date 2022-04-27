public class EmailMessageActions {
    public Id prevId {get;set;}
    public Id nextId {get;set;}
    public Id caseId {get;set;}
    public Boolean isLex {get;set;}
    public String prevURL {get;set;}
    public String nextURL {get;set;}
    public EmailMessage eMsg;
    public String statusMsg {get;set;}
    
    public EmailMessageActions(ApexPages.StandardController stdController) {        
        this.eMsg = (EmailMessage)stdController.getRecord();
        statusMsg = null;
        getPreviousNextEMsgIds();
    }
    
    public PageReference previousMsg(){
        //statusMsg = 'Loading...';
        System.debug('In previousMsg');
        if(prevId!=null){
            PageReference page = new PageReference(prevURL);
            page.setRedirect(true);
            return page;
        }
        else
            statusMsg = 'No More Previous Emails.';
        return null;
    }
    public PageReference nextMsg(){
        System.debug('In nextMsg');
        if(nextId!=null){
            PageReference page = new PageReference(nextURL);
            page.setRedirect(true);
            return page;
        }
        else
            statusMsg = 'No More Next Emails.';
        return null;
    }
    
    public void getPreviousNextEMsgIds() {
        System.debug('eMsg--'+eMsg.Id);
        for(EmailMessage obj: [SELECT ParentId FROM EmailMessage WHERE Id =:eMsg.Id])
            caseId = obj.ParentId;
        System.debug('caseId--'+caseId);
        List<Id> lstId = new List<Id>();
        for(EmailMessage obj: [SELECT Id FROM EmailMessage WHERE ParentId =:caseId ORDER BY MessageDate ASC])
            lstId.add(obj.Id);
        System.debug('lstId--'+lstId);
        Integer result = lstId.indexOf(String.valueOf(eMsg.Id));
        System.debug('result--'+result);
        if(result > 0){
            prevId = lstId.get(result-1);
            if(result < lstId.size()-1)
                nextId = lstId.get(result+1);
        }
        else if(result == 0 && lstId.size() > 1)
            nextId = lstId.get(result+1);
        
        String uiThemeDisplayed = UserInfo.getUiThemeDisplayed();
        if(uiThemeDisplayed.equalsIgnoreCase('Theme4d'))
            isLex = true;
        else 
            isLex = false;
        System.debug('isLex--'+isLex);
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        if(isLex){
            if(prevId!=null)
                prevURL = sfdcBaseURL+'/lightning/r/EmailMessage/'+prevId+'/view';
            if(nextId!=null)
                nextURL = sfdcBaseURL+'/lightning/r/EmailMessage/'+nextId+'/view';
        }
        else{
            if(prevId!=null)
                prevURL = sfdcBaseURL+'/'+prevId;
            if(nextId!=null)
                nextURL = sfdcBaseURL+'/'+nextId;
        }
        System.debug('prevURL--'+prevURL);
    }
}