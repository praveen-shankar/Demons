/*
* Used to map relation level records to party based on organization number
*/
global class crm_MapRelationToParty_Batch implements Database.batchable<sObject>,Database.Stateful{
    
    public string recordTypeIdStr = NULL;
    public string callback = ''; 
  
  
    global Database.QueryLocator start(Database.BatchableContext BC){
        // Select all relation level accounts (based on the recordtype of the env passed)
        String query = 'Select id, orga__c from Account where parentid=null and recordTypeid=:recordTypeIdStr '; 
        return Database.getQueryLocator(query);                      
    }
    public crm_MapRelationToParty_Batch(string callback ,string recordType){
         this.callback = callback;
        this.recordTypeIdStr = recordType;
    }
    global void execute(Database.BatchableContext BC, List<Account> acclist) {
                Account parentObj = NULL;
            for (Account a: acclist){
                parentObj = new Account();
                // use the upsertkey field which is a concatenation of organization number and 'PARTY' String
                // to construct parent object
                // Note: All party accounts should have this upsertKey field populated before running this batch
                parentObj.crm_upsertKey__c = a.orga__c+'PARTY';
                a.Parent = parentObj;
                // setting up Party Level Account is a must to have this account displayed under party
                a.crm_Party_level_Account__r = parentObj;
                //system.debug('Account ID' + a.id);
                }
            if(acclist.size()>0){
            try{
                Database.update(acclist,false);
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
        
        
        if(!Test.IsRunningTest())
            Database.executeBatch(new crm_DisconnectRelationAccount(str));
       } 
        
    
    
}