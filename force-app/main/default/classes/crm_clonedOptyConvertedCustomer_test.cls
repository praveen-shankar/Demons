@istest
public class crm_clonedOptyConvertedCustomer_test
{
    @testSetup
    Public static void testDataSetup()
    {   
        test.startTest();
        crm_TestDataFactory.CreateCustomSetting();
        Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt1.crm_Conv_Converison_Heat__c = 'Heat L - SEPTEMBER 2020';
        partyLevelacnt1.crm_customer_converted_date__c = Date.today().adddays(1);
        partyLevelacnt1.Customer_Converted__c = 'Converted';
        partyLevelacnt1.name= 'Test acc1';
        insert  partyLevelacnt1;
        
        Account partyLevelacnt2= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt2.crm_customer_converted_date__c = date.today().adddays(1);
        partyLevelacnt2.crm_Conv_Converison_Heat__c = 'Heat L - SEPTEMBER 2020';
        partyLevelacnt2.Customer_Converted__c = 'Converted';
        partyLevelacnt1.name= 'Test acc2';
        insert  partyLevelacnt2;
        
        List<contact> con = new list<contact>();
        
        Contact con1 = New Contact(firstname='Abhilasha', lastname='Saxena',
                                   email='abhilasha.saxena@posten.no',AccountId=partyLevelacnt1.Id,
                                   crm_contact_type__c='Sales',Status__c = 'Aktiv');
        con.add(con1);
        
        Contact con2 = New Contact(firstname='Abhilasha', lastname='Saxena',
                                   email='abhilasha.saxena@tcs.com',AccountId=partyLevelacnt1.Id,
                                   crm_contact_type__c='Sales',Status__c = 'Aktiv');
        con.add(con2);
        insert con;
        
        List<pricebook2> pb = new list<pricebook2> ();
        PriceBook2 pb1 = crm_TestDataFactory.createPricebook();
        pb1.name = 'Hente/Bringe';
        pb.add(pb1);
        
        PriceBook2 pb2 = crm_TestDataFactory.createPricebook();
        pb2.name = 'Hente/Bringe_New';
        pb.add(pb2);
        
        /*PriceBook2 pb3 = crm_TestDataFactory.createPricebook();
        pb3.name = 'Hente/Bringe';
        pb.add(pb3);
        
        PriceBook2 pb4 = crm_TestDataFactory.createPricebook();
        pb4.name = 'Hente/Bringe';
        pb.add(pb4);*/
        insert pb;
               
        List<opportunity> opp = new list<opportunity>();
        Opportunity opp1 = new Opportunity();
        string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and developername = 'Parcels_Domestic_Norway_Opportunity' limit 1].Id;   
        opp1.name='Test parcel domestic oppty1';
        opp1.recordtypeId=RecordTypeId ;
        opp1.AccountId = partyLevelacnt1.id;
        opp1.StageName='New Opportunity';
        opp1.CloseDate=Date.Today();
        opp1.crm_Agreement_Start_Date__c = Date.Today().adddays(1);
        opp1.crm_Opp_Service_Group__c ='Parcels – Domestic Norway';
        opp1.crm_Opp_Service_Family__c = 'Hente/Bringe';
        opp1.ContactId = con1.id;
        opp1.Amount = 11;
        opp1.crm_Language_for_Offer__c = 'EN';
        opp1.crm_reason_won__c = 'Price';
        opp1.Pricebook2Id = pb1.id;

        //opp1.crm_Agreement__c = agr[0].id;
        opp1.crm_Close_Behaviour__c = 'Renegotiate';
        opp1.Type = 'Create';
        opp.add(opp1);
        
               
        Opportunity opp2 = new Opportunity();
        opp2.name='Test parcel domestic oppty2';
        opp2.AccountId = partyLevelacnt2.id;
        opp2.recordtypeId= RecordTypeId ;
        opp2.StageName='New Opportunity';
        opp2.CloseDate=Date.Today();
        opp2.crm_Agreement_Start_Date__c = Date.Today().adddays(1);
        opp2.crm_Opp_Service_Group__c ='Parcels – Domestic Norway';
        opp2.crm_Opp_Service_Family__c = 'Hente/Bringe';
        opp2.ContactId = con2.id;
        opp2.Amount = 21;
        opp2.crm_Language_for_Offer__c = 'EN';
        opp2.crm_reason_won__c = 'Price';
        opp2.Pricebook2Id = pb2.id;
        //opp2.crm_Agreement__c = agr[1].id;
        opp2.crm_Close_Behaviour__c = 'Renegotiate';
        opp2.Type = 'Create';
        opp.add(opp2);
        insert opp;    
        
        
        List <crm_Agreement__c> agr = new list<crm_agreement__c> ();
        crm_agreement__c agr1 = crm_TestDataFactory.createAgreement();
        agr1.crm_Status__c = 'Active';
        agr1.crm_Agreement_Service_Family__c = 'Hente/Bringe';
        agr1.crm_Agreement_Service_Group__c = 'Parcels – Domestic Norway';
        agr1.crm_Agreement_Start_Date__c = Date.Today().adddays(1);
        agr1.crm_Agreement_End_Date__c = null;
        agr1.crm_Account__c = partyLevelacnt1.id;
        agr1.crm_Agreement_Name__c = 'Test parcel domestic oppty agreement1';
        agr1.crm_New_Revenue_Start_Date__c = Date.Today().addMonths(-6);

