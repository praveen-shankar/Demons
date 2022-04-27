global class cs_UpdateAttachmentDescription_Batch implements Database.Batchable<sObject>, Database.Stateful {
    
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'Select id, parentId, description, createdby.name from Attachment where createdbyId != \'005w000000724XW\'';
        return database.getquerylocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Attachment> scope){
        List<Attachment> updateAttachment = New List<Attachment>();
        for(Attachment att : scope){
            if(att.ParentId.getSobjectType() == Case.SobjectType && att.createdbyId != '005w000000724XW'){
                att.Description = 'Internal';
                updateAttachment.add(att);
                recordsProcessed += 1;
            }
        }
        update updateAttachment;
    }
    
    global void finish(Database.BatchableContext bc){
        system.debug('No of attachments updated : '+recordsProcessed);
    }
}