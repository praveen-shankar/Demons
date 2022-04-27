// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
/*
*  Test class for the trigger CaseBeforeTrigger.trigger
*/

@isTest
private class zzz_CaseBeforeTrigger {
  
  private static Id senderRecordTypeId = KATSUtilities.getRecordType('complaint');
  private static Id recieverRecordTypeId = KATSUtilities.getRecordtype('complaint');
  
  static Group getQueue(String name) {
    Group g = new Group(Type='Queue', Name=name);
    insert g;
    
    List<QueueSObject> qList = new List<QueueSObject>();
    qList.add(new QueueSObject(SobjectType='Case', QueueId=g.Id));
    qList.add(new QueueSObject(SobjectType='QueueDetails__c', QueueId=g.Id));
    
    insert qList;
    
    return [SELECT id, name FROM Group WHERE id = :g.id LIMIT 1];
  }
  
  static Account getTestAccount() {
    Account acc = new Account(crm_customer_number__c= 'Test000', CustomerTeam__c = 'SB Kundeteam 6', customer_segment__c = 'A', status__c = 'Valid', Name = 'TestAccount');
    upsert acc;
    
    upsert new Division__c(Name = 'Post', Account__c = acc.id, SegmentName__c = 'A', SubSegmentName__c = 'SB Kundeteam 6', Sales_Person_Email__c = 'testSalesPersonEmail@post.test');
    upsert new Division__c(Name = 'Logistikk', Account__c = acc.id, SegmentName__c = 'x-large', SubSegmentName__c = '', Sales_Person_Email__c = 'testSalesPersonEmail@logistikk.test');
    upsert new Division__c(Name = 'Dialog', Account__c = acc.id, SegmentName__c = 'A1', SubSegmentName__c = 'A', Sales_Person_Email__c = 'testSalesPersonEmail@dialog.test');
    
    return acc;
  }
  
  /*
  *  Tests involving new messages on case
  */
  static QueueDetails__c getQueueDetailsWithCTI(Group queue) {
    QueueDetails__c qd = new QueueDetails__c();
    qd.Default_Division_In_Queue__c = 'Post';
    qd.queue_id__c = queue.id;
    qd.queue_name__c = queue.name;
    upsert qd;
    
    qd.fetch_from_cti__c = true;
    upsert qd;
    
    return qd;
  }
  
