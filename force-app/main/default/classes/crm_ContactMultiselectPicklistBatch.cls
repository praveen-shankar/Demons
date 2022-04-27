global class crm_ContactMultiselectPicklistBatch implements database.Batchable<sobject>, Database.Stateful{
    String recId = [Select Id from recordType where sobjectType = 'Contact' AND DeveloperName like '%Sales%'].Id;
    Integer recordsProcessed = 0;
    global Database.QueryLocator start (Database.batchableContext BC){
        string query= 'Select Id, crm_Has_agreed_to_Marketing_actvities__c ,crm_Has_Agreed_To_Email__c, crm_Has_Agreed_to_SMS__c, Marketing_Activities_Agreed_To__c from contact where crm_Contact_Type__c = \'Sales\' AND RecordTypeId = :recId';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.batchableContext BC, List<Contact> conList){
        List<Contact> conToUpdate = New List<Contact>();
        String agreedTo;
        if(conList.size()>0){
            for(Contact con : conList){
                agreedTo = '';
                if(con.crm_Has_agreed_to_Marketing_actvities__c){
                    if(con.crm_Has_Agreed_To_Email__c){
                    agreedTo += 'Email';
                	}
                
                	If(agreedTo != ''){
                    	agreedTo += ';';
                	}
                
                	if(con.crm_Has_Agreed_to_SMS__c){
                    	agreedTo = agreedTo + 'SMS';
                	}
                
                	system.debug(agreedTo);
                	con.Marketing_Activities_Agreed_To__c = agreedTo;
                	system.debug(con.Marketing_Activities_Agreed_To__c);
                
                	conToUpdate.add(con);
                    recordsProcessed += 1;
                }
                
            }
        }
        update conToUpdate;
    }
    
    global void finish(Database.batchableContext BC){
        system.debug('No of contacts updated : '+recordsProcessed);
           
    }
}