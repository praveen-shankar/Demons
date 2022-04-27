/*
Created By:Supriya Goel
Date: 27 th oct 2016
Calculate last year revenue on relation level

*/

global class crm_LastYrRevenueOnRelationAccount_Batch implements Database.batchable<sObject>,Database.Stateful{
    public string callback = '';        
    global crm_LastYrRevenueOnRelationAccount_Batch (String callback){
        this.callback = callback;   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
         crm_AccountRecordTypes__c rTrelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
         Id relationLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTrelation.crm_Record_Type_Label__c).getRecordTypeId();
       
        String query = 'Select id, crm_Revenue_Last_Year__c, currencyisocode  from Account where RecordTypeId = :relationLevelRecordTypeId'; 
        return Database.getQueryLocator(query);                      
    }

    global void execute(Database.BatchableContext BC, List<Account> acclist) {
       
        Set <Id> relationlevelId= new Set<Id>();
        Map<Id,Decimal> groupedrelationMapThisYr = new Map<Id,Decimal>();
        Map<Id,String> accountCurrencyMap = new Map<Id,String>();
        
        for(Account acnt: acclist){ 
            relationlevelId.add(acnt.id) ;
            accountCurrencyMap.put(acnt.id, acnt.currencyisocode) ;
        }  
        //get all the system currency
        Map<String, decimal> currencyMap= new Map<String, decimal>();
        
        List<CurrencyType> currencyList = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE];  
        for (CurrencyType ctype: currencyList ){
            currencyMap.put(ctype.ISOCode, ctype.ConversionRate );
        }
     
        /*to calculate this year*/ 
        
        Map<id, List<crm_revenue_line__c>> acntRevMap= new  Map<id, List<crm_revenue_line__c>>();
        
        
        List<crm_revenue_line__c>  revLines=[Select crm_amount__c ,  crm_account__c, CurrencyISOCode, crm_Transaction_Date__c from  crm_revenue_line__c where crm_account__c in :relationlevelId and crm_Transaction_Date__c =LAST_YEAR] ;
        
        if(revLines.size()>0)     {
            for (crm_revenue_line__c  rev:  revLines)  {
                if(acntRevMap.containsKey (rev.crm_account__c)){
                    List<crm_Revenue_line__c> templist=  new List<crm_revenue_line__c>();
                    templist= acntRevMap.get(rev.crm_account__c);
                    templist.add(rev);
                    acntRevMap.put(rev.crm_account__c, templist);
                
                }else{
                    List<crm_Revenue_line__c> templist=  new List<crm_revenue_line__c>();
                    templist.add(rev);
                    acntRevMap.put(rev.crm_account__c, templist);
                }
            }      
        
        }//end od size check
     
        
        Map<Id, Decimal> AcntRevMapLastyr= new Map<Id, Decimal>();
        
        for ( ID aID : acntRevMap.keySet() ){
             List<crm_Revenue_line__c> templist=acntRevMap.get(aID);
             Decimal total =0;
             for (crm_Revenue_line__c rev:templist){
              // Decimal Amount=rev.crm_amount__c / currencyMap.get(rev.CurrencyISOCode);
                 Decimal Amount=rev.crm_amount__c.divide(currencyMap.get(rev.CurrencyISOCode), 2, System.RoundingMode.UP);
                  total   +=Amount;
             }
             
             String Accountcurrency= accountCurrencyMap.get(aID);
        
             Decimal LastyrRev= total* currencyMap.get(Accountcurrency);
             AcntRevMapLastyr.put(aID, LastyrRev);
                          
        }
       
     /*   for(AggregateResult agg : [SELECT SUM(crm_Amount__c )amount, crm_Account__c  account  FROM crm_Revenue_Line__c WHERE crm_Account__c IN :relationlevelId  AND crm_Amount__c!= NULL and  crm_Transaction_Date__c = LAST_YEAR GROUP BY crm_Account__c]){
            groupedrelationMapLastYr.put((Id)agg.get('account'),(Decimal)agg.get('amount'));
        }
        
          System.debug('@@@groupedrelationMapLastYr'+ groupedrelationMapLastYr);*/
               
        for (Account acnt: acclist){
       
            if(AcntRevMapLastyr.containskey(acnt.id))  {
                acnt.crm_Revenue_Last_Year__c = AcntRevMapLastyr.get(acnt.id);
            }
             else{
             acnt.crm_Revenue_Last_Year__c =0;
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
                
                
                 //send mail 
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
        mail.setSubject('Summary for Weekly batch classes - Revenue last year on Party and relation ');
        mail.setPlainTextBody(str);
        
        // Send the email for the developer reference
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
        
          
      } 

    }