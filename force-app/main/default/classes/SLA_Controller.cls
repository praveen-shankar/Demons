public class SLA_Controller {
    
    public static void setSolutionAndResponse(list<Case> newList) {
        Map <String, ID> workinghourslist = new Map<String, ID>();
        Map <String, ID> entitlementslist = new Map<String, ID>();
        Map<ID, Account> accountlistFull = new Map<ID, Account>();
        
        Set<String> customerDivision = new Set<String>{'A','B','C'};
        
        for (BusinessHours bh : KATSutilities.getBusinessHours().values()) {
           workinghourslist.put(bh.name, bh.id);
        }
        
        for (Entitlement ent : KATSutilities.getEntitlements().values()) {
           entitlementslist.put(ent.name, ent.id);
        }   
        
        accountlistFull = CaseController.getAccountMap();
        
        for(Case newCase : newList) {
            Account acc = accountlistFull.get(newCase.AccountId);
            if(acc != null && customerDivision.contains(acc.customer_segment__c)){
                newCase.BusinessHoursId = workinghourslist.get('Storbedrift');
                newCase.EntitlementId = entitlementslist.get('Storbedrift');
            }
        }
    }
    
    public static void CalculateBusinessHoursAges(list<Case> newCases, map<Id, Case> oldMap) {
        //Get the stop statuses
      
        Set<String> stopStatusSet = new Set<String>();
        for (Stop_Status__c stopStatus:[Select Name From Stop_Status__c]) {
            stopStatusSet.add(stopStatus.Name);
        }

        //Get the default business hours (we might need it)
        Id defaultHoursId = KATSutilities.getDefaultBusinessHours();

        //Get the closed statuses (because at the point of this trigger Case.IsClosed won't be set yet)
        Set<String> closedStatusSet = new Set<String>();
        for (CaseStatus status:KATSutilities.getCaseStatuses().values()) {
            if(status.IsClosed) {
                //closedStatusSet.add(status.MasterLabel);
                closedStatusSet.add(status.ApiName);
            }
        }
       
        //For any case where the status is changed, recalc the business hours in the buckets
        for (Case updatedCase:newCases) {
            Case oldCase = oldMap.get(updatedCase.Id);
           
            if (oldCase.Status!=updatedCase.Status && updatedCase.Last_Status_Change__c!=null) {

                if(updatedCase.Time_With_Customer__c == null)
                {
                    updatedCase.Time_With_Customer__c = 0;
                }
                if(updatedCase.Time_With_Support__c == null)
                {
                    updatedCase.Time_With_Support__c = 0;
                }
                if(updatedCase.Time_in_Avventer_Fakturaring__c == null)
                {
                    updatedCase.Time_in_Avventer_Fakturaring__c = 0;
                }
                if(updatedCase.Time_in_Avventer_i_hht_NSAB__c == null)
                {
                    updatedCase.Time_in_Avventer_i_hht_NSAB__c = 0;
                }
                if(updatedCase.Time_in_Avventer_POD__c == null)
                {
                   updatedCase.Time_in_Avventer_POD__c = 0;
                }
                
                //OK, the status has changed
                if (!oldCase.IsClosed) {
                    //We only update the buckets for open cases

                    //On the off-chance that the business hours on the case are null, use the default ones instead
                    Id hoursToUse = updatedCase.BusinessHoursId!=null?updatedCase.BusinessHoursId:defaultHoursId;

                    //The diff method comes back in milliseconds, so we divide by 3600000 to get hours.
                    Double timeSinceLastStatus = BusinessHours.diff(hoursToUse, updatedCase.Last_Status_Change__c, System.now())/3600000.0;
                  

                    //We decide which bucket to add it to based on whether it was in a stop status before
                    if (stopStatusSet.contains(oldCase.Status)) 
                    {   
                        System.debug('stopStatusSet.contains(oldCase.Status)');
                           if(oldCase.Status.equalsIgnoreCase('avventer kunde'))
                      {
                        updatedCase.Time_With_Customer__c += timeSinceLastStatus;  
                      }
                      else if(oldCase.Status.equalsIgnoreCase('avventer fakturering'))
                      {
                        updatedCase.Time_in_Avventer_Fakturaring__c += timeSinceLastStatus;
                      }
                      else if(oldCase.Status.equalsIgnoreCase('avventer i hht nsab'))
                      {
                        updatedCase.Time_in_Avventer_i_hht_NSAB__c += timeSinceLastStatus;
                      }

                      else if(oldCase.Status.equalsIgnoreCase('avventer pod'))
                        {
                           updatedCase.Time_in_Avventer_POD__c += timeSinceLastStatus; 
                        }

                        else
                        {
                            updatedCase.Time_With_Support__c += timeSinceLastStatus;    
                        }
                        
                    } 
                    else
                    {
                        
                        updatedCase.Time_With_Support__c += timeSinceLastStatus;
                    }


                    //This code will check if the new Status of the case is a Stop Status and pause the timer
                    if(stopStatusSet.contains(updatedCase.Status))
                    {
                        updatedCase.isStopped = true;
                    }
                    else
                    {
                        updatedCase.isStopped = false;
                    }


                    if (closedStatusSet.contains(updatedCase.Status))
                    {
                        updatedCase.Case_Age_In_Business_Hours__c = updatedCase.Time_With_Customer__c + updatedCase.Time_With_Support__c + updatedCase.Time_in_Avventer_Fakturaring__c + updatedCase.Time_in_Avventer_i_hht_NSAB__c+ updatedCase.Time_in_Avventer_POD__c ;
                      
                    }
                }


                updatedCase.Last_Status_Change__c = System.now();
            }
        }
    }
    
    //Go through all cases if any case is a target for notification
    public static void caseAfterUpdateEscalation(list<Case>newCases, map<Id, Case>oldMap){
        List<Case> sendEmail = new List<Case>();
        List<Case> createTask = new List<Case>();
        List<ID> queuedetailslist = new List<ID>();
        
        Case oldCase = null;
        for(Case newCase: newCases) {       
                oldCase = oldMap.get(newCase.Id);
                if(newCase.hidden_escalation_notification__c && newCase.hidden_escalation_notification__c != oldCase.hidden_escalation_notification__c){
                    queuedetailslist.add(newCase.ownerid);
                    if(newCase.hidden_owner_type__c == 'Queue'){
                        sendEmail.add(newCase);
                    }
                    if(newCase.hidden_owner_type__c == 'User'){
                        createTask.add(newCase);
                    }
                }
        }
        
        if(createTask.size() > 0) {
            SLA_Controller.createNotificationTask(createTask);
        }
        
        if(sendEmail.size() > 0) {
            SLA_Controller.createNotificationEmail(sendEmail);
        }
    }
    
    private static void createNotificationEmail(list<Case> cases) {
        Map <Id,String> queueAndOwner = new Map<Id,String>();
        for(QueueDetails__c qdowner: KATSutilities.getQueueDetails().values()){
            queueAndOwner.put(qdowner.ownerid, qdowner.queue_owner__r.email);
        }
        for(Case notifyOwner : cases){
            String email = queueAndOwner.get(notifyOwner.Ownerid);
            if(email != null && email != ''){
                System.debug(email);
                String[] toaddress = new String[]{};
                toaddress.add(email);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(toaddress);
                    mail.setsubject(System.Label.cs_Messagefromthequeue);
                    mail.setPlainTextBody(System.Label.cs_Case+': ' + notifyOwner.CaseNumber +System.Label.cs_inQueue);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
    
    private static void createNotificationTask(list<Case> cases) {
        List<Task> upsertTasks = new List<Task>();
        for(Case notifyOwner : cases){
            Task notifytask = new Task(
                WhatId = notifyOwner.Id,
                OwnerId = notifyOwner.OwnerId,
                Priority = 'High',
                IsReminderSet = true,
                ReminderDateTime = system.now(),
                ActivityDate = date.newInstance(system.now().year(),
                                                system.now().month(),
                                                system.now().day()),                              
                Type = 'Notification reminder',
                Status = 'Not Started',
                Subject = 'Notification reminder');
                        
            upsertTasks.add(notifytask);
        }
        
        if(upsertTasks.size() > 0){
            upsert(upsertTasks);
        }
    }
    
    public static void CaseBeforeInsertSetSolutionAndResponseSLA(list<Case> newCases) {
        Map <String, ID> workinghourslist = new Map<String, ID>();
        Map <String, ID> entitlementslist = new Map<String, ID>();
        Map<ID, Account> accountMap = new Map<ID, Account>();
        Set<String> storkundesegment = new Set<String>{'A','B','C'};
        
        for (BusinessHours bh : KATSutilities.getBusinessHours().values()) {
           workinghourslist.put(bh.name, bh.id);
        }
        for (Entitlement ent : KATSutilities.getEntitlements().values()) {
           entitlementslist.put(ent.name, ent.id);
        }
        
        for (Case newCase : newCases){
            Account tempA = accountMap.get(newCase.AccountId);
            if(tempA != null && storkundesegment.contains(tempA.customer_segment__c)){
                newCase.BusinessHoursId = workinghourslist.get('Storbedrift');
                newCase.EntitlementId = entitlementslist.get('Storbedrift');
            }
        }
    }
    
    public static void CaseAfterInsertFollowUpTaskMaintainer(list<Case> newCaseList) {
        list<Case> createTask = new list<Case>();
        for (Case newCase : newCaseList) {   
            if(newCase.date_to_be_resumed__c != null) {
                createTask.add(newCase);
                System.debug('create task' + newCase.id);
            }
        }
        if(createTask.size()>0) {
            SLA_Controller.createFollowUpTask(createTask);
        }
    }
    
    public static void CaseAfterUpdateFollowUpTaskMaintainer(list<Case> newCases, map<Id, Case>oldMap) {
        list<Case> updateTask = new list<Case>(); 
        list<Case> createTask = new list<Case>();
        list<Case> deleteTask = new list<Case>();
        list<Case> caseToUpdate = new list<Case>();
        list<Task> newTaskList = new list<Task>();
        list<String> doesTaskExist = new list<String>();
        
        map<Id, Task> newTaskMap = new map<Id,Task>();
        map<String, Task> doesTaskExistMap = new map<String, Task>();
        map<Id, Case> caseToUpdateMap = new map<Id, Case>();
        
        for (Case updatedCase : newCases) {             
            Case beforeUpdate = oldMap.get(updatedCase.Id);
            if(updatedCase.date_to_be_resumed__c != beforeUpdate.date_to_be_resumed__c) {
                
                if (updatedCase.date_to_be_resumed__c != null) {
                    system.debug('Case has been postponed');
                    
                    if((beforeUpdate.date_to_be_resumed__c != null) && (updatedCase.hidden_activity__c != null)){
                        system.debug('Case was already postponed. Now date_to_be_resumed__c has been changed (and a hidden_activity__c is existing)');
                        caseToUpdateMap.put(updatedCase.id,updatedCase);
                        updateTask.add(updatedCase);
                        doesTaskExist.add(updatedCase.hidden_activity__c);
                        System.debug('update task'); 
                    }
                    else if ((beforeUpdate.date_to_be_resumed__c == null) && (updatedCase.hidden_activity__c == null)){
                        system.debug('Case is being postponed (it was not already postponed) (and no hidden_activity__c is existing)');
                        system.debug('caseBefore: hidden_activity__c=' + beforeUpdate.hidden_activity__c + ', date_to_be_resumed__c=' + beforeUpdate.date_to_be_resumed__c + ' | caseAfter: hidden_activity__c=' + updatedCase.hidden_activity__c + ', date_to_be_resumed__c=' + updatedCase.date_to_be_resumed__c);
                        
                        caseToUpdateMap.put(updatedCase.id,updatedCase);
                        createTask.add(updatedCase);
                        System.debug('create task' + beforeUpdate.id);
                    }
                }
                else if (updatedCase.date_to_be_resumed__c == null && beforeUpdate.hidden_activity__c != null){
                    system.debug('Case is no longer postponed');
                    deleteTask.add(updatedCase);
                    doesTaskExist.add(updatedCase.hidden_activity__c);
                    System.debug('delete task'); 
                }
            }
        }
        
        if(doesTaskExist.size()>0) {
            for(Task tsk : [Select id, WhatId from Task where id in :doesTaskExist]){
                doesTaskExistMap.put(tsk.id, tsk);
            }
        }
        
        if(createTask.size()>0) {
            newTaskList.addAll(SLA_Controller.createFollowUpTask(createTask));
        }
        
        if(deleteTask.size()>0) {
            caseToUpdate = SLA_Controller.deleteFollowUpTask(deleteTask, doesTaskExistMap);
            for(Case c : caseToUpdate) {
                c.hidden_activity__c = '';
                TriggerDispatcher.casesToUpdate.put(c.id, c);
            }
        }
        
        if(updateTask.size()>0) {
            newTaskList.addAll(SLA_Controller.updateFollowUpTask(updateTask, doesTaskExistMap));
        }
        
        
        if(newTaskList.size()>0) {
            for(Task t : newTaskList) {
                System.debug('Task updated: ' + t.id);
                System.debug('Caseid = what.id: ' + t.WhatId);
                Case c = caseToUpdateMap.get(t.WhatId);
                //c.hidden_activity__c = t.id;
                //TriggerDispatcher.casesToUpdate.put(c.id, c);
                
                if(TriggerDispatcher.casesToUpdate.containsKey(c.id)) {
                    c.hidden_activity__c = t.id;
                    TriggerDispatcher.casesToUpdate.put(c.id, c);
                } else {
                    TriggerDispatcher.casesToUpdate.put(c.id, new Case(id = c.id, hidden_activity__c = t.id));
                }
            }
        }
    }
    
    private static list<Task> createFollowUpTask(list<Case> caseList) {
        list<Task> insertTasks = new list<Task>();
        Task tsk;
        
        for(Case newTask : caseList){
            tsk = new Task(
                            WhatId = newTask.Id,
                            OwnerId = Userinfo.getUserId(),
                            Priority = 'Normal',
                            IsReminderSet = true,
                            ReminderDateTime = newTask.date_to_be_resumed__c,
                            ActivityDate = date.newInstance(newTask.date_to_be_resumed__c.year(),
                                                            newTask.date_to_be_resumed__c.month(),
                                                            newTask.date_to_be_resumed__c.day()),                              
                            Type = 'Gjenopptakelse',
                            Status = 'Ikke startet',
                            Subject = 'Følg opp sak');
                        
            insertTasks.add(tsk);
        }
        if (insertTasks.size() != 0){
            insert insertTasks;
        }
        
        return insertTasks;
    }
    
    private static list<Task> updateFollowUpTask(list<Case> caseList, Map<String, Task> doesTaskExistMap) {
        list<Task> newTaskList = new list<Task>();
        list<Task> updateTasks = new list<Task>();
        list<Case> newTasks = new list<Case>();
        
        Task tsk;
        for(Case taskToUpdate : caseList) {               
            if(doesTaskExistMap.containsKey(taskToUpdate.hidden_activity__c)){
                System.debug('Task exists for update: '+ taskToUpdate.hidden_activity__c);
                tsk = new Task(Id = taskToUpdate.hidden_activity__c);
                tsk.ReminderDateTime = taskToUpdate.date_to_be_resumed__c;
                tsk.ActivityDate = date.newInstance(taskToUpdate.date_to_be_resumed__c.year(),
                                                    taskToUpdate.date_to_be_resumed__c.month(),
                                                    taskToUpdate.date_to_be_resumed__c.day());
            }
            else{
                newTasks.add(taskToUpdate);
            }
            
            updateTasks.add(tsk);
        }
        
        if (newTasks.size() != 0) {
            newTaskList = SLA_Controller.createFollowUpTask(newTasks);
        }
        // Added exception handling to prevent errors when a task is deleted from case ()
        if (updateTasks.size() != 0){
            try{
            update updateTasks;}
            catch(System.ListException e){
                System.debug('No tasks to update');
            }
        }
        
        return newTaskList;
    }
    
    private static list<Case> deleteFollowUpTask(list<Case> caseList, Map<String, Task> doesTaskExistMap) {
        list<Case> updateCaseList = new list<Case>();
        list<Task> deleteTasks = new List<Task>();
        Task tsk;
        for(Case removeTask : caseList){
            System.debug('Before Task check for delete'+ removeTask.hidden_activity__c);
            if(doesTaskExistMap.containsKey(removeTask.hidden_activity__c)){
                System.debug('Task exists for delete: '+ removeTask.hidden_activity__c);
                tsk = new Task(Id = removeTask.hidden_activity__c);
                deleteTasks.add(tsk);
            }
            Case crem = new Case(id = removeTask.id);
            crem.hidden_activity__c = '';
            System.debug('Case att ta bort task från ' + removeTask.CaseNumber);
            updateCaseList.add(crem); 
        }
        if(deleteTasks.size() != 0) {
            delete deleteTasks;
        }
        
        return updateCaseList;
    }
}