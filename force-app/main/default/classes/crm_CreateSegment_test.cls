/* 
Date: 06 March 2018
Test class: Test class for Create Segment lightning component
*/

@isTest
public class crm_CreateSegment_test {
    
    @testSetup static void setup() {
        
        crm_TestDataFactory.CreateCustomSetting();
        //create party level account
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        insert  partyLevelacnt;
    }
    
    static TestMethod void testCreateSegment()
    {
        System.Test.startTest();
        
        User u = crm_TestDataFactory.createUser();
        insert u;
        System.runAs(u){
            //fetch party account
            Account acc= [Select id, name from Account where name ='parent test' limit 1];
            System.assertequals(acc.Name,'parent test');
            
            crm_CreateSegment.getOpportunityserviceGroups(acc.id);
            
            List<String> l1 = new List<String>();
            l1.add('Cargo');
            crm_CreateSegment.saveSegments(acc.id,l1);
            l1.add('Cargo');
            crm_CreateSegment.saveSegments(acc.id,l1);
        }
        System.Test.stopTest();  
    }
    
}