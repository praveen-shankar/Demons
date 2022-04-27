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
@isTest
private class zzz_cti_CustomerInfo {
    static String contactPhone = '112233';
    static String contactMobile = '223344';
    static String accountPhone = '442211';
    static String accountFax = '998877';
    static String personAccountPhone = '321321';
     
    static Account testAccount;
    static Contact testContact;
    static Account testPersonAccount;
    static cti_CustomerInfo customerInfo = new cti_CustomerInfo();
    static Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
    
    static private Id queryForPersonRecType()
    {
        return [Select Id From RecordType where developername = 'person_account'].Id;
    }
    static private Id queryForBusinessRecType()
    {
        return [Select Id From RecordType where developername = 'business_account'].Id;
    }
    
    static {
        testAccount = new Account(name='Test Account', Phone=accountPhone, Fax=accountFax, recordtypeId=queryForBusinessRecType());
        insert testAccount;
        testContact = new Contact(lastName='Test User', Phone = contactPhone, AccountId = testAccount.Id, MobilePhone = contactMobile,recordtypeid=csRecordTypeId);
        insert testContact;
        testPersonAccount = new Account(FirstName='Test personAccount', LastName='Test personAccount', Phone=personAccountPhone, Fax=personAccountPhone);
        testPersonAccount.RecordTypeId = queryForPersonRecType(); 
        insert testPersonAccount;
    }

    static testMethod void testGetBusinessAccountUsingContactPhone() {
        Test.startTest();
        cti_CustomerInfo.SearchResult result = customerInfo.getBusinessAccount(contactPhone, false);
        System.assert(result.account.Id == testAccount.Id, 'using contactPhone: accounts are different ' + result.account.Id + ' != ' + testAccount.Id);
        result = customerInfo.getBusinessAccount(contactMobile, false);
        Test.stopTest();
        System.assert(result.account.Id == testAccount.Id, 'using contactMobile: accounts are different ' + result.account.Id + ' != ' + testAccount.Id);
    }
    
    static testMethod void testGetBusinessAccountUsingAccountPhone() {
        Test.startTest();
        cti_CustomerInfo.SearchResult result = customerInfo.getBusinessAccount(accountPhone, false);
        System.assert(result.account.Id == testAccount.Id, 'using accountPhone: accounts are different ' + result.account.Id + ' != ' + testAccount.Id);
        result = customerInfo.getBusinessAccount(accountFax, false);
        Test.stopTest();
        System.assert(result.account.Id == testAccount.Id, 'using accountPhone: accounts are different ' + result.account.Id + ' != ' + testAccount.Id);
    }
    
    static testMethod void testGetPersonAccount() {
        Test.startTest();
        cti_CustomerInfo.SearchResult result = customerInfo.getPersonAccount(personAccountPhone);
        System.assert(result != null);
        System.assert(testPersonAccount.Id == result.account.Id,'should find personAccount');
        Test.stopTest();
        
    }
    
    static testMethod void testQueryAccountByContact() {
        Account acc = KatsTestUtilities.getTestBusinessAccount();
        Contact con = KatsTestUtilities.getTestContact();
        System.assertEquals(customerInfo.queryAccountByContact(con).Id, acc.Id);    
    }
    
    static testMethod void testMyTest() {
        Account a = new Account(FirstName = 'First', LastName = 'Last', Phone = 'fff', RecordTypeId = queryForPersonRecType());
        insert a;
        Test.startTest();
        Account b = [select Id, IsPersonAccount, Name from Account where Id = :a.Id];
        System.assert(b != null);
        Test.stopTest();
        System.debug(b);
        
    }
    static testMethod void testGetAccount() {
        String phoneNumber = '55555';
        Account b = new Account(Name = 'The business account', Phone = phoneNumber, Fax = phoneNumber, recordtypeId=queryForBusinessRecType());
        insert b;
        Account p = new Account(FirstName = 'Person', LastName = 'Account', Phone = phoneNumber, Fax = phoneNumber, RecordTypeId = queryForPersonRecType());
        insert p;
        Test.startTest();
        Account theAccount = customerInfo.getAccountByAPhoneNumber(phoneNumber);
        Test.stopTest();
        System.assert(theAccount != null);
        System.assert(theAccount.Id == b.Id);
    }
    
