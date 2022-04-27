/*  Supriya Goel
 Date: 23 may  2018
 * Test class for crm_markUseronContact_Batch
 */

@isTest
public class crm_markduplicateContact_BatchTest {

       @testSetup static void setup() {
       crm_TestDataFactory.CreateCustomSetting();
   
       Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt1;
      
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partyLevelacnt1.id;
       insert  relationLevelacnt1;
       
       Id RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
       Profile P = [Select id from Profile where name='System Administrator'];
           
        User SalesUser= new User();
        SalesUser.lastname='test1';
        SalesUser.profileid=p.id;
        SalesUser.Email = 'sales@test.com';
        SalesUser.Username = 'sales_test134567@posten.test.com';
        SalesUser.CompanyName = 'TEST';
        SalesUser.Title = 'title';
        SalesUser.Alias = 'sales';
        SalesUser.TimeZoneSidKey = 'America/Los_Angeles';
        SalesUser.EmailEncodingKey = 'UTF-8';
        SalesUser.LanguageLocaleKey = 'en_US';
        SalesUser.LocaleSidKey = 'en_US';
        SalesUser.crm_User_Type__c ='Sales';   
        insert SalesUser;
           
           
        User marketingUser= new User();
        marketingUser.lastname='test1';
        marketingUser.profileid=p.id;
        marketingUser.Email = 'marketing@test.com';
        marketingUser.Username = 'marketing_test6788543245@posten.test.com';
        marketingUser.CompanyName = 'TEST';
        marketingUser.Title = 'title';
        marketingUser.Alias = 'mmark';
        marketingUser.TimeZoneSidKey = 'America/Los_Angeles';
        marketingUser.EmailEncodingKey = 'UTF-8';
        marketingUser.LanguageLocaleKey = 'en_US';
        marketingUser.LocaleSidKey = 'en_US';
        insert marketingUser;
        
        
        
        //other user
        
         User otherUser= new User();
        otherUser.lastname='test1';
        otherUser.profileid=p.id;
        otherUser.Email = 'otherUser@test.com';
        otherUser.Username = 'otherUser_test09766899@posten.test.com';
        marketingUser.CompanyName = 'TEST';
        otherUser.Title = 'title';
        otherUser.Alias = 'mmark';
        otherUser.TimeZoneSidKey = 'America/Los_Angeles';
        otherUser.EmailEncodingKey = 'UTF-8';
        otherUser.LanguageLocaleKey = 'en_US';
        otherUser.LocaleSidKey = 'en_US';
          otherUser.crm_User_Type__c ='Other';
        insert otherUser;
            
       Contact con= crm_TestDataFactory.createContact();
       con.accountid=partyLevelacnt1.id;
       con.Status__c='Aktiv';
       con.crm_Contact_Type__c='Sales';
       con.email= 'testcontact@test.com';
       con.Recordtypeid=RecordTypeId;
       insert con;
        
       con.MobilePhone='222';
       con.crm_functional_decision_level__c ='Decision maker';
           
       con.Meaningful_User__c=marketingUser.id;
       con.Last_modified_Date__c = System.today();
       con.ProcessedContactHistory__c = true;
       con.Updated_Mobile__c= '11111';   
       con.Mobile_Updated_Meaningful_User_date__c  = System.today().adddays(-1);
       update con;
       
          
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
       con1.Meaningful_User__c=marketingUser.id;
       con1.Last_modified_Date__c = System.today();
       con1.ProcessedContactHistory__c = true;
       con1.Updated_Mobile__c= '11111';   
       con1.Mobile_Updated_Meaningful_User_date__c  = System.today();
       update con1; 
       /* by sales user */    
       Contact con2= crm_TestDataFactory.createContact();
       con2.accountid=partyLevelacnt1.id;
       con2.Status__c='Aktiv';
       con2.crm_Contact_Type__c='Sales';
       con2.Recordtypeid=RecordTypeId;
       con2.email= 'testcontactsales@test.com';
       insert con2;
        
       con2.MobilePhone='1111';
       con2.crm_functional_decision_level__c ='User';
       con2.crm_No_to_Marketing_activities__c= true;
       con2.Meaningful_User__c=SalesUser.id;
       con2.Last_modified_Date__c = System.today();
       con2.ProcessedContactHistory__c = true;
       con2.Updated_Mobile__c= '11111';   
       con2.Mobile_Updated_Meaningful_User_date__c  = System.today();
       update con2; 
           
       Contact con3= crm_TestDataFactory.createContact();
       con3.accountid=partyLevelacnt1.id;
       con3.Status__c='Aktiv';
       con3.crm_Contact_Type__c='Sales';
       con3.Recordtypeid=RecordTypeId;
       con3.email= 'testcontactsales12966894@posten.test.com';
       insert con3;
        
       con3.MobilePhone='1111';
       con3.crm_functional_decision_level__c ='User';
       con3.crm_No_to_Marketing_activities__c= true;
       con3.Meaningful_User__c=SalesUser.id;
       con3.Last_modified_Date__c = System.today();
       con3.ProcessedContactHistory__c = true;
       con3.Updated_Mobile__c= '11111';   
       con3.Mobile_Updated_Meaningful_User_date__c  = System.today();
       update con3; 
       
       
       Contact con4= crm_TestDataFactory.createContact();
       con4.accountid=partyLevelacnt1.id;
       con4.Status__c='Aktiv';
       con4.crm_Contact_Type__c='Sales';
       con4.Recordtypeid=RecordTypeId;
       con4.email= 'testcontactother@test.com';
       insert con4;
        
       con4.MobilePhone='3333';
       con4.crm_functional_decision_level__c ='User';
       con4.crm_No_to_Marketing_activities__c= true;
       con4.Meaningful_User__c=otherUser.id;
       con4.Last_modified_Date__c = System.today().adddays(-1);
       con4.ProcessedContactHistory__c = true;
       con4.Updated_Mobile__c= '11111';   
       con4.Mobile_Updated_Meaningful_User_date__c  = System.today();
       update con4; 
       
       
       Contact con5= crm_TestDataFactory.createContact();
       con5.accountid=partyLevelacnt1.id;
       con5.Status__c='Aktiv';
       con5.crm_Contact_Type__c='Sales';
       con5.Recordtypeid=RecordTypeId;
       con5.email= 'testcontactother@test.com';
       insert con5;
        
       con5.MobilePhone='3333';
       con5.crm_functional_decision_level__c ='User';
       con5.crm_No_to_Marketing_activities__c= true;
       con5.Meaningful_User__c=otherUser.id;
       con5.Last_modified_Date__c = System.today().adddays(-1);
       con5.ProcessedContactHistory__c = true;
       con5.Updated_Mobile__c= '11111';   
       con5.Mobile_Updated_Meaningful_User_date__c  = System.today();
       update con5; 
       
            
           
       }
    
    static TestMethod void testBatch()
        {
            System.Test.StartTest();
           // Database.executeBatch(new crm_markUseronContact_Batch());
            crm_markduplicateContact_Batch obj= new crm_markduplicateContact_Batch();
            obj.dummytest();
            Database.executeBatch(new crm_markduplicateContact_Batch());
            System.Test.StopTest();
        }
    
}