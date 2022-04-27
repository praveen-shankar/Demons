/*
Created By:Supriya Goel
Date: 11 th june 2019 
setprimary contact on account 

*/

global class crm_setprimarycontactAccount_Batch implements Database.batchable<sObject>,Database.Stateful
{
    public string callback = '';        
    global crm_setprimarycontactAccount_Batch (String callback){
        this.callback = callback;   
    }
    
   global Database.QueryLocator start(Database.BatchableContext BC)
   {
         crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
         Id PartyLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
        String query = 'Select id,  Primary_contact__c, Warrants_Postage__c, Set_Primary_Contact__c from account  where RecordTypeId = :PartyLevelRecordTypeId and Set_Primary_Contact__c = false order by createddate desc '; 
        if(callback!='')
            query = 'Select id,  Primary_contact__c, Warrants_Postage__c, Set_Primary_Contact__c from account  where RecordTypeId = :PartyLevelRecordTypeId and id =:callback and Set_Primary_Contact__c = false order by createddate desc '; 
        return Database.getQueryLocator(query);                      
    }

    global void execute(Database.BatchableContext BC, List<Account> acclist) 
    {      
        Map<id, List <Id>> DecisionmakerMap= new Map<Id,List <Id>>();
        Map<id, List <Id>> InfluencerMap= new Map<Id,List <Id>>();
        Map<id, List <Id>> ContactUserMap= new Map<Id,List <Id>>();
        Map<id, List <Id>> ContactBlankMap= new Map<Id,List <Id>>();
        Map<id, List <Id>> ContactMap= new Map<Id,List <Id>>();
        Set<Id> Accountids = new Set<Id>();
        
        for (Account a:acclist )
            Accountids.add(a.id);
        
        List<AccountContactRelation > AccountContactRelationlist =[Select id ,contactid,accountid, contact.status__c, account.name , contact.name , contact.crm_functional_decision_level__c  from AccountContactRelation where accountid in : Accountids and contact.status__c ='Aktiv' and contact.email!=null and contact.crm_Contact_Type__c ='Sales' order by accountid, contact.crm_functional_decision_level__c];
        List<AccountcontactrelationCustom__c> listtoadd = new List<AccountcontactrelationCustom__c>();
        
        
        for (AccountContactRelation  c:  AccountContactRelationlist )
        {            
            if(c.contact.crm_functional_decision_level__c == 'Decision maker' || c.contact.crm_functional_decision_level__c == 'Beslutningstaker')
            {
                if(DecisionmakerMap.containskey(c.accountid))
                    DecisionmakerMap.get(c.accountid).add(c.contactid);
                else
                    DecisionmakerMap.put(c.accountid, New List<Id>{c.contactid});
                if(ContactBlankMap.containskey(c.accountid))
                    ContactBlankMap.remove(c.accountid);
            }
            
            if(c.contact.crm_functional_decision_level__c == 'Influencer' || c.contact.crm_functional_decision_level__c == 'Påvirker')
            {       
                if (!DecisionmakerMap.containskey(c.accountid))
                {
                    if(InfluencerMap.containskey(c.accountid)) 
                        InfluencerMap.get(c.accountid).add(c.contactid);
                }
                else
                    InfluencerMap.put(c.accountid, New List<Id>{c.contactid});
                if(ContactBlankMap.containskey(c.accountid))
                    ContactBlankMap.remove(c.accountid);
            }
            
            if(c.contact.crm_functional_decision_level__c == 'User' || c.contact.crm_functional_decision_level__c == 'Bruker')
            {
                if((!DecisionmakerMap.containskey(c.accountid)) && (!InfluencerMap.containskey(c.accountid)))
                {
                    if(ContactUserMap.containskey(c.accountid)) 
                        ContactUserMap.get(c.accountid).add(c.contactid);
                    else
                        ContactUserMap.put(c.accountid, New List<Id>{c.contactid});
                    if(ContactBlankMap.containskey(c.accountid))
                        ContactBlankMap.remove(c.accountid);
                }
            }   
            
            if(c.contact.crm_functional_decision_level__c == '' || c.contact.crm_functional_decision_level__c == null)
            {
                if((!DecisionmakerMap.containskey(c.accountid)) && (!InfluencerMap.containskey(c.accountid)) && (!ContactUserMap.containskey(c.accountid)))
                {
                    if(ContactBlankMap.containskey(c.accountid)) 
                        ContactBlankMap.get(c.accountid).add(c.contactid);
                    else
                        ContactBlankMap.put(c.accountid, New List<Id>{c.contactid});
                }  
            } 
            
        }//end of for
        
        system.debug('## InfluencerMap '+  InfluencerMap );
        system.debug('## DecisionmakerMap ' + DecisionmakerMap);
        system.debug('## ContactUserMap' + ContactUserMap);
        system.debug('## ContactBlankMap' + ContactBlankMap);
        system.debug('## ContactMap'+  ContactMap);
        
        for (Account acct : acclist)
        {
            if (DecisionmakerMap.containskey(acct.id))
            {
                for (Id conid:DecisionmakerMap.get(acct.id))
                   listtoadd.add(new AccountcontactrelationCustom__c (Accountid__c=acct.id, Contactid__c= conid, Functional_Decision_level__c ='Descision Maker'));
            }
            else if (InfluencerMap.containskey(acct.id))
            {
                for (Id conid:InfluencerMap.get(acct.id))
                    listtoadd.add(new AccountcontactrelationCustom__c (Accountid__c=acct.id, Contactid__c= conid, Functional_Decision_level__c ='Influencer'));
                
            }
            else if (ContactUserMap.containskey(acct.id))
            {
                for (Id conid:ContactUserMap.get(acct.id))
                    listtoadd.add(new AccountcontactrelationCustom__c (Accountid__c=acct.id, Contactid__c= conid, Functional_Decision_level__c ='User'));
            }
            else if (ContactBlankMap.containskey(acct.id))
            {
                for (Id conid:ContactBlankMap.get(acct.id))
                    listtoadd.add(new AccountcontactrelationCustom__c (Accountid__c=acct.id, Contactid__c= conid, Functional_Decision_level__c =''));
            }
            
        }
        
        try 
        {
            if(!listtoadd.isEmpty())
                insert  listtoadd ;
            //update acclist; 
        }
        
        catch (Exception ex)
        {
            crm_Exception_handler.createExceptionRecords(ex);         
        }
        
        Map<Id, Integer> AggresultsMap = new Map<Id, Integer>();         
        
        list<AggregateResult> AggregateResultList=[select Accountid__c,count(id)total  from AccountcontactrelationCustom__c group by Accountid__c]; 
        if(AggregateResultList!= null && AggregateResultList.size() > 0)
        { 
            for(AggregateResult agg:AggregateResultList)
            { 
                if(!AggresultsMap.containskey((id)agg.get('Accountid__c')))
                    AggresultsMap.put((id)agg.get('Accountid__c'), (Integer)agg.get('total'));
            }  
        }
        
        for (Account acct : acclist)
        {
            if (DecisionmakerMap.containskey(acct.id))
            {
                for (Id conid:DecisionmakerMap.get(acct.id))
                    acct.Primary_contact__c = conid;
                acct.Set_Primary_Contact__c = true;
                if (AggresultsMap.containskey(acct.id))
                    acct.Warrants_Postage__c= true;
                else
                    acct.Warrants_Postage__c = false;
            }
            else if (InfluencerMap.containskey(acct.id))
            {
                for (Id conid:InfluencerMap.get(acct.id))
                    acct.Primary_contact__c = conid;
                acct.Set_Primary_Contact__c = true;
                if (AggresultsMap.containskey(acct.id))
                    acct.Warrants_Postage__c= true;
                else
                    acct.Warrants_Postage__c = false;
            }
            else if (ContactUserMap.containskey(acct.id))
            {
                for (Id conid:ContactUserMap.get(acct.id))
                    acct.Primary_contact__c = conid;
                acct.Set_Primary_Contact__c = true;
                if (AggresultsMap.containskey(acct.id))
                    acct.Warrants_Postage__c= true;
                else
                    acct.Warrants_Postage__c = false;
            }
            else if (ContactBlankMap.containskey(acct.id))
            {
                for (Id conid:ContactBlankMap.get(acct.id))
                    acct.Primary_contact__c = conid;
                acct.Set_Primary_Contact__c = true;
                if (AggresultsMap.containskey(acct.id))
                    acct.Warrants_Postage__c= true;
                else
                    acct.Warrants_Postage__c = false;
            }
        }
        update acclist;
    }
    
     global void finish(Database.BatchableContext BC) {
        String str = '';
        AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
        if(callback != '' && callback != null)
                  str += callback + '\n';
        
        if(a != null && a.size() > 0){
                    str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
                }               
                 //send mail 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'posten.salesforce@tcs.com'}; 
       // String[] ccAddresses = new String[] {'supriya.goel@capgemini.com'};
        
        mail.setToAddresses(toAddresses);
      //  mail.setCcAddresses(ccAddresses);
        mail.setReplyTo('posten.salesforce@tcs.com');
        mail.setSenderDisplayName('Posten');
        mail.setSubject('Set primary contact on  Account');
        mail.setPlainTextBody(str);
        
        // Send the email for the developer reference
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
      } 
    }