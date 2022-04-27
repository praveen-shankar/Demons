/* Created By: Supriya Goel
Date: Sprint 3
Test class: Test class for opportunity trigger helper
*/


@isTest

public class crm_opportunityTriggerHelperTest{
    
    @testSetup static void setup() {
        Test.startTest();
        crm_TestDataFactory.CreateCustomSetting(); 
        
        environment_settings__c  objCustomSetting = new environment_settings__c ();
        objCustomSetting.value__c='1';
        objCustomSetting.Name = 'Lead_Conversion_code';
        insert objCustomSetting ;
          
        //create party level account for agreemwet active
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt.orga__c= 'NotDuplicate';
        insert  partyLevelacnt;
        
        Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt1.parentId=partyLevelacnt.id;
        relationLevelacnt1.name= 'relationaccount';
        
        insert  relationLevelacnt1;
        
        //create account without active agreement and has revenue line 
        Account partyLevelacntforRev= crm_TestDataFactory.createPartylevelAccount();
        insert  partyLevelacntforRev;
        
        Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt.parentId=partyLevelacntforRev.id;
        insert  relationLevelacnt;
        
         Account partyLevelacntConverted= crm_TestDataFactory.createPartylevelAccount();
         partyLevelacntConverted.Customer_Converted__c ='Converted';
         partyLevelacntConverted.crm_customer_converted_date__c =System.today().addmonths(2);
         insert  partyLevelacntConverted;
        
        
        
        //create product
        Product2 prdobj = crm_TestDataFactory.createProduct();
        prdobj.crm_ERP_Product_ID__c ='123' ;
        prdobj.crm_global_Service_Area__c='Logistics';
        prdobj.crm_global_Service_Group__c ='Linehaul';
        prdobj.crm_global_Service_Family__c ='Linehaul';
        prdobj.IsActive = true;
        insert prdobj;
        
        crm_Revenue_Line__c revLineObj1=crm_TestDataFactory.createRevenueLine();
        revLineObj1.crm_Account__c = relationLevelacnt.id;
        revLineObj1.crm_Product__c= prdobj.id;
        revLineObj1.crm_Amount__c = 500;
        revLineObj1.crm_Transaction_Date__c = System.today();
        insert revLineObj1;
        
        crm_Revenue_Line__c revLineObj2=crm_TestDataFactory.createRevenueLine();
        revLineObj2.crm_Account__c = relationLevelacnt.id;
        revLineObj2.crm_Product__c= prdobj.id;
        revLineObj2.crm_Amount__c = 5000;
        revLineObj2.crm_Transaction_Date__c = System.today().addMonths(1);
        insert revLineObj2;
        
        User u = crm_TestDataFactory.createUser();
        u.crm_User_Type__c='Sales';
        insert u;
        
        //create Pricebook
        Pricebook2 Pb1 = crm_TestDataFactory.createPricebook();
        Pb1.Name = 'Air';
        Pb1.IsActive= true;
        insert Pb1;
        
        Pricebook2 Pb2 = crm_TestDataFactory.createPricebook();
        Pb2.Name = 'Linehaul';
        Pb2.IsActive= true;
        insert Pb2;  
        
        
        /*crm_Tender__c tenderobj1= new crm_tender__c();
        tenderobj1.name='Test1';
        tenderobj1.crm_account__c=partyLevelacnt.id;
        insert tenderobj1; Check22050201*/
        
        contact buyer = crm_TestDataFactory.createcontact();
        buyer.AccountId = partyLevelacnt.id;
        insert buyer;
        
        Contact c = crm_TestDataFactory.createContact();
        c.accountid=partyLevelacnt.id;
        c.email='testopp@test.com';
        insert c;
        
        
        //create cargo +air opp
       Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
        oppAir.accountId=partyLevelacnt.id;
        oppAir.CloseDate=date.today().addDays(20);
        oppAir.StageName='New Opportunity';
        oppAir.crm_Opp_Service_Family__c='Air';
        oppAir.crm_Close_Behaviour__c='Create';
        //oppAir.crm_tender__c= tenderobj1.id;Check22050201*/
        OppAir.crm_Primary_Opportunity_Contact__c= c.id;       
        insert oppAir; 
        
                
       OpportunityTeamMember otm =crm_TestDataFactory.createOpportunityTeamMember();
        otm.OpportunityId=oppAir.id;
        otm.userId=u.id;
        insert otm;
        
        //insert for sea SF
        Opportunity oppsea = crm_TestDataFactory.createSeaOpportunity();
        oppsea.accountId=partyLevelacnt.id;
        oppsea.CloseDate=date.today().addDays(20);
        oppsea.StageName='New Opportunity';
        oppsea.crm_Opp_Service_Family__c='Sea';
        //oppsea.crm_Probability__c= 80; 
        insert oppsea;
        
        
        
        //create cargo +linehaul opp  //revenure line
        Opportunity oppRevline = crm_TestDataFactory.createLinehaulOpportunity();
        oppRevline.accountId=partyLevelacntforRev.id;
        oppRevline.CloseDate=date.today().addDays(20);
        oppRevline.StageName='New Opportunity';
        oppRevline.crm_Opp_Service_Family__c='Linehaul';
        oppRevline.crm_Close_Behaviour__c='Create';
        //oppRevline.crm_Probability__c= 80; 
        //oppRevline.crm_tender__c= tenderobj1.id;Check22050201*/
        insert oppRevline;
        
        System.debug('##oppRevline'+ oppRevline);
        Test.stoptest();   
    }
    
