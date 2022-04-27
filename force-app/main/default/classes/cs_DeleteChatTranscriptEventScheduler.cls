/*********************************************************************
Name: cs_DeleteChatTranscriptEventScheduler 
=====================================================================
Req: US-15230 - Salesforce Data Storage Issue
=====================================================================
Purpose:
This Batch class schedules the cs_DeleteChatTranscriptEventsBatch class
to run every week.
**********************************************************************/

global class cs_DeleteChatTranscriptEventScheduler implements Schedulable{
    
     global void execute(SchedulableContext sc) {
        
        cs_DeleteChatTranscriptEventsBatch  DeleteChatTranscriptEventsBatch = new cs_DeleteChatTranscriptEventsBatch(); 
        Database.executeBatch(DeleteChatTranscriptEventsBatch);
         
    }
}