public class crm_createcontactcontroller
{    
    public Contact con{get;set;}

    public string accountid{get;set;}
    List<Account> relationLevelAccount{get;set;}

    public List<Account> account {get;set;}
    public string relationaccountid{get;set;}

    private ApexPages.StandardController controller {get; set;}
    public List<contact> duplicatecontact{get;set;}
    public boolean hasDuplicateContact{get;set;}
    public string language{get;set;}
    public integer count{get;set;}


    public List<Contact> contactlist=new List<Contact>();
    public User logggedInUser{get;set;}
    public String message{get;set;}
    public Integer dupilcatecount{get;set;}
    public List<AccountContactRelation> relationshiplist=new List<AccountContactRelation>();

    public crm_createcontactcontroller(ApexPages.StandardController controller) {
        this.controller = controller;
        this.con= (Contact)controller.getRecord();
        System.debug('@@@con'+con);
        
        logggedInUser=[Select crm_User_Type__c,LanguageLocaleKey,profileid from User where id=:UserInfo.getUserid() limit 1];
        Con.crm_Contact_Type__c=logggedInUser.crm_User_Type__c;
        language=logggedInUser.LanguageLocaleKey;
 
    }
     
    public List<SelectOption> getAccounts(){
        relationLevelAccount=new List<Account>();
        if(ApexPages.CurrentPage().getparameters().containsKey('accid'))  {
            accountid=ApexPages.CurrentPage().getparameters().get('accid');
            System.debug('@@@inside constructor'+accountid);
            if(accountid!=null)  {
                relationLevelAccount=[Select id,Name,Crm_Customer_number__c,crm_bus_addr_City__c from Account where Parentid=:accountid];
            }
        }
         
        List<SelectOption> options = new List<SelectOption>();
        
        // System.debug('@@@inside getAccounts'+relationLevelAccount);
        if(relationLevelAccount.size()>0)
            {
                for(Account acc:relationLevelAccount)
                {
                if(acc.crm_bus_addr_City__c!=null)
                    options.add(new SelectOption(acc.id,acc.name+','+acc.Crm_Customer_number__c+','+acc.crm_bus_addr_City__c));
                else
                    options.add(new SelectOption(acc.id,acc.name+','+acc.Crm_Customer_number__c));
                }
            }
            return options;
       }
       
    /*   public PageReference SaveDuplicate()
       {
           AccountContactRelation relationship=new AccountContactRelation();
           AccountContactRelation relationship1=new AccountContactRelation();
           Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
           
           Boolean redirect=false;
           Id Contactid;
           try{
               Database.DMLOptions dml = new Database.DMLOptions();
               dml.DuplicateRuleHeader.AllowSave = true; 
               Database.SaveResult[] srList = Database.Insert(contactlist,dml);
               
               for (Database.SaveResult sr : srList) 
               {
                if (sr.isSuccess()) 
                {
                    redirect=true; 
                }
               }
               
                              
               if(con.id!=null && redirect==true){
                   
                   relationship.Accountid=relationaccountid; //accountid;
               relationship.Contactid=con.id;
               relationshiplist.add(relationship);
               
                Contact cloneCSCon=con.clone(false, true);
                cloneCSCon.ownerid  =con.ownerid;
                cloneCSCon.recordtypeid=  csRecordTypeId ;  //sales
                cloneCSCon.Master_Reference_Id__c=con.id;
                cloneCSCon.crm_Contact_Type__c ='Customer Service';
                cloneCSCon.crm_Origination_type__c ='New';
                cloneCSCon.crm_Was_Split_From_Customer_Service__c = false;
                cloneCSCon.accountid= relationaccountid;
                insert cloneCSCon;
                
                Contact newContact= [Select id, Master_Reference_Id__c from contact where Master_Reference_Id__c= :con.id ];
                con.Master_Reference_Id__c= newContact.id;
                update con;

                
                relationship1.Accountid = accountid; //accountid;
                relationship1.Contactid = newContact.id;
                relationshiplist.add(relationship1);
                
            
           if(relationshiplist.size()>0)
           {
               insert relationshiplist;
           }
               
                  return new PageReference('/'+con.id);
                    
               }
                  else 
                  return null;
              
           }
           
           catch(Exception ex)
           {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
                 return null;
                 
           }
       }*/
       