  static testMethod void testEdiTaskcreation(){
        Test.startTest();
        Opportunity oppAir=[Select stagename ,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c,crm_Close_Behaviour__c, crm_Agreement__c, accountId  from Opportunity  where crm_Opp_Service_Family__c='Air' limit 1]  ;
        
        Contact c = crm_TestDataFactory.createContact();
        c.email= 'test1@test1.com';
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
        //active agreement with service family air    
        //insert opptem member
        
        crm_Tender__c tenderobj1= new crm_tender__c();
        tenderobj1.name='Test';
        tenderobj1.crm_account__c=oppAir.accountId;
        insert tenderobj1;
        
        crm_Tender__c tenderobj2= new crm_tender__c();
        tenderobj2.name='Test';
        tenderobj2.crm_account__c=oppAir.accountId;
        insert tenderobj2;
        
        
        oppAir.stagename ='Closed Won'   ;
        oppAir.crm_reason_won__c ='Price';
        oppAir.Amount=500;
        oppAir.crm_Close_Behaviour__c='Create';
        oppAir.crm_Agreement_Start_Date__c = date.today();
        oppAir.crm_tender__c= tenderobj1.id;
        Update oppAir;
        
        oppAir.crm_tender__c= tenderobj2.id;
        Update oppAir;
        
       // oppAir.crm_tender__c= null;
        Update oppAir;
        Test.stopTest();
        
    }
    
    
    
