global class crm_coppartytocustomerPerson_Batch implements Database.batchable<sObject>,Database.Stateful{
  
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        String personid=[Select id from RecordType where isPersonType=true and SobjectType='Account' limit 1 ].id;
        String query = 'Select Party_number__c, crm_Customer_Number__c from Account where Party_number__c!=null and recordTypeid=:personid'; 
        return Database.getQueryLocator(query);                      
    }

    global void execute(Database.BatchableContext BC, List<Account> acclist) {
            for (Account a: acclist){
            a.crm_Customer_Number__c =a.Party_number__c;
            
        }
            if(acclist.size()>0){
            try{
                Database.update(acclist,false);
               }catch(Exception e) {   crm_Exception_handler.createExceptionRecords(e);  }
     
        } //end of size
    }       
             
        global void finish(Database.BatchableContext BC) {
        
    }
    
    }