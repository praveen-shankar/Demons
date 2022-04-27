/*
Created By: Supriya Goel
Object:Revenue Batch
Date: sprint 6
Batch on the revenue line object which will match the correct agreement
This will execute only once
*/

global class crm_revenueAgreementCustom_batch implements Database.Batchable<SObject>{

        String queryString = '';
         String id= '';
               
        public crm_revenueAgreementCustom_batch (String id){
            this.id = id;
             Integer days=550;
            environment_settings__c datesetting = environment_settings__c.getInstance('Revenue_Agreement_transaction_days');
            System.debug('datesetting ----------'+datesetting);
            days= Integer.valueof(datesetting.value__c);  
            System.debug('days----------'+days);          
            queryString = 'SELECT id,crm_Account__c, crm_Agreement__c, isTransactionDatePrecedeAgrStartDate__c ,crm_Product_Service_Family__c, crm_Agreement_Service_Family__c, crm_Revenue_Type__c, crm_Transaction_Date__c from crm_Revenue_Line__c where id=:id and crm_Transaction_Date__c = LAST_N_DAYS:'+ days+' order by crm_Transaction_Date__c  desc ';            
            System.debug('queryString----------'+queryString);
        
        }
        global Database.QueryLocator start(Database.BatchableContext bcMain){   
            return Database.getQueryLocator(queryString);
        }
        
        global void execute(Database.BatchableContext bcMain, List<crm_Revenue_Line__c> revLinesList){
        
        Set<Id> relationAcntIds = new Set<Id>();
        System.debug('@@revLinesList '+revLinesList );
        //get all account id
        for (crm_Revenue_Line__c rev: revLinesList ){
            relationAcntIds.add(rev.crm_Account__c);      
        
        }
        //String agrStatus ='Active'
       // List<crm_Agreement__c> agreementList = [Select crm_Account__c,crm_Agreement_End_Date__c, crm_Status__c,crm_Agreement_Name__c,crm_Agreement_Service_Family__c,crm_Agreement_Start_Date__c from crm_Agreement__c where crm_Status__c =:agrStatus and  crm_Account__c in (Select parentid from account where id in : relationAcntIds)];
        String Status ='Draft';
            System.debug('@@relationAcntIds '+relationAcntIds );
       List<crm_Agreement__c> agreementList = [Select crm_Account__c,crm_Account__r.Customer_Converted__c,crm_Agreement_End_Date__c, crm_Status__c,crm_Agreement_Name__c,crm_Agreement_Service_Family__c,crm_Agreement_Start_Date__c, crm_New_Revenue_Start_Date__c from crm_Agreement__c where crm_Status__c !=:Status  and crm_Account__c in (Select parentid from account where id in : relationAcntIds) order by crm_Annual_Contract_Value__c desc , crm_status__c asc];
       System.debug('@@agreementList '+agreementList );
          List<Account> ParentaccountList =[Select id , parentid from Account where id in  :relationAcntIds];
            Map<Id,Set<Id>> ParentaccountMap =new Map<Id,Set<Id>>();
            Map<Id,Id> RelationaccountMap =new Map<Id,Id>();
            System.debug('@@ParentaccountList '+ParentaccountList );
            for (Account a: ParentaccountList ){
                if (ParentaccountMap.containsKey(a.parentid)){
                    Set<Id> temp = new Set<id>();
                    temp = ParentaccountMap.get(a.parentid);
                    temp.add(a.id);
                    ParentaccountMap.put(a.parentid,temp) ;
                   
                }
                else {
                    Set<Id> temp = new Set<id>();
                    temp.add(a.id);
                    ParentaccountMap.put(a.parentid,temp) ;
                   
                } 
                RelationaccountMap.put(a.id, a.parentid);
            }
                  System.debug('@@RelationaccountMap '+RelationaccountMap );
            Map<id, List<crm_Agreement__c>> partyAccountAgrMap = new  Map<id, List<crm_Agreement__c>>();
            for (crm_Agreement__c agr: agreementList){
                             
                if (partyAccountAgrMap.containsKey(agr.crm_Account__c)){
                    List<crm_Agreement__c> templist = new List<crm_Agreement__c>();
                    templist = partyAccountAgrMap.get(agr.crm_Account__c);
                    templist.add(agr);
                    partyAccountAgrMap.put(agr.crm_Account__c,templist );
                }
                else {
                    List<crm_Agreement__c> templist = new List<crm_Agreement__c>();
                    templist.add(agr);
                    partyAccountAgrMap.put(agr.crm_Account__c,templist) ;
                } 
                       
              }  
            
            System.debug('@@partyAccountAgrMap '+partyAccountAgrMap );
              
            Map<Id,List<crm_Agreement__c>>  RelationAccountAgrMap = new Map<Id,List<crm_Agreement__c>>();
             
            for (Id parentacntid: ParentaccountMap.keyset() ){
                 Set <Id> relationacntId =ParentaccountMap.get(parentacntid);
                 for (Id relationid: relationacntId ){
                    if(partyAccountAgrMap.containskey(parentacntid)){
                        RelationAccountAgrMap.put(relationid,partyAccountAgrMap.get(parentacntid));
                    
                    }
                 
                 }
         
             }
        
            System.debug('@@RelationAccountAgrMap '+RelationAccountAgrMap );
        //list of all agreements for the accounts 
         
         List<crm_Revenue_Line__c> updatedRevLines= new List<crm_Revenue_Line__c>();
         for (crm_Revenue_Line__c rev: revLinesList ){
            
             if(RelationAccountAgrMap.containskey(rev.crm_Account__c)){
                 List<crm_Agreement__c> agrListtocheck = new List<crm_Agreement__c>();
                 agrListtocheck = RelationAccountAgrMap.get(rev.crm_Account__c);
                    System.debug('@@agrListtocheck '+agrListtocheck );
                 for (crm_Agreement__c agr : agrListtocheck)      {
                  System.debug('### agr  '+agr   + agr.crm_Agreement_Service_Family__c );
                  
                     System.debug('### rev'+rev.crm_Product_Service_Family__c);
                     
                     if(agr.crm_Agreement_Service_Family__c!= null  && rev.crm_Product_Service_Family__c!=null && agr.crm_Agreement_Start_Date__c !=null ){
                     if(agr.crm_Agreement_Service_Family__c.toLowerCase() == rev.crm_Product_Service_Family__c.toLowerCase()){
                       System.debug('@@family matched');
                         System.debug('@@agr'+agr);
                             System.debug('@@rev'+rev);
                             
                           
                     date agrstartDate = date.newInstance(agr.crm_Agreement_Start_Date__c.year(),agr.crm_Agreement_Start_Date__c.month(),1); 
                     System.debug('@@agrstartDate'+agrstartDate); 
                         System.debug('@@agr.crm_Agreement_End_Date__c'+agr.crm_Agreement_End_Date__c); 
                         System.debug('@@rev.crm_Transaction_Date__c'+rev.crm_Transaction_Date__c);
                    if((agr.crm_Agreement_End_Date__c == null && rev.crm_Transaction_Date__c>=agrstartDate ) ||
                       ( agr.crm_Agreement_End_Date__c != null && rev.crm_Transaction_Date__c >=agrstartDate  && rev.crm_Transaction_Date__c<= agr.crm_Agreement_End_Date__c ) || (rev.crm_Transaction_Date__c < agrstartDate && agr.crm_Account__r.Customer_Converted__c == 'Converted'))

                           {
                           
                           
                             rev.crm_Agreement__c = agr.id;
                               System.debug('@@ rev.crm_Agreement__c'+rev.crm_Agreement__c);
                               System.debug('@@ rev.crm_Transaction_Date__c'+rev.crm_Transaction_Date__c);
                               System.debug('@@ agrstartDate'+agrstartDate);
                               System.debug('@@ agr.crm_Account__r.Customer_Converted__c'+agr.crm_Account__r.Customer_Converted__c);

                            if(rev.crm_Transaction_Date__c < agrstartDate && agr.crm_Account__r.Customer_Converted__c == 'Converted'){
                                System.debug('INSIDE rev.crm_Transaction_Date__c'+rev.crm_Transaction_Date__c);
                               System.debug('INSIDE@@ agrstartDate'+agrstartDate);
                               System.debug('INSIDE@@ agr.crm_Account__r.Customer_Converted__c'+agr.crm_Account__r.Customer_Converted__c);
                                rev.isTransactionDatePrecedeAgrStartDate__c = true; 
                            }
                        // if (agr.crm_New_Revenue_Start_Date__c >= System.today().addYears(-1))
                         //if (agr.crm_New_Revenue_Start_Date__c >= rev.crm_Transaction_Date__c .addYears(-1))
                        // trans date >= agm date  &&  transs sate should be less tha = agm date  +1 year 
                         if( rev.crm_Transaction_Date__c >=agr.crm_New_Revenue_Start_Date__c  &&  rev.crm_Transaction_Date__c < agr.crm_New_Revenue_Start_Date__c.addYears(1) )
                            rev.crm_Revenue_Type__c = 'New' ;  //getRevenuetype(sales.crm_Invoice_Date__c);
                        else
                            rev.crm_Revenue_Type__c = 'Existing' ;  //getRevenuetype(sales.crm_Invoice_Date__c);    
                           //  updatedRevLines.add(rev);
                             break;
                     
                     }//end of agr dates check
                    else {
                    System.debug('%%%'+ rev);
                     rev.crm_Agreement__c =null;
                     rev.crm_Revenue_Type__c ='';
                     System.debug('@@rev for delink '+rev);
                      }
                     
                       System.debug('@@rev'+agr.crm_New_Revenue_Start_Date__c);
                    
                 
                     
                } //end of service family check, if sf does not match then delink the agreement from revenue
                
                else { //delink the agr
                if(agr.id==rev.crm_Agreement__c) {
                     rev.crm_Agreement__c =null;
                      rev.crm_Revenue_Type__c ='';
                      
                       System.debug('@@rev for delink '+rev);
                       }
                   }
                }//end of null check for both  
                 else {
                     rev.crm_Agreement__c =null;
                      rev.crm_Revenue_Type__c ='';
                      
                       System.debug('@@rev for delink '+rev);
                      }
                
                  
                   System.debug('@@rev on line 129'+rev);     
                      
                 
                 }//end of agr for
               } //end of if agr check 
               
                 updatedRevLines.add(rev);
                 
             }//end of rev line
              try{
              
               Database.update (updatedRevLines, false);
            System.debug('@@revLinesList'+updatedRevLines);
           }catch(Exception e) {   crm_Exception_handler.createExceptionRecords(e);   }   
        
        }
        global void finish(Database.BatchableContext bc){
            String str = '';
            AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
            
               
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
        mail.setSubject('Revenue agreement batch notification');
        mail.setPlainTextBody(str);
        
        // Send the email for the developer reference
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });         
                    
           
                 
            }
    
    }