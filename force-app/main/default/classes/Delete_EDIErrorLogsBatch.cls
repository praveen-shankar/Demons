global class Delete_EDIErrorLogsBatch implements Database.Batchable<sObject>{

 
   public Database.QueryLocator start(Database.BatchableContext BC){
   
   Date dateobj= System.today().addmonths(-3);
        
    id testid = '500w000000jyHda';
    String query= 'SELECT id, createddate  FROM EDI_LM_Error__c WHERE createddate <= :dateobj order by createddate asc';
    
      return Database.getQueryLocator(query);
    
   
    }//End of start method
    
    global void execute (Database.BatchableContext BC, List<sobject> scope){
     try{
     delete scope;
     }catch(Exception e){}
    
    }
    
    global void finish(Database.BatchableContext BC){
 
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors, a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById, a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId() ];//get the job Id
     String [] email = new String[] {'supriya.goel@capgemini.com'};
      mail.setToAddresses(email);
      mail.setReplyTo('supriya.goel@capgemini.com');//Add here your email address
      mail.setSenderDisplayName('LM Error logs deletion');
      mail.setSubject('LM Error logs deletion '+a.Status);
      mail.setPlainTextBody('The Batch Apex job processed  '+a.TotalJobItems+' batches with  '+a.NumberOfErrors+' failures'+'Job Item processed are '+a.JobItemsProcessed);
      Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    
     }//End of finish method. Called after all batches are processed. Use to send confirmation emails or execute post - processing operations.
       
    
    }//End of class