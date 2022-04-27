/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.    
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest
private class zzz_Article_Exctension {
    
    private static Id evtId;//holds the eventid to event object
    //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
    //to custom Service Product object. Change by Rajeev on 12th July 2016
    private static Id proId;//holds the Service_Product__c to product object
    private static Id re1Id;//holds the reason 1 id to reason1 object
    private static Id re2Id;//holds the reason 2 id to reason2 object
    private static Id artID;

    private static ID businessRecTypeID;

    static private Id queryForBusinessRecType()
    { if(businessRecTypeID==null){
        businessRecTypeID = [Select Id From RecordType where developername = 'business_account'].Id;
    }
    return  businessRecTypeID;  
    }

    static testMethod void myUnitTest() {
        prepareArticleNumbers('1');
        crm_TestDataFactory.CreateCustomSetting();
        test.startTest();
        Account a = new Account(Name='Test Account', crm_customer_number__c='12345678', recordtypeId=queryForBusinessRecType());
        KATSutilities.upsertAsSystem(a);
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Case c = new Case(accountId=a.id, subject='Test case', Code_Event__c= evtId, Service_Product__c=proId, Code_Reason1__c =re1Id,Code_reason2__c = re2Id, Value_added_services__c='SMS');
        upsert c;
        
        monetary_transaction__c t = new monetary_transaction__c(case__c=c.id, Bank_Account_Number__c='12345678903', RecordTypeId=KATSutilities.getRecordType('Transaction'));
        upsert t;
        t = [select id, status__c, Valutakode__c from monetary_transaction__c where id=:t.id];
        system.assertEquals('Ny', t.status__c);
        system.assertEquals('NOK', t.Valutakode__c);
        
        Monetary_Transaction_Line_Item__c tlone = new Monetary_Transaction_Line_Item__c (is_motpost__c = true,Transaksjon__c = t.id, Type__c='Refusjon', Line_Amount__c=123.45);   
        PageReference pageRef = Page.addMonetaryTransactionLineItem;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('TransId', t.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(tlone);      
        Article_Extension controller = new Article_Extension(sc);
        
        insert tlone;
        Monetary_Transaction_Line_Item__c tlone1 = new Monetary_Transaction_Line_Item__c (is_motpost__c = true,Transaksjon__c = t.id, Type__c='Kompensasjon', Line_Amount__c=123.45);   
        insert tlone1;
        
        controller.loaddata();
        
        controller.createMotpost(tlone);
        controller.getMotpostItems();
        
        List<selectOption> slo1 = controller.getAllowedArticles();
        //System.assertNotEquals(slo1.size(), 1);
        
        controller.savelineitem();
        String prod = controller.getMTProduct();
        String name = controller.getMTName();
        String cur=controller.getMTCurrency();
        String rType=controller.getMTRecordTypeName();
        String stat = controller.getAccountStatus();
        Id mtid = controller.getMTid();
        PageReference pagerefcancel = controller.cancelAndBack();
        PageReference pagerefsave = controller.validateAndSave();
        String mess = controller.getMessages();
        Boolean oknok = controller.validation();
        
        
        System.assertNotEquals(controller.getItems().size(),0 );
        List<Monetary_Transaction_Line_Item__c> lineItems=controller.getItems();
        System.assertEquals(lineItems.get(0).Transaksjon__c,t.id);
        
        String s = 'input';
        controller.setTrans(s);
        system.assertEquals(controller.getTrans(),s);
        controller.setBil(s);
        system.assertEquals(controller.getBil(),s);
        controller.getTypeHelptext();
        
        test.stopTest();
        
    }
    
    
    static testMethod void myUnitTest2() {
        prepareArticleNumbers('2');
        crm_TestDataFactory.CreateCustomSetting();
        test.startTest();
        Account a = new Account(Name='Test Account', crm_customer_number__c='BLNOC12345678', recordtypeId=queryForBusinessRecType());
        KATSutilities.upsertAsSystem(a);
        Contact contact = new Contact(AccountId = a.Id, LastName = 'lastName',FirstName='test', email = 'a@b.c');
        upsert contact;
        a.Transaksjonskontakt__c = contact.Id;
        upsert a;
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Case c = new Case(accountId=a.id, subject='Test case 2', Code_Event__c= evtId, Service_Product__c=proId, Code_Reason1__c =re1Id,Code_reason2__c = re2Id, RecordTypeId=KATSutilities.getRecordType('Cargo_Claims'), amount_claimed__c = 150, Value_added_services__c='SMS');
        upsert c;
        
        monetary_transaction__c t = new monetary_transaction__c(case__c=c.id, Bank_Account_Number__c='12345678903');
        upsert t;
        t = [select id, status__c from monetary_transaction__c where id=:t.id];
        system.assertEquals('Ny', t.status__c);
        
        PostalUnit__c enhet = new PostalUnit__c (Name = 'testEnhet', DRM_id__c = 'enh.1025..1234', unit_number__c = 'EN1234', unit_number_in_subsidiary__c='DATTER1234');
        upsert enhet;
        
        Monetary_Transaction_Line_Item__c tlone = new Monetary_Transaction_Line_Item__c (Transaksjon__c = t.id,is_motpost__c =true, Type__c='Kompensasjon', Line_Amount__c=1, vare_number_NAV__c = artID, cargo_product_code__c = '1010 - HURTIGRUTE', cargo_division_code__c = enhet.Id);
        
        PageReference pageRef = Page.addMonetaryTransactionLineItem;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('TransId', t.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(tlone);      
        Article_Extension controller = new Article_Extension(sc);
        
        insert tlone;
        
        controller.loaddata();
        
        List<selectOption> slo1 = controller.getAllowedArticles();
        //System.assertEquals(slo1.size(), 3);
        test.stopTest();    
    }
    
    static testMethod void testValidationPass() {
        
        prepareArticleNumbers('2');
        crm_TestDataFactory.CreateCustomSetting();
        test.startTest();
        Account a = new Account(Name='Test Account', crm_customer_number__c='BLNOC12345678', recordtypeId=queryForBusinessRecType());
        KATSutilities.upsertAsSystem(a);
        Contact contact = new Contact(AccountId = a.Id, LastName = 'lastName',FirstName='test', email = 'a@b.c');
        upsert contact;
        a.Transaksjonskontakt__c = contact.Id;
        upsert a;
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Case c = new Case(Value_added_services__c='SMS', accountId=a.id, subject='Test case 3', Code_Event__c= evtId, Service_Product__c=proId, Code_Reason1__c =re1Id,Code_reason2__c = re2Id, RecordTypeId=KATSutilities.getRecordType('Cargo_Claims'), amount_claimed__c = 150);
        upsert c;
        
        monetary_transaction__c t = new monetary_transaction__c(case__c=c.id, Bank_Account_Number__c='12345678903');
        upsert t;
        
        PostalUnit__c enhet = new PostalUnit__c (Name = 'testEnhet', DRM_id__c = 'enh.1025..1234', unit_number__c = 'EN1234', unit_number_in_subsidiary__c='DATTER1234');
        upsert enhet;
        
        Monetary_Transaction_Line_Item__c tlone = new Monetary_Transaction_Line_Item__c (Article_Number__c= artID, Transaksjon__c = t.id, Type__c='Utbetaling', Line_Amount__c=1, vare_number_NAV__c = artID, cargo_product_code__c = '1010 - HURTIGRUTE', cargo_division_code__c = enhet.Id);
        // Monetary_Transaction_Line_Item__c tlone_unvalid = new Monetary_Transaction_Line_Item__c ( Transaksjon__c = t.id, Type__c='Utbetaling', Line_Amount__c=1, vare_number_NAV__c = artID, cargo_product_code__c = '1010 - HURTIGRUTE', cargo_division_code__c = enhet.Id);
        System.debug(artID);
        PageReference pageRef = Page.addMonetaryTransactionLineItem;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('TransId', t.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(tlone);      
        Article_Extension controller = new Article_Extension(sc);
        
        controller.loaddata();
        
        system.assertEquals(controller.validation(),true);
        
        controller.validateAndSave();
        
        test.stopTest();    
    }
    
    static testMethod void testValidationFails() {
        
        prepareArticleNumbers('2');
        crm_TestDataFactory.CreateCustomSetting();
        test.startTest();
        Account a = new Account(Name='Test Account', crm_customer_number__c='BLNOC12345678', recordtypeId=queryForBusinessRecType());
        KATSutilities.upsertAsSystem(a);
        Contact contact = new Contact(AccountId = a.Id, LastName = 'lastName',FirstName='test', email = 'a@b.c');
        upsert contact;
        a.Transaksjonskontakt__c = contact.Id;
        upsert a;
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Case c = new Case(accountId=a.id, subject='Test case 4', Code_Event__c= evtId, Service_Product__c=proId, Code_Reason1__c =re1Id,Code_reason2__c = re2Id, RecordTypeId=KATSutilities.getRecordType('Cargo_Claims'), amount_claimed__c = 150, Value_added_services__c='SMS');
        upsert c;
        
        monetary_transaction__c t = new monetary_transaction__c(case__c=c.id, Bank_Account_Number__c='12345678903');
        upsert t;
        
        PostalUnit__c enhet = new PostalUnit__c (Name = 'testEnhet', DRM_id__c = 'enh.1025..1234', unit_number__c = 'EN1234', unit_number_in_subsidiary__c='DATTER1234');
        upsert enhet;
        
        Monetary_Transaction_Line_Item__c tlone = new Monetary_Transaction_Line_Item__c (Transaksjon__c = t.id,is_motpost__c =true, Type__c='Kompensasjon', Line_Amount__c=1, vare_number_NAV__c = artID, cargo_product_code__c = '1010 - HURTIGRUTE', cargo_division_code__c = enhet.Id);
        
        PageReference pageRef = Page.addMonetaryTransactionLineItem;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('TransId', t.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(tlone);      
        Article_Extension controller = new Article_Extension(sc);
        
        system.assertEquals(controller.validation(),false); // transaccount is null
        insert tlone;
        controller.loaddata();
        controller.validation();
        
        test.stopTest();    
    }
    
    static testMethod void testValidationFails2() {
        
        prepareArticleNumbers('2');
        crm_TestDataFactory.CreateCustomSetting();
        test.startTest();
        Account a = new Account(Name='Test Account', crm_customer_number__c='BLNOC12345678', recordtypeId=queryForBusinessRecType());
        KATSutilities.upsertAsSystem(a);
        Contact contact = new Contact(AccountId = a.Id, LastName = 'lastName',FirstName='test', email = 'a@b.c');
        upsert contact;
        a.Transaksjonskontakt__c = contact.Id;
        upsert a;
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Case c = new Case(accountId=a.id, subject='Test case 5', Code_Event__c= evtId, Service_Product__c=proId, Code_Reason1__c =re1Id,Code_reason2__c = re2Id, RecordTypeId=KATSutilities.getRecordType('Cargo_Claims'), amount_claimed__c = 150, Value_added_services__c='SMS');
        upsert c;
        
        monetary_transaction__c t = new monetary_transaction__c(case__c=c.id, Bank_Account_Number__c='12345678903');
        upsert t;
        
        PostalUnit__c enhet = new PostalUnit__c (Name = 'testEnhet', DRM_id__c = 'enh.1025..1234', unit_number__c = 'EN1234', unit_number_in_subsidiary__c='DATTER1234');
        upsert enhet;
        
        Monetary_Transaction_Line_Item__c tlone = new Monetary_Transaction_Line_Item__c (is_motpost__c = true, Transaksjon__c = t.id, Type__c='', Line_Amount__c=1, vare_number_NAV__c = artID, cargo_product_code__c = '1010 - HURTIGRUTE', cargo_division_code__c = enhet.Id);
        
        PageReference pageRef = Page.addMonetaryTransactionLineItem;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('TransId', t.id);
        
        
        ApexPages.StandardController sc = new ApexPages.standardController(tlone);      
        Article_Extension controller = new Article_Extension(sc);
        
        insert tlone;
        controller.loaddata();
        
        system.assertEquals(controller.validation(),false); // monetarytransline type is ''
        test.stopTest();    
    }
    
    static testMethod void testValidationFailsRegress1() {
        
        crm_TestDataFactory.CreateCustomSetting();
        prepareArticleNumbers('2');
        test.startTest();
        Account a = new Account(Name='Test Account', crm_customer_number__c='BLNOC12345678', recordtypeId=queryForBusinessRecType());
        KATSutilities.upsertAsSystem(a);
        Contact contact = new Contact(AccountId = a.Id, LastName = 'lastName',FirstName='test', email = 'a@b.c');
        upsert contact;
        a.Transaksjonskontakt__c = contact.Id;
        upsert a;
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Case c = new Case(accountId=a.id, subject='Test case 6', Code_Event__c= evtId, Service_Product__c=proId, Code_Reason1__c =re1Id,Code_reason2__c = re2Id, RecordTypeId=KATSutilities.getRecordType('Cargo_Claims'), amount_claimed__c = 150, Value_added_services__c='SMS');
        upsert c;
        
        monetary_transaction__c t = new monetary_transaction__c(case__c=c.id, Bank_Account_Number__c='12345678903');
        upsert t;
        PostalUnit__c enhet = new PostalUnit__c (Name = 'testEnhet', DRM_id__c = 'enh.1025..1234', unit_number__c = 'EN1234', unit_number_in_subsidiary__c='DATTER1234');
        upsert enhet;
        
        Monetary_Transaction_Line_Item__c tlone = new Monetary_Transaction_Line_Item__c (Transaksjon__c = t.id, Type__c='Regress', Line_Amount__c=1);
        
        PageReference pageRef = Page.addMonetaryTransactionLineItem;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('TransId', t.id);
        ApexPages.StandardController sc = new ApexPages.standardController(tlone);      
        Article_Extension controller = new Article_Extension(sc);
        
        //insert tlone;
        controller.loaddata();
        
        
        system.assertEquals(controller.validation(),false); // Regress fields are blank. 
        
        test.stopTest();    
    }
    
    
    static testMethod void testMotpost1(){
        crm_TestDataFactory.CreateCustomSetting();
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Service_Product__c pro = new Service_Product__c(Name='Test Product', Product_Code__c='Test Product',Product_Description__c='TEST',IsActive__c=true);
        upsert pro;
        article_number__c art = new article_number__c(Name='TEST1',Service_Product__c =pro.id,Transaction_Type__c ='Refusjon', Value_added_service__c='SMS');
        insert art;
        Account a = new Account(Name='Test Account', crm_customer_number__c='BLNOC12345678', recordtypeId=queryForBusinessRecType());
        KATSutilities.upsertAsSystem(a);
        Contact contact = new Contact(AccountId = a.Id, LastName = 'lastName',FirstName='test', email = 'a@b.c');
        insert contact;
        a.Transaksjonskontakt__c = contact.Id;
        upsert a;
        Code_Event__c evt = new Code_Event__c(Name='HendelseTest',IsActive__c=true);
        insert evt;
        
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Code_Event_Prod__c evtpro = new Code_Event_Prod__c(Code_Event__c = evt.id,Service_Product__c=pro.id,IsActive__c=true );
        insert evtpro;
        
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Case c = new Case(accountId=a.id, subject='Test case 2', Code_Event__c= evt.Id, Service_Product__c=pro.Id, RecordTypeId=KATSutilities.getRecordType('Cargo_Claims'), amount_claimed__c = 150, Value_added_services__c='SMS');
        insert c;
        
        
        monetary_transaction__c t = new monetary_transaction__c(case__c=c.id, Bank_Account_Number__c='12345678903');
        insert t;
        PostalUnit__c enhet = new PostalUnit__c (Name = 'testEnhet', DRM_id__c = 'enh.1025..1234', unit_number__c = 'EN1234', unit_number_in_subsidiary__c='DATTER1234');
        insert enhet;
        
        Monetary_Transaction_Line_Item__c tlone = new Monetary_Transaction_Line_Item__c (is_motpost__c =true,Transaksjon__c = t.id, Type__c='Refusjon', Line_Amount__c=1, vare_number_NAV__c = art.ID, cargo_product_code__c = '1010 - HURTIGRUTE', cargo_division_code__c = enhet.Id);
        insert tlone;

        PageReference pageRef = Page.addMonetaryTransactionLineItem;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('TransId', t.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(new Monetary_Transaction_Line_Item__c ());      
        Article_Extension controller = new Article_Extension(sc);     
        controller.LoadData();
        controller.getMotpostItems(); // Test to crceate items
        controller.setIsMotpostTrue();
        controller.setMotpostDesc('beskrivelse');
        PageReference validateAndSaveMotpost = controller.validateAndSaveMotpost();
        
        List<Monetary_Transaction_Line_Item__c> result= [select id, is_motpost__c from Monetary_Transaction_Line_Item__c where Transaksjon__c =:t.id];
        PageReference validateAndSaveMotpost2 = controller.validateAndSaveMotpost();
        //System.assertEquals(2, result.size());
        
    }
    /*******************
*** TEST HELPERS ***
*******************/
    private static void prepareArticleNumbers(String nr) {
        
        crm_TestDataFactory.CreateCustomSetting();
        //Create an event type and connect product and reason to this.
        Code_Event__c evt = new Code_Event__c(Name='HendelseTest',IsActive__c=true);
        upsert evt;
        evtId = evt.id;
        
        if(nr == '1'){
            //Upsert an product first before you can relate the article to the product for test
            //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
            //to custom Service Product object. Change by Rajeev on 12th July 2016
            Service_Product__c pro = new Service_Product__c(Name='Test Product1', Product_Code__c='Test Product',Product_Description__c='TEST',IsActive__c=true);
            upsert pro;
            proId = pro.id;
            
            //Upsert article
            article_number__c art = new article_number__c(Name='TEST1',Service_Product__c =proId,Transaction_Type__c ='Refusjon', Value_added_service__c='SMS');
            upsert art;
            artID = art.id;   
        }
        if(nr == '2'){
            //Upsert an product first before you can relate the article to the product for test
            //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
            //to custom Service Product object. Change by Rajeev on 12th July 2016
            Service_Product__c pro = new Service_Product__c(Name='Test Service_Product__c', Product_Code__c='47110U',Product_Description__c='TEST - reklamasjon gods',IsActive__c=true);
            upsert pro;
            proId = pro.id;
            
            //Upsert article
            article_number__c art = new article_number__c(Name='47110U',Service_Product__c =proId);
            upsert art;
            artID = art.id;
        }
        if(nr== '3'){
            //Upsert an product first before you can relate the article to the product for test
            //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
            //to custom Service Product object. Change by Rajeev on 12th July 2016
            Service_Product__c pro = new Service_Product__c(Name='Test Product3', Product_Code__c='47110U',Product_Description__c='TEST - reklamasjon gods',IsActive__c=true);
            upsert pro;
            proId = pro.id;
            
            //Upsert article
            article_number__c art = new article_number__c(Name='47110U',Service_Product__c =proId, Value_added_service__c='SMS', Transaction_Type__c ='Refusjon');
            upsert art;
            artID = art.id;
        } 
        
        //Create an relationship between event and product
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Code_Event_Prod__c evtpro = new Code_Event_Prod__c(Code_Event__c = evtId,Service_Product__c=proId,IsActive__c=true );
        upsert evtpro;
        
        Code_Reason1__c re1 = new Code_Reason1__c(Name='Årsak1');
        upsert re1;
        re1Id = re1.id;
        
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        CodeProdReason__c prorea = new CodeProdReason__c(Service_Product__c=proId, Code_reason1__c=re1Id,IsActive__c=true);
        upsert prorea;
        
        Code_Reason2__c re2 = new Code_Reason2__c(Name='Årsak2');
        upsert re2;
        re2Id = re2.id;
        
        Code_Reason_12__c re12 = new Code_Reason_12__c(Code_reason1__c=re1Id, Code_reason2__c=re2Id,IsActive__c=true);
        
        
        
        /*list<Article_Number__c> an = new list<Article_Number__c>();
an.add(new Article_Number__c(Name='TEST-AN123', Service_Product__c=proId, Transaction_Type__c='Refusjon'));
for(integer i=0; i<200; i++) {
an.add(new Article_Number__c(Name='TEST-AN123'+i, Service_Product__c=proId, Transaction_Type__c='Refusjon'));
}
upsert an;
*/
        
    }    

  ///////////////////////////////////////////////////////////////////////////////
    static testMethod void testMotpost1111(){
        crm_TestDataFactory.CreateCustomSetting();
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Service_Product__c pro = new Service_Product__c(Name='Test Product', Product_Code__c='Test Product',Product_Description__c='TEST',IsActive__c=true);
        upsert pro;
        article_number__c art = new article_number__c(Name='TEST1',Service_Product__c =pro.id,Transaction_Type__c ='Refusjon', Value_added_service__c='SMS');
        insert art;
        Account a = new Account(Name='Test Account', crm_customer_number__c='BLNOC12345678', recordtypeId=queryForBusinessRecType());
        KATSutilities.upsertAsSystem(a);
        Contact contact = new Contact(AccountId = a.Id, LastName = 'lastName',FirstName='test', email = 'a@b.c');
        insert contact;
        a.Transaksjonskontakt__c = contact.Id;
        upsert a;
        Code_Event__c evt = new Code_Event__c(Name='HendelseTest',IsActive__c=true);
        insert evt;
        
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Code_Event_Prod__c evtpro = new Code_Event_Prod__c(Code_Event__c = evt.id,Service_Product__c=pro.id,IsActive__c=true );
        insert evtpro;
        
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Case c = new Case(accountId=a.id, subject='Test case 2', Code_Event__c= evt.Id, Service_Product__c=pro.Id, RecordTypeId=KATSutilities.getRecordType('Cargo_Claims'), amount_claimed__c = 150, Value_added_services__c='SMS');
        insert c;
        
        
        monetary_transaction__c t = new monetary_transaction__c(case__c=c.id, Bank_Account_Number__c='12345678903');
        insert t;
        PostalUnit__c enhet = new PostalUnit__c (Name = 'testEnhet', DRM_id__c = 'enh.1025..1234', unit_number__c = 'EN1234', unit_number_in_subsidiary__c='DATTER1234');
        insert enhet;
        
        Monetary_Transaction_Line_Item__c tlone1 = new Monetary_Transaction_Line_Item__c (is_motpost__c =true,Transaksjon__c = t.id, Type__c='Kompensasjon', Line_Amount__c=1, vare_number_NAV__c = art.ID, cargo_product_code__c = '1010 - HURTIGRUTE', cargo_division_code__c = enhet.Id);
        insert tlone1;

        PageReference pageRef = Page.addMonetaryTransactionLineItem;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('TransId', t.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(new Monetary_Transaction_Line_Item__c ());      
        Article_Extension controller = new Article_Extension(sc);     
        controller.LoadData();
        controller.getMotpostItems(); // Test to crceate items
        controller.setIsMotpostTrue();
        controller.setMotpostDesc('beskrivelse');
        controller.getMTCurrency();
        //controller.getBil();
        controller.getTrans();
        controller.getMTName();
        controller.getAccountStatus();
        PageReference validateAndSaveMotpost = controller.validateAndSaveMotpost();
        
        List<Monetary_Transaction_Line_Item__c> result= [select id, is_motpost__c from Monetary_Transaction_Line_Item__c where Transaksjon__c =:t.id];
        PageReference validateAndSaveMotpost2 = controller.validateAndSaveMotpost();
        //System.assertEquals(2, result.size());
        
    }
  
  
    
        static testMethod void testMotpost2222(){
        crm_TestDataFactory.CreateCustomSetting();
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Service_Product__c pro = new Service_Product__c(Name='Test Product', Product_Code__c='Test Product',Product_Description__c='TEST',IsActive__c=true);
        upsert pro;
        article_number__c art = new article_number__c(Name='TEST1',Service_Product__c =pro.id,Transaction_Type__c ='Refusjon', Value_added_service__c='SMS');
        insert art;
        Account a = new Account(Name='Test Account', crm_customer_number__c='BLNOC12345678', recordtypeId=queryForBusinessRecType());
        KATSutilities.upsertAsSystem(a);
        Contact contact = new Contact(AccountId = a.Id, LastName = 'lastName',FirstName='test', email = 'a@b.c');
        insert contact;
        a.Transaksjonskontakt__c = contact.Id;
        upsert a;
        Code_Event__c evt = new Code_Event__c(Name='HendelseTest',IsActive__c=true);
        insert evt;
        
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Code_Event_Prod__c evtpro = new Code_Event_Prod__c(Code_Event__c = evt.id,Service_Product__c=pro.id,IsActive__c=true );
        insert evtpro;
        
        //Added as a part of P3CRM-Sales project. Removing reference from standard Product Object
        //to custom Service Product object. Change by Rajeev on 12th July 2016
        Case c = new Case(accountId=a.id, subject='Test case 2', Code_Event__c= evt.Id, Service_Product__c=pro.Id, RecordTypeId=KATSutilities.getRecordType('Cargo_Claims'), amount_claimed__c = 150, Value_added_services__c='SMS');
        insert c;
        
        
        monetary_transaction__c t = new monetary_transaction__c(case__c=c.id, Bank_Account_Number__c='12345678903');
        insert t;
        PostalUnit__c enhet = new PostalUnit__c (Name = 'testEnhet', DRM_id__c = 'enh.1025..1234', unit_number__c = 'EN1234', unit_number_in_subsidiary__c='DATTER1234');
        insert enhet;
        
        Monetary_Transaction_Line_Item__c tlone1 = new Monetary_Transaction_Line_Item__c (is_motpost__c =false,Transaksjon__c = t.id, Type__c='Manuell behandling', Line_Amount__c=1, vare_number_NAV__c = art.ID, cargo_product_code__c = '1010 - HURTIGRUTE', cargo_division_code__c = enhet.Id);
        insert tlone1;
        Test.startTest();

        PageReference pageRef = Page.addMonetaryTransactionLineItem;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('TransId', t.id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(new Monetary_Transaction_Line_Item__c ());      
        Article_Extension controller = new Article_Extension(sc);     
        controller.LoadData();
        controller.getMotpostItems(); // Test to crceate items
        controller.setIsMotpostTrue();
        controller.setMotpostDesc('beskrivelse');
        controller.getMTCurrency();
        controller.getBil();
        controller.getTrans();
        controller.getMTName();
        controller.getAccountStatus();
        PageReference validateAndSaveMotpost = controller.validateAndSaveMotpost();
        
        List<Monetary_Transaction_Line_Item__c> result= [select id, is_motpost__c from Monetary_Transaction_Line_Item__c where Transaksjon__c =:t.id];
        PageReference validateAndSaveMotpost2 = controller.validateAndSaveMotpost();
           Test.stopTest();
        //System.assertEquals(2, result.size());
        
    }
    
}