    /*
    * If more than one account with the same phoneNumber, return VIP account.
    */
    static testMethod void testGetAccountByPriority() {
        Account acc1 = KatsTestUtilities.getTestBusinessAccount();
        acc1.recordtypeId=queryForBusinessRecType();
        update acc1;    
        String phoneNumber = 'TestPhone1234';
        System.assertEquals(customerInfo.getAccountByAPhoneNumber(acc1.Phone,false,true).Id, acc1.Id);
        
        Account acc2 = new Account(Name='Test2', CRMStatus__c=cti_CustomerInfo.CRM_STATUS_VIP, recordtypeId=queryForBusinessRecType());
        acc2.Phone = phoneNumber;
        upsert acc2;
        System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false,true).Id, acc2.Id);
                
        Account acc3 = new Account(Name='Test3', CRMStatus__c=cti_CustomerInfo.CRM_STATUS_STORKUNDE, recordtypeId=queryForBusinessRecType());
        acc3.Phone = phoneNumber;
        upsert acc3;
        System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false,true).Id, acc2.Id);
        
        acc2.CRMStatus__c = null;
        //upsert acc2;
       
      // System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false,true).Id, acc3.Id);
        
        acc3.CRMStatus__c = null;
       // upsert acc3;
       // System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false,true), null);
    }
    
    /*
    * If more than one contact with the same phoneNumber, return VIP-account related to the contact.
    */
    static testMethod void testGetAccountContactByPriority() {
        Account acc1 = KatsTestUtilities.getTestBusinessAccount();
        acc1.recordtypeId=queryForBusinessRecType();
        update acc1;
        Contact con1 = KatsTestUtilities.getTestContact();
        String phoneNumber = con1.MobilePhone;
        System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false,true).Id, acc1.Id);
        
        Account acc2 = new Account(Name='Test2', CRMStatus__c=cti_CustomerInfo.CRM_STATUS_VIP, recordtypeId=queryForBusinessRecType());
        upsert acc2;
        
        Contact con2 = new Contact(LastName='Test2', MobilePhone=phoneNumber,recordtypeid=csRecordTypeId);
        con2.AccountId = acc2.Id;
        upsert con2;
        System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false,true).Id, acc2.Id);
                
        Account acc3 = new Account(Name='Test3', CRMStatus__c=cti_CustomerInfo.CRM_STATUS_STORKUNDE, recordtypeId=queryForBusinessRecType());
        upsert acc3;
        Contact con3 = new Contact(LastName='Test3', MobilePhone=phoneNumber,recordtypeid=csRecordTypeId);
        con3.AccountId = acc3.Id;
        upsert con3;
        // Return VIP account (acc2)
        System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false,true).Id, acc2.Id);
        
        acc2.CRMStatus__c = null;
        //upsert acc2;
        // No VIP account found, return Storkunde account (acc3)
       // System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false,true).Id, acc3.Id);
        
        acc3.CRMStatus__c = null;
       // upsert acc3;
        // No VIP or Storkunde account exists, the first account found by SOQL will be returned.
       // System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false,true), null);
    }
    
    /*
    * Test to ensure that the relation to the VIP account is found, even if the contact is not related directly to the VIP-account.
    */
    static testMethod void testGetRelatedVipAccount() {
        Account acc1 = KatsTestUtilities.getTestBusinessAccount();
        acc1.recordtypeId=queryForBusinessRecType();
        update acc1;
        String phoneNumber = 'TestPhone1234';
        System.assertEquals(customerInfo.getAccountByAPhoneNumber(acc1.Phone,false,true).Id, acc1.Id);
        
        Account acc2 = new Account(Name='Test2', DUNS_number__c='TestDunsNumber', Orga__c='TestOrganizationNumber', recordtypeId=queryForBusinessRecType());
        acc2.Phone = phoneNumber;
        upsert acc2;
        
        // acc2 and acc3 related to each other by the same DUNS_number__c.
        Account acc3 = new Account(Name='Test3', DUNS_number__c='TestDunsNumber', CRMStatus__c=cti_CustomerInfo.CRM_STATUS_VIP, recordtypeId=queryForBusinessRecType());
        upsert acc3;
        
        // acc2 and acc4 related to each other by the same Orga__c.
        Account acc4 = new Account(Name='Test4', Orga__c='TestOrganizationNumber2', CRMStatus__c=cti_CustomerInfo.CRM_STATUS_STORKUNDE, recordtypeId=queryForBusinessRecType());
        //upsert acc4;
        
        // acc2 is found by phone-number search. acc2 is related to acc3 which has VIP status, therefore return the VIP account
        System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false,true).DUNS_number__c, acc2.DUNS_number__c);
        //System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false).Id, acc3.Id);

        acc3.CRMStatus__c=null;
       // upsert acc3;
        
        // acc2 is found by phone-number search. acc2 is related to acc4 which has Storkunde status, therefore return the Storkunde account
        //System.assertEquals(customerInfo.getAccountByAPhoneNumber(phoneNumber,false).Orga__c, acc4.Orga__c);
    }
    
    static testmethod void testgetAllPossiblePhoneNumbers(){
        customerInfo.getAllPossiblePhoneNumbers('076656544');
        
    }
    
    static testMethod void testcheckAndCopyFromBacksystemToKats(){
        //customerinfo.checkAndCopyFromBacksystemToKats('20202020');
    }

}