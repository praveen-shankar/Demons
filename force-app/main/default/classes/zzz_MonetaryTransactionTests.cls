//Added as a part of P3CRM-Sales project, removing reference from standard Product Object
//to custom Service Product object. Change by Rajeev on 13th July 2016
// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.crm_customer_number__c with Account.crm_customer_number__c

@isTest
private class zzz_MonetaryTransactionTests {

  private static Service_Product__c createTestProduct(){
      Service_Product__c p=new Service_Product__c(Name='MyTestProduct');
      insert p;
      return p;
    }
      private static Code_Reason1__c createTestReason(){
      Code_Reason1__c r=new Code_Reason1__c(Name='MyTestReason1');
      insert r;
      return r;
    }
    private static Code_Event__c createTestEvent(){
      
      Code_Event__c ce = new Code_Event__c(Name='MyTestEvent');
      insert ce;
      Return ce;
    }
   

private static Service_Product__c testProduct=createTestProduct();
private static Code_Reason1__c testReason= createTestReason();
private static Code_Event__c testEvent=createTestEvent();    
      
  
    static testMethod void testArticleNumberDefinition() {
        
        prepareArticleNumbers();
                
       // Case c = new Case(subject='Test case', Produkt__c='Test Product');
        Case c = new Case(subject='Test case', Service_Product__c=testProduct.id);
        upsert c;
        
        test.startTest();
        
        monetary_transaction__c t = new monetary_transaction__c(case__c=c.id, Bank_Account_Number__c='12345678903');
        upsert t;
        
        t = [select id from monetary_transaction__c where id=:t.id];
        //Monetary_Transaction_Line_Item__c tltest = new Monetary_Transaction_Line_Item__c (is_motpost__c =true,Transaksjon__c = t.id, Type__c='Refusjon', Line_Amount__c=123.45);
        //Csphase2 Supriya 29122016
        Monetary_Transaction_Line_Item__c tltest = new Monetary_Transaction_Line_Item__c (is_motpost__c =true,Transaksjon__c = t.id, Type__c='Refund', Line_Amount__c=123.45);
        upsert tltest;
        
        tltest = [select id, Article_Number__c from monetary_transaction_line_item__c where id=:tltest.id];
                
        test.stopTest();
    }

    static testMethod void testUpdateTransactionStatusFromEconnect() {
      List<Monetary_transaction__c> transactionsToUpdate = new List<Monetary_transaction__c>();
      String TestId = getTestTransaction(MonetaryTransactionsController.NAV);
      Monetary_transaction__c m = [select t.case__r.case_referens__c, t.case__r.account.Transaksjonskontakt__r.Email, t.id, t.status__c, t.case__r.caseNumber, t.case__r.type__c, t.case__r.Code_event__r.name, t.case__r.Code_reason1__r.name, t.case__r.account.crm_customer_number__c, t.case__r.account.name, t.case__r.contact.name, t.Bank_Account_Number__c, t.Transaction_approved_date__c, t.CreatedDate, t.ERP_target_system__c,t.case__r.Account.crm_Company_IBAN__c, t.Reference__c, (select Line_Amount__c, Article_Number__c, vare_number_NAV__c,vare_number_NAV__r.Name, Regress_Account__r.Transaksjonskontakt__r.Email, Description__c, cargo_product_code__c, Regress_Account__r.crm_customer_number__c, cargo_division_code__r.unit_number_in_subsidiary__c,cargo_division_code__r.DRM_id__c, Type__c from monetary_transaction__c.Monetary_Transaction_Line_Items__r) from monetary_transaction__c t where t.Id = :TestId limit 1];
      transactionsToUpdate.add(m);
      
      MonetaryTransactionsController.updateTransactionStatusFromEconnect(transactionsToUpdate, null);
      system.assertEquals(m.status__c, MonetaryTransactionsController.FAIL_STATUS);
            
      Map<string,string> statusMap = new Map<string,string>();
      statusMap.put(TestId,'OK');
      MonetaryTransactionsController.updateTransactionStatusFromEconnect(transactionsToUpdate, statusMap);
      //system.assertEquals(m.status__c, MonetaryTransactionsController.SUCCESS_STATUS_NAV);
      
      Map<string,string> statusMap2 = new Map<string,string>();
      statusMap2.put('UnknownTestId','OK');
      MonetaryTransactionsController.updateTransactionStatusFromEconnect(transactionsToUpdate, statusMap2);
      system.assertEquals(m.status__c, MonetaryTransactionsController.FAIL_STATUS);
      
      List<Monetary_transaction__c> transactionsToUpdate2 = new List<Monetary_transaction__c>();
      m.ERP_target_system__c = MonetaryTransactionsController.OEBS;
      transactionsToUpdate2.add(m);
      MonetaryTransactionsController.updateTransactionStatusFromEconnect(transactionsToUpdate2, statusMap);
      //system.assertEquals(m.status__c, MonetaryTransactionsController.SUCCESS_STATUS_OEBS);
    }
   
