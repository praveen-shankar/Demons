trigger QueueDetailsValidateOwner on QueueDetails__c (before insert) {
    List<ID> idlist = new List<ID>();
    QueueDetails__c oldQueueDetails = null;
    Map<Id,Id> allqueues = new Map <Id,Id>();
    
    for(integer i=0; i<trigger.new.size(); i++ ) {  
        if(Trigger.isInsert && Trigger.new[i].fetch_from_cti__c == true){
               Trigger.new[i].addError('Du må assigna Sakskødetaljene til en sakskø før du kan aktivere henting til CTI');
        }
    }
}