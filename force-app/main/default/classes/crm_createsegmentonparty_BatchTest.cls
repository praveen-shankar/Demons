/* 
Date: 06 Sept 2019
Test class: Test class for Create Segment on Party on converted customers
*/

@isTest
public class crm_createsegmentonparty_BatchTest {
    
       
    static TestMethod void testCreateSegment()
    {
    
    crm_TestDataFactory.CreateCustomSetting();
        //create party level account
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        insert  partyLevelacnt;

    
    //create admin user
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
   User u = new User();
        u.Alias = 'admin';
        u.Email='admin@test.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='testsegment@testuser1.com';
        insert u;   
    
    
    
    environment_settings__c  objCustomSetting = new environment_settings__c ();
        objCustomSetting.value__c='testsegment@testuser1.com';
        objCustomSetting.Name = 'Ufordelte kunder logistikk norge';
        insert objCustomSetting ;
        
    
       
    //insert segments
  
    
    partyLevelacnt.Customer_Converted__c='InPreparation';
        update partyLevelacnt;
        
        partyLevelacnt.Customer_Converted__c='Converted';
        partyLevelacnt.Is_Segment_Created__c= false;
        update partyLevelacnt;
        
          crm_segment__c segobj1= crm_TestDataFactory.createSegment();
    segobj1.crm_Account__c= partyLevelacnt.id;
    segobj1.crm_Service_Group__c ='Parcels – Domestic Norway';
    segobj1.crm_Sales_Responsible__c =u.id;
    insert segobj1;  
        
        Test.startTest();
        crm_createsegmentonparty_Batch obj= new crm_createsegmentonparty_Batch();
        Database.executeBatch(obj);
        Test.stoptest();
     }
        }