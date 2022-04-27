/*
* While running test the class postenNoEconnectUtilities return stubclasses. Some of these tests are based on data from these stubs.
*/
// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest
private class zzz_MainSearchController {
    
    static testMethod void searchPrivateCustomerAndCreateShipmentCase() {
        String Partynumber = '7654321';
        String LastName = 'LastName';
       
        Account acct = new Account(crm_customer_number__c = partynumber, lastName = 'Testsen', recordTypeId = KATSutilities.getRecordType('person_account'));
        upsert acct;
        
        MainSearchController msc = new MainSearchController();
        msc.currentSearchModus = 'FAR';
        msc.activeSearchTab = 'tabPrivate';
        msc.setparty_number(Partynumber);
        msc.searchPersonAccounts();
       
        
        system.assert(msc.account_search_results.size() > 0, 'Search result equals 0, something is wrong');
        
        msc.selected_account_search_result = 0;
        msc.new_case_data.recordTypeId = KATSutilities.getRecordType('complaint');
        msc.setGo_to_type('NEW_CASE');
        
        msc.goDo();
        
        Case c = [SELECT id, recordType.developername, Type__c FROM Case WHERE account.crm_customer_number__c = '7654321' LIMIT 1].get(0);
        
    }
    
    /* load person account from backend */
   /* static testMethod void searchAndGotoNonExistingPersonAccount() {
    KatsTestUtilities.createTestPrivateAccount();
        String Partynumber = '7654321';
        
        MainSearchController msc = new MainSearchController();
        msc.currentSearchModus = 'FAR';
        msc.activeSearchTab = 'tabPrivate';
        msc.setforwardingnumber('1234567');
        
        msc.searchBusinessAccounts();
        
        system.assert(msc.account_search_results.size() > 0, 'Search result equals 0, something is wrong');
        
        msc.selected_account_search_result = 0;
        msc.selected_contact_search_result = -2;
        msc.override_required_contact = (msc.getgo_to_type_as_string() == 'ACCOUNT');
        msc.setGo_to_type('ACCOUNT');
        
        msc.godo();
        
        Account acct = [SELECT id, recordType.developername, isPersonAccount FROM Account WHERE crm_customer_number__c = :Partynumber LIMIT 1].get(0);
        
        system.assert(acct.isPersonAccount, 'Account is not a person account!');
        system.assert(acct.recordType.developername == 'person_account', 'Account is not a person account!');
    }*/

     
    /* update person account from backend */
    static testMethod void searchAndGotoExistingPersonAccount() {
        String Partynumber = '7654321';
        String LastName = 'LastName';
       
        Account acct = new Account(crm_customer_number__c = partynumber, lastName = 'LastName', recordTypeId = KATSutilities.getRecordType('person_account'));
        upsert acct;
        
        MainSearchController msc = new MainSearchController();
        msc.currentSearchModus = 'FAR';
        msc.activeSearchTab = 'tabPrivate';
        msc.setparty_number(Partynumber);
        msc.searchPersonAccounts();
        
        system.assert(msc.account_search_results.size() > 0, 'Search result equals 0, something is wrong');
        
        msc.selected_account_search_result = 0;
        msc.selected_contact_search_result = -2;
        msc.override_required_contact = (msc.getgo_to_type_as_string() == 'ACCOUNT');
        msc.setGo_to_type('ACCOUNT');
        
        msc.godo();
        
        acct = [SELECT id, recordType.developername, isPersonAccount, lastName FROM Account WHERE crm_customer_number__c = :Partynumber LIMIT 1].get(0);
        
        system.assert(acct.isPersonAccount, 'Account is not a person account!');
        system.assert(acct.recordType.developername == 'person_account', 'Account is not a person account!');
        system.assert(acct.lastName == lastName, 'Account does not have the correct name! Supposed to be ' + lastName + ' not ' + acct.LastName);
        
    }
    