  /*  static testMethod void testCreateRemitPayment() {
    String BankAccountNo='12345678903';
    postenNoEconnectKatsPaymentevents.RemitPaymentType RemitPaymentTest = MonetaryTransactionsController.createRemitPayment(BankAccountNo);
    system.assertEquals(BankAccountNo, RemitPaymentTest.BankAccountNumber);
    postenNoEconnectKatsPaymentevents.RemitPaymentType RemitPaymentBlank = MonetaryTransactionsController.createRemitPayment('');
    system.assertEquals('', RemitPaymentBlank.BankAccountNumber); // A possible logical error in MonetaryTransactionsController creates a RemitPayment element if a blank bankaccNo is provided.
    postenNoEconnectKatsPaymentevents.RemitPaymentType RemitPaymentNull = MonetaryTransactionsController.createRemitPayment(null);
    system.assertEquals(null, RemitPaymentNull);
    }*/
    

    static testMethod void testCreatePayment_1() {
      DateTime approvedDate = DateTime.now();
      DateTime createdDate = DateTime.now();
      
      Account testAccount = new Account();
        testAccount.Name = 'TestAccountName';
        testAccount.crm_customer_number__c = '12345678_mtt';
        testAccount.RecordTypeId = [select id from RecordType where developerName =:'business_account' limit 1].id;
      insert testAccount;
    Contact testContact = new Contact();
      testContact.AccountId = testAccount.id;
      testContact.FirstName = 'Test';
      testContact.LastName = 'Contact';
    insert testContact;
      Case testCase = new Case();
        testCase.AccountId = testAccount.id;
        testCase.ContactId = testContact.id;
        testCase.type__c = 'TestType';
        testCase.Code_Event__c=testEvent.id;
        testCase.Code_reason1__c = TestReason.id;
      insert testCase;
      Monetary_transaction__c testTransaction = new Monetary_transaction__c();
        testTransaction.case__c = testCase.id;
        testTransaction.Reference__c = 'TestReference';
        testTransaction.Bank_Account_Number__c = '76940512928';
        testTransaction.Transaction_approved_date__c = approvedDate;
        testTransaction.CreatedDate = createdDate;
        testTransaction.ERP_target_system__c = 'OEBS';
      insert testTransaction;
      
      testTransaction = [SELECT t.case__r.case_referens__c,
                    t.case__r.account.Transaksjonskontakt__r.Email,
                    t.id,
                    t.status__c,
                    t.case__r.caseNumber,
                    t.case__r.type__c,
                    t.case__r.Code_event__r.name,
                    t.case__r.Code_reason1__r.name,
                    t.case__r.account.crm_customer_number__c,
                    t.case__r.account.name,
                    t.case__r.contact.name,
                    t.case__r.Account.crm_Company_bank_name__c,
                    t.Bank_Account_Number__c,
                    t.Transaction_approved_date__c,
                    t.CreatedDate,
                    t.ERP_target_system__c,t.case__r.Account.crm_Company_IBAN__c,
                    t.Reference__c,
                      (SELECT Line_Amount__c,
                          Name,
                          Article_Number__c,
                          vare_number_NAV__c,
                          vare_number_NAV__r.Name,
                          Description__c,
                          Regress_Account__r.Transaksjonskontakt__r.Email,
                          cargo_product_code__c,
                          Regress_Account__r.crm_customer_number__c,
                          cargo_division_code__r.unit_number_in_subsidiary__c,
                          cargo_division_code__r.DRM_id__c,
                          Type__c
                        FROM monetary_transaction__c.Monetary_Transaction_Line_Items__r)
                  FROM monetary_transaction__c t WHERE t.Id = :testTransaction.id].get(0);
      
      cs_postenNoEcServiceSendcreditmem.ReceivableType result;
       
      //Test.startTest();
       // result = MonetaryTransactionsController.createPayment(testTransaction);
     // Test.stopTest();
      
      //system.assertNotEquals(null, result);
      //system.assertEquals('Kundeservicesak ' + [SELECT CaseNumber FROM Case WHERE id = :testCase.id LIMIT 1].CaseNumber + ', Kontaktperson Test Contact', result.ReceivableHeader.CaseNumber);
      //system.assertEquals('TestType/MyTestEvent/MyTestReason1', result.ReceivableHeader.CaseCode);
      //system.assertEquals(testTransaction.id, result.ReceivableHeader.CRMTransactionID);
      //system.assertEquals('12345678_mtt',result.ReceivableHeader.CustomerNumber);
      //system.assertEquals('TestAccountName',result.ReceivableHeader.CustomerName);
      //system.assertEquals('KATS', result.ReceivableHeader.Source);
      //system.assertEquals('TestReference', result.ReceivableHeader.Reference);
      //system.assertEquals(approvedDate.date(), result.ReceivableHeader.PostingDate);
      //system.assertEquals(createdDate.date(), result.ReceivableHeader.DocumentDate);
      //system.assertEquals('OEBS', result.ReceivableHeader.TargetSystem);
     // system.assertEquals('', result.ReceivableHeader.OurReference);
    }
    
