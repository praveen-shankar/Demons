/* Created By: Supriya Goel
Date: 14th june 2019
Test class: crm_setalternativesonPartyBatch - test class for rev this yr
*/

@isTest()
public class crm_setalternativesonPartyBatchTest{

@testSetup static void setup() {
    
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
       // Id pricebookId = Test.getStandardPricebookId();
        Id pricebookId = System.Test.getStandardPricebookId();
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
                                          AccountId=acc.Id,CurrencyIsoCode='NOK',New_Service_Group__c=true,RecordtypeId=opprt.Id,CloseDate=Date.today()+5);
        insert opp;
    
        Opportunity opp1 = new Opportunity(Name='Opportunity Test1',StageName='New Opportunity',crm_Opp_Service_Family__c='Cargo Domestic Norway',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=acc.Id,CurrencyIsoCode='NOK',New_Service_Group__c=true,RecordtypeId=opprt.Id,CloseDate=Date.today()+5);
        insert opp1;
        
      /*  String j1 = '{"asId":"' + acc.Id + '",';
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
        crm_addServicesControllerLightning.findALLPicklistValues('ALL'); */
        
  

    /*PricebookEntry standardPrice = crm_TestDataFactory.createPricebookEntry();
    
    standardPrice.Pricebook2Id = pricebookId;
    standardPrice.Product2Id = prod1.Id;
    insert standardPrice;*/

    Pricebook2 customPB = crm_TestDataFactory.createPricebook();
    customPB.Name ='Business Parcel';
    insert customPB;
    
    PricebookEntry customPrice1 = crm_TestDataFactory.createPricebookEntry();
    customPrice1.Pricebook2Id = customPB.Id;
    customPrice1.Product2Id = prod1.Id;
    insert customPrice1;
    
    PricebookEntry customPrice2 = crm_TestDataFactory.createPricebookEntry();
    customPrice2.Pricebook2Id = customPB.Id;
    customPrice2.Product2Id = prod2.Id;
    insert customPrice2;
    
    PricebookEntry customPrice3 = crm_TestDataFactory.createPricebookEntry();
    customPrice3.Pricebook2Id = customPB.Id;
    customPrice3.Product2Id = prod3.Id;
    insert customPrice3;
    
     OpportunityLineItem oppLineAS1 = new OpportunityLineItem(); //discount AS
    oppLineAS1.pricebookentryid=customPrice1.Id;
    oppLineAS1.crm_Discount__c=19;
    oppLineAS1.OpportunityID = opp.Id;
    oppLineAS1.UnitPrice=100;
    insert oppLineAS1;
    
    OpportunityLineItem oppLineAS = new OpportunityLineItem();  //discount , min prcice AS
    oppLineAS.pricebookentryid=customPrice1.Id;
    oppLineAS.crm_Minimum_Price__c =7;
    oppLineAS.crm_Discount__c=19;
    oppLineAS.OpportunityID = opp.Id;
    oppLineAS.UnitPrice=100;
    insert oppLineAS;
    
    OpportunityLineItem oppLineAS11 = new OpportunityLineItem();  //discount , min prcice AS
    oppLineAS11.pricebookentryid=customPrice1.Id;
    oppLineAS11.crm_Minimum_Price__c =7;
    oppLineAS11.crm_Discount__c=19;
    oppLineAS11.OpportunityID = opp.Id;
    oppLineAS11.UnitPrice=100;
    insert oppLineAS11;
        
    OpportunityLineItem oppLine = new OpportunityLineItem(); //all AS 
    oppLine.pricebookentryid=customPrice1.Id;
    oppLine.crm_Min_Weight__c = 2;
    oppline.crm_Max_Weight__c =10;
    oppline.crm_Minimum_Price__c =7;
    oppline.crm_Discount__c=19;
    oppLine.OpportunityID = opp.Id;
    oppLine.UnitPrice=100;
    insert oppLine;
   
