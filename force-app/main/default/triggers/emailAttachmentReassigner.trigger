// Jonathan Hersh - jhersh@salesforce.com
// November 13, 2008
//Edited so thet it only adds attachment to case on outgoing emails

trigger emailAttachmentReassigner on Attachment (before insert) {
	list<Attachment> attachmentsToInvestigate = new list<Attachment>();
	
	for( Attachment a : trigger.new ) {
		// Check the parent ID - if it's 02s, this is for an email message
		if( a.parentid == null ) {
			continue;
		} else if( string.valueof( a.parentid ).substring( 0, 3 ) == '02s' ){
			attachmentsToInvestigate.add(a);
		}
	}
	
	if(attachmentsToInvestigate.size() > 0) {
		EmailReceiverHelpers.reassignAttachments(attachmentsToInvestigate);
	}
	
}