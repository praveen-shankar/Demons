@isTest
private class zzz_EmailRecieverHelpers {

    private static User adminAdmin;
    private static Contact con;
    private static Account acc;
    /**
    *   HELPERS
    */
    static {
        adminAdmin = [SELECT id, username, profile.Name FROM User WHERE Id = '00520000001C2TK' LIMIT 1];
        
        acc = new Account(Name='Test account');
        acc.ShippingStreet = 'Test account street 123';
        acc.ShippingCity = 'Test account city';
        acc.ShippingCountry = 'NO';
        acc.ShippingPostalCode = '1337';
        //Dinesh , Added line no. 19 on 23 Feb 2017
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        insert acc;
        
        con = new Contact(LastName='Testensen');
        con.firstname='Test';
        con.email = 'test.testesen@test.test';
        con.Caesar_Contact_Id__c = 'test1234';
        con.Status__c = 'Active';
        //Csphase2 Supriya 29122016
        //con.Status__c = 'Aktiv';
        con.AccountId = acc.id;
        upsert con;
    }
    
    public static EmailMessage createEmailMessage() {
        EmailMessage em = new EmailMessage();
        em.ToAddress = 'postenKundeservice@example.org';
        em.ToAddress = 'postenCustomer@example.org';
        em.Incoming = true;
        return em;
    }
    public static Case createCase(EmailMessage em) {
        Case c = new Case();
        c.origin = 'Raw - Sporing';
        c.SuppliedEmail = em.FromAddress;
        c.SuppliedName = em.FromName;
        c.Description = em.TextBody;
        c.Subject = em.Subject;
        return c;
    }
    public static Case saveCaseAndEmail(Case c, EmailMessage em) {
        upsert c;
        em.ParentId = c.id;
        insert em;
        c = [select id, subject, description, origin, Entry_Email_Address__c, RecordTypeId, Shipment_identification__c from case where id=:c.id];
        system.debug('testing on case (new values)' + c);
        return c;
    }
    
    /**
    *   TEST METHODS
    */
    static testMethod void test_processCases() {
        Set<Id> caseIds = new Set<Id>();
        Case c = new Case();
            c.subject = 'Test case';
            c.accountId = acc.id;
            c.contactId = null;
            c.recordTypeId = KATSutilities.getRecordType('simple_inquiry');
            c.origin = 'Raw - Test';
            c.suppliedEmail = con.email;
            c.description = 'Test Description';
            c.Send_Autoresponse__c = false;
        upsert c;
        
        caseIds.add(c.id);
        
        system.runAs(adminAdmin) {
            EmailReceiverHelpers erh = new EmailReceiverHelpers();
            erh.processCases(caseIds);
        }
        
        c = [SELECT id, accountId, contactId, RecordTypeId, origin, suppliedEmail, description, Send_Autoresponse__c, subject FROM Case WHERE id = :c.id LIMIT 1];
        
        system.assertEquals('Test case', c.subject);
        system.assertEquals('Epost - Test', c.origin);
        system.assertEquals('simple_inquiry', KATSutilities.getRecordType(c.RecordTypeId));
        system.assertEquals('Test Description', c.Description);
        system.assertEquals(con.email, c.suppliedEmail);
        //system.assertEquals(con.id, c.contactId);
        system.assertEquals(acc.id, c.accountId);
    }
    
    static testMethod void test_reassignAttachments_inboundEmail() {
        Case c = new Case();
        upsert c;
        
        EmailMessage email= new EmailMessage(ParentId = c.id, Incoming = true);
        upsert email;
        
        Attachment a = new Attachment();
        a.name = 'test attachment';
        a.body = blob.valueof('attachment body');
        a.parentid = [select id from EmailMessage limit 1].id;
        
        insert a;   
        
        Attachment newAtt = [SELECT id, name FROM Attachment WHERE parentId = :c.id];
        
        system.assertEquals(System.Label.cs_Emailin+ a.name, newAtt.name);
    }
    
