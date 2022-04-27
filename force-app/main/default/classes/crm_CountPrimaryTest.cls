/* Created By: Akshata
Date: 14th March  2017
Test class: Test class for the crm_CountPrimaryRelation
*/

@isTest
public class crm_CountPrimaryTest{

    @testSetup static void setup() {
         
         crm_TestDataFactory.CreateCustomSetting();
         
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
         relacc.Name='Test Account';
         List<Account> acc=new List<Account>();
         acc.add(relacc);
         Database.insert(relacc,false);
         

    
    }
    
    static testMethod void testbatch()
    {
         System.Test.startTest();
         crm_CountPrimaryRelation batchObj=new crm_CountPrimaryRelation();
         DataBase.executebatch(batchObj);
         System.Test.StopTest();
    }
    
}