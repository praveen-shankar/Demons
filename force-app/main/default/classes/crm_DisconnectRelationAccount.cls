global class crm_DisconnectRelationAccount implements Database.batchable<sObject>,Database.Stateful
{
    crm_AccountRecordTypes__c rTRelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
    Id RelationLevelRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTRelation.crm_Record_Type_Label__c).getRecordTypeId();
     public string callback = ''; 
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query='Select id, parentid,Orga__c,DisconnectRelationAccount__c,crm_Customer_Number__c from Account where DisconnectRelationAccount__c = false and Account.RecordTypeid=:RelationLevelRecordTypeId';
        return Database.getQueryLocator(query);     
    } 
    
     public crm_DisconnectRelationAccount (string callback){
         this.callback = callback;
        
    }
    
    global void execute(Database.BatchableContext BC, List<Account> AccountList)  {
        System.debug('~~AccountList'+AccountList);
        list<Account> DisconnectRelAcc = new list<Account> ();
        for (Account acc:AccountList ){
            If(acc.DisconnectRelationAccount__c == false){
                acc.ParentId = null; 
                DisconnectRelAcc.add(acc) ; 
                
            }
            
        }
        try{
            if(DisconnectRelAcc.size()>0) {
                Database.update (DisconnectRelAcc , false);
            }
        }catch(Exception e){
            crm_Exception_handler.createExceptionRecords(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) 
    {    
    String str = '';
             crm_AccountRecordTypes__c rTRelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
             String RelationLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTRelation.crm_Record_Type_Label__c).getRecordTypeId();
        AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
        
        if(callback != '' && callback != null)
                  str += callback + '\n';
        if(a != null && a.size() > 0){
                    str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
                }
        
        
        if(!Test.IsRunningTest())
            Database.executeBatch(new crm_setprimayrelationAccount_Batch(str));
        
    }
    
}