/* Created By: Supriya Goel
Date: 23th may 2018 
Test class: crm_ContactMergeBatch 
*/

@isTest
public class crm_ContactMergeBatchTest{

@testSetup static void setup() { 
        crm_TestDataFactory.CreateCustomSetting();  
        Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        partyLevelacnt1.orga__c ='12345';
        insert  partyLevelacnt1;
        
         Account partyLevelacnt2= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt2.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
        partyLevelacnt2.orga__c ='1234544';
        insert  partyLevelacnt2;
        
        Contact duplicateContact1=new Contact();
       duplicateContact1.lastName='testduplicate';
       duplicateContact1.email='testduplicate@cg.com';
       duplicateContact1.Status__c='Active';
       duplicateContact1.accountid= partyLevelacnt1.id;
       insert duplicateContact1;
       
       Contact duplicateContact2=new Contact();
       duplicateContact2.lastName='testduplicate';
       duplicateContact2.email='testduplicate@cg.com';
       duplicateContact2.Status__c='Active';
       duplicateContact2.accountid= partyLevelacnt2.id;
       insert duplicateContact2;
       
       crm_ContactMerge__c  obj = new crm_ContactMerge__c ();
       obj.crm_Parent_ContactId__c= duplicateContact1.id;
       obj.crm_Child_ContactId__c= duplicateContact2.id;
       obj.crm_create_ACR_status__c = 'NotInitiated';
       insert obj;
       
       
        Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
        oppAir.accountId=partyLevelacnt1.id;
        oppAir.CloseDate=date.today().addDays(20);
        oppAir.StageName='New Opportunity';
        oppAir.crm_Opp_Service_Family__c='Air';
        oppAir.crm_Close_Behaviour__c='Create';
        insert oppAir;
        
        OpportunityContactRole opprconrole1= new OpportunityContactRole();
        opprconrole1.ContactId= duplicateContact2.id;
        opprconrole1.IsPrimary=true;
        opprconrole1.OpportunityId= oppAir.id;
        insert opprconrole1;
        
        Task t = crm_TestDataFactory.createTask();
        t.whoid= duplicateContact2.id;
        Insert t;
        
        Event e= crm_TestDataFactory.createEvent();
        e.whoid= duplicateContact2.id;
        Insert e;
        
        Campaign c= new Campaign();
        c.name= 'Test Campaign';
        insert c;
        
        CampaignMember cm1= new  CampaignMember();
        cm1.campaignid= c.id;
        cm1.contactid=duplicateContact2.id;
        insert cm1;
        
        crm_Tender__c tenderobj1= new crm_tender__c();
        tenderobj1.name='Test1';
        tenderobj1.crm_account__c=partyLevelacnt1.id;
        insert tenderobj1;
        
        crm_Tender_Contact_Role__c tencontactrole = new crm_Tender_Contact_Role__c();
        tencontactrole.crm_Contact__c = duplicateContact2.id;
        tencontactrole.crm_Tender__c = tenderobj1.id;
        tencontactrole.crm_Contact_Role__c = '  Business User';
        insert  tencontactrole;
    }
    
    static testMethod void mergetest(){
        Test.startTest();
        crm_ContactMergeBatch  batchObj=new crm_ContactMergeBatch ();
        Database.ExecuteBatch(batchObj);
        Test.stoptest();
             
             }
       
    
  }