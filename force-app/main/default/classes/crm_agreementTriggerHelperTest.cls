/* Created By: Supriya Goel
Date: 4th april  2016
Test class: crm_agreementTriggerHelper
*/

@isTest
public class crm_agreementTriggerHelperTest{

@testSetup static void setup() {

    crm_TestDataFactory.CreateCustomSetting();    
    //create party level account
    Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
    insert  partyLevelacnt;

    ////create cargo +air opp
    Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
    oppAir.accountId=partyLevelacnt.id;
    oppAir.CloseDate=date.today().addDays(20);
    oppAir.StageName='New Opportunity';
    oppAir.crm_Opp_Service_Family__c='Air';
    //oppAir.crm_Probability__c= 80; 
    insert oppAir;
    
    }
       

static testMethod void UpdateAgreementIdinOppTest(){   

 Opportunity oppAir = [Select stagename, crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Close_Behaviour__c, crm_Agreement__c, accountId from Opportunity where crm_Opp_Service_Family__c = 'Air'
   limit 1
  ];
  
  environment_settings__c env = new environment_settings__c();
  env.Name = 'AgeementMasterInterfaceSwitch';
  env.value__c = 'false';
  insert env;

  crm_get_Service_Area__c customSetting = new crm_get_Service_Area__c();
  customSetting.name = 'Air';
  customSetting.Is_New__c = false;
  insert customSetting;

  Contact c = crm_TestDataFactory.createContact();
  c.accountid = oppAir.accountId;
  insert c;
  oppAir.crm_Primary_Opportunity_Contact__c = c.id;


  oppAir.stagename = 'Offer Sent';
  Update oppAir;
  oppAir.stagename = 'Closed Won';
  oppAir.crm_reason_won__c = 'Price';
  oppAir.Amount = 500;
  oppAir.crm_Agreement_Start_Date__c = date.today();
  update OppAir;
  
 

  
    }
    
    
   static testMethod void testUpdateAgrstartdates(){
        
     Opportunity oppAir=[Select stagename ,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountId  from Opportunity  where crm_Opp_Service_Family__c='Air' limit 1]  ;
     system.debug('@@oppAir 1'+oppAir) ;
     
     Contact c = crm_TestDataFactory.createContact();
     c.accountid=oppAir.accountId;
     insert c;
      
    OpportunityContactRole opprconrole= new OpportunityContactRole();
    opprconrole.ContactId= c.id;
    opprconrole.IsPrimary=true;
    opprconrole.OpportunityId= oppAir.id;
    insert opprconrole;
    
    oppAir.stagename ='Offer Sent'   ;
    Update oppAir; 
    
    ////create cargo +air opp
     Opportunity opp1 = crm_TestDataFactory.createLinehaulOpportunity();
     opp1.accountId=oppAir.accountId;
     opp1.CloseDate=date.today().addDays(20);
     opp1.StageName='New Opportunity';
     opp1.crm_Opp_Service_Family__c='Linehaul';
     opp1.amount=5000;
     //opp1.crm_Probability__c= 80; 
     insert opp1;
    
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
 
      System.Test.startTest(); 
     crm_createAgreementBatch batchObj=new crm_createAgreementBatch('test');
        Database.ExecuteBatch(batchObj);
       
       Opportunity  opp= [Select id, crm_Agreement__c from Opportunity where id =: oppAir.Id limit 1];
       
       crm_Agreement__c agr1=  new crm_Agreement__c ();
      
       insert agr1;
       
        agr1.crm_Agreement_Start_Date__c= date.today();
        update agr1;
         System.Test.stopTest();  
   
               
    }
    
    static testMethod void sendtoPE(){   

 Opportunity oppAir = [Select stagename, crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Close_Behaviour__c, crm_Agreement__c, accountId from Opportunity where crm_Opp_Service_Family__c = 'Air'
   limit 1
  ];
  
  string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity'
   and name = 'Business Delivery'
   limit 1
  ].Id;
  Opportunity opp = new Opportunity();
  opp.name = 'BD Opportunity';
  opp.Accountid = oppAir.accountId ;
  opp.recordtypeId = RecordTypeId;
  opp.StageName = 'New Opportunity';
  opp.CloseDate = Date.Today().addDays(10);
  opp.crm_Opp_Service_Group__c = 'Business Delivery';
  insert opp;
  Contact c = crm_TestDataFactory.createContact();
  c.accountid = opp.accountId;
  insert c;
  opp.crm_Primary_Opportunity_Contact__c = c.id;


  opp.stagename = 'Offer Sent';
  Update opp;
  opp.stagename = 'Closed Won';
  opp.crm_reason_won__c = 'Price';
  opp.Amount = 500;
  opp.crm_Agreement_Start_Date__c = date.today();
  update Opp;
  opp.crm_Verified_by_Contract_Management__c = true;
  update opp;


  environment_settings__c env = new environment_settings__c();
  env.Name = 'AgeementMasterInterfaceSwitch';
  env.value__c = 'true';
  insert env;

  crm_get_Service_Area__c customSetting = new crm_get_Service_Area__c();
  customSetting.name = 'Business Delivery';
  customSetting.Is_New__c = true;
  insert customSetting;


  Test.startTest();

  crm_createAgreementCustomBatch batchObj = new crm_createAgreementCustomBatch(opp.id);
  Database.ExecuteBatch(batchObj);
  
 crm_Agreement__c agr1=  new crm_Agreement__c ();
 insert agr1;
 
 opp.crm_Agreement__c   =agr1.id;
 update opp;
 
   agr1= [select id, crm_Agreement_End_Date__c  , crm_status__c from crm_Agreement__c   where id =: opp.crm_Agreement__c limit 1];
  agr1.crm_Agreement_End_Date__c  = System.today();
  agr1.crm_status__c  ='Terminated';
   update agr1;
  
  Test.stoptest();
  
    }
    
}