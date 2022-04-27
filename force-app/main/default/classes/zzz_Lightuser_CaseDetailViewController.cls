// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest
private class zzz_Lightuser_CaseDetailViewController {
  /* TODO: Write proper testing when logic is landed. This test has sole focus on line coverage */
    
    static testMethod void coverageTest() {
      Account testAccount = new Account(
        FirstName = 'Test',
        LastName = 'Testesen',
        crm_customer_number__c = 'p'+system.now(),
        ShippingStreet = 'Daudbilbakken 1',
        ShippingPostalCode = '0000',
        ShippingCity = 'Andeby',
        ShippingCountry = 'Norway'
      );
      upsert testAccount;
      
      /*Contact testContact = new Contact(
        LastName = 'Testesen',
        accountId = testAccount.id
      );
      upsert testContact;
      */
      Case parentCase = new Case();
      upsert parentCase;
      
      PostalUnit__c pu = new PostalUnit__c(
        unit_name__c = 'Test Unit',
        unit_number__c = '00000',
        DRM_id__c = '123abc123'
      );
      upsert pu;
      
      ForwardingAddressChange__c fac = new ForwardingAddressChange__c(
        account__c = testAccount.id,
        fromStreet__c = 'fromStreet__c',
      fromPostalCode__c = '0000',
      fromCity__c = 'fromCity__c',
      toStreet__c = 'toStreet__c',
      toPostalCode__c = '0000',
      toCity__c = 'toCity__c'
      );
      upsert fac;
      Code_Event__c ce=new Code_Event__c(Name='Ikke levert');
      insert ce;
      //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
      //to custom Service Product object. Change by Rajeev on 12th July 2016
      Service_Product__c p=new Service_Product__c(Name='Norgespakke');
      insert p;
      p=[SELECT Name, Id from Service_Product__c where id=:p.id];
      
      Code_Reason1__c cr1=new Code_Reason1__c(Name='Sol og sommer');
      insert cr1;
      Case c = new Case(
        Subject = 'zzz_Lightuser_CaseDetailViewController',
        RecordTypeId = KATSutilities.getRecordType('deviation_case'),
        
        //Status = 'Ny',
        //Cspahse2 Supriya 29122016
        Status = 'New',
        Priority = 'Medium',
        date_to_be_resumed__c = system.now().addDays(1),
        Type__c = 'Uregistrert',
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Service_Product__c=p.id,
        Code_Event__c = ce.id,
        Code_Reason1__c = cr1.id,
        change_address_ref_no__c = '12345',
        Created_by_Name__c = 'Test Testesen',
        Created_by_Unit__c = pu.id,
        //Division__c = 'Post Privat',
        //Cspahse2 Supriya 29122016
        Division__c = 'mail Private',
        PO_Amount__c = 10.00,
        Waiting_for_unit__c = pu.id,
        ParentId = parentCase.id,
        Shipment_number__c = '12345678901',
        Shipment_identification__c = '12345678901',
        
        accountId = testAccount.id,
        //contactId = testAccount.id //Is Private Account so this is ok
        forwardingAddress__c = fac.id
      );
      upsert c;
      
      ApexPages.currentPage().getParameters().put('id',c.id);
      Lightuser_CaseDetailViewController lc;
      Test.startTest();
      ApexPages.StandardController stdCase = new ApexPages.StandardController(c);
        lc = new Lightuser_CaseDetailViewController(stdCase);
        lc.newCaseWithSomeDataFromLastCase();
      Test.stopTest();
      
      //Test case parameters
      system.assertEquals(c.subject, lc.caseDetail.subject);
      system.assertEquals([SELECT Name FROM RecordType WHERE Id =:c.RecordTypeId].Name, lc.caseDetail.recordType);
      system.assertEquals(c.Status, lc.caseDetail.status);
      system.assertEquals(c.Priority, lc.caseDetail.priority);
      system.assertEquals(c.date_to_be_resumed__c.format('dd.MM.yyyy HH:mm'), lc.caseDetail.dateToBeResumed);
      system.assertEquals(c.Type__c, lc.caseDetail.type_c);
      
      system.assertEquals(p.name, lc.caseDetail.produkt);
      system.assertEquals(ce.name , lc.caseDetail.category);
      
      system.assertEquals(cr1.name, lc.caseDetail.reason);
      system.assertEquals(c.change_address_ref_no__c, lc.caseDetail.changeAddressRefNo);
      system.assertEquals(c.Created_by_Name__c, lc.caseDetail.CreatedByName);
      system.assertEquals(c.Created_by_Unit__c, lc.caseDetail.CreatedByUnit);
      system.assertEquals(c.Division__c, lc.caseDetail.division);
      system.assertEquals(c.PO_Amount__c.toPlainString(), lc.caseDetail.POAmount);
      system.assertEquals(c.Waiting_for_unit__c, lc.caseDetail.WaitingForUnit);
      system.assertEquals([SELECT CaseNumber FROM Case WHERE id = :parentCase.id].CaseNumber, lc.caseDetail.parentCase);
      system.assertEquals(c.Shipment_number__c, lc.caseDetail.shipmentNumber);
      system.assertEquals(c.Shipment_identification__c, lc.caseDetail.shipmentIdentification);
    
    system.assertEquals(testAccount.FirstName + ' ' + testAccount.LastName, lc.caseDetail.accountName);
    system.assertEquals(testAccount.crm_customer_number__c, lc.caseDetail.accountPartyNumber);
    system.assertEquals(testAccount.ShippingStreet, lc.caseDetail.accountShippingStreet);
    system.assertEquals(testAccount.ShippingPostalCode, lc.caseDetail.accountShippingPostalCode);
    system.assertEquals(testAccount.ShippingCity, lc.caseDetail.accountShippingCity);
    system.assertEquals(testAccount.ShippingCountry, lc.caseDetail.accountShippingCountry);
    
    //system.assertEquals(testAccount.FirstName + ' ' + testAccount.LastName, lc.caseDetail.contactName);
    
    system.assert(lc.caseDetail.showChangeAddress);
    system.assertEquals(fac.fromStreet__c+' '+fac.fromPostalCode__c+' '+fac.fromCity__c, lc.caseDetail.previousAddress);
    system.assertEquals(fac.toStreet__c+' '+fac.toPostalCode__c+' '+fac.toCity__c, lc.caseDetail.newAddress);
    }
}