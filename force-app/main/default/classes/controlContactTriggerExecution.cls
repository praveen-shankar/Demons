public class controlContactTriggerExecution {
    
    public static void deactivateContactTrigger() {
        System.debug('DEACTIVATING_CONTACT_TRIGGER_NOW');
        ContactTriggerSetting__c[] customsetting = [SELECT Name, Id, Contact_Trigger_Status__c FROM ContactTriggerSetting__c WHere Name = 'Contact' Limit 1 For Update];
        if(customsetting.size() > 0) {
            if(customsetting[0].Contact_Trigger_Status__c) {
                customsetting[0].Contact_Trigger_Status__c = false;
                update customsetting;
                System.debug('DEACTIVATION_CONTACT_TRIGGER_DONE');
            }
        }
    }
    
    public static void activateContactTrigger() {
        System.debug('ACTIVATING_CONTACT_TRIGGER_NOW');
        ContactTriggerSetting__c[] customsetting = [SELECT Name, Id, Contact_Trigger_Status__c FROM ContactTriggerSetting__c WHere Name = 'Contact' Limit 1 For Update];
        if(customsetting.size() > 0) {
            if(!customsetting[0].Contact_Trigger_Status__c) {
                customsetting[0].Contact_Trigger_Status__c = true;
                update customsetting;
                System.debug('ACTIVATION_CONTACT_TRIGGER_DONE');
            }
        }
    }
}