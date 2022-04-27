/*
Created By: Supriya Goel
Object  :event
Date: 29 April 2016
Trigger  for event to post on the chatter if the event is created back date
*/

    trigger crm_EventTrigger on Event (after update, after insert) {
    List<Event>  EventList = new List<Event>();
     /*   if(Trigger.isUpdate && Trigger.isAfter){

            for(Event evnt: Trigger.new){
                Event oldevnt = Trigger.oldMap.get(evnt.Id);

                if(evnt.StartDateTime!= oldevnt.StartDateTime &&  evnt.StartDateTime < System.now() )
                    EventList.add(evnt);
                }

            if(EventList.size()>0){
                crm_EventTriggerHelper.addfeedItems(EventList) ;
                }
            }

        if(Trigger.isInsert && Trigger.isAfter){
            for(Event evnt: Trigger.new){
                if(evnt.StartDateTime < System.now() )
                    EventList.add(evnt);

            }

            if(EventList.size()>0){
                crm_EventTriggerHelper.addfeedItems(EventList) ;
            }
        } */
        
        // code for NPS
        
        if(Trigger.isInsert && Trigger.isAfter  ||  Trigger.isUpdate && Trigger.isAfter){ 
        List<Id> eventIds = new List<Id>();
        for(Event e: Trigger.new){
            if (e.crm_event_completed__c == true && string.isBlank(e.crm_NPS_Status__c)){
                eventIds.add(e.id);
            }
        }
        
        if (eventIds.size() > 0 ){
            if( ! test.isRunningTest() && System.isBatch()==false) {
                crm_Event_SendToNPS.sendEventsToNPS(eventIds);
            }
        } 
        
        }//end of events
    }//end of trigger