    static testMethod void testCreatePayment_2() {
      DateTime approvedDate = DateTime.now();
      DateTime createdDate = DateTime.now();
      
      Account testAccount = new Account();
        testAccount.Name = 'TestAccountName';
        testAccount.crm_customer_number__c = 'BLNOC12345678';
        testAccount.RecordTypeId = [select id from RecordType where developerName =:'business_account' limit 1].id;
      insert testAccount;
    Contact testContact = new Contact();
      testContact.AccountId = testAccount.id;
      testContact.FirstName = 'Test';
      testContact.LastName = 'Contact';
    insert testContact;
      Case testCase = new Case();
        testCase.AccountId = testAccount.id;
        testCase.ContactId = testContact.id;
        testCase.RecordTypeId = KATSutilities.getRecordType('Cargo_Claims');
        testCase.type__c = 'TestType';
        testCase.Code_Event__c = testEvent.id;
        testCase.Code_reason1__c = testReason.id;
      insert testCase;
      Monetary_transaction__c testTransaction = new Monetary_transaction__c();
        testTransaction.case__c = testCase.id;
        testTransaction.Reference__c = 'TestReference';
        testTransaction.Bank_Account_Number__c = '76940512928';
        testTransaction.Transaction_approved_date__c = approvedDate;
        testTransaction.CreatedDate = createdDate;
        testTransaction.ERP_target_system__c = 'NAV';
      insert testTransaction;
      
      testTransaction = [SELECT t.case__r.case_referens__c,
                    t.case__r.account.Transaksjonskontakt__r.Email,
                    t.id,
                    t.status__c,
                    t.case__r.caseNumber,
                    t.case__r.type__c,
                    t.case__r.Code_Event__r.name,
                    t.case__r.Code_reason1__r.name,
                    t.case__r.account.crm_customer_number__c,
                    t.case__r.account.name,
                    t.case__r.contact.name,
                    t.Bank_Account_Number__c,
                    t.Transaction_approved_date__c,
                    t.CreatedDate,
                    t.ERP_target_system__c,t.case__r.Account.crm_Company_IBAN__c,
                    t.Reference__c,
                      (SELECT Line_Amount__c,
                          Name,
                          Article_Number__c,
                          vare_number_NAV__c,
                          vare_number_NAV__r.Name,
                          Regress_Account__r.Transaksjonskontakt__r.Email,
                          Description__c,
                          cargo_product_code__c,
                          Regress_Account__r.crm_customer_number__c,
                          cargo_division_code__r.unit_number_in_subsidiary__c,
                          cargo_division_code__r.DRM_id__c,
                          Type__c
                        FROM monetary_transaction__c.Monetary_Transaction_Line_Items__r)
                  FROM monetary_transaction__c t WHERE t.Id = :testTransaction.id].get(0);
      
       cs_postenNoEcServiceSendcreditmem.ReceivableType result;
       
      //Test.startTest();
        //result = MonetaryTransactionsController.createPayment(testTransaction);
      //Test.stopTest();
      
      /*system.assertNotEquals(null, result);
      system.assertEquals('Kundeservicesak ' + [SELECT CaseNumber FROM Case WHERE id = :testCase.id LIMIT 1].CaseNumber, result.ReceivableHeader.CaseNumber);
      system.assertEquals('TestType/MyTestEvent/MyTestReason1', result.ReceivableHeader.CaseCode);
      system.assertEquals(testTransaction.id, result.ReceivableHeader.CRMTransactionID);
      system.assertEquals('BLNOC12345678',result.ReceivableHeader.CustomerNumber);
      system.assertEquals('TestAccountName',result.ReceivableHeader.CustomerName);
     system.assertEquals('KATS', result.Source);
      system.assertEquals('TestReference', result.ReceivableHeader.Reference);
      system.assertEquals(approvedDate.date(), result.ReceivableHeader.PostingDate);
      system.assertEquals(createdDate.date(), result.ReceivableHeader.DocumentDate);
      system.assertEquals('NAV', result.ReceivableHeader.TargetSystem);
      system.assertEquals('', result.ReceivableHeader.OurReference);*/
      
       
    }
    