    /***************************AS end ************************/
    
    OpportunityLineItem oppLine1 = new OpportunityLineItem(); //vas discount 
    oppLine1.pricebookentryid=customPrice2.Id;
    oppLine1.TotalPrice=2000;
    oppLine1.crm_Discount__c = 2;
    oppLine1.OpportunityID = opp.Id;
    insert oppLine1;
    
    OpportunityLineItem oppLineVAS = new OpportunityLineItem(); //VAS discount 
    oppLineVAS.pricebookentryid=customPrice2.Id;
    oppLineVAS.TotalPrice=2000;
    oppLineVAS.crm_Discount__c = 2;
    oppLineVAS.OpportunityID = opp.Id;
    insert oppLineVAS;
  
    
    OpportunityLineItem oppLineVAS2 = new OpportunityLineItem(); //VAS unit price
    oppLineVAS2.pricebookentryid=customPrice2.Id;
    oppLineVAS2.TotalPrice=2000;
    oppLineVAS2.crm_Unit_Price__c = 200;
    oppLineVAS2.OpportunityID = opp.Id;
    insert oppLineVAS2;
    
    OpportunityLineItem oppLineVAS3 = new OpportunityLineItem(); //vas unit price
    oppLineVAS3.pricebookentryid=customPrice2.Id;
    oppLineVAS3.TotalPrice=2000;
    oppLineVAS3.crm_Unit_Price__c = 200;
    oppLineVAS3.OpportunityID = opp.Id;
    insert oppLineVAS3;
    
    /**********************VAS end ***********************/
    
    
     OpportunityLineItem oppLineS = new OpportunityLineItem(); //discount surcharge
    oppLineS.pricebookentryid=customPrice3.Id;
    oppLineS.TotalPrice=2000;
    oppLineS.crm_Discount__c = 2;
    oppLineS.OpportunityID = opp.Id;
    insert oppLineS;
    
    OpportunityLineItem oppLineS1 = new OpportunityLineItem();//discount surcharge
    oppLineS1.pricebookentryid=customPrice3.Id;
    oppLineS1.TotalPrice=2000;
    oppLineS1.crm_Discount__c = 2;
    oppLineS1.OpportunityID = opp.Id;
    insert oppLineS1;
    
    OpportunityLineItem oppLineS2 = new OpportunityLineItem(); //unit price surcharge
    oppLineS2.pricebookentryid=customPrice3.Id;
    oppLineS2.TotalPrice=2000;
    oppLineS2.crm_Unit_Price__c = 200;
    oppLineS2.OpportunityID = opp.Id;
    insert oppLineS2;
    
    OpportunityLineItem oppLineS3 = new OpportunityLineItem();//unit price surcharge
    oppLineS3.pricebookentryid=customPrice3.Id;
    oppLineS3.TotalPrice=2000;
    oppLineS3.crm_Unit_Price__c = 200;
    oppLineS3.OpportunityID = opp.Id;
    insert oppLineS3;
    
    /*******************************/
    
    /***********************for opp1******************************/
    Pricebook2 customPBopp2 = crm_TestDataFactory.createPricebook();
    customPBopp2.Name ='Cargo Domestic Norway';
    insert customPBopp2;
    
    PricebookEntry customPrice1opp2 = crm_TestDataFactory.createPricebookEntry();
    customPrice1opp2.Pricebook2Id = customPBopp2.Id;
    customPrice1opp2.Product2Id = prod1.Id;
    insert customPrice1opp2;
    
    PricebookEntry customPrice2opp2 = crm_TestDataFactory.createPricebookEntry();
    customPrice2opp2.Pricebook2Id = customPBopp2.Id;
    customPrice2opp2.Product2Id = prod2.Id;
    insert customPrice2opp2;
    
