/* Created By: Supriya Goel
Date: 9th jan 2018
Test class: Test class for createAgreementBatch
*/


@isTest

public class crm_createAgreementCustomBatchTest{

 @testSetup static void setup() {

  crm_TestDataFactory.CreateCustomSetting();
  //create party level account for agreemwet active
  Account partyLevelacnt = crm_TestDataFactory.createPartylevelAccount();
  partyLevelacnt.orga__c = 'NotDuplicate';
  partyLevelacnt.name = 'TestParty';
  insert partyLevelacnt;

  Account relationLevelacnt = crm_TestDataFactory.createRelationlevelAccount();
  relationLevelacnt.parentId = partyLevelacnt.id;
  insert relationLevelacnt;

  //create product
  Product2 prdobj = crm_TestDataFactory.createProduct();
  prdobj.crm_ERP_Product_ID__c = '123';
  prdobj.crm_global_Service_Area__c = 'Logistics';
  prdobj.crm_global_Service_Group__c = 'Linehaul';
  prdobj.crm_global_Service_Family__c = 'Linehaul';
  prdobj.IsActive = true;
  insert prdobj;

  Product2 prdobj1 = crm_TestDataFactory.createProduct();
  prdobj1.crm_ERP_Product_ID__c = '123Air';
  prdobj1.crm_global_Service_Area__c = 'Logistics';
  prdobj1.crm_global_Service_Group__c = 'Air';
  prdobj1.crm_global_Service_Family__c = 'Air';
  prdobj1.IsActive = true;
  insert prdobj1;

  //create cargo +air opp
  Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
  oppAir.accountId = partyLevelacnt.id;
  oppAir.CloseDate = date.today().addDays(20);
  oppAir.StageName = 'New Opportunity';
  oppAir.crm_Opp_Service_Family__c = 'Air';
  oppAir.crm_Close_Behaviour__c = 'Create';
  insert oppAir;


  crm_Revenue_Line__c revLineObj1 = crm_TestDataFactory.createRevenueLine();
  revLineObj1.crm_Account__c = relationLevelacnt.id;
  revLineObj1.crm_Product__c = prdobj.id;
  revLineObj1.crm_Amount__c = 500000;
  revLineObj1.crm_Transaction_Date__c = System.today().adddays(-100);
  insert revLineObj1;

  crm_Revenue_Line__c revLineObj2 = crm_TestDataFactory.createRevenueLine();
  revLineObj2.crm_Account__c = relationLevelacnt.id;
  revLineObj2.crm_Product__c = prdobj1.id;
  revLineObj2.crm_Amount__c = 500000;
  revLineObj2.crm_Transaction_Date__c = System.today().adddays(-100);
  insert revLineObj2;

 }

 static testMethod void createagreementold_services() {
  Opportunity oppAir = [Select stagename, crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Close_Behaviour__c, crm_Agreement__c, accountId from Opportunity where crm_Opp_Service_Family__c = 'Air'
   limit 1
  ];

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

  environment_settings__c env = new environment_settings__c();
  env.Name = 'AgeementMasterInterfaceSwitch';
  env.value__c = 'false';
  insert env;

  crm_get_Service_Area__c customSetting = new crm_get_Service_Area__c();
  customSetting.name = 'Air';
  customSetting.Is_New__c = false;
  insert customSetting;
  Test.startTest();

  crm_createAgreementCustomBatch batchObj = new crm_createAgreementCustomBatch(oppAir.id);
  Database.ExecuteBatch(batchObj);
  
  Opportunity oppAir1 = [Select stagename, crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Close_Behaviour__c, crm_Agreement__c, accountId from Opportunity where crm_Opp_Service_Family__c = 'Air'
   limit 1
  ];

  oppAir1.crm_Primary_Opportunity_Contact__c = c.id;

  oppAir1.stagename = 'Closed Won';
  oppAir1.crm_reason_won__c = 'Price';
  oppAir1.Amount = 500;
  oppAir1.crm_Agreement_Start_Date__c = system.today();
  update OppAir1;
  
  batchObj = new crm_createAgreementCustomBatch(oppAir1.id);
  Database.ExecuteBatch(batchObj);
  Test.stoptest();

 }