    //static testMethod void testCreatePayment() {
      //cs_postenNoEcServiceSendcreditmem.ReceivableType t = MonetaryTransactionsController.createPayment(new Monetary_Transaction__c());
      //system.assertEquals(null, t);
      
    //String mtNAV = getTestTransaction(MonetaryTransactionsController.NAV);
    //Monetary_Transaction__c mt = [select t.case__r.case_referens__c, t.case__r.account.Transaksjonskontakt__r.Email, t.id, t.status__c, t.case__r.caseNumber, t.case__r.type__c, t.case__r.code_event__r.name, t.case__r.Code_reason1__r.name, t.case__r.account.crm_customer_number__c, t.case__r.account.name, t.case__r.contact.name, t.Bank_Account_Number__c, t.Transaction_approved_date__c, t.CreatedDate, t.ERP_target_system__c,t.case__r.Account.crm_Company_IBAN__c, t.Reference__c, (select Name, Line_Amount__c, Article_Number__c, vare_number_NAV__c,vare_number_NAV__r.Name, Regress_Account__r.Transaksjonskontakt__r.Email, Description__c, cargo_product_code__c, Regress_Account__r.crm_customer_number__c, cargo_division_code__r.unit_number_in_subsidiary__c,cargo_division_code__r.DRM_id__c, Type__c, voucher_number__c from monetary_transaction__c.Monetary_Transaction_Line_Items__r) from monetary_transaction__c t where t.Id = :mtNAV limit 1];
    //mt.status__c = MonetaryTransactionsController.READY_STATUS;
    //cs_postenNoEcServiceSendcreditmem.ReceivableType  tt = MonetaryTransactionsController.createPayment(mt);
    //system.assertEquals(mt.case__r.account.Transaksjonskontakt__r.Email, tt.ReceivableLine.get(0).Email);
    //system.assertEquals(mt.case__r.account.crm_customer_number__c, tt.PartyNumber);
    //system.assertEquals(mt.Bank_Account_Number__c, tt.RemitPayment.BankAccountNumber);
    //system.assertEquals(mt.Id, tt.KATSTransactionID);
    //}
            
