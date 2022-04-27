// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest
private class zzz_HD_transaction {

 private   static testMethod void myUnitTest() {
       
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        String transID = getTestTransaction('NAV');

         Test.startTest();

      // Schedule the test job
      String jobId = System.schedule('HD transaction',
                        CRON_EXP, 
                        new HD_transaction());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2022-03-15 00:00:00', 
         String.valueOf(ct.NextFireTime));
       Test.stopTest();
    }
    
    private   static testMethod void myNegativeUnitTest() {
    
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        String transID = getTestTransaction('NAV');

         Test.startTest();

      // Schedule the test job
      String jobId = System.schedule('khjkjsahdjhskte',
                        CRON_EXP, 
                        new HD_transaction());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);
       Test.stopTest();
    }
    
    
       private   static testMethod void myNegativeUnitTest2() {
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        //String transID = getTestTransaction('NAV');

         Test.startTest();

      // Schedule the test job
      environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
    //    envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
      String jobId = System.schedule('khjkjsahdjhskte',
                        CRON_EXP, 
                        new HD_transaction());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);
       Test.stopTest();
    }
    
  private static String getTestTransaction(String TargetSystem){  
  
    environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
    //    envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
          
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
     Code_Event__c ce = new Code_Event__c(Name='MyTestEvent');
      insert ce;
         Code_Reason1__c r=new Code_Reason1__c(Name='MyTestReason1');
      insert r;
   // Case c = new Case(Description='Test', Subject ='Test', Division__c ='Logistics Business', Type='TestCaseType', code_event__c=ce.id, Code_reason1__c=r.id);
     Case c = new Case(Description='Test', Subject ='Test', Division__c ='Logistikk Bedrift', Type='TestCaseType', code_event__c=ce.id, Code_reason1__c=r.id);
    //Csphase2 Supriya 29122016
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
        Datetime TransactionApprovedDate = Datetime.now()-1;
        Monetary_Transaction__c m = new Monetary_Transaction__c(Bank_Account_Number__c = BankAccountNo, 
        Transaction_approved_date__c = TransactionApprovedDate, ERP_target_system__c = ERPTargetSystem, Reference__c = Reference, status__c = 'Avsluttet', IsHDTranscation__c=true);
          //Csphase2 Supriya 29122016
       // Transaction_approved_date__c = TransactionApprovedDate, ERP_target_system__c = ERPTargetSystem, Reference__c = Reference, status__c = 'Closed');
        m.case__c = c.Id;
        insert(m);
        
   Article_Number__c vareNumber = new Article_Number__c(Name='Test Product', Product_Name__c='Test Product', Transaction_Type__c = 'Refusjon' );
    //Csphase2 Supriya 29122016
   // Article_Number__c vareNumber = new Article_Number__c(Name='Test Product', Product_Name__c='Test Product', Transaction_Type__c = 'Refund' );
    
    //Refund

    insert(vareNumber);
    PostalUnit__c cargoDivisionCode = new PostalUnit__c(DRM_id__c='TestDRMId1234', unit_number__c='TestUnitNumber', unit_number_in_subsidiary__c='TestUnitNumberInSub');
    insert(cargoDivisionCode);
    Double LineAmount=123.45;
    String cargoProductCode = '0000 - TestProductCode';
    String Description = 'Test description';
  
    Monetary_Transaction_Line_Item__c mtl = new Monetary_Transaction_Line_Item__c(Line_Amount__c=LineAmount, Type__c = MonetaryTransactionsController.REGRESS,
                            cargo_product_code__c = cargoProductCode, Description__c = Description);
    mtl.vare_number_NAV__c = vareNumber.Id;
    mtl.cargo_division_code__c = cargoDivisionCode.Id;
    mtl.Regress_Account__c = a.Id;
    mtl.Transaksjon__c = m.id;
    insert(mtl);
    
    Monetary_Transaction_Line_Item__c mtl2 = new Monetary_Transaction_Line_Item__c(Line_Amount__c=LineAmount, Type__c = MonetaryTransactionsController.KREDITTNOTA,
                            cargo_product_code__c = cargoProductCode, Description__c = Description);
        mtl2.vare_number_NAV__c = vareNumber.Id;
    mtl2.cargo_division_code__c = cargoDivisionCode.Id;
    mtl2.Regress_Account__c = a.Id;
    mtl2.Transaksjon__c = m.id;
    insert(mtl2);
    
    return (m.id);
  }
    
}