        //agr1.crm_Opportunity_Id__c = opp[0].id;
        agr.add(agr1);
        
        crm_agreement__c agr2 = crm_TestDataFactory.createAgreement();
        agr2.crm_Status__c = 'Active';
        agr2.crm_Agreement_Service_Family__c = 'Hente/Bringe';
        agr2.crm_Agreement_Service_Group__c = 'Parcels – Domestic Norway';
        agr2.crm_Agreement_Start_Date__c = Date.Today().adddays(3);
        agr2.crm_Agreement_End_Date__c = null;
        agr2.crm_Account__c = partyLevelacnt2.id;
        agr2.crm_Agreement_Name__c = 'Test parcel domestic oppty agreement2';
                agr2.crm_New_Revenue_Start_Date__c = Date.Today().addMonths(-6);

        //agr2.crm_Opportunity_Id__c = opp[1].id;
        agr.add(agr2);
        insert agr; 
        
        system.debug('enddate1'+ agr[0].crm_Agreement_End_Date__c);
        system.debug('enddate2'+ agr[1].crm_Agreement_End_Date__c);
        
        List<Product2> pd = new list<product2>();
        Product2 pd1 = crm_TestDataFactory.createProduct();
        pd1.name = 'A1 Bringe Rammetid 0800-1000 kjernetid 30 min';
        pd1.crm_Service_Type__c = 'Surcharge';
        pd1.crm_global_Service_Area__c = 'Logistics';
        pd1.crm_global_Service_Family__c = 'Hente/Bringe';
        pd1.crm_global_Service_Group__c = 'Parcels – Domestic Norway';
        pd1.crm_global_Service_Family_old__c = 'Hente/Bringe';
        pd1.crm_global_Service_Group_old__c = 'Parcels – Domestic Norway';
        pd1.IsActive = true;
        pd.add(pd1);
        
        Product2 pd2 = crm_TestDataFactory.createProduct();
        pd2.name = 'B1 Bringe Rammetid 1000-1200 Kjernetid 30 min';
        pd2.crm_Service_Type__c = 'Surcharge';
        pd2.crm_global_Service_Area__c = 'Logistics';
        pd2.crm_global_Service_Family__c = 'Hente/Bringe';
        pd2.crm_global_Service_Group__c = 'Parcels – Domestic Norway';
        pd2.crm_global_Service_Family_old__c = 'Hente/Bringe';
        pd2.crm_global_Service_Group_old__c = 'Parcels – Domestic Norway';
        pd2.IsActive = true;
        pd.add(pd2);
        
        Product2 pd3 = crm_TestDataFactory.createProduct();
        pd3.name = 'A1 Bringe Rammetid 0800-1000 kjernetid 30 min';
        pd3.crm_Service_Type__c = 'Surcharge';
        pd3.crm_global_Service_Area__c = 'Logistics';
        pd3.crm_global_Service_Family__c = 'Hente/Bringe_New';
        pd3.crm_global_Service_Group__c = 'Hente/Bringe';
        pd3.crm_global_Service_Family_old__c = 'Hente/Bringe';
        pd3.crm_global_Service_Group_old__c = 'Parcels – Domestic Norway';
        pd3.IsActive = true;
        pd.add(pd3);
        