    static testMethod void testSendPaymentForTransactions() {
    String mtNAV = getTestTransaction(MonetaryTransactionsController.NAV);
    Monetary_Transaction__c mt = [select t.case__r.case_referens__c, t.case__r.account.Transaksjonskontakt__r.Email, t.id, t.status__c, t.case__r.caseNumber, t.case__r.type__c, t.case__r.code_event__r.name, t.case__r.Code_reason1__r.name, t.case__r.account.crm_customer_number__c, t.case__r.account.name, t.case__r.contact.name, t.Bank_Account_Number__c, t.Transaction_approved_date__c, t.CreatedDate, t.ERP_target_system__c,t.case__r.Account.crm_Company_IBAN__c, t.Reference__c, (select Name, Line_Amount__c, Article_Number__c, vare_number_NAV__c,vare_number_NAV__r.Name, Regress_Account__r.Transaksjonskontakt__r.Email, Description__c, cargo_product_code__c, Regress_Account__r.crm_customer_number__c, cargo_division_code__r.unit_number_in_subsidiary__c,cargo_division_code__r.DRM_id__c, Type__c, voucher_number__c from monetary_transaction__c.Monetary_Transaction_Line_Items__r) from monetary_transaction__c t where t.Id = :mtNAV limit 1];
    mt.status__c = MonetaryTransactionsController.READY_STATUS;
    upsert mt;
    System.debug(mt);
    System.debug(mt.status__c);
    List<Id> transactionIds = new List<Id>();
    transactionIds.add(mt.Id);
    Test.startTest();
    MonetaryTransactionsController.sendPaymentForTransactions(transactionIds);
    Test.stopTest();
  }
    
    static testMethod void testBilagsnummer(){
      String mtNAV = getTestTransaction(MonetaryTransactionsController.NAV);
    Monetary_Transaction__c mt = [select t.case__r.case_referens__c, t.case__r.account.Transaksjonskontakt__r.Email, t.id, t.status__c, t.case__r.caseNumber, t.case__r.type__c, t.case__r.code_event__r.name, t.case__r.Code_reason1__r.name, t.case__r.account.crm_customer_number__c, t.case__r.account.name, t.case__r.contact.name, t.Bank_Account_Number__c, t.Transaction_approved_date__c, t.CreatedDate, t.ERP_target_system__c,t.case__r.Account.crm_Company_IBAN__c, t.Reference__c, (select Line_Amount__c, Article_Number__c, vare_number_NAV__c,vare_number_NAV__r.Name, Description__c, cargo_product_code__c, Regress_Account__r.crm_customer_number__c, cargo_division_code__r.unit_number_in_subsidiary__c,cargo_division_code__r.DRM_id__c, Type__c from monetary_transaction__c.Monetary_Transaction_Line_Items__r) from monetary_transaction__c t where t.Id = :mtNAV limit 1];
    mt.status__c = MonetaryTransactionsController.SUCCESS_STATUS_NAV;
    mt.OEBS_transaction_number__c='test1234';
    upsert mt;
    system.assertEquals(mt.OEBS_transaction_number__c,'test1234');
    
    }
    
    static testMethod void testBilagsnummer2(){
      String mtNAV = getTestTransaction(MonetaryTransactionsController.NAV);
    Monetary_Transaction__c mt = [select t.case__r.case_referens__c, t.case__r.account.Transaksjonskontakt__r.Email, t.id, t.status__c, t.case__r.caseNumber, t.case__r.type__c, t.case__r.code_event__r.name, t.case__r.Code_reason1__r.name, t.case__r.account.crm_customer_number__c, t.case__r.account.name, t.case__r.contact.name, t.Bank_Account_Number__c, t.Transaction_approved_date__c, t.CreatedDate, t.ERP_target_system__c,t.case__r.Account.crm_Company_IBAN__c, t.Reference__c, (select Line_Amount__c, Article_Number__c, vare_number_NAV__c,vare_number_NAV__r.Name, Description__c, cargo_product_code__c, Regress_Account__r.crm_customer_number__c, cargo_division_code__r.unit_number_in_subsidiary__c,cargo_division_code__r.DRM_id__c, Type__c, voucher_number__c from monetary_transaction__c.Monetary_Transaction_Line_Items__r) from monetary_transaction__c t where t.Id = :mtNAV limit 1];
    mt.status__c = MonetaryTransactionsController.SUCCESS_STATUS_NAV;
    String s = 'test1234';
    for(Monetary_Transaction_Line_Item__c mtl  : [select name, id, voucher_number__c from Monetary_Transaction_Line_Item__c where id = :mt.Id]){
      s += ';' + mtl.name.substring(3) + ',' + 'testlineRef' + mtl.name.substring(3);
      system.assertEquals(mtl.voucher_number__c, null);
    }
    mt.OEBS_transaction_number__c=s;
    upsert mt;
    system.assertEquals(mt.OEBS_transaction_number__c,'test1234');
    for(Monetary_Transaction_Line_Item__c mtl  : [select name, id, voucher_number__c from Monetary_Transaction_Line_Item__c where id = :mt.Id]){
      system.assertNotEquals(mtl.voucher_number__c, 'testlineRef' + mtl.name.substring(3));
    }
    
    }
    
