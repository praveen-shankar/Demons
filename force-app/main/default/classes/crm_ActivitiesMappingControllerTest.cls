/* Created By: Supriya Goel
Date: 7th sept   2016
Test class: crm_ActivitiesMappingController
*/

@isTest
public class crm_ActivitiesMappingControllerTest{

@testSetup static void setup() {

       crm_TestDataFactory.CreateCustomSetting();
       //create Relation level account
       Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
       insert  relationLevelacnt;
       
       //create contact
       Contact c= crm_TestDataFactory.createContact();
       insert c;
       
       //Definig owner
      Profile p = [SELECT Id FROM Profile WHERE Name = 'CRM Sales User'];
      User u1 = new User( Alias = 'testu', Email = 'test@example.com',EmailEncodingKey = 'UTF-8',LastName = 'Test',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', TimeZoneSidKey='America/Los_Angeles', ProfileId = p.Id, UserName='test@example.com');
      User u2 = new User( Alias = 'testuser', Email = 'test1@example.com',EmailEncodingKey = 'UTF-8',LastName = 'Test1',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', TimeZoneSidKey='America/Los_Angeles', ProfileId = p.Id, UserName='test1@example.com');
       
       
       //create event
       Event e1 =crm_TestDataFactory.createEvent();
       e1.crm_who_Id__c=c.id;
       e1.crm_what_Id__c = relationLevelacnt.id;
       e1.crm_Owner_Temp__c = u1.id ; 
       insert e1;
       
        //create event
       Event e2 =crm_TestDataFactory.createEvent();
       e2.crm_who_Id__c=c.id;
       e2.crm_what_Id__c = relationLevelacnt.id;
       e2.crm_Owner_Temp__c = u2.id;
       insert e2;
       
       }

    static testMethod void testActivitiesMapping(){
          
          System.Test.startTest();
         environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
        crm_ActivitiesMappingController  classObj= new  crm_ActivitiesMappingController ();
        
        Database.executeBatch(classObj);
        System.Test.stopTest();
     
    }
}