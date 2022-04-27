/* Date:  5th april 2018
 * Test class for crm_CopyRelatedrecords_Batch  
 */

@isTest
public class crm_CopyRelatedrecords_BatchTest {
    
    @testSetup static void setup() {
       crm_TestDataFactory.CreateCustomSetting();
   
       Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt1;
      
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partyLevelacnt1.id;
       insert  relationLevelacnt1;
       
       Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
       Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
            
       Contact con= crm_TestDataFactory.createContact();
       con.accountid=relationLevelacnt1.id;
       con.Status__c='Aktiv';
       con.crm_Contact_Type__c='Sales';
       con.Recordtypeid=salesRecordTypeId;
       insert con;
       
       Contact con1= crm_TestDataFactory.createContact();
       con1.accountid=relationLevelacnt1.id;
       con1.Status__c='Aktiv';
       con1.crm_Contact_Type__c='Customer Service';
       con1.Recordtypeid=csRecordTypeId;
       con1.Master_Reference_Id__c =con.id;
       insert con1;
       
       con.Master_Reference_Id__c = con1.id;
       update con;
       
           //create cargo +air opp
        Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
        oppAir.accountId=partyLevelacnt1.id;
        oppAir.CloseDate=date.today().addDays(20);
        oppAir.StageName='New Opportunity';
        oppAir.crm_Opp_Service_Family__c='Air';
        oppAir.crm_Close_Behaviour__c='Create';
        insert oppAir;
        
        OpportunityContactRole opprconrole1= new OpportunityContactRole();
        opprconrole1.ContactId= con1.id;
        opprconrole1.IsPrimary=true;
        opprconrole1.OpportunityId= oppAir.id;
        insert opprconrole1;
        
        Task t = crm_TestDataFactory.createTask();
        t.whoid= con1.id;
        Insert t;
        
        Event e= crm_TestDataFactory.createEvent();
        e.whoid= con1.id;
        Insert e;
        
        Campaign c= new Campaign();
        c.name= 'Test Campaign';
        insert c;
        
        CampaignMember cm1= new  CampaignMember();
        cm1.campaignid= c.id;
        cm1.contactid=con1.id;
        insert cm1;
        
        crm_Tender__c tenderobj1= new crm_tender__c();
        tenderobj1.name='Test1';
        tenderobj1.crm_account__c=partyLevelacnt1.id;
        insert tenderobj1;
        
        crm_Tender_Contact_Role__c tencontactrole = new crm_Tender_Contact_Role__c();
        tencontactrole.crm_Contact__c = con1.id;
        tencontactrole.crm_Tender__c = tenderobj1.id;
        tencontactrole.crm_Contact_Role__c = '  Business User';
        insert  tencontactrole;
      
              
       }
       
        static TestMethod void testBatch()
        {
            System.Test.StartTest();
            Database.executeBatch(new crm_CopyRelatedrecords_Batch());
            System.Test.StopTest();
        }
        
     }