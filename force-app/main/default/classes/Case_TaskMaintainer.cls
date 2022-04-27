public with sharing class Case_TaskMaintainer {
	
	public Case_TaskMaintainer() {
		
	}
	
	static testMethod void testChangeClosedCaseFromUserToQueue() {
		Case_TaskMaintainer ctm = new Case_TaskMaintainer();
	}
	
	/*
	public static void addTasksToInsertCases(list<Case> newCases) {
		list<Task> upsertTasks = new list<Task>();	//List of tasks which will be upserted in DB
		Set<Id> checkedId= new Set<Id>();				// Helper variable to contain IDs for cases which have already been processed by the trigger. This is to avoid re-processing of same case (COMMENT: why is this required? A trigger batch will never contain dupes of the object it's running on)
		
		for (Case newCase : newCases) {   
			if(newCase.date_to_be_resumed__c != null) {
				system.debug('Newly created case is postponed');
                  		
            	if(!checkedId.contains(newCase.id)){
                	upsertTasks.add(Case_TaskMaintainer.createTask(newCase));
					checkedId.add(newCase.id);
               	}
			}
    	}
    	
    	system.debug('Do DML calls');
        if (upsertTasks.size() != 0){	upsert upsertTasks;  }
        
        map<ID, Task> newTaskMap = new map<ID, Task>();
        for(Task t : [select id, whatId from Task where id in :upsertTasks]) {
            System.debug('Task updated: ' + t.id);
            System.debug('Caseid = what.id: ' + t.WhatId);
            
            newTaskMap.put(t.WhatId, t);
        }
        
        for(Case newCase : newCases) {
        	Task t = newTaskMap.get(newCase.Id);
        	if(t != null) {
        		newCase.hidden_activity__c = t.id;
        	}
        }
	}
	
	public static map<ID, Task> updateCasesWithTasks(list<Case> newCases, Map<ID, Case> oldMap) {
		List<Task> upsertTasks = new List<Task>();	//List of tasks which will be upserted in DB
        List<Task> deleteTasks = new List<Task>();	//List of tasks which will be deleted in DB
        
        list<Case> updatewTask = new list<Case>();	//Cases with a task related, but task is out of sync with case data 
        map<ID, Case> createTask = new map<ID, Case>();	//New task related to case 
        List<Case> deleteTask = new List<Case>();	//Cases with a task related, though case should have no task related
        
        List<String> doesTaskExist = new List<String>();				// Used to collect tasks to be loaded in the doesTaskExistMap variable
        Map<String, Task> doesTaskExistMap = new Map<String, Task>();	// Contains all tasks which already exist in the system, but must be manipulated (updated or deleted)
        Set<Id> checkedId= new Set<Id>();								// Helper variable to contain IDs for cases which have already been processed by the trigger. This is to avoid re-processing of same case (COMMENT: why is this required? A trigger batch will never contain dupes of the object it's running on)
        
        for (Case newCase : newCases) {             
            Case oldCase = oldMap.get(newCase.Id);
            
            if (newCase.date_to_be_resumed__c != null) {
              	system.debug('Case has been postponed');
              	
            	if((oldCase.date_to_be_resumed__c != null) && (newCase.hidden_activity__c != null)){
                	system.debug('Case was already postponed. Now date_to_be_resumed__c has been changed (and a hidden_activity__c is existing)');
                	
                	upsertTasks.add(Case_TaskMaintainer.createTask(newCase));
                    doesTaskExist.add(newCase.hidden_activity__c);
                    System.debug('update task'); 
              	}
              	else if ((oldCase.date_to_be_resumed__c == null) && (newCase.hidden_activity__c == null)){
              		//system.debug('Case is being postponed (it was not already postponed) (and no hidden_activity__c is existing)');
              		//system.debug('caseBefore: hidden_activity__c=' + oldCase.hidden_activity__c + ', date_to_be_resumed__c=' + oldCase.date_to_be_resumed__c + ' | caseAfter: hidden_activity__c=' + updatedCase.hidden_activity__c + ', date_to_be_resumed__c=' + updatedCase.date_to_be_resumed__c);
              		
                	if(!checkedId.contains(newCase.id)){
                    	updatewTask.add(newCase);
                        System.debug('create task' + oldCase.id);
                        checkedId.add(oldCase.id);
                    }
              	}
        	} else if (newCase.date_to_be_resumed__c == null && oldCase.hidden_activity__c != null){
           		system.debug('Case is no longer postponed');
           		
           		deleteTask.add(newCase);
            	System.debug('delete task'); 
            	newCase.hidden_activity__c = '';
          	}
    	}
    	
    	for(Case c : updatewTask) {
    		upsertTasks.add(Case_TaskMaintainer.updateTask(c, Case_TaskMaintainer.getExistingTasks(oldMap.keySet())));
    	}
    	
    	system.debug('Do DML calls');
        if (upsertTasks.size() != 0){	upsert upsertTasks;  }
        
        
        map<ID, Task> taskMap = new map<ID, Task>();
        for(Task t : [select id, whatId from Task where id in :upsertTasks]) {
            System.debug('Task updated: ' + t.id);
            System.debug('Caseid = what.id: ' + t.WhatId);
            
            taskMap.put(t.whatId, t);
        }
        
        if (deleteTasks.size() > 0) {	Case_TaskMaintainer.deleteTasks(deleteTask);		}
        
        return taskMap;
	}
	
	
	// register existing maps
	public static map<String, Task> getExistingTasks(set<ID> caseIds) {
		Map<String, Task> doesTaskExistMap = new Map<String, Task>();
		system.debug('Transforming variable doesTaskExist into the Map<Task.id, Task> doesTaskExistMap');
    	for(Task tsk : [Select id, WhatId from Task where id in :caseIds]){
    		doesTaskExistMap.put(tsk.id, tsk);
    		System.debug('Task with id:' + tsk.id);
    	}
    	
    	return doesTaskExistMap;
	}
	
	//Create a new Task
	public static Task createTask(Case newTask) {
		Task t = new Task(WhatId = newTask.Id,
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
    	return t;
	}
	
	// Update existing map
	public static Task updateTask(Case updateTask, map<String, Task> doesTaskExistMap) {
		Task t = null;
		if(doesTaskExistMap.containsKey(updateTask.hidden_activity__c)){
            	System.debug('Task exists for update: '+ updateTask.hidden_activity__c);
              	t = new Task(Id = updateTask.hidden_activity__c);
            }
			else{
	           	t = new Task(WhatId = updateTask.Id,
            						OwnerId = Userinfo.getUserId(),
			                        Priority = 'Normal',
			                        IsReminderSet = true,
			                        Type = 'Gjenopptakelse',
			                    	Status = 'Ikke startet',
			                    	Subject = 'Følg opp sak'
			                        );
			}
	                        
			t.ReminderDateTime = updateTask.date_to_be_resumed__c;
			t.ActivityDate = date.newInstance(updateTask.date_to_be_resumed__c.year(),
	                                                 updateTask.date_to_be_resumed__c.month(),
	                                                 updateTask.date_to_be_resumed__c.day());                            
	        return t;
	}
	
	public static list<Task> deleteTasks(list<Case> cases) {
		list<Task> tasksToDelete = new list<Task>();
		for(Case c : cases) {
			tasksToDelete.add(new Task(id = c.hidden_activity__c));
		}
		delete tasksToDelete;
		
		return tasksToDelete;
	}
	*/
}