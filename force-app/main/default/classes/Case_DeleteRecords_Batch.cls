global class Case_DeleteRecords_Batch implements Database.Batchable<sObject>,  Database.Stateful {

    global String [] email = new String[] {'supriya.goel@capgemini.com'};//DL address changed on 25th dept 2018 Add here your email address here
     global  List<id> idlist = new List<id>();
    //Below code will fetch the job Id
 
    //Start method. Collects the records or objects to be passed to the interface method execute
    global Database.Querylocator start (Database.BatchableContext BC){
        
    //The date conversion. decimalValue holds the value of days.
    //Case_Anonymisation_Days__c is a custom setting holding the value of number of days.
    Case_Anonymisation_Days__c datesetting = Case_Anonymisation_Days__c.getInstance('Default');
    Datetime age = (System.now()-datesetting.Number_Of_Days__c);
    System.debug(age );     
    return Database.getQueryLocator('SELECT id,ContactId ,AccountId  FROM Case WHERE CreatedDate <=:age and Do_not_Delete__c= false order by  CreatedDate ASC limit 2000');
    
    
    //return Database.getQueryLocator('SELECT id,ContactId ,AccountId, Do_not_Delete  FROM Case WHERE  id =:testid order by Closeddate ASC limit 2000');
    
   
    }//End of start method
    
    global void execute (Database.BatchableContext BC, List<sobject> scope){
    
    System.debug(scope);
    Delete scope;
    
    }
    
    global void finish(Database.BatchableContext BC){
 

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
  mail.setSenderDisplayName('Case Deletion');
  mail.setSubject('Case Deletion '+a.Status);
  mail.setPlainTextBody('The Batch Apex job processed  '+a.TotalJobItems+' batches with  '+a.NumberOfErrors+' failures'+'Job Item processed are '+a.JobItemsProcessed);
  Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
  
 }//End of finish method. Called after all batches are processed. Use to send confirmation emails or execute post - processing operations.
   

}//End of class