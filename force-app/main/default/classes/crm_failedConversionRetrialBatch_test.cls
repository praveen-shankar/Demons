@IsTest
private class crm_failedConversionRetrialBatch_test{

    @IsTest static void testThisclass() {
        Test.startTest();
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType opprt = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Business_Delivery'];
        Account acc = new Account(Name='Party',Customer_Converted__c='NotConverted',Orga__c='2348274724',RecordTypeId=partyrt.Id);
        insert acc;
        Opportunity opp = new Opportunity(Name='Opportunity Test',crm_Verified_by_Contract_Management__c=false,StageName='New Opportunity',crm_Opp_Service_Family__c='Business Delivery',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=acc.Id,CurrencyIsoCode='NOK',RecordtypeId=opprt.Id,CloseDate=Date.today()+5);
        insert opp;
        crm_Exception__c ex1 = new crm_Exception__c(crm_Dml_Id__c=acc.Id,crm_Type__c = 'System.CalloutException',crm_Stack_Trace__c = 'Class.crm_convertCustomerIntegrationController');
        crm_Exception__c[] exlist = new crm_Exception__c[]{};
        exlist.add(ex1);
        insert exlist;        
        Database.executeBatch(new crm_failedConversionRetrialBatch());
        Test.stoptest();
        
    }

}