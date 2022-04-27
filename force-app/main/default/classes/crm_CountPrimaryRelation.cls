global class crm_CountPrimaryRelation implements Database.batchable<sObject>,Database.Stateful
{
     global Database.QueryLocator start(Database.BatchableContext BC){
     String recordtype=[Select id from RecordType where developername='crm_Party_level_Customer' and SobjectType='Account'].id;
     //String party='0012600000PlDCB';
     String query='Select id, crm_Count_of_Primary_Relation__c from Account where Recordtypeid=:recordtype';
     return Database.getQueryLocator(query);  
     }
     
       global void execute(Database.BatchableContext BC, List<Account> Acclist) {
       System.debug('@@@Acclist@@'+Acclist);
       Set<id> parentidset=new Set<id>();
       Map<id,Integer> PrimaryCount=new Map<id,Integer>();
       String RelationLevelRecordTypeId =[Select id from RecordType where developername='business_account' and SobjectType='Account'].id;
       for(Account ac:Acclist)
           parentidset.add(ac.id);
          
        List<Account> AccountToUpdate=new List<Account>();   
        for(AggregateResult agg : [SELECT Count(id) primaryAcc, ParentId account from account WHERE crm_Primary_Customer_Account__c=true and recordtypeId=:RelationLevelRecordTypeId and ParentId In:parentidset group by ParentId]){
            PrimaryCount.put((Id)agg.get('account'),(Integer)agg.get('primaryAcc'));
        }
        System.debug('@@@map@@'+PrimaryCount);   
        for(Id i:PrimaryCount.Keyset())
        {
            Account acc=new Account();
            acc.id=i;
            acc.crm_Count_of_Primary_Relation__c=PrimaryCount.get(i);
            System.debug('@@@PrimaryCount.get(i)@@'+PrimaryCount.get(i));
            AccountToUpdate.add(acc);
        } 
        
        Database.Update(AccountToUpdate,false);    
       }
       
       global void finish(Database.BatchableContext BC) 
       {
       }
}