        Product2 pd4 = crm_TestDataFactory.createProduct();
        pd4.name = 'B1 Bringe Rammetid 1000-1200 Kjernetid 30 min';
        pd4.crm_Service_Type__c = 'Surcharge';
        pd4.crm_global_Service_Area__c = 'Logistics';
        pd4.crm_global_Service_Family__c = 'Hente/Bringe_New';
        pd4.crm_global_Service_Group__c = 'Hente/Bringe';
        pd4.crm_global_Service_Family_old__c = 'Hente/Bringe';
        pd4.crm_global_Service_Group_old__c = 'Parcels – Domestic Norway';
        pd4.IsActive = true;
        pd.add(pd4);
        insert pd;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry sp1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = pd1.Id,UnitPrice = 0, IsActive = true);
        insert sp1;
        PricebookEntry sp2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = pd2.Id,UnitPrice = 0, IsActive = true);
        insert sp2;
        PricebookEntry sp3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = pd3.Id,UnitPrice = 0, IsActive = true);
        insert sp3;
        PricebookEntry sp4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = pd4.Id,UnitPrice = 0, IsActive = true);
        insert sp4;
        
               
        List <PricebookEntry> pbe = new list<PricebookEntry> ();
        system.debug('pd1 >>> '+pd1);
        PricebookEntry pbe1 = crm_TestDataFactory.createPricebookEntry();
        pbe1.Pricebook2Id =pb1.id;
        pbe1.Product2Id = pd1.id;
        pbe1.UnitPrice = 0;
        pbe.add(pbe1);
        
        PricebookEntry pbe2 = crm_TestDataFactory.createPricebookEntry();
        pbe2.Pricebook2Id =pb1.id;
        pbe2.Product2Id = pd2.id;
        pbe2.UnitPrice = 0;
        pbe.add(pbe2);
        
        PricebookEntry pbe3 = crm_TestDataFactory.createPricebookEntry();
        pbe3.Pricebook2Id =pb2.id;
        pbe3.Product2Id = pd3.id;
        pbe3.UnitPrice = 0;
        pbe.add(pbe3);
        
        PricebookEntry pbe4 = crm_TestDataFactory.createPricebookEntry();
        pbe4.Pricebook2Id =pb2.id;
        pbe4.Product2Id = pd4.id;
        pbe4.UnitPrice = 0;
        pbe.add(pbe4);
        insert pbe;
        
        system.debug('pbe1 >>> '+pbe1);
        List<OpportunityLineItem> oli = new List<OpportunityLineItem>();
        OpportunityLineitem oli1 = new OpportunityLineitem();
        oli1.Product2Id = pd1.id;
        oli1.PricebookEntryId = pbe1.id;
        oli1.UnitPrice = 100;
        oli1.OpportunityId = opp1.id;
        oli.add(oli1);
        
        OpportunityLineitem oli2 = new OpportunityLineitem();
        oli2.Product2Id = pd2.id;
        oli2.PricebookEntryId = pbe2.id;
        oli2.UnitPrice = 100;
        oli2.OpportunityId = opp1.id;
        oli.add(oli2);
        
        /*OpportunityLineitem oli3 = new OpportunityLineitem();
        oli3.Product2Id = pd3.id;
        oli3.PricebookEntryId = pbe3.id;
        oli3.UnitPrice = 100;
        oli3.OpportunityId = opp2.id;
        oli.add(oli3);
        
        OpportunityLineitem oli4 = new OpportunityLineitem();
        oli4.Product2Id = pd4.id;
        oli4.PricebookEntryId = pbe4.id;
        oli4.UnitPrice = 100;
        oli4.OpportunityId = opp2.id;
        oli.add(oli4);*/
        insert oli;
        
        for (integer i=0; i<2; i++)
        {
            opp[i].stagename= 'Closed Won';
            opp[i].crm_Agreement__c = agr[0].id;
            opp[i].crm_Agreement__c = agr[1].id;
            //opp[i].CloseDate = date.today();
            System.debug('Debug opp>>>>>'+ opp[i].crm_Opp_Service_Group__c);
            System.debug('Debug opp>>>>>'+ opp[i].crm_Opp_Service_family__c);
            system.debug('Debug opp>>>>>'+ opp[i].crm_Agreement__c);
        }
        Update opp;
                
        Conversion_heat__c ch = new Conversion_heat__c(value__c = 'Heat L - SEPTEMBER 2020', name = 'Heat Name');
        insert ch;
        
        environment_settings__c ES = new environment_settings__c(Name = 'BatchEmailNotification', value__c = 'abhilasha.saxena@posten.no');
        insert ES;
        
        system.debug('opp1:' + opp1.id +' '+opp1.crm_Opp_Service_Family__c + ' '+ opp1.crm_Opp_Service_Group__c);
        test.stopTest();
    }
  public static TestMethod void testcloneoppty()
  {
      crm_clonedOpportunityConvertedCustomer coc = new crm_clonedOpportunityConvertedCustomer('');
      database.executeBatch(coc);
      crm_clonedOpptyconvertedCustomer_v1 cloned_allHeat = new crm_clonedOpptyconvertedCustomer_v1('');
      database.executeBatch(cloned_allHeat);

      
  }
}