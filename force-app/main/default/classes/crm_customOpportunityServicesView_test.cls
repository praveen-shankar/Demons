@IsTest
private class crm_customOpportunityServicesView_test{

    @IsTest static void testThisclass() {
        Test.startTest();
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType opprt = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Business_Delivery'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id);
        insert acc;
        Product2[] prod = new List<Product2>();
        Product2 prod1 = new Product2(Name='Business Delivery AS',crm_ERP_Product_ID__c='5000',crm_New_Service__c= true,crm_global_Service_Area__c='Logistics',IsActive=true,
                                    crm_global_Service_Group__c='Business Delivery',crm_global_Service_Family__c='Business Parcel',crm_Service_Type__c='Actual Service');
        Product2 prod2 = new Product2(Name='Business Delivery VAS',crm_ERP_Product_ID__c='500',crm_New_Service__c= true,crm_global_Service_Area__c='Logistics',IsActive=true,
                                    crm_global_Service_Group__c='Business Delivery',crm_global_Service_Family__c='Business Parcel',crm_Service_Type__c='VAS');
        Product2 prod3 = new Product2(Name='Business Delivery Surcharge',crm_ERP_Product_ID__c='450',crm_New_Service__c= true,crm_global_Service_Area__c='Logistics',IsActive=true,
                                    crm_global_Service_Group__c='Business Delivery',crm_global_Service_Family__c='Business Parcel',crm_Service_Type__c='Surcharge');
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
        OpportunityLineItem[] lines = new OpportunityLineItem[]{};
        OpportunityLineItem line1 = new OpportunityLineItem(PricebookEntryId=entries[0].Id,UnitPrice=300,OpportunityId=opp.Id,crm_Discount__c=34,crm_lineItemsGroupId__c='123456789',Product2Id=prod[0].Id);
        insert line1;
        OpportunityLineItem line2 = new OpportunityLineItem(PricebookEntryId=entries[1].Id,crm_Actual_Service__c=prod[0].Id,UnitPrice=300,OpportunityId=opp.Id,crm_Discount__c=34,crm_lineItemsGroupId__c='123456789',Product2Id=prod[1].Id);
        OpportunityLineItem line3 = new OpportunityLineItem(PricebookEntryId=entries[2].Id,crm_Actual_Service__c=prod[0].Id,UnitPrice=300,OpportunityId=opp.Id,crm_Discount__c=34,crm_lineItemsGroupId__c='123456789',Product2Id=prod[2].Id);
        lines.add(line2);
        lines.add(line3);
        insert lines;
        Map<String,String> attributes = new Map<String,String>{'actualServiceId' => prod[0].Id,'oppId' => opp.Id, 'UnitPrice' => '400','additionalServiceId' => prod[1].Id,
                                                              'Discount' => '23', 'groupId' => '123456789'};
        crm_customOpportunityServicesView.getLineItems(opp.Id);
        crm_customOpportunityServicesView.addLineItem(attributes);
        crm_customOpportunityServicesView.getVASandSurcharges(prod[0].Id);
        crm_customOpportunityServicesView.cloneLineItems('123456789');
        crm_customOpportunityServicesView.deleteLineItems(new List<String>{line1.Id});
        Test.stopTest();
    }
}