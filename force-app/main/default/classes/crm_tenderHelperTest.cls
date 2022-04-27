@isTest
public class crm_tenderHelperTest{

@testSetup static void setup() {
    
    //create party level account   
    
    crm_TestDataFactory.CreateCustomSetting();
    Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
    partyLevelacnt.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  partyLevelacnt; 
    
    
    
    }
    
     testMethod static void tendercreatetest()
    {
    
        Account party =[Select id from Account where crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP' ];
        crm_Tender__c tenderobj1= new crm_tender__c();
        tenderobj1.name='Test';
        tenderobj1.crm_account__c=party.Id;
        insert tenderobj1;
        
   }
   
   testmethod static void  tendercalculations (){
   
    Account party =[Select id from Account where crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP' ];
        crm_Tender__c tenderobj1= new crm_tender__c();
        tenderobj1.name='Test';
        tenderobj1.crm_account__c=party.Id;
        tenderobj1.currencyIsocode='NOK';
        insert tenderobj1;
        
        Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
        oppAir.accountId=party.id;
        oppAir.CloseDate=date.today().addDays(20);
        oppAir.StageName='New Opportunity';
        oppAir.crm_Opp_Service_Family__c='Air';
        oppAir.crm_Close_Behaviour__c='Create';
        oppAir.crm_tender__c= tenderobj1.id;
        //oppAir.crm_Probability__c= 80; 
        insert oppAir;
        
        tenderobj1.currencyIsocode='EUR';
        update tenderobj1;
        
   
   }
   
   }