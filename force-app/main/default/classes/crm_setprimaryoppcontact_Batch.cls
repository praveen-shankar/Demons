/*
Created By:Supriya Goel
Date:14 th nov 2016
To set opportunity primary contact field  on opportunity

*/

global class crm_setprimaryoppcontact_Batch implements Database.batchable<sObject>,Database.Stateful{
   public string callback = '';  
   
     global crm_setprimaryoppcontact_Batch(String callback){
         this.callback = callback;      
    }
     
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select id, crm_Primary_Opportunity_Contact__c from Opportunity where crm_Primary_Opportunity_Contact__c!=null'; 
        return Database.getQueryLocator(query);                      
    }

    global void execute(Database.BatchableContext BC, List<Opportunity>  opplist) {
            set<id> OppIds= new Set<Id>();
            for (Opportunity opp: opplist){
                OppIds.add(opp.id);
                }
            
    Map<Id, List<OpportunityContactRole>> Opp_OCR = new Map<Id, List<OpportunityContactRole>>(); 
    List<OpportunityContactRole> oppcontRolelist=new List<OpportunityContactRole>();
    oppcontRolelist=[select id, contactid, Opportunityid, role, isprimary,opportunity.Accountid,Contact.Accountid,contact.Account.Parentid from OpportunityContactRole where opportunityid in:OppIds and isprimary = true];
    System.debug('@@@oppcontRolelist@@'+oppcontRolelist);
    for(opportunitycontactrole orc: oppcontRolelist)
    {
    System.debug('@@@orc32@@'+orc);
    System.debug('@@@ocr33@@'+orc.opportunity.Accountid+'@@@@ocrContctid'+orc.Contact.Accountid);
        if(orc.opportunity.Accountid==orc.Contact.Accountid || orc.opportunity.Accountid==orc.contact.Account.Parentid)
        {
        List<OpportunityContactRole> tmp_orc = new List<OpportunityContactRole>(); 
        tmp_orc = Opp_OCR.get(orc.Opportunityid); 
        if (tmp_orc == null) {
            Opp_OCR.put(orc.opportunityid, new List<OpportunityContactRole>{orc});
        } 
         else { 
         
            tmp_orc.add(orc); 
            Opp_OCR.put(orc.opportunityid, tmp_orc); 
             }
          }
          
          else
          {
           Opp_OCR.put(orc.opportunityid, null);
           System.debug('@@@opportunityid@@@'+orc.opportunityid);
           system.debug('insideelse');
           }
        } 
        System.debug('@@@Opp_OCR@@'+Opp_OCR);
         Map<id, boolean> PrimarycontactMap = new Map<id, boolean>();
        for (Opportunity opps : oppList) { 
            List<OpportunityContactRole> this_OCR = new List<OpportunityContactRole>(); 
            this_OCR = Opp_OCR.get(opps.id); 
            If(opps.id=='00625000005Lgov')
            {
            System.debug('@@@@opps@@'+opps);
            System.debug('@@@@this_OCR @@@'+this_OCR );
            }
            System.debug('@@@@opps63@@'+opps.id);
            System.debug('@@@@this_OCR63 @@@'+this_OCR );
            if (this_OCR == null){
                opps.crm_Primary_Opportunity_Contact__c= null; 
                PrimarycontactMap.put(opps.id, false); 
            }
            else {  
            
                for (OpportunityContactRole r : this_OCR) { 
                    if (r.isprimary) {
                        opps.crm_Primary_Opportunity_Contact__c= r.contactid;
                        PrimarycontactMap.put(opps.id, true);
                    }
                }  
            } 
        }
            if(opplist.size()>0){
            try{
                Database.update(opplist,false);
               }catch(Exception e) {   crm_Exception_handler.createExceptionRecords(e);  }
     
        } //end of size
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
       /* if(existingJobs.isEmpty()){
            try{ 
                System.scheduleBatch(obj , jobName, mins,200); 
             }catch(Exception e) {      }
        
        } */
        //Database.executebatch(new crm_setprimarycontactonopp_Batch('test'));
  } 

}