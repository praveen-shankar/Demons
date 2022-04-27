public class AccountController 
{
    // This function accepts a String
    // This function will remove the whitespaces and dots (.) in the Bank Account Number
    // After processing the function will return the fixed account number
    public static String fixBankAccountNumber(String accNo)
    {
        String fixAccNo = '';                       // temporary string to hold processed account number
        if(accNo != null)                           // Null check before processing String Methods
        {
            fixAccNo = accNo.replaceAll('[^0-9]', '');
        }

        return fixAccNo;
    }
    
    public class AccountController_Before_Insert implements TriggerDispatcher.ITriggerEntry {
        public void MainEntry(String TriggerObject,
        boolean IsBefore, Boolean IsDelete,
        Boolean IsAfter, Boolean IsInsert,
        Boolean IsUpdate, Boolean IsExecuting,
        List<Sobject> newList, Map<Id, SObject> newMap,
        List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            List<Account> accNewList = (List<Account>)newList;
            List<Account> accOldList = (List<Account>)newList;
            Map<Id, Account> accNewMap = (Map<Id, Account>)newMap;
            Map<Id, Account> accOldMap = (Map<Id, Account>)oldMap;
            Data_Loader_Process__c IsProcessOn;
            for(Account newAccount : accNewList) 
            {
                // Fix Bank Account Number if available
                if(String.isNotBlank(newAccount.Bankkontonummer__c))
                {
                    newAccount.Bankkontonummer__c = AccountController.fixBankAccountNumber(newAccount.Bankkontonummer__c);
                }

                //Check custom setting if customers are Upserted using Data Loader process.
                if(!test.isrunningtest())
                   IsProcessOn = Data_Loader_Process__c.getValues('Process Is On');
                else
                    {
                        IsProcessOn=new Data_Loader_Process__c();
                        IsProcessOn.Status__c=false;
                    }
                //Check if customer is to be updated from eConnect, no DML only future
                if(String.isNotEmpty(newAccount.crm_customer_number__c) && System.isBatch()==false && !IsProcessOn.Status__c) {
                    if(Test.isRunningTest()) {
                        newAccount.status_update__c = 'Ready for update';
                        newAccount.last_updated__c = DateTime.now();
                    } else if(System.isFuture()){
                        newAccount.status_update__c = 'Never updated';
                    } 
                    else {
                        DataPersistencyController.updateAccount(newAccount.Id);
                    }
                }
            }
        }
        
        public void InProgressEntry(String TriggerObject,
        boolean IsBefore, Boolean IsDelete,
        Boolean IsAfter, Boolean IsInsert,
        Boolean IsUpdate, Boolean IsExecuting,
        List<Sobject> newList, Map<Id, SObject> newMap,
        List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            return;
            /*List<Account> accNewList = (List<Account>)newList;
            List<Account> accOldList = (List<Account>)newList;
            Map<Id, Account> accNewMap = (Map<Id, Account>)newMap;
            Map<Id, Account> accOldMap = (Map<Id, Account>)oldMap;
            
            return;*/
        }
    }
    
    public class AccountController_Before_Update implements TriggerDispatcher.ITriggerEntry {
        public void MainEntry(String TriggerObject,
        boolean IsBefore, Boolean IsDelete,
        Boolean IsAfter, Boolean IsInsert,
        Boolean IsUpdate, Boolean IsExecuting,
        List<Sobject> newList, Map<Id, SObject> newMap,
        List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            List<Account> accNewList = (List<Account>)newList;
            List<Account> accOldList = (List<Account>)newList;
            Map<Id, Account> accNewMap = (Map<Id, Account>)newMap;
            Map<Id, Account> accOldMap = (Map<Id, Account>)oldMap;
            
            for(Account newAccount : accNewList) 
            {
                // Fix Bank Account Number if available
                if(String.isNotBlank(newAccount.Bankkontonummer__c))
                {
                    newAccount.Bankkontonummer__c = AccountController.fixBankAccountNumber(newAccount.Bankkontonummer__c);
                }
                
                //Check if customer is to be updated from eConnect, no DML only future
                if(String.isNotEmpty(newAccount.crm_customer_number__c) && String.isNotEmpty(newAccount.status_update__c) && newAccount.status_update__c.equals('Updating')) {
                    if (newAccount.status_update__c != accOldMap.get(newAccount.id).status_update__c){
                        if(Test.isRunningTest()) {
                            newAccount.status_update__c = 'Ready for update';
                            newAccount.last_updated__c = DateTime.now();
                        } else {
                            DataPersistencyController.updateAccount(newAccount.Id);
                        }
                    }
                }
            }
        }
        
        public void InProgressEntry(String TriggerObject,
        boolean IsBefore, Boolean IsDelete,
        Boolean IsAfter, Boolean IsInsert,
        Boolean IsUpdate, Boolean IsExecuting,
        List<Sobject> newList, Map<Id, SObject> newMap,
        List<SObject> oldList, Map<ID,SObject> oldMap)
        {
            return;
            /*List<Account> accNewList = (List<Account>)newList;
            List<Account> accOldList = (List<Account>)newList;
            Map<Id, Account> accNewMap = (Map<Id, Account>)newMap;
            Map<Id, Account> accOldMap = (Map<Id, Account>)oldMap;
            
            return;*/
        }
    }
}