@isTest
public class crm_OppToPricingToolIntegration_Test {
	
    @isTest
    static void customerFetchTest(){
        String partyRecTypeId = [Select Id From recordType Where sObjectType='Account' AND developerName='crm_Party_level_Customer'].Id;
        String oppRecTypeId = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Business_Delivery'].Id;
        
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
        
        Opportunity opp = new Opportunity(Name='Opportunity Test',StageName='New Opportunity',crm_Opp_Service_Family__c='Business Parcel',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=a.Id,CurrencyIsoCode='NOK',RecordtypeId=oppRecTypeId, send_To_Pricing_Tool__c=true, CloseDate=Date.today()+5);
        insert opp;
        
        List<String> oppIds = New List<String>();
        oppIds.add(opp.Id);
        List<Opportunity> opportunityList = New List<Opportunity>();
        opportunityList.add(opp);
        
        Test.setMock(HttpCalloutMock.class, new crm_convertCustomerIntegration_mock());
        system.enqueueJob(new crm_OppToPricingToolIntegration(oppIds, 'Create', opportunityList));
        
    }
}