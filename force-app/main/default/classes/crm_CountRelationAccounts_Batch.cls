/*
Created By:Supriya Goel
Date: sprint 6 adjustments
count of relation accounts

*/

global class crm_CountRelationAccounts_Batch implements Database.batchable<sObject>
{    
    
    public string callback = '';        
    global crm_CountRelationAccounts_Batch (String callback){
        this.callback = callback;   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        
        crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
        Id PartyLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
        String query = 'Select id, ParentId ,crm_Count_of_Relation_level_Accounts__c from Account where RecordTypeId = :PartyLevelRecordTypeId  '; 
        return database.getquerylocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> AccountList) {
        System.debug('@@AccountList'+AccountList);
        Set<Id> parentAccs = new Set<Id>();
        
        Map<Id, Integer> childCount = new Map<Id, Integer>();
        if(AccountList.size()>0){ 
            for (Account a : AccountList){
                // if(a.ParentId != null)
                parentAccs.add(a.id);  //collect parent ids
            }
        } 
        System.debug('@@parentAccs'+parentAccs);  
        
        Map<id,Integer> groupedMap = new Map<id,Integer>();
        
        List<Account> accsUpdate = new List<Account>{};
            
            for(Account acc : [Select Id, ParentId from Account where ParentId IN :parentAccs and  (crm_Account_Inserted__c=true or crm_Account_Updated__c=true or crm_Active_Relation_Account__c =true)]){
                if(childCount.get(acc.ParentId) == null)
                    childCount.put(acc.ParentId, 0);  //create a counter for parent
                
                childCount.put(acc.ParentId, childCount.get(acc.ParentId) +1); //increment counter
                
            }
        System.debug('@@childCount'+childCount);
        
        
        for(Account acc : AccountList){
            if(childCount.containskey(acc.id)){
                
                accsUpdate.add(new Account(Id = acc.Id, crm_Count_of_Relation_level_Accounts__c= childCount.get(acc.Id))); //set parent counts
            } 
            else{
                
                accsUpdate.add(new Account(Id = acc.Id, crm_Count_of_Relation_level_Accounts__c= 0)); //set parent counts
            }
        }
        
        try{ 
            Database.update(accsUpdate); //update parent accounts
            
        } catch(Exception e){ crm_Exception_handler.createExceptionRecords(e); }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        String str = '';
        AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
        
        if(callback != '' && callback != null)
            str += callback + '\n';
        if(a != null && a.size() > 0){
            str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
        }
        
        
        if(!Test.IsRunningTest())
            Database.executeBatch(new crm_ThisYrRevenueOnPartyAccount_Batch(str));
    }
    
}