    static testMethod void testBilagsnummerError(){
      String mtNAV = getTestTransaction(MonetaryTransactionsController.NAV);
    Monetary_Transaction__c mt = [select t.case__r.case_referens__c, t.case__r.account.Transaksjonskontakt__r.Email, t.id, t.status__c, t.case__r.caseNumber, t.case__r.type__c,t.case__r.code_event__r.name, t.case__r.Code_reason1__r.name, t.case__r.account.crm_customer_number__c, t.case__r.account.name, t.case__r.contact.name, t.Bank_Account_Number__c, t.Transaction_approved_date__c, t.CreatedDate, t.ERP_target_system__c,t.case__r.Account.crm_Company_IBAN__c, t.Reference__c, (select Line_Amount__c, Article_Number__c, vare_number_NAV__c,vare_number_NAV__r.Name, Description__c, cargo_product_code__c, Regress_Account__r.crm_customer_number__c, cargo_division_code__r.unit_number_in_subsidiary__c,cargo_division_code__r.DRM_id__c, Type__c, voucher_number__c from monetary_transaction__c.Monetary_Transaction_Line_Items__r) from monetary_transaction__c t where t.Id = :mtNAV limit 1];
    mt.status__c = MonetaryTransactionsController.SUCCESS_STATUS_NAV;
    mt.OEBS_transaction_number__c='test1234;InvalidReference,testline1';
    upsert mt;
    String ref = [select id, OEBS_transaction_number__c from monetary_transaction__c t where t.Id = :mtNAV limit 1].OEBS_transaction_number__c;
    system.assertEquals(ref,'test1234');
    for(Monetary_Transaction_Line_Item__c mtl  : [select id, voucher_number__c from Monetary_Transaction_Line_Item__c where id = :mt.Id]){
      system.assertEquals(mtl.voucher_number__c, null);
    }
    mt.OEBS_transaction_number__c='test123;InvalidReference';
    upsert mt;
    String ref2 = [select id, OEBS_transaction_number__c from monetary_transaction__c t where t.Id = :mtNAV limit 1].OEBS_transaction_number__c;
    system.assertEquals(ref2,'test1234');  
    }
    
/*******************
*** TEST HELPERS ***
*******************/

