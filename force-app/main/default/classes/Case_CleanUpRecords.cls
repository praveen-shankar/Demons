global class Case_CleanUpRecords implements Database.Batchable<sObject>,  Database.Stateful {

    global String [] email = new String[] {'supriya.goel@capgemini.com'};//DL address changed on 25th dept 2018 Add here your email address here
     global  List<id> idlist = new List<id>();
    //Below code will fetch the job Id
 
    //Start method. Collects the records or objects to be passed to the interface method execute
    global Database.Querylocator start (Database.BatchableContext BC){
        
    //The date conversion. decimalValue holds the value of days.
    //Case_Anonymisation_Days__c is a custom setting holding the value of number of days.
    Case_Anonymisation_Days__c datesetting = Case_Anonymisation_Days__c.getInstance('Default');
    Datetime age = (System.now()-datesetting.Number_Of_Days__c);
    
    //added on 6/6/2018
    if(Test.isRunningTest()){
        return database.getQueryLocator('SELECT id,ContactId ,AccountId ,AccountEmail__c,SuppliedEmail,Description,status,account.ispersonaccount FROM Case');
    }
           
       
    id testid = '500w000000jyHda';
    
    return Database.getQueryLocator('SELECT id,ContactId ,AccountId ,AccountEmail__c,SuppliedEmail,Description,status,account.ispersonaccount FROM Case WHERE isClosed = true  and Closeddate <=:age and isanonymized__c = false order by Closeddate ASC limit 2000');
    
   
    }//End of start method

//Execute method. Is called for each batch of records passed to the method. Use to do all required processing for each chunk of data.
global void execute (Database.BatchableContext BC, List<sobject> scope){

    //The list of cases that is hitting the criteria
    List<Case> caseList = new List<Case>();
    List<Case> updatedCaseList = new List<Case>();
    List<CaseComment> comList = new List<CaseComment>();
    //List<sf4twitter__Twitter_Conversation__c> convList = new List<sf4twitter__Twitter_Conversation__c>();
    List<Emailmessage> emailList = new List<Emailmessage>();
    List<Attachment> attList = new List<Attachment>();
    List<CaseHistory> hisList = new List<CaseHistory>();
    //List<CaseFeed> feedList = new List<CaseFeed>();
    List<Event> eventList = new List<Event>();
    List<Task> taskList = new List<Task>();
    //The list of id values
   
    List<id> idAccountList = new List<id>();
    
    Case_Anonymisation_Days__c datesetting = Case_Anonymisation_Days__c.getInstance('Default');
    String QueueName = datesetting.queue_name__c;
    List<QueueSobject> anonymize_cases = new list<QueueSobject>();     
    anonymize_cases =[Select QueueId from QueueSobject where Queue.DeveloperName =: QueueName and SobjectType='Case' limit 1];
      
    for (sObject objScope: scope) { 
        Case newObjScope = (Case)objScope ;//type casting from generic sOject to Case
        
        /*newObjScope.Description = 'The case has reach the limit for 3,5 year and is anonymoused';
        newObjScope.Subject = 'The case is anonymoused';
        CSphase 2 Supriya 22122016 =>Added the labels
        */
        newObjScope.Description = System.label.cs_Case_description_anonymoused;
        newObjScope.Subject = System.label.cs_Case_subject_anonymoused;
        newObjScope.AccountId = null;
        newObjScope.AccountEmail__c = '';
        newObjScope.AccountPhone__c= '';
        newObjScope.ContactId=null;
        newObjScope.Customer_accountnumber__c = null;
        newObjScope.Customers_reference__c = null;
        newObjScope.SuppliedEmail = '';
        newObjScope.SuppliedAddress__c = '';
        newObjScope.SuppliedCity__c='';
        newObjScope.SuppliedName='';
        newObjScope.SuppliedPhone = '';
        newObjScope.SuppliedPartyNumber__c=null;
        newObjScope.Shipper_address__c ='';
        newObjScope.Shipper_name__c = '';
        newObjScope.Shipper_postal_address__c ='';
        newObjScope.Shipment_identification__c = '';
        newObjScope.Shipment_number__c ='';
        newObjScope.Invoice_no__c='';
        newObjScope.Invoice_number_from_customer__c ='';
        newObjScope.ForwardingAddress__c = null;
        newObjScope.Deviation_affected_address__c='';
        newObjScope.Change_address_ref_no__c='';
        newObjScope.Reciever_name__c ='';
        newObjScope.Reciever_address__c= null;
       // newObjScope.Sf4twitter__Author_External_Id__c='';
       // newObjScope.Sf4twitter__Twitter_Username__c=''; 
        newObjScope.Entry_Email_Address__c= '';
        newObjScope.Hidden_previous_address__c='';

        newObjScope.Isanonymized__c = true;
 
        if(anonymize_cases.size()>0)  //anonymize_cases[0].queueid!=null
            newObjScope.OwnerId = anonymize_cases.get(0).queueId;
        updatedCaseList.add(newObjScope);//Add records to the List
        idlist.add(newObjScope.id);
        idAccountList.add(newObjScope.AccountId);
        ////system.debug('Value of UpdatedCustomerList '+updatedCaseList);

}//end of for loop

     if (updatedCaseList != null && updatedCaseList.size()>0) {//Check if List is empty or not
         Database.update(updatedCaseList); 
            system.debug('List Size '+updatedCaseList.size());//Update the Records
        }
        
        system.debug('List Size '+updatedCaseList);//Update the Records
      

        //CASE COMMENT - Identifying Case comment on case and delete the comments
        //comList = [SELECT Id,ParentId FROM CaseComment WHERE ParentId =:newObjScope.Id];
        comList = [SELECT Id,ParentId FROM CaseComment WHERE ParentId in : idlist];
        if(comList!=null && comList.size()>0){
            Delete comList;
            Database.EmptyRecycleBin(comList);
            //system.debug('Comlist '+ comlist.size());
        }

        //CONVERSATION - Identifying Conversation from facebook and twitter and delete
       /* convList = [SELECT Id,sf4twitter__Case__c FROM sf4twitter__Twitter_Conversation__c WHERE sf4twitter__Case__c in :idlist];
        if(convList!=null && convList.size()>0){
            Delete convList;
            Database.EmptyRecycleBin(convList);
            //system.debug('convList '+ convList.size());
        }*/

        //EMAILMESSAGE - 
        emailList = [SELECT Id,ParentId FROM Emailmessage WHERE ParentId in :idlist];
        if(emailList!=null && emailList.size()>0){
            Delete emailList;
            Database.EmptyRecycleBin(emailList);
            //system.debug('emailList '+ emailList.size());

        }

        //ATTACHMENT - 
        attList = [SELECT Id,ParentId FROM Attachment WHERE ParentId in :idlist];
        if(attList!=null && attList.size()>0){
            Delete attList;
            Database.EmptyRecycleBin(attList);
            //system.debug('attList '+ attList.size());
        }

       
        
        //Activity HISTORY
        //It is not possible to delete from Case History
        //The idea is considered from SF https://success.salesforce.com/ideaView?id=08730000000JCiz
      
        eventList =[Select id , whatid from Event where what.type='Case' and (isArchived=true or isArchived=false) and whatid in :idlist];
       
        if(eventList !=null && eventList.size()>0){
            Delete eventList;
            Database.EmptyRecycleBin(eventList);
        }

        //CASE FEED
        /* feedList = [SELECT Id,ParentId FROM CaseFeed WHERE ParentId in :idlist];
         System.debug('##feedList '+ feedList );
        if(feedList!=null && feedList.size()>0){
            Delete feedList;
            Database.EmptyRecycleBin(feedList);
            system.debug('feedList '+ feedList.size());
        }*/
        
       

        //TASK
        taskList = [SELECT Id, Whatid FROM Task WHERE WhatId in :idList all rows]; //added all rows
        if(taskList!=null && taskList.size()>0){
            Delete taskList;
            Database.EmptyRecycleBin(taskList);
            //system.debug('taskList '+ taskList.size());
        }
        
        //CASE HISTORY
        //It is not possible to delete from Case History
        //The idea is considered from SF https://success.salesforce.com/ideaView?id=08730000000JCiz
        /*hisList = [SELECT Id,CaseId FROM CaseHistory WHERE CaseId in :idlist];
        if(hisList!=null && hisList.size()>0){
            Delete hisList;
            Database.EmptyRecycleBin(hisList);
        }*/
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
  mail.setSubject('Case cleanup  '+a.Status);
  mail.setPlainTextBody('The Batch Apex job processed  '+a.TotalJobItems+' batches with  '+a.NumberOfErrors+' failures'+'Job Item processed are '+a.JobItemsProcessed);
  Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
  
 // Database.executeBatch(new Case_CleanUpRecords_CaseHistory(),1);
 }//End of finish method. Called after all batches are processed. Use to send confirmation emails or execute post - processing operations.
   

}//End of class