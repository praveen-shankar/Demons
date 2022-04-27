/* Date:12/1/2018
 * Test class for Create Contact lightning component
 */

@isTest
public class CreateContactController_Test {
    
    @testSetup static void setup() {
     crm_TestDataFactory.CreateCustomSetting();
   
       Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt1;
      
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partyLevelacnt1.id;
       insert  relationLevelacnt1;
       
       User u = crm_TestDataFactory.createUser();
       u.crm_user_type__c='Sales';
       insert u;
       
       Contact duplicateContact=new Contact();
       duplicateContact.lastName='testduplicate';
       duplicateContact.email='testduplicate@cg.com';
       duplicateContact.Status__c='Active';
            try
            {
               insert duplicateContact;
            }
            catch(Exception e)
            {
                System.assert(e.getMessage().contains('You\'re creating a duplicate record'));
            }
        
       }
    static TestMethod void testCreateContact()
      {
         Account acc=[Select id from account where parentid!=null limit 1];
        
          CreateContactController.getAccountOptions('');
          CreateContactController.getfunctionalarea();
          CreateContactController.getstatus();
          CreateContactController.getfunctionaldecisionlevel();
          
          contact con=new contact();
          con.lastName='testcontact1';
           con.Email='contest@cap.com';
          con.AccountId=acc.id;
          CreateContactController.createRecord(con);
         CreateContactController.createDuplicateRecord(con,acc.id);
          
       }
}