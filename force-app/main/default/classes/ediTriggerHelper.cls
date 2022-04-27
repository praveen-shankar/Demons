/*
 * Author: Rajeev Shekhar
 * Helper class to support EDI operations
*/

public with sharing class ediTriggerHelper {
    
    public static void action(Edi_Information__c[] edis,Edi_Information__c[] oldedis,Map<Id,Edi_Information__c> oldMap,Map<Id,Edi_Information__c> newMap,System.TriggerOperation triggerEvent){
        switch on triggerEvent {
            when AFTER_INSERT {
                countAndUpdateCustomers(edis,true);
            }
            when BEFORE_UPDATE {
                Set<Id> Ids = new Set<Id>();
                Set<Id> ediChangedIds = new Set<Id>();
                Set<Id> qualificatorChangedIds = new Set<Id>();                
                EDI_System_Status__c[] syssnew = new List<EDI_System_Status__c>();
                rollUpToPartyAndImportAction(edis);
                validateLMFields(newMap);
                validateMBFields(newMap);
                for(Edi_Information__c e : edis) {
                    Edi_Information__c oldedi = oldMap.get(e.Id);
                    if((e.Status__c == 'Terminated' || e.Status__c == 'PhaseOut') && (oldMap.get(e.Id).Status__c != e.Status__c)) {
                        e.Active__c = false;
                        //if(e.End_Date__c == null) e.End_Date__c = Date.today();
                    }    
                    else if((e.Status__c != 'Terminated' || e.Status__c != 'PhaseOut') && (oldMap.get(e.Id).Status__c != e.Status__c)){
                        e.Active__c = true;
                    }            
                    if((e.File_Transfer__c != oldedi.File_Transfer__c) || (e.File_Transfer_Detail__c != oldedi.File_Transfer_Detail__c) ||
                        (e.ID_Domain__c != oldedi.ID_Domain__c) || (e.ID_Format__c != oldedi.ID_Format__c) || (e.ID_Subscriber__c != oldedi.ID_Subscriber__c) || (e.Inbound_Message_Type__c != oldedi.Inbound_Message_Type__c) || 
                        (e.Integration_Type__c != oldedi.Integration_Type__c) || (e.Message_Format__c != oldedi.Message_Format__c) || (e.My_Bring_ID__c != oldedi.My_Bring_ID__c) ||
                        (e.Outbound_Message_Type__c != oldedi.Outbound_Message_Type__c) || (e.TA_Vendor__c != oldedi.TA_Vendor__c) ||
                        (e.Status__c == 'PhaseOut' && (oldedi.Status__c == 'Production' || oldedi.Status__c == 'Testing' || oldedi.Status__c == 'OnHold'))) {
                        Ids.add(e.Id);
                    }
                    if(e.EDI_Identificator__c != oldMap.get(e.Id).EDI_Identificator__c) {
                        ediChangedIds.add(e.Id);
                    }
                    if(e.Kvalificator__c != oldMap.get(e.Id).Kvalificator__c) {
                        qualificatorChangedIds.add(e.Id);
                    }
                    if((e.Status__c == 'PhaseOut' || e.Status__c == 'Terminated') && (oldMap.get(e.Id).Status__c == 'New'))
                        e.Disqualified_for_Integration__c = true;
                    if(e.Status__c == 'Terminated' && oldMap.get(e.Id).Status__c == 'PhaseOut' && !e.Disqualified_for_Integration__c)
                        Ids.remove(e.Id);                       
                }
                //If EDI Ident is changing after the EDI record was sent to production systems, throw an error
                for(EDI_System_Status__c c : [SELECT Id,EDI__c,EDI__r.Status__c,Message_Sent__c FROM EDI_System_Status__c WHERE EDI__c IN :ediChangedIds]) {
                    if(c.Message_Sent__c) {
                        newMap.get(c.EDI__c).EDI_Identificator__c.addError(System.Label.edi_IdentChangeNotAllowed);
                    }            
                }
                for(EDI_System_Status__c c : [SELECT Id,EDI__c,EDI__r.Status__c,Message_Sent__c FROM EDI_System_Status__c WHERE EDI__c IN :qualificatorChangedIds]) {
                    if(c.Message_Sent__c) {    
                        newMap.get(c.EDI__c).Kvalificator__c.addError(System.Label.edi_qualificatorChangeNotAllowed);
                    }            
                }                
                for(EDI_System_Status__c c : [SELECT Message_Sent_After_Data_Change__c,Manual_Integration_Confirmation__c,Manual_Integration_Confirmation_Datetime__c FROM EDI_System_Status__c WHERE EDI__c IN :Ids]) {
                    if(c.Message_Sent_After_Data_Change__c) c.Message_Sent_After_Data_Change__c = false;
                    if(c.Manual_Integration_Confirmation__c) c.Manual_Integration_Confirmation__c = false;
                    if(c.Manual_Integration_Confirmation_Datetime__c != null) c.Manual_Integration_Confirmation_Datetime__c = null;
                    syssnew.add(c);
                }
                if(syssnew.size() > 0) {
                    try{
                        update syssnew;
                    }Catch(Exception e){
                        System.debug('Exception: '+ e);
                    }
                
                }
            }
            when BEFORE_INSERT {
                rollUpToPartyAndImportAction(edis);     
            }
            when AFTER_DELETE {
                countAndUpdateCustomers(oldedis,false);     
            }
            when AFTER_UPDATE {
                validateStatusChange(edis,newMap,oldMap);         
            }
            
        }
    }
    
    //Method to assign EDIs to the relation customer's parent
    //Method to update the RecordType to Imported for migrated data
    //Method to set Account_Id__c field used in Guplicate rules
    private static void rollUpToPartyAndImportAction(Edi_Information__c[] edis){
        Map<String,Schema.RecordTypeInfo> rtMapEDI = Edi_Information__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Set<Id> acctIds = new Set<Id>();
        Map<Id,Id> parentMap = new Map<Id,Id>();
        for(Edi_Information__c edi : edis) {
            if(edi.crm_Account__c != null) {
                acctIds.add(edi.crm_Account__c);
                edi.Account_Id__c = String.valueOf(edi.crm_Account__c).substring(0,15);//Field used in duplicate rule
            }    
            if(edi.Imported_Data__c)
                edi.RecordTypeId = rtMapEDI.get('Imported').getRecordTypeId();                            
        }
        for(Account a : [SELECT ParentId, Id From Account WHERE Id IN :acctIds])
            parentMap.put(a.Id,a.ParentId);
        for(Edi_Information__c ed : edis) {
            if(parentMap.containsKey(ed.crm_Account__c) && parentMap.get(ed.crm_Account__c) != null)
                ed.Party__c = parentMap.get(ed.crm_Account__c);
        }   
    }   
    
    //Method to validate change of status
    private static void validateStatusChange(List<Edi_Information__c> edis,Map<Id,Edi_Information__c> newMap,Map<Id,Edi_Information__c> oldMap) {
        Set<Id> ediInProdOrPout = new Set<Id>();
        Set<Id> ediInTerminated = new Set<Id>();
        for(Edi_Information__c e : edis) {
            if(e.Status__c == 'Production' || e.Status__c == 'PhaseOut') {
                ediInProdOrPout.add(e.Id);
            }
            if(e.Status__c == 'Terminated' && oldMap.get(e.Id).Status__c == 'PhaseOut') {
                ediInTerminated.add(e.Id);
            }
        }
        
        for(EDI_System_Status__c c : [SELECT Id,EDI__c,EDI__r.Imported_Data__c,EDI__r.Disqualified_for_Integration__c,EDI__r.Status__c,EDI__r.EDI_Files_Approved__c,EDI__r.Labels_Approved__c,Message_Sent__c,Message_Sent_After_Data_Change__c 
            FROM EDI_System_Status__c WHERE EDI__c IN :ediInProdOrPout]) {
            if(!c.EDI__r.Disqualified_for_Integration__c && (!c.Message_Sent__c || !c.EDI__r.EDI_Files_Approved__c || !c.EDI__r.Labels_Approved__c)  && !c.EDI__r.Imported_Data__c) {
                newMap.get(c.EDI__c).Status__c.addError(System.Label.edi_statusToProd);
                if(!c.EDI__r.EDI_Files_Approved__c) newMap.get(c.EDI__c).EDI_Files_Approved__c.addError(String.format(System.Label.edi_statusToProd2,new String[]{c.EDI__r.Status__c}));
                if(!c.EDI__r.Labels_Approved__c) newMap.get(c.EDI__c).Labels_Approved__c.addError(String.format(System.Label.edi_statusToProd2,new String[]{c.EDI__r.Status__c}));
            }            
        }
        for(EDI_System_Status__c c : [SELECT Id,EDI__c,EDI__r.Imported_Data__c,EDI__r.Disqualified_for_Integration__c,EDI__r.Status__c,EDI__r.EDI_Files_Approved__c,EDI__r.Labels_Approved__c,Message_Sent__c,Message_Sent_After_Data_Change__c, 
            Negative_Manual_Integration_Confirmation__c FROM EDI_System_Status__c WHERE EDI__c IN :ediInTerminated]) {
            if(!c.EDI__r.Disqualified_for_Integration__c && (!c.Message_Sent_After_Data_Change__c || !c.EDI__r.EDI_Files_Approved__c || !c.EDI__r.Labels_Approved__c)  && !c.EDI__r.Imported_Data__c) {
                if(c.Negative_Manual_Integration_Confirmation__c) continue;
                newMap.get(c.EDI__c).Status__c.addError(System.Label.edi_statusToTerminated);
                if(!c.EDI__r.EDI_Files_Approved__c && !c.EDI__r.Imported_Data__c) newMap.get(c.EDI__c).EDI_Files_Approved__c.addError(String.format(System.Label.edi_statusToProd2,new String[]{c.EDI__r.Status__c}));
                if(!c.EDI__r.Labels_Approved__c && !c.EDI__r.Imported_Data__c) newMap.get(c.EDI__c).Labels_Approved__c.addError(String.format(System.Label.edi_statusToProd2,new String[]{c.EDI__r.Status__c}));
            }            
        }  
    }
    
    //Validate fields related to MB
    private static void validateMBFields(Map<Id,Edi_Information__c> newMap) {
        for(EDI_System_Status__c c : [SELECT Id,EDI__c,EDI__r.Imported_Data__c FROM EDI_System_Status__c WHERE EDI__c IN :newMap.keySet() AND System_Name__c = 'MB']) {
            if(!c.EDI__r.Imported_Data__c) {
                Edi_Information__c newrec = newMap.get(c.EDI__c);
                if(newrec.ID_Domain__c == null && newrec.ID_Format__c == null) {
                    if(newrec.ID_Domain__c == null) newMap.get(c.EDI__c).ID_Domain__c.addError(System.Label.edi_MBRequired);
                    if(newrec.ID_Format__c == null) newMap.get(c.EDI__c).ID_Format__c.addError(System.Label.edi_MBRequired);
                }
            }
        }            
    }
    
    //Validate fields related to LM
    private static void validateLMFields(Map<Id,Edi_Information__c> newMap) {
        for(EDI_System_Status__c c : [SELECT Id,EDI__c,EDI__r.Imported_Data__c FROM EDI_System_Status__c WHERE EDI__c IN :newMap.keySet() AND System_Name__c = 'LM']) {
            if(!c.EDI__r.Imported_Data__c) {
                Edi_Information__c newrec = newMap.get(c.EDI__c);
                if(newrec.Outbound_Message_Type__c == null) {
                    newMap.get(c.EDI__c).Outbound_Message_Type__c.addError(System.Label.edi_LMRequired);
                }
            }
        }            
    }
    
    //Author: Rajeev Shekhar - Method To Count Total No.of EDI Records Associated With Customers
    //Method to update EDI Customer flag on Relation level accounts
    private static void countAndUpdateCustomers(List<Edi_Information__c> ediList, Boolean isInsert) {
        Set<Id> accountIds = new Set<Id>();
        Map<Id,Integer> countMap = new Map<Id,Integer>();
        List<Account> toUpdateAcc = new List<Account>();
        List<Account> toUpdatePartyAcc = new List<Account>();
        //Capturing the account Ids
        for(Edi_Information__c e : ediList) {
            if(e.crm_Account__c != null)
                accountIds.add(e.crm_Account__c);
        }
        
        //Query the count of children for each account in the set
        AggregateResult[] groupedResults = [SELECT count(Id) c,crm_Account__c FROM Edi_Information__c WHERE crm_Account__c IN :accountIds Group By crm_Account__c];
        //Query the Account records
        List<Account> accts = [SELECT Id, Parent.crm_EDI_Customer__c, crm_EDI_Customer__c, Total_Count_of_EDI_Records__c FROM Account WHERE Id IN :accountIds];
        //Create a Map of account and the count
        for(AggregateResult ag : groupedResults)
            countMap.put((Id)ag.get('crm_Account__c'),(Integer)ag.get('c'));
        
        //Update Accounts
        for(Account a : accts) {
            if(countMap.containsKey(a.Id)) {
                a.Total_Count_of_EDI_Records__c = countMap.get(a.Id);
                toUpdateAcc.add(a);
            }
            if(countMap.size() == 0) {
                a.Total_Count_of_EDI_Records__c = 0;
                a.crm_EDI_Customer__c = false;
                toUpdateAcc.add(a);    
            }
            if(isInsert && !a.crm_EDI_Customer__c) {
                a.crm_EDI_Customer__c = true;
                if(a.Parentid !=null){
                    a.Parent.crm_EDI_Customer__c = true;
                 }   
                toUpdatePartyAcc.add(a.Parent);
            }            
        }
        if(toUpdateAcc.size() > 0) {
            try{
                update toUpdateAcc;
                update toUpdatePartyAcc;
            }Catch(Exception e) {
                System.debug('Exception occured:' + e);
            }
        }           
    }
    
    //Method to create Platform Event records, consumed by lightning component
    public static void generateNotifications(EDI_System_Status__c[] systems) {
        if(Schema.SObjectType.EDI_Event__e.isCreateable()) {
            List<EDI_Event__e> pEvents = new List<EDI_Event__e>();
            for(EDI_System_Status__c e : systems) {
                pEvents.add(new EDI_Event__e(RecordId__c=e.EDI__c));    
            }
            if(pEvents.size() > 0) {
                List<Database.SaveResult> results = EventBus.publish(pEvents);
            }
        }         
    }
}