  private static String getTestTransaction(String TargetSystem){    
    Account a = new Account( Name = 'Test Account');
    if(TargetSystem == MonetaryTransactionsController.NAV){
      a.crm_customer_number__c = 'BLNOCTestPartyNo';
    } else {
      a.crm_customer_number__c = 'TestPartyNo';
    }
    insert a;
    
    Contact con = new Contact(FirstName='Test', LastName= 'Contact Name', Email='testemail@test.email');
    con.AccountId = a.Id;
    insert con;
    
    a.Transaksjonskontakt__c = con.Id;
    a.RecordTypeId = [select id from RecordType where developerName =:'business_account' limit 1].id;
    upsert a;
    
    //Case c = new Case(Description='Test', Subject ='Test', Division__c ='Logistikk Bedrift', Type='TestCaseType', code_event__c=testEvent.id, Code_reason1__c=testReason.id);
    //Csphase2 Supriya 29122016
    Case c = new Case(Description='Test', Subject ='Test', Division__c ='Logistics Business', Type='TestCaseType', code_event__c=testEvent.id, Code_reason1__c=testReason.id);
    c.AccountId = a.Id;
    c.ContactId = con.Id;
    c.amount_claimed__c=10000;
    if(TargetSystem == MonetaryTransactionsController.NAV){
      c.RecordTypeId = KATSutilities.getRecordType('Cargo_Claims');
    }
    insert c;
    
    String Reference = 'TestReference';
        String ERPTargetSystem = TargetSystem;
        String BankAccountNo='12345678903';
        Datetime TransactionApprovedDate= date.newinstance(2013, 1, 1);
        Monetary_Transaction__c m = new Monetary_Transaction__c(Bank_Account_Number__c = BankAccountNo, 
          Transaction_approved_date__c = TransactionApprovedDate, ERP_target_system__c = ERPTargetSystem, Reference__c = Reference);
        m.case__c = c.Id;
        insert(m);
        
    //Article_Number__c vareNumber = new Article_Number__c(Name='Test Product', Product_Name__c='Test Product', Transaction_Type__c = 'Refusjon' );
    //Csphase2 Supriya 29122016
    Article_Number__c vareNumber = new Article_Number__c(Name='Test Product', Product_Name__c='Test Product', Transaction_Type__c = 'Refund' );
    insert(vareNumber);
    PostalUnit__c cargoDivisionCode = new PostalUnit__c(DRM_id__c='TestDRMId1234', unit_number__c='TestUnitNumber', unit_number_in_subsidiary__c='TestUnitNumberInSub');
    insert(cargoDivisionCode);
    Double LineAmount=123.45;
    String cargoProductCode = '0000 - TestProductCode';
    String Description = 'Test description';
    string regress='Refund';
    string kredit='Credit Memo';
    Monetary_Transaction_Line_Item__c mtl = new Monetary_Transaction_Line_Item__c(Line_Amount__c=LineAmount, Type__c = regress,
                            cargo_product_code__c = cargoProductCode, Description__c = Description);
    mtl.vare_number_NAV__c = vareNumber.Id;
    mtl.cargo_division_code__c = cargoDivisionCode.Id;
    mtl.Regress_Account__c = a.Id;
    mtl.Transaksjon__c = m.id;
    insert(mtl);
    Monetary_Transaction_Line_Item__c mtl2 = new Monetary_Transaction_Line_Item__c(Line_Amount__c=LineAmount, Type__c = kredit,
                            cargo_product_code__c = cargoProductCode, Description__c = Description);
        mtl2.vare_number_NAV__c = vareNumber.Id;
    mtl2.cargo_division_code__c = cargoDivisionCode.Id;
    mtl2.Regress_Account__c = a.Id;
    mtl2.Transaksjon__c = m.id;
    mtl2.is_motpost__c  = true;
    insert(mtl2);
    
    return (m.id);
  }

    private static void prepareArticleNumbers() {
        
        list<Article_Number__c> an = new list<Article_Number__c>();
        //an.add(new Article_Number__c(Name='TEST-AN123', Service_Product__c=testProduct.id, Transaction_Type__c='Refusjon'));
        //Csphase2 Supriya 29122016
        an.add(new Article_Number__c(Name='TEST-AN123', Service_Product__c=testProduct.id, Transaction_Type__c='Refund'));
        
        list <Service_Product__c> products=new list<Service_Product__c>();
        for(integer i=0; i<200; i++) {
          Service_Product__c p=new Service_Product__c(Name='MyTestProduct'+i);   
          products.add(p);
        }
        insert products;
        
        for(integer i=0; i<200; i++) {
            //an.add(new Article_Number__c(Name='TEST-AN123'+i, Service_Product__c=products.get(i).id,Transaction_Type__c='Refusjon'));
             //Csphase2 Supriya 29122016
             an.add(new Article_Number__c(Name='TEST-AN123'+i, Service_Product__c=products.get(i).id,Transaction_Type__c='Refund'));
        }
        upsert an;
        
    }
    

}