@IsTest
private class EDIOpportunitiesTeamMember_Test 
{
    static testMethod void OpportunityTeamMember()
    {
        Test.startTest();    
        User u = crm_TestDataFactory.createUser();
        u.crm_User_Type__c='Sales';
        insert u;
        
        //create party level account for agreement active
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType relrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'business_account'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id,crm_Updated_by_CDH__c=true);
        insert acc;
                
        //create cargo +air opp
        Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
        oppAir.accountId=acc.id;
        oppAir.CloseDate=date.today().addDays(20);
        oppAir.StageName='New Opportunity';
        oppAir.crm_Opp_Service_Family__c='Air';
        oppAir.crm_Close_Behaviour__c='Create';
        oppAir.crm_Probability__c= '80';
        oppAir.crm_Agreement_Start_Date__c = system.today(); 
        
        insert oppAir; 
                        
        OpportunityTeamMember otm =crm_TestDataFactory.createOpportunityTeamMember();
        otm.OpportunityId=oppAir.id;
        otm.userId=u.id;
        insert otm;
        
        EDIOpportunitiesTeamMember.fetchOpportunities();
                    
        Test.stopTest();
       
    }
}