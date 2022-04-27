public with sharing class cti_CasePriority {
    
    
    public static boolean isCaseCtiDeadlineExpired(Case oldCase, Case newCase) {
		if(newCase.cti_deadline__c == null) {
			return true;
		}
		
		if(hasTheCaseChangedOwner(oldCase, newCase) && isCaseOwnedByACtiQueue(newCase)) {
			/*
			if(isDateHigherThanTheQueuePriority(oldCase.cti_deadline__c, newCase)) {
				//System.assert(false, 'isDateHigherThanTheQueuePriority(oldCase.cti_deadline__c, newCase)');
				return true;
			}
			*/
			return true;
		}
		return false;
	}
	
    private static boolean isCaseOwnedByACtiQueue(Case c) {
		QueueDetails__c qd = getQueueDetails(c);
		return qd != null;
	}
    
    private static QueueDetails__c getQueueDetails(Case c) {
		QueueDetails__c qd = [select Id, queue_deadline__c, Business_Hours__r.Id, Business_Hours__c from QueueDetails__c where OwnerId = :c.OwnerId];
		return qd;
	}
	/** NOT IN USE
	
    private static DateTime calculateCaseCtiDeadline(Case c) {
    	integer minutes = getQueueDeadline(c);
    	BusinessHours bh = KATSutilities.getBusinessHours(c);
    	DateTime deadline = KATSutilities.addMinutesToDateWithRespectToBusinessHours(minutes, DateTime.now(), bh);
    	return deadline;
    }
	*/
    /** NOT IN USE
    private static boolean isDateHigherThanTheQueuePriority(Datetime deadline, Case newCase) {
		QueueDetails__c newCaseQueueDetails = getqueueDetails(newCase);
			if(newCaseQueueDetails == null) { // case is not owned by a queue
				return false;
			}
			
			// the case has a deadline higher than the queue priority?
			if(deadline > calculateCaseCtiDeadline(newCase)) {
				return true;
			}
			return false;
	}
	*/
	/** NOT IN USE
	private static integer getQueueDeadline(Case c) {
    	QueueDetails__c qd = [select queue_deadline__c from QueueDetails__c where OwnerId = :c.OwnerId];
    	if(qd == null || qd.queue_deadline__c == null) {
    		return 0;
    	}
    	return qd.queue_deadline__c.intValue();
    }
    */
	private static boolean hasTheCaseChangedOwner(Case oldCase, Case newCase) {
		return oldCase.OwnerId != newCase.OwnerId;
	}
	
	public static void resetCtiDeadlineOnCase(Case c) {
		QueueDetails__c qd = getQueueDetails(c);
		if(qd != null) {
			integer minutes = 0;
			if(qd.queue_deadline__c != null) {
				minutes = qd.queue_deadline__c.intValue();
			}
			BusinessHours bh = qd.Business_Hours__r;
			if(bh != null)
				c.cti_deadline__c = KATSutilities.addMinutesToDateWithRespectToBusinessHours(minutes, DateTime.now(), bh);
		}
		//update c;
	}
	
	public static void addMinutesToCaseWithRespectToBusinessHours(Case c, integer minutes) {
    	if(c.cti_deadline__c == null) {
    		c.cti_deadline__c = Datetime.now();
    	}
		BusinessHours bh = KATSutilities.getBusinessHours(c);
    	c.cti_deadline__c = KATSutilities.addMinutesToDateWithRespectToBusinessHours(minutes, c.cti_deadline__c, bh);
    }
    
	
	
	

}