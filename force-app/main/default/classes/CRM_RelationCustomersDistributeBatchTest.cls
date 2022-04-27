/**********************************************************************
 Name: CRM_RelationCustomersDistributeBatchTest
======================================================
Req:

======================================================
Purpose:
This test class is to test the functionality.
Distribution of relation level customers to other 
systems after party level customer 
conversion
======================================================
History
-------
VERSION  AUTHOR            DATE              DETAIL
   1.0 -  Vasudha Tandon    08/05/2020     Initial Development
***********************************************************************/
@isTest
public class CRM_RelationCustomersDistributeBatchTest {
    static testmethod void testDistributeCutomer() {
        // Create test accounts to be updated by batch
    Id partyRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('crm_Party_level_Customer').getRecordTypeId();
    Id relationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('business_account').getRecordTypeId();
    Account[] partyCustomerList = new List<Account>();
    for (Integer i=0;i< 10;i++) {
        Account ac = new Account(Name = 'Account ' + i, 
                                RecordTypeID = partyRecordTypeID , 
                                crm_customer_converted_date__c = System.today().addDays(-2),
                                crm_Updated_by_CDH__c  = true,
                                Customer_Converted__c = 'Converted',
                                CreatedDate = system.today().addDays(-2));
        partyCustomerList.add(ac);
    }
    insert partyCustomerList ;
    
    
    Account relationCustomer = new Account();
     relationCustomer.Name = ' Test Relation Account' ;
     relationCustomer.RecordTypeID = relationRecordTypeId ;
     relationCustomer.crm_Updated_by_CDH__c  = true;
     relationCustomer.ParentId = partyCustomerList[1].Id;
     relationCustomer.orga__c = '9856244';
     
     insert relationCustomer;
        
     crm_Account_Cross_Reference__c cross = new crm_Account_Cross_Reference__c(crm_Account__c=relationCustomer.Id,
                                                                               crm_Origin_System__c='AMPHORA_SPN',
                                                                               crm_Status__c='A');
     
     insert cross;
        
     environment_settings__c env1 = New environment_settings__c(name = 'ToRecipientList',
                                                                value__c = 'salesforce1@testmail.com');
     insert env1;
        
     environment_settings__c env2 = New environment_settings__c(name = 'ToRecipientListCC',
                                                                value__c = 'salesforce1@testmail.com');
     insert env2;
     
     Datetime fiveMinuesBack = Datetime.now().addMinutes(-5);
        Test.setCreatedDate(relationCustomer.Id, fiveMinuesBack );  
        Test.startTest();
           // CRM_RelationCustomersDistributeBatch b = new CRM_RelationCustomersDistributeBatch();
        //Database.executeBatch(b);
          Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('Test', CRON_EXP, new CRM_RelationCustomersDistributeSchedular() ); 
        Test.stopTest();
        // Verify accounts updated
    //Account[] accUpdatedList = [SELECT Id, Name FROM Account];
    //System.assert(accUpdatedList[0].Name.Contains('sfdcpoint'));
    }
    
}