    /*static testMethod void testcrossfamily(){
        
       
        Opportunity oppSea=[Select stagename ,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountId  from Opportunity  where crm_Opp_Service_Family__c='Sea' limit 1]  ;
        
        Contact c = crm_TestDataFactory.createContact();
        c.email= 'test2@test2.com';
        c.accountid=oppSea.accountId;
        insert c;
        
        Contact c1= crm_TestDataFactory.createContact();
        c1.email= 'test3@test3.com';
        c1.accountid=oppSea.accountId;
        insert c1;
        
        Contact c2= crm_TestDataFactory.createContact();
        c2.email= 'test4@test4.com';
        c2.accountid=oppSea.accountId;
        insert c2;
        
        oppSea.crm_Primary_Opportunity_Contact__c = c1.id;
        update oppSea;
        
        oppSea.crm_Primary_Opportunity_Contact__c = c2.id;
        update oppSea;
              
        OpportunityContactRole opprconrole= new OpportunityContactRole();
        opprconrole.ContactId= c.id;
        opprconrole.IsPrimary=true;
        opprconrole.OpportunityId= oppSea.id;
        insert opprconrole;
        
        
        //active agreement with service family air    
        oppSea.stagename ='Offer Sent'   ;
        Update oppSea;   
        
        
        oppSea.stagename ='Closed Won'   ;
        oppSea.crm_reason_won__c ='Price';
        oppSea.Amount=500;
      // oppSea.crm_Close_Behaviour__c='Create';
        oppSea.crm_Agreement_Start_Date__c = date.today();
        Update oppSea;
        
          crm_createAgreementBatch batchObj=new crm_createAgreementBatch('test');
        Database.ExecuteBatch(batchObj);
         
        Opportunity oppSea2 = crm_TestDataFactory.createSeaOpportunity();
        oppSea2.accountId=oppSea.accountId;
        oppSea2.CloseDate=date.today().addDays(10);
        oppSea2.StageName='New Opportunity';
        oppSea2.crm_Opp_Service_Family__c='Sea';
        oppSea2.crm_Agreement_Start_Date__c = date.today();
        oppSea2.Amount=5000;
        //oppSea2.crm_Probability__c= 80; 
        insert oppSea2;
        
       
        
        Test.startTest();
        OpportunityContactRole opprconrole1= new OpportunityContactRole();
        opprconrole1.ContactId= c.id;
        opprconrole1.IsPrimary=true;
        opprconrole1.OpportunityId= oppSea2.id;
        insert opprconrole1;
        
        //active agreement with service family air    
        oppSea2.stagename ='Offer Sent'   ;
        Update oppSea2;    
        
        oppSea2.stagename ='Closed Won'   ;
        oppSea2.crm_reason_won__c ='Price';
        oppSea2.crm_private__c=true;
        oppSea2.Amount=500;
        oppSea2.crm_Agreement_End_Date__c = date.today().adddays(30);
        update oppSea2;  
        
         environment_settings__c env = new environment_settings__c();
          env.Name = 'AgeementMasterInterfaceSwitch';
          env.value__c = 'false';
          insert env;
        
          crm_get_Service_Area__c customSetting = new crm_get_Service_Area__c();
          customSetting.name = 'Sea';
          customSetting.Is_New__c = false;
          insert customSetting;
 
        batchObj=new crm_createAgreementBatch('test');
        Database.ExecuteBatch(batchObj);
             
        Test.stopTest(); 
        
    }*/
    
    static testMethod void testrevCrossFamilyoppType(){
        Test.startTest();
        //revenue line checks
        Opportunity oppRevline=[Select stagename ,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountId  from Opportunity  where crm_Opp_Service_Family__c='Linehaul' limit 1]  ;
        
        //active agreement with service family air    
        Opportunity  opp1= crm_TestDataFactory.createCargoOpportunity();
        opp1.accountId=oppRevline.accountId;
        opp1.CloseDate=date.today().addmonths(2);
        opp1.StageName='New Opportunity';
        opp1.crm_Opp_Service_Family__c='Cargo Domestic';
        opp1.Amount=600;
        //opp1.crm_Probability__c= 80; 
        insert opp1;
        
        crm_Tender__c tenderobj1= new crm_tender__c();
        tenderobj1.name='Test';
        tenderobj1.crm_account__c=opp1.accountId;
        insert tenderobj1;
                       
        delete opp1;
        Test.stopTest();      
    }  
    
