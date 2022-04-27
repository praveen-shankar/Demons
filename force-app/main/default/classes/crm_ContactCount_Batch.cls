/*
Created By:Supriya Goel
Date: 30 jan 2018
count of opportunities, cases,activities on contact

*/

global class crm_ContactCount_Batch implements Database.batchable<sObject>
{    
    
    public string callback = '';        
    global crm_ContactCount_Batch (String callback){
        this.callback = callback;   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query = 'Select id, crm_Activities_Count__c,crm_Case_Count__c , crm_Opportunity_Count__c, crm_Campaign_Count__c, crm_Email_Sent_Count__c from Contact order by lastmodifieddate desc'; 
        return database.getquerylocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> ContactList) {
    Set<Id> contactIds = new  Set<Id>(); 
    Map<Id,Integer> taskcount= new Map<Id,Integer>();
    Map<Id,Integer> eventcount= new Map<Id,Integer>();
    Map<Id,Integer> opportunitycount= new Map<Id,Integer>();
    Map<Id,Integer> casecount= new Map<Id,Integer>();
    Map<Id,Integer> campaigncount= new Map<Id,Integer>();
    Map<Id,Integer> emailsentcount= new Map<Id,Integer>();
    
     for (Contact c: ContactList)
        contactIds.add(c.id);
        
        for(AggregateResult agg : [SELECT count(id) countTask, whoid contactid   FROM Task WHERE whoid in :contactIds group by whoid  ]){
            taskcount.put((Id)agg.get('contactid'),(Integer)agg.get('countTask'));
        }
        
        
        for(AggregateResult agg : [SELECT count(id) countEvent, whoid contactid   FROM Event WHERE whoid in :contactIds group by whoid  ]){
            eventcount.put((Id)agg.get('contactid'),(Integer)agg.get('countEvent'));
        }
        
         for(AggregateResult agg : [SELECT count(id) opportunitycount, contactid contactidtemp   FROM Opportunitycontactrole WHERE contactid in :contactIds group by contactid  ]){
            opportunitycount.put((Id)agg.get('contactidtemp'),(Integer)agg.get('opportunitycount'));
        }
        
        for(AggregateResult agg : [SELECT count(id) casecount, contactid contactidtemp   FROM case WHERE contactid in :contactIds group by contactid  ]){
            casecount.put((Id)agg.get('contactidtemp'),(Integer)agg.get('casecount'));
        }
        
         for(AggregateResult agg : [SELECT count(id) campaigncount, contactid contactidtemp   FROM CampaignMember  WHERE contactid in :contactIds group by contactid  ]){
            campaigncount.put((Id)agg.get('contactidtemp'),(Integer)agg.get('campaigncount'));
        }
        
        for(AggregateResult agg : [SELECT count(id) emailcount, et4ae5__Contact__c contactidtemp   FROM et4ae5__IndividualEmailResult__c WHERE et4ae5__Contact__c in :contactIds group by et4ae5__Contact__c ]){
            emailsentcount.put((Id)agg.get('contactidtemp'),(Integer)agg.get('emailcount'));
        }
        
         
        
          //Select id , ContactId  from CampaignMember  where contactid='0030E00000GBegJ'
    
     System.debug('###taskcount'+ taskcount);
      System.debug('###eventcount'+ eventcount);
       System.debug('###opportunitycount'+ opportunitycount);
        System.debug('###casecount'+ casecount);
      
        
        for (Contact c: ContactList){
         Integer taskcount1=0;
         Integer eventcount1=0;
         if (taskcount.containskey(c.id))
             taskcount1=  taskcount.get(c.id);
            
             
          if (eventcount.containskey(c.id))
             eventcount1=  eventcount.get(c.id); 
             
           c.crm_Activities_Count__c   = taskcount1+ eventcount1;
           
           
            if (opportunitycount.containskey(c.id))
             c.crm_Opportunity_Count__c =  opportunitycount.get(c.id);
             else
             c.crm_Opportunity_Count__c = 0;
             
          if (casecount.containskey(c.id))
             c.crm_Case_Count__c =  casecount.get(c.id); 
          else c.crm_Case_Count__c = 0;
          
          
          if (campaigncount.containskey(c.id))
             c.crm_Campaign_Count__c=  campaigncount.get(c.id); 
          else c.crm_Campaign_Count__c= 0;
          
           if (emailsentcount.containskey(c.id))
             c.crm_Email_Sent_Count__c=  emailsentcount.get(c.id); 
          else c.crm_Email_Sent_Count__c= 0;
           
        
        }
        
          if(ContactList.size()>0){
            try{
                Database.update (ContactList, false);
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