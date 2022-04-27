/*
Name: crm_TestDataFactory  
Purpose: Util class for data setup for test classes
Created by : Supriya
*/

@isTest
public class crm_TestDataFactory {

    //setup the party level account
    public static Account createPartylevelAccount() { 
       // string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Account' and name =  'Party level Customer' limit 1].Id;
        Account PartylevelAccount  = new Account(Name= 'parent test', recordTypeid= PartyRecordTypeId());
        return PartylevelAccount ; 
    
    }
     //setup the Prospect account
    public static Account createProspectAccount() { 
       // string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Account' and name =  'Party level Customer' limit 1].Id;
        Account ProspectAccount  = new Account(Name= 'parent test', recordTypeid= ProspectRecordTypeId());
        return ProspectAccount ; 
    
    }
    //setup the relation level account
    public static Account createRelationlevelAccount() { 
       // string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Account' and name =  'Relation level Customer' limit 1].Id;
        Account RelationlevelAccount  = new Account(Name= 'test account', recordTypeid= RelationRecordTypeId());
        return RelationlevelAccount; 
    
    }
    
    
    //create contact
     public static Contact createContact() { 
         Contact con= new contact();
         con.firstname='test';
         con.lastname='test';
         con.email='test@test.com';
         return con;
     }
    
    //setup the task
    public static Task createTask() { 
        task t = new Task(); 
        t.Subject = 'Test';
        t.Priority = 'Normal';
        t.Status = 'Not Started';
        t.ActivityDate = date.today(); 
        return t;    
    }
    
    //setup the event
    public static Event createEvent() { 
        Event e = new Event();
        e.Subject = 'Call';
        e.crm_Interaction_Type__c = 'Phone';
        e.StartDateTime =System.today()-2;
        e.DurationInMinutes=60;
        return e; 
    }
    
    //setup the agreement
    public static crm_Agreement__c createAgreement() { 
        crm_Agreement__c agreement= new crm_Agreement__c();
        agreement.crm_Agreement_Name__c='test agreement' ;
        agreement.crm_Agreement_Start_Date__c = Date.today()-40;
        agreement.crm_Agreement_End_Date__c = Date.today()-30;
        agreement.crm_Realized_Contract_Value__c =0;
        agreement.crm_Send_Mail_to_owner__c=false;
        return agreement;    
    }
    
