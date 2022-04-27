/**
This class contains methods that create and update log records on the CaseLog object. 
*/

public with sharing class CaseLogUtils {

public static boolean firstRunPostalUnit=true; // code should only run once
public static boolean firstRunUnreadAction=true; // code should only run once

static  Id defaultHoursId = KATSutilities.getDefaultBusinessHours();
private static Boolean isEnabled; // Logging can be enabled and disabled. Controlled by custom setting

/* Postal Units */ 
private static List<Case> newUnitsToLog=new List<Case>();
private static List<Case> caseUnitsToUpdate=new List<Case>();

/* Email */
private static List<Case> newEmailsToLog=new List<Case>();
private static List<Case> caseEmailsToUpdate=new List<Case>();

/** Log waiting for unit */
public static void LogEventPostalUnit(List<Case> caseNewList, Map<id,case> oldCaseMap){
        CaseLogUtils.setIsEnabled();
        if(isEnabled && firstRunPostalUnit){
            for(Case c : caseNewList){      
                Case oldCase=((oldCaseMap==null)? null: oldCaseMap.get(c.id));
                //supriya 26012017
                if(oldCase!=null && c.status.equals('Avventer annen enhet') && c.Waiting_for_unit__c!=null && (oldCase.waiting_for_unit__c!= c.Waiting_for_unit__c||c.status!=oldCase.status) ){
              // if(oldCase!=null && c.status.equals('Pending other unit') && c.Waiting_for_unit__c!=null && (oldCase.waiting_for_unit__c!= c.Waiting_for_unit__c||c.status!=oldCase.status) ){
                    newUnitsToLog.add(c);
                     firstRunPostalUnit=false;
                }
                else if(oldCase!=null ){
                    if(oldCase.status!=null && oldCase.status.equals('Avventer annen enhet') && c.status!=oldCase.status){
                   // if(oldCase.status!=null && oldCase.status.equals('Pending other unit') && c.status!=oldCase.status){
                        caseUnitsToUpdate.add(c);
                        firstRunPostalUnit=false;
                    }
                 }                      
            }       
            if(newUnitsToLog.size()>0){
                CaseLogUtils.LogNewWaitingForUnitEvent(newUnitsToLog);
                newUnitsToLog.clear();
            }
            
            if(caseUnitsToUpdate.size()>0){
                CaseLogUtils.UpdateLogDoneWaitingForUnit(caseUnitsToUpdate);
                caseUnitsToUpdate.clear();
            }
            
        }       
    }
    
    public static void LogEventUnreadEmail(List<Case> caseNewList, Map<id,case> oldCaseMap){
        CaseLogUtils.setIsEnabled();
        if(isEnabled && firstRunUnreadAction){
            for(Case c : caseNewList){              
                Case oldCase=((oldCaseMap==null)? null: oldCaseMap.get(c.id));
                
                /* Log and update unread action */
            
                if((oldCase==null && c.unread_action__c==true) || (oldCase!=null && oldCase.unread_action__c==false && c.unread_action__c==true)){
                    system.debug('## Creating log on case: ' + c);
                    newEmailsToLog.add(c);
                    firstRunUnreadAction=false;
                } else if(oldCase!=null && oldCase.unread_action__c==true && c.unread_action__c==false){
                    caseEmailsToUpdate.add(c);
                    firstRunUnreadAction=false;
                }           
            }           
            if(newEmailsToLog.size()>0){
                CaseLogUtils.LogNewUnreadActionEvent(newEmailsToLog);
                newEmailsToLog.clear();
            }
            if(caseEmailsToUpdate.size()>0){
                CaseLogUtils.UpdateLogUnreadActionEvent(caseEmailsToUpdate);
                caseEmailsToUpdate.clear();
            }           
            }
    }
    
    
    
    public static void LogQueue(List<Case> cases){
        Map<ID,Group> queueNames = new Map<Id,Group>([Select Id, Name from Group where Type = 'Queue']);    
        List<CaseLog__c> logList=new List<CaseLog__c>();
        
        system.debug('## update queue' +cases);
        List<CaseLog__c> updateLogEntry=[select business_Hours__c,  createddate,  id, time_hours__c,  fieldname__c, stop_time__c from CaseLog__c where case__c in :cases and stop_time__c=null and fieldname__c='Tid i Kø'];
        for(CaseLog__c log:updateLogEntry){
            log.stop_time__c=System.now();
            log.time_hours__c=CaseLogUtils.getTimeInBusinessHours(log);
        }
        upsert updateLogEntry;
        
        for(Case c:cases){  
        // Called in caseAfter. These cases have allready been checked that the owner has changed. Only check if new owner is queue
         if(CaseLogUtils.isQueue(c.ownerId)){ 
            ID hoursId=((c.BusinessHoursId!=null) ? c.BusinessHoursId : defaultHoursId);
            String queueLabel=queueNames.get(c.ownerId).Name;
            CaseLog__c newLogEntry=new CaseLog__c(queue_name__c=queueLabel, Business_Hours__c=hoursId, case__c=c.id, fieldname__c='Tid i Kø', stop_time__c=null );
            logList.add(newLogEntry);
         }
        }
         insert logList;
        
        system.debug('## 10');
         
    }
    
    public static void LogNewQueueEvent(List<Case> cases){
        System.debug(cases);
        // Get queueNames
        
        Map<ID,Group> queueNames = new Map<Id,Group>([Select Id, Name from Group where Type = 'Queue']);
        
        List<CaseLog__c> logList=new List<CaseLog__c>();
        for(Case c:cases){
            ID hoursId=((c.BusinessHoursId!=null) ? c.BusinessHoursId : defaultHoursId);
            String queueLabel=queueNames.get(c.ownerId).Name;
            CaseLog__c newLogEntry=new CaseLog__c(queue_name__c=queueLabel, Business_Hours__c=hoursId, case__c=c.id, fieldname__c='Tid i Kø', stop_time__c=null );
            logList.add(newLogEntry);
        }
        insert logList;
    }
    
    public static void UpdateNewQueueEvent(List<Case> cases){
        system.debug('## update queue' +cases);
        List<CaseLog__c> newLogEntry=[select business_Hours__c,  createddate,  id, time_hours__c,  fieldname__c, stop_time__c from CaseLog__c where case__c in :cases and stop_time__c=null and fieldname__c='Tid i Kø'];
        for(CaseLog__c log:newLogEntry){
            log.stop_time__c=System.now();
            log.time_hours__c=CaseLogUtils.getTimeInBusinessHours(log);
        }
        upsert newLogEntry;
    }
    
    public static void LogNewUnreadActionEvent(List<Case> cases){
        
        List<CaseLog__c> logList=new List<CaseLog__c>();
        for(Case c:cases){
            ID hoursId=((c.BusinessHoursId!=null) ? c.BusinessHoursId : defaultHoursId);
            CaseLog__c newLogEntry=new CaseLog__c(Business_Hours__c=hoursId, case__c=c.id, fieldname__c='Ulest Epost', stop_time__c=null );
            logList.add(newLogEntry);
        }
        insert logList; 
    }
    
    public static void UpdateLogUnreadActionEvent(List<Case> cases){
        List<CaseLog__c> newLogEntry=[select business_Hours__c,  createddate,  id, time_hours__c,  fieldname__c, stop_time__c from CaseLog__c where case__c in :cases and stop_time__c=null and fieldname__c='Ulest Epost'];
        for(CaseLog__c log:newLogEntry){
            log.stop_time__c=System.now();
            log.time_hours__c=CaseLogUtils.getTimeInBusinessHours(log);
        }
        upsert newLogEntry;
    }
    
    public static void LogNewWaitingForUnitEvent(List<Case> cases){
        List<CaseLog__c> logList=new List<CaseLog__c>();
        for(Case c:cases){
            ID hoursId=((c.BusinessHoursId!=null) ? c.BusinessHoursId : defaultHoursId);
            CaseLog__c newLogEntry=new CaseLog__c(Business_Hours__c=hoursId, case__c=c.id, postal_unit__c=c.Waiting_for_unit__c, fieldname__c='Postal Enhet', stop_time__c=null );
            logList.add(newLogEntry);
        }
        insert logList;     
    }
    
    public static void UpdateLogDoneWaitingForUnit(List<Case> cases){
        List<CaseLog__c> newLogEntry=[select business_Hours__c,  createddate,  id, time_hours__c, postal_unit__c,  fieldname__c, stop_time__c from CaseLog__c where case__c in :cases and stop_time__c=null and fieldname__c='Postal Enhet' ];
        for(CaseLog__c log:newLogEntry){
            log.stop_time__c=System.now();
            log.time_hours__c=CaseLogUtils.getTimeInBusinessHours(log);
        }
        upsert newLogEntry;
    }
    
    public static Decimal getTimeInBusinessHours(CaseLog__c log){   
        //The diff method comes back in milliseconds, so we divide by 3600000 to get hours.
        Double timeInHours = BusinessHours.diff(log.Business_Hours__c, log.createddate, System.now())/3600000.0;
        return timeInHours;
    }
    
    public static void cleanUp(List<CaseLog__c> logs){
        delete logs;     
    }
    
    private static void setIsEnabled(){
        if(Test.isRunningTest()){
            isEnabled =  true;
        }
        else if(LogSettings__c.getInstance('Default')==null) {
            isEnabled =false;
        }
        else {
            isEnabled =LogSettings__c.getInstance('Default').Enabled__c;
        }
    }
    
    public static boolean isQueue(ID caseId){
        return ((String)caseId).startsWith('00G');
    }
}