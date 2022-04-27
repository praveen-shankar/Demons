/*Date: 28 Nov 2016
Test class: Test class for the Contacttriggerhelper
*/

@isTest
public class crm_updatecontactTypeTest{

    static TestMethod void testcreatecontact() {
    //create party level account
       crm_TestDataFactory.CreateCustomSetting();
         //BusinessStreet, BusinessCity, BillingState, BusinessPostalCode,  BusinessCountry,
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       partyLevelacnt.crm_Count_of_Relation_level_Accounts__c=1;
       insert  partyLevelacnt;
       
       ContactTriggerSetting__c  objConCustomSetting = new ContactTriggerSetting__c();
        objConCustomSetting.Contact_Trigger_Status__c=true;
        objConCustomSetting.Name = 'Contact';
        insert objConCustomSetting;
       
       Contact con=new Contact();
       con.lastname='testmaping';
       con.email='Testmapping@cap.com';
       con.AccountId=partyLevelacnt.id;
       con.crm_Contact_Type__c='Sales';
       insert con;
       
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partyLevelacnt.id;
       relationlevelacnt1.crm_Primary_Customer_Account__c=true;
       insert  relationLevelacnt1;
       
       User u= crm_TestDataFactory.createUser();
       u.crm_user_type__c='Customer Service';
       insert u;      
       
           Contact con1=[Select id from contact where id=:con.id];
           System.runas(u)
           {
               Update con1;
           }
       }
       
          public static testmethod void ContactTriggerTest()

          {     

               insert new et4ae5__Configuration__c(et4ae5__Support_Ticket_Recipient__c = 'example@example.com');
    
               Test.startTest();
    
               Contact c = new Contact(LastName='TestExample');
    
               // Insert contact
    
               insert c;
    
               // If no exceptions occurred, it was successful 
    
               System.assert(!String.isBlank(c.Id));
    
               Test.stopTest();

         } 
       
    }