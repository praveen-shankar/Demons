global class KATSEmailServiceController implements Messaging.InboundEmailHandler {

    //Class variables
    private Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    private Messaging.Inboundemail email;
    private Messaging.Inboundenvelope envelope;
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email_var, Messaging.InboundEnvelope envelope_var) {
        this.result = new Messaging.InboundEmailresult();
        email = email_var;
        envelope = envelope_var;
        

        //If mail is sent from saksbehandler(example-> scanneddocuments)
        if(this.envelope.fromAddress.equals(this.envelope.fromAddress)) { //TODO: .equals(printer epostadresse)
            system.debug('The inbound e-mail is a scanned letter/fax');
            Task t = new Task();
            
            //a t.whatId is needed. Otherwise only users with modify/view all data permission will have access
            try {
	            Account placeholderObject = [select id from Account where name like '%brev%' and parent.name='Posten SLA Placeholder Account' limit 1];
	            t.WhatId = placeholderObject.Id;
            }
            catch(Exception e) {
            	system.debug('ERROR in ref data: If this fails, ref data is not properly setup. An account is needed with "brev" in the name and with an account named "Posten SLA Placeholder Account" as parent account');
            	throw e;
            }
            
            t.recordTypeId = KATSutilities.getRecordType('Letter_or_fax_task');
            t.subject = 'Brev/faks';
            t.ActivityDate = Date.today();
            t.status = 'Completed';
            t.Type = 'Brev/faks';
            t.Description = email.subject + '\n\n' + email.plainTextBody;
            
            insert t;
            
            list<Attachment> attachmentsToInsert = new list<Attachment>();
            for(integer i=0; email.binaryAttachments != null && i<email.binaryAttachments.size(); i++) {
	            Attachment a = new Attachment();
	            a.Body = email.binaryAttachments[i].body;
	            a.ContentType = email.binaryAttachments[i].mimeTypeSubType;
	            a.Name = email.binaryAttachments[i].fileName;
            	a.ParentId = t.id;
            	attachmentsToInsert.add(a);
            }
            insert attachmentsToInsert;
        }
        // possibly also handle outlook-to-salesforce scenario
      
		result.success = true;
        return result;
    }
}