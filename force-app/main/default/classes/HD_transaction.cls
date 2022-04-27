/*Schedule class that sends daily HD transactions to Visma
*/
global class HD_transaction implements Schedulable {

    public static final String APEX_JOB_NAME = 'HD Daily Transactions';
    public static String CRON_EXP = '0 25 0 * * ?';
   

    global void execute(SchedulableContext sc){

    /**
    Creating the list of yesterdays SPN transactions. 
    Parameters:
    Transaksjon__r.status__c = 'Avsluttet'(SPN is the only transactions that have this status)
    Transaksjon__r.Transaction_approved_date__c = YESTERDAY (Transactions need to be approved)
    */
    String header = System.Label.cs_CSVNPBHeader;
    string finalstr = header ;
    String recordString='';
    
    List<Monetary_Transaction_Line_Item__c> mtliList = new List<Monetary_Transaction_Line_Item__c>();
    mtliList = [SELECT
                Transaksjon__r.status__c,
                Transaksjon__r.Bank_Account_Number__c,
                Transaksjon__r.Transaction_approved_date__c,
                Transaksjon__r.case__r.caseNumber,
                Transaksjon__r.case__r.Service_Product__r.Name,
                Transaksjon__r.case__r.account.crm_customer_number__c,
                Transaksjon__r.case__r.account.name,
                Article_Number__c,
                Name,
                Line_Amount__c,
                Description__c,
                Transaksjon__r.Reference__c,
                cs_Accounting_Unit__c,
                Regress_Account__r.Transaksjonskontakt__r.Email,
                Regress_Account__r.crm_customer_number__c,
                Regress_Account__r.Name,
                Type__c,
                vare_number_NAV__r.name,
                cargo_division_code__r.unit_number_in_subsidiary__c
                 FROM Monetary_Transaction_Line_Item__c  WHERE
                 Transaksjon__r.status__c = 'Avsluttet' 
                 AND Transaksjon__r.Transaction_approved_date__c = YESTERDAY
                 AND Transaksjon__r.IsHDTranscation__c =true
                ORDER BY Transaksjon__r.Transaction_approved_date__c desc
               ];
    finalstr = finalstr + '\n'+recordString; // '\uFEFF'+
    if(mtliList.size()>0)
    {
    /**
    Creating the file
    */
    
        for(Monetary_Transaction_Line_Item__c mt: mtliList)
        {
            if(mt.Type__c == 'Regress'){
                recordString = mt.Transaksjon__r.status__c + ';'
                   + mt.Transaksjon__r.Bank_Account_Number__c + ';'
                   + mt.Transaksjon__r.Transaction_approved_date__c + ';' 
                   + mt.Transaksjon__r.case__r.caseNumber + ';' 
                   + mt.Transaksjon__r.case__r.Service_Product__r.Name+';'
                   + mt.Regress_Account__r.crm_customer_number__c + ';'
                   + mt.Regress_Account__r.Name + ';' 
                   + mt.Name + ';'
                   + mt.Article_Number__c + ';'
                   + mt.Line_Amount__c + ';'
                   + mt.Transaksjon__r.Reference__c.replaceall(',' ,' ') + ';'
                   + mt.Description__c + ';'
                   + mt.Regress_Account__r.Transaksjonskontakt__r.Email + ';'
                   + mt.Type__c + ';'
                   + mt.vare_number_NAV__r.name +';'
                   + mt.cargo_division_code__r.unit_number_in_subsidiary__c+'\n';
            }else {
                recordString = mt.Transaksjon__r.status__c + ';'
                   + mt.Transaksjon__r.Bank_Account_Number__c + ';'
                   + mt.Transaksjon__r.Transaction_approved_date__c + ';'
                   + mt.Transaksjon__r.case__r.caseNumber + ';'  
                   + mt.Transaksjon__r.case__r.Service_Product__r.Name + ';'
                   + mt.Transaksjon__r.case__r.account.crm_customer_number__c + ';'
                   + mt.Transaksjon__r.case__r.account.name + ';'
                   + mt.Name + ';'
                   + mt.Article_Number__c + ';'
                   + mt.Line_Amount__c + ';'
                   + mt.Transaksjon__r.Reference__c.replaceall(',' ,' ') + ';'
                   + mt.Description__c + ';'
                   + mt.Regress_Account__r.Transaksjonskontakt__r.Email + ';'
                   + mt.Type__c + ';'
                   + mt.vare_number_NAV__r.name +';'
                   + mt.cargo_division_code__r.unit_number_in_subsidiary__c+'\n';
                 
            }
                
               finalstr +=  recordString; 
        }
        
        /**
        Creating the message
        */
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        Date mydate = date.today()-1;
        string csvname= 'HD-transaksjoner.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
         List < string > toAddress = new List < string > ();
        environment_settings__c emailnotifications = environment_settings__c.getValues('BatchEmailNotification');
        List < String > valuesList1 = new List < String > ();
        if (emailnotifications != null && emailnotifications.value__c != null) 
        valuesList1 = emailnotifications.value__c.split(',');
     
         for (String emailuser:valuesList1 )
              toAddress.add(emailuser);  
       //below code will send an email to User about the status
        email.setToAddresses(toAddress);
        String subject ='KATS '+ mydate;
        email.setSubject(subject);
        email.setPlainTextBody(System.Label.cs_DailyHD);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
    else{
        /**
        Creating the message
        */
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        Date mydate = date.today()-1;
        string csvname= 'HD-transaksjoner.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
          List < string > toAddress = new List < string > ();
        environment_settings__c emailnotifications = environment_settings__c.getValues('BatchEmailNotification');
        List < String > valuesList1 = new List < String > ();
        if (emailnotifications != null && emailnotifications.value__c != null) 
        valuesList1 = emailnotifications.value__c.split(',');
     
        for (String emailuser:valuesList1 )
             toAddress.add(emailuser);  
       //below code will send an email to User about the status
        email.setToAddresses(toAddress);
        String subject ='KATS '+ mydate;
        email.setSubject(subject);
        email.setPlainTextBody(System.Label.cs_NoTransaction);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        } 

    }/** END OF global void execute(SchedulableContext sc) */

    static public void startHDTransactionScheduler(){      
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        // Runs 12:25 every night
        
        System.schedule('HD_Transactions',CRON_EXP, new HD_transaction());
    } /** END OF static public void startSPNTransactionScheduler */

}