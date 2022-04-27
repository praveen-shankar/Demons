/**
This class creates the job that deletes old case log records. The age setting should be set in "Log Delete Age" in custom settings.
*/

global class CaseLog_schedulesDeleteLogs implements Schedulable {	
	list<CaseLog__c> logsToBeDeleted;
	public static final String APEX_JOB_NAME = 'CaseLog Delete';
	static LogSettings__c datesetting=LogSettings__c.getInstance('Default');
	static decimal ageInWeeks = ((datesetting!=null && datesetting.Age__c!=null) ? datesetting.Age__c : 52);
	public static String CRON1 = '0 0 23 * * ?';
	
	global void execute(SchedulableContext sc){
		Datetime dateLimit=System.now()-(7*ageInWeeks);
		logsToBeDeleted = [SELECT id FROM CaseLog__c where Case__c=null or (stop_time__c!=null and stop_time__c<:dateLimit) limit 9999];
		
		if(logsToBeDeleted.size()>0){
			CaseLogUtils.cleanUp(logsToBeDeleted);
		}
		
	}

	static public void startDeleteLogsScheduler(){		
		// Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
		// Runs 23:00 every night
		
		System.schedule('LOG_DELETE_' + 1 ,CRON1, new CaseLog_schedulesDeleteLogs());
	}
	

}