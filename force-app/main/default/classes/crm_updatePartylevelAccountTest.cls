/*Date: 13th Sept 2016
Test class: Test class for the crm_SASCustomerToAccountConversionBatch
*/

@isTest
public class crm_updatePartylevelAccountTest{

    @testSetup static void setup() {
        
          crm_TestDataFactory.CreateCustomSetting();
          
         Account partyacc=new Account();
         partyacc.RecordTypeId=crm_TestDataFactory.PartyRecordTypeId();
         partyacc.Orga__c='9990002';
         partyacc.Name='Test Party';
         
         insert partyacc;
         
         Account relaccnew=new Account();
         relaccnew.crm_Customer_Number__c='CAP77123453';
         relaccnew.RecordTypeId=crm_TestDataFactory.RelationRecordTypeId();
         relaccnew.ParentId=partyacc.id;
         relaccnew.crm_Primary_Customer_Account__c=true;
         relaccnew.crm_Updated_By_CDH__c=false;
         relaccnew.Orga__c='9990002';
         relaccnew.Name='Test Account';
         
         insert relaccnew;
    }
    
    static testMethod void testUpdate()
    {
        System.Test.starttest();
        Account acc=[Select id,website from account where recordTypeid=:crm_TestDataFactory.RelationRecordTypeId() and crm_customer_number__c='CAP77123453' and Orga__c='9990002'];
        acc.website='test.com';
        List<id> accid=new List<id>{acc.id};
        crm_updatePartylevelAccount.UpdateParent(accid);
        System.Test.stoptest();
    }
    }