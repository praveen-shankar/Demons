trigger QueueDetailsValidateOwnerBeforeUpdate on QueueDetails__c (before update) {
    List<ID> idlist = new List<ID>();
    List<ID> idlistActivate = new List<ID>();
    QueueDetails__c oldQueueDetails = null;
    Map<Id,boolean> allActiveQueues = new Map <Id,boolean>();
    for (QueueDetails__c qd : [select owner.id, fetch_from_cti__c from QueueDetails__c where fetch_from_cti__c = true]) {
             allActiveQueues.put(qd.owner.id, qd.fetch_from_cti__c);
    }
    System.debug(allActiveQueues.size());
    
    for(integer i=0; i<trigger.new.size(); i++ ) {
        QueueDetails__c newQueueDetails = trigger.new[i];
    
        if(Trigger.isUpdate){   
            oldQueueDetails = System.Trigger.oldMap.get(newQueueDetails.Id);
            if (newQueueDetails.fetch_from_cti__c == true && (newQueueDetails.fetch_from_cti__c != oldQueueDetails.fetch_from_cti__c)){
                idlistActivate.add(newQueueDetails.Id);
            }           
        }
    }

    list<QueueDetails__c> queuesActivate = [select id, owner.id, owner.type, fetch_from_cti__c from QueueDetails__c where id in :idlistActivate]; 
        for(QueueDetails__c c:queuesActivate) {
            if(allActiveQueues.containsKey(c.owner.id)){
                 Trigger.newMap.get(c.Id).addError('Du må enbart ha en aktiv Saksködetaljer per kö');       
            }
            if(c.Owner.Type != 'Queue'){
                Trigger.newMap.get(c.Id).addError('Du må assigna dessa detaljer till en kö innan du aktiverar hämtning från CTI');      
            } 
        }
}