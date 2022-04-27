// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest
private class zzz_embed_caseDetail {

    static Case getCaseWithBusinessAccount() {
        Account acc = new Account(Name='Test Business Account');
        acc.crm_customer_number__c = 'TEST1234567';
        acc.RecordTypeId = KATSutilities.getRecordType('business_account');
        insert acc;
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.view_Backend_Invoices__c = true;
        insert c;
        
        return c;
    }
    
    static Case getCaseWithPrivateAccount() {
        Account acc = new Account(FirstName='Test', LastName='Person Account');
        acc.crm_customer_number__c = 'TEST-2-1234567';
        acc.RecordTypeId = KATSutilities.getRecordType('person_account');
        insert acc;
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.view_Backend_Invoices__c = true;
        insert c;
        
        return c;
    }
    
    static Case getCaseWithoutAccountPartyNumber() {
        Account acc = new Account(FirstName='Test', LastName='Person Account');
        acc.crm_customer_number__c = '';
        acc.RecordTypeId = KATSutilities.getRecordType('person_account');
        insert acc;
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.view_Backend_Invoices__c = true;
        insert c;
        
        return c;
    }
    
    static Case getCaseWithoutAccount() {
        Case c = new Case();
        c.view_Backend_Invoices__c = true;
        insert c;
        
        return c;
    }
    
    
    static Case getCaseChangeAddress() {
        Account acc = new Account(FirstName='Test', LastName='Person Account');
        acc.crm_customer_number__c = 'TEST-2-1234567';
        acc.RecordTypeId = KATSutilities.getRecordType('person_account');
        insert acc;
        
        Case c = new Case(change_address_ref_no__c = 'ReferenceOMA');
        c.RecordTypeId = KATSutilities.getRecordType('change_address_case');
        c.AccountId = acc.Id;
        c.view_Backend_Invoices__c = true;
        insert c;
        
        return c;
    }
    
    static testMethod void testCaseWithoutAccount()
    {
        Case c = getCaseWithoutAccount();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);

        try
        {
            embed_caseDetail cde = new embed_caseDetail(sc);
        }
        catch(embed_caseDetail.EmbededCaseDetailException e)
        {
            system.assert(e.getMessage().contains('Kunde mangler'));
        }
    }

    static testMethod void testPrivateAccount(){
        Case c = getCaseWithPrivateAccount();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        embed_caseDetail cde = new embed_caseDetail(sc);
        
        //system.assert(cde.customertype == 'person_account','Customer type is: ' + cde.customertype);
    }
    
    static testMethod void testBusinessAccount(){
        Case c = getCaseWithBusinessAccount();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        embed_caseDetail cde = new embed_caseDetail(sc);
        
        //system.assert(cde.customertype == 'business_account');
    }
    
    static testMethod void testAccountWithoutPartyNumber(){
        Case c = getCaseWithoutAccountPartynumber();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        embed_caseDetail cde = new embed_caseDetail(sc);
        
        system.assertEquals(false, cde.getHasEConnectData(), 'eConnectData = ' + cde.getHasEConnectData());
        
        EConnectWrapper_GetCustomerData.InvoiceElement i=cde.invoiceElements;
        EConnectWrapper_GetCustomerData.ForwardingElement f= cde.forwardingElements;
        
        System.assertEquals(null, i);
        System.assertEquals(null, f);
        
    }
     static testMethod void testForwardingAndInvoiceBusiness(){
        Case c = getCaseWithBusinessAccount();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        embed_caseDetail cde = new embed_caseDetail(sc);
        EConnectWrapper_GetCustomerData.ForwardingElement f= cde.forwardingElements;
        EConnectWrapper_GetCustomerData.InvoiceElement i=cde.invoiceElements;
        //system.assert(cde.getHasEConnectData());
    }
    
    Static testMethod void testdownloadInvoicePDF()
    {
        Case c = getCaseWithBusinessAccount();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        embed_caseDetail cde = new embed_caseDetail(sc);
        cde.eConnectData =new EConnectWrapper_GetCustomerData(mock_Crmgetcustome.getBusinessAccount());
        cde.invNumber='Number_x';
        cde.downloadInvoicePDF();
    }
    Static testMethod void tesnew(){
        
        Test.setMock(WebServiceMock.class, new DisputeMock ());
        Case c = getCaseWithBusinessAccount();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        
        embed_caseDetail cde = new embed_caseDetail(sc);
        //cde.disputeObj(new Dispute_Amount__c'123');
        cde.UnitName='ABX';
    	cde.UnitNumber='123';
        cde.OrganizationNumber='123456';
        cde.ExternalReference='546789';
		cde.requestDispute();
		cde.BackToCase();
        
        cde.raiseDispute();
        cde.closeDispute();
        
    }
    
}