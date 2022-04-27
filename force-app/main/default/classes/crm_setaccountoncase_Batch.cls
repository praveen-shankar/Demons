/*
Created By:Supriya Goel
Date: 22 nov 2018
 set party level account id on acse record  
*/

global class crm_setaccountoncase_Batch implements Database.batchable<sObject>,Schedulable
{    
      public Set<string> reqId= new Set<String>();
     
 
     global Database.QueryLocator start(Database.BatchableContext BC){
     
     String query  ='Select id,crm_Party_Level_Account__c,Accountid   from Case where crm_Party_Level_Account__c = null';
         
     return database.getquerylocator(query);
     
     
     }
     
     global void execute(Database.BatchableContext BC, List<Case> caseList) {
     Set<id> relIds = new Set<Id>();
     
     for (Case c: caseList)
     {
         relIds.add(c.Accountid); 
         
     
     }
     
     Map<Id,Id> Accountmap = new Map<Id, Id>();
     
     List<Account> accountList= [Select id, parentid from account where id in  :relIds];
     for (Account a : accountList){
         Accountmap.put(a.id,a.parentid);
     
     }
     
      for (Case c: caseList)   {
          c.crm_Party_Level_Account__c = Accountmap.get(c.accountid);
      
      }
      
      if (caselist.size()>0)
          update caseList;
     
     
     }
     
     public void execute(SchedulableContext sc){
        Database.executeBatch(new crm_setaccountoncase_Batch());
    }
     
      global void finish(Database.BatchableContext BC) {}
     
  }//end of function