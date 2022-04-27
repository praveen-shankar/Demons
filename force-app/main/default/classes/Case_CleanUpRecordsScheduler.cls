global class Case_CleanUpRecordsScheduler implements Schedulable {

global void execute(SchedulableContext sc){

List<Case_anonymisation_day_schedule__c> ScheduleDays = Case_anonymisation_day_schedule__c.getall().values();
AsyncApexJob[] jobs;
DateTime startDateTime;
DateTime endDateTime;

Boolean canWe= False;

ApexClass BatchClass = [Select ID From ApexClass Where Name ='Case_CleanUpRecordsScheduler' LIMIT 1 ];
if(BatchClass!=null) 
{
jobs = [select id from AsyncApexJob where status='Processing' AND ApexClassId=:BatchClass.Id AND JobType='BatchApex'];
if ((jobs==null || jobs.size()==0)) 
    {
    Datetime curr = Datetime.now();
    String currLoc = curr.format();
    String dayOfWeek = curr.format('E');
    
    Integer hr = Integer.valueOf(curr.format('HH'));
    Double currTime = hr;
    System.debug(currTime);
    
        for(Case_anonymisation_day_schedule__c sd:ScheduleDays)
        {   
            System.debug('-----'+sd.name+'=========='+dayOfWeek);
            if(sd.name.containsIgnoreCase(dayOfWeek))
            {
                If((sd.Start_Time__c!=null ||sd.Start_Time__c!='') && (sd.End_Time__c!=null ||sd.End_Time__c!='') )
                {
                canWe = (Double.valueOf(sd.Start_Time__c) <= currTime) && (currTime < Double.valueOf(sd.End_Time__c)); 
                }
                if(Test.isRunningTest()){
                    canWe = true;
                }
            }
        }
    
       
        
        if(canWe)
        {
         Id batchJobId = Database.executeBatch(new Case_CleanUpRecords(), 200);
        }
            
        }

    }

}

    static public void startCase_CleanUpRecordsScheduler_15min() {
        String CRON1 = '0 0 * * * ?';
        String CRON2 = '0 15 * * * ?';
        String CRON3 = '0 30 * * * ?';
        String CRON4 = '0 45 * * * ?';
        Case_CleanUpRecordsScheduler.startCase_CleanUpRecordsScheduler(1, CRON1);
        Case_CleanUpRecordsScheduler.startCase_CleanUpRecordsScheduler(2, CRON2);
        Case_CleanUpRecordsScheduler.startCase_CleanUpRecordsScheduler(3, CRON3);
        Case_CleanUpRecordsScheduler.startCase_CleanUpRecordsScheduler(4, CRON4);
    }
    
    static public void startCase_CleanUpRecordsScheduler(Integer jobNumber, String cron) {
    
        System.schedule('Case_CleanUpRecords' + jobNumber ,cron, new Case_CleanUpRecordsScheduler());
    }
}