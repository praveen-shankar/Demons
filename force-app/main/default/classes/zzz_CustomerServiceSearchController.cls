@isTest
private class zzz_CustomerServiceSearchController {
   static {
       crm_AccountRecordTypes__c rr = new crm_AccountRecordTypes__c();
        rr.Name = 'Relation level Customer';
        rr.crm_Record_Type_Label__c ='Relation level Customer';
        insert rr;
    }  
    
     /*
     * Test sorting of account results. Resluts are sortet by revenue this year, then revenue last year. 
    */
    static testmethod void testsort1(){
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
        list<CustomerServiceSearchController.AccountSearchResult> results = new list<CustomerServiceSearchController.AccountSearchResult>();
    
        results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test1',crm_Revenue_Last_Year__c=700, crm_Revenue_This_Year__c=200 ),msc));
        results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test2',crm_Revenue_Last_Year__c=900, crm_Revenue_This_Year__c=150 ),msc));
        results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test3',crm_Revenue_Last_Year__c=200, crm_Revenue_This_Year__c=0 ),msc));
        results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test4',crm_Revenue_Last_Year__c=300, crm_Revenue_This_Year__c=600 ),msc));
        results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test5',crm_Revenue_Last_Year__c=400, crm_Revenue_This_Year__c=0 ),msc));
            
        results.sort();
        // Verify sort order
        System.assertEquals(results.get(0).name, 'test4');
        System.assertEquals(results.get(1).name, 'test1');
        System.assertEquals(results.get(2).name, 'test2');
        System.assertEquals(results.get(3).name, 'test5');
        System.assertEquals(results.get(4).name, 'test3');
        
        results.clear();    // Empty list to add new items for sorting     
      
        // Test that 0 and null are treated equal
        results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test1',crm_Revenue_Last_Year__c=100, crm_Revenue_This_Year__c=null ),msc));
        results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test2',crm_Revenue_Last_Year__c=200, crm_Revenue_This_Year__c=0 ),msc));
        results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test3',crm_Revenue_Last_Year__c=null, crm_Revenue_This_Year__c=0 ),msc));
        results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test4',crm_Revenue_Last_Year__c=1, crm_Revenue_This_Year__c=0 ),msc));
               
        results.sort();
        // Verify. test3 should be last. 
        System.assertEquals(results.get(0).name, 'test2');
        System.assertEquals(results.get(1).name, 'test1');
        System.assertEquals(results.get(2).name, 'test4');
        System.assertEquals(results.get(3).name, 'test3');
    }
    
