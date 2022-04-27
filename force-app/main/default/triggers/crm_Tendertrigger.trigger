trigger crm_Tendertrigger on crm_Tender__c (before update, after insert) {
if(Trigger.isupdate && trigger.isBefore) {
    crm_tendertriggerHelper.calculatevalues (Trigger.new, Trigger.oldMap);
 
}


if(Trigger.isinsert && trigger.isAfter) {

    crm_tendertriggerHelper.sharerecord(Trigger.new);

}




}