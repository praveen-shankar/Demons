@isTest
private class HelperClassTest {
    @isTest static void testCallout() {
        // Set mock callout class 
        // 
        WebTransferMailBox__c Mbox = new WebTransferMailBox__c();
        Mbox.name = 'WebTransferMailBox';
        Mbox.Username__c = 'Mbox.Username__c';
        Mbox.Password__c = 'password';
        Mbox.Url__c ='https://snqaws.posten.no/Salgsnettservice.asmx/HentEpostForDistrEnhet?PostNr=2008&DistribusjonsType=B';
        insert Mbox;
        
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWebform());
        
        Case c1 = new Case();
        c1.Subject = 'Test Callout';
        c1.PostNumber__c ='2008';
        c1.Webform_customer_input__c ='p:i:flytting_av_postkasse';
        Insert c1;
        List<id> cList = new List<id>();
        cList.add(c1.id);
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
         Helperclass.updateEmailToCase(cList);
        
        
    }
}