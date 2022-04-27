/*
 * Author: Rajeev Shekhar
 * Trigger to support EDI operations
*/
trigger ediTrigger on Edi_Information__c (before update, before insert, after update, after insert, after delete) {
    environment_settings__c env = environment_settings__c.getValues('ediTriggerActive');
    if ((env != null && env.value__c == 'true') || Test.isRunningTest()) {
        ediTriggerHelper.action(trigger.new,trigger.old,trigger.oldMap,trigger.newMap,trigger.operationType);
    }   
}