/*
Created By:Dinesh kumar
Date: 12 April 21016 (Sprint 3)
create Addon Opportunity and create Renegotiate Opportunity
*/

@isTest

public class crm_opportunityProcessTest{

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


        //create draft agreement
        crm_Agreement__c agreement= crm_TestDataFactory.createAgreement();
        agreement.crm_Account__c = partyLevelacnt.id;
        agreement.crm_Status__c ='Draft';
        agreement.crm_Agreement_Start_Date__c= system.today().addDays(1);
        agreement.crm_Agreement_End_Date__c= system.today().addDays(5);
        insert agreement;
        
        Product2 prod = crm_TestDataFactory.createProduct();
        insert prod;   

    Id pricebookId = System.Test.getStandardPricebookId();

    PricebookEntry standardPrice = crm_TestDataFactory.createPricebookEntry();
    
    standardPrice.Pricebook2Id = pricebookId;
    standardPrice.Product2Id = prod.Id;
    insert standardPrice;

    Pricebook2 customPB = crm_TestDataFactory.createPricebook();
    customPB.Name ='Air';
    insert customPB;
    
    PricebookEntry customPrice = crm_TestDataFactory.createPricebookEntry();
    customPrice.Pricebook2Id = customPB.Id;
    customPrice.Product2Id = prod.Id;
    insert customPrice;
        
    OpportunityLineItem oppLine = new OpportunityLineItem();
    oppLine.pricebookentryid=customPrice.Id;
    oppLine.TotalPrice=2000;
    oppLine.Quantity = 2;
    oppLine.OpportunityID = oppAir.Id;
    oppLine.crm_lineItemsGroupId__c = '9876543210-Air';
    insert oppLine;
        
    OpportunityLineItem oppLine1 = new OpportunityLineItem();
    oppLine1.pricebookentryid=customPrice.Id;
    oppLine1.TotalPrice=2000;
    oppLine1.Quantity = 2;
    oppLine1.OpportunityID = opp2.Id;
    oppLine1.crm_lineItemsGroupId__c = '9876543210-Linehaul';
    insert oppLine1;

    }
    
    static testMethod void testUpsell(){
        Opportunity oppAir=[Select id, stagename ,crm_Opp_Service_Group__c,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountid  from Opportunity  where crm_Opp_Service_Family__c='Air' limit 1]  ;

        Contact c = crm_TestDataFactory.createContact();
     c.accountid=oppAir.accountId;
     insert c;
      
    OpportunityContactRole opprconrole= new OpportunityContactRole();
    opprconrole.ContactId= c.id;
    opprconrole.IsPrimary=true;
    opprconrole.OpportunityId= oppAir.id;
    insert opprconrole;
  
        oppAir.stagename ='Closed Won'   ;
        oppAir.crm_reason_won__c ='Price';
        oppAir.Amount=500;
        oppAir.crm_Agreement_Start_Date__c = date.today();
          Update oppAir;    
        
         environment_settings__c env = new environment_settings__c();
  env.Name = 'AgeementMasterInterfaceSwitch';
  env.value__c = 'false';
  insert env;

  crm_get_Service_Area__c customSetting = new crm_get_Service_Area__c();
  customSetting.name = 'Air';
  customSetting.Is_New__c = false;
  insert customSetting;
  Test.startTest();
    
      
        crm_createAgreementBatch batchObj=new crm_createAgreementBatch('test');
        Database.ExecuteBatch(batchObj);
          System.Test.stopTest();  
        
        
          
        
        
        oppAir=[Select id, crm_Agreement__c from Opportunity  where id = :oppAir.id limit 1];
        crm_Agreement__c agr= [Select id from crm_Agreement__c where id =:oppAir.crm_Agreement__c  limit 1];
        
       
        ApexPages.StandardController sc = new ApexPages.standardController(agr);
        crm_opportunityProcessOpp opp = new crm_opportunityProcessOpp(sc);
        opp.createAddonOpportunity();
          
    }
    
    static testMethod void testRenegotiate(){
    
     Opportunity opp=[Select id, stagename ,crm_Opp_Service_Group__c,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountid  from Opportunity  where crm_Opp_Service_Family__c='Linehaul' limit 1]  ;
     Contact c = crm_TestDataFactory.createContact();
     c.accountid=opp.accountId;
     insert c;
      
    OpportunityContactRole opprconrole= new OpportunityContactRole();
    opprconrole.ContactId= c.id;
    opprconrole.IsPrimary=true;
    opprconrole.OpportunityId= opp.id;
    insert opprconrole;
    

        opp.stagename ='Closed Won'   ;
        opp.crm_reason_won__c ='Price';
        opp.Amount=500;
        opp.crm_Agreement_Start_Date__c = date.today();
      
        Update opp;  
        
            environment_settings__c env = new environment_settings__c();
  env.Name = 'AgeementMasterInterfaceSwitch';
  env.value__c = 'false';
  insert env;

  crm_get_Service_Area__c customSetting = new crm_get_Service_Area__c();
  customSetting.name = 'Linehaul';
  customSetting.Is_New__c = false;
  insert customSetting;
  Test.startTest();    
        
         crm_createAgreementBatch batchObj=new crm_createAgreementBatch('test');
        Database.ExecuteBatch(batchObj);
          System.Test.stopTest();    

       opp=[Select id, crm_Agreement__c from Opportunity  where id = :opp.id limit 1];
        crm_Agreement__c agr= [Select id from crm_Agreement__c where id =:opp.crm_Agreement__c  limit 1];
        
       
        ApexPages.StandardController sc = new ApexPages.standardController(agr);
        crm_opportunityProcessOpp opp1 = new crm_opportunityProcessOpp(sc);
        opp1.createRenegotiateOpportunity();
        
        }

}