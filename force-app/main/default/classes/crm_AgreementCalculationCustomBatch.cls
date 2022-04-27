/*
Created By:Supriya Goel
Date: 29 March 2016 (Sprint 5)
update the value for the Agreement Contract Conversion calculation:
Agreement Contract Conversion % - is Recognized Revenue / (days since Agreement Start Date * (Agreement Contracted Value / 365))

*/

global class crm_AgreementCalculationCustomBatch implements Database.batchable<sObject>{
        
    public string id = '';      
    
    global crm_AgreementCalculationCustomBatch (String id){
        this.id = id;   
       
    }
     
    global Database.QueryLocator start(Database.BatchableContext BC){
                                  
        //select all agreements  which are active and crm_days = TODAY()- crm_Agreement_Start_Date__c (no of days agreement started)
        String query = 'Select id, crm_Days__c, crm_Agreement_Contract_Conversion__c,crm_Realized_Contract_Value__c, crm_Annual_Contract_Value__c,crm_Status__c from crm_Agreement__c  where id=:id ' ; 
        return Database.getQueryLocator(query);                      
    }

      
    global void execute(Database.BatchableContext BC, List<crm_Agreement__c> agrlist) {
    Integer  DaysSinceStart =365;
    
              for(crm_Agreement__c  agr : agrlist){    
         
            if(agr.crm_Annual_Contract_Value__c !=null && agr.crm_Annual_Contract_Value__c >0 && agr.crm_Realized_Contract_Value__c >0 && agr.crm_Realized_Contract_Value__c !=null) {
            if (agr.crm_Days__c <=365)
               DaysSinceStart= Integer.valueof(agr.crm_Days__c);
               else 
                DaysSinceStart =365;
               
               
               Decimal temp1 =   DaysSinceStart * agr.crm_Annual_Contract_Value__c / 365; 
               Decimal temp2 =   agr.crm_Realized_Contract_Value__c/temp1; 
               Decimal temp3 = (temp2*100 ).setScale(2);
               agr.crm_Agreement_Contract_Conversion__c= temp3;
                
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
                   
        global void finish(Database.BatchableContext BC) {}
       

    }