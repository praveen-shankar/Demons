/*
    Trigger to handle duplicate Cross references from CDH
    Author: Rajeev Shekhar
    Project: Customer Conversion CR
    Date started: 19.04.2017
    Last Modified: 31.10.2017
*/
trigger crm_crossReferencesTrigger on crm_Account_Cross_Reference__c (before insert,after insert) {
    crm_crossReferencesTriggerHelper.process(trigger.new,trigger.operationType); 
    if(Trigger.IsAfter && Trigger.isInsert) 
          crm_crossReferencesTriggerHelper.sendemailsforconverted(trigger.new);    
}