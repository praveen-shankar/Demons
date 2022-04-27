@isTest
private class zzz_CaseFollowUpTaskMaintainer {

    /************
    ** Helpers **
    ************/
    public static Task getFollowUpTaskForCase(ID caseId) {
    	return [select id, ReminderDateTime from Task where whatId=:caseId AND subject = 'Følg opp sak'];
    }
    
    public static integer getNumberOfFollowupTasksOnCase(ID caseId) {
    	return [select id from Task where whatId=:caseId].size();
    }
    
    public static Case reloadCase(ID caseId) {
    	return [select id, date_to_be_resumed__c from case where id=:caseId];
    }
    
    static testMethod void insertTest() {
    	case postponed = new case(subject='Postponed', date_to_be_resumed__c=system.now());
    	case notPostponed = new case(subject='Not Postponed');
    	case postponedStraightToProcessing = new case (subject='Postponed and under behandling', status='Under behandling', date_to_be_resumed__c=system.now());
    	//insert postponed;
    	//insert notPostponed;
    	insert postponedStraightToProcessing;
    	
    	test.startTest();
   		//postponed = reloadCase(postponed.id);
   		//notPostponed = reloadCase(notPostponed.id);
   		postponedStraightToProcessing = reloadCase(postponedStraightToProcessing.id);
   		
   		if(postponedStraightToProcessing.date_to_be_resumed__c == null) {
			system.assertEquals(0, getNumberOfFollowupTasksOnCase(postponedStraightToProcessing.id)); //0 should be created because of WF rule named 'ALL_update expected time and when status is under behandling'
   		}
		else {
			system.assertEquals(1, getNumberOfFollowupTasksOnCase(postponedStraightToProcessing.id)); 
		}
   		/*
		system.assertEquals(0, getNumberOfFollowupTasksOnCase(notPostponed.id));

		system.assertEquals(1, getNumberOfFollowupTasksOnCase(postponed.id));
		system.assertEquals(postponed.date_to_be_resumed__c, getFollowUpTaskForCase(postponed.id).ReminderDateTime);
   		
   		Datetime newResumeDate = system.now()+1000;
   		postponed.date_to_be_resumed__c = newResumeDate;
   		upsert postponed;
   		postponed = reloadCase(postponed.id);
    	test.stopTest();
   		
		system.assertEquals(1, getNumberOfFollowupTasksOnCase(postponed.id));
		system.assertEquals(newResumeDate, getFollowUpTaskForCase(postponed.id).ReminderDateTime);
   		*/
    }
    
    static testMethod void updateTest() {
    	
    	case postponed = new case(subject='Postponed');
    	case notPostponed = new case(subject='Not Postponed');
    	upsert postponed;
    	upsert notPostponed;
    	//following two lines can be deleted after insert fix...
    	postponed.date_to_be_resumed__c = (system.now()+1000);
    	upsert postponed;
    	
    	test.startTest();
    		system.debug('Starting tests (test.startTest)' + postponed);
    		//postponed --> other field updated (postponed to same date)
    		postponed.description = 'Case updated';
    		upsert(postponed);
    		postponed = reloadCase(postponed.id);
    		system.assertEquals(1, getNumberOfFollowupTasksOnCase(postponed.id));
    		system.assertEquals(postponed.date_to_be_resumed__c, getFollowUpTaskForCase(postponed.id).ReminderDateTime);
    		
    		//postponed --> postponed to other date
    		Datetime newResumeDate = system.now()+300;
    		postponed.date_to_be_resumed__c = newResumeDate;
    		upsert(postponed);
    		postponed = reloadCase(postponed.id);
    		system.assertEquals(1, getNumberOfFollowupTasksOnCase(postponed.id));
    		system.assertEquals(newResumeDate, getFollowUpTaskForCase(postponed.id).ReminderDateTime);
    		
    		//postponed --> no longer postponed
    		postponed.date_to_be_resumed__c = null;
    		upsert(postponed);
    		postponed = reloadCase(postponed.id);
    		system.assertEquals(0, getNumberOfFollowupTasksOnCase(postponed.id));
    		
    		//not postponed --> no postpone
			notPostponed.date_to_be_resumed__c = null;
			notPostponed.Description = '...';
    		upsert(notPostponed);
    		notPostponed = reloadCase(notPostponed.id);
    		system.assertEquals(0, getNumberOfFollowupTasksOnCase(notPostponed.id));

    		//not postponed --> postponed
    		notPostponed.date_to_be_resumed__c = newResumeDate;
    		upsert(notPostponed);
    		notPostponed = reloadCase(notPostponed.id);
    		system.assertEquals(1, getNumberOfFollowupTasksOnCase(notPostponed.id));
    		system.assertEquals(newResumeDate, getFollowUpTaskForCase(notPostponed.id).ReminderDateTime);
			 		
    		
    	
    	test.stopTest();
    	
    }
    
    
    
    

    
    
    
    
    static testMethod void batchTest() {
    	List<Case> newCaseList = new List<Case>();
    	Case newCase = new Case();
    	
    	for(Integer i=0;i<200;i++){
    		if(i<50){
    			newCase = new Case(date_to_be_resumed__c = System.now());
    			newCaseList.add(newCase);
    		}
    		if(i>49 && i<100){
    			newCase = new Case(date_to_be_resumed__c = System.now());
    			newCaseList.add(newCase);
    		}
    		if(i>99 && i<150){
    			newCase = new Case();
    			newCaseList.add(newCase);
    		}
    		if(i>149 && i<200){
    			newCase = new Case();
    			newCaseList.add(newCase);
    		}
    	}
    	for(Integer i=0;i<200;i++){
    		if(i<50){
    			//newCaseList[0].add(newCase);
    		}
    		if(i>49 && i<100){
    			//newCaseList[0].add(newCase);

    		}
    		if(i>99 && i<150){
    			//newCaseList[0].add(newCase);
    			
    		}
    		if(i>149 && i<200){
    			//newCaseList[0].add(newCase);
    			
    		}
    	}
    	
    }
}