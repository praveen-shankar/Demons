/*
Created By:Supriya Goel
Date: 6th nov 2016
Calculate THIS year revenue on relation level

*/

global class crm_ThisYrRevOnRelation7novdep_Batch implements Database.batchable<sObject>,Database.Stateful{
    public string callback = '';        
    global crm_ThisYrRevOnRelation7novdep_Batch (String callback){
        this.callback = callback;   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
         crm_AccountRecordTypes__c rTrelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
         Id relationLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTrelation.crm_Record_Type_Label__c).getRecordTypeId();
       
        String query = 'Select id, crm_Revenue_This_Year__c from Account where RecordTypeId = :relationLevelRecordTypeId'; 
        System.debug('@@@query'+ query);
        return Database.getQueryLocator(query);                      
    }

    global void execute(Database.BatchableContext BC, List<Account> acclist) {
        Set <Id> relationlevelId= new Set<Id>();
        Map<Id,Decimal> groupedrelationMapThisYr = new Map<Id,Decimal>();
        
        for(Account acnt: acclist){ 
            relationlevelId.add(acnt.id) ;
        }  
         
        
          
         /*to calculate last year*/ 
       
        for(AggregateResult agg : [SELECT SUM(crm_Amount__c )amount, crm_Account__c  account  FROM crm_Revenue_Line__c WHERE crm_Account__c IN :relationlevelId  AND crm_Amount__c!= NULL and  crm_Transaction_Date__c = THIS_YEAR GROUP BY crm_Account__c]){
            groupedrelationMapThisYr.put((Id)agg.get('account'),(Decimal)agg.get('amount'));
        }
        
          System.debug('@@@groupedrelationMapThisYr'+ groupedrelationMapThisYr);
               
        for (Account acnt: acclist){
       
            if(groupedrelationMapThisYr.containskey(acnt.id))  {
                acnt.crm_Revenue_This_Year__c = groupedrelationMapThisYr.get(acnt.id);
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
        
        
               
      } 

    }