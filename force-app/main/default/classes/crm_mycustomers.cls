/* Created By: Supriya goel
Date: 14th nov 
class: Class to shoe my customers 
*/

public with sharing class crm_mycustomers {

public string loggdInUserId{get;set;}  
 public Set<id> SegmentIds;

 public string partyRecordtype = 'Party level Customer';
 public string relationRecordtype = 'Relation level Customer';
 public Integer size{get;set;} 
  public Integer size1{get;set;} 
   Public Integer noOfRecords{get; set;} 
   Public Integer noOfRecords1{get; set;} 
   public List<SelectOption> paginationSizeOptions{get;set;}
    public List<SelectOption> paginationSizeOptions1{get;set;}
      public boolean flag {get;set;}
      public  Set<id> accountIds;
       public  Set<id> relationaccountIds;
        public String defaultCur {get;set;}
 
 
  public crm_mycustomers (){
      loggdInUserId=UserInfo.getUserId();
      defaultCur = UserInfo.getDefaultCurrency();
       SegmentIds= new Set<id>();
       accountIds= new Set<id>();
       relationaccountIds=new Set<Id>();
      List<crm_segment__c> segmentList=  [Select id, crm_Sales_Responsible__c , crm_account__c  from crm_segment__c  where crm_Sales_Responsible__c=:loggdInUserId and crm_account__r.recordtype.Name=:partyRecordtype];
      for (crm_segment__c seg: segmentList ){
          SegmentIds.add(seg.crm_account__c);
      
      }
      
      segmentList=  [Select id, crm_Sales_Responsible__c , crm_account__c, crm_account__r.parentid  from crm_segment__c  where crm_Sales_Responsible__c=:loggdInUserId and crm_account__r.recordtype.Name=:relationRecordtype];
      for (crm_segment__c seg: segmentList ){
          SegmentIds.add(seg.crm_account__r.parentid);
      
      }
      
       String theme = UserInfo.getUiThemeDisplayed();
            if(theme != 'Theme3' )
                flag = true;
            else
                flag = false;
            //2017-3, Ann-Kristin Olsen, Change from 10 to 100
            size=100;
            
            size1=10;
       
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        
        
        paginationSizeOptions1 = new List<SelectOption>();
        paginationSizeOptions1.add(new SelectOption('5','5'));
        paginationSizeOptions1.add(new SelectOption('10','10'));
        paginationSizeOptions1.add(new SelectOption('20','20'));
        paginationSizeOptions1.add(new SelectOption('50','50'));
        paginationSizeOptions1.add(new SelectOption('100','100'));
    
  
  }
  
 public ApexPages.StandardSetController setCon {
       get {   
          if(setCon == null) {
          
           string searchquery = 'Select name, recordtype.Name, Orga__c,crm_bus_addr_City__c, crm_bus_addr_Country__c, crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c, BillingStreet, BillingCity, BillingState, BillingPostalCode,  BillingCountry, crm_Company_Group_Name__c ,crm_Revenue_Last_Year__c,crm_Revenue_This_Year__c, crm_Count_of_Relation_level_Accounts__c,crm_e_commerce_KAM__c, crm_Group_KAM__c from account where';
           searchquery += ' (id in :SegmentIds or crm_e_commerce_KAM__c=:loggdInUserId or crm_Group_KAM__c =:loggdInUserId) and recordtype.Name=:partyRecordtype';
           searchquery +=' order by name asc NULLS last limit 10000';
             System.debug('@@query in load' +searchquery );
               setCon = new ApexPages.StandardSetController(Database.getQueryLocator(searchquery));
               setCon.setPageSize(size);  
               noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
    
     public List<Account> getAccounts() {
        System.debug('on getaccounts');
        return (List<Account>) setCon.getRecords();

    }

    
       //Changes the size of pagination
    public PageReference refreshPageSize() {
         setCon.setPageSize(size);
         refresh();
         return null;
    }
    
     public pageReference refresh() {
        setCon = null;
        setCon.setPageNumber(1);
        noOfRecords = setCon.getResultSize();
        return null;
    }
    
    // the current sort direction. defaults to asc
    public String sortDir {
        // To set a Direction either in ascending order or descending order.
                                get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;}
        set;
    }

    // the current field to sort by. defaults to last name
    public String sortField {
        // To set a Field for sorting.
                                get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
        set;
    } 
    
  
    
     
     public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        string searchquery = 'Select name, recordtype.Name, Orga__c,crm_bus_addr_City__c, crm_bus_addr_Country__c, crm_bus_addr_Street__c, crm_bus_addr_Zip_Code__c, BillingStreet, BillingCity, BillingState, BillingPostalCode,  BillingCountry, crm_Company_Group_Name__c ,crm_Revenue_Last_Year__c,crm_Revenue_This_Year__c, crm_Count_of_Relation_level_Accounts__c,crm_e_commerce_KAM__c, crm_Group_KAM__c from account where';
           searchquery += ' (id in :SegmentIds or crm_e_commerce_KAM__c=:loggdInUserId or crm_Group_KAM__c =:loggdInUserId) and recordtype.Name=:partyRecordtype';
           searchquery +=' order by ' +  sortField + ' ' + sortDir  +' NULLS last limit 10000';
           System.debug('@@query in sort' +searchquery );
               setCon = new ApexPages.StandardSetController(Database.getQueryLocator(searchquery));
               setCon.setPageSize(size);  
               noOfRecords = setCon.getResultSize();
   }
   
   
   
    public ApexPages.StandardSetController setCon1 {
       get {   
          if(setCon1 == null) {
          
          List<Account> accountList= [Select id from account where (id in :SegmentIds or crm_e_commerce_KAM__c=:loggdInUserId or crm_Group_KAM__c =:loggdInUserId) and recordtype.Name=:partyRecordtype];
         
          
          for (Account acnt: accountList){
              accountIds.add(acnt.id);
          }
          
          accountList= [select id from account where parentid=:accountIds ];
          
           
          for (Account acnt: accountList){
              relationaccountIds.add(acnt.id);
          }
          
          
           string searchquery = 'Select id,  name , accountid, account.name, email, crm_Source__c  from contact where';
           searchquery += ' Accountid in :relationaccountIds  AND Status__c = \'Active\' ';
           searchquery +=' order by lastmodifieddate desc NULLS last limit 10000';
           System.debug('@@query in load' +searchquery );
           setCon1 = new ApexPages.StandardSetController(Database.getQueryLocator(searchquery));
           setCon1.setPageSize(size1);  
           noOfRecords1 = setCon1.getResultSize();
            }            
            return setCon1;
        }
        set;
    }
    
     public List<Contact> getContacts() {
        System.debug('on getContacts');
        return (List<Contact>) setCon1.getRecords();

    }

    
       //Changes the size of pagination
    public PageReference refreshPageSize1() {
         setCon1.setPageSize(size1);
         refreshContacts();
         return null;
    }
    
     public pageReference refreshContacts() {
        setCon1 = null;
        setCon1.setPageNumber(1);
        noOfRecords1 = setCon1.getResultSize();
        return null;
    }
    
     
    
     public void toggleSortContact() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
          string searchquery = 'Select id,  name , accountid, account.name, email, crm_Source__c   from contact where';
           searchquery += ' Accountid in :relationaccountIds AND Status__c = \'Active\' ';
           searchquery +=' order by ' +  sortField + ' ' + sortDir  +' NULLS last limit 10000';
             System.debug('@@query in load' +searchquery );
               setCon1 = new ApexPages.StandardSetController(Database.getQueryLocator(searchquery));
               setCon1.setPageSize(size1);  
               noOfRecords1 = setCon1.getResultSize();
   }
   
  }