global class Case_CleanUpRecords_CaseHistory implements Database.Batchable<sObject>{

    global String [] email = new String[] {'supriya.goel@capgemini.com'};//Add here your email address here
      //Below code will fetch the job Id
 
//Start method. Collects the records or objects to be passed to the interface method execute
global Database.Querylocator start (Database.BatchableContext BC){
  
    return Database.getQueryLocator('SELECT id,ContactId ,AccountId ,AccountEmail__c,SuppliedEmail,Description,status,account.ispersonaccount FROM Case WHERE isanonymized__c = true and IsHistoryDeleted__c = false');
    
    }//End of start method

//Execute method. Is called for each batch of records passed to the method. Use to do all required processing for each chunk of data.
global void execute (Database.BatchableContext BC, List<sobject> scope){

 List<id> idlist = new List<id>();
 List<Case> caseList = new List<Case>();          
         for (sObject objScope: scope) { 
        Case newObjScope = (Case)objScope ;//type casting from generic sOject to Case
        newObjScope.IsHistoryDeleted__c = true;
        caseList.add(newObjScope);
        idlist.add(newObjScope.id);
        
       }//end of for loop
       
        List<CaseHistory> hisList = new List<CaseHistory>();
        
        hisList = [SELECT Id,CaseId FROM CaseHistory WHERE CaseId=:idlist];
        if(hisList!=null && hisList.size()>0){
            Delete hisList;
            Database.EmptyRecycleBin(hisList);
        }
         
        
         if (caseList != null && caseList .size()>0) {//Check if List is empty or not
             Database.update(caseList); 
         }
    }//End of execute method

//Finish method
global void finish(Database.BatchableContext BC){

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors, a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById, a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];//get the job Id
    System.debug('$$$ Jobid is'+BC.getJobId());

  //below code will send an email to User about the status
  mail.setToAddresses(email);
  mail.setReplyTo('postenbringsalesforce.no@capgemini.com');//Add here your email address
  mail.setSenderDisplayName('Apex Batch Processing Module');
  mail.setSubject('Batch Processing for history records'+a.Status);
  mail.setPlainTextBody('The Batch Apex job processed  '+a.TotalJobItems+' batches with  '+a.NumberOfErrors+' failures'+'Job Item processed are '+a.JobItemsProcessed);
  Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});

    }//End of finish method. Called after all batches are processed. Use to send confirmation emails or execute post - processing operations.
   

}//End of class