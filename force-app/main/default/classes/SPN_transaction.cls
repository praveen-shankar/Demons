// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
/**
Schedule class that sends daily SPN transaction to Visma
*/
global class SPN_transaction implements Schedulable {

    public static final String APEX_JOB_NAME = 'SPN Daily Transactions';
    public static String CRON_EXP = '0 10 0 * * ?';


    global void execute(SchedulableContext sc){

    /**
    Creating the list of yesterdays SPN transactions. 
    Parameters:
    Transaksjon__r.status__c = 'Avsluttet'(SPN is the only transactions that have this status)
    Transaksjon__r.Transaction_approved_date__c = YESTERDAY (Transactions need to be approved)
    */
    String header = System.Label.cs_CSVHeader;
    string finalstr = header ;
    String recordString='';
    
    List<Monetary_Transaction_Line_Item__c> mtliList = new List<Monetary_Transaction_Line_Item__c>();
    mtliList = [SELECT
                Transaksjon__r.status__c,
                Transaksjon__r.Bank_Account_Number__c,
                Transaksjon__r.Transaction_approved_date__c,
                Transaksjon__r.case__r.caseNumber,
                Transaksjon__r.case__r.account.crm_customer_number__c,
                Transaksjon__r.case__r.account.name,
                Name,
                Line_Amount__c,
                Description__c,
                Regress_Account__r.Transaksjonskontakt__r.Email,
                Regress_Account__r.crm_customer_number__c,
                Regress_Account__r.Name,
                Type__c,
                vare_number_NAV__r.name,
                cargo_division_code__r.unit_number_in_subsidiary__c
                  FROM Monetary_Transaction_Line_Item__c
                 WHERE Transaksjon__r.status__c = 'Avsluttet'
                   AND Transaksjon__r.Transaction_approved_date__c = YESTERDAY
                  AND  Transaksjon__r.IsHDTranscation__c =false
                ORDER BY Transaksjon__r.Transaction_approved_date__c desc
               ];
    
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
                   + mt.Regress_Account__r.crm_customer_number__c + ';'
                   + mt.Regress_Account__r.Name + ';'
                   + mt.Name + ';'
                   + mt.Line_Amount__c + ';'
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
                   + mt.Transaksjon__r.case__r.account.crm_customer_number__c + ';'
                   + mt.Transaksjon__r.case__r.account.name + ';'
                   + mt.Name + ';'
                   + mt.Line_Amount__c + ';'
                   + mt.Description__c + ';'
                   + mt.Regress_Account__r.Transaksjonskontakt__r.Email + ';'
                   + mt.Type__c + ';'
                   + mt.vare_number_NAV__r.name +';'
                   + mt.cargo_division_code__r.unit_number_in_subsidiary__c+'\n';
                 
            }
                
               finalstr = '\uFEFF'+ finalstr + recordString; 
        }
        
        /**
        Creating the message
        */
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        Date mydate = date.today()-1;
        string csvname= 'SPN-transaksjoner.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        //String[] toAddresses = new list<string> {'katsforvaltning.no@capgemini.com'};
        //String[] ccaddresses = new list<string> {'katsforvaltning.no@capgemini.com'};
       /*String[] toAddresses = new list<string> {'norway.post.customer.service@visma.com'};
        String[] ccaddresses = new list<string> {'finn.gronas@posten.no','katsforvaltning.no@capgemini.com'};*/  //Commented on 27/04/2018
        
        //Custom Settings for Addresses
        
        String[] ccaddresses = new List<String>();
        SPN_Transcation__c listOfAddresses = [select name,EmailAddress__c from SPN_Transcation__c where name ='ccAddress'];
        ccaddresses = listOfAddresses.EmailAddress__c.split(',');
    
        String[] toaddresses = new List<String>();
        listOfAddresses = [select name,EmailAddress__c from SPN_Transcation__c where name ='toAddress'];
        toaddresses = listOfAddresses.EmailAddress__c.split(',');

            
        String subject ='KATS '+ mydate;
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setCcAddresses(ccaddresses);
        email.setPlainTextBody(System.Label.cs_DailySNP);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }else{
        /**
        Creating the message
        */
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        Date mydate = date.today()-1;
        string csvname= 'SPN-transaksjoner.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        /*String[] toAddresses = new list<string> {'katsforvaltning.no@capgemini.com'};
        String[] ccaddresses = new list<string> {'katsforvaltning.no@capgemini.com'};*/  //Commented on 27/04/2018
        //String[] toAddresses = new list<string> {'norway.post.customer.service@visma.com'};
        //String[] ccaddresses = new list<string> {'finn.gronas@posten.no','katsforvaltning.no@capgemini.com'};
        
        //Custom Settings for Addresses
       
        String[] ccaddresses = new List<String>();
        SPN_Transcation__c listOfAddresses = [select name,EmailAddress__c from SPN_Transcation__c where name ='ccAddressElse'];
        ccaddresses = listOfAddresses.EmailAddress__c.split(',');

        String[] toaddresses = new List<String>();
        listOfAddresses = [select name,EmailAddress__c from SPN_Transcation__c where name ='toAddressElse'];
        toaddresses = listOfAddresses.EmailAddress__c.split(',');

        
        String subject ='KATS '+ mydate;
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setCcAddresses(ccaddresses);
        email.setPlainTextBody(System.Label.cs_NoTransaction);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        } 

    }/** END OF global void execute(SchedulableContext sc) */

    static public void startSpnTransactionScheduler(){      
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        // Runs 00:10 every night
        
        System.schedule('SPN_Transactions',CRON_EXP, new SPN_transaction());
    } /** END OF static public void startSPNTransactionScheduler */

}