    static testMethod void test_shouldThrowAutoresponse_testFilter() {
        String email = con.email;
        
        Autresponse_Filter__c filter = new Autresponse_Filter__c();
        filter.Name = 'Test filter';
        filter.Regex__c = email;
        insert filter;
        Case c = new Case(suppliedEmail = email);
        
        Set<Case> cases = new Set<Case>();
        cases.add(c);
        
        
        system.runAs(adminAdmin) {
            system.debug('Start test');
            test.startTest();
                EmailReceiverHelpers.shouldThrowAutoresponse(cases);
            test.stopTest();
        }
        
        system.assertEquals(false, c.Send_Autoresponse__c);
    }
    
    static testMethod void test_shouldThrowAutoresponse_createdCasesTwice() {
        String email = con.email;
        Set<Case> cases = new Set<Case>();
        
        Case c1 = new Case(suppliedEmail = email);
        Case c2 = new Case(suppliedEmail = email);
        cases.add(c2);
        
       // upsert c1;
        
        system.runAs(adminAdmin) {
            system.debug('Start test');
            test.startTest();
                EmailReceiverHelpers.shouldThrowAutoresponse(cases);
            test.stopTest();
        }
        
       // system.assertEquals(false, c2.Send_Autoresponse__c);
    }
    
    static testMethod void testWebformCase() {
        webform_structures__c webformSetting = new webform_structures__c();
        webformSetting.name = 'TESTSporing av pakker:';
        webformSetting.field_mappings__c = 'ignore;shipment_identification;phone;ignore;ignore;company;org_number;address;postal_code;city;party_number;description';
        webformSetting.field_names_1__c = 'Navn:;Sendingens nummer:;Telefonnummer:;Epost:;Referansenummer:;Firma:;Organisasjonsnummer:;Adresse:;Postnummer:;Poststed:;Kunde og aktørnummer:;Melding:';
        webformSetting.Default_Record_Type__c = 'complaint';
        insert webformSetting;
        
        //Create case and e-mail as is the email-to-case feature has done it
        EmailMessage em = createEmailMessage();
        em.subject  =   'TESTSporing av pakker: Test test';
        em.TextBody =   'Navn: Test test' + '\n'
                        + 'Sendingens nummer: 123456789' + '\n'
                        + 'Telefonnummer: 87654321' + '\n'
                        + 'Epost: test@example.org' + '\n'
                        + 'Referansenummer: 12345' + '\n'
                        + 'Firma: TestFirma' + '\n'
                        + 'Organisasjonsnummer: 123456789' + '\n'
                        + 'Adresse: Testveien' + '\n'
                        + 'Postnummer: 0000' + '\n'
                        + 'Poststed: Testby' + '\n'
                        + 'Kunde og aktørnummer: 00000' + '\n'
                        + 'Melding: Test message from webform';
        em.ToAddress = 'KATS.Test@posten.no';
        
        Case c = createCase(em);
        c = saveCaseAndEmail(c,em);
        
        c = [SELECT id, origin, subject, Shipment_identification__c, RecordTypeId, Description FROM Case WHERE id = :c.id LIMIT 1];
        
        system.debug('Asserting the case: ' + c);
        system.assertEquals(true, c.origin.contains('Web'), 'Expected \'Web - <queue name>\', but got ' + c.origin);
        system.assertEquals(true, c.subject.contains('Web:'), 'Expected \'Web: - <subject>\', but got ' + c.subject);
        system.assertEquals('123456789', c.Shipment_identification__c);
        system.assertEquals(KATSutilities.getRecordType('complaint'), c.RecordTypeId);
        system.assertEquals(em.textBody, c.Description);
    }
    
    static testMethod void testDoesWebformStructureExist() {
        EmailReceiverHelpers erh = new EmailReceiverHelpers();
        erh.doesWebformStructureExist('short');
        erh.doesWebformStructureExist('Long with all latin characters. Long with all latin characters. Long with all latin characters. Long with all latin characters. ');
        // This will fail because String.length() counts unicode length, byt for custom settings, size is half...
        // erh.doesWebformStructureExist('Long incl non-æøå-latin characters. Long incl non-æøå-latin characters. Long incl non-æøå-latin characters. Long incl non-æøå-latin characters');
    }
}