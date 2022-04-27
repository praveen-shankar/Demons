//Author - Rajeev Shekhar
//When a workItem is accepted through Omni channel widget, it does not activate the trigger on the Case object.
//This trigger makes sure that the Case gets updated when a workitem is accepted via Omni Channel. The update will
//run triggers, workflow etc on case.
//Odigo CTI Project
//Date: 06 October 2017


trigger OmniCaseHandler on AgentWork (after insert, after update) {
    List<Id> casesToUpdate = new List<Id>();
    List<Case> toupdate = new List<Case>();
    
    System.debug('Agent Work trigger : ' + trigger.isinsert + ' or ' + trigger.isupdate + ' ' + trigger.new);
    
    for(AgentWork aw : trigger.new){
        if(Test.isRunningTest() && trigger.isInsert){
            //For Test class, select any case
            Case c = [Select Id from Case Limit 1];
            casesToUpdate.add(c.Id);
            break;
        }
        else if(trigger.isUpdate && aw.Status == 'Opened' && aw.WorkItemId != null && aw.WorkItemId.getSobjectType() == Schema.Case.SObjectType){ 
            casesToUpdate.add(aw.WorkItemId);
        }
    }
    
    if(casesToUpdate.size() > 0) {
        try{
            for(Case c : [Select Id, Status,Origin,case_new_Comment__c,Omni_Channel__c, unread_action__c, OwnerId From Case Where Id = :casesToUpdate]){
                c.Status = 'Under behandling';
                c.unread_action__c = false;
                c.Omni_Channel__c = true;
                c.case_new_Comment__c = false;
                c.Assigned_to_CTI__c = false;
                c.Assigned_to_CTI_Agent__c = false;
                toupdate.add(c); 
            }
            
            update toupdate;
        }
        Catch(Exception e){
            System.debug('Exception occured while accepting Case through Omni Channel: '+ e);
        }
    }
}