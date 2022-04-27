@isTest
public class crm_ContactMultiselectPicklistBatchTest {
    
    @isTest
    static void testmethod1(){
        string partyRecId = [Select Id From RecordType where sobjecttype = 'Account' and developername like 'crm_Party_level_Customer' limit 1].Id;    
        Account a1 = New Account(name='Test Account1', recordTypeId = partyRecId);
        Account a2 = New Account(name='Test Account2', recordTypeId = partyRecId);
        insert a1;
        insert a2;
        
        string contactRecId = [Select Id From RecordType where sobjecttype = 'Contact' and developername like 'crm_Sales' limit 1].Id;    
        contact c1 = New contact(AccountId = a1.Id, crm_Contact_Type__c='Sales', recordTypeId = contactRecId, Status__c='Aktiv',
                                 FirstName='Test',LastName='Contact1',Email='Test.123@mail.com', crm_Has_agreed_to_Marketing_actvities__c = True,
                                 crm_Has_Agreed_To_Email__c=True, crm_Has_Agreed_to_SMS__c=true);
        
        contact c2 = New contact(AccountId = a2.Id, crm_Contact_Type__c='Sales', recordTypeId = contactRecId, Status__c='Aktiv',
                                 FirstName='Test',LastName='Contact2',Email='Test.456@mail.com', crm_Has_Agreed_to_SMS__c=true);
        insert c1;
        insert c2;
        
        Test.startTest();
        	Database.executeBatch(new crm_ContactMultiselectPicklistBatch());
        Test.stopTest();
    }

}