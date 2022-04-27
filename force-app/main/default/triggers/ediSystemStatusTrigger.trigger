/*
 * Author: Rajeev Shekhar
 * Trigger to support EDI operations
*/
trigger ediSystemStatusTrigger on EDI_System_Status__c (before insert, after insert, before update, after update, before delete, after delete) {
    environment_settings__c env = environment_settings__c.getValues('ediSystemStatusTriggerActive');
    if ((env != null && env.value__c == 'true') || Test.isRunningTest()) {
        if(trigger.IsDelete && trigger.IsBefore){
            for(EDI_System_Status__c e : trigger.old) {
                if(e.Message_Sent__c || e.Manual_Integration_Confirmation__c) {
                    e.addError(System.Label.edi_cannotDeleteSystemStaus);
                }
            }
        }
        if((trigger.IsBefore && trigger.IsInsert) || (trigger.IsBefore && trigger.IsUpdate)){
            Set<Id> ediIds = new Set<Id>();
            for(EDI_System_Status__c e : trigger.new) {
                ediIds.add(e.EDI__c);
            }
            Map<Id,Edi_Information__c> ediMap = new Map<Id,Edi_Information__c>([SELECT Id,Status__c FROM Edi_Information__c WHERE Id In :ediIds]);
            for(EDI_System_Status__c e : trigger.new) {
                //if(trigger.IsInsert) e.EDI_Id__c = String.valueOf(e.EDI__c).substring(0,15);
                if(trigger.IsInsert) e.EDI_Id__c = e.EDI__c;//Field to store EDI Id to detect Duplicates and fire duplicate rule    
                    if((trigger.IsInsert && e.Manual_Integration_Confirmation__c) || 
                        (trigger.IsUpdate && e.Manual_Integration_Confirmation__c && !trigger.oldMap.get(e.Id).Manual_Integration_Confirmation__c)) {
                            if(!e.Message_Sent__c) e.Message_Sent__c = true;
                            if((ediMap.get(e.EDI__c).Status__c != 'PhaseOut') && !e.Message_Sent_After_Data_Change__c) e.Message_Sent_After_Data_Change__c = true;
                            e.Manual_Integration_Confirmation_Datetime__c = System.now();
                            e.Summary__c = 'Manual Integration Completed';
                            e.Status__c = 'SUCCESS';
                            e.Error_Message__c = null;
                            e.Timestamp__c = null;
                            e.Transaction_ID__c = 'MANUAL';
                            e.StatusCode__c = 'MANUAL';
                            e.Details__c = 'Manual Integration Completed';
                } 
                  
                        else if(trigger.IsUpdate && !e.Message_Sent_After_Data_Change__c && trigger.oldMap.get(e.Id).Message_Sent_After_Data_Change__c) {
                            e.Manual_Integration_Confirmation_Datetime__c = null;
                            e.Summary__c = null;
                            e.Status__c = null;
                            e.Error_Message__c = null;
                            e.Timestamp__c = null;
                            e.Transaction_ID__c = null;
                            e.StatusCode__c = null;
                            e.Details__c = null;
                        } 
                      
                       
                        else if(trigger.IsUpdate && e.Negative_Manual_Integration_Confirmation__c && !trigger.oldMap.get(e.Id).Negative_Manual_Integration_Confirmation__c) {
                            e.Manual_Integration_Confirmation_Datetime__c = System.now();
                            e.Summary__c = 'Negative Manual Integration Completed';
                            e.Status__c = 'SUCCESS';
                            e.Error_Message__c = null;
                            e.Timestamp__c = null;
                            e.Transaction_ID__c = 'MANUAL';
                            e.StatusCode__c = 'MANUAL';
                            e.Details__c = 'Negative Manual Integration Completed';
                        }  
            }
        }
        if(trigger.IsUpdate && trigger.IsAfter) {
            List<EDI_System_Status__c> records = new List<EDI_System_Status__c>();
            for(EDI_System_Status__c e : trigger.new) {
                EDI_System_Status__c oldrec = trigger.oldMap.get(e.Id);
                if((e.Manual_Integration_Confirmation__c != oldrec.Manual_Integration_Confirmation__c) || (e.Message_Sent__c != oldrec.Message_Sent__c) ||
                    (e.Message_Sent_After_Data_Change__c != oldrec.Message_Sent_After_Data_Change__c))
                    records.add(e);    
            }
            ediTriggerHelper.generateNotifications(records);
        }
        if(trigger.IsDelete && trigger.IsAfter) {
            ediTriggerHelper.generateNotifications(trigger.old);
        }
        if(trigger.IsInsert && trigger.IsAfter) {
            ediTriggerHelper.generateNotifications(trigger.new); 
        }        
    }
}