/*
Created By: Supriya Goel
Object  :Agreement
Date: 28 march 2016
Helper class for Agreement Trigger
*/

public class crm_agreementTriggerHelper {
    //create task for agreement when the agrm is active
  /* public static void CreateTask(Map<Id,crm_Agreement__c> oldAggMap, List<crm_Agreement__c> newAggList){  
    
        List<Task> Tasks = new List<Task>(); 
        Set<Id> aggIds= new Set<Id>();
        List<crm_Agreement__c> aggList= new List<crm_Agreement__c>();
        if(Trigger.isInsert && Trigger.isAfter){
            for(crm_Agreement__c agg: newAggList) {
                if (agg.crm_Agreement_Name__c!=null && agg.crm_Agreement_Start_Date__c !=null && agg.crm_Status__c=='Active')
                    aggIds.add(agg.Id);
            }
          
        aggList=[select crm_Account__c ,crm_Agreement_Start_Date__c, crm_Account__r.OwnerId from  crm_Agreement__c  where id in :aggIds ] ; 
        
        List<Opportunity> oppList =[Select id, crm_agreement__c , ownerid from Opportunity where crm_agreement__c in :aggIds order by createddate desc limit 1];
         system.debug('&&&oppList'+ oppList);
        Map<id, id> AggOppMap = new Map<id,id>();
        
        for (Opportunity opp : oppList ){
               if(!AggOppMap.containskey(opp.crm_agreement__c))
                   AggOppMap.put(opp.crm_agreement__c,opp.ownerid);
        }
         system.debug('&&&AggOppMap'+ AggOppMap);
        
            if (aggList.size()>0){
            for (crm_Agreement__c agg : aggList){
            task t = new Task(); 
            t.whatID = agg.id;
            t.Subject = 'Customer Agreement Start Date';
            t.Priority = 'Normal';
            t.Status = 'Not Started';
            t.ActivityDate = agg.crm_Agreement_Start_Date__c +3;
            //t.OwnerId = agg.crm_Account__r.OwnerId; 
            t.OwnerId = AggOppMap.get(agg.id);
            Tasks.add(t)  ;
            }
        } 
    
    }//end of isinsert  
    if(Trigger.isUpdate && Trigger.isAfter){
        for(crm_Agreement__c agg: newAggList) {
            crm_Agreement__c oldagg = oldAggMap.get(agg.Id);
            if(oldagg.crm_Status__c!= agg.crm_Status__c  && agg.crm_Status__c=='Active' && agg.crm_Agreement_Name__c!=null && agg.crm_Agreement_Start_Date__c !=null)
                aggIds.add(agg.Id);
        }
    aggList=[select crm_Account__c ,crm_Agreement_Start_Date__c, crm_Account__r.OwnerId from  crm_Agreement__c  where id in :aggIds ] ; 
    
    List<Opportunity> oppList =[Select id, crm_agreement__c , ownerid  from Opportunity where crm_agreement__c in :aggIds order by createddate desc limit 1];
        Map<id, id> AggOppMap = new Map<id, id>();
        
        system.debug('&&&oppList'+ oppList);
        
        for (Opportunity opp : oppList ){
               if(!AggOppMap.containskey(opp.crm_agreement__c))
                   AggOppMap.put(opp.crm_agreement__c,opp.ownerid);
        }
        
          system.debug('&&&afterupdate'+ AggOppMap);
        
    if (aggList.size()>0){
        for (crm_Agreement__c agg : aggList){ 

            task t = new Task(); 
            t.whatID = agg.id;
            t.Subject = 'Customer Agreement Start Date';
            t.Priority = 'Normal';
            t.Status = 'Not Started';
            t.ActivityDate=agg.crm_Agreement_Start_Date__c+3;
            //t.OwnerId = agg.crm_Account__r.OwnerId;
            t.OwnerId = AggOppMap.get(agg.id); 
            Tasks.add(t)  ;
            }
        } 
    }  //end of isupdate
  
      try{
        if (Tasks.size()>0){
            insert Tasks ;
        }
    }//end of try
       catch(Exception e) { crm_Exception_handler.createExceptionRecords(e) ;}
    }
 */
    //update the opp id for agreeemtn when opp is closed won 
    public static void UpdateAgreementIdinOpp(List<crm_Agreement__c> newAggList){ 
        Set<Id> OppIds = new Set<Id>();
        Map<Id,Id> OppAgrIds= new Map<Id,Id>();
        for (crm_agreement__c agr : newAggList){
            if(agr.crm_Opportunity_Id__c!=null){
                OppAgrIds.put(agr.crm_Opportunity_Id__c, agr.Id) ;
                OppIds.add(agr.crm_Opportunity_Id__c) ;
            }
        }
        
         System.debug('&&& Opplist'+OppAgrIds);
          System.debug('&&& Opplist'+OppIds);
        list<Opportunity> OppList= [Select crm_Agreement__c from opportunity where id in :OppIds];
        System.debug('&&& OppList'+OppList);

        for (Opportunity opp : OppList){
            if (OppAgrIds.containsKey(opp.id)) 
                opp.crm_Agreement__c =OppAgrIds.get(opp.id);

            }
        try{    
        Database.update(OppList, true);
            }//end of try
        catch(Exception e) {crm_Exception_handler.createExceptionRecords(e) ; }
        
        System.debug('&&& Opplist'+OppList);
        }
    
