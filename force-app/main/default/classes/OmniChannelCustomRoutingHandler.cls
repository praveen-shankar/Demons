//Author: Rajeev Shekhar
//Date: 27 November 2017
//Class to update Omni channel routing decision

public without sharing class OmniChannelCustomRoutingHandler Implements Queueable{
    
    Map<Id,Case> cases;
    public OmniChannelCustomRoutingHandler(Map<Id,Case> cases) {
        this.cases = cases;
    }
    
    public void execute(QueueableContext qc){
        PendingServiceRouting[] pendingItems = new List<PendingServiceRouting>();
        for(PendingServiceRouting pp : [Select Id, CustomRequestedDatetime, WorkItemId from PendingServiceRouting Where WorkItemId IN :cases.keySet()
                                        And CustomRequestedDatetime = null]) {
            pp.CustomRequestedDatetime = cases.get(pp.WorkItemId).CreatedDate;
            pendingItems.add(pp);
        }
        
        if(pendingItems.size() > 0)
            Database.update(pendingItems,false); 
    }
    
}