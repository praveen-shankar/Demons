/*
Created By:Abhilasha Saxena
Date: 06.10.2020
Create automatic clone of counterpart SG/SF when Customer is In Converted for Hente/Bringe
*/

global class crm_clonedOpptyconvertedCustomer_v1 implements Database.batchable<sObject>
{
    public string callback = '';    
    
    global crm_clonedOpptyconvertedCustomer_v1(String callback)
    {
        this.callback = callback;   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        crm_AccountRecordTypes__c rcrdparty= crm_AccountRecordTypes__c.getValues('Party level Customer');
        Id PartyLevelRcrd= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rcrdparty.crm_Record_Type_Label__c).getRecordTypeId();
       // Conversion_heat__c c_heat= Conversion_heat__c.getValues('Heat Name');
       // String conv_h = c_heat.value__c;
        
        
        //Set<String> conv_status = new set<string>{'Converted'};
        String conv_status = 'Converted';
          // String ids = '001w000001jkuIlAAI';
            String mainQuery = 'Select id,crm_customer_converted_date__c,name from account where Customer_Converted__c =: conv_status and RecordTypeId = :PartyLevelRcrd and crm_customer_converted_date__c !=null'; 
        
        return Database.getQueryLocator(mainQuery);                   
    }
    
    
    global void execute(Database.BatchableContext BC, List<Account> AcctList)
    {
        String Hb_rcrdid = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Pick_up').getRecordTypeId();
        //Maps to store the intermediate data structure - Start
        Map<Id,Account> acctmap = new map<Id,Account>();
        Map<id,List<OpportunityLineItem>> opplnitmmap = new Map<id,List<OpportunityLineItem>>();
        Map<String,id> idmap = new Map<String,id>();
        Map<string, Id> ServiceNameToPBEIdMap = New Map<string, Id>();
        String opportunityPrimaryContact ;  
        //Maps to store the intermediate data structure - Stop
        
        //Lists to used for saving records in DML - Start
        List<opportunity> opplist = new list<opportunity>();
        List<opportunitylineitem> opplineitemlist_toinsert = new List<opportunitylineitem>();
        //Lists to used for saving records in DML - End
        
       // Savepoint sp = Database.setSavepoint();
       // String PriceBookID =  getPriceBookOrEntryId('PB');
      //  String PriceBookEntryID = getPriceBookOrEntryId('PBE');
        ServiceNameToPBEIdMap = getServiceNameToPBEIdMap();
        for (Account acct : AcctList)
            acctmap.put(acct.id,acct);
        system.debug('accountmap>>>' + acctmap);
        
        /*------ Start Add Primary Contact on Opportunity-----*/    
       List<AccountContactrelation> conList= [Select id,Accountid ,contactid, contact.crm_contact_type__c ,contact.crm_Activities_Count__c, contact.status__c from  AccountContactrelation where Accountid = :acctmap.keySet() and contact.status__c='Aktiv' and contact.crm_contact_type__c ='Sales' order by contact.crm_Activities_Count__c desc ];  
       Map<Id, id> ContactActcount= new Map<Id, id>();  
        
       for (AccountContactrelation con: conList)  { 
           if(!ContactActcount.containskey(con.accountid))  
                ContactActcount.put(con.accountid, con.contactid);  
                        
       }    
       /*------ Stop Add Primary Contact on Opportunity-----*/
        
        for(Opportunity OriginalOpportunity : [select id, Name,AccountId,OwnerId,CurrencyIsoCode,type,crm_Close_Behaviour__c,crm_Opp_Service_Group__c,crm_Opp_Service_Family__c,
                             crm_Primary_Opportunity_Contact__c,crm_Agreement__r.crm_New_Revenue_Start_Date__c,crm_Agreement__r.crm_Realized_Contract_Value__c,CloseDate,StageName,crm_Probability__c,crm_reason_won__c,crm_Notes__c,Amount,crm_Language_for_Offer__c,
                             crm_Posten_Legal_Company_for_Offer__c,crm_Verified_by_Contract_Management__c,crm_Agreement_Start_Date__c,crm_Agreement_End_Date__c,crm_Adjustment_Date__c,
                             crm_exceptions_standardPrice__c,crm_Offer_Generated_Date__c,crm_Offer_Sent__c,crm_Opportunity_Notes__c,crm_Enriched_In_PriceEngine__c/*,
                             (select id,PricebookEntry.Product2.Name,OpportunityId,Product2Id,crm_Actual_Service__c,crm_Max_Weight__c,crm_Direction__c,crm_Local__c,crm_Conversion_Factor__c,
                              crm_Min_Weight__c,crm_Terminals__c,crm_Unit_Price__c,crm_Free_Pickup__c,crm_lineItemsGroupId__c,PricebookEntryId,crm_Minimum_Price__c,
                              UnitPrice,crm_Discount__c,crm_Passive_Return__c
                              from OpportunityLineItems) */  
                             from opportunity 
                             where Id in : getMaxDatedOpportunities(acctmap.keySet())
                             order by crm_Agreement_Start_Date__c desc])
        {
            system.debug('inside for');
            List<OpportunityLineItem> opplineitemlist = new list<OpportunityLineItem>();
            
            /*for(OpportunityLineItem opplnitem : OriginalOpportunity.OpportunityLineItems)
            {
                Opportunitylineitem clonedlineitem = new Opportunitylineitem();
                clonedlineitem = opplnitem.clone(false,true,false,false);
                clonedlineitem.PricebookEntryId = ServiceNameToPBEIdMap.get(opplnitem.PricebookEntry.Product2.Name);
                opplineitemlist.add(clonedlineitem);
            }
            opplnitmmap.put(OriginalOpportunity.id,opplineitemlist);*/
            
             if(String.isBlank(OriginalOpportunity.crm_Primary_Opportunity_Contact__c)){    
                if(ContactActcount.containsKey(OriginalOpportunity.AccountId)){ 
                    opportunityPrimaryContact = ContactActcount.get(OriginalOpportunity.AccountId); 
                    
                }   
            }else{  
                opportunityPrimaryContact = OriginalOpportunity.crm_Primary_Opportunity_Contact__c; 
            }
            
            Opportunity ClonedOpportunity = getClonedOpportunity(OriginalOpportunity, acctmap.get(OriginalOpportunity.AccountId), Hb_rcrdid,opportunityPrimaryContact);
            opplist.add(ClonedOpportunity);
            idmap.put(ClonedOpportunity.name,OriginalOpportunity.id);
        }
        Try
        {
            if (!opplist.isEmpty())
                Database.insert(opplist,false);
            System.debug('cloned opportunity>>>> '+ opplist);
            for (Opportunity oppty: opplist)
            {
               // oppty.StageName = 'Closed Won';
                //oppty.type = 'Renegotiate';
                Opportunitylineitem lnitm = createActualService();
                lnitm.OpportunityId = oppty.id;
                lnitm.UnitPrice = oppty.Amount;
                System.debug('map value<<<<'+lnitm.Product2Id);
                lnitm.PricebookEntryId = ServiceNameToPBEIdMap.get(lnitm.Product2Id);
                opplineitemlist_toinsert.add(lnitm);
                
            }
            
            try
        {
            if(!opplineitemlist_toinsert.isEmpty())
                Database.insert(opplineitemlist_toinsert,false);
            System.debug('cloned opportunitylineitem>>>> '+ opplineitemlist_toinsert[0].id);
        }
        
        catch(exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
           // Database.rollback(sp);
            crm_Exception_handler.createExceptionRecords(e);
        }
            
            for (Opportunity oppty: opplist)
            {
                oppty.type = 'Renegotiate';
                oppty.StageName = 'Closed Won';
            }
            if (!opplist.isEmpty())
                Database.update(opplist,false);
            
            /*for(Opportunity clonedopp: opplist)
            {
                for (Opportunitylineitem oli : opplnitmmap.get(idmap.get(clonedopp.name)))
                {
                    oli.OpportunityId = clonedopp.id;
                    opplineitemlist_toinsert.add(oli);
                }
            }*/
        }
        
        catch(exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
           // Database.rollback(sp);
            crm_Exception_handler.createExceptionRecords(e);
        }
    }
    
    
    global void finish(Database.BatchableContext BC) 
    {
        String str = '';
        AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
        if(callback != '' && callback != null)
            str += callback + '\n';
        
        if(a != null && a.size() > 0)
        {
            str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List < string > toAddress = new List < string > ();
        environment_settings__c emailnotifications = environment_settings__c.getValues('BatchEmailNotification');
        List < String > valuesList1 = new List < String > ();
        if (emailnotifications != null && emailnotifications.value__c != null) 
            valuesList1 = emailnotifications.value__c.split(',');
        for (String emailuser:valuesList1 )
            toAddress.add(emailuser);  
        //below code will send an email to User about the status
        mail.setToAddresses(toAddress);
        mail.setSenderDisplayName('Posten');
        mail.setSubject('Batch status for cloned opportunity');
        mail.setPlainTextBody(str);
        // Send the email for the developer reference
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                  
    } 
    
    public static set<id> getMaxDatedOpportunities(Set<id> AccountIDSet)
    {
        //Code to get map of AccountID and Latest Hente/Bringe Opportunity - Start
        set<id> MaxOptySet = new set<id>();
        map<Id, List<Opportunity>> AccountToOptyListMap = new map<Id, List<Opportunity>>();
        map<Id, Opportunity> AccountToMaxOptyMap = New map<Id, Opportunity>();
        for (Opportunity opp: [select id, Name,AccountId,crm_Agreement_Start_Date__c,StageName,crm_Opp_Service_Group__c,crm_Opp_Service_family__c,crm_Agreement__r.crm_Status__c,crm_Agreement__r.crm_Agreement_End_Date__c from opportunity  
                               where StageName = 'Closed Won' 
                               and crm_Opp_Service_Group__c = 'Parcels – Domestic Norway' 
                               and crm_Opp_Service_Family__c = 'Hente/Bringe' 
                               and crm_Agreement__c != null 
                               and crm_Agreement__r.crm_Status__c = 'Active' 
                               and AccountId in :AccountIDSet
                               order by crm_Agreement_Start_Date__c desc])
        {
            system.debug('opportunity details>>'+ opp.StageName + '  ' + opp.crm_Opp_Service_Group__c + '  '+opp.crm_Opp_Service_Family__c + '  ' +opp.crm_Agreement__r.crm_Status__c+ ' '+ opp.crm_Agreement__r.crm_Agreement_End_Date__c);
            if(AccountToOptyListMap.containsKey(opp.AccountId))
                AccountToOptyListMap.get(opp.AccountId).add(opp);
            else
                AccountToOptyListMap.put(opp.AccountId, New List<Opportunity>{opp});
        }
        for(ID AccId : AccountToOptyListMap.keySet())
        {
            for(Opportunity Opp : AccountToOptyListMap.get(AccId))
            {
                if(!AccountToMaxOptyMap.containsKey(Opp.AccountId))
                {
                    AccountToMaxOptyMap.put(Opp.AccountId, Opp);
                }
                else
                {
                    if(Opp.crm_Agreement_Start_Date__c > AccountToMaxOptyMap.get(Opp.AccountId).crm_Agreement_Start_Date__c)
                    {
                        AccountToMaxOptyMap.put(Opp.AccountId, Opp);
                    }
                }
            }
        }
        for(Opportunity Opp : AccountToMaxOptyMap.values())
            MaxOptySet.add(Opp.Id);
        
        return MaxOptySet;
    }
    
   /* public static id getPriceBookOrEntryId(string Ptype)
    {
        List<Pricebookentry> pbentrylist = [SELECT id,pricebook2id,currencyisocode 
                                            FROM PricebookEntry 
                                            where currencyisocode = 'NOK' 
                                            and pricebook2.isstandard = false 
                                            and product2id in (select id 
                                                               from product2 
                                                               where name = 'Hente/Bringe' 
                                                               and crm_global_Service_Family__c = 'Hente/Bringe_new')
                                            and isactive = true limit 1];
        if(! pbentrylist.isEmpty())
        {
            if(Ptype == 'PB')
                return pbentrylist[0].pricebook2id;
            else if(Ptype == 'PBE')
                return pbentrylist[0].Id;
            else
                return null;
        }
        else
            return null;
    } */
    
    public static Opportunity getClonedOpportunity(Opportunity OriginalOpportunity,Account Acc, ID RecordTypeId,string opportunityPrimaryContact)
    {
        Opportunity oppclone = new Opportunity();
        oppclone = OriginalOpportunity.clone(false,true,false,false);
        oppclone.CloseDate = Acc.crm_customer_converted_date__c;
        oppclone.crm_Agreement_Start_Date__c = Acc.crm_customer_converted_date__c;
        oppclone.crm_Opp_Service_Family__c = 'Hente/Bringe_new';
        oppclone.crm_Opp_Service_Group__c = 'Hente/Bringe';
        oppclone.crm_Agreement__c = null;
        oppclone.StageName = 'New Opportunity';
        oppclone.Type = 'Renegotiate';
        oppclone.crm_Close_Behaviour__c = 'Create';
        oppclone.RecordTypeId = RecordTypeId;
        oppclone.name = Acc.name + '-'+ 'Hente/Bringe_new';
        oppclone.crm_Primary_Opportunity_Contact__c = opportunityPrimaryContact;    
                oppclone.OwnerId = OriginalOpportunity.OwnerId;

        if(OriginalOpportunity.crm_Agreement__r.crm_New_Revenue_Start_Date__c != null ){    
            Date max12Months = Date.today().addDays(-365);  
            Date min12months = Date.today().addDays(-1); // trailing twelve lower bound 
            Date revenueStartDate = OriginalOpportunity.crm_Agreement__r.crm_New_Revenue_Start_Date__c; 
                
            if(revenueStartDate >= max12Months && revenueStartDate < min12months  ){    
                oppclone.Amount = OriginalOpportunity.Amount;   
            }   
            else if(revenueStartDate < max12Months ){   
                if(OriginalOpportunity.crm_Agreement__r.crm_Realized_Contract_Value__c > 0){    
                    oppclone.Amount = OriginalOpportunity.crm_Agreement__r.crm_Realized_Contract_Value__c;  
                }   
                else{   
                    oppclone.Amount = OriginalOpportunity.Amount;   
                }   
            }   
        }   
        else{
            
            if(Boolean.valueOf(System.Label.TagRealized12MonthsRevenue)){
                if(OriginalOpportunity.crm_Agreement__r.crm_Realized_Contract_Value__c > 0){
                    oppclone.Amount = OriginalOpportunity.crm_Agreement__r.crm_Realized_Contract_Value__c;
                }
                else{
                    oppclone.Amount = OriginalOpportunity.Amount;
                }
            
            }
        
        }
        //oppclone.Amount = OriginalOpportunity.crm_Agreement__r.crm_Realized_Contract_Value__c;
        //oppclone.Pricebook2Id = ;
        //oppclone.Pricebook2Id = PriceBookId;
       // system.debug('pricebookid>>> '+PriceBookId);
        return oppclone;
    }
    
    public static Opportunitylineitem createActualService()
    {
        Opportunitylineitem olnitm = new Opportunitylineitem();
        String erpid = '1545_new';
        List <Product2> pdtid = new list<Product2>();
        pdtid= [select id,name from product2 where crm_ERP_Product_ID__c = :erpid limit 1];
        for (Product2 ids : pdtid)
        {
            olnitm.Product2Id = ids.id;
            //olnitm.Product2.name = ids.name;
        }
        olnitm.crm_Conversion_Factor__c = 'Standard';
        olnitm.crm_Direction__c = 'Both';
        olnitm.crm_Terminals__c = 'ALL';
        return olnitm;
        
    }
        
    public static map<string, Id> getServiceNameToPBEIdMap()
    {
        map<String, id> NewServiceToPBEId = new map<String, id>();
        for(PriceBookEntry PBE : [SELECT id,pricebook2id,currencyisocode, product2.Name
                                  FROM PricebookEntry 
                                  where currencyisocode = 'NOK' 
                                  and pricebook2.isstandard = false 
                                  and product2id in (select id 
                                                     from product2 
                                                     where crm_global_Service_Family_old__c = 'Hente/Bringe' 
                                                     and crm_global_Service_Group_old__c = 'Parcels – Domestic Norway'
                                                     and crm_global_Service_Group__c = 'Hente/Bringe'
                                                     and crm_Service_Type__c = 'Actual Service')
                                  and isactive = true])
        {
            NewServiceToPBEId.put(PBE.product2.Id, PBE.id);
            System.debug('service Map>>>'+NewServiceToPBEId);
        }
        return NewServiceToPBEId;
    }
}