  static testMethod void testClosedCaseWithNewMessage()
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
        ar1.Name = 'Code Reason 1';
        database.insert(ar1);

    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
    //to custom Service Product object. Change by Rajeev on 12th July 2016
    System.runAs ( thisUser ) {
      Case c = new Case(status = 'Closed', Code_Event__c = ce1.Id, Service_Product__c = prod1.Id, Category__c = ce1.Name, Produkt__c = prod1.Name, Code_Reason1__c = ar1.Id, reason__c = ar1.Name);
      upsert c;
      
      c.unread_action__c = true;
      upsert c;
      
      c = [SELECT Assigned_to_CTI__c, Assigned_to_CTI_Agent__c, hidden_queue_id__c FROM Case WHERE id = :c.id LIMIT 1];
      
    }
  }
  
  static testMethod void testClosedCaseWithHiddenQueueAndIdNewMessage() 
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
        ar1.Name = 'Code Reason 1';
        database.insert(ar1);

    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
      Group g = getQueue('Test queue');
      //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
      //to custom Service Product object. Change by Rajeev on 12th July 2016
      Case c = new Case(status = 'Avsluttet', Code_Event__c = ce1.Id, Service_Product__c = prod1.Id, Category__c = ce1.Name, Produkt__c = prod1.Name, Code_Reason1__c = ar1.Id, reason__c = ar1.Name);
      c.hidden_queue_id__c = g.id;
      upsert c;
      
      c = [SELECT ownerId, unread_action__c, Owner.Type, Assigned_to_CTI__c, Assigned_to_CTI_Agent__c, hidden_queue_id__c FROM Case WHERE id = :c.id LIMIT 1];
      
      c.unread_action__c = true;
      upsert c;
      
      c = [SELECT ownerId, unread_action__c, Owner.Type, Assigned_to_CTI__c, Assigned_to_CTI_Agent__c, hidden_queue_id__c FROM Case WHERE id = :c.id LIMIT 1];
      
    }
  }
  
  static testMethod void testOpenCaseWithHiddenQueueAndIdNewMessage() {
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
      Group g = getQueue('Test queue');
      Case c = new Case();
      c.hidden_queue_id__c = g.id;
      upsert c;
      
      c = [SELECT ownerId, unread_action__c, Owner.Type, Assigned_to_CTI__c, Assigned_to_CTI_Agent__c, hidden_queue_id__c FROM Case WHERE id = :c.id LIMIT 1];
      
      c.unread_action__c = true;
      upsert c;
      
      c = [SELECT ownerId, unread_action__c, Owner.Type, Assigned_to_CTI__c, Assigned_to_CTI_Agent__c, hidden_queue_id__c FROM Case WHERE id = :c.id LIMIT 1];
      
     // system.assertEquals('User', c.Owner.Type);
      system.assert(!c.Assigned_to_CTI__c);
      system.assert(c.Assigned_to_CTI_Agent__c);
      system.assert(c.hidden_queue_id__c == g.id);
    }
  }
  
  /*
  *  Tests involving change open case from user to queue
  */
  
  static testMethod void testChangeOpenCaseFromUserToQueue() {
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
      Group g = getQueue('Test queue');
      Case c = new Case(Assigned_to_CTI__c = true, Assigned_to_CTI_Agent__c = false);
      upsert c;
      test.startTest();
      c.OwnerId = g.id;
      upsert c;
      test.stopTest();
      c = [SELECT ownerId, unread_action__c, Owner.Type, Assigned_to_CTI__c, Assigned_to_CTI_Agent__c, hidden_queue_id__c FROM Case WHERE id = :c.id LIMIT 1];
      
      system.assertEquals('Queue', c.Owner.Type);
      system.assertEquals( g.id, c.ownerId);
      system.assertEquals(false,c.Assigned_to_CTI__c);
      system.assertEquals(true,c.Assigned_to_CTI_Agent__c);
      system.assertEquals(g.id, c.hidden_queue_id__c);
    }
  }
  
  static testMethod void testChangeClosedCaseFromUserToQueue()
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
        ar1.Name = 'Code Reason 1';
        database.insert(ar1);

    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
      Group g = getQueue('Test queue');
      //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
      //to custom Service Product object. Change by Rajeev on 12th July 2016
      Case c = new Case(Assigned_to_CTI__c = true, Code_Event__c = ce1.Id, Service_Product__c = prod1.Id, Category__c = ce1.Name, Produkt__c = prod1.Name, Code_Reason1__c = ar1.Id, reason__c = ar1.Name, Assigned_to_CTI_Agent__c = false, status = 'Avsluttet');
      upsert c;
      
      c.OwnerId = g.id;
      upsert c;
      
      c = [SELECT ownerId, unread_action__c, Owner.Type, Assigned_to_CTI__c, Assigned_to_CTI_Agent__c, hidden_queue_id__c FROM Case WHERE id = :c.id LIMIT 1];
      
    }
  }
  
  static testMethod void testShipmentCaseSenderAssignsSenderInfo() {
    Account a = KatsTestUtilities.getTestBusinessAccount();
    Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
    a.recordtypeid=  RecordTypeId;
    update a;
    Case c = new Case(RecordTypeId = senderRecordTypeId, AccountId = a.Id);
    Test.startTest();
    insert c;
    Test.stopTest();
    c = fetchCase(c.Id);
    //assertSenderInfo(c, a);
  }

  static testMethod void testShipmentCaseSenderAccountChangesUpdatesSenderInfo() {
    Account a = KatsTestUtilities.getTestBusinessAccount();
    Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
    a.recordtypeid=  RecordTypeId;
    update a;
    Case c = new Case(RecordTypeId = senderRecordTypeId, AccountId = a.Id);
    insert c;
    Account b = createAnotherTestAccount(a);
    c.AccountId = b.Id;
    Test.startTest();
    update c;
    Test.stopTest();
    c = fetchCase(c.Id);
    //assertSenderInfo(c, b);
  }

  static private Case fetchCase(Id caseId) {
    return [SELECT   shipper_name__c, 
            shipper_address__c, 
            shipper_postal_address__c, 
            shipper_zip_code__c, 
             
            shipper_country__c,
            reciever_name__c, 
            reciever_address__c, 
            reciever_zip_code__c, 
            reciever_postal_address__c,
            
            reciever_country__c 
            FROM Case WHERE Case.Id = :caseId];
  }
  //Shipper_CountryCode__c,
  //Reciever_CountryCode__c, 

  static private void assertSenderInfo(Case c, Account a) {
    System.assertEquals(a.Name, c.shipper_name__c); // Ola Nordmann
      System.assertEquals(a.ShippingStreet, c.shipper_address__c); // Ola Nordmanns vei 1
      System.assertEquals(a.ShippingCity, c.shipper_postal_address__c); // 0555
      System.assertEquals(a.ShippingPostalCode, c.shipper_zip_code__c); // Oslo
     // System.assertEquals(a.ShippingCountry, c.Shipper_CountryCode__c); // NO
      System.assertEquals(null, c.shipper_country__c); // this field is not in use by the IT systems at Posten
  }
  
  static testMethod void testShipmentCaseRecieverAssignsRecieverInfo() {
    Account a = KatsTestUtilities.getTestBusinessAccount();
    Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
    a.recordtypeid=  RecordTypeId;
    update a;
    Case c = new Case(RecordTypeId = recieverRecordTypeId, AccountId = a.Id);
    insert c;
    Account b = createAnotherTestAccount(a);
    b.recordtypeid=  RecordTypeId;
    update b;
    c.AccountId = b.Id;
    Test.startTest();
    update c;
    Test.stopTest();
    c = fetchCase(c.Id);
    //assertRecieverInfo(c, b);
  }
  
  static testMethod void testShipmentCaseRecieverAccountChangesUpdatesRecieverInfo() {
    Account a = KatsTestUtilities.getTestBusinessAccount();
    Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
    a.recordtypeid=  RecordTypeId;
    update a;
    Case c = new Case(RecordTypeId = recieverRecordTypeId, AccountId = a.Id);
    insert c;
    Account b = createAnotherTestAccount(a);
  
    b.recordtypeid=  RecordTypeId;
    update b;
    c.AccountId = b.Id;
    Test.startTest();
    update c;
    Test.stopTest();
    c = fetchCase(c.Id);
    //assertRecieverInfo(c, b);
  }
  
  static private void assertRecieverInfo(Case c, Account a) {
    System.assertEquals(a.Name, c.reciever_name__c); // Ola Nordmann
      System.assertEquals(a.ShippingStreet, c.reciever_address__c); // Ola Nordmanns vei 1
      System.assertEquals(a.ShippingPostalCode, c.reciever_zip_code__c); // 0555
      System.assertEquals(a.ShippingCity, c.reciever_postal_address__c); // Oslo
      //System.assertEquals(a.ShippingCountry, c.Reciever_CountryCode__c); // NO
      System.assertEquals(null, c.reciever_country__c); // this field is not in use by the IT systems at Posten
  }
  
  static private Account createAnotherTestAccount(Account a) {
    Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();  
    Account b = new Account(Name=a.name + 'b');
    b.recordtypeid=  RecordTypeId;
    b.ShippingStreet = a.ShippingStreet + 'b';
    b.ShippingCity = a.ShippingStreet + 'b';
    b.ShippingCountry = a.ShippingCountry + 'b';
    b.ShippingPostalCode = a.ShippingPostalCode + 'b';
    insert b;
    return b;
  }
  
  static testMethod void testSearchCustomerForCaseFromEmail() {
    Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
    Account a = new Account(Name='Test account');
    a.recordTypeid= RecordTypeId;
    upsert a;
    Contact con = new Contact(lastName='Test contact', email='testadshjdkowp@test.com', accountId=a.id, FirstName='test');
    insert con;
    
    Case c = new Case(subject='test', suppliedEmail=con.Email, origin='Web - klage');
    insert c;
    
    c = [SELECT id, contactId, accountId FROM Case WHERE id=:c.id LIMIT 1];
    
    //system.assertEquals(con.id, c.contactId);
    // Dinesh , Commented line no 329 on 22 Feb 2017
    //system.assertEquals(a.id, c.accountId);
  }
  
  static testMethod void testSearchCustomerForCaseFromEmailNegative() {
    Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
    Account a = new Account(Name='Test account');
    a.recordtypeid= recordtypeid;
    upsert a;
    
    Contact con = new Contact(lastName='Test contact', email='', accountId=a.id, FirstName='test');
    insert con;
    
    Case c = new Case(subject='test', suppliedEmail=con.Email, origin='Web - klage');
    insert c;
    
    c = [SELECT id, contactId, accountId FROM Case WHERE id=:c.id LIMIT 1];
    
    system.assertEquals(null, c.contactId);
    system.assertEquals(null, c.accountId);
  }
  /**/
}