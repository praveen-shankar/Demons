/* Created By: Supriya
Date: 9th sept 2017
Test class: Test class for the crm_updateorgno_Batch 
*/

@isTest
public class crm_updateorgno_BatchTest {

    @testSetup static void setup() {
    crm_TestDataFactory.CreateCustomSetting();
    
         Account parentacc=new Account();
         parentacc.RecordTypeId=crm_TestDataFactory.PartyRecordTypeId();
         parentacc.Orga__c='9990003-167/888';
         parentacc.Name='Test Account';
         parentacc.crm_Updated_by_CDH__c =true;
         insert parentacc;
         
         List<Account> accList=new List<Account>();
         Account relacc=new Account();
         relacc.Party_Number__c='123453';
         relacc.RecordTypeId=crm_TestDataFactory.RelationRecordTypeId();
         relacc.ParentId=parentacc.id;
         relacc.crm_Primary_Customer_Account__c=true;
         relacc.crm_Updated_By_CDH__c=true;
    
         relacc.Name='Test Account';
         accList.add(relacc);
         
         Account relacc3=new Account();
         relacc3.Party_Number__c='123456';
         relacc3.RecordTypeId=crm_TestDataFactory.RelationRecordTypeId();
         relacc3.ParentId=parentacc.id;
         relacc3.crm_Primary_Customer_Account__c=false;
         relacc3.crm_Updated_By_CDH__c=false;
     
         relacc3.Name='Test Account 2';
         accList.add(relacc3);
         
         Insert accList;
    }
    
    static testMethod void TestCopyPartyNumber()
     {
         System.Test.startTest();
         crm_updateorgno_Batch  batchObj=new crm_updateorgno_Batch ();
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
     }
         
}