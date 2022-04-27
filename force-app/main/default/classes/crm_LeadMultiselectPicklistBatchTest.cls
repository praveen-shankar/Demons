@isTest
public class crm_LeadMultiselectPicklistBatchTest {
    
    @isTest
    static void testmethod1(){
        List<Lead> leadsToInsert = New List<Lead>();
        for(integer i=0;i<10;i++){
            Lead l = New Lead(FirstName='Test', LastName='Lead'+i, Company='Test Company', Status='New',
                             crm_Has_Agreed_to_Marketing_Activities__c=true, crm_Has_Agreed_to_Emai__c=true, crm_Has_Agreed_to_SMS__c=true);
            leadsToInsert.add(l);
        }
        
        for(integer i=10;i<20;i++){
            Lead l = New Lead(FirstName='Test', LastName='Lead'+i, Company='Test Company', Status='New',
                             crm_Has_Agreed_to_Marketing_Activities__c=false);
            leadsToInsert.add(l);
        }  
		for(integer i=20;i<30;i++){
            Lead l = New Lead(FirstName='Test', LastName='Lead'+i, Company='Test Company', Status='New',
                             crm_Has_Agreed_to_Marketing_Activities__c=true, crm_Has_Agreed_to_Emai__c=true, crm_Has_Agreed_to_SMS__c=false);
            leadsToInsert.add(l);
        }        
        insert leadsToInsert;
        Test.startTest();
        	Database.executeBatch(new crm_LeadMultiselectPicklistBatch());
        Test.stopTest();
    }

}