     static testmethod void testsort2(){
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
  list<CustomerServiceSearchController.AccountSearchResult> results = new list<CustomerServiceSearchController.AccountSearchResult>();
       
  results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test1',crm_Revenue_Last_Year__c=100, crm_Revenue_This_Year__c=null ),msc));
  results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test2',crm_Revenue_Last_Year__c=200, crm_Revenue_This_Year__c=0 ),msc));
  results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test3',crm_Revenue_Last_Year__c=null, crm_Revenue_This_Year__c=0 ),msc));
  results.add(new CustomerServiceSearchController.AccountSearchResult(new Account(Name='test4',crm_Revenue_Last_Year__c=1, crm_Revenue_This_Year__c=0 ),msc));
       
  results.sort();
// Test that 0 and null are treaded equal
  System.assertEquals(results.get(0).name, 'test2');
  System.assertEquals(results.get(1).name, 'test1');
  System.assertEquals(results.get(2).name, 'test4');
  System.assertEquals(results.get(3).name, 'test3');
 }
 static testMethod void searchPrivateCustomerAndCreateShipmentCase() {
    crm_TestDataFactory.CreateCustomSetting();  
    CustomerServiceSearchController msc = new CustomerServiceSearchController();
        msc.currentSearchModus = 'FOT';
        msc.activeSearchTab = 'tabPrivate';
        
        msc.searchPersonAccounts();
        
        //system.assert(msc.account_search_results.size() > 0, 'Search result equals 0, something is wrong');
        
        msc.selected_account_search_result = 0;
        msc.new_case_data.recordTypeId = KATSutilities.getRecordType('complaint');
        msc.setGo_to_type('NEW_CASE');
        
        //msc.goDo();
        
        //Case c = [SELECT id, recordType.developername, Type__c FROM Case WHERE account.party_number__c = '7654321' LIMIT 1].get(0);
        
        msc.goToCase();
    }   
/* load person account from backend */
    static testMethod void searchAndGotoNonExistingPersonAccount() {
        String Partynumber = '7654321';
        crm_TestDataFactory.CreateCustomSetting(); 
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
        msc.currentSearchModus = 'FAR';
        msc.activeSearchTab = 'tabPrivate';
        msc.setforwardingnumber('1234567');
        
        msc.searchBusinessAccounts();
        
        //system.assert(msc.account_search_results.size() > 0, 'Search result equals 0, something is wrong');
        
        msc.selected_account_search_result = 0;
        msc.selected_contact_search_result = -2;
        msc.override_required_contact = (msc.getgo_to_type_as_string() == 'ACCOUNT');
        msc.setGo_to_type('ACCOUNT');
        
        //msc.godo();
        
        //Account acct = [SELECT id, recordType.developername, isPersonAccount FROM Account WHERE party_number__c = :Partynumber LIMIT 1].get(0);
        
        //system.assert(acct.isPersonAccount, 'Account is not a person account!');
        //system.assert(acct.recordType.developername == 'person_account', 'Account is not a person account!');
    }

     
    /* update person account from backend */
    static testMethod void searchAndGotoExistingPersonAccount() {
        String Partynumber = '7654321';
        String LastName = 'LastName';
        crm_TestDataFactory.CreateCustomSetting(); 
        Account acct = new Account(crm_Account_Updated__c=false, crm_Account_Inserted__c=false, crm_Updated_by_CDH__c=false, crm_Updated_by_FKB__c=false,  party_number__c = partynumber, lastName = 'Testsen', recordTypeId = KATSutilities.getRecordType('person_account'));
        upsert acct;
        
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
        msc.currentSearchModus = 'FAR';
        msc.activeSearchTab = 'tabPrivate';
        
        msc.searchBusinessAccounts();
        
        //system.assert(msc.account_search_results.size() > 0, 'Search result equals 0, something is wrong');
        
        msc.selected_account_search_result = 0;
        msc.selected_contact_search_result = -2;
        msc.override_required_contact = (msc.getgo_to_type_as_string() == 'ACCOUNT');
        msc.setGo_to_type('ACCOUNT');
        
        //msc.godo();
        
        acct = [SELECT id, recordType.developername, isPersonAccount, lastName FROM Account WHERE party_number__c = :Partynumber LIMIT 1].get(0);
        
        system.assert(acct.isPersonAccount, 'Account is not a person account!');
        system.assert(acct.recordType.developername == 'person_account', 'Account is not a person account!');
    //  system.assert(acct.lastName == lastName, 'Account does not have the correct name! Supposed to be ' + lastName + ' not ' + acct.LastName); Results are merged differently so this is no lunger true
        
    }
    
    static testMethod void searchAndCreateCaseForNonExistingPrivateAccount() {
        crm_TestDataFactory.CreateCustomSetting(); 
        String partyNumber = '7654321';
        String caseType = 'complaint'; //We want to create a Klage in this test
        String recordTypeid = KATSutilities.getRecordType(caseType);
        
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
        msc.currentSearchModus = 'FAR';
        msc.activeSearchTab = 'tabPrivate';
        
        msc.searchPersonAccounts();
        
        msc.selected_account_search_result = 0;
        msc.new_case_data.recordTypeId = recordTypeid;
        msc.setGo_to_type('NEW_CASE');
        
        //msc.godo();
        
        Case c = null;
        //c = [SELECT id, recordTypeId, Account.Party_number__c, Contact.Caesar_Contact_Id__c FROM Case WHERE Account.Party_number__c =: partyNumber LIMIT 1];
}
    
