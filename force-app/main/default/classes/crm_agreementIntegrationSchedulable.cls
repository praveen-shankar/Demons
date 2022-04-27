public class crm_agreementIntegrationSchedulable  implements Schedulable {

List<Id> opportunityids;

public crm_agreementIntegrationSchedulable(List<Id> opportunityids){
        this.opportunityids = opportunityids;   
    }

    public void execute(SchedulableContext sc) {
        System.enqueueJob(new crm_agreementIntegrationController(opportunityids, null));
        // Abort the job once the job is queued
        System.abortJob(sc.getTriggerId());
    }
}