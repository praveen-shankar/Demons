/**
 *  This class is used by Odigo_WebService to find Accounts in Salesforce associated with a phone number
 *  The phone number might be registrered directly with the Account or indirectly by a Contact associated with the Account.
 *  The phone number might be a regular Phone, MobilePhone, OtherPhone, Fax or AssistantPhone
 *  Last Modified By Rajeev S, 23 June 2017, CTI Project
 */


public with sharing class Odigo_CustomerInfo {
    //This string will hold all the possible numbers but removing aditional zeroes from the beginning of the number
    private String numberList;     
    public Enum ResultStatus { NOT_FOUND, MULTIPLE_RESULTS, OK }
    public Enum ResultAccountType { BUSINESS_ACCOUNT, PERSON_ACCOUNT }
    public static String POSTEN_GLOBAL_ADRESSELISTE = KATSutilities.getGlobalAddressListName();
    public static String CRM_STATUS_VIP = 'VIP';
    public static String CRM_STATUS_STORKUNDE= 'Storkunde';
    
    /*
      * Helper class for the search/query methods to set various statuses based on query size
      *
    */
    public class SearchResult {
        public ResultStatus status {get; set;}
        public ResultAccountType accountType {get; set;}
        public Account account {get; set;} 
        
        public SearchResult(List<Account> accounts) {
            if(accounts.size() == 1) {
                account = accounts.get(0);
                status = ResultStatus.OK;
            } else if(accounts.size() > 1){
                status = ResultStatus.MULTIPLE_RESULTS;
            } else {
                status = ResultStatus.NOT_FOUND;
            }
            
            if(account != null && account.IsPersonAccount) {
                accountType = ResultAccountType.PERSON_ACCOUNT;
            } else {
                accountType = ResultAccountType.BUSINESS_ACCOUNT;
            }
        }       
    }
    
    /**
     * Gets the Account associated with a phone number or Account associated by a Contact whose number is aPhoneNumber
     * 
     * This method will return a business account from KATS if it exists possibly copying a business account from the
     * the back systems
     * 
     * If there is no business accounts with the associated phone number, it will try to return a person account 
     * with the associated phone number. 
     *
     * If there exists multiple occurances, the method will return null. Unless the option checkPriority is true, 
     * in which case it will try to return an account with KS_status equal VIP or Storkunde, otherwise null.
     * The caller will then have to deal with the multiple accounts situation, for instance by returning
     * an URL to the Customer search page.
     *  
     * @param aPhoneNumber like regular phone, mobile phone, fax etc.
     * @return the Account or null if no or multiple instances where found
     */
    public Account getAccountByAPhoneNumber(String aPhoneNumber, boolean checkPriority){
        SearchResult result = getBusinessAccount(aPhoneNumber, checkPriority); 
        if(result.status == ResultStatus.NOT_FOUND) { // could not find BusinessAccount
            result = getPersonAccount(aPhoneNumber);
        }
        
        return (result != null ? result.account : null);    
    }

    
    public SearchResult getBusinessAccount(String aPhoneNumber, boolean checkPriority) {
        SearchResult result = findAccountfromContactByAPhoneNumber(aPhoneNumber, checkPriority); 
        if(result == null){
            boolean isPersonAccount = false;
            result = findAccountByAPhoneNumber(aPhoneNumber, isPersonAccount, checkPriority);
        }
        return result;
    }
    
    public SearchResult getPersonAccount(String aPhoneNumber) {
        boolean isPersonAccount = true;
        boolean checkPriority = false;
        SearchResult result = findAccountByAPhoneNumber(aPhoneNumber, isPersonAccount, checkPriority);
        return result;            
    }
    
   
    /*
    * Finds a business Contact with the given phone number.
    *
    * If no account found: return null.
    * If one account found: return acccount.
    * If more than one account found:
    *  If checkPriority is false: return null
    *  If checkPriority is true: It will try to return an account with CRM Status 'VIP' or 'Storkunde', otherwise it returns null
    */
    private SearchResult findAccountFromContactByAPhoneNumber(String aPhoneNumber, boolean checkPriority) {
       List<Account> accountList=null;
       if(Test.isRunningTest()){
       accountList = [Select a.Id, a.Orga__c, a.DUNS_number__c, a.CRMStatus__c, a.isPersonAccount, a.Sector__c 
            From Account a 
            where a.Id in (
            select Contact.AccountId
            from Contact c 
            where (Contact.Phone = :aPhoneNumber
            or Contact.MobilePhone = :aPhoneNumber
            or Contact.OtherPhone = :aPhoneNumber
            or Contact.Fax = :aPhoneNumber
            or Contact.AssistantPhone = :aPhoneNumber)
            and AccountId != null
            and isPersonAccount = false
            and Account.id!=:POSTEN_GLOBAL_ADRESSELISTE)
            ]; 
       } else {
            
            //Creating list of possible numbers (truncating additional zeroes)
            numberList = getAllPossiblePhoneNumbers(aPhoneNumber);
            
            List<List<SObject>> ContactssearchList = [FIND :numberList IN PHONE FIELDS RETURNING Contact (AccountID where isPersonAccount=false and AccountID!=:POSTEN_GLOBAL_ADRESSELISTE)];
            List<Contact> contacts = ((List<Contact>)ContactssearchList[0]);
            List<ID> AccountIDList = new List<ID>();
            
            for(contact c: contacts){
                AccountIDList.add(c.accountID);
            }
            accountList =
                [Select a.Id, a.Orga__c, a.DUNS_number__c,
                a.CRMStatus__c, a.isPersonAccount, a.Sector__c
                From Account a where a.Id in :AccountIDList];  
       }        
         
        if(accountList.size() > 0) {
            SearchResult result;
            if(checkPriority){
                result = getAccountByPriority(accountList);
            } else {
                result = new SearchResult(accountList);
            }
            
            if(result != null && result.status == ResultStatus.OK){
                return result;
            } 

        }
        return null;
    }
    
    private SearchResult findAccountByAPhoneNumber(String aPhoneNumber, boolean isPersonAccount, boolean checkPriority) {
         List<Account> accountList=null;
        if(Test.isRunningTest()){
        accountList = [select a.Id, a.isPersonAccount, a.CRMStatus__c, a.Sector__c, a.Orga__c, a.DUNS_number__c
                from Account a 
                where (a.Phone = :aPhoneNumber
                or a.Fax = :aPhoneNumber)
                and isPersonAccount = :isPersonAccount
                and id!=:POSTEN_GLOBAL_ADRESSELISTE
                ];
        } 
        else 
        {
              
                //Creating list of possible numbers (truncating additional zeroes)
                numberList = getAllPossiblePhoneNumbers(aPhoneNumber);
                
                List<List<SObject>> accountSearchList=[FIND :numberList IN PHONE FIELDS returning Account(Id, isPersonAccount, CRMStatus__c, Sector__c, Orga__c, DUNS_number__c
                    where isPersonAccount=:isPersonAccount and id!=:POSTEN_GLOBAL_ADRESSELISTE)];
                accountList=((List<Account>)accountSearchList[0]);
                
        }
        SearchResult result;
        if(!isPersonAccount && checkPriority){ // Only sort by priority (VIP,Storkunde) if the account is a business account.
            result = getAccountByPriority(accountList);
        } else {
            result = new SearchResult(accountList);
        }
        return result;
    }
    
    /*
    * This function will follow the below mentioned logic
    * If there is only one account with the linked phone number, simple send the status of that account.
    * If there are more than one accounts linked to the mentioned phone number, check the highest status in all the account and send it back.
    * The method will first try to search for VIP-accounts, secondly Storkunde-accounts.
    * If the input is an empty list, the method will directly return a SearchResult with ResultStatus NOT_FOUND. 
    * 
    * Priority when searching for VIP/Storkunde accounts
    *
    * Step 1: Search the list accList for any account with CRM-status VIP
    * Step 2: Search the list accList for any account with CRM-status Storkunde
    * Step 3: If no VIP or Storkunde account is found, return all accounts in accList
    */
  
    private SearchResult getAccountByPriority(List<Account> accList)
    {       
        if(accList.size() > 0)
        {
            //  Step 1: Search the list accList for any account with CRM-status VIP
            for(Account a: accList)
            {
                if(a.CRMStatus__c == CRM_STATUS_VIP)
                {
                    List<Account> acc = new List<Account>();
                    acc.add(a);
                    return new SearchResult(acc);
                }
            }
            
            //  Step 2: Search the list accList for any account with CRM-status Storkunde
            for(Account a: accList)
            {
                if(a.CRMStatus__c == CRM_STATUS_STORKUNDE)
                {
                    List<Account> acc = new List<Account>();
                    acc.add(a);
                    return new SearchResult(acc);
                }
            }
        }
        // No account found with CRM-status VIP or Storbedrift, return the original list of accounts.
        return new SearchResult(accList);
    }
    
    
    //Function to create a String of all possible numbers by truncating the additional zeroes at the beginning of the number
    //Example: The number received from CTI is 0004045
    //Output of this function: '0004045 OR 004045 OR 04045 OR 4045'
    //This value will be passed into the SOSL query for the Customer Search
    @testVisible private String getAllPossiblePhoneNumbers(String aNumber)
    {
        String temp = aNumber;
        String numList = temp;
        
        while(temp.startsWith('0'))
        {
            temp = temp.substring(1);
            numList = numList + ' OR ' + temp;
        }
        
        return numList;
    }  
}