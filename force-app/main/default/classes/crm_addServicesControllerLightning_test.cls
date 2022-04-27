@IsTest
private class crm_addServicesControllerLightning_test{
    
    @IsTest static void testAddServices() {
        Test.startTest();
        User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'Guest-CRM Sales user'].Id,
             LastName = 'last',
             Email = 'test000@gmail.com',
             Username = 'test@gmail.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
             
        );
        
        
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType opprt = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Business_Delivery'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id);
        insert acc;
        Product2[] prod = new List<Product2>();
        Product2 prod1 = new Product2(Name='Business Delivery AS',crm_ERP_Product_ID__c='5000',crm_New_Service__c= true,crm_global_Service_Area__c='Logistics',IsActive=true,
                                    crm_global_Service_Group__c='Business Delivery',crm_global_Service_Family__c='Business Delivery',crm_Service_Type__c='Actual Service');
        Product2 prod2 = new Product2(Name='Business Delivery VAS',crm_ERP_Product_ID__c='500',crm_New_Service__c= true,crm_global_Service_Area__c='Logistics',IsActive=true,
                                    crm_global_Service_Group__c='Business Delivery',crm_global_Service_Family__c='Business Delivery',crm_Service_Type__c='VAS');
        Product2 prod3 = new Product2(Name='Business Delivery Surcharge',crm_ERP_Product_ID__c='450',crm_New_Service__c= true,crm_global_Service_Area__c='Logistics',IsActive=true,
                                    crm_global_Service_Group__c='Business Delivery',crm_global_Service_Family__c='Business Delivery',crm_Service_Type__c='Surcharge');
        prod.add(prod1);
        prod.add(prod2);
        prod.add(prod3);
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry[] entries = new List<PricebookEntry>();
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod[0].Id, UnitPrice = 10000, IsActive = true,CurrencyIsoCode='NOK');
        entries.add(standardPrice1);
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod[1].Id, UnitPrice = 10000, IsActive = true,CurrencyIsoCode='NOK');
        entries.add(standardPrice2);
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod[2].Id, UnitPrice = 10000, IsActive = true,CurrencyIsoCode='NOK');
        entries.add(standardPrice3);
        insert entries;
                                    
        crm_Product_Relationship__c rel1 = new crm_Product_Relationship__c(Actual_service__c=prod[0].Id,Surcharge__c=prod[2].Id,VAS__c=prod[1].Id);
        insert rel1;                                                                                    
        Opportunity opp = new Opportunity(Name='Opportunity Test',StageName='New Opportunity',crm_Opp_Service_Family__c='Business Parcel',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=acc.Id,CurrencyIsoCode='NOK',RecordtypeId=opprt.Id,CloseDate=Date.today()+5);
        insert opp;
        
        String j1 = '{"asId":"' + acc.Id + '",';
        j1 += '"oppId":"' + opp.Id + '",';
        j1 += '"minimumprice":"12","discount":"34","minweight":"99","maxweight":"120","standardUnitPrice":"4000","freepickup":"true","local":';
        j1 += '"Domestic","conversionfactor":"Standard","direction":"Both","terminals":"Drammen;Fauske","additionalServices":[{"discountAddSer":"5",';
        j1 += '"productId":"' + prod[1].Id + '"},';
        j1 += '{"unitPriceAddSer":"88",';
        j1 += '"productId":"' + prod[2].Id + '"}]}';
        
        crm_addServicesControllerLightning.getOpportunityDetails(opp.Id);
        crm_addServicesControllerLightning.getProductsPerFamily(opp.Id);  
        crm_addServicesControllerLightning.getVASandSurcharges(prod[0].Id);
        crm_addServicesControllerLightning.getColumnData('Business Delivery');
        crm_addServicesControllerLightning.getPicklistFieldsOptions();
        crm_addServicesControllerLightning.createLineItems(j1);
        crm_addServicesControllerLightning.findALLPicklistValues('ALL'); 
        crm_addServicesControllerLightning.getpassivereturn();
        crm_addServicesControllerLightning.getCurrentUserProfile();
        Test.stopTest();                                      
    }


}