    static testMethod void testrevCrossGroupoppType(){
        Test.startTest();
        crm_get_Service_Area__c serviceArea1 = new crm_get_Service_Area__c ();
        serviceArea1.name= 'Cargo';
        serviceArea1.crm_Service_Area__c = 'Logistics';
        insert serviceArea1;
        System.assertNotEquals(null , serviceArea1 );
        
        crm_get_Service_Area__c serviceArea2= new crm_get_Service_Area__c ();
        serviceArea2.name= 'Warehousing';
        serviceArea2.crm_Service_Area__c = 'Logistics';
        insert serviceArea2;
        System.assertNotEquals(null , serviceArea2);   
        
        //revenue line checks
        Opportunity oppRevline=[Select stagename ,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountId  from Opportunity  where crm_Opp_Service_Family__c='Linehaul' limit 1]  ; 
        
        //set the type to cross family    
        Opportunity oppwarehousingRevline=crm_TestDataFactory.createWarehousingOpportunity();
        oppwarehousingRevline.Accountid=oppRevline.accountId;
        oppwarehousingRevline.CloseDate=date.today().addmonths(2);
        oppwarehousingRevline.StageName='New Opportunity';
        oppwarehousingRevline.crm_Opp_Service_Family__c='Transport';
        oppwarehousingRevline.Amount=5000;
        //oppwarehousingRevline.crm_Probability__c= 80; 
        insert oppwarehousingRevline;    
        //set to cros group
        Test.stopTest();
    }
    
     static testMethod void testRenegotiateOpp(){
         Test.startTest();
         opportunity  Opp =[Select accountId  from Opportunity  where crm_Opp_Service_Family__c='Sea' limit 1]; 
         Contact c = crm_TestDataFactory.createContact();
         c.email= 'test5@test5.com';
         c.accountid=Opp.accountId;
         insert c;  
         
          OpportunityContactRole opprconrole= new OpportunityContactRole();
        opprconrole.ContactId= c.id;
        opprconrole.IsPrimary=true;
        opprconrole.OpportunityId= Opp.id;
        insert opprconrole;
      
        Opp.stagename ='Offer Sent'   ;
        Opp.crm_private__c=true;
        Update Opp;  
         
        /*Opportunity oppSea2 = crm_TestDataFactory.createSeaOpportunity();
        oppSea2.accountId=Opp.accountId;
        oppSea2.CloseDate=date.today().addDays(10);
        oppSea2.StageName='New Opportunity';
        oppSea2.crm_Opp_Service_Family__c='Sea';
        oppSea2.crm_Agreement_Start_Date__c = date.today();
        oppSea2.Amount=5000;
        //oppSea2.crm_Probability__c= 80; 
        insert oppSea2;*/
         
        
       
        
        //active agreement with service family air    
        
        Opp.stagename ='Closed Won'   ;
        Opp.crm_reason_won__c ='Price';
        Opp.Amount=500;
        Opp.crm_Agreement_Start_Date__c = date.today();
        update Opp;   
        Test.stopTest();
     
     }
   
    
      static testMethod void testPerformClosedLost(){
        opportunity  Opp =[Select accountId  from Opportunity  where crm_Opp_Service_Family__c='Air' limit 1];     
        
        Opportunity oppCn = crm_TestDataFactory.createOffshoreOpportunity();
        oppCn.accountId=Opp.accountId; 
        oppCn.CloseDate=date.today();
        oppCn.StageName='New Opportunity';
        oppCn.crm_Opp_Service_Family__c='Offshore';
        oppCn.crm_Close_Behaviour__c='Create';
        //oppCn.crm_Probability__c= 80; 
        insert oppCn;
        
        Contact c = crm_TestDataFactory.createContact();
        c.email= 'test6@test6.com';
        c.accountid=oppCn.accountId;
        insert c;   
        
        OpportunityContactRole opprconrole= new OpportunityContactRole();
        opprconrole.ContactId= c.id;
        opprconrole.IsPrimary=true;
        opprconrole.OpportunityId= oppCn.id;
        insert opprconrole;
        
        //active agreement with service family air    
        oppCn.stagename ='Offer Sent'   ;
        oppCn.crm_private__c=true;
        Update oppCn;  
        
        oppCn.stagename ='Closed Won'   ;
        oppCn.crm_reason_won__c ='Price';
        oppCn.Amount=500;
        oppCn.crm_Agreement_Start_Date__c = date.today();
        update oppCn;   
        // Opportunity oppagr =[Select crm_agreement__c from opportunity where crm_agreement__c = :oppCn.id ] ; 
        
        Opportunity oppagr = [Select stagename ,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, accountId  from Opportunity where id=:oppCn.id];  
        
        Opportunity opp1=crm_TestDataFactory.createCargoOpportunity();
        opp1.Accountid=Opp.accountId;
        opp1.CloseDate=date.today().addDays(20);
        opp1.StageName='New Opportunity';
        opp1.crm_Opp_Service_Family__c='Cargo Domestic';
        opp1.crm_Close_Behaviour__c='Upsell';
        opp1.Type='Upsell';
        //opp1.crm_Probability__c= 80; 
        insert opp1;  
                
        OpportunityContactRole opprconrole1= new OpportunityContactRole();
        opprconrole1.ContactId= c.id;
        opprconrole1.IsPrimary=true;
        opprconrole1.OpportunityId= opp1.id;
        insert opprconrole1;
        
        Test.startTest();   
        opp1.stagename ='Closed Won'   ;
        opp1.crm_reason_won__c ='Price';
        opp1.Amount=500;
        opp1.crm_Agreement_Start_Date__c = date.today();
        update opp1; 
        
        
        opp1.stagename ='Closed Lost'   ;
        opp1.crm_reason_lost__c ='Price';
        opp1.crm_Agreement__c = oppagr.crm_Agreement__c;   
        update opp1; 
        Test.stopTest();
        
    } 
    
