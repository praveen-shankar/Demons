/*
Created By:Supriya Goel
Date: 29 March 2016 (Sprint 5)
update the value for the Agreement Contract Conversion calculation:
Agreement Contract Conversion % - is Recognized Revenue / (days since Agreement Start Date * (Agreement Contracted Value / 365))

*/

global class crm_AgreementCalculationBatch implements Database.batchable<sObject>{
        
    public string callback = '';      
    
    global crm_AgreementCalculationBatch (String callback){
        this.callback = callback;   
       
    }
     
    global Database.QueryLocator start(Database.BatchableContext BC){
        string status='Active';
     
                            
        //select all agreements  which are active and crm_days = TODAY()- crm_Agreement_Start_Date__c (no of days agreement started)
        String query = 'Select id, crm_Days__c, crm_Agreement_Contract_Conversion__c,crm_Realized_Contract_Value__c, crm_Annual_Contract_Value__c,crm_Status__c, Expected_Realized_Amount__c   from crm_Agreement__c where crm_Status__c= :status  and crm_Days__c >0 ' ; 
        return Database.getQueryLocator(query);                      
    }

      
    global void execute(Database.BatchableContext BC, List<crm_Agreement__c> agrlist) {
     
           for(crm_Agreement__c  agr : agrlist){    
         
            if(agr.Expected_Realized_Amount__c !=null && agr.Expected_Realized_Amount__c >0 && agr.crm_Realized_Contract_Value__c >0 && agr.crm_Realized_Contract_Value__c !=null) {
                         
               Decimal temp1 =   agr.crm_Realized_Contract_Value__c / agr.Expected_Realized_Amount__c ; 
               agr.crm_Agreement_Contract_Conversion__c= (temp1*100 ).setScale(2);
                
                //agr.crm_Agreement_Contract_Conversion__c=((agr.crm_Realized_Contract_Value__c/ (DaysSinceStart * (agr.crm_Annual_Contract_Value__c/365)))*100).setScale(2);
                //  agr.crm_Agreement_Contract_Conversion__c=(agr.crm_Realized_Contract_Value__c/ ((agr.crm_Days__c * (agr.crm_Annual_Contract_Value__c/365)))).setScale(2);
                
            }
            else
            {
                 agr.crm_Agreement_Contract_Conversion__c=0;
            }
           
                                            
        }//end of for  
         try{ 
       
                Database.update (agrlist);
        }catch(Exception e) { crm_Exception_handler.createExceptionRecords(e);}
        
        
             
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
            Database.executeBatch(new crm_NoRevenueAgreementNotification(str));
        } 

    }