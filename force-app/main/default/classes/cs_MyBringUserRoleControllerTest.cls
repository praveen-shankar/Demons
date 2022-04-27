@isTest
public class cs_MyBringUserRoleControllerTest {
    
    @isTest
    static void userRoletest(){
        String rectypeId = [Select Id from recordType  where  name = 'Relation Level Customer' Limit 1].Id;
        Account relLevelAcc = New Account(Name='Test Account',
                                              recordTypeId=rectypeId);
        insert relLevelAcc;
        
        String ContactRectypeId = [Select Id from recordType  where  name = 'Customer Service' Limit 1].Id;
        Contact con = New Contact(firstname='test',lastname='cs contact',crm_contact_type__c='Customer Service',
       						      recordTypeId = ContactRectypeId, AccountId=relLevelAcc.Id);
        
        insert con;
        
        AccountContactRelation acr = [Select AccountId, ContactId, roles__c from AccountContactRelation where AccountId= :relLevelAcc.Id And contactId= :con.Id];
        acr.roles__c='FINANCE;ADMIN';
        
        Test.startTest();
        cs_MyBringUserRoleController.getCustomers(con.Id);
        cs_MyBringUserRoleController.getRoles(relLevelAcc.Id, con.Id);
        Test.stopTest();
    }
}