       public PageReference saveContact()
       {
            AccountContactRelation relationship=new AccountContactRelation();
            AccountContactRelation relationship1=new AccountContactRelation();
            RecordType[] cstypes = [SELECT Id FROM RecordType Where DeveloperName = 'Customer_Service' And sObjectType = 'Contact' Limit 1];
            Id csRecordTypeId = null;
            If(cstypes.size() > 0) {
                csRecordTypeId  = cstypes.get(0).Id;
            }
            
            RecordType[] salestypes = [SELECT Id FROM RecordType Where DeveloperName = 'crm_Sales' And sObjectType = 'Contact' Limit 1];
            Id salesRecordTypeId = null;
            If(salestypes.size() > 0) {
                salesRecordTypeId  = salestypes.get(0).Id;
            }
       
            try  {
                con.Accountid=accountid; // relationaccountid;
                con.Recordtypeid=salesRecordTypeId;
                con.crm_Contact_Type__c ='Sales';
                con.crm_Origination_type__c ='New';
                con.Sync_to_Marketing__c= true;
                contactlist.add(con);
                hasDuplicateContact = false;
                Count = 0;
                System.debug('@@@cont@@@'+contactlist);
    
    if(contactlist.size() > 0)
    {
        
        duplicatecontact= new List<Contact>();
        Database.SaveResult[] srList = Database.Insert(contactlist, false);
        System.debug('###srList' + srList); 
        for (Database.SaveResult sr : srList) 
        {
            if (!sr.isSuccess()) 
            {
                for (Database.Error error : sr.getErrors()) 
                {
                    if (error instanceof Database.DuplicateError) 
                    {
                        Database.DuplicateError duplicateError =  (Database.DuplicateError)error;
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                  
                        dupilcatecount=0;
                        for(Datacloud.MatchResult matchResult : duplicateResult.getMatchResults())
                        {    
                          
                          
                            for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) 
                            {
                                dupilcatecount++;
                                System.debug('MatchRecord: ' + matchRecord.getRecord());
                                DuplicateContact.add((Contact)matchRecord.getRecord());
                            }
                        }
                        message=String.valueof(dupilcatecount)+' Possible Duplicate Record found. '+duplicateResult.getErrorMessage();
                         
                        hasDuplicateContact= !DuplicateContact.isEmpty();
                    }
                }
            }
        }
      }   
         
            if(con.id!=null) {
                
               relationship.Accountid=relationaccountid; //accountid;
               relationship.Contactid=con.id;
               relationshiplist.add(relationship);
               
                Contact cloneCSCon=con.clone(false, true);
               // cloneCSCon.ownerid  =con.ownerid;
                cloneCSCon.recordtypeid=  csRecordTypeId ;  //sales
                cloneCSCon.Master_Reference_Id__c=con.id;
                cloneCSCon.crm_Contact_Type__c ='Customer Service';
                cloneCSCon.crm_Origination_type__c ='New';
                cloneCSCon.crm_Was_Split_From_Customer_Service__c = false;
                cloneCSCon.accountid= relationaccountid;
                insert cloneCSCon;
                
                Contact newContact= [Select id, Master_Reference_Id__c from contact where Master_Reference_Id__c= :con.id ];
                con.Master_Reference_Id__c= newContact.id;
                update con;

                
                relationship1.Accountid = accountid; //accountid;
                relationship1.Contactid = newContact.id;
                relationshiplist.add(relationship1);
                
            
           if(relationshiplist.size()>0)
           {
               insert relationshiplist;
           }
                
                return new PageReference('/'+con.id);
           
           }
                else 
              return null;
           }
           catch(Exception ex)
           {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
                 return null;
                 
           }
         
           
       }

       

}