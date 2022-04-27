public class account_heirarchy {

    public Account acnt{get;set;}
    public ApexPages.StandardSetController con{get; set;} 
    public id acntid {get;set;}
    public boolean isParty{get;set;}
    public Integer size{get;set;} 
     public boolean flag {get;set;}
     
      Public Integer noOfRecords{get; set;} 
   public List<SelectOption> paginationSizeOptions{get;set;}
     public Account acc{get;set;}
    Public String query{get;set;}
    
    
    public account_heirarchy(ApexPages.StandardController controller) {
      
      
         if(!test.isrunningtest())
      acntid=ApexPages.currentPage().getParameters().get('id');
      else
          acntid=[Select id from Account where Orga__c='9990002'].id;
      
      
         acc = [Select id,Name,Orga__c,  recordtypeid,parentid from Account where id=:acntid];
      String theme = UserInfo.getUiThemeDisplayed();
      
      if(theme != 'Theme3' )
                flag = true;
            else
                flag = false;
            size=10;
      
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        
      
        }
       public Account party {
       get{
        Id RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.crm_Party_level_Customer).getRecordTypeId();
            System.debug('@@@acc.recordtypeId@@'+acc.recordtypeId);
            System.debug('@@@RecordTypeId@@'+RecordTypeId);
             acc = [Select id,Name,Orga__c,  recordtypeid,parentid,crm_Customer_Status_Role_1__c,crm_customer_number__c,BillingCity,BillingPostalcode,ShippingCity,ShippingPostalCode,crm_Revenue_This_Year__c ,crm_Revenue_Last_Year__c  from Account where id=:acntid];
             System.debug('@@@acc@@'+acc);
            if(acc.recordtypeId == RecordTypeId){  ///account is  party 
            System.debug('@@@acntid@@'+acntid);
                party=acc;
                isParty=true;
             }
             else
             {
                  party=[Select id,Name,Orga__c,crm_Customer_Status_Role_1__c,crm_customer_number__c,BillingCity,BillingPostalcode,ShippingCity,ShippingPostalCode,crm_Revenue_This_Year__c ,crm_Revenue_Last_Year__c  from account where id=:acc.Parentid];
             }
             return party;
       }
       set;}
           
     public ApexPages.StandardSetController setCon {
       get {   
         if(setCon == null) {
         string searchquery ='Select id, name,Orga__c,cs_Customer_Role_formula__c,crm_customer_number__c,BillingCity,BillingPostalcode,ShippingCity,ShippingPostalCode,crm_Revenue_This_Year__c ,crm_Revenue_Last_Year__c   from Account';  
             
         System.debug('@@@acc@@'+acc);
         Id RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.crm_Party_level_Customer).getRecordTypeId();
            System.debug('@@@acc.recordtypeId@@'+acc.recordtypeId);
            System.debug('@@@RecordTypeId@@'+RecordTypeId);
            
             System.debug('@@@acc@@'+acc);
            if(isParty==true){  ///account is  party 
            System.debug('@@@acntid@@'+acntid);
               
                searchquery =searchquery +' where parentid=:acntid';
              
                }
                
                else{ //account is relation 
               
               
                String partyid=party.id;
                searchquery=searchquery+' where parentid=:partyid';
                System.debug('@@@party@@'+party);
                }
                
               System.debug('@@query in load' +searchquery );
               setCon = new ApexPages.StandardSetController(Database.getQueryLocator(searchquery));
               setCon.setPageSize(size);  
               noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
    
              
            


    public Boolean hasNext  
    {  
        get  
        {  
            return con.getHasNext();  
        }  
        set;  
    }  
    public Boolean hasPrevious  
    {  
        get  
        {  
            return con.getHasPrevious();  
        }  
        set;  
    }  
    public Integer pageNumber  
    {  
        get  
        {  
            return con.getPageNumber();  
        }  
        set;  
    }  
    public void previous()  
    {  
        con.previous();  
    }  
    public void next()  
    {  
        con.next();  
    }  
    
     public List<Account> getAccounts() {
        System.debug('on getaccounts');
        return (List<Account>) setCon.getRecords();

    }
    
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

}