@isTest
private class zzz_Case_SendToNPS {

  static testMethod void noNPSsettings() {

    delete nps_settings__c.getall().values();
    nps_settings__c nps = new nps_settings__c(endpoint_url__c='TestEndpoint', Password__c='Pass123', Username__c='TestUser' );
    List<Id> caseIds = new List<Id>();
    
    
    User testUser = KatsTestUtilities.getTestKundekonsulentUser();
    Account a = KatsTestUtilities.getTestBusinessAccount();
    Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
    a.recordtypeid=  RecordTypeId;
    update a;
    
    Case c1 = new Case(subject='TEST', accountId=a.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com', ownerId = testUser.Id);
    insert c1;
    //c1.Status = 'Avsluttet';
    caseIds.add(c1.Id);
    
    //Test
      test.startTest();
        Case_SendToNPS.sendCasesToNPS(caseIds);
      test.stopTest();
      
      //Control
      Case testCase = [SELECT NPS_Status__c, id FROM Case WHERE id = :c1.id];
      system.assertEquals(testCase.NPS_Status__c, Case_SendToNPS.NPS_NO_SETTINGS);
  }
  
  static testMethod void sendMultipleRecords() {
    
    delete nps_settings__c.getall().values();
    nps_settings__c nps = new nps_settings__c(Name='Test', endpoint_url__c='TestEndpoint', Password__c='Pass123', Username__c='TestUser',Send_to_NPS__c = true );
    insert nps;
    List<Id> caseIds = new List<Id>();
    
     User testUser = KatsTestUtilities.getTestKundekonsulentUser();
    Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
     //Dinesh , Added line no. 42 on 22 Feb 2017
    Id RecordTypeId1=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_Account_record_type_Private).getRecordTypeId();
    Account a = KatsTestUtilities.getTestBusinessAccount();
    a.recordtypeid=Recordtypeid;
    update a;
    Account a2 = KatsTestUtilities.getTestPrivateAccount();
    a2.recordtypeid=Recordtypeid1;
    update a2;
    Contact con = KatsTestUtilities.getTestContact();
    
    List<Case> cs = new List<Case>();
    // Email
    Case c1 = new Case(subject='TEST', accountId=a.id, ContactId=con.Id, description = 'test', SuppliedEmail='SuppliedEmail@test.com', Origin='Epost', ownerId = testUser.Id);
    cs.add(c1);
    // Phone
    Case c2 = new Case(subject='TEST', accountId=a2.id, description = 'test', SuppliedPhone='12345678', Origin='Telefon', ownerId = testUser.Id);
    cs.add(c2);
    // Fax, do not send
    Case c3 = new Case(subject='TEST', accountId=a.id, ContactId=con.Id, description = 'test', SuppliedPhone='12345678', Origin='Fax', ownerId = testUser.Id);
    cs.add(c3);
    Case c4 = new Case(subject='TEST', accountId=a.id, ContactId=con.Id, description = 'test', SuppliedEmail='SuppliedEmail@test.com', Preferred_Communications_Channel__c = 'Epost', ownerId = testUser.Id);
    cs.add(c4);
    Case c5 = new Case(subject='TEST', accountId=a.id, ContactId=con.Id, description = 'test', SuppliedPhone='12345678', Preferred_Communications_Channel__c = 'Telefon', ownerId = testUser.Id);
    cs.add(c5);
    // No contact
    Case c6 = new Case(subject='TEST', accountId=a.id, description = 'test', SuppliedPhone='12345678', Preferred_Communications_Channel__c = 'Brev', ownerId = testUser.Id);
    cs.add(c6);    
    insert cs;
    
    caseIds.add(c1.Id);
    caseIds.add(c2.Id);
    caseIds.add(c3.Id);
    caseIds.add(c4.Id);
    caseIds.add(c5.Id);
    caseIds.add(c6.Id);
    
    //Test
      test.startTest();
        Case_SendToNPS.sendCasesToNPS(caseIds);
      test.stopTest();
      
      //Control
      Case testC1 = [SELECT NPS_Status__c, id FROM Case WHERE id = :c1.id];
    Case testC2 = [SELECT NPS_Status__c, id FROM Case WHERE id = :c2.id];
      // (c3.Origin = 'Fax' => Do not send)
    Case testC3 = [SELECT NPS_Status__c, id FROM Case WHERE id = :c3.id];
    Case testC5 = [SELECT NPS_Status__c, id FROM Case WHERE id = :c5.id];
  }
  
