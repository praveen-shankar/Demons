@IsTest
private class crm_agreementIntegrationController_test{

     @IsTest static void testThisClass() {
        Test.startTest();
        crm_Agreement_Terminals__c agrTerminal = New crm_Agreement_Terminals__c(Name = 'ALL', crm_Code__c = 'ALL');
        insert agrTerminal;
        
        environment_settings__c envSettings = New environment_settings__c(Name = 'AgreementMasterCodes',
                                                                         value__c = 'new=AM-01,account=AM-02,retrial=AM-03,upsell=AM-01,renegotiate=AM-01,shellagreement=AM-06,priceadjustment=AM-07');
        
        insert  envSettings;
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType relrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'business_account'];
        RecordType opprt = [Select Id From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Business_Delivery'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id,crm_Updated_by_CDH__c=true);
        insert acc;
        Account relacc = new Account(Name='Relation',Orga__c='2348274724',RecordTypeId=relrt.Id,ParentId=acc.Id,crm_Updated_by_CDH__c=true,crm_Customer_Number__c='45983945');
        insert relacc;
        Contact con = new Contact(AccountId = acc.Id,crm_Contact_Type__c='Sales',Status__c='Aktiv',FirstName='Raddd',LastName='kjieer',Email='cnkncd@dkjfioereor.com');
        insert con;        
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
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod[0].Id, UnitPrice = 10000, IsActive = true);
        entries.add(standardPrice1);
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod[1].Id, UnitPrice = 10000, IsActive = true);
        entries.add(standardPrice2);
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod[2].Id, UnitPrice = 10000, IsActive = true);
        entries.add(standardPrice3);
        insert entries;
                                    
        crm_Product_Relationship__c rel1 = new crm_Product_Relationship__c(Actual_service__c=prod[0].Id,Surcharge__c=prod[2].Id,VAS__c=prod[1].Id);
        insert rel1;                                                                                    
        Opportunity opp = new Opportunity(Name='Opportunity Test',StageName='New Opportunity',crm_Opp_Service_Family__c='Business Parcel',crm_Opp_Service_Group__c='Business Delivery',
                                          AccountId=acc.Id,CurrencyIsoCode='NOK',RecordtypeId=opprt.Id,CloseDate=Date.today()+5, crm_Primary_Opportunity_Contact__c = con.Id);
        insert opp;
         
        OpportunityContactRole oppcon = new OpportunityContactRole(OpportunityId=opp.Id,IsPrimary=true,ContactId=con.Id,Role='Business User');
        insert oppcon;
        OpportunityLineItem[] lines = new OpportunityLineItem[]{};
        OpportunityLineItem line1 = new OpportunityLineItem(PricebookEntryId=entries[0].Id,UnitPrice=300,OpportunityId=opp.Id,crm_Discount__c=34,crm_lineItemsGroupId__c='123456789',Product2Id=prod[0].Id,crm_Terminals__c='ALL');
        insert line1;
        OpportunityLineItem line2 = new OpportunityLineItem(PricebookEntryId=entries[1].Id,crm_Actual_Service__c=prod[1].Id,UnitPrice=300,OpportunityId=opp.Id,crm_Discount__c=34,crm_lineItemsGroupId__c='123456789',Product2Id=prod[1].Id,crm_Terminals__c='ALL');
        OpportunityLineItem line3 = new OpportunityLineItem(PricebookEntryId=entries[2].Id,crm_Actual_Service__c=prod[2].Id,UnitPrice=300,OpportunityId=opp.Id,crm_Discount__c=34,crm_lineItemsGroupId__c='123456789',Product2Id=prod[2].Id,crm_Terminals__c='ALL');
        lines.add(line2);
        lines.add(line3);
        insert lines;
        
		String oppId = [Select Id from Opportunity Limit 1].Id;
       /* Price_Adjustment__c pa = New Price_Adjustment__c(Opportunity_Id__c = oppId, Customer_Name__c = acc.Id,
                                                         Service__c = 'Business Delivery AS', Adjustment_Percent__c = line1.crm_Discount__c,
                                                         Adjustment_Date__c = Date.Today());
        insert pa;
        
        Price_Adjustment__c paUpdate = New Price_Adjustment__c(Id = pa.Id, Verified_by_Contract_Manager__c = true, Rounding_Up__c = True);
        update paUpdate; */
         
        Test.setMock(HttpCalloutMock.class, new crm_convertCustomerIntegration_mock());
         
        Opportunity oppagain = new Opportunity(crm_Agreement_Start_Date__c=Date.today()+2,Id=opp.Id,crm_Callout_Status__c='Callout Pending',crm_Verified_by_Contract_Management__c =true,StageName='Closed Won',crm_Language_for_Offer__c='NO',crm_reason_won__c='MyBring', Send_Shell_Agreement__c =true);
        update oppagain;
        System.enqueueJob(new crm_agreementIntegrationController(new List<String>{oppagain.Id},'new'));
        
        /*Opportunity paOpp = New Opportunity(Id=opp.Id,crm_Callout_Status__c='Callout Pending',crm_Verified_by_Contract_Management__c =true, Send_Shell_Agreement__c =false);
        update paOpp;
        System.enqueueJob(new crm_agreementIntegrationController(new List<String>{paOpp.Id},'priceadjustment'));*/
        
        String jobId = System.schedule('crm_agreementIntegrationSchedulable', '0 0 0 3 9 ? 2022',new crm_agreementIntegrationSchedulable(new List<Id>{oppagain.Id}));
        Test.stopTest();
     }

}