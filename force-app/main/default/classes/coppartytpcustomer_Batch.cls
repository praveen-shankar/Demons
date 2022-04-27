global class coppartytpcustomer_Batch implements Database.batchable<sObject>,Database.Stateful{
  
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        crm_AccountRecordTypes__c rTRelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
        Id RelationLevelRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_party_level_customer).getRecordTypeId();
        // Id RelationLevelRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTRelation.crm_Record_Type_Label__c).getRecordTypeId();
        String query = 'Select Party_number__c, crm_Customer_Number__c from Account where Party_number__c!=null and recordTypeid!=\'012w000000072at\' and crm_customer_number__c=null'; 
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