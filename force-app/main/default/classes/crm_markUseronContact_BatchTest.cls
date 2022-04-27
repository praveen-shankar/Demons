/*  Supriya Goel
 Date: 23 may  2018
 * Test class for crm_markUseronContact_Batch
 */

@isTest
public class crm_markUseronContact_BatchTest {
    
    @testSetup static void setup() {
       crm_TestDataFactory.CreateCustomSetting();
   
       Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt1;
      
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partyLevelacnt1.id;
       insert  relationLevelacnt1;
       
       Id RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
            
       Contact con= crm_TestDataFactory.createContact();
       con.accountid=partyLevelacnt1.id;
       con.Status__c='Aktiv';
       con.crm_Contact_Type__c='Sales';
       con.email= 'testcontact@test.com';
       con.Recordtypeid=RecordTypeId;
       insert con;
        
       con.MobilePhone='222';
       con.crm_functional_decision_level__c ='Decision maker';
       update con;
        
        Profile P = [Select id from Profile where name='System Administrator'];
    
        User marketingUser= new User();
        marketingUser.lastname='test1';
        marketingUser.profileid=p.id;
        marketingUser.Email = 'marketing@test.com';
        marketingUser.Username = 'marketing_test@test.com';
        marketingUser.CompanyName = 'TEST';
        marketingUser.Title = 'title';
        marketingUser.Alias = 'mmark';
        marketingUser.TimeZoneSidKey = 'America/Los_Angeles';
        marketingUser.EmailEncodingKey = 'UTF-8';
        marketingUser.LanguageLocaleKey = 'en_US';
        marketingUser.LocaleSidKey = 'en_US';
        insert marketingUser;
        
        System.RunAs(marketingUser) {
       
       Contact con1= crm_TestDataFactory.createContact();
       con1.accountid=partyLevelacnt1.id;
       con1.Status__c='Aktiv';
       con1.crm_Contact_Type__c='Sales';
       con1.Recordtypeid=RecordTypeId;
       con1.email= 'testcontact@test.com';
       insert con1;
        
       con1.MobilePhone='1111';
       con1.crm_functional_decision_level__c ='User';
       con1.crm_No_to_Marketing_activities__c= true;
       update con1; 
            
        }   
        
   
       }
      
       
        static TestMethod void testBatch()
        {
            System.Test.StartTest();
            Database.executeBatch(new crm_markUseronContact_Batch());
            System.Test.StopTest();
        }
        
     }