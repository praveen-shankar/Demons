/*Trigger logic for processing e-mails received by the system.*/
trigger EmailReceiver on EmailMessage (before insert) {

    map<ID, EmailMessage> emailsToInvestigate = new map<ID, EmailMessage>();
    map<ID, Case> emailsAndAutoresponse = new map<ID, Case>();
    EmailReceiverHelpers erh = new EmailReceiverHelpers();
    
    for(EmailMessage em:trigger.new) { 
        system.debug('populating map of caseID, emailMessage to investigate');
        system.debug('Looking at emailmessage: ' + em);
        if(em.Incoming) { //Only incomming e-mails are interesting...
            if(emailsToInvestigate.containsKey(em.parentId)) {
                system.debug('The case is already in the list...');
                if(em.CreatedDate < emailsToInvestigate.get(em.parentId).CreatedDate) {
                    system.debug('The case is already in the list, but with a newer e-mail. Linking the oldest e-mail');        
                    emailsToInvestigate.put(em.parentId, em);
                }
            }
            else {
                system.debug('The case is not already in the list. Adding it.');        
                emailsToInvestigate.put(em.parentId, em);
            }
        }
    }
    
    erh.processCases(emailsToInvestigate.keySet());
}