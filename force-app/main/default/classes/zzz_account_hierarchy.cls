@isTest
public class zzz_account_hierarchy{
      
      @testSetup static void setup() {
         
         crm_TestDataFactory.CreateCustomSetting();
         }
     static testMethod void testHierarchyPArty()
     {
         Account partyacc=new Account();
         partyacc.RecordTypeId=crm_TestDataFactory.PartyRecordTypeId();
         partyacc.Orga__c='9990002';
         partyacc.Name='Test Party';
         insert partyacc;
         
          Account relacc=new Account();
         relacc.crm_Customer_Number__c='123453';
         relacc.RecordTypeId=crm_TestDataFactory.RelationRecordTypeId();
         relacc.ParentId=partyacc.id;
         relacc.crm_Primary_Customer_Account__c=true;
         relacc.crm_Updated_By_CDH__c=false;
         relacc.Orga__c='9990003';
         relacc.Name='Test Account';
         
         insert relacc;
         
        
         
        
        System.Test.startTest();
        account_heirarchy AAC = new account_heirarchy(new ApexPages.StandardController(new Account()));
        
        AAC.acntid=[Select id from account where orga__c='9990002' limit 1].id;
        System.debug('@@@AAC@@'+AAC.acntid);
        AAC.getaccounts();
        AAC.refreshPageSize(); 
        PageReference pr= Page.Account_heirarchy;
        
        System.Test.setCurrentPage(pr);
        System.Test.stopTest();    
         
     }
}