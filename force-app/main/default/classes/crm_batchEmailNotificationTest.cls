/* Created By: Supriya Goel
Date: 4th april  2016
Test class: crm_batchEmailNotification
*/

@isTest()
public class crm_batchEmailNotificationTest{

@testSetup static void setup() {
         
    user manager=  crm_TestDataFactory.createUser();
    insert manager;

    manager= [Select id from user where email = 'admin@test.com'];
    User u1 = crm_TestDataFactory.createSalesUser();
    u1.managerId= manager.id;
    insert u1;
    
    
    crm_ISO_Country_Codes__c countrycodes = new crm_ISO_Country_Codes__c ();
    countrycodes.crm_Country__c = 'india';
    countrycodes.crm_ISO_Country_Code__c = 'IN';
    countrycodes.name='1';
    insert countrycodes;

    lead leadobj1 = crm_TestDataFactory.createLead();
    leadobj1.OwnerId= u1.id;    
    leadobj1.Country='india';
    leadobj1.firstname='test firstname';
    leadobj1.status='New';
    insert  leadobj1 ;
      }

static testMethod void testLeads(){
      
    crm_batchEmailNotification ben = new crm_batchEmailNotification ('test');
    lead l =[Select id,crm_last_modified_status_datetime__c  from lead where status='New' limit 1 ];
    l.crm_last_modified_status_datetime__c =Date.today()-10;
        
    update l;
        
    crm_lead_notification_days__c lnd = new crm_lead_notification_days__c ();
    lnd.crm_Lead_Manager_Default_days__c = 5;
    lnd.crm_Lead_Owner_Default_days__c = 3;
    lnd.Name = 'Test Data';
    insert lnd;
    System.assertNotEquals(null , lnd );
    
      environment_settings__c envSetting = new environment_settings__c();
        envSetting.Name = 'BatchEmailNotification'; 
     // envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
        envSetting.value__c = 'test@posten.no';
        insert envSetting;
    
    System.Test.startTest();
    Database.executeBatch(ben);    
    System.Test.stopTest(); 
   }
}