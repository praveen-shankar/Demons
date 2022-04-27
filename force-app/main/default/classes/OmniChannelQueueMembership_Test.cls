@isTest(seeAllData=true)

private class OmniChannelQueueMembership_Test{

    static testMethod void testOmni(){
        Test.startTest();
        Group g = [Select Id From Group Where DeveloperName = 'Adresseendring' And Type = 'Queue'];
        
        User u = [Select Id from User Where Alias = 'aadmi'];
        
        Agent_Omni_Configuration__c ag = new Agent_Omni_Configuration__c(Agent_SF_Id__c = u.Id, Allowed_Public_Groups__c = 'OMNI_Privat_Adresseendring');
        insert ag;
        
        Case c = new case(OwnerId = g.Id);
        insert c;
        
        System.runAs(u){
            OmniChannelQueueMembershipController con = new OmniChannelQueueMembershipController();
            con.removeMembership();
            con.addMembership();
            con.refresh();
        }
        Test.stopTest();
    }
}