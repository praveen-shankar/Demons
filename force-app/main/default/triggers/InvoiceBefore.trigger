trigger InvoiceBefore on Invoice__c (after insert, after update) {
	
	List<ID> idList = new List<ID>();

	for(Invoice__c i : trigger.new) {
		if(System.Trigger.oldMap != null) {
			Invoice__c beforeUpdate = System.Trigger.oldMap.get(i.Id);
			if(i.exclude_reminder__c != beforeUpdate.exclude_reminder__c){
			idList.add(i.id); //Add uppdated invoices
			}
		}
		else if(i.exclude_reminder__c){
			idList.add(i.id); //Add new invoices id exclude_reminder__c is true
		}
		
	}

	if(!system.isFuture()) InvoiceUtil.sendUpdateNote(idList);
}