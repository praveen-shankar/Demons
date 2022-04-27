global class OEBS_scheduledOrderRelease implements Schedulable {
	list<Case> caseToBeReleasedList;
	static final String APEX_JOB_NAME = 'OEBS Release';
	
	global void execute(SchedulableContext sc){
		caseToBeReleasedList = [SELECT id FROM Case WHERE Origin = 'OEBS'
									AND recordTypeId = :KATSutilities.getRecordType('deviation_case')
									AND OEBS_Order_Status__c = 'Release failed' LIMIT 100];
		
		list<Id> caseIdToBeReleasedList = new list<id>();
		for(Case caseToBeReleased : caseToBeReleasedList){
			caseIdToBeReleasedList.add(caseToBeReleased.id);
			
			if(caseIdToBeReleasedList.size() == 10) {
				
				OEBS_OrderController.releaseOrderListNotifyOwnerFuture(caseIdToBeReleasedList);
				caseIdToBeReleasedList.clear();
			}
		}
		if(caseIdToBeReleasedList.size() > 0)
		OEBS_OrderController.releaseOrderListNotifyOwnerFuture(caseIdToBeReleasedList);
	}

	static public void startOrderReleaseScheduler_15min() {
		String CRON1 = '0 0 * * * ?';
		String CRON2 = '0 15 * * * ?';
		String CRON3 = '0 30 * * * ?';
		String CRON4 = '0 45 * * * ?';
		OEBS_scheduledOrderRelease.startOrderReleaseScheduler(1, CRON1);
		OEBS_scheduledOrderRelease.startOrderReleaseScheduler(2, CRON2);
		OEBS_scheduledOrderRelease.startOrderReleaseScheduler(3, CRON3);
		OEBS_scheduledOrderRelease.startOrderReleaseScheduler(4, CRON4);
	}
	
	static public void startOrderReleaseScheduler(Integer jobNumber, String cron) {
		System.schedule('OEBS Release_' + jobNumber ,cron, new OEBS_scheduledOrderRelease());
	}
}