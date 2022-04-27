/* Created By: Supriya goel
Date: Sprint 6 US
Test class: Class for the account search
*/
public with sharing class crm_AccountSearchController{

   public string orgNo{get;set;}  
   public string AccountName{get;set;} 
   public string BillingStreet{get;set;}
   public string BillingCity{get;set;}
   public string BillingState{get;set;}
   public string BillingPostalCode{get;set;}
   public string BillingCountry{get;set;}
   public string CompanyGroupName{get;set;}
   public list <account> acc {get;set;}  
   public String defaultCur {get;set;}
   
   
   public string BusinessStreet{get;set;}
   public string BusinessCity{get;set;}
   public string BusinessPostalCode{get;set;}
   public string BusinessCountry{get;set;}
   
   
   public string partyRecordtype = 'Party level Customer';
   public string prospectRecordtype = 'Prospect';
   Public Integer size{get;set;} 
   Public Integer noOfRecords{get; set;} 
   public List<SelectOption> paginationSizeOptions{get;set;}
   public List<Account> accList{get; set;}
   public Boolean RecordFlag{get; set;}
   public Boolean SearchCriteriaBlankFlag{get; set;}
   public Boolean LoadFirsttimeFlag{get; set;}
   public boolean flag {get;set;}
   
     public crm_AccountSearchController(){
         defaultCur = UserInfo.getDefaultCurrency();
         String theme = UserInfo.getUiThemeDisplayed();
            if(theme != 'Theme3' )
                flag = true;
            else
                flag = false;
            size=10;
        RecordFlag=false;
        LoadFirsttimeFlag=false;
        SearchCriteriaBlankFlag=false;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
    }
    
     public ApexPages.StandardSetController setCon {
    
      get {   
          if(setCon == null) {
                   string searchquery = 'select name, recordtype.Name, Orga__c,crm_bus_addr_City__c,crm_bus_addr_Country__c, crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c, BillingStreet, BillingCity, BillingState, BillingPostalCode,  BillingCountry, crm_Company_Group_Name__c ,convertCurrency(crm_Revenue_Last_Year__c),convertCurrency(crm_Revenue_This_Year__c), crm_Count_of_Relation_level_Accounts__c from account where name != null and (recordtype.Name=:partyRecordtype OR recordtype.Name=:ProspectRecordtype)';
                   
                  if((String.isNotBlank(orgNo)  || String.isNotEmpty(orgNo)) 
                  || (String.isNotBlank(AccountName)  || String.isNotEmpty(AccountName) )
                  || (String.isNotBlank(CompanyGroupName)  || String.isNotEmpty(CompanyGroupName))
                  || (String.isNotBlank(BusinessStreet)  || String.isNotEmpty(BusinessStreet))
                  || (String.isNotBlank(BusinessCity)  || String.isNotEmpty(BusinessCity))
                  || (String.isNotBlank(BusinessPostalCode)  || String.isNotEmpty(BusinessPostalCode))
                  || (String.isNotBlank(BusinessCountry)  || String.isNotEmpty(BusinessCountry) ) ) {
                  
                  String neworgNo=orgNo.deleteWhitespace();
                  String newBusinessPostalCode=BusinessPostalCode.deleteWhitespace();
                                         
                     if(String.isNotBlank(AccountName)  || String.isNotEmpty(AccountName)  )
                        searchquery  += ' and name LIKE   \'%' +String.escapeSingleQuotes(AccountName)+ '%\'';  
                        LoadFirsttimeFlag=false;  
                        
                   if(String.isNotBlank(orgNo)  || String.isNotEmpty(orgNo))
                         searchquery += ' and ( Orga__c  LIKE  \'%'  +String.escapeSingleQuotes(neworgNo)+ '%\' OR Orga__c  LIKE  \'%'  +String.escapeSingleQuotes(orgNo)+ '%\')' ;
                         
                   if(String.isNotBlank(CompanyGroupName)  || String.isNotEmpty(CompanyGroupName)  )
                        searchquery  += ' and crm_Company_Group_Name__c LIKE   \'%' +String.escapeSingleQuotes(CompanyGroupName)+ '%\'';  
                                              
                   
                   if(String.isNotBlank(BusinessStreet)  || String.isNotEmpty(BusinessStreet)  )
                        searchquery  += ' and crm_bus_addr_Street__c LIKE   \'%' +String.escapeSingleQuotes(BusinessStreet)+ '%\'';  
                    
                        
                   if(String.isNotBlank(BusinessCity)  || String.isNotEmpty(BusinessCity)  )
                        searchquery  += ' and crm_bus_addr_City__c LIKE   \'%' +String.escapeSingleQuotes(BusinessCity)+ '%\'';  
                    
                     
                   if(String.isNotBlank(BusinessPostalCode)  || String.isNotEmpty(BusinessPostalCode)  )
                        searchquery  += ' and ( crm_bus_addr_Zip_Code__c LIKE   \'%' +String.escapeSingleQuotes(newBusinessPostalCode)+ '%\' OR crm_bus_addr_Zip_Code__c LIKE   \'%' +String.escapeSingleQuotes(BusinessPostalCode)+ '%\')  ';  
                        LoadFirsttimeFlag=false;
                           
                   if(String.isNotBlank(BusinessCountry)  || String.isNotEmpty(BusinessCountry) )
                        searchquery  += ' and crm_bus_addr_Country__c LIKE   \'%' +String.escapeSingleQuotes(BusinessCountry)+ '%\'';  
                        searchquery += ' ORDER BY crm_Revenue_This_Year__c DESC NULLS LAST LIMIT 10000';    
                       System.debug('@@searchquery '+ searchquery );     
                 
          }
           else
         
          {
              searchquery = 'select name, Orga__c  ,recordtype.Name,crm_bus_addr_City__c, crm_bus_addr_Country__c, crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c, BillingStreet, BillingCity, BillingState, BillingPostalCode,  BillingCountry, crm_Company_Group_Name__c ,convertCurrency(crm_Revenue_Last_Year__c),convertCurrency(crm_Revenue_This_Year__c), crm_Count_of_Relation_level_Accounts__c from account where name = null Limit 0';
              LoadFirsttimeFlag=true;
          }
        
      
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(searchquery));
                setCon.setPageSize(size);  
                noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
     
    //Changes the size of pagination
    public PageReference refreshPageSize() {
         setCon.setPageSize(size);
           refresh();
         return null;
    }
 
    // Initialize setCon and return a list of record    
     
       public pageReference refresh() {
        setCon = null;

        
             if((String.isBlank(orgNo)  || String.isEmpty(orgNo)) 
                  && (String.isBlank(AccountName)  || String.isEmpty(AccountName) )
                  && (String.isBlank(CompanyGroupName)  || String.isEmpty(CompanyGroupName))
                  && (String.isBlank(BusinessStreet)  || String.isEmpty(BusinessStreet))
                  && (String.isBlank(BusinessCity)  || String.isEmpty(BusinessCity))
                  && (String.isBlank(BusinessPostalCode)  || String.isEmpty(BusinessPostalCode))
                  && (String.isBlank(BusinessCountry)  || String.isEmpty(BusinessCountry) ) ) {
            
            SearchCriteriaBlankFlag=true;
          
             }
           else
           {
               SearchCriteriaBlankFlag=false;
           }
       
        getAccounts();
        setCon.setPageNumber(1);
        return null;
    }
    
     Public List<Account> getAccounts(){
     
        accList = new List<Account>();
        List<Account> aaa = (List<Account>)setCon.getRecords();
        for(Account a : (List<Account>)setCon.getRecords())
            accList.add(a);
            
            
            if(accList.size()>0){
                RecordFlag = true;
                
                }
            else
            {
              RecordFlag = false;   
             
              }
        return accList;
    }
  
}