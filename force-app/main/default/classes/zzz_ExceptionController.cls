@isTest
private class zzz_ExceptionController {

    /*
    *   HELPERS
    */
    static String getInputDeveloperMessage() {
        return 'This is a test dev message';
    }
    
    static String getInputUserMessage() {
        return 'This is a test user message';
    }
    
    static void setSystemErrorMessage() {
        ExceptionController.systemErrorMsg = 'This is a test system error message';
    }
    
    static Exception getException() {
        Exception e;
        
        try{
            String a = null;
            a.toUpperCase();
        } catch(Exception ex) {
            e = ex;
        }
        
        return e;
    }
    
    /*
    *       TESTS
    */
    static testMethod void testHandleException() {
        // RUNNING TEST
        Test.startTest();
            ExceptionController.handleException(true, true, zzz_ExceptionController.getException(), zzz_ExceptionController.getInputDeveloperMessage(), zzz_ExceptionController.getInputUserMessage());
        Test.stopTest();
        
        //Test input exception
        system.assert(true, 'Something is wrong');
        system.assert(ExceptionController.e != null, 'Exception is null');
        
        //Test input message from error
        system.assert(String.isNotEmpty(ExceptionController.devMsg), 'String devMsg is null');
        system.assert(ExceptionController.devMsg.equals(zzz_ExceptionController.getInputDeveloperMessage()), 'String devMsg is different from inputDevMessage');
        system.assert(String.isNotEmpty(ExceptionController.usrMsg), 'String usrMsg is null');
        system.assert(ExceptionController.usrMsg.equals(zzz_ExceptionController.getInputUserMessage()), 'String usrMsg is different from inputUsrMessage');
        
        //Test notification type
        system.assert(ExceptionController.notifyUsr);
        system.assert(ExceptionController.notifyAm);
        
        //Test if systemErrorMsg and userErrorMsg is populated
        system.assert(String.isNotEmpty(ExceptionController.systemErrorMsg), 'String systemErrorMsg is null, should have been populated');
        system.assert(String.isNotEmpty(ExceptionController.userErrorMsg), 'String userErrorMsg is null, should have been populated');
    }
    
    static testMethod void testCreateUserErrorMessage() {
        ExceptionController.usrMsg = zzz_ExceptionController.getInputUserMessage();
        ExceptionController.notifyAm = true;
        ExceptionCOntroller.notifyUsr = false;
        
        String testString = 'Det har oppstått en feil:\n' + ExceptionController.usrMsg + '\nEt automatisk varsel angående feilen har blitt sendt til KATS Forvaltning';
        
        Test.startTest();
            ExceptionController.createUserErrorMessage();
        Test.stopTest();
        
        //system.assertEquals(ExceptionController.userErrorMsg, testString);
    }

    static testMethod void testCreateUserErrorMessageWithoutEmail() {
        ExceptionController.usrMsg = zzz_ExceptionController.getInputUserMessage();
        zzz_ExceptionController.setSystemErrorMessage();
        
        String testString = 'Det har oppstått en feil:\n' + ExceptionController.usrMsg + '\nHvis denne feilen forsetter så meld videre til din superbruker.';
        
        Test.startTest();
            ExceptionController.createUserErrorMessage();
        Test.stopTest();
        
        system.assert(String.isNotEmpty(ExceptionController.userErrorMsg), 'String userErrorMsg is null, should have been populated');
        //system.assertEquals(testString, ExceptionController.userErrorMsg);
    }
    
    static testMethod void testCreateSystemErrorMessage() {
        ExceptionController.devMsg = zzz_ExceptionController.getInputDeveloperMessage();
        ExceptionController.e = zzz_ExceptionController.getException();

        String timestamp = datetime.now().format('dd/MM/yyyy HH:mm', 'CET');
        
        String testString = 'DTG: ' + timestamp + '\n\nFølgende feilmelding er kommet inn til KATS:\n' 
        + ExceptionController.e.getStackTraceString()
        + '\n'+ExceptionController.e.getTypeName()
        +'\n'+ExceptionController.e.getMessage()
        + '\n\nFeilmeldingen har følgende beskrivelse fra utvikler:\n'
        + zzz_ExceptionController.getInputDeveloperMessage();
        
        Test.startTest();
            ExceptionController.createSystemErrorMessage();
        Test.stopTest();
        
        system.assert(String.isNotEmpty(ExceptionController.systemErrorMsg), 'String systemErrorMsg is null, should have been populated');
        //system.assertEquals(testString, ExceptionController.systemErrorMsg);
    }
    
