global class crm_CreatePartyFromProspect implements Database.batchable<sObject>,Database.Stateful
{
    crm_AccountRecordTypes__c rTRelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');
    Id RelationLevelRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTRelation.crm_Record_Type_Label__c).getRecordTypeId();
    crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
    Id PartyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
     
      crm_AccountRecordTypes__c rTProspect= crm_AccountRecordTypes__c.getValues('Prospect');
    Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTProspect.crm_Record_Type_Label__c).getRecordTypeId();
     
     
     public string callback = ''; 
     
      global crm_CreatePartyFromProspect (string callback){
         this.callback = callback;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query='Select id, parentid,Orga__c,crm_Customer_Number__c from Account where Orga__c!=null and parentid=null and Account.RecordTypeid=:RelationLevelRecordTypeId ';
        //id test ='0012000000pDiShAAK';
        //string query='Select id, parentid,Orga__c,crm_Customer_Number__c from Account where id =:test';
        return Database.getQueryLocator(query);     
    } 
    
    
    
    global void execute(Database.BatchableContext BC, List<Account> AccountList)  {
        System.debug('~~AccountList'+AccountList);
        list<Account> ConvertToParty = new list<Account> ();
         list<Account> accountstoUpdate= new list<Account> ();
        Set<String> OrgNumber = new Set<String> ();
        List<User> userList= [Select id from user where alias='aadmi' limit 1];
        for (Account acc:AccountList ){
            If(acc.Orga__c != null){
                  OrgNumber.add(acc.Orga__c) ; 
                
            }
            
        }
        
            if(OrgNumber.size()>0) {
              ConvertToParty = [Select id,Orga__c from Account where Orga__c!=null and RecordTypeid=: ProspectRecordTypeId  and Orga__c in:OrgNumber];  
            }
           
           if(ConvertToParty!=null && ConvertToParty.size()>0)
           { 
           for (Account acc:ConvertToParty)
           {
            acc.recordtypeid=PartyRecordTypeId; 
            if (userList!= null && userList.size()>0) 
                 acc.ownerid= userlist[0].id;
            accountstoUpdate.add(acc);
           }
           
            try{
           Database.update(accountstoUpdate,false); 
            
        }catch(Exception e){
            crm_Exception_handler.createExceptionRecords(e);
        }
           
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
           Database.executeBatch(new crm_MapRelationToParty_Batch(str, RelationLevelRecordTypeId));
        
    }
    
}