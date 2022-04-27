@isTest

public class crm_opportunityTriggerTest{
static testMethod void testinsertopp(){
 crm_TestDataFactory.CreateCustomSetting(); 
  Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
          Test.startTest();
        partyLevelacnt.orga__c= 'NotDuplicate';
        insert  partyLevelacnt;
        
          //create Pricebook
        Pricebook2 Pb1 = crm_TestDataFactory.createPricebook();
        Pb1.Name = 'Air';
        Pb1.IsActive= true;
        insert Pb1;
        
          Opportunity oppAir = crm_TestDataFactory.createAirOpportunity();
        oppAir.accountId=partyLevelacnt.id;
        oppAir.CloseDate=date.today().addDays(20);
        oppAir.StageName='New Opportunity';
        oppAir.crm_Opp_Service_Family__c='Air';
        oppAir.crm_Close_Behaviour__c='Create';
        
         Contact c = crm_TestDataFactory.createContact();
        c.email= 'test1@test1.com';
        c.accountid=oppAir.accountId;
        insert c;
       
        OppAir.crm_Primary_Opportunity_Contact__c= c.id;       
        insert oppAir; 
        
        oppAir.stagename='Offer Sent';
        update oppAir;
        
       crm_Tender__c tenderobj1= new crm_tender__c();
        tenderobj1.name='Test1';
        tenderobj1.crm_account__c=partyLevelacnt.id;
        insert tenderobj1;
                
       
        
         oppAir.stagename ='Closed Won'   ;
        oppAir.crm_reason_won__c ='Price';
        oppAir.Amount=500;
        oppAir.crm_Close_Behaviour__c='Create';
        oppAir.crm_Agreement_Start_Date__c = date.today();
        //oppair.crm_Enriched_In_PriceEngine__c= true;
        oppAir.crm_Verified_by_Contract_Management__c=true;
        oppAir.crm_tender__c= tenderobj1.id;
     
        Update oppAir;
        Test.stopTest();
        }
        
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
    
   
    static testMethod void sendToPricingToolTest1(){
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