    // createCargoOpportunity
    public static Opportunity createCargoOpportunity() { 
         
         string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and developername like 'Cargo_Opportunity' limit 1].Id;   
         Opportunity opp = new Opportunity();
         opp.name='Cargo Opportunity';
         opp.recordtypeId=RecordTypeId ;
         opp.StageName='New Opportunity';
         opp.CloseDate=Date.Today().addDays(10);
         opp.crm_Opp_Service_Group__c ='Cargo Domestic';
         return opp;
       
    }
    
       // createAirOpportunity
    public static Opportunity createAirOpportunity() { 
         
         string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and name ='Air' limit 1].Id;   
         Opportunity opp = new Opportunity();
         opp.name='Air Opportunity';
         opp.recordtypeId=RecordTypeId ;
         opp.StageName='New Opportunity';
         opp.CloseDate=Date.Today().addDays(10);
         opp.crm_Opp_Service_Group__c ='Air';
         return opp;
       
    }
    
    
       // createlinehaulOpportunity
    public static Opportunity createLinehaulOpportunity() { 
         
         string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and name ='Linehaul' limit 1].Id;   
         Opportunity opp = new Opportunity();
         opp.name='Linehaul Opportunity';
         opp.recordtypeId=RecordTypeId ;
         opp.StageName='New Opportunity';
         opp.CloseDate=Date.Today().addDays(10);
         opp.crm_Opp_Service_Group__c ='Linehaul';
         return opp;
       
    }
    
       // createSeaOpportunity
    public static Opportunity createSeaOpportunity() { 
         
         string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and name ='Sea' limit 1].Id;   
         Opportunity opp = new Opportunity();
         opp.name='Sea Opportunity';
         opp.recordtypeId=RecordTypeId ;
         opp.StageName='New Opportunity';
         opp.CloseDate=Date.Today().addDays(10);
         opp.crm_Opp_Service_Group__c ='Sea';
         return opp;
       
    }
    
       // createOffshoreOpportunity
    public static Opportunity createOffshoreOpportunity() { 
         
         string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and name ='Offshore' limit 1].Id;   
         Opportunity opp = new Opportunity();
         opp.name='Offshore Opportunity';
         opp.recordtypeId=RecordTypeId ;
         opp.StageName='New Opportunity';
         opp.CloseDate=Date.Today().addDays(10);
         opp.crm_Opp_Service_Group__c ='Offshore';
         return opp;
       
    }
    
    
    // createCitymailOpportunity
    public static Opportunity createCitymailOpportunity() { 
         
         string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and name like '%Citymail%' limit 1].Id;   
         Opportunity opp = new Opportunity();
         opp.name='Citymail Opportunity';
         opp.recordtypeId=RecordTypeId ;
          opp.StageName='New Opportunity';
         opp.CloseDate=Date.Today().addDays(10);
         opp.crm_Opp_Service_Group__c ='Citymail';
         return opp;
       
    }
    
    // createWarehousingOpportunity
    public static Opportunity createWarehousingOpportunity() { 
         
         string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and name like '%Warehousing%' limit 1].Id;   
         Opportunity opp = new Opportunity();
         opp.name='Warehousing Opportunity';
         opp.recordtypeId=RecordTypeId ;
         opp.StageName='New Opportunity';
         opp.CloseDate=Date.Today().addDays(10);
         opp.crm_Opp_Service_Group__c ='Warehousing';
         return opp;
       
    }
    public static Opportunity createConvertedfromLeadOpportunity() { 
         
         string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Opportunity' and name like '%Converted From Lead%' limit 1].Id;   
         Opportunity opp = new Opportunity();
         opp.name='Converted From Lead';
         opp.recordtypeId=RecordTypeId ;
         opp.StageName='New Opportunity';
         opp.CloseDate=Date.Today().addDays(10);
        
         return opp;
       
    }
    
    
    //create lead
    public static lead createLead() { 
        lead leadobj= new lead();
        leadobj.FirstName='test firstname';
        leadobj.LastName ='test lastname';
        leadobj.Company='Capgemini';
        leadobj.Email='test@test.com';
        leadobj.Status='New';
        leadobj.Status='Hot';
        leadobj.leadsource='Web';
        leadobj.AnnualRevenue = 1000;
        return leadobj;    
    }
    
    //create user
    public static User createUser() { 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User();
        u.Alias = 'admin';
        u.Email='admin@test.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='admin123rts@testorg0075.com';
        return u;    
    }
    
    public static User createUser(String userName,String alias) { 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User();
        u.Alias = alias;
        u.Email=userName+'@test.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName=userName;
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName=userName+'123rts@testorg0075.com';
        return u;    
    }
    
    public static User createSalesUser() { 
        Profile p = [SELECT Id FROM Profile WHERE Name='CRM Sales User']; 
        
        User u = new User();
        u.Alias = 'salesusr';
        u.Email='salesuser@test.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='salesuser0081@testorg001.com';
        return u;    
    }
    
    //create OpportunityTeamMember 
    public static OpportunityTeamMember createOpportunityTeamMember() { 
       
        OpportunityTeamMember otm = new OpportunityTeamMember();
        otm.TeamMemberRole='EDI admin';
        return otm;    
    }
    
    
     //create Product
    public static product2 createProduct() { 
       
        Product2 prod= new Product2();
        prod.Name = 'Laptop X200';
        prod.Family = 'Hardware';
        return prod;    
    }
    
    
    //create Pricebook
    public static Pricebook2 createPricebook() { 
       
        Pricebook2 pb= new Pricebook2 ();
        pb.Name = 'Air';
        pb.IsActive= true;
        return pb;    
    }
    
    //create PricebookEntry
    public static PricebookEntry createPricebookEntry() { 
       
        PricebookEntry pbentry= new PricebookEntry();
        pbentry.UnitPrice = 1200;
        pbentry.IsActive= true;
        return pbentry;    
    }
    
    //create sales import data
    public static crm_SalesImport__c createSalesImport() { 
       
        crm_SalesImport__c saleObj=new crm_SalesImport__c();
        saleObj.crm_Customer_Number__c='929292';
        saleObj.crm_Source__c='BLNOCMP';
        saleObj.crm_Product__c='1202';
        saleObj.crm_Invoice_Date__c='09072016';
        saleObj.crm_Currency__c='NOK';
        saleObj.crm_Price__c='21265';
         return saleObj;    
    }
    
    //create sales import data
    public static crm_SAS_Customer_Import__c createSaSCustomerImport() { 
       
        crm_SAS_Customer_Import__c sasObj=new crm_SAS_Customer_Import__c ();
        sasObj.crm_CUSTOMER_NUMBER__c='929292';
        sasObj.Name='Test Account';
        sasObj.crm_CUSTOMER_ORGANISATIONNUMBER__c='1202';
        sasObj.crm_RATING__c='2';
       
       
         return sasObj;    
    }
    
    public static crm_Segment__c createSegment() { 
       
        crm_Segment__c segObj=new crm_Segment__c ();
        segObj.crm_Service_Group__c='Cargo';
        return segObj;    
    }
    
    
    public static crm_Revenue_Line__c createRevenueLine() { 
       
        crm_Revenue_Line__c revLineObj=new crm_Revenue_Line__c();
        return revLineObj;    
    }
    
   
    public static id PartyRecordTypeId()
    {   
         crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
         Id RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
         return RecordTypeId;
    }
    
    
    public static id RelationRecordTypeId()
    {
        crm_AccountRecordTypes__c rTBedrift= crm_AccountRecordTypes__c.getValues('Relation level Customer');
         Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTBedrift.crm_Record_Type_Label__c).getRecordTypeId();
         return RecordTypeId;
    }
    
    public static id ProspectRecordTypeId()
    {
        crm_AccountRecordTypes__c rTProspect= crm_AccountRecordTypes__c.getValues('Prospect');
        Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTProspect.crm_Record_Type_Label__c).getRecordTypeId();
        return RecordTypeId;
    }
    
    public static void CreateCustomSetting()
    {
        List<crm_AccountRecordTypes__c> settingList=new List<crm_AccountRecordTypes__c>();
        crm_AccountRecordTypes__c rec1=new crm_AccountRecordTypes__c();
        rec1.Name='Bedrift';
        rec1.crm_Record_Type_Label__c='Bedrift';
        settingList.add(rec1);
        
        crm_AccountRecordTypes__c rec2=new crm_AccountRecordTypes__c();
        rec2.Name='Party level Customer';
        rec2.crm_Record_Type_Label__c='Party level Customer';
        settingList.add(rec2);
        
        crm_AccountRecordTypes__c rec3=new crm_AccountRecordTypes__c();
        rec3.Name='Prospect';
        rec3.crm_Record_Type_Label__c='Prospect';
        settingList.add(rec3);
        
        crm_AccountRecordTypes__c rec4=new crm_AccountRecordTypes__c();
        rec4.Name='Relation level Customer';
        rec4.crm_Record_Type_Label__c='Relation level Customer';
        settingList.add(rec4);
        
        insert settingList;     
        
    }
    
  }