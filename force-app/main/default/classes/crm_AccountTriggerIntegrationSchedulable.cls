public class crm_AccountTriggerIntegrationSchedulable implements Schedulable {
    
List<Id> accountIds;

public crm_AccountTriggerIntegrationSchedulable(List<Id> accountIds){
        this.accountIds = accountIds;   
    }

    public void execute(SchedulableContext sc) {
        System.enqueueJob(new crm_convertCustomerIntegrationController(accountIds));
        // Abort the job once the job is queued
        System.abortJob(sc.getTriggerId());
    }
}