@IsTest
public class viewServicesTest {
 @IsTest static void viewServicesTest() {
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
        RecordType opprt = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'SF_II_RT_A'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id);
        insert acc;
      
        Product2[] prod = new List<Product2>();
        Product2 prod1 = new Product2(Name='Pakke til bedrift',crm_ERP_Product_ID__c='5000',crm_New_Service__c= true,crm_global_Service_Area__c='Logistics',IsActive=true,
                                    crm_global_Service_Group__c='Business Delivery',crm_global_Service_Family__c='Business Delivery',crm_Service_Type__c='Actual Service');
        
    Product2 prod2 = new Product2(Name='Sosial kontroll',crm_ERP_Product_ID__c='1082',crm_New_Service__c= true,crm_global_Service_Area__c='Logistics',IsActive=true,
                             crm_global_Service_Group__c='',crm_global_Service_Family__c='',crm_Service_Type__c='VAS');
        //  Product2 prod2 = new Product2(Name='Pakke levert hjem',crm_ERP_Product_ID__c='5600',crm_New_Service__c= true,crm_global_Service_Area__c='Logistics',IsActive=true,
     //                               crm_global_Service_Group__c='Delivery to consumer',crm_global_Service_Family__c='Home Delivery Parcel',crm_Service_Type__c='Actual Service');
        Product2 prod3 = new Product2(Name='Skjult strekkode',crm_ERP_Product_ID__c='1155',crm_New_Service__c= true,crm_global_Service_Area__c='Logistics',IsActive=true,
                                    crm_global_Service_Group__c='',crm_global_Service_Family__c='',crm_Service_Type__c='Surcharge');
        prod.add(prod1);
        prod.add(prod2);
        prod.add(prod3);
        insert prod;
        //01s7a000001umk1AAA

       Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry[] entries1 = new List<PricebookEntry>();
        PricebookEntry standardPrice12 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod[0].Id, UnitPrice = 10000, IsActive = true,CurrencyIsoCode='NOK');
        entries1.add(standardPrice12);
        PricebookEntry standardPrice23 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod[1].Id, UnitPrice = 10000, IsActive = true,CurrencyIsoCode='NOK');
        entries1.add(standardPrice23);
        PricebookEntry standardPrice34 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod[2].Id, UnitPrice = 10000, IsActive = true,CurrencyIsoCode='NOK');
        entries1.add(standardPrice34);
        insert entries1;
        
        
        
       Pricebook2 pb = new Pricebook2(Name = 'SF2.0', Description = 'Salesforce 2.0 Application', IsActive = true );
       insert pb;
        Id pricebookSF2pbId = pb.Id;
    
        PricebookEntry[] entries = new List<PricebookEntry>();
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookSF2pbId, Product2Id = prod[0].Id, UnitPrice = 0, IsActive = true,CurrencyIsoCode='NOK');
        entries.add(standardPrice1);
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookSF2pbId, Product2Id = prod[1].Id, UnitPrice = 0, IsActive = true,CurrencyIsoCode='NOK');
        entries.add(standardPrice2);
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookSF2pbId, Product2Id = prod[2].Id, UnitPrice = 0, IsActive = true,CurrencyIsoCode='NOK');
        entries.add(standardPrice3);
        insert entries;
        
         Product_Relation__c rel1 = new Product_Relation__c(Service__c=prod[0].Id,Additional_Service__c=prod[1].Id);
        insert rel1;      
      
      
        Opportunity opp = new Opportunity(Name='Opportunity Test',StageName='New Opportunity',crm_Opp_Service_Family__c='Business Parcel',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=acc.Id,CurrencyIsoCode='NOK',RecordtypeId=opprt.Id,CloseDate=Date.today()+5);
        insert opp;
             String grpLineItemIdnew ='123456789';
//= opp.Id+ String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
     
     OpportunityLineItem oppLineItem =new OpportunityLineItem(crm_Discount__c=3,UnitPrice=1,crm_Min_Weight__c=2,
                                                              crm_Minimum_Price__c=2,crm_Max_Weight__c=5,
                                   OpportunityId=opp.Id,crm_Actual_Service__c=prod1.Id,PricebookEntryId=standardPrice1.Id,
                                                             crm_lineItemsGroupId__c='123456789');
     insert oppLineItem;
     
      OpportunityLineItem oppLineItem1 =new OpportunityLineItem(crm_Discount__c=3,UnitPrice=1,crm_Min_Weight__c=1,
                                                              crm_Minimum_Price__c=3,crm_Max_Weight__c=6,
                                   OpportunityId=opp.Id,crm_Actual_Service__c=prod1.Id,PricebookEntryId=standardPrice1.Id,
                                                             crm_lineItemsGroupId__c='123456789');
     insert oppLineItem1;
     
    /* 'crm_Discount__c' : this.strDiscount,
                 'UnitPrice' : this.strAnnualServiceValue,
                  'crm_Minimum_Price__c' : this.strMinimumPrice,
                  'crm_Min_Weight__c' : this.strcrm_Min_Weight__c,
                  'crm_Max_Weight__c' : this.strcrm_Max_Weight__c,
                   'OpportunityId':this.recordId,
                    'crm_Actual_Service__c':this.actualServiceIdModified,                          
                        'PricebookEntryId':this.PricebookEntryvalue,
                        'crm_lineItemsGroupId__c':this.grouplineItemId, */
     
     
     
    
     viewServices.fetchOppLineRecord(opp.Id);
     viewServices.fetchProductConfig(prod1.Id,opp.Id);
     viewServices.fetchOppLineRecordAdditionalService(grpLineItemIdnew,opp.Id); 
     viewServices.fetchDynamicFieldsConditions(prod1.Id);
     viewServices.cloneActualService(oppLineItem.Id,oppLineItem.crm_lineItemsGroupId__c,opp.Id);
     viewServices.deleteActualService(oppLineItem.Id,opp.Id);
     viewServices.updateActualService(oppLineItem1);
     
     
     Test.stopTest(); 
     
 }
}