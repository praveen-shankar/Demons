// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest
public class zzz_accountController {

    private static testMethod void testAccountController_1() {
        Test.startTest();
            AccountController ac = new AccountController();
        Test.stopTest();
    }
    
    private static testMethod void testInsertAccount_1() {
        list<Account> newAccountList = new list<Account>();
        newAccountList.add(new Account(crm_customer_number__c = null, last_updated__c = null, Name = 'Test account'));
        
        AccountController.AccountController_Before_Insert ac = new AccountController.AccountController_Before_Insert();
        
        ac.MainEntry('Account', true, false, false, true, false, true, newAccountList, null, null, null);
        
        system.assertEquals(null, newAccountList.get(0).crm_customer_number__c);
        system.assertEquals('Test account', newAccountList.get(0).Name);
        system.assertEquals(null , newAccountList.get(0).last_updated__c);
        system.assertEquals(null , newAccountList.get(0).status_update__c);
    }
    
    private static testMethod void testInsertAccount_2() {
        list<Account> newAccountList = new list<Account>();
        newAccountList.add(new Account(crm_customer_number__c = 'Test123', last_updated__c = null, Name = 'Test account',Bankkontonummer__c='12334'));
        
        AccountController.AccountController_Before_Insert ac = new AccountController.AccountController_Before_Insert();
        
        ac.MainEntry('Account', true, false, false, true, false, true, newAccountList, null, null, null);
        
        system.assertEquals('Test123', newAccountList.get(0).crm_customer_number__c);
        system.assertEquals('Test account', newAccountList.get(0).Name);
        system.assertNotEquals(null , newAccountList.get(0).last_updated__c);
        system.assertEquals('Ready for update', newAccountList.get(0).status_update__c);
    }
    
    private static testMethod void testMainEntryUpdateAccount_1() {
        list<Account> newAccountList = new list<Account>();
        map<Id, Account> oldAccountMap = new map<Id, Account>();
        
        oldAccountMap.put('001W0000001P5WP', new Account(id = '001W0000001P5WP', crm_customer_number__c = null, last_updated__c = null, Name = 'Test account'));
        newAccountList.add(new Account(id = '001W0000001P5WP', crm_customer_number__c = null, last_updated__c = null, Name = 'Test account',Bankkontonummer__c='12334'));
        
        AccountController.AccountController_Before_Update ac = new AccountController.AccountController_Before_Update();
        
        ac.MainEntry('Account', true, false, false, true, false, true, newAccountList, null, null, oldAccountMap);
        
        system.assertEquals(null, newAccountList.get(0).crm_customer_number__c);
        system.assertEquals('Test account', newAccountList.get(0).Name);
        system.assertEquals(null , newAccountList.get(0).last_updated__c);
        system.assertEquals(null , newAccountList.get(0).status_update__c);
    }
    
    private static testMethod void testMainEntryUpdateAccount_2() {
        list<Account> newAccountList = new list<Account>();
        map<Id, Account> oldAccountMap = new map<Id, Account>();
        
        oldAccountMap.put('001W0000001P5WP', new Account(id='001W0000001P5WP', crm_customer_number__c = null, last_updated__c = null, Name = 'Test account'));
        newAccountList.add(new Account(id='001W0000001P5WP', crm_customer_number__c = null, last_updated__c = null, Name = 'Test account'));
        
        AccountController.AccountController_Before_Update ac = new AccountController.AccountController_Before_Update();
        
        ac.MainEntry('Account', true, false, false, true, false, true, newAccountList, null, null, oldAccountMap);
        
        system.assertEquals(null, newAccountList.get(0).crm_customer_number__c);
        system.assertEquals('Test account', newAccountList.get(0).Name);
        system.assertEquals(null , newAccountList.get(0).last_updated__c);
        system.assertEquals(null , newAccountList.get(0).status_update__c);
    }
    
    private static testMethod void testMainEntryUpdateAccount_3() {
        list<Account> newAccountList = new list<Account>();
        map<Id, Account> oldAccountMap = new map<Id, Account>();
        
        oldAccountMap.put('001W0000001P5WP', new Account(id='001W0000001P5WP', crm_customer_number__c = 'Test123', last_updated__c = null, Name = 'Test account', status_update__c = 'Updating Map'));
        newAccountList.add(new Account(id='001W0000001P5WP', crm_customer_number__c = 'Test123', last_updated__c = null, Name = 'Test account', status_update__c = 'Updating'));
        
        AccountController.AccountController_Before_Update ac = new AccountController.AccountController_Before_Update();
        
        ac.MainEntry('Account', true, false, false, true, false, true, newAccountList, null, null, oldAccountMap);
        
        system.assertEquals('Test123', newAccountList.get(0).crm_customer_number__c);
        system.assertEquals('Test account', newAccountList.get(0).Name);
        // Dinesh , Commented line no 86 on 23 Feb 2017
       // system.assertEquals(null , newAccountList.get(0).last_updated__c);
        system.assertEquals('Ready for update', newAccountList.get(0).status_update__c);
    }
    
    private static testMethod void testMainEntryUpdateAccount_4() {
        list<Account> newAccountList = new list<Account>();
        map<Id, Account> oldAccountMap = new map<Id, Account>();
        
        oldAccountMap.put('001W0000001P5WP', new Account(id='001W0000001P5WP', crm_customer_number__c = 'Test123', last_updated__c = null, Name = 'Test account', status_update__c = 'Klar for oppdatering'));
        newAccountList.add(new Account(id='001W0000001P5WP', crm_customer_number__c = 'Test123', last_updated__c = null, Name = 'Test account', status_update__c = 'Under oppdatering'));
        
        AccountController.AccountController_Before_Update ac = new AccountController.AccountController_Before_Update();
        
        ac.MainEntry('Account', true, false, false, true, false, true, newAccountList, null, null, oldAccountMap);
        
        //system.assertEquals('Test123', newAccountList.get(0).crm_customer_number__c);
        //system.assertEquals('Test account', newAccountList.get(0).Name);
        //system.assertNotEquals(null , newAccountList.get(0).last_updated__c);
        //system.assertEquals('Klar for oppdatering', newAccountList.get(0).status_update__c);
    }
     private static testMethod void testInProgress(){
         list<Account> newAccountList = new list<Account>();
        newAccountList.add(new Account(crm_customer_number__c = null, last_updated__c = null, Name = 'Test account'));
        AccountController.AccountController_Before_Insert ac = new AccountController.AccountController_Before_Insert();
        ac.InProgressEntry('Account', true, false, false, true, false, true, newAccountList, null, null, null);
        map<Id, Account> oldAccountMap = new map<Id, Account>();
        
        oldAccountMap.put('001W0000001P5WP', new Account(id = '001W0000001P5WP', crm_customer_number__c = null, last_updated__c = null, Name = 'Test account'));
        newAccountList.add(new Account(id = '001W0000001P5WP', crm_customer_number__c = null, last_updated__c = null, Name = 'Test account'));
        
        AccountController.AccountController_Before_Update ac_update = new AccountController.AccountController_Before_Update();
        
        ac_update.InProgressEntry('Account', true, false, false, true, false, true, newAccountList, null, null, null);
        
        
    }
}