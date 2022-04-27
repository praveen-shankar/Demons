/*
 * Author: Rajeev Shekhar
 * Agreement master project
 * StartDate 08-11-2018
*/

@IsTest
private class crm_convertCustomerIntegration_test{
    
     @IsTest static void testPositive() {
        Test.startTest();
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType relrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'business_account'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id,Customer_Converted__c='Converted',crm_customer_converted_date__c=System.today()+7,
                                  crm_Updated_by_CDH__c = true,crm_CDH_RowId__c ='8778889',crm_Posten_Source_Comp_for_datarecord_ER__c='Posten');
        insert acc;                          
        Account relacc = new Account(Name='Relation',Orga__c='2348274724',crm_Customer_Status_Role_3__c ='A',ParentId=acc.Id,RecordTypeId=relrt.Id, crm_Updated_by_CDH__c = true,crm_CDH_RowId__c ='87798889',crm_Customer_Number__c='98788878');                          
        insert relacc;
        
        crm_Account_Cross_Reference__c cross = new crm_Account_Cross_Reference__c(crm_Account__c=relacc.Id,crm_Origin_System__c='AMPHORA_SPN',crm_Status__c='A');
        insert cross;
        Test.setMock(HttpCalloutMock.class, new crm_convertCustomerIntegration_mock());
        System.enqueueJob(new crm_convertCustomerIntegrationController(new List<Id>{acc.Id}));
        Test.stopTest();

     }
     
     @IsTest static void testPositive1() {
        Test.startTest();
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType relrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'business_account'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id,Customer_Converted__c='Converted',
                                  crm_Updated_by_CDH__c = true,crm_CDH_RowId__c ='8778889',crm_Posten_Source_Comp_for_datarecord_ER__c='Posten');
        insert acc;                          
        Account relacc = new Account(Name='Relation',Orga__c='2348274724',crm_Customer_Status_Role_3__c ='A',ParentId=acc.Id,RecordTypeId=relrt.Id, crm_Updated_by_CDH__c = true,crm_CDH_RowId__c ='87798889',crm_Customer_Number__c='98788878');                          
        insert relacc;
        
        crm_Account_Cross_Reference__c cross = new crm_Account_Cross_Reference__c(crm_Account__c=relacc.Id,crm_Origin_System__c='AMPHORA_SPN',crm_Status__c='A');
        insert cross;
        Test.setMock(HttpCalloutMock.class, new crm_convertCustomerIntegration_mock());
        System.enqueueJob(new crm_convertCustomerIntegrationController(new List<Id>{acc.Id}));
        Test.stopTest();

     }
     
     @IsTest static void testPositive2() {
        Test.startTest();
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType relrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'business_account'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id,Customer_Converted__c='NotConverted',
                                  crm_Updated_by_CDH__c = true,crm_customer_converted_date__c=System.today()+7,crm_CDH_RowId__c ='8778889',crm_Posten_Source_Comp_for_datarecord_ER__c='Posten');
        insert acc;                          
        Account relacc = new Account(Name='Relation',Orga__c='2348274724',crm_Customer_Status_Role_3__c ='A',ParentId=acc.Id,RecordTypeId=relrt.Id, crm_Updated_by_CDH__c = true,crm_CDH_RowId__c ='87798889',crm_Customer_Number__c='98788878');                          
        insert relacc;
        
        crm_Account_Cross_Reference__c cross = new crm_Account_Cross_Reference__c(crm_Account__c=relacc.Id,crm_Origin_System__c='AMPHORA_SPN',crm_Status__c='A');
        insert cross;
        Test.setMock(HttpCalloutMock.class, new crm_convertCustomerIntegration_mock());
        System.enqueueJob(new crm_convertCustomerIntegrationController(new List<Id>{acc.Id}));
        Test.stopTest();

     }
    
}