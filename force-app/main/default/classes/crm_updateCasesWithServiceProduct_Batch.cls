/**@author  - Rajeev Shekhar      
       @description - This batch class will update Cases with new Product references.
       @date - 17 August 2016
**/


global class crm_updateCasesWithServiceProduct_Batch implements Database.Batchable<SObject>{
    
    Boolean makeProduct2Null = NULL;
    Boolean firstRun = NULL;
    String query = '';
    
    public crm_updateCasesWithServiceProduct_Batch(Boolean makeProduct2Null,Boolean firstRun,Integer year){
       
       if(year == 2013 || year == 2014 || year == 2015 || year == 2016){
           query = 'SELECT Id,ProductId,Service_Product__c FROM Case WHERE ProductId != NULL AND crm_Year__c = ' + year;
       }
       
       if(year == 2012){
           year++;
           query = 'SELECT Id,ProductId,Service_Product__c FROM Case WHERE ProductId != NULL AND crm_Year__c < ' + year;
       }
       
       this.makeProduct2Null = makeProduct2Null;
       this.firstRun = firstRun;      
    }
    
    
    
    //Start method
    global Database.QueryLocator start(Database.BatchableContext bcMain){   
        return Database.getQueryLocator(query);
    } 
    
    //Execute Method
    global void execute(Database.BatchableContext bcMain, list<Case> cases){
        
        List<Case> toUpdateCases = new List<Case>();
        
        Map<Id,Id> serviceProductMap = new  Map<Id,Id>();
        
        for(Service_Product__c s : [SELECT Id, Product2Id__c FROM Service_Product__c]){
            if((s.Product2Id__c != NULL) && (!serviceProductMap.containsKey(s.Product2Id__c))) 
                serviceProductMap.put(s.Product2Id__c,s.Id);
        }
        
       for(Case cc : cases){  
           if((serviceProductMap.containsKey(cc.ProductId)) && (serviceProductMap.get(cc.ProductId) != NULL)){
               if(firstRun)
                   cc.Service_Product__c = serviceProductMap.get(cc.ProductId);
               if(makeProduct2Null)
                   cc.ProductId = NULL;
               
               toUpdateCases.add(cc);
           }     
       }
           
       
       if(toUpdateCases.size() > 0)
           update toUpdateCases;          
    
    }
    
    
     //Finish Method
    global void finish(Database.BatchableContext bc){
        /*AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('Batch Processing : Case Update');
        mail.setSubject('Batch Process Id: '+a.Id+' '+a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/   
    }
    
}