 static testMethod void createagreementnew_services() {

  Account party = [Select id from account where Name = 'TestParty'
   limit 1
  ];

  string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity'
   and name = 'Business Delivery'
   limit 1
  ].Id;
  Opportunity opp = new Opportunity();
  opp.name = 'BD Opportunity';
  opp.Accountid = party.Id;
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
  Test.stoptest();

 }

 static testMethod void upselltest() {

  Opportunity oppAir = [Select stagename, crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Close_Behaviour__c, crm_Agreement__c, accountId from Opportunity where crm_Opp_Service_Family__c = 'Air'
   limit 1
  ];

  Contact c = crm_TestDataFactory.createContact();
  c.accountid = oppAir.accountId;
  insert c;

  oppAir.crm_Primary_Opportunity_Contact__c = c.id;
  update oppAir;

  oppAir.stagename = 'Closed Won';
  oppAir.crm_reason_won__c = 'Price';
  oppAir.Amount = 500;
  oppAir.crm_Close_Behaviour__c = 'Upsell';
  oppAir.type='Upsell';
  oppAir.crm_Agreement_Start_Date__c = date.today();
  update OppAir;

  environment_settings__c env = new environment_settings__c();
  env.Name = 'AgeementMasterInterfaceSwitch';
  env.value__c = 'false';
  insert env;

  crm_get_Service_Area__c customSetting = new crm_get_Service_Area__c();
  customSetting.name = 'Air';
  customSetting.Is_New__c = false;
  insert customSetting;

  Test.startTest();

  crm_createAgreementCustomBatch batchObj = new crm_createAgreementCustomBatch(oppAir.id);
  Database.ExecuteBatch(batchObj);
 
  //Opportunity  oppagr=[Select id,  crm_agreement__c , type from opportunity where id =:OppAir.id limit 1]  ;
  // system.debug('###oppAir'+ OppAir);

 /* crm_Agreement__c agr = [Select id from crm_Agreement__c where crm_Agreement_Service_Family__c = 'Air'
   limit 1
  ];
  system.debug('###agr' + agr);

  ApexPages.StandardController sc = new ApexPages.standardController(agr);
  crm_opportunityProcessOpp opp = new crm_opportunityProcessOpp(sc);
  opp.createAddonOpportunity();

  Opportunity oppUpsell = [Select id, crm_Agreement__c, type from Opportunity where crm_Opp_Service_Family__c = 'Air'
   and type = 'Upsell'
   limit 1
  ];
  system.debug('###oppUpsell' + oppUpsell);

  oppUpsell.stagename = 'Offer Sent';
  Update oppUpsell;

  oppUpsell.stagename = 'Closed Won';
  oppUpsell.crm_reason_won__c = 'Price';
  oppUpsell.Amount = 500;
  oppUpsell.crm_Agreement_Start_Date__c = date.today();
  update oppUpsell;

  batchObj = new crm_createAgreementBatch('test');
  Database.ExecuteBatch(batchObj);*/
  Test.stoptest();
 }

 static testMethod void Renegotiatetest() {
  //crm_Close_Behaviour__c=='Renegotiate' && type=='Renegotiate' 

  Opportunity oppAir = [Select id, crm_Agreement__c, stagename, accountId, crm_reason_won__c, crm_Agreement_Start_Date__c from Opportunity where crm_Opp_Service_Family__c = 'Air'
   order by lastmodifieddate desc limit 1
  ];
  Contact c = crm_TestDataFactory.createContact();
  c.accountid = oppAir.accountId;
  insert c;
  oppAir.crm_Primary_Opportunity_Contact__c = c.id;
  update oppAir;

  oppAir.stagename = 'Closed Won';
  oppAir.crm_reason_won__c = 'Price';
  oppAir.Amount = 500;
  oppAir.crm_Close_Behaviour__c = 'Renegotiate';
  oppAir.type='Renegotiate';
  oppAir.crm_Agreement_Start_Date__c = date.today();
  update OppAir;
  
  environment_settings__c env = new environment_settings__c();
  env.Name = 'AgeementMasterInterfaceSwitch';
  env.value__c = 'false';
  insert env;

  crm_get_Service_Area__c customSetting = new crm_get_Service_Area__c();
  customSetting.name = 'Air';
  customSetting.Is_New__c = false;
  insert customSetting;
  Test.startTest();
 crm_createAgreementCustomBatch batchObj = new crm_createAgreementCustomBatch(oppAir.id);
  Database.ExecuteBatch(batchObj);
  
  Test.stoptest();

 }


 static testMethod void RenegotiateNewtest() {

  Opportunity oppAir = [Select id, crm_Agreement__c, stagename, accountId, crm_reason_won__c, crm_Agreement_Start_Date__c from Opportunity where crm_Opp_Service_Family__c = 'Air'
   order by lastmodifieddate desc limit 1
  ];
  
    Opportunity oppRevline = crm_TestDataFactory.createLinehaulOpportunity();
        oppRevline.accountId=oppAir.Accountid;
        oppRevline.CloseDate=date.today().addDays(20);
        oppRevline.StageName='New Opportunity';
        oppRevline.crm_Opp_Service_Family__c='Linehaul';
        oppRevline.crm_Close_Behaviour__c='Renegotiate';
      
        insert oppRevline;
  
   Contact c = crm_TestDataFactory.createContact();
  c.accountid = oppRevline.accountId;
  insert c;
  
  oppRevline.crm_Primary_Opportunity_Contact__c = c.id;
  update oppRevline;
  oppRevline.stagename = 'Offer Sent';
  Update oppRevline;
  
  
  Opportunity oppRevline1 = crm_TestDataFactory.createLinehaulOpportunity();
  oppRevline1.accountId = oppAir.accountid;
  oppRevline1.CloseDate = date.today().addDays(20);
  oppRevline1.StageName = 'New Opportunity';
  oppRevline1.crm_Opp_Service_Family__c = 'Linehaul';
  oppRevline1.crm_Close_Behaviour__c = 'Renegotiate';
  //oppRevline.crm_Probability__c= 80; 
  insert oppRevline1;

   oppRevline1 = [Select stagename, type, crm_Close_Behaviour__c, crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountId from Opportunity where crm_Opp_Service_Family__c = 'Air'
   limit 1
  ];
  System.debug('## in reno' + oppRevline1);


 
  oppRevline1.crm_Primary_Opportunity_Contact__c = c.id;
  update oppRevline1;
  oppRevline1.stagename = 'Offer Sent';
  Update oppRevline1;
  //active agreement with service family air    
  //insert opptem member


  oppRevline1.stagename = 'Closed Won';
  oppRevline1.crm_reason_won__c = 'Price';
  oppRevline1.Amount = 500;
  oppRevline1.crm_Close_Behaviour__c = 'Create';
  oppRevline1.crm_Agreement_Start_Date__c = date.today();

  update oppRevline1;
  System.debug('## in reno' + oppRevline);

  environment_settings__c env = new environment_settings__c();
  env.Name = 'AgeementMasterInterfaceSwitch';
  env.value__c = 'false';
  insert env;

  crm_get_Service_Area__c customSetting = new crm_get_Service_Area__c();
  customSetting.name = 'Air';
  customSetting.Is_New__c = false;
  insert customSetting;
  Test.startTest();

  crm_createAgreementCustomBatch batchObj = new crm_createAgreementCustomBatch(oppRevline1.id);
  Database.ExecuteBatch(batchObj);

  Test.stoptest();



 }

}