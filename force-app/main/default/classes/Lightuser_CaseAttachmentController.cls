public with sharing class Lightuser_CaseAttachmentController {

    public String caseId { get; set; }
    public Attachment att { get; set; }
    public boolean isCaseOpen;
    public boolean isCaseClosed;
    public Boolean Isactivelightuser {get;set;}

    public Lightuser_CaseAttachmentController() {
        att = new Attachment();
         Isactivelightuser =true;
       environment_settings__c env = environment_settings__c.getValues('Isactivelightuser');
        if (env != null && env.value__c == 'false')  {
              Isactivelightuser =false;  
        
        }
    }

    public Attachment[] attachments {
        get {
            caseId = ApexPages.currentPage().getParameters().get('id');
            return [SELECT id, body, name, createdDate FROM Attachment WHERE ParentId = :caseId ORDER BY CreatedDate desc];
        }
        set;
    }
    
    public boolean getIsCaseOpen() {
        try {
            caseId = ApexPages.currentPage().getParameters().get('id');
            String status = [SELECT status FROM Case WHERE id = :caseId LIMIT 1].status;
            
           // if(status != 'Closed') 
            if(status != 'Avsluttet') //api name
            {
                return true;
            }
        } catch(Exception e) {
        
        }
        
        return false;
    }
    
    public boolean getIsCaseClosed() {
        if(!getIsCaseOpen()) {
            return true;
        }
        return false;
    }
    
    public PageReference newAttachment() {
        try {
            caseId = ApexPages.currentPage().getParameters().get('id');
            att.ParentId = caseId;
            insert att;
           
           PageReference ref=new PageReference('/Lightuser_CaseDetailView?id=' + caseId + '&attachmentCreatedDate=' + System.now());
            ref.setRedirect(true);
            return ref;
            //return new PageReference('/Lightuser_searchCase?id=' + caseId);
        } catch(Exception e) {
        
        } 
        
        return null;
    }
    
}