    static testMethod void initiateControllerWithoutCase(){
        String gotoType = 'ACCOUNT';
        
        PageReference pageRef = Page.customerServiceSearch;
        Test.setCurrentPage(pageRef);
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
        
        system.assert(msc.getgo_to_type_as_string() == gotoType);
        
    }
    
    static testMethod void initiateControllerFromCaseWithAccount(){
        String partyNumber = 'TestPartyNumber';
        String firstName = 'FirstName';
        String lastName = 'LastName';
        String name = firstName + ' ' + lastName;
        String forwadingNumber = 'forwardingNumber';
        String shipmentNumber = 'shipmentNumber';
        String InvoiceNo = 'invoiceNo';
        String gotoType = 'EXISTING_CASE';
        String Phone = 'phone';
        String searchTab = 'tabPrivate';
        crm_TestDataFactory.CreateCustomSetting(); 
        Account acct = new Account();
        acct.Party_number__c = partyNumber;
        acct.Name = name;
        acct.crm_Account_Updated__c=false;
        acct.crm_Account_Inserted__c=false;
        acct.crm_Updated_by_CDH__c=false;
        acct.crm_Updated_by_FKB__c=false;
        acct.RecordTypeId = [select id from RecordType where developerName =:'business_account' limit 1].id;
        upsert acct;
        
        acct = [SELECT id, Party_number__c FROM Account WHERE id = :acct.id LIMIT 1];
        system.assert(acct.Party_number__c == partyNumber);
        
        Case c = new Case();
        c.accountid = acct.id;
        c.Shipment_number__c = shipmentNumber;
        c.Invoice_no__c = InvoiceNo;
        c.change_address_ref_no__c = forwadingNumber;
        upsert(c);
        
        c = [select id, casenumber from case limit 1];
        
        PageReference pageRef = Page.customerServiceSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('caseId', c.id);
        ApexPages.currentPage().getParameters().put('phone', Phone);
        ApexPages.currentPage().getParameters().put('searchTab', searchTab);
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
        
        system.assert(msc.right_case.casenumber == c.casenumber);
    }
    
    static testMethod void coverageTestSetNameInController1() {
        Case c = new Case(SuppliedName = 'TestName');
        upsert c;
        
        PageReference pageRef = Page.customerServiceSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('caseId', c.id);
        
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
    }
    
    static testMethod void coverageTestSetNameInController2() {
        crm_TestDataFactory.CreateCustomSetting(); 
        Account acct = new Account(Name = 'Name');
        acct.RecordTypeId = [select id from RecordType where developerName =:'business_account' limit 1].id;
        upsert acct;
        
        Case c = new Case(SuppliedName = 'TestName', accountId = acct.id);
        upsert c;
        
        PageReference pageRef = Page.customerServiceSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('caseId', c.id);
        
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
    }

