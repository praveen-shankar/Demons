global class crm_updateorgno_Batch implements Database.batchable<sObject>,Database.Stateful{
  
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
        crm_AccountRecordTypes__c rTRelation = crm_AccountRecordTypes__c.getValues('Relation level Customer');
        crm_AccountRecordTypes__c rTprospect = crm_AccountRecordTypes__c.getValues('Prospect');
        
        Id PartyLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
        Id RelationLevelRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTRelation.crm_Record_Type_Label__c).getRecordTypeId();
        Id ProspectLevelRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTprospect.crm_Record_Type_Label__c).getRecordTypeId();
        
        String query = 'Select id,Orga__c from Account where (recordTypeid=:PartyLevelRecordTypeId or recordTypeid=:RelationLevelRecordTypeId or recordTypeid=:ProspectLevelRecordTypeId) and Orga__c!=null and crm_orgnumber_has_characters__c = true'; 
        return Database.getQueryLocator(query);                      
    }

    global void execute(Database.BatchableContext BC, List<Account> acclist) {
     String fixAccNo = '';
            for (Account a: acclist)
            {
                fixAccNo = a.Orga__c.replaceAll('[^0-9]', '');
                a.Orga__c=fixAccNo;
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