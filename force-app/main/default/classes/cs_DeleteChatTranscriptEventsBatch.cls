/*********************************************************************
Name: cs_DeleteChatTranscriptEventsBatch 
=====================================================================
Req: US-15230 - Salesforce Data Storage Issue
=====================================================================
Purpose:
This Batch class is to delete all the LiveChatTranscriptEvent records
created before last month. The batch is scheduled to run every week
**********************************************************************/

public class cs_DeleteChatTranscriptEventsBatch implements Database.Batchable<sObject>, Database.Stateful {
    public Map<Id, String> errorMap {get; set;}
    public Integer processedRecords = 0;
    public Integer unprocessedRecords = 0;
    
    public cs_DeleteChatTranscriptEventsBatch(){
        errorMap = new Map<Id, String>();
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){

        try {
            Datetime currenttime = datetime.now();
            Datetime backtime = currenttime.addMonths(-1);
            String formattedDatetime = backtime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.000+0000');
            String queryChatTranscriptEvent;
            
            //fetching all the LiveChatTranscriptEvent records created before last month.
            //queryChatTranscriptEvent= 'SELECT Id FROM LiveChatTranscriptEvent where CreatedDate < '+formattedDatetime+ ' LIMIT 2000';
            queryChatTranscriptEvent= 'SELECT Id FROM LiveChatTranscriptEvent where CreatedDate < '+formattedDatetime;

            System.debug('queryChatTranscriptEvent== ' + queryChatTranscriptEvent);
            
            Database.QueryLocator queryLocatorChatTranscriptEvent;
            queryLocatorChatTranscriptEvent = Database.getQueryLocator(queryChatTranscriptEvent);
            
            System.debug('queryLocatorChatTranscriptEvent == ' + queryLocatorChatTranscriptEvent );    
            return queryLocatorChatTranscriptEvent;
        }
        catch (Exception e) {
            System.debug('Exception -----'+e);
            return null;
        }
        
    }
    
    public void execute(Database.BatchableContext bc, List<LiveChatTranscriptEvent> chatTranscriptEventList){
        if(chatTranscriptEventList.size()>0){
            /*for(LiveChatTranscriptEvent lct : chatTranscriptEventList){
                system.debug('Id - '+ lct.Id);
            }*/
            
            // Delete the LiveChatTranscriptEvent
            Database.DeleteResult[] drList = Database.delete(chatTranscriptEventList, false);
             
            // Iterate through each returned result
            integer index = 0;
            for(Database.DeleteResult dr : drList) {
                if (dr.isSuccess()) {
                    processedRecords++;
                }
                else {
                    // Operation failed, so get all errors  
                    unprocessedRecords++;
                    String errMsg = dr.getErrors()[0].getMessage();
                    errorMap.put(drList[index].Id, errMsg);
                }
                
                index++;
            } 
        }
        
    }
    
    public void finish(Database.BatchableContext bc){
            AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
        
            String finalstr = 'Id, Error \n';
            String subject = 'LiveChatTranscriptEvent - Record Deletion Batch';
            String attName = 'cs_DeleteChatTranscriptEventsBatch Errors.csv';
            String body = 'The execution of batch job cs_DeleteChatTranscriptEventsBatch was completed. \n';
            body += 'There were ' + processedRecords + ' success and ' + unprocessedRecords + ' errors.';
            body += ' Please find the error list attached to the email.';
            
            if(!errorMap.isEmpty()){
                for(Id id  : errorMap.keySet()){
                string err = errorMap.get(id);
                string recordString = '"'+id+'","'+err+'"\n';
                finalstr = finalstr +recordString;
                }
            }
                
            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
            
            // Sets the paramaters of the email
            email.setSubject( subject );
            email.setToAddresses( new String[] {a.CreatedBy.Email} );
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Send the email
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
    }
    
}