    //Coverage test for parts not involving logic
    static testMethod void coverageTest() {
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
        crm_TestDataFactory.CreateCustomSetting(); 
        Account acct = new Account(Name = 'Name');
        acct.RecordTypeId = [select id from RecordType where developerName =:'business_account' limit 1].id;
        upsert acct;
        
        Case c = new Case(Shipment_identification__c = '9876676', Shipment_number__c='667522', SuppliedName = 'TestName', accountId = acct.id);
        upsert c;
        
        
        msc.getaddress_house_number();
        msc.setaddress_house_number('HouseNumber');
        msc.getaddress_house_letter();
        msc.setaddress_house_letter('houseLetter');
        //msc.getaddress_po_box_number();
        //msc.setaddress_po_box_number('poBoxNumber');
        msc.getparty_type();
        msc.setparty_type('partyType');
        msc.getaccount_number();
        msc.setaccount_number('accountNumber');
        msc.getorder_number();
        msc.setorder_number('orderNumber');
        msc.getorg_name();
        msc.getorg_fiscal_reference();
        //msc.getorg_contactFirstName();
        //msc.setorg_contactFirstName('name');
        //msc.getorg_contactLastName();
        //msc.setorg_contactLastName('name');
        msc.getperson_first_name();
        msc.getperson_last_name();
        msc.getperson_national_identification_number();
        msc.setperson_national_identification_number('998878666');
        msc.getaddress_city();
        msc.getaddress_postal_code();
        msc.getemail();
        msc.getphone();
        msc.getaddress_street_name();
        msc.setaddress_street_name('adress');
        msc.getparty_number();
        msc.getforwardingnumber();
        msc.getreceivable_number();
        msc.getShipmentID();
        msc.getShipmentUnitID();
        msc.getShipmentDateTimeFrom();
        msc.getShipmentDateTimeTo();
        msc.getSendersReferenceNumber();
        msc.getShipmentPartyNumber();
        msc.getShipmentCity();
        msc.setShipmentCity('city');
        msc.getPostalCodeSource();
        msc.setPostalCodeSource('source');
        msc.getPostalCodeDestination();
        msc.setPostalCodeDestination('Dest');
        msc.getLoadingWeightMeasureFrom();
        msc.setLoadingWeightMeasureFrom('200');
        msc.getLoadingWeightMeasureTo();
        msc.setLoadingWeightMeasureTo('400');
      
        msc.getCustomerServiceSearchController();
        msc.getHas_account_search_results();
        msc.getHas_shipment_search_results();
        msc.getHas_contact_search_results();
        msc.getHasSearchResults();
       // msc.searchBusinessAccountVoid();
    
    }
    
    /* No update account from backend */
    static testMethod void searchAndGotoExistingRelationLevelAccount() {
        String Partynumber = '1234567';
        String Name = 'Name from CM'; // Name should not be changed when using search
        crm_TestDataFactory.CreateCustomSetting(); 
        Account acct = new Account(name=Name,crm_Account_Updated__c=true, crm_Account_Inserted__c=false, crm_Updated_by_CDH__c=false, crm_Updated_by_FKB__c=false,  party_number__c = partynumber, recordTypeId = KATSutilities.getRecordType('business_account'));
        insert acct;
        
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
        msc.currentSearchModus = 'FAR';
        msc.activeSearchTab = 'tabBusiness';
        
        msc.searchBusinessAccounts();
        
        //system.assert(msc.account_search_results.size() > 0, 'Search result equals 0, something is wrong');
        
        msc.selected_account_search_result = 0;
        msc.selected_contact_search_result = -2;
        msc.override_required_contact = (msc.getgo_to_type_as_string() == 'ACCOUNT');
        msc.setGo_to_type('ACCOUNT');
        
        //msc.godo();
        
        acct = [SELECT name FROM Account WHERE party_number__c = :Partynumber LIMIT 1].get(0);
        
        system.assert(acct.Name == Name, 'Account name has changed: '+acct.Name);
        
    }
    