    PricebookEntry customPrice3opp2 = crm_TestDataFactory.createPricebookEntry();
    customPrice3opp2.Pricebook2Id = customPBopp2.Id;
    customPrice3opp2.Product2Id = prod3.Id;
    insert customPrice3opp2;
    
    OpportunityLineItem oppLine2AS1 = new OpportunityLineItem(); //discount AS
    oppLine2AS1.pricebookentryid=customPrice1opp2.Id;
    oppLine2AS1.crm_Discount__c=19;
    oppLine2AS1.OpportunityID = opp1.Id;
    oppLine2AS1.UnitPrice=100;
    insert oppLine2AS1;
    
    OpportunityLineItem oppLine2AS = new OpportunityLineItem();  //discount , min prcice AS
    oppLine2AS.pricebookentryid=customPrice1opp2.Id;
    oppLine2AS.crm_Minimum_Price__c =7;
    oppLine2AS.crm_Discount__c=19;
    oppLine2AS.OpportunityID = opp1.Id;
    oppLine2AS.UnitPrice=100;
    insert oppLine2AS;
    
    OpportunityLineItem oppLine2AS11 = new OpportunityLineItem();  //discount , min prcice AS
    oppLine2AS11.pricebookentryid=customPrice1opp2.Id;
    oppLine2AS11.crm_Minimum_Price__c =7;
    oppLine2AS11.crm_Discount__c=19;
    oppLine2AS11.OpportunityID = opp1.Id;
    oppLine2AS11.UnitPrice=100;
    insert oppLine2AS11;
        
    OpportunityLineItem oppLine2 = new OpportunityLineItem(); //all AS 
    oppLine2.pricebookentryid=customPrice1opp2.Id;
    oppLine2.crm_Min_Weight__c = 2;
    oppLine2.crm_Max_Weight__c =10;
    oppLine2.crm_Minimum_Price__c =7;
    oppLine2.crm_Discount__c=19;
    oppLine2.OpportunityID = opp1.Id;
    oppLine2.UnitPrice=100;
    insert oppLine2;
   
    /***************************AS end ************************/
    
    OpportunityLineItem oppLine2VAS1 = new OpportunityLineItem(); //vas discount 
    oppLine2VAS1.pricebookentryid=customPrice2opp2.Id;
    oppLine2VAS1.TotalPrice=2000;
    oppLine2VAS1.crm_Discount__c = 2;
    oppLine2VAS1.OpportunityID = opp1.Id;
    insert oppLine2VAS1;
    
    OpportunityLineItem oppLine2VAS = new OpportunityLineItem(); //VAS discount 
    oppLine2VAS.pricebookentryid=customPrice2opp2.Id;
    oppLine2VAS.TotalPrice=2000;
    oppLine2VAS.crm_Discount__c = 2;
    oppLine2VAS.OpportunityID = opp1.Id;
    insert oppLine2VAS;
  
    
    OpportunityLineItem oppLine2VAS2 = new OpportunityLineItem(); //VAS unit price
    oppLine2VAS2.pricebookentryid=customPrice2opp2.Id;
    oppLine2VAS2.TotalPrice=2000;
    oppLine2VAS2.crm_Unit_Price__c = 200;
    oppLine2VAS2.OpportunityID = opp1.Id;
    insert oppLine2VAS2;
    
    OpportunityLineItem oppLine2VAS3 = new OpportunityLineItem(); //vas unit price
    oppLine2VAS3.pricebookentryid=customPrice2opp2.Id;
    oppLine2VAS3.TotalPrice=2000;
    oppLine2VAS3.crm_Unit_Price__c = 200;
    oppLine2VAS3.OpportunityID = opp1.Id;
    insert oppLine2VAS3;
    
    /**********************VAS end ***********************/
    
    
     OpportunityLineItem oppLine2S = new OpportunityLineItem(); //discount surcharge
    oppLine2S.pricebookentryid=customPrice3opp2.Id;
    oppLine2S.TotalPrice=2000;
    oppLine2S.crm_Discount__c = 2;
    oppLine2S.OpportunityID = opp1.Id;
    insert oppLine2S;
    
