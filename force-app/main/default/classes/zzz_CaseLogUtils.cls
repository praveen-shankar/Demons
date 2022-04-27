/**

 */
@isTest
private class zzz_CaseLogUtils {


    static  Id defaultHoursId = KATSutilities.getDefaultBusinessHours();  
    static QueueSobject socialQueue =[Select QueueId from QueueSobject where Queue.Name='Privat Sosiale kanaler' and SobjectType='Case' limit 1];
   
            
//static  QueueSobject socialQueue ;
    static testMethod void tesLogNewQueueEvent(){

    
        List<Case> caseList=new List<Case>();
         for(integer i=0;i<1;i++){
            Case c=new Case(OwnerID=socialQueue.QueueId, status='Ny');
            caseList.add(c);
         }       
        test.startTest();
        CaseLogUtils.LogNewQueueEvent(caseList);    
        test.stopTest();
        List<CaseLog__c> insertedLogs=[select id, case__c, queue_name__c from CaseLog__c where case__c in :caseList and fieldname__c='Tid i Kø'];       
        System.assertEquals(insertedLogs.size(), 1);
        System.assertEquals(insertedLogs.get(0).queue_name__c, 'Privat Sosiale kanaler');
        
    }
    
    static testMethod void testUpdateLogNewQueueEvent(){

         List<CaseLog__c> logList=new List<CaseLog__c>();
         List<Case> cases=new List<Case>();
         for(integer i=0;i<10;i++){
            Case c=new Case(BusinessHoursId=defaultHoursId);
            cases.add(c);
         }
         
        insert cases;
        
        for(Case c:cases){
            CaseLog__c newLogEntry=new CaseLog__c(Business_Hours__c=c.BusinessHoursId, case__c=c.id,fieldname__c='Tid i Kø', stop_time__c=null );
            logList.add(newLogEntry);
        }
        
        insert logList;
    
        CaseLogUtils.UpdateNewQueueEvent(cases);
        List<CaseLog__c> upsertedLogs=[select id, business_hours__c, time_hours__c, case__c, stop_time__c from CaseLog__c where case__c in :cases];
        
        System.assertEquals(upsertedLogs.size(), cases.size());
        System.assert(upsertedLogs.get(0).stop_time__c!=null);
        System.assert(upsertedLogs.get(0).time_hours__c!=null);
    }
    
    
    
    
        static testMethod void tesLogNewUnreadActionEvent(){

        List<Case> caseList=new List<Case>();
         for(integer i=0;i<10;i++){
            Case c=new Case(unread_action__c=true);
            caseList.add(c);
         }       
         CaseLogUtils.LogNewUnreadActionEvent(caseList);    
        List<CaseLog__c> insertedLogs=[select id, case__c from CaseLog__c where case__c in :caseList];      
        System.assertEquals(insertedLogs.size(), 10);
    }
    
    static testMethod void testUpdateLogUnreadActionEvent(){

         List<CaseLog__c> logList=new List<CaseLog__c>();
         List<Case> cases=new List<Case>();
         for(integer i=0;i<10;i++){
            Case c=new Case(unread_action__c=false,  BusinessHoursId=defaultHoursId);
            cases.add(c);
         }
         
        insert cases;
        
        for(Case c:cases){
            CaseLog__c newLogEntry=new CaseLog__c(Business_Hours__c=c.BusinessHoursId, case__c=c.id,fieldname__c='Ulest Epost', stop_time__c=null );
            logList.add(newLogEntry);
        }
        
        insert logList;
    
        CaseLogUtils.UpdateLogUnreadActionEvent(cases);
        
        List<CaseLog__c> upsertedLogs=[select id, business_hours__c, time_hours__c, case__c, stop_time__c from CaseLog__c where case__c in :cases];
        
        System.assertEquals(upsertedLogs.size(), cases.size());
        System.assert(upsertedLogs.get(0).stop_time__c!=null);
        System.assert(upsertedLogs.get(0).time_hours__c!=null);
    }
    
    static testMethod void tesLogNewWaitingForUnitEvent(){

        PostalUnit__c myUnit=new PostalUnit__c(unit_number__c='enhet 0001', DRM_id__c='0001', unit_number_in_subsidiary__c='enh..001');
        insert myUnit;
        List<Case> caseList=new List<Case>();
         for(integer i=0;i<10;i++){
            Case c=new Case(status='Avventer annen enhet', Waiting_for_unit__c=myUnit.id, date_to_be_resumed__c=system.now()+10);
            caseList.add(c);
         }
         
         CaseLogUtils.LogNewWaitingForUnitEvent(caseList);
        
        List<CaseLog__c> insertedLogs=[select Business_hours__c, id, case__c from CaseLog__c where case__c in :caseList];
        
        System.assertEquals(insertedLogs.size(), caseList.size());
        System.assert(insertedLogs.get(0)!=null);
    }
    