   /* static testMethod void searchAndCreateCaseForNonExistingPrivateAccount() {
        String partyNumber = '7654321';
        String caseType = 'complaint'; //We want to create a Klage in this test
        String recordTypeid = KATSutilities.getRecordType(caseType);
        KatsTestUtilities.createTestPrivateAccount();
        MainSearchController msc = new MainSearchController();
        msc.currentSearchModus = 'FAR';
        msc.activeSearchTab = 'tabPrivate';
        
        msc.searchPersonAccounts();
        
        msc.selected_account_search_result = 0;
        msc.new_case_data.recordTypeId = recordTypeid;
        msc.setGo_to_type('NEW_CASE');
        
        msc.godo();
        
        Case c = null;
        c = [SELECT id, recordTypeId, Account.crm_customer_number__c, Contact.Caesar_Contact_Id__c FROM Case WHERE Account.crm_customer_number__c =: partyNumber LIMIT 1];
}  */  
    static testMethod void initiateControllerWithoutCase(){
        String gotoType = 'ACCOUNT';
        
        PageReference pageRef = Page.mainSearch;
        Test.setCurrentPage(pageRef);
        MainSearchController msc = new MainSearchController();
        
        system.assert(msc.getgo_to_type_as_string() == gotoType);
        
    }
    
    static testMethod void initiateControllerFromCaseWithAccount(){
        String partyNumber = 'partyNumber';
        String firstName = 'FirstName';
        String lastName = 'LastName';
        String name = firstName + ' ' + lastName;
        String forwadingNumber = 'forwardingNumber';
        String shipmentNumber = 'shipmentNumber';
        String InvoiceNo = 'invoiceNo';
        String gotoType = 'EXISTING_CASE';
        String Phone = 'phone';
        String searchTab = 'tabPrivate';
        
        Account acct = new Account();
        acct.crm_customer_number__c = partyNumber;
        acct.Name = name;
        //Id RelationLevelRecordTypeId =  [select id from recordType where developerName='business_account' and sobjectType='Account'].id;
        // Dinesh , Added line no. 180 on 23 Feb 2017
        Id RelationLevelRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        acct.recordtypeid=RelationLevelRecordTypeId;
        upsert acct;
        
        acct = [SELECT id, crm_customer_number__c FROM Account WHERE id = :acct.id LIMIT 1];
        system.assert(acct.crm_customer_number__c == partyNumber);
        
        Case c = new Case();
        c.accountid = acct.id;
        c.Shipment_number__c = shipmentNumber;
        c.Invoice_no__c = InvoiceNo;
        c.change_address_ref_no__c = forwadingNumber;
        upsert(c);
        
        c = [select id, casenumber from case limit 1];
        
        PageReference pageRef = Page.mainSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('caseId', c.id);
        ApexPages.currentPage().getParameters().put('phone', Phone);
        ApexPages.currentPage().getParameters().put('searchTab', searchTab);
        MainSearchController msc = new MainSearchController();
        
        system.assert(msc.right_case.casenumber == c.casenumber);
    }
    
    static testMethod void coverageTestSetNameInController1() {
        Case c = new Case(SuppliedName = 'TestName');
        upsert c;
        
        PageReference pageRef = Page.mainSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('caseId', c.id);
        
        MainSearchController msc = new MainSearchController();
    }
    
    static testMethod void coverageTestSetNameInController2() {
        Account acct = new Account(Name = 'Name');
        // Dinesh , Added line no. 180 on 23 Feb 2017
        //Id RelationLevelRecordTypeId =  [select id from recordType where developerName='business_account' and sobjectType='Account'].id;
        Id RelationLevelRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        acct.recordTypeId=RelationLevelRecordTypeId;
        upsert acct;
        
        Case c = new Case(SuppliedName = 'TestName', accountId = acct.id);
        upsert c;
        
        PageReference pageRef = Page.mainSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('caseId', c.id);
        
        MainSearchController msc = new MainSearchController();
    }

    //Coverage test for parts not involving logic
    static testMethod void coverageTest() {
        MainSearchController msc = new MainSearchController();
        msc.getaddress_house_number();
        msc.setaddress_house_number('HouseNumber');
        msc.getaddress_house_letter();
        msc.setaddress_house_letter('houseLetter');
        msc.getaddress_po_box_number();
        msc.setaddress_po_box_number('poBoxNumber');
        msc.getparty_type();
        msc.setparty_type('partyType');
        msc.getaccount_number();
        msc.setaccount_number('accountNumber');
        msc.getorder_number();
        msc.setorder_number('orderNumber');
        
    }
    /**/
}