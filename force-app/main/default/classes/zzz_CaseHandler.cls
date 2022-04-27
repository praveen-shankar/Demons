/*
################################################################################
#                                                                              #
#  This test class will be used to cover the apex class: CaseHandler           # 
#  CaseHandler class is used to handle all the emails received for checking    #
#  and autoclosing the case.                                                   #
#                                                                              #
#  Created on: 09-Feb-2015                                                     #
#  Created by: Rohit Paul                                                      #
#                                                                              #
################################################################################
*/

@isTest
private class zzz_CaseHandler 
{
    // This method will test for a standard success scenario
    static testMethod void Test1_Success()
    {
        // Creating a sample case to close using this process
        Case test1 = new Case();
        test1.subject = 'Test 1';
        test1.origin = 'Telefon';
        Database.insert(test1);
        
        
        // Fetching information from the newly created case
        Case toTest = [SELECT Id, case_referens__c, CaseNumber FROM Case WHERE Id = :test1.Id];
        
        // Creating new Email Body
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Lukking av sak {' + toTest.CaseNumber + '} ' + toTest.case_referens__c;
        email.fromAddress = 'Test@test.com';
        email.plainTextBody = 'This is a test. Please close the case';    
        
        // Creating new Email envelope
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'Test@test.com';
        envelope.toAddress = 'noreply@salesforce.com';
        
        // Creating an instance of the Controller to run the function
        CaseHandler ch1 = new CaseHandler();
        
        Test.startTest();

        ch1.handleInboundEmail(email,envelope);

        Test.stopTest();
    }

    
    // This method will test for a fail scenario when we are not able to find the case. 
    // The program will throw an exception
    static testMethod void Test2_Fail()
    {
        // Creating a new random Email Body without any actual email reference
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        //This is a fixed value which will not match any case in the test
        email.subject = 'Lukking av sak {0399987} [ ref:_00D118Sad._500114HmLS:ref ]';
        email.fromAddress = 'Test@test.com';
        email.plainTextBody = 'This is a test. Please close the case';    
        
        // Creating new Email envelope
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        envelope.fromAddress = 'Test@test.com';
        envelope.toAddress = 'noreply@salesforce.com';
        
        // Creating an instance of the Controller to run the function
        CaseHandler ch1 = new CaseHandler();
        
        Test.startTest();

        ch1.handleInboundEmail(email,envelope);

        Test.stopTest();
    
    }    
}