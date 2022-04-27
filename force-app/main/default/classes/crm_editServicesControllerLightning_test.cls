@IsTest
private class crm_editServicesControllerLightning_test{
    
    @IsTest static void testAddServices() {
        Test.startTest();
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
        
       /* Pricebook2 pricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
         id pricebookId =pricebook.id;*/
        
         PricebookEntry standardPrice1 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id =prod[0].Id,
            UnitPrice = 10000, IsActive = true,CurrencyIsoCode='NOK');
               
         PricebookEntry standardPrice2 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id =prod[1].Id,
            UnitPrice = 10000, IsActive = true,CurrencyIsoCode='NOK');
                
         PricebookEntry standardPrice3 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id =prod[2].Id,
            UnitPrice = 10000, IsActive = true, CurrencyIsoCode='NOK');
            
            List<PricebookEntry> stdpricebookentries= new List<PricebookEntry>();
            stdpricebookentries.add(standardPrice1);
            stdpricebookentries.add(standardPrice2);
            stdpricebookentries.add(standardPrice3);
            
            insert stdpricebookentries;
        
        Pricebook2 pb1= new Pricebook2();
        pb1.name='Business Delivery';
        pb1.IsActive = true ;
        insert pb1;
        
          
        PricebookEntry[] entries = new List<PricebookEntry>();
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = pb1.id, Product2Id = prod[0].Id, UnitPrice = 10000, IsActive = true, CurrencyIsoCode='NOK');
        entries.add(customPrice1);
        PricebookEntry customPrice2 = new PricebookEntry(Pricebook2Id = pb1.id, Product2Id = prod[1].Id, UnitPrice = 10000, IsActive = true, CurrencyIsoCode='NOK');
        entries.add(customPrice2);
        PricebookEntry customPrice3 = new PricebookEntry(Pricebook2Id = pb1.id, Product2Id = prod[2].Id, UnitPrice = 10000, IsActive = true, CurrencyIsoCode='NOK');
        entries.add(customPrice3);
        insert entries;
                                    
        crm_Product_Relationship__c rel1 = new crm_Product_Relationship__c(Actual_service__c=prod[0].Id,Surcharge__c=prod[2].Id,VAS__c=prod[1].Id);
        insert rel1;
        
      
                
                                                                                            
        Opportunity opp = new Opportunity(Name='Opportunity Test',StageName='New Opportunity',crm_Opp_Service_Family__c='Business Parcel',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=acc.Id,CurrencyIsoCode='NOK',RecordtypeId=opprt.Id,CloseDate=Date.today()+5, Pricebook2id=pb1.id);
        insert opp;
        
        Opportunitylineitem line1=new Opportunitylineitem (opportunityid=opp.Id,Product2id= prod[0].id,UnitPrice =500,crm_Discount__c = 10,PricebookEntryId =entries[0].id,crm_lineItemsGroupId__c ='12345');
                
        Opportunitylineitem line2=new Opportunitylineitem (opportunityid=opp.Id,crm_Actual_Service__c=prod[0].id, Product2id= prod[1].id,crm_Discount__c = 10,PricebookEntryId =entries[1].id,crm_lineItemsGroupId__c ='12345');
                
        Opportunitylineitem line3=new Opportunitylineitem (opportunityid=opp.Id,crm_Actual_Service__c=prod[0].id, Product2id= prod[2].id,crm_Discount__c = 20, PricebookEntryId =entries[2].id,crm_lineItemsGroupId__c ='12345');
               
        List<Opportunitylineitem> itemlist= new List<Opportunitylineitem>();
        itemlist.add(line1);
        itemlist.add(line2);
        itemlist.add(line3);
        
        insert itemlist;
            
        
        String j1 = '{"asId":"' + itemlist[0].id + '",';
        j1 += '"oppId":"' + opp.Id + '",';
        j1 += '"minimumprice":"12","discount":"34","unitprice":67, "minweight":"99","maxweight":"120","priceunit":67, "standardUnitPrice":"4000","freepickup":"true","local":';
        j1 += '"Domestic","conversionfactor":"Standard","direction":"Both","terminals":"Drammen;Fauske","minimumpricepercent":67,"additionalServices":[{"discountAddSer":"5",';
        j1 += '"productId":"' + itemlist[1].id + '"},';
        j1 += '{"unitPriceAddSer":"88",';
        j1 += '"productId":"' + itemlist[2].id+ '"}]}';
                
               
          
        
        //List<opportunitylineitem> line1= [Select id from opportunitylineitem where crm_AccountId__c=:acc.Id];     
        
         crm_editServicesControllerLightning.getOpportunityServices(opp.Id);     
        crm_editServicesControllerLightning.editOpportunity(itemlist[0].id);
        crm_editServicesControllerLightning.getAdditionalServices(itemlist[0].id);
        
        crm_editServicesControllerLightning.getActualServicesData(itemlist[0].id);
        crm_editServicesControllerLightning.getAdditionalServicesData(itemlist[0].id);
        crm_editServicesControllerLightning.getConversionFactor();
        crm_editServicesControllerLightning.getDirection();
        crm_editServicesControllerLightning.getLocal();
        crm_editServicesControllerLightning.getPriceList();
        crm_editServicesControllerLightning.getPriceUnit();
        crm_editServicesControllerLightning.getTerminal();
        crm_editServicesControllerLightning.getAddServices(itemlist[0].id);
        
        crm_editServicesControllerLightning.updateLineItems(j1);
              
        Test.stopTest();                                      
    }


}