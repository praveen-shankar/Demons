trigger crm_segChangeRequestTrigger on Segment_Change_Request__c (After insert, Before Update) {


if(Trigger.isinsert && trigger.isAfter) {
 crm_segChangeRequestTriggerHelper.sharerecord(Trigger.new);
 }
 
 if(Trigger.isupdate && trigger.isbefore) {
 List<Segment_Change_Request__c   > slist= new List<Segment_Change_Request__c   >();
    for(Segment_Change_Request__c   obj : Trigger.new){
          crm_segChangeRequestTriggerHelper.checkapprover(Trigger.new, Trigger.oldMap);
   }      
 
 }
 

}