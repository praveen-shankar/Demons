//Sakshi: Show All the Opportunities where the logged in user (EDI user) is added as an Opportunity Team Member, Condition: Agreement StartDate is within 30 days
public with sharing class EDIOpportunitiesTeamMember {
    
    @AuraEnabled
    public static List<Opportunity> fetchOpportunities() {

        List<Opportunity> opportunitiesList = 	[SELECT ID, Name, Account.Name, AccountId, crm_Agreement_Start_Date__c, crm_Agreement__c, crm_Agreement__r.Name, crm_Opp_Service_Family__c, crm_Opp_Service_Group__c, CloseDate, StageName,
                             					OwnerId, Owner.Name FROM Opportunity WHERE 
                             					ID IN (SELECT OpportunityID FROM OpportunityTeamMember WHERE UserId = :UserInfo.getUserID() AND TeamMemberRole = 'Integration Consultant') 
                             					AND crm_Agreement_Start_Date__c >= NEXT_N_DAYS:30 Order by crm_Agreement_Start_Date__c ASC LIMIT 10];

        System.debug('Opportunities Team Member where Agreement Start Date is Within 30 days: '+ opportunitiesList);
       	return opportunitiesList;
    }
}