    static testMethod void testsetPartyacntonopp(){
        Test.startTest();
        environment_settings__c env= new environment_settings__c();
        env.name='Lead_Conversion_code';
        env.value__c ='1';
        insert env;
        
        opportunity  Opp =[Select accountId  from Opportunity  where crm_Opp_Service_Family__c='Air' limit 1];     
        
        Opportunity oppCn = crm_TestDataFactory.createConvertedfromLeadOpportunity();
        oppCn.accountId=Opp.accountId; 
        insert oppCn;  
        
        string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and name like '%Citymail%' limit 1].Id;  
       
        crm_TestDataFactory.CreateCustomSetting();   
        
        
        oppCn.recordtypeid = RecordTypeId;
        update  oppCn;  
      
        Test.stopTest();
      
    }
    
    static testMethod void testsetAgrblank(){
        Test.startTest();
        opportunity  Opp =[Select accountId  from Opportunity  where crm_Opp_Service_Family__c='Air' limit 1];    
        
        Opp.stagename ='Offer Sent'   ;
        Opp.crm_private__c=true;
        Update Opp; 
        
        list<Opportunity>  opplist = new List<Opportunity>();
        opplist.add(Opp);
        
        crm_opportunityTriggerHelper.setAgrblank(oppList);
        crm_opportunityTriggerHelper.setAgrDate(oppList);
      
        Test.stopTest();
    }
    
    static testmethod void testrenegotiateclosedlost(){
     Test.startTest();
     opportunity  Opp =[Select accountId  from Opportunity  where crm_Opp_Service_Family__c='Air' limit 1];    
     
        crm_Agreement__c agrobj1 = crm_TestDataFactory.createAgreement();
        agrobj1.crm_Account__c =opp.accountId ;
        agrobj1.crm_Agreement_Start_Date__c = System.today().adddays(10);
        agrobj1.crm_Agreement_End_Date__c = System.today().adddays(20);
        agrobj1.crm_Status__c ='Draft';
        insert agrobj1;  
        
        Opportunity oppCn = crm_TestDataFactory.createOffshoreOpportunity();
        oppCn.accountId=Opp.accountId; 
        oppCn.CloseDate=date.today();
        oppCn.StageName='New Opportunity';
        oppCn.crm_Opp_Service_Family__c='Offshore';
        oppCn.crm_Close_Behaviour__c='Create';
        oppCn.type='New';
        insert oppCn;
        
        Contact c = crm_TestDataFactory.createContact();
        c.email= 'test7@test7.com';
        c.accountid=oppCn.accountId;
        insert c; 
        
        OpportunityContactRole opprconrole1= new OpportunityContactRole();
        opprconrole1.ContactId= c.id;
        opprconrole1.IsPrimary=true;
        opprconrole1.OpportunityId= oppCn.id;
        insert opprconrole1;
        
           
        oppCn.stagename ='Closed Won'   ;
        oppCn.crm_reason_won__c ='Price';
        oppCn.Amount=500;
        oppCn.crm_Agreement_Start_Date__c = date.today();
        update oppCn; 
        
        oppCn.crm_Agreement__c= agrobj1.id;
        update oppCn;
        
        Opportunity oppCn1 = crm_TestDataFactory.createOffshoreOpportunity();
        oppCn1.accountId=Opp.accountId; 
        oppCn1.CloseDate=date.today();
        oppCn1.StageName='New Opportunity';
        oppCn1.crm_Opp_Service_Family__c='Offshore';
        oppCn1.crm_Close_Behaviour__c='Renegotiate';
        oppCn1.type='Renegotiate';
        oppCn1.crm_Primary_Opportunity_Contact__c = c.id;
        insert oppCn1;
        
        oppCn1.stagename ='Closed Lost'   ;
        oppCn1.crm_reason_lost__c ='Price';
        oppCn1.crm_Agreement_Start_Date__c= system.today().adddays(20);
        update oppCn1; 
        
         list<Opportunity>  opplist = new List<Opportunity>();
        opplist.add(oppCn1);
        
        crm_opportunityTriggerHelper.checksamedatesonopp(oppList);
        Test.stopTest();
    
    
    }
    
    static testmethod void testcreateoppcontactrole(){
     Test.startTest();
     opportunity  Opp =[Select accountId  from Opportunity  where crm_Opp_Service_Family__c='Air' limit 1]; 
    Opportunity oppCn = crm_TestDataFactory.createOffshoreOpportunity();
        oppCn.accountId=Opp.accountId; 
        oppCn.CloseDate=date.today();
        oppCn.StageName='New Opportunity';
        oppCn.crm_Opp_Service_Family__c='Offshore';
        oppCn.crm_Close_Behaviour__c='Create';
        oppCn.type='New';
        insert oppCn;
        
        Contact c = crm_TestDataFactory.createContact();
        c.email= 'test8@test8.com';
        c.accountid=oppCn.accountId;
        insert c;  
        
        Contact c1 = crm_TestDataFactory.createContact();
        c1.email= 'test9@test.com';
        c1.accountid=oppCn.accountId;
        insert c1; 
        
        oppCn.crm_Primary_Opportunity_Contact__c = c.id;
        update oppCn;
        
        oppCn.crm_Primary_Opportunity_Contact__c = c1.id;
        update oppCn;
        Test.stopTest();   
        
    }
    
    static testmethod void testconvertedopptype(){
    Test.startTest();
    Account acnt= [Select id  from Account where Customer_Converted__c='Converted' limit 1];
    Opportunity oppCn = crm_TestDataFactory.createOffshoreOpportunity();
    
    crm_get_Service_Area__c customSetting = new crm_get_Service_Area__c();
  customSetting.name = 'Offshore';
  customSetting.Is_New__c = true;
  insert customSetting;
  
        oppCn.accountId=acnt.id; 
        oppCn.CloseDate=date.today();
        oppCn.StageName='New Opportunity';
        oppCn.crm_Opp_Service_Family__c='Offshore';
        oppCn.crm_Close_Behaviour__c='Create';
        oppCn.type='New';
        insert oppCn;
    Test.stopTest();
    }
    
    static testmethod void testselectedcustomer(){
    Test.startTest();
    Account acnt= [Select id  from Account where Customer_Converted__c='Converted' limit 1];
    RecordType opprt = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Business_Delivery'];
    
      environment_settings__c env = new environment_settings__c();
  env.Name = 'OppValidationConvertedCustomer';
  env.value__c = 'true';
  insert env;
  
  
    
     opportunity  Opp =[Select accountId  from Opportunity  where crm_Opp_Service_Family__c='Air' limit 1]; 
    
        Opportunity oppnew = new Opportunity(Name='Opportunity Test',StageName='New Opportunity',crm_Opp_Service_Family__c='Business Parcel',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=Opp.accountid,CurrencyIsoCode='NOK',RecordtypeId=opprt.Id,CloseDate=Date.today()+5);
                                          insert oppnew;
       Test.stopTest();
    
    }
    
     static testmethod void testcalloutstatus(){
      Test.startTest();
       Opportunity oppAir=[Select id, stagename ,crm_Opp_Service_Group__c,crm_reason_won__c, Amount, crm_Agreement_Start_Date__c, crm_Agreement__c, Send_Shell_Agreement__c, accountid  from Opportunity  where crm_Opp_Service_Family__c='Air' limit 1]  ;

       Contact c1 = crm_TestDataFactory.createContact();
        c1.email= 'test10@test.com';
        c1.accountid=oppAir.accountId;
        insert c1; 
        
        oppAir.crm_Primary_Opportunity_Contact__c=c1.id;
        update oppAir; 
        
    
     environment_settings__c env = new environment_settings__c();
     env.Name = 'AgeementMasterInterfaceSwitch';
     env.value__c = 'true';
     insert env;
        oppAir.crm_Primary_Opportunity_Contact__c=c1.id;
        oppAir.stagename ='Closed Won'   ;
        oppAir.crm_reason_won__c ='Price';
        oppAir.Amount=500;
        oppAir.crm_Agreement_Start_Date__c = date.today();
        Update oppAir;  
        
        oppAir.crm_Verified_by_Contract_Management__c= true;
        //oppAir.crm_Enriched_In_PriceEngine__c = true;
        oppAir.Send_Shell_Agreement__c =true;
        update oppAir; 
        
        crm_Agreement__c agr = New crm_Agreement__c();
        insert agr; 
        
        oppAir.crm_Agreement__c = agr.Id;
        oppAir.Send_Shell_Agreement__c =false;
        oppAir.description='test';
        update oppAir;   
       
     Test.stopTest();
     
     }
   /* static testmethod void testverifiedcheckbox(){
    
     environment_settings__c env = new environment_settings__c();
  env.Name = 'AgeementMasterInterfaceSwitch';
  env.value__c = 'true';
  insert env;
  
    
    Profile P = [Select id from Profile where name='Guest-CRM Sales user' limit 1];
    
    User batchUser= new User();
        batchUser.lastname='test1_datamigration';
        batchUser.profileid=p.id;
        batchUser.Email = 'batchUser@test.com';
        batchUser.Username = 'batchUser_test@test.com';
        batchUser.CompanyName = 'TEST';
        batchUser.Title = 'title';
        batchUser.Alias = 'alias';
        batchUser.TimeZoneSidKey = 'America/Los_Angeles';
        batchUser.EmailEncodingKey = 'UTF-8';
        batchUser.LanguageLocaleKey = 'en_US';
        batchUser.LocaleSidKey = 'en_US';
        insert batchUser;
        
          Account acnt= [Select Id  from Account where Customer_Converted__c='Converted' limit 1];
          System.RunAs(batchuser) { 
         Opportunity oppCn = crm_TestDataFactory.createOffshoreOpportunity();
        oppCn.accountId=acnt.Id; 
        oppCn.CloseDate=date.today();
        oppCn.StageName='New Opportunity';
        oppCn.crm_Opp_Service_Family__c='Offshore';
        oppCn.crm_Close_Behaviour__c='Create';
        oppCn.type='New';
        insert oppCn;
        
         oppCn.crm_Verified_by_Contract_Management__c= true;
        // oppCn.crm_Enriched_In_PriceEngine__c = true;
         update oppCn;
    
      }   
    
    
   }  */
    
    @isTest
    static void sendToPricingToolTest(){
        String partyRecTypeId = [Select Id From recordType Where sObjectType='Account' AND developerName='crm_Party_level_Customer'].Id;
        String BusinessDeliveryRecTypeId = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Business_Delivery'].Id;
        String ParcelsRecTypeId = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Parcels_Opportunity'].Id;
        
        environment_Settings__c env = New environment_Settings__c(Name ='PricingToolInterfaceSwitch', Value__c='true');
        insert env;
        
        List<SPPIntegrationDetails__c> insertSPPIntegrationDetails = New List<SPPIntegrationDetails__c>();
        SPPIntegrationDetails__c integrationDetails_1 = New SPPIntegrationDetails__c(Name='PricingTool_EndpointUrl', Value__c='https://qa.bring.services/digital-pricing/customerOpportunity');
        SPPIntegrationDetails__c integrationDetails_2 = New SPPIntegrationDetails__c(Name='SPP_CustomerFetch_ClientSecret', Value__c='q3t6w8z$C&F)O@NcRfTjW3Zr4u7x!A%S*G-KaPdSgUkh40O5v7y/B?E(G+MbQeTh');
        insertSPPIntegrationDetails.add(integrationDetails_1); insertSPPIntegrationDetails.add(integrationDetails_2);
        insert insertSPPIntegrationDetails;
        
        Account a = New Account();
        a.Name = 'Test Party Customer';
        a.Orga__c = '123456';
        a.shippingCountry = 'Norway';
        a.recordTypeId = partyRecTypeId;
        insert a;
        
        Opportunity opp = new Opportunity(Name='Test Opportunity 1',StageName='New Opportunity',crm_Opp_Service_Family__c='Business Parcel',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=a.Id,CurrencyIsoCode='NOK',RecordtypeId=BusinessDeliveryRecTypeId, send_To_Pricing_Tool__c=true, CloseDate=Date.today()+5);
        insert opp;
        
        Test.StartTest();
        opp.Amount = 10000;
        update opp;
        
        opp.Send_to_Pricing_Tool__c = false;
        update opp;
        
        opp.Send_to_Pricing_Tool__c = true;
        opp.Amount = 100;
        update opp;
        Test.StopTest();
    }
    
   
   @isTest
    static void sendToPricingToolTest1(){
        String partyRecTypeId = [Select Id From recordType Where sObjectType='Account' AND developerName='crm_Party_level_Customer'].Id;
        String BusinessDeliveryRecTypeId = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Business_Delivery'].Id;
        String ParcelsRecTypeId = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Parcels_Opportunity'].Id;
        
        environment_Settings__c env = New environment_Settings__c(Name ='PricingToolInterfaceSwitch', Value__c='true');
        insert env;
        
        List<SPPIntegrationDetails__c> insertSPPIntegrationDetails = New List<SPPIntegrationDetails__c>();
        SPPIntegrationDetails__c integrationDetails_1 = New SPPIntegrationDetails__c(Name='PricingTool_EndpointUrl', Value__c='https://qa.bring.services/digital-pricing/customerOpportunity');
        SPPIntegrationDetails__c integrationDetails_2 = New SPPIntegrationDetails__c(Name='SPP_CustomerFetch_ClientSecret', Value__c='q3t6w8z$C&F)O@NcRfTjW3Zr4u7x!A%S*G-KaPdSgUkh40O5v7y/B?E(G+MbQeTh');
        insertSPPIntegrationDetails.add(integrationDetails_1); insertSPPIntegrationDetails.add(integrationDetails_2);
        insert insertSPPIntegrationDetails;
        
        Update insertSPPIntegrationDetails;
        
        Account a = New Account();
        a.Name = 'Test Party Customer';
        a.Orga__c = '123456';
        a.shippingCountry = 'Norway';
        a.recordTypeId = partyRecTypeId;
        insert a;
        
        Opportunity opp = new Opportunity(Name='Test Opportunity 1',StageName='New Opportunity',crm_Opp_Service_Family__c='Business Parcel',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=a.Id,CurrencyIsoCode='NOK',RecordtypeId=BusinessDeliveryRecTypeId, send_To_Pricing_Tool__c=true, CloseDate=Date.today()+5);
        insert opp;
        
        Test.StartTest();
        opp.Amount = 10000;
        update opp;
        
        opp.Send_to_Pricing_Tool__c = false;
        update opp;
        
        opp.Send_to_Pricing_Tool__c = true;
        opp.Amount = 100;
        update opp;
        Test.StopTest();
    }
    
    
    
}