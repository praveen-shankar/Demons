trigger UndeliverableBeforeUpdate on UndeliverableShipment__c (before insert, before update, after update) {
    for(UndeliverableShipment__c newUndeliverable: Trigger.new) {
        
        if(Trigger.isInsert && UserInfo.getUserId()!=null) {
            try {
                String unitNumber = [SELECT unit_number__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].unit_number__c;
                newUndeliverable.Postal_Unit__c = [SELECT id FROM PostalUnit__c WHERE unit_number__c = :unitNumber LIMIT 1].id;
            } catch (QueryException qe) {
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Noe gikk galt ved lasting av enhet' ));
            }
        }

        /*
        C-02435
        UndeliverableDestruction__c is a custom setting. 
        Used to set desctruction date for undeliverable types UndeliverableShipment__c.type__c
        */
        if(Trigger.isBefore && newUndeliverable.Type__c != '') {
            List<UndeliverableDestruction__c> udList = UndeliverableDestruction__c.getAll().values();
                for(UndeliverableDestruction__c ud : udList) {
                    if(newUndeliverable.Type__c == ud.name) {
                        newUndeliverable.DateForDestruction__c = newUndeliverable.submitted__c.addMonths(integer.valueof(ud.Month__c));
                    }
                }
        }        

        
        if(Trigger.isAfter && newUndeliverable.status__c == 'Sendt til kunde' && newUndeliverable.Case__c != null) {
            Case c = [SELECT id, status FROM Case where id =: newUndeliverable.Case__c LIMIT 1];
            
            CaseComment comment = new CaseComment();
            comment.CommentBody = 'Den ubesørgelige sendingen er nå sendt til kunden';
            comment.ParentId = c.id;
            upsert comment;
            
            //commented line 37 for incident E2-IM018488316
            //c.status = 'Avsluttet';
            c.case_new_Comment__c = false;
            upsert c;
        }
    }
}