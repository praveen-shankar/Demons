trigger PIBmessagetrigger on cs_case_pib_messages__c (before insert,before update) {
for (cs_case_pib_messages__c pib : Trigger.new) {
        pib.District_Manager_Email__c = pib.email_District_Manager__c;
    }  
}