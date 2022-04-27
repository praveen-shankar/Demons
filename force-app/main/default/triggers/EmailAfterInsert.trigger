trigger EmailAfterInsert on EmailMessage (after insert) {
       DateTime completionDate = System.now();
        List<Id> caseIds = new List<Id>();
        for (EmailMessage em : Trigger.new){
            if(em.Incoming == false)
                caseIds.add(em.ParentId);
        }
        if (caseIds.size()>0){
           KATSutilities.completeMilestone(caseIds, 'Svarsfrist', completionDate);
        }  
        
        
        //Salesforce.com Support test 05174457
        /*
        
        for(EmailMessage trigObj : Trigger.new)
        {
            System.debug('Setup Variables'); //Setup variables.
            List<Id> csId = new List<Id>();
            Case cObj = new Case();
            
            System.debug('Define Variables'); //Define variables.
            csId.add(TrigObj.ParentId); 
            cObj = [select id, Entry_Email_Address__c from case where Id=:csId];
            
            cObj.Entry_Email_Address__c = trigObj.ToAddress;
            update cObj;            
        }*/
}