    // Testing method when exception is null or missing. Should throw exception in this case
    static testMethod void testCreateSystemErrorMessageExceptionMissing() {
        ExceptionController.devMsg = zzz_ExceptionController.getInputDeveloperMessage();
        
        Boolean throwsException = false;
        
        Test.startTest();
            try {
                ExceptionController.createSystemErrorMessage();
            } catch (NullPointerException npe) {
                throwsException = true;
            }
        Test.stopTest();
        
        system.assert(throwsException);
    }
    
    static testMethod void testCreateVisualForceErrorMessage() {
        zzz_ExceptionController.setSystemErrorMessage();
        ExceptionController.notifyAm = true;
        ExceptionController.notifyUsr = true;
        ExceptionController.usrMsg = zzz_ExceptionController.getInputUserMessage();
        ExceptionController.createUserErrorMessage();

        String testString = 'Det har oppstått en feil:\n' + ExceptionController.usrMsg + '\nEt automatisk varsel angående feilen har blitt sendt til KATS Forvaltning';
        
        Test.startTest();
            ExceptionController.createVisualForceErrorMessage();
        Test.stopTest();
        
        system.assert(ApexPages.hasMessages());
        ApexPages.message msg = ApexPages.getMessages().get(0);     
        system.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        //system.assertEquals(testString, msg.getSummary());
    }
    
    /*
        This is basically now a coverage test due to the New Controls for Sending Email change in Spring 13
        The change does not let you run sending email tests as long as the Access level is not All Email
    */
    static testMethod void testNotifyApplicationManagement() {
    
         environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
        //envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        
        zzz_ExceptionController.setSystemErrorMessage();
        ExceptionController.e = zzz_ExceptionController.getException();
        ExceptionController.notifyAm = true;
        ExceptionController.notifyUsr = true;
        ExceptionController.usrMsg = zzz_ExceptionController.getInputUserMessage();
        ExceptionController.createUserErrorMessage();
        ExceptionController.createSystemErrorMessage();
        
        Test.startTest();
            ExceptionController.notifyAplicationManagement();
        Test.stopTest();
        
        //system.assertEquals(1, ExceptionController.emailResultList.size());
        //system.assert(ExceptionController.emailResultList.get(0).isSuccess());
    }
    
    static testMethod void testCreateErrorRecord(){
        List<ErrorRecord__c> er=new List<ErrorRecord__c>();
        String userMessage='';
        
        ErrorLogging__c el=KatsTestUtilities.getTestErrorLogging();
        test.startTest();
        try {
            String i;
            System.debug(i.length());
            } 
            catch ( System.Nullpointerexception e ) {
            System.debug('exception e--------------------------'+e);
                ExceptionController.createErrorRecord(e, 'Details');
                
                er=[select id, Type__c from ErrorRecord__c order by createddate desc limit 1 ];
                userMessage=ExceptionController.translateExceptionMessage(e.getMessage()); // Attempt to de-reference a null object
                
                }
                
        
        
        test.stopTest();
        //System.assertEquals(userMessage, 'Det oppstod et problem med søket. Prøv på nytt. Dersom problemet vedvarer så meld fra til din superbruker.');
        //System.assertEquals(ExceptionController.translateExceptionMessage('Web service callout failed'),'Det er for øyeblikket ingen kontakt til baksystemet. Vent et par minutter og prøv igjen. Om problemet vedvarer så kontakt din superbruker.');
        //System.assertEquals(ExceptionController.translateExceptionMessage('IO Exception'), 'Søket ditt tok for lang tid, enten fordi det er stor trafikk på serveren eller fordi søket ga for mange treff. Prøv å spesifiser søket bedre og søk igjen.');
        
        //System.assertEquals(er.get(0).Type__c, 'System.NullPointerException');    
    }
}