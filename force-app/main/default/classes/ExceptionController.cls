/*
*   This class is used to help give better feedback to the user and the application management team
*
*   Example of use:

        try{
            String a = null;
            a.toUpperCase();
        } catch(Exception e,) {
            //Notifies both AM and User
            ExceptionController.handleException(true, true, e,
                'Det oppsto en feil da man forsøkte å gjøre om teksten til store bokstaver',
                'Feil det oppsto en feil i metode xxx da man forsøkte å gjøre yyy, saksnummer: ' + c.caseNumber
            );
        }

notifyUser
notifyAM

*
*/

public class ExceptionController {
    
    public static boolean notifyUsr = false;
    public static boolean notifyAm = false;
    public static Exception e;
    public static String devMsg = '';
    public static String usrMsg = '';
    public static String systemErrorMsg = '';
    public static String userErrorMsg = '';
    
    public static List<Messaging.SendEmailResult> emailResultList; //Mostly for testing purposes


    public class KATSexception extends Exception {}

    /*
    * "Main" method that creates error messages and notifies users and developers
    */
    public static void handleException(boolean notifyUser, boolean notifyAplicationManagement, Exception ex, String devMessage, String userMessage) {
        ExceptionController.notifyUsr = notifyUser;
        ExceptionController.notifyAm = notifyAplicationManagement;
        ExceptionController.e = ex;
        ExceptionController.devMsg = devMessage;
        ExceptionController.usrMsg = userMessage;
        
        ExceptionController.createSystemErrorMessage();
        ExceptionController.createUserErrorMessage();
        
        if(notifyAm) {
            ExceptionController.notifyAplicationManagement();
        }
        
        if(notifyUsr) {
            ExceptionController.createVisualForceErrorMessage();
        }
    }

    /*
    * Sends an email to katsforvaltning.no@capgemini.com
    */
    public static void notifyAplicationManagement() {
        String content = '';
        
        content += ExceptionController.systemErrorMsg;
        
        if(notifyUsr) {
          //  content += '\n\nBruker har mottatt en formatert feilmelding:\n' + ExceptionController.userErrorMsg;
          //Csphase2 supriya 27122016
          content += '\n\n'+System.label.cs_user_formatted_error+':\n' + ExceptionController.userErrorMsg;
        } else {
            content += '\n\n'+System.label.cs_user_formatted_error;
        }
        
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
        mail.setSenderDisplayName('KATS');
       
        mail.setSubject('KATS Exception');
        mail.setPlainTextBody(content);
        
        /*
            This had to be implemented due to the New Controls for Sending Email change in Spring 13
            This change does not let you run sending emails in tests as long as the Access level is not All Email
        */
        if(Test.isRunningTest() == false) {
            emailResultList = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    /*
    * Adds the user error message to a Visual Force Page Message
    */
    public static void createVisualForceErrorMessage() {
        ApexPages.message msg = new ApexPages.message(ApexPages.Severity.ERROR, ExceptionController.userErrorMsg);
        KATSutilities.addMessage(msg);
    }
    
    /*
    * Create a text string that contains tecnical data
    */
    public static void createSystemErrorMessage() {
        String errorMsg = '';
        errorMsg += 'DTG: ' + datetime.now().format('dd/MM/yyyy HH:mm', 'CET');
       // errorMsg += '\n\nFølgende feilmelding er kommet inn til KATS:\n' + e.getStackTraceString();
       //Csphase2 Supriya 27122016
       errorMsg += '\n\n'+System.label.cs_error_message_received_by_kats+'\n' + e.getStackTraceString();
        errorMsg+= '\n'+e.getTypeName();
        errorMsg+='\n'+e.getMessage();
        if(String.isNotBlank(ExceptionController.devMsg)) {
            //errorMsg += '\n\nFeilmeldingen har følgende beskrivelse fra utvikler:\n' + ExceptionController.devMsg;
            //Csphase2 Supriya 27122016
            //errorMsg += '\n\n'+System.label.cs_error_message_has_desc_developer+':\n' + ExceptionController.devMsg; 
        }
        ExceptionController.systemErrorMsg = errorMsg;
    }
    
    /*
    * Create a text string that is displayed to the user
    */
    public static void createUserErrorMessage() {
        String errorMsg = '';
        errorMsg += 'Det har oppstått en feil';

        if(String.isNotBlank(ExceptionController.usrMsg)) {
            errorMsg += ':\n' + ExceptionController.usrMsg;
        }
        
        if(notifyAm) {
           // errorMsg += '\nEt automatisk varsel angående feilen har blitt sendt til KATS Forvaltning';
           //Csphase2 supriya 27122016
           errorMsg += '\n'+ System.label.cs_automatic_warning_msg;
        } else {
            //errorMsg += '\nHvis denne feilen forsetter så meld videre til din superbruker.';
            // Csphase2 supriya 27122016
            errorMsg += '\n' + System.label.cs_error_sign_in;
        }
        
        ExceptionController.userErrorMsg = errorMsg;
    }
    
    /* Methods for saving exception information in KATS */
    public static void createErrorRecord(Exception ex, String details){
        boolean loggingIsOn=false;
        if(ErrorLogging__c.getInstance('Default')!=null){
            loggingIsOn=ErrorLogging__c.getInstance('Default').on__c;
        }
        
        if(loggingIsOn && ex!=null){
            ErrorRecord__c er=new ErrorRecord__c();     
            er.Message__c=(ex.getMessage().length()>255 ? ex.getMessage().left(255): ex.getMessage());
            er.StackTrace__c= (ex.getStackTraceString().length()>32768 ? ex.getStackTraceString().left(32768): ex.getStackTraceString());
            er.Type__c=(ex.getTypeName().length()>255 ? ex.getTypeName().left(255): ex.getTypeName());
            if(details!=null)
                er.Details__c=(details.length()>32768 ? details.left(32768) : details);
            insert er;
        }
    }
   
    /* Helper method that translates known exception messages to understandable information for user. */
    public static String translateExceptionMessage(String ex){  
        String translation='';
        if(ex==null) {return translation;}
        // Web service callout failed or IO Exception
        if(ex.startsWith('Web service callout failed')) 
            //translation='Det er for øyeblikket ingen kontakt til baksystemet. Vent et par minutter og prøv igjen. Om problemet vedvarer så kontakt din superbruker.';
            //Csphase2 Supriya 27122016
            translation=System.Label.cs_no_contact_to_central_pc;
        else if (ex.startsWith('IO Exception')) 
            //translation='Søket ditt tok for lang tid, enten fordi det er stor trafikk på serveren eller fordi søket ga for mange treff. Prøv å spesifiser søket bedre og søk igjen.';
            translation=system.label.cs_search_took_too_longer;
        else
           // translation='Det oppstod et problem med søket. Prøv på nytt. Dersom problemet vedvarer så meld fra til din superbruker.';
           translation=System.label.cs_problem_in_search;
        return translation;
    }
    
}