    //update the agreement status to active if the agreement is created today and set parent agr=terminated
 /*   public static void UpdateAgreementStatus(List<crm_Agreement__c> agrlist){  
   
        Set<id> ParentAgrIds = new Set<Id>();
        Set<Id> Accntids= new Set<Id>();
        for(crm_Agreement__c  agr : agrlist){
            Decimal  groupedAmount =0;
            
         
        if(agr.crm_Agreement_Start_Date__c <= System.today()) {
         
            agr.crm_Status__c ='Active';
            agr.crm_not_updated_byBatch__c=true;
            Accntids.add(agr.crm_account__c);
                    
            if(agr.crm_Parent_Agreement__c!=null)
                ParentAgrIds.add(agr.crm_Parent_Agreement__c); 
                   
            }   
            
            agr.crm_Agreement_Start_Date__c =  date.newInstance(agr.crm_Agreement_Start_Date__c.year(),agr.crm_Agreement_Start_Date__c.month(),1);
        } 
     
        List <crm_Agreement__c>  parentagrList=[Select crm_Status__c, crm_not_updated_byBatch__c from crm_Agreement__c where id in :ParentAgrIds];  
        if(parentagrList.size()>0){
          for (crm_Agreement__c  agr: parentagrList )   {
               agr.crm_Status__c ='Terminated';
               agr.crm_not_updated_byBatch__c=true;
         
         } 
        try{
            update parentagrList;
         }catch(Exception e) { crm_Exception_handler.createExceptionRecords(e); }
     
        } //end of size
        
         system.debug('@@@Accntids in setvalues'+ Accntids);    
       // if (Accntids!=null)
        //  SetAccountValues(Accntids);  
      
    }*/
    
     
   //update the opp id for agreeemtn when opp is closed won 
    public static void UpdateLookupfield(List<crm_Agreement__c> agrList){ 
        
        
        for(crm_Agreement__c  agr : agrlist){
            if (agr.crm_status__c =='Active'){
                agr.crm_Active_Agreements__c = agr.crm_Account__c;
                agr.crm_Inactive_Agreements__c = null;
            
            }else{
            
             agr.crm_Active_Agreements__c = null;
             agr.crm_Inactive_Agreements__c = agr.crm_Account__c;
            }
        
        
        }
  
  }
  public static void SetAccountValues(Set<Id> AccntIds ){
           string status ='Active';
        
            List<Account> updatedAcntList= new List<Account>();
            List<Account> AccntList= new List<Account>();
            AccntList=[Select id, crm_Agreement_Contract_Value__c from account where id in :AccntIds ];
            Map<id,Decimal> AccountResults = new Map<id,Decimal>();
            
             
            System.debug('@@ AccountResults 1st time '+AccountResults);  
            for(AggregateResult agg : [Select sum(crm_Agreement_Increased_Contract_Value__c) amount,  crm_Account__c from crm_agreement__c where crm_Agreement_Increased_Contract_Value__c !=null and  crm_status__c =:status and crm_Account__c  in : AccntIds  group by crm_Account__c ]){
                  AccountResults.put((Id)agg.get('crm_Account__c'),(Decimal)agg.get('amount'));
          }        
           System.debug('@@AccountResults'+AccountResults);  
         for (Account acnt: AccntList){
             if(AccountResults.containskey(acnt.id))  {
                acnt.crm_Agreement_Contract_Value__c = AccountResults.get(acnt.id);
            } 
        }
     
       try{     
            if (AccntList.size()>0)
               Database.update (AccntList, false);
        } catch(Exception e) { 
            crm_Exception_handler.createExceptionRecords(e);
         }
    
    
   
     System.debug('@@updatedAcntListin create'+updatedAcntList); 
} 


/*public static void SetAgrNRSD(List<crm_Agreement__c> agrlist){  
  
       Set<Id> Agrids= new Set<Id>();
       Map<id, Id>  OppAgrMap = new Map<id, id>();
             
        for(crm_Agreement__c  agr : agrlist){
           if(agr.crm_Parent_Agreement__c ==null  ||  agr.crm_Parent_Agreement_ID__c== null){
               Agrids.add(agr.id);
               }
           }
       
           List<crm_agreement__c> newList=[select id, crm_New_Revenue_Start_Date__c from  crm_Agreement__c where id in :Agrids  ];
        
           
           List<Opportunity> oppList=[Select  id, crm_Agreement__c,type, crm_Close_Behaviour__c  from opportunity where crm_Agreement__c in :Agrids  and type='Renegotiate' order by createddate desc limit 1 ];
          
           for (Opportunity opp: oppList){
               OppAgrMap.put(opp.crm_agreement__c, opp.id);
           }
           
           
        for(crm_Agreement__c  agr : newList){
         if(OppAgrMap.containsKey(agr.id)){
             agr.crm_New_Revenue_Start_Date__c=null;
         
             }
        
        }  
        
              
       try{    
        Database.update(newList, true);
            }//end of try
        catch(Exception e) {crm_Exception_handler.createExceptionRecords(e) ; }
        
         System.debug('@@agrlist after update '+newList);  
         
             
  }*/
  
  public static void sendToPriceEngine(Set<Id> Agrids){ 
      
  
  List<String> oppIdstosend = new List<String>();
  
  List<Opportunity> oppList=[Select  id, crm_Agreement__c, crm_Callout_Status__c , crm_Verified_by_Contract_Management__c  from opportunity where crm_Agreement__c in :Agrids and crm_Verified_by_Contract_Management__c  =true ];
  for (Opportunity opp: oppList){
  
        opp.crm_Callout_Status__c = 'Callout Pending';
        oppIdstosend.add(opp.id);
      }
      
      System.debug('##oppIdstosend'+ oppIdstosend);
    if(oppIdstosend.size()>0) {
         if(Limits.getQueueableJobs() == 1){
                String hour = String.valueOf(Datetime.now().hour());
                String min = String.valueOf(Datetime.now().minute()); 
                String ss = String.valueOf(Datetime.now().second() + 15);
                //parse to cron expression
                String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
                System.schedule('Agreement master' + String.valueOf(Math.random()), nextFireTime, new crm_agreementIntegrationSchedulable(oppIdstosend));
            }else{
                System.enqueueJob(new crm_agreementIntegrationController(oppIdstosend,null)); 
            }
    
               
        
  
      }
  }


  
  
  
  }