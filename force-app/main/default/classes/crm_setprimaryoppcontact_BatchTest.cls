/* Created By: Supriya Goel
Date:14th nov 16
Test class: for crm_setprimaryoppcontact_Batch 
*/

@isTest()
public class crm_setprimaryoppcontact_BatchTest{

@testSetup static void setup() {

      crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
       
         //insert for sea SF
        Opportunity oppsea = crm_TestDataFactory.createSeaOpportunity();
        oppsea.accountId=partyLevelacnt.id;
        oppsea.CloseDate=date.today().addDays(20);
        oppsea.StageName='New Opportunity';
        oppsea.crm_Opp_Service_Family__c='Sea';
        oppsea.crm_Probability__c= '25'; 
        insert oppsea;
       }

     static testMethod void testOppContactRole(){
        Opportunity oppSea=[Select stagename ,accountId  from Opportunity  where crm_Opp_Service_Family__c='Sea' limit 1]  ;
    
          //create contact
        Contact c = crm_TestDataFactory.createContact();
        c.accountid=oppSea.accountId;
        insert c;
        
        OpportunityContactRole opprconrole= new OpportunityContactRole();
        opprconrole.ContactId= c.id;
        opprconrole.IsPrimary=true;
        opprconrole.OpportunityId= oppSea.id;
        insert opprconrole;
        //active agreement with service family air    
        
        oppSea.crm_Primary_opportunity_contact__c=c.id;
        update oppSea;
         
        crm_setprimaryoppcontact_Batch  acb = new crm_setprimaryoppcontact_Batch('test'); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        System.Test.stopTest(); 
    }
}