@isTest
public class CS_CreateCaseFromParentTest {

      static testMethod void CreateCaseFromParent ()
      {
         
         String recordIdBusiness=KATSutilities.getRecordType('business_account');
         Account a1=new Account( crm_customer_number__c='12345676', Name='Bedrift AS', RecordTypeId=recordIdBusiness, Phone='99009900');
         insert a1;
         
         Case c1=new Case(subject='TEST', accountId=a1.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com', AccountPhone__c=null, AccountEmail__c=null);
                
         insert c1;
         CS_CreateCaseFromParent.CreateCaseFromParent (c1.Id);
      }
}