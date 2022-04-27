@IsTest
public class ConfigureTest {
  @IsTest static void ConfigureTest() {
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
      
      ConfigureService.fetchPricebook2Id(opp.Id);
      ConfigureService.fetchPriceBookEntryId(prod1.Id, pricebookSF2pbId, 'NOK');
      
          Test.stopTest(); 
         
  }
}