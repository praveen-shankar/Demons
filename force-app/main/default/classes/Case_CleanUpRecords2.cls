global class Case_CleanUpRecords2 implements Database.Batchable<sObject>,  Database.Stateful {

    global String [] email = new String[] {'supriya.goel@capgemini.com'};//DL address changed on 25th dept 2018 Add here your email address here
     global  List<id> idlist = new List<id>();
    //Below code will fetch the job Id
 
    //Start method. Collects the records or objects to be passed to the interface method execute
    global Database.Querylocator start (Database.BatchableContext BC){
        
    //The date conversion. decimalValue holds the value of days.
    //Case_Anonymisation_Days__c is a custom setting holding the value of number of days.
    Case_Anonymisation_Days__c datesetting = Case_Anonymisation_Days__c.getInstance('Default');
    Datetime age = (System.now()-datesetting.Number_Of_Days__c);
    
       
       
    id testid = '500w000000jyHda';
    
    return Database.getQueryLocator('SELECT id,ContactId ,AccountId  FROM Case WHERE isanonymized__c = true order by Closeddate ASC limit 2000');
    
   
    }//End of start method

//Execute method. Is called for each batch of records passed to the method. Use to do all required processing for each chunk of data.
global void execute (Database.BatchableContext BC, List<sobject> scope){

    //The list of cases that is hitting the criteria
    
   // List<CaseFeed> feedList = new List<CaseFeed>();
    List<Event> eventList = new List<Event>();
    List<Task> taskList = new List<Task>();
   
        //Activity HISTORY
        //It is not possible to delete from Case History
        //The idea is considered from SF https://success.salesforce.com/ideaView?id=08730000000JCiz
      
        eventList =[Select id , whatid from Event where what.type='Case' and (isArchived=true or isArchived=false) and whatid in :idlist];
       
        if(eventList !=null && eventList.size()>0){
            Delete eventList;
            Database.EmptyRecycleBin(eventList);
        }

        //CASE FEED
       /*  feedList = [SELECT Id,ParentId FROM CaseFeed WHERE ParentId in :idlist];
         System.debug('##feedList '+ feedList );
        if(feedList!=null && feedList.size()>0){
            Delete feedList;
            Database.EmptyRecycleBin(feedList);
            system.debug('feedList '+ feedList.size());
        }
        */
       

        //TASK
        taskList = [SELECT Id, Whatid FROM Task WHERE WhatId in :idList all rows]; //added all rows
        if(taskList!=null && taskList.size()>0){
            Delete taskList;
            Database.EmptyRecycleBin(taskList);
            //system.debug('taskList '+ taskList.size());
        }
        
      
    }//End of execute method
//Finish method
global void finish(Database.BatchableContext BC){
 /*List<CaseFeed> feedList = new List<CaseFeed>();

 feedList = [SELECT Id,ParentId FROM CaseFeed WHERE ParentId in :idlist];
         System.debug('##feedList '+ feedList );
        if(feedList!=null && feedList.size()>0){
            Delete feedList;
            Database.EmptyRecycleBin(feedList);
            system.debug('feedList '+ feedList.size());
        }*/

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors, a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById, a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId() ];//get the job Id
   //system.debug('$$$ Jobid is'+BC.getJobId());

  List < string > toAddress = new List < string > ();
    environment_settings__c emailnotifications = environment_settings__c.getValues('BatchEmailNotification');
    List < String > valuesList1 = new List < String > ();
    if (emailnotifications != null && emailnotifications.value__c != null) 
    valuesList1 = emailnotifications.value__c.split(',');
       for (String emailuser:valuesList1 )
            toAddress.add(emailuser);  
  //below code will send an email to User about the status
  mail.setToAddresses(toAddress);
  mail.setSenderDisplayName('Case cleanup');
  mail.setSubject('Case cleanup record 2  for feed and activity history  '+a.Status);
  mail.setPlainTextBody('The Batch Apex job processed  '+a.TotalJobItems+' batches with  '+a.NumberOfErrors+' failures'+'Job Item processed are '+a.JobItemsProcessed);
  Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
  
  //Database.executeBatch(new Case_CleanUpRecords_CaseHistory(),1);
 }//End of finish method. Called after all batches are processed. Use to send confirmation emails or execute post - processing operations.
   

}//End of class