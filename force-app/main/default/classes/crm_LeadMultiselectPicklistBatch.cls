global class crm_LeadMultiselectPicklistBatch implements database.Batchable<sobject>, Database.Stateful{
    Integer recordsProcessed = 0;
    
    global Database.QueryLocator start (Database.batchableContext BC){
        string query= 'Select Id, crm_Has_Agreed_to_Marketing_Activities__c ,crm_Has_Agreed_to_Emai__c, crm_Has_Agreed_to_SMS__c, Marketing_Activities_Agreed_To__c from lead';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.batchableContext BC, List<Lead> LeadList){
        List<Lead> LeadToUpdate = New List<Lead>();
        String agreedTo;
        if(LeadList.size()>0){
            for(Lead l : LeadList){
                agreedTo = '';
                if(l.crm_Has_Agreed_to_Marketing_Activities__c){
                    if(l.crm_Has_Agreed_to_Emai__c){
                    agreedTo += 'Email';
                	}
                
                	If(agreedTo != ''){
                    	agreedTo += ';';
                	}
                
                	if(l.crm_Has_Agreed_to_SMS__c){
                    	agreedTo = agreedTo + 'SMS';
                	}
                
                	system.debug(agreedTo);
                	l.Marketing_Activities_Agreed_To__c = agreedTo;
                	system.debug(l.Marketing_Activities_Agreed_To__c);
                
                	LeadToUpdate.add(l);
                    recordsProcessed += 1;
                }
                
            }
        }
        update LeadToUpdate;
    }
    
    global void finish(Database.batchableContext BC){
        system.debug('No of contacts updated : '+recordsProcessed);
           
    }
}