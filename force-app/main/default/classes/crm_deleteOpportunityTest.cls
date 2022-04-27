/*
Created By : supriya goel
Date: 25 nov
delet opp
*/

@isTest

public class crm_deleteOpportunityTest{

    @testSetup static void setup() {
     crm_TestDataFactory.CreateCustomSetting();
        //create party level account
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        insert  partyLevelacnt;

        //create opportunity
        Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
        oppAir.accountId=partyLevelacnt.id;
        oppAir.CloseDate=date.today().addDays(20);
        oppAir.StageName='New Opportunity';
        oppAir.crm_Opp_Service_Family__c='Air';
        insert oppAir;
        
         //create opportunity
        Opportunity opp2 = crm_TestDataFactory.createLinehaulOpportunity();
        opp2.accountId=partyLevelacnt.id;
        opp2.CloseDate=date.today().addDays(20);
        opp2.StageName='New Opportunity';
        opp2.crm_Opp_Service_Family__c='Linehaul';
        insert opp2;
    
    
    }
    static testMethod void testdeletewithagr(){
        Opportunity oppAir=[Select id, stagename ,crm_Opp_Service_Group__c,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountid  from Opportunity  where crm_Opp_Service_Family__c='Air' limit 1]  ;

     Contact c = crm_TestDataFactory.createContact();
     c.accountid=oppAir.accountId;
     insert c;
      
    OpportunityContactRole opprconrole= new OpportunityContactRole();
    opprconrole.ContactId= c.id;
    opprconrole.IsPrimary=true;
    opprconrole.OpportunityId= oppAir.id;
    insert opprconrole;
        //active agreement with service family air    
    oppAir.stagename ='Offer Sent'   ;
    Update oppAir;    
        oppAir.stagename ='Closed Won'   ;
        oppAir.crm_reason_won__c ='Price';
        oppAir.Amount=500;
        oppAir.crm_Agreement_Start_Date__c = date.today();
        Update oppAir;    
        
        System.Test.startTest();   
        ApexPages.StandardController sc = new ApexPages.standardController(oppAir);
        crm_deleteOpportunity opp = new crm_deleteOpportunity(sc);
        opp.deleteOpportunity();
        System.Test.stopTest();   
        }
        
        static testMethod void testdeletewithoutagr(){
        
        Opportunity opp=[Select id, stagename ,crm_Opp_Service_Group__c,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountid  from Opportunity  where crm_Opp_Service_Family__c='Linehaul' limit 1]  ;
        System.Test.startTest();   
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        crm_deleteOpportunity oppobj = new crm_deleteOpportunity(sc);
        oppobj.deleteOpportunity();
        System.Test.stopTest();
        
        
        }
    }