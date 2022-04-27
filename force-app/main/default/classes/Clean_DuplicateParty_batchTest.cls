/* Created By: Supriya
Test class: Clean_DuplicateParty_batch
*/

@isTest
public class Clean_DuplicateParty_batchTest{

@testSetup static void setup() {
    
    //create party level account   
    
    crm_TestDataFactory.CreateCustomSetting();
    
    
    Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
    Profile P = [Select id from Profile where name='System Administrator'];
    
      User cdhUser= new User();
        cdhUser.lastname='test1';
        cdhUser.profileid=p.id;
        cdhUser.Email = 'cdhUser@test.com';
        cdhUser.Username = 'cdhuser_test@test.com';
        cdhUser.CompanyName = 'TEST';
        cdhUser.Title = 'title';
        cdhUser.Alias = 'alias';
        cdhUser.TimeZoneSidKey = 'America/Los_Angeles';
        cdhUser.EmailEncodingKey = 'UTF-8';
        cdhUser.LanguageLocaleKey = 'en_US';
        cdhUser.LocaleSidKey = 'en_US';
        insert cdhUser;
        
        User batchUser= new User();
        batchUser.lastname='test1_datamigration';
        batchUser.profileid=p.id;
        batchUser.Email = 'batchUser@test.com';
        batchUser.Username = 'batchUser_test@test.com';
        batchUser.CompanyName = 'TEST';
        batchUser.Title = 'title';
        batchUser.Alias = 'alias';
        batchUser.TimeZoneSidKey = 'America/Los_Angeles';
        batchUser.EmailEncodingKey = 'UTF-8';
        batchUser.LanguageLocaleKey = 'en_US';
        batchUser.LocaleSidKey = 'en_US';
        insert batchUser;
        
        User DatamigrationUser= new User();
        DatamigrationUser.lastname='test1';
        DatamigrationUser.profileid=p.id;
        DatamigrationUser.Email = 'DatamigrationUser@test.com';
        DatamigrationUser.Username = 'DatamigrationUser_test@test.com';
        DatamigrationUser.CompanyName = 'TEST';
        DatamigrationUser.Title = 'title';
        DatamigrationUser.Alias = 'alias';
        DatamigrationUser.TimeZoneSidKey = 'America/Los_Angeles';
        DatamigrationUser.EmailEncodingKey = 'UTF-8';
        DatamigrationUser.LanguageLocaleKey = 'en_US';
        DatamigrationUser.LocaleSidKey = 'en_US';
        insert DatamigrationUser;
      
      List<environment_settings__c> settingList=new List<environment_settings__c>();
        environment_settings__c  CDHUserId=new environment_settings__c();
        CDHUserId.Name='CDHUserId';
     // CDHUserId.ReplyToEmailAddress__c = 'cdhUser@test.com';
        CDHUserId.value__c=cdhUser.id;
        
        settingList.add(CDHUserId);
        
        environment_settings__c  BatchjobUserId=new environment_settings__c();
        BatchjobUserId.Name='BatchjobUserId';
     // BatchjobUserId.ReplyToEmailAddress__c = 'batchUser@test.com';
        BatchjobUserId.value__c=batchuser.id;
       
        settingList.add(BatchjobUserId);
        
        environment_settings__c  DatamigrationUserId=new environment_settings__c();
        DatamigrationUserId.Name='DataMigrationUserId';
     // DatamigrationUserId.ReplyToEmailAddress__c = 'DatamigrationUser@test.com';
        DatamigrationUserId.value__c=DatamigrationUser.id;
        settingList.add(DatamigrationUserId);
        
        environment_settings__c  batchEmailUser =new environment_settings__c();
        batchEmailUser.Name='BatchEmailNotification';
    //    batchEmailUser.ReplyToEmailAddress__c = 'batchemailUser@test.com';
        batchEmailUser.value__c='test@salesforce.com';
        
        settingList.add(batchEmailUser);
        insert settingList;
    
    
     System.debug('settingList'+ settingList);
               
    System.RunAs(batchuser) {
    partyLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    partyLevelacnt1.orga__c ='12345';
    insert  partyLevelacnt1;

          }
    
    System.debug('partyLevelacnt1'+ partyLevelacnt1);
          
          
    Account partyLevelacnt2= crm_TestDataFactory.createPartylevelAccount();
    
          
    System.RunAs(cdhuser) {
    partyLevelacnt2.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    partyLevelacnt2.orga__c ='12345';
    insert  partyLevelacnt2;

          }

     
    //create relation level accounts  
    Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt1.parentId=partyLevelacnt1.id;
    relationLevelacnt1.crm_Customer_Number__c='123456';
    relationLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  relationLevelacnt1;
    
    crm_Segment__c segobj1= new crm_Segment__c ();
    segobj1.crm_Account__c= partyLevelacnt1.id;
    segobj1.crm_Service_Group__c ='Cargo Domestic';
    insert segobj1; 
    
    crm_Caesar_Document__c  ceassardoc= new crm_Caesar_Document__c();
    ceassardoc.crm_Account__c=partyLevelacnt1.id;
    ceassardoc.crm_Created_Date__c=System.today();
    insert ceassardoc;
    
    crm_Caesar_Activity_Document__c actdoc= new crm_Caesar_Activity_Document__c();
    actdoc.crm_Account__c= partyLevelacnt1.id;
    actdoc.crm_Created_Date__c=System.today();
    insert actdoc;
    
     Contact Contact1=new Contact();
       Contact1.lastName='test1';
       Contact1.email='test1@cg.com';
       Contact1.Status__c='Active';
       contact1.accountid= relationLevelacnt1.id;
       insert Contact1;
       
       AccountContactRelation acr = new AccountContactRelation();
       acr.contactid=contact1.id;
       acr.Accountid= partyLevelacnt1.id;
       insert acr;
       
       crm_Customer_Event__c  custevent = new crm_Customer_Event__c();
       custevent.crm_Account__c= partyLevelacnt1.id;
       custevent.crm_Code__c ='2333';
       custevent.crm_Description__c='test';
       insert custevent;
       
       crm_Request_RelationCustomer__c reqcust= new crm_Request_RelationCustomer__c();
       reqcust.crm_Customer__c= partyLevelacnt1.id;
       reqcust.crm_RequestedCreditAmount__c = 100;
       insert reqcust;
       
          Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
        oppAir.accountId=partyLevelacnt1.id;
        oppAir.CloseDate=date.today().addDays(20);
        oppAir.StageName='New Opportunity';
        oppAir.crm_Opp_Service_Family__c='Air';
        oppAir.crm_Close_Behaviour__c='Create';
       
        insert oppAir;
       
       
       
       event e1 =  crm_TestDataFactory.createEvent();
       e1.whatid=partyLevelacnt1.id;
       insert e1;
       
       Task t1= crm_TestDataFactory.createTask();
       t1.whatid= partyLevelacnt1.id;
       insert t1;
       
       
    
    Account relationLevelacnt2= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt2.parentId=partyLevelacnt2.id;
    relationLevelacnt2.crm_Customer_Number__c='1234567';
    relationLevelacnt2.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  relationLevelacnt2;
    
  
    }
    
     testMethod static void cleanpartyTest()
    {
        System.Test.StartTest();
        Clean_DuplicateParty_batch  batchObj=new Clean_DuplicateParty_batch();
        Database.ExecuteBatch(batchObj);
        System.Test.StopTest();
    }
    
 }