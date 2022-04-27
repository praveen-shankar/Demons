/*
Created By:Vasudha Tandon
Date: 11 March 2021
Multi Relation level for opportunity
*/

@isTest

public class MultiSelectRelationAccountForOppTest{

    @testSetup static void setup() {
    
        crm_TestDataFactory.CreateCustomSetting();
        //create party level account
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt.Orga__c = '38975894359';
        insert  partyLevelacnt;
        
        Account relationLevelAcnt1= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelAcnt1.crm_Customer_Number__c = 'OH123456789';
        relationLevelAcnt1.ParentId =partyLevelacnt.Id;
        insert relationLevelAcnt1;
        
        Account relationLevelAcnt2= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelAcnt2.crm_Customer_Number__c = 'OH94043456789';
        relationLevelAcnt2.ParentId =partyLevelacnt.Id;
        insert relationLevelAcnt2;

        //create opportunity
        Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
        oppAir.accountId=partyLevelacnt.id;
        oppAir.CloseDate=date.today().addDays(20);
        oppAir.StageName='New Opportunity';
        oppAir.crm_Opp_Service_Family__c='Air';
        oppAir.Customer_NOs_For_Agreement__c  = '104093356,BENO236355,BPNO1037456,71651376,BLNOC460050003275,47799291';
        insert oppAir;
        
        
         //create opportunity
        Opportunity opp2 = crm_TestDataFactory.createLinehaulOpportunity();
        opp2.accountId=partyLevelacnt.id;
        opp2.CloseDate=date.today().addDays(20);
        opp2.StageName='New Opportunity';
        opp2.crm_Opp_Service_Family__c='Linehaul';
        insert opp2;


   
    }
    
    
    
    static testMethod void testGetPiklistValues(){
    
         Opportunity opp=[Select id, stagename ,crm_Opp_Service_Group__c,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountid  from Opportunity limit 1]  ;
         Contact c = crm_TestDataFactory.createContact();
         c.accountid=opp.accountId;
         insert c;
         
         MultiSelectRelationAccountForOpp.getPiklistValues(opp.Id);
         
   
     }
     
     static testMethod void testGetSelectedCustomers(){
    
         Opportunity opp=[Select id, stagename ,Customer_NOs_For_Agreement__c  ,crm_Opp_Service_Group__c,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountid  from Opportunity limit 1]  ;
         Contact c = crm_TestDataFactory.createContact();
         c.accountid=opp.accountId;
         insert c;
         
         List<String> multiSelectedOptions = new List<String>();
         multiSelectedOptions.add('BENO236355');
         multiSelectedOptions.add('BLNOC46005000327');
         multiSelectedOptions.add('47799291');
         
         MultiSelectRelationAccountForOpp.getSelectedCustomers(opp.Id ,multiSelectedOptions);
        MultiSelectRelationAccountForOpp.getCustomerNumberForOpportunity(opp.Id);

         
         
   
     }
  
        
        
        
}