    OpportunityLineItem oppLine2S1 = new OpportunityLineItem();//discount surcharge
    oppLine2S1.pricebookentryid=customPrice3opp2.Id;
    oppLine2S1.TotalPrice=2000;
    oppLine2S1.crm_Discount__c = 2;
    oppLine2S1.OpportunityID = opp1.Id;
    insert oppLine2S1;
    
    OpportunityLineItem oppLine2S2 = new OpportunityLineItem(); //unit price surcharge
    oppLine2S2.pricebookentryid=customPrice3opp2.Id;
    oppLine2S2.TotalPrice=2000;
    oppLine2S2.crm_Unit_Price__c = 200;
    oppLine2S2.OpportunityID = opp1.Id;
    insert oppLine2S2;
    
    OpportunityLineItem oppLine2S3 = new OpportunityLineItem();//unit price surcharge
    oppLine2S3.pricebookentryid=customPrice3opp2.Id;
    oppLine2S3.TotalPrice=2000;
    oppLine2S3.crm_Unit_Price__c = 200;
    oppLine2S3.OpportunityID = opp1.Id;
    insert oppLine2S3;
    
    /***************************/
      
    Contact c = crm_TestDataFactory.createContact();
    c.accountid=acc.id;
       // c.email='testopp@test.com';
    c.crm_functional_decision_level__c='Decision maker';
    c.status__c='Aktiv';
    c.crm_Contact_Type__c='Sales';
        insert c;
        
        OpportunityContactRole opprconrole= new OpportunityContactRole();
        opprconrole.ContactId= c.id;
        opprconrole.IsPrimary=true;
        opprconrole.OpportunityId= opp.id;
        insert opprconrole;
              
        opp.stagename ='Offer Sent'   ;
   // opp.ContactId=c.id;
        Update opp;   
        
        opp.stagename ='Closed Won'   ;
        opp.crm_reason_won__c ='Price';
        opp.Amount=500;
        opp.crm_Close_Behaviour__c='Create';
        opp.crm_Agreement_Start_Date__c = date.today();
        opp.crm_Verified_by_Contract_Management__c= true;
        //opp.New_Service_Group__c=true;
        Update opp;
    
        opp1.stagename ='Offer Sent'   ;
        Update opp1;   
        
        opp1.stagename ='Closed Won'   ;
        opp1.crm_reason_won__c ='Price';
        opp1.Amount=500;
        opp1.crm_Close_Behaviour__c='Create';
        opp1.crm_Agreement_Start_Date__c = date.today();
        opp1.crm_Verified_by_Contract_Management__c= true;
        //opp.New_Service_Group__c=true;
        Update opp1;
        
                                                 
       }
       
    static testMethod void testalternatives(){
      //  List<Account> ac1=[Select id,Orga__c from account where Orga__c='2348274724'];
       
       // List <OpportunityLineItem> allitemlist = [Select id, crm_AccountId__c, Opportunityid, opportunity.New_Service_Group__c, Opportunity.Stagename, Opportunity.crm_Verified_by_Contract_Management__c, Product2.id, Product2.crm_New_Service__c, product2.crm_Service_Type__c, crm_Discount__c, crm_Minimum_Price__c, crm_Min_Weight__c, crm_Max_Weight__c, crm_Unit_Price__c from OpportunityLineItem where crm_AccountId__c = :ac1[0].Id and opportunity.New_Service_Group__c = true and Opportunity.crm_Verified_by_Contract_Management__c = true and Opportunity.Stagename = 'Closed Won'];
        //System.debug('allitemlist' + allitemlist);
        crm_setalternativesonPartyBatch  acb = new crm_setalternativesonPartyBatch (); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        acb.countAlternatives();
        System.Test.stopTest(); 
    }
    
    
   
       }