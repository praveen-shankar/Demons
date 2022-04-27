trigger crm_tenderteamroletrigger on crm_Tender_Team_Role__c (after insert) {
if(Trigger.isinsert && trigger.isAfter) {
    crm_tenderteamroletriggerHelper.sharerecord(Trigger.new);

    
    
    }
    
 }