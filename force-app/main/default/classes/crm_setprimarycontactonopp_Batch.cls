/*
Created By:Supriya Goel
Date:14 th nov 2016
To set opportunity primary contact field  on opportunity

*/

global class crm_setprimarycontactonopp_Batch implements Database.batchable<sObject>,Database.Stateful{
   public string callback = '';  
   
     global crm_setprimarycontactonopp_Batch (String callback){
         this.callback = callback;      
    }
     
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'select id, contactid, Opportunityid, role, isprimary from OpportunityContactRole where isprimary = true'; 
        return Database.getQueryLocator(query);                      
    }
    
     global void execute(Database.BatchableContext BC, List<OpportunityContactRole>  opprole) {
     Map<id,id> oppcontactmap=new Map<id,id>();
         for(OpportunityContactRole con:opprole)
         {
             oppcontactmap.put(con.opportunityid,con.contactid);
         }
         
         List<Opportunity> opptoUpdate=new List<Opportunity>();
         for(id oppid:oppcontactmap.keyset())
         {
             Opportunity o=new opportunity();
             o.id=oppid;
             o.crm_Primary_Opportunity_Contact__c =oppcontactmap.get(oppid);
             opptoUpdate.add(o);
         }
         
         Database.update(opptoUpdate,false);
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
        mail.setSubject('Set Primary contact on opportunity');
        mail.setPlainTextBody(str);
        // Send the email for the developer reference
       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
        
         String jobName='Set Primary contact on opportunity';
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
            
        crm_setprimaryoppcontact_Batch obj = new crm_setprimaryoppcontact_Batch('test');
        /*1min= 60 sec  
        1hr =  60 mins 
        1day  = 60 *24 *15   =  21600 */
        Integer mins= 5;
            
        //schedule a job
        /*if(existingJobs.isEmpty()){
            try{ 
                System.scheduleBatch(obj , jobName, mins,200); 
             }catch(Exception e) {      }
        
        } */
        if(!Test.IsRunningTest())
        Database.executebatch(obj);
        }
  }