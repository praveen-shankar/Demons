/* Created By: Supriya goel
Date: 5th feb 2018
Test class: crm_ContactCount_Batch test
*/

@isTest
public class crm_ContactCount_BatchTest{

@testSetup static void setup() {
    
    //create party level account   
    
    crm_TestDataFactory.CreateCustomSetting();
    Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
    partyLevelacnt.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  partyLevelacnt; 
    
    //create relation level accounts  
    Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt1.parentId=partyLevelacnt.id;
    relationLevelacnt1.crm_Customer_Number__c='12345';
    relationLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  relationLevelacnt1;
    
    Contact con= crm_TestDataFactory.createContact();
    con.accountid=relationLevelacnt1.id;
    insert con;
    
    Task t = crm_TestDataFactory.createTask();
    t.whoid= con.id;
    Insert t;
    
    Event e  = crm_TestDataFactory.createEvent();
    e.whoid= con.id;
    Insert e;
    
    
     Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
     oppAir.accountId=partyLevelacnt.id;
        oppAir.CloseDate=date.today().addDays(20);
        oppAir.StageName='New Opportunity';
        oppAir.crm_Opp_Service_Family__c='Air';
        oppAir.crm_Close_Behaviour__c='Create';
        //oppAir.crm_Probability__c= 80; 
        System.debug('###'+oppAir);
        insert oppAir;
        
        
        
        OpportunityContactRole opprconrole= new OpportunityContactRole();
        opprconrole.ContactId= con.id;
        opprconrole.IsPrimary=true;
        opprconrole.OpportunityId= oppAir.id;
        insert opprconrole;
        
        oppAir.Closedate =System.today()  ;
        Update oppAir;   
        
    
    
    }
    
    
     static TestMethod void testBatch()
        {
            System.Test.StartTest();
            Database.executeBatch(new crm_ContactCount_Batch('test'));
            System.Test.StopTest();
        }
    
    }