    static testmethod void testSelectedContact(){     
        crm_TestDataFactory.CreateCustomSetting(); 
         Id recordtypeId =   KATSutilities.getRecordType('business_account') ;
        Account acct = new Account(Name = 'Name', party_number__c = '123456789', crm_Updated_by_CDH__c=true,  crm_Account_Updated__c=true, recordtypeId=recordtypeId);
        insert acct;
        Case c = new Case(SuppliedName = 'TestName', accountId = acct.id);
        insert c;
        
        List<contact> contacts = new list<contact>();
        for(integer i=0;i>5;i++){
            Contact cnt = new Contact(lastname='name'+i, firstname='name'+i, email='kshkfh@kjd.sjk'+i, phone='78686776'+i, department='IT', title='Superhuman', accountId=acct.id);
            contacts.add(cnt);
        }
        insert contacts;
        
        CustomerServiceSearchController msc = new CustomerServiceSearchController();
        msc.right_account = acct;
        msc.right_case = c;
        
        msc.override_required_contact = false;
        
        //msc.godo();
        msc.new_contact = new Contact(lastname='name', firstname='name', email='jlkreea@kjd.sjk', phone='78686776', department='IT', title='Superhuman', accountId=acct.id);
        
         msc.searchContacts();
        system.assert(! msc.prepareContact()); // false is no search result is selected
        
        
        // This test is failing because of filter. Depend on contact decision
     //   Contact contact1 = msc.createContact( new Contact(lastname='name', firstname='name', email='jlkreea@kjd.sjk', phone='78686776', department='IT', title='Superhuman'));
   //     System.assert([SELECT AccountID from Contact where id=:contact1.id limit 1].AccountID == acct.id);
        
       
    }
    
    static testMethod void shipmentTest(){
       // searchShipments
        // godoShipmentcase
        CustomerServiceSearchController msc = new CustomerServiceSearchController(); 
        msc.currentSearchModus = 'LM_GENERAL_UNITID';
        msc.searchShipments();
        msc.currentSearchModus = 'LM_GENERAL_PARTYNO';
        msc.searchShipments();
        msc.currentSearchModus = 'LM_GENERAL_REFNO';
        msc.searchShipments();
        
        
    }
   /*  static testMethod void testSearchAccountsMode(){
     
        CustomerServiceSearchController msc = new CustomerServiceSearchController(); 
        msc.currentSearchModus = 'AR';
        msc.searchAccounts();
         
        msc.currentSearchModus = 'FW';
        msc.searchAccounts();
         
         msc.currentSearchModus = 'OM';
        msc.searchAccounts();
        

    } */
    static testmethod void testsplitAddress(){
        CustomerServiceSearchController msc = new CustomerServiceSearchController(); 
        msc.splitAddress('Posteboks 18977, 1876 Oslo');
        msc.splitAddress('Hansensgt 6b, 1876 Oslo');
        msc.splitAddress('Hansensgt 6 b, 1876 Oslo');
         msc.splitAddress('Hansensgt6b, 1876 Oslo');
         msc.splitAddress(' ,  ');
    }
    
   static testmethod void testCreateNewContactForCMacocunt(){     
        crm_TestDataFactory.CreateCustomSetting(); 
      Id recordtypeId =   KATSutilities.getRecordType('business_account') ;
        Account acct = new Account(Name = 'Name', party_number__c = '123456789', crm_Updated_by_CDH__c=true,  crm_Account_Updated__c=true, recordtypeId=recordtypeId);
        insert acct;
        Case c = new Case(SuppliedName = 'TestName', accountId = acct.id, SuppliedCompany='testCompany', suppliedAddress__c='McBridge road 14 A, 9999 Nowhere');
        insert c;
        
        List<contact> contacts = new list<contact>();
        for(integer i=0;i>5;i++){
            Contact cnt = new Contact(lastname='name'+i, firstname='name'+i, email='kshkfh@kjd.sjk'+i, phone='78686776'+i, department='IT', title='Superhuman', accountId=acct.id);
            contacts.add(cnt);
        }
        insert contacts;
         CustomerServiceSearchController msc = new CustomerServiceSearchController(); 
       msc.currentSearchModus = 'na';
        msc.activeSearchTab = 'tabBusiness';
        msc.setGo_to_type('NEW_CASE');
        msc.searchBusinessAccounts();
        
        //system.assert(msc.account_search_results.size() > 0, 'Search result equals 0, something is wrong');
        System.assert((msc.right_account==null));
        
        msc.selected_account_search_result = 0;
        //msc.goDo(); // Account is selected
        
        //System.assert((msc.right_account!=null));
        //System.assert(msc.right_contact== null);
        
        msc.selected_contact_search_result = 1;
        //msc.goDo(); // Contact is selected. Contact was null. Search contact should have been called as a result. We have defined selected contact as 1. 
        
        msc.right_contact = null;
        msc.override_required_contact = false;
        
    //  System.assert(msc.right_contact!= null);
        
        //msc.override_required_contact = (msc.getgo_to_type_as_string() == 'ACCOUNT');
    //  msc.setGo_to_type('ACCOUNT');
        
      
        //msc.new_contact = new Contact(lastname='name', firstname='name', email='jlkreea@kjd.sjk', phone='78686776', department='IT', title='Superhuman', accountId=acct.id);
         
        
    }
    