    static testMethod void testUpdateLogDoneWaitingForUnit(){

         List<CaseLog__c> logList=new List<CaseLog__c>();
         List<Case> cases=new List<Case>();
         for(integer i=0;i<10;i++){
            Case c=new Case(status='Under behandling', BusinessHoursId=defaultHoursId);
            cases.add(c);
         }
         
         insert cases;
        
        for(Case c:cases){
            CaseLog__c newLogEntry=new CaseLog__c(Business_Hours__c=c.BusinessHoursId, case__c=c.id, postal_unit__c=c.Waiting_for_unit__c, fieldname__c='Postal Enhet', stop_time__c=null );
            logList.add(newLogEntry);
        }
        
        insert logList;
    
        CaseLogUtils.UpdateLogDoneWaitingForUnit(cases);
        
        List<CaseLog__c> upsertedLogs=[select id, time_hours__c, case__c, stop_time__c from CaseLog__c where case__c in :cases];
        
        System.assertEquals(upsertedLogs.size(), cases.size());
        System.assert(upsertedLogs.get(0).stop_time__c!=null);
        System.assert(upsertedLogs.get(0).time_hours__c!=null);
    }

    
    static testMethod void testWaitingForUnit(){

        List<Case> newCaseList=new List<Case>();
        Map<Id, Case> oldCaseMap = new Map<Id, Case>();
        
        PostalUnit__c myUnit=new PostalUnit__c(unit_number__c='enhet 0001', DRM_id__c='0001', unit_number_in_subsidiary__c='enh..001');
        insert myUnit;     
        
        Case oldCase = new Case(status='Avventer annen enhet', Waiting_for_unit__c=myUnit.id, date_to_be_resumed__c=system.now()+10);
        insert oldCase;   
        Case newCase= new Case(id=oldCase.id, status='Under behandling', Waiting_for_unit__c=myUnit.id );
        
        CaseLog__c newLogEntry=new CaseLog__c(Business_Hours__c=defaultHoursId, case__c=oldCase.id, postal_unit__c=oldCase.Waiting_for_unit__c, fieldname__c='Postal Enhet', stop_time__c=null );
        insert newLogEntry;
           
        oldCaseMap.put(oldCase.id, oldCase);
        NewCaseList.add(newCase);
        
        test.startTest();
            CaseLogUtils.LogEventPostalUnit(newCaseList, oldCaseMap);
        test.stopTest();

       List<CaseLog__c> log=[select id, postal_unit__c, case__c, fieldname__c, stop_time__c from CaseLog__c where case__c=:newCase.id];
        
       System.assertEquals(log.get(0).postal_unit__c, myUnit.id);
       System.assertEquals(log.get(0).fieldname__c, 'Postal Enhet');
       //System.assert(log.get(0).stop_time__c!=null);
    }
    
    
      static testMethod void testUnreadAction(){

        // Test opprettelse av log ved ulest action. Om en sak blir oppdatert med unread action så skal det opprettes en log med 'Ulest Epost'
        List<Case> newCaseList=new List<Case>();
        Map<Id, Case> oldCaseMap = new Map<Id, Case>();
            
        Case oldCase = new Case(unread_action__c=false, status='Avventer kunde', BusinessHoursId=defaultHoursId);
        Case newCase = new Case(unread_action__c=true, status='Under behandling');
        
        oldCaseMap.put(null,oldCase);
        NewCaseList.add(newCase);
        test.startTest();
            CaseLogUtils.LogEventUnreadEmail(newCaseList, oldCaseMap);
        test.stopTest();
 
       List<CaseLog__c> log=[select id, case__c, fieldname__c, stop_time__c from CaseLog__c where fieldname__c='Ulest Epost'];
       System.assertEquals(log.get(0).fieldname__c, 'Ulest Epost');
      }
      
    static testMethod void testChangeOwner(){

        List<Case> newCaseList=new List<Case>();
        
        Case newCase = new Case(OwnerId=socialQueue.QueueId ,status='Ny', BusinessHoursId=defaultHoursId);
        NewCaseList.add(newCase);
       
        CaseLogUtils.LogQueue(newCaseList);
        
        // Select from CaseLog
       List<CaseLog__c> log=[select id, case__c, fieldname__c, stop_time__c, queue_name__c from CaseLog__c];
       System.assert(log.size()>0);
       System.assertEquals(log.get(0).fieldname__c, 'Tid i Kø');
        System.assertEquals(log.get(0).queue_name__c, 'Privat Sosiale kanaler');
    }
    
    static testMethod void testInsertCaseWithNull(){

        List<Case> newCaseList=new List<Case>();
        newCaseList.add(new Case());
        test.startTest();
            CaseLogUtils.LogEventUnreadEmail(newCaseList, null);
            CaseLogUtils.LogEventPostalUnit(newCaseList, null);
        test.stopTest();
    }
    
    
    static testmethod void test() {

        Datetime stopTime=System.now()-(7*52+1);
        List<CaseLog__c> logs=new List<CaseLog__c>();
        for(integer i=0;i<1;i++){
            logs.add( new CaseLog__c(fieldname__c='TEST SCHEDULER', stop_time__c=stopTime ));
        }
        insert logs;
    String jobName='CaseLog_schedulesDeleteLogs';
     System.assertEquals(0, [SELECT COUNT()
                                FROM AsyncApexJob
                                WHERE ApexClassId IN (SELECT Id FROM ApexClass WHERE NamespacePrefix = null AND Name =:jobName)]);
       
    
    Test.startTest();
       CaseLog_schedulesDeleteLogs.startDeleteLogsScheduler();
    Test.stopTest();
     
    System.assertEquals(1, [SELECT COUNT() FROM AsyncApexJob WHERE ApexClassId IN (SELECT Id FROM ApexClass WHERE NamespacePrefix = null AND Name =:jobName)]);
       
    
   }
   
   static testMethod void testIsQueue(){
    
    Case newCase = new Case(OwnerId=socialQueue.QueueId ,status='Ny', BusinessHoursId=defaultHoursId);
    insert newCase;   
    newCase=[SELECT OwnerID from case];
    System.assert(CaseLogUtils.isQueue(newCase.ownerId));
    
   }
}