  static testMethod void noRecordsMeetCriteria() {
    
    delete nps_settings__c.getall().values();
    nps_settings__c nps = new nps_settings__c(Name='Test', endpoint_url__c='TestEndpoint', Password__c='Pass123', Username__c='TestUser',Send_to_NPS__c = true );
    insert nps;
    List<Id> caseIds = new List<Id>();
    
     User testUser = KatsTestUtilities.getTestKundekonsulentUser();
    Account a = KatsTestUtilities.getTestBusinessAccount();
    Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
    a.recordtypeid=  RecordTypeId;
    update a;
    Contact con = KatsTestUtilities.getTestContact();
    
    List<Case> cs = new List<Case>();
    Case c1 = new Case(subject='TEST', accountId=a.id, ContactId=con.Id, description = 'test', SuppliedPhone='12345678', Origin='Fax', ownerId = testUser.Id);
    cs.add(c1);
    insert cs;
    
    caseIds.add(c1.Id);
    
    //Test
      test.startTest();
        Case_SendToNPS.sendCasesToNPS(caseIds);
      test.stopTest();
      
      //Control
      Case testC1 = [SELECT NPS_Status__c, id FROM Case WHERE id = :c1.id];
      //system.assertEquals(testC1.NPS_Status__c, Case_SendToNPS.NPS_NOT_QUALIFIED);

  }
  
  static testMethod void noAccountOnRecord()
  {
    Code_Event__c ce1 = new Code_Event__c();
        ce1.Name = 'CodeEvent1';
        ce1.IsActive__c = true;
        database.insert(ce1);
    //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Service_Product__c prod1 = new Service_Product__c();
        prod1.Name = 'Prod1';
        prod1.Eier__c = 'Post';
        prod1.IsActive__c = true;
        database.insert(prod1);

        Code_Reason1__c ar1 = new Code_Reason1__c();
        ar1.Name = 'CodeReason1';
        database.insert(ar1);
    
    delete nps_settings__c.getall().values();
    nps_settings__c nps = new nps_settings__c(Name='Test', endpoint_url__c='TestEndpoint', Password__c='Pass123', Username__c='TestUser',Send_to_NPS__c = true );
    insert nps;
    List<Id> caseIds = new List<Id>();
    
     User testUser = KatsTestUtilities.getTestKundekonsulentUser();
    //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
    List<Case> cs = new List<Case>();
        Case c1 = new Case(subject='TEST', Code_Event__c = ce1.Id, Category__c = ce1.Name, Service_Product__c = prod1.Id, Produkt__c = prod1.Name, Code_Reason1__c = ar1.Id, reason__c = ar1.Name, status='Avsluttet', description = 'test', SuppliedEmail='SuppliedEmail@test.com', Origin='Epost', ownerId = testUser.Id);
    cs.add(c1);
    insert cs;
    
    caseIds.add(c1.Id);
  
    //Test
      test.startTest();
        Case_SendToNPS.sendCasesToNPS(caseIds);
      test.stopTest();
      
      //Control
      Case testC1 = [SELECT NPS_Status__c, id FROM Case WHERE id = :c1.id];
      system.assertEquals(testC1.NPS_Status__c, Case_SendToNPS.NPS_SUCCESS);
  }
  
  static testMethod void noContactOnRecord()
  {
    Code_Event__c ce1 = new Code_Event__c();
        ce1.Name = 'CodeEvent1';
        ce1.IsActive__c = true;
        database.insert(ce1);
    //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Service_Product__c prod1 = new Service_Product__c();
        prod1.Name = 'Prod1';
        prod1.Eier__c = 'Post';
        prod1.IsActive__c = true;
        database.insert(prod1);

        Code_Reason1__c ar1 = new Code_Reason1__c();
        ar1.Name = 'CodeReason1';
        database.insert(ar1);
    
    delete nps_settings__c.getall().values();
    nps_settings__c nps = new nps_settings__c(Name='Test', endpoint_url__c='TestEndpoint', Password__c='Pass123', Username__c='TestUser',Send_to_NPS__c = true );
    insert nps;
    List<Id> caseIds = new List<Id>();
    
     User testUser = KatsTestUtilities.getTestKundekonsulentUser();
    Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
    Account acc = new Account(Name = 'TestAcc', recordtypeid=RecordTypeId);
    insert acc;
    
    List<Case> cs = new List<Case>();
    //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
    //to custom Service Product object. Change by Rajeev on 12th July 2016
    Case c1 = new Case(subject='TEST', accountId=acc.id, Code_Event__c = ce1.Id, Category__c = ce1.Name, Service_Product__c = prod1.Id, Produkt__c = prod1.Name, Code_Reason1__c = ar1.Id, reason__c = ar1.Name, status='Avsluttet', description = 'test', SuppliedEmail='SuppliedEmail@test.com', Origin='Epost', ownerId = testUser.Id);
    cs.add(c1);
    insert cs;
    
    caseIds.add(c1.Id);
  
    //Test
      test.startTest();
        Case_SendToNPS.sendCasesToNPS(caseIds);
      test.stopTest();
      
      //Control
      Case testC1 = [SELECT NPS_Status__c, id FROM Case WHERE id = :c1.id];
      system.assertEquals(testC1.NPS_Status__c, Case_SendToNPS.NPS_SUCCESS);
  }
}