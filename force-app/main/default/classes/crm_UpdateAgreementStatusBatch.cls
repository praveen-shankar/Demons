/*
Created By:Supriya Goel
Date: 20 June 2016 (Sprint 5)
Agreement should be activated on the “Agreement Start Date” and at that point the “parent agreement” should be set to Terminated. 

*/

global class crm_UpdateAgreementStatusBatch implements Database.batchable<sObject>,Database.Stateful{
    public string callback = '';    
    global crm_UpdateAgreementStatusBatch(String callback){
    this.callback = callback;   
    }
     
    global Database.QueryLocator start(Database.BatchableContext BC){
        string status='Draft';
        String query = 'Select crm_Agreement_Start_Date__c,crm_not_updated_byBatch__c,crm_Parent_Agreement__c,crm_Status__c from crm_Agreement__c  where crm_Agreement_Start_Date__c <= TODAY  and crm_Status__c =:Status '; 
        //Nikita:removed and crm_not_updated_byBatch__c=false from the query condition [15-03-2017].
        //and crm_Agreement_End_Date__c <= :Date.today()
        return Database.getQueryLocator(query);                      
    }

      
    global void execute(Database.BatchableContext BC, List<crm_Agreement__c> agrlist) {
        Set<id> ParentAgrIds = new Set<Id>();
        for(crm_Agreement__c  agr : agrlist){    
         
            agr.crm_Status__c ='Active';
            agr.crm_not_updated_byBatch__c=true;
            if(agr.crm_Parent_Agreement__c!=null)
                ParentAgrIds.add(agr.crm_Parent_Agreement__c); 
                   
            }   
            
            List <crm_Agreement__c>  parentagrList=[Select crm_Status__c, crm_not_updated_byBatch__c from crm_Agreement__c where id in :ParentAgrIds];  
            if(parentagrList.size()>0){
              for (crm_Agreement__c  agr: parentagrList )   {
                   agr.crm_Status__c ='Terminated';
                   agr.crm_not_updated_byBatch__c=true;
             
             } 
            }//end of size
            try{
               if(parentagrList.size()>0)  
                 update parentagrList;
               if(agrlist.size()>0)  
               Database.update (agrlist, false);
            }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }

    
    }
                   
        global void finish(Database.BatchableContext BC) {
        String str = '';
        AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:BC.getJobId()];
        if(callback != '' && callback != null)
                  str += callback + '\n';
        
        if(a != null && a.size() > 0){
                    str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
                }
        
        if(!Test.IsRunningTest())
            Database.executeBatch(new crm_revenueAgreement_batch(str));
        
        } 

    }