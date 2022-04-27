@isTest
public class crm_tenderteamroletriggerHelperTest{

@testSetup static void setup() {
    
    //create party level account   
    
    crm_TestDataFactory.CreateCustomSetting();
    Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
    partyLevelacnt.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  partyLevelacnt; 
    
    crm_Tender__c tenderobj1= new crm_tender__c();
    tenderobj1.name='Test';
    tenderobj1.crm_account__c=partyLevelacnt.Id;
    insert tenderobj1;
    
    }
    
     testMethod static void tenderteamroletest()
    {
    
     crm_Tender__c tenderobj1 =[Select id from crm_Tender__c where name='Test'];
     User u = crm_TestDataFactory.createUser();
     insert u;
        
        
        crm_Tender_Team_Role__c  tenderteamobj1= new crm_Tender_Team_Role__c ();
        tenderteamobj1.crm_tender__c=tenderobj1.id;
        tenderteamobj1.crm_user__c=u.id;
        tenderteamobj1.crm_Team_Role__c='Bid Owner';
        
        insert tenderteamobj1;
        
   }
   
   }