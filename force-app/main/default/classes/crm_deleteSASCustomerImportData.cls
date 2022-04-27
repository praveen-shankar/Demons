/*
Created By:Akshata Asukar
Date: 28 July 2016 (Sprint 5)
delete records from Temp data
*/

global class crm_deleteSASCustomerImportData implements Database.batchable<sObject>,Database.Stateful {
    public string callback = '';     
    global crm_deleteSASCustomerImportData(String callback){
         this.callback = callback;      
    }
    //get all processed data 
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT crm_Processed__c FROM crm_SAS_Customer_Import__c WHERE crm_Processed__c= true';
        return Database.getQueryLocator(query);                      
    }

      
    global void execute(Database.BatchableContext BC, List<crm_SAS_Customer_Import__c> sas_import) {    
        try{   
            delete sas_import;
           }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e); }
   }
                   
    global void finish(Database.BatchableContext BC) {
    
        String str = '';
        AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
        
        if(callback != '' && callback != null)
           str += callback + '\n';
        if(a != null && a.size() > 0){
                    str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
        }
        
        //send mail 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List < string > toAddress = new List < string > ();
        environment_settings__c emailnotifications = environment_settings__c.getValues('BatchEmailNotification');
        List < String > valuesList1 = new List < String > ();
        if (emailnotifications != null && emailnotifications.value__c != null) 
        valuesList1 = emailnotifications.value__c.split(',');
     
       for (String emailuser:valuesList1 )
            toAddress.add(emailuser);  
       //below code will send an email to User about the status
        mail.setToAddresses(toAddress);
        mail.setSenderDisplayName('Posten');
        mail.setSubject('Summary for all the temp data deletion');
        mail.setPlainTextBody(str);
        
        // Send the email for the developer reference
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
        
         String jobName='Delete Revenue Line and SAS import temp data';
         List<CronTrigger> existingJobs = [Select Id 
                                              From CronTrigger 
                                              Where CronJobDetail.Name = :jobName
                                              And CronJobDetail.JobType = '7' 
                                              And State IN ('ERROR','DELETED') 
                                              And NextFireTime = null
                                              And TimesTriggered > 0];
            
            //Abort the already scheduled jobs
            for(CronTrigger c : existingJobs)
                System.abortJob(c.Id);
            
        crm_deleteRevenuelineTempData obj = new crm_deleteRevenuelineTempData();
        /*1min= 60 sec  
        1hr =  60 mins 
        1day  = 60 *24 *15   =  21600 */
        Integer mins= 21600;
            
        //schedule a job
        if(existingJobs.isEmpty()){
            try{ 
                System.scheduleBatch(obj , jobName, mins,2000); 
             }catch(Exception e) {      crm_Exception_handler.createExceptionRecords(e); }
        
        } 
  } 

}