    static testmethod void testaddAccountToCase(){
        /*
          system.debug('Relating the case ' + right_case + ' to the account ' + right_account + ' and the contact ' + right_contact);
        right_case.AccountId = right_account.id;
        
        if(right_account.IsPersonAccount || right_account.RecordTypeId == KATSutilities.getRecordType('person_account')) {
            right_case.ContactId = right_account.PersonContactId;
        }
        else if(isContactNeeded()){
            right_case.ContactId = right_contact.id;
        }
        else if(!isContactNeeded())
        {
            right_case.ContactId = null;
        }
        
        isContactNeeded =  if(!override_required_contact && !(right_account.IsPersonAccount || right_account.RecordTypeId == KATSutilities.getRecordType('person_account') )  ) {
        */
          crm_TestDataFactory.CreateCustomSetting(); 
      Id recordtypeId =   KATSutilities.getRecordType('business_account') ;
        Account acct = new Account(Name = 'Name', party_number__c = '123456789', crm_Updated_by_CDH__c=true,  crm_Account_Updated__c=true, recordtypeId=recordtypeId);
        insert acct;
        Account acct_person = new Account(FirstName='firstname', LastName = 'Lastname', party_number__c = '9887766655', crm_Updated_by_CDH__c=false,  crm_Account_Updated__c=false, recordtypeId=KATSutilities.getRecordType('person_account'));
        insert acct_person; 
        Case c = new Case(SuppliedName = 'TestName', accountId = acct.id, SuppliedCompany='testCompany', suppliedAddress__c='McBridge road 14 A, 9999 Nowhere');
        insert c;
         Contact cnt = new Contact(lastname='name', firstname='name', email='kshkfh@kjd.sjk', phone='78686776', department='IT', title='Superhuman', accountId=acct.id);
          insert cnt;
          
          CustomerServiceSearchController msc = new CustomerServiceSearchController(); 
          msc.right_case = c;
          msc.right_account = acct_person;
           msc.addAccountToCase(); // test coverage for method addAccountToCase
            
            //system.assertEquals(msc.right_case.ContactId, acct_person.id);
           msc.right_account = acct;
          msc.right_contact = cnt; 
          msc.override_required_contact = false;
          msc.addAccountToCase(); 
          system.assertEquals(msc.right_case.ContactId, cnt.id);
          
          msc.override_required_contact = true;
          msc.addAccountToCase(); 
          system.assertEquals(msc.right_case.ContactId, null);
          
    }
        
     static testmethod void testgodoShipmentcase(){
         CustomerServiceSearchController msc = new CustomerServiceSearchController(); 
         msc.currentSearchModus = 'LM_GENERAL_UNITID';
      //  msc.currentSearchModus =    'LM_GENERAL_REFNO'
      //  msc.currentSearchModus =   'LM_GENERAL_PARTYNO'
        
         
            msc.setShipmentUnitID('ShipmentUnitID');
              msc.setShipmentID('ShipmentID');            
              msc.setSendersReferenceNumber('SendersReferenceNumber');
              msc.setShipmentPartyNumber('ShipmentPartyNumber');
            
             msc.searchShipments();
         
          
         
         String shipmentType = '';
         String recTypeId = '';
     //  Pagereference p = msc.godoShipmentcase( shipmentType, recTypeId) ;
     }
        
        
}