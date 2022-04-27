@IsTest
private with sharing class addServicesTest{
      @IsTest static void testAddServices() {
        Test.startTest();
        User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'Guest-CRM Sales user'].Id,
             LastName = 'last',
             Email = 'test000@gmail.com',
             Username = 'test@gmail.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
             
        );
           RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType opprt = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'SF_II_RT_A'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id);
        insert acc;
          
          String tabselected='B2B';
          
          String Searchkey='pakke';
          addServices.fetchProduct2Record(tabselected,Searchkey);
          addServices.fetchProduct2Record('All',Searchkey);
          addServices.getPickListValuesIntoList();
          
          Test.stopTest();    
      }
}