@isTest
public class CS_UpdateCustomerInfoTest {

      static testMethod void UpdateCustomerInfo()
      {
          Account testAccount = new Account(Name = 'Test OEBS Account',
                                    crm_customer_number__c = '12345678');
        
        insert testAccount;
         CS_UpdateCustomerInfo.UpdateCustomerInfo(testAccount.Id);
      }
}