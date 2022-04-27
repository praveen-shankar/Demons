@IsTest
private class crm_customRecordTypePageOpportunity_test {
    @IsTest static void testThisClass1(){
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id,Customer_Converted__c='Converted');
        insert acc;
        crm_customRecordTypePageOpportunity.getOpportunityRecordTypes(acc.Id);
    }
    
    @IsTest static void testThisClass2(){
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id,Customer_Converted__c='NotConverted');
        insert acc;
        crm_customRecordTypePageOpportunity.getOpportunityRecordTypes(acc.Id);
    }
    
    @IsTest static void testThisClass3(){
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id,Customer_Converted__c='InPreparation');
        insert acc;
        crm_customRecordTypePageOpportunity.getOpportunityRecordTypes(acc.Id);
    }
    @IsTest static void testThisClass4(){
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        Account acc = new Account(Name='Party Test',Orga__c='2348274724',RecordTypeId=partyrt.Id,Customer_Converted__c='Converted');
        insert acc;
        crm_customRecordTypePageOpportunity.getOpportunityRecordTypes_NewBusiness(acc.Id);
    }    
    
}