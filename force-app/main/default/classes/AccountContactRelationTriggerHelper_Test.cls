@isTest
public class AccountContactRelationTriggerHelper_Test {
 @testSetup static void setup() {
 
  crm_TestDataFactory.CreateCustomSetting();
  Account partyLevelacnt = crm_TestDataFactory.createPartylevelAccount();
  partyLevelacnt.Name = 'Party level Customer';
  partyLevelacnt.crm_Count_of_Relation_level_Accounts__c = 1;
  insert partyLevelacnt;

  Account partyLevelacnt2 = crm_TestDataFactory.createPartylevelAccount();
  partyLevelacnt2.name = 'Dummy acct';
  partyLevelacnt2.crm_Count_of_Relation_level_Accounts__c = 1;
  insert partyLevelacnt2;

  Account relationLevelacnt1 = crm_TestDataFactory.createRelationlevelAccount();
  relationLevelacnt1.name = 'Dummy relation';
  relationLevelacnt1.parentId = partyLevelacnt.id;
  relationlevelacnt1.crm_Primary_Customer_Account__c = true;
  insert relationLevelacnt1;

  Contact con = new Contact();
  con.lastname = 'testmaping';
  con.email = 'Testmapping@cap.com';
  con.AccountId = partyLevelacnt.id;
  con.crm_contact_type__c = 'Sales';
  con.crm_functional_decision_level__c = 'Influencer';
  con.status__c = 'Aktiv';
  insert con;

  Contact con1 = new Contact();
  con1.lastname = 'testmaping1';
  con1.email = 'Testmapping1@cap.com';
  con1.AccountId = partyLevelacnt2.id;
  con1.crm_contact_type__c = 'Sales';
  con1.crm_functional_decision_level__c = 'Decision maker';
  con1.Status__c = 'Aktiv';
  insert con1;

  Contact con2 = new Contact();
  con2.lastname = 'testmaping2';
  con2.email = 'Testmapping2@cap.com';
  con2.AccountId = partyLevelacnt.id;
  con2.crm_contact_type__c = 'Sales';
  con2.Status__c = 'Aktiv';
  insert con2;
 }
 static TestMethod void setprimarycontact() {
  Account acc = [Select Id from account where name = 'Party level Customer'];
  Contact con = [Select id from Contact where email = 'Testmapping@cap.com'];
  Account acc1 = [Select id from account where name = 'Dummy acct'];
  Contact con1 = [Select id from Contact where email = 'Testmapping1@cap.com'];
  Contact con2 = [Select id from Contact where email = 'Testmapping2@cap.com'];



  AccountContactRelation accCon = new AccountContactRelation();
  accCon.AccountId = acc.Id;
  accCon.ContactId = con1.Id;
  insert accCon;

  AccountContactRelation accCon1 = new AccountContactRelation();
  accCon1.AccountId = acc1.Id;
  accCon1.ContactId = con.Id;
  insert accCon1;

  AccountContactRelation accCon2 = new AccountContactRelation();
  accCon2.AccountId = acc1.Id;
  accCon2.ContactId = con2.Id;
  insert accCon2;

  con2.crm_functional_decision_level__c = 'User';
  update con2;
  
  delete accCon2;
 }
 
  static testMethod void testbatchmethod(){
        crm_setprimarycontactAccount_Batch acb = new crm_setprimarycontactAccount_Batch('test'); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
}