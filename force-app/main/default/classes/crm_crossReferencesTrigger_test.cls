@IsTest
private class crm_crossReferencesTrigger_test{

     @IsTest static void testThisClass() {
        Test.startTest();
         
           environment_settings__c  objCustomSettingint = new environment_settings__c ();
        objCustomSettingint.value__c='supriya.goel@capgemini.com;jainam.c.shah@capgemini.com';
        objCustomSettingint.Name = 'ToRecipientList';
        insert objCustomSettingint ;
         
          environment_settings__c  objCustomSettingint1 = new environment_settings__c ();
        objCustomSettingint1.value__c='supriya.goel@capgemini.com;jainam.c.shah@capgemini.com';
        objCustomSettingint1.Name = 'ToRecipientListCC';
        insert objCustomSettingint1 ;
            RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
            Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id,crm_Updated_by_CDH__c=true, Customer_Converted__c ='Converted');
            insert acc;
            RecordType relrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'business_account'];
            Account relacc = new Account(Name='Relation',Orga__c='2348274724',RecordTypeId=relrt.Id,ParentId=acc.Id,crm_Updated_by_CDH__c=true,crm_Customer_Number__c='45983945');
            insert relacc;
            List<crm_Account_Cross_Reference__c> cross = new List<crm_Account_Cross_Reference__c>();
            crm_Account_Cross_Reference__c c1 = new crm_Account_Cross_Reference__c(crm_Account__c=relacc.id,crm_Customer_Number__c='45983945',crm_Origin_System__c='Test',crm_Origin_System_Reference__c='Test',
            crm_Status__c='A');
            crm_Account_Cross_Reference__c c2 = new crm_Account_Cross_Reference__c(crm_Account__c=relacc.id,crm_Customer_Number__c='45983945',crm_Origin_System__c='Test',crm_Origin_System_Reference__c='Test',
            crm_Status__c='A');
            
            crm_Account_Cross_Reference__c c3 = new crm_Account_Cross_Reference__c(crm_Account__c=relacc.id,crm_Customer_Number__c='45983945',crm_Origin_System__c='AMPHORA_SPN',crm_Origin_System_Reference__c='Test',
            crm_Status__c='A');
            
            cross.add(c1);
            cross.add(c2);
            cross.add(c3);
            insert cross;
        Test.stopTest();
    }
}