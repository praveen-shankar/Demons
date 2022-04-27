/*
Created By:Supriya Goel
Date: 17 th oct 2016
Calculate THIS year revenue on party level

*/

global class crm_ThisYrRevenueOnPartyAccount_Batch implements Database.batchable<sObject>,Database.Stateful{
    public string callback = '';   
  
       
    global crm_ThisYrRevenueOnPartyAccount_Batch (String callback){
        this.callback = callback;   
       
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
         crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
         Id PartyLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
              
        String query = 'Select id, crm_Revenue_This_Year__c, currencyisocode from Account where RecordTypeId = :PartyLevelRecordTypeId'; 
        return Database.getQueryLocator(query);                      
    }

    global void execute(Database.BatchableContext BC, List<Account> acclist) {
        Set <Id> partylevelId = new Set<Id>();
        Map<id, Id> RelationPartyAccoutMap = new Map<Id, Id>();
        Map<Id,Decimal> groupedPartyMapThisYr = new Map<Id,Decimal>();
        
         Map<Id,String> accountCurrencyMap = new Map<Id,String>();
        
        for(Account acnt: acclist){ 
            partylevelId.add(acnt.id) ;
            accountCurrencyMap.put(acnt.id, acnt.currencyisocode) ;
        }  
         
         List<Account> relationAccountList=[Select id, parentid from account where parentid in :partylevelId];
         for (account acnt : relationAccountList){
            
             RelationPartyAccoutMap.put(acnt.id, acnt.parentid) ;
        } 
        
        //get all the system currency
        Map<String, decimal> currencyMap= new Map<String, decimal>();
                       
        List<CurrencyType> currencyList = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE];  
        for (CurrencyType ctype: currencyList ){
            currencyMap.put(ctype.ISOCode, ctype.ConversionRate );
        }
          
         /*to calculate last year*/ 
         
         
        Map<id, List<crm_revenue_line__c>> acntRevMap= new  Map<id, List<crm_revenue_line__c>>();
        
        
        List<crm_revenue_line__c>  revLines=[Select crm_amount__c ,  crm_Account__r.parentid , CurrencyISOCode, crm_Transaction_Date__c from  crm_revenue_line__c where crm_Account__r.parentid IN :RelationPartyAccoutMap.values()  and crm_Transaction_Date__c =THIS_YEAR] ;
        
        if(revLines.size()>0)     {
            for (crm_revenue_line__c  rev:  revLines)  {
                if(acntRevMap.containsKey (rev.crm_Account__r.parentid)){
                    List<crm_Revenue_line__c> templist=  new List<crm_revenue_line__c>();
                    templist= acntRevMap.get(rev.crm_Account__r.parentid);
                    templist.add(rev);
                    acntRevMap.put(rev.crm_Account__r.parentid, templist);
                
                }else{
                    List<crm_Revenue_line__c> templist=  new List<crm_revenue_line__c>();
                    templist.add(rev);
                    acntRevMap.put(rev.crm_Account__r.parentid, templist);
                }
            }      
        
        }//end od size check
        
        Map<Id, Decimal> AcntRevMapThisyr= new Map<Id, Decimal>();
        
        for ( ID aID : acntRevMap.keySet() ){
             List<crm_Revenue_line__c> templist=acntRevMap.get(aID);
             Decimal total =0;
             for (crm_Revenue_line__c rev:templist){
             
               Decimal Amount=0;
               //Amount=rev.crm_amount__c / currencyMap.get(rev.CurrencyISOCode);
               Amount=rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);
               total   +=Amount;
             }
         
            String Accountcurrency= accountCurrencyMap.get(aID);
        
            Decimal ThisyrRev= total* currencyMap.get(Accountcurrency);
            AcntRevMapThisyr.put(aID, ThisyrRev);
                          
        }
        for (Account acnt: acclist){
       
            if(AcntRevMapThisyr.containskey(acnt.id))  {
                acnt.crm_Revenue_This_Year__c = AcntRevMapThisyr.get(acnt.id);
            } 
            else {
                 acnt.crm_Revenue_This_Year__c = 0;
            }
        }
         if(acclist.size()>0){
            try{
                Database.update (acclist, false);
            }catch(Exception e) {   crm_Exception_handler.createExceptionRecords(e);  }
     
        } //end of size
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
         Database.executeBatch(new crm_ThisYrRevenueOnRelationAccount_Batch (str));   
          
      } 

    }