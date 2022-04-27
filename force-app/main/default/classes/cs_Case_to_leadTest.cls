/*
Created By:supriya goel
Date: 20 jan 2017 
test class for case to lead
*/

@isTest

public class cs_Case_to_leadTest{

    @testSetup static void setup() {
    
      crm_TestDataFactory.CreateCustomSetting();
        //create party level account
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt.orga__c='1123';
        insert  partyLevelacnt;
        
       //create relation level account
       Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt.parentId=partyLevelacnt.id;
       relationLevelacnt.Party_number__c='1123';
       relationLevelacnt.orga__c='111';
       insert  relationLevelacnt;
       
       Contact c = crm_TestDataFactory.createContact();
        c.accountid=relationLevelacnt.id;
        c.lastname='Test name';
        c.phone='1234';
        c.crm_contact_type__c='Sales';
        System.debug('@@@ contact insert'+ c.crm_contact_type__c) ;
        insert c;
       
       List<Profile> profileList = [select Id from Profile where name='KATS system user'];
       DateTime timestamp = dateTime.now();
       String appendTimeStamp = timestamp.format('MMddyyyyhhmmss','America/New_York');
       User testUser = new User(
            alias='testuser',
            email='tesruser@posten.capgemini.com.test',
            emailencodingkey='UTF-8', 
            lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = profilelist.get(0).Id,
            timezonesidkey='America/Los_Angeles',           
            username='testuser@posten.capgemini.com.test',
            crm_User_Type__c='Customer Service'            );
        
        insert testUser;    
        System.runAs(testUser) {    
        c.lastname='test1'  ;
        update c;      
       
      }
        
       Code_Event__c code_event= new Code_Event__c();
       code_event.name='test';
       code_event.IsActive__c= true;
       insert code_event;
       
       Code_Reason1__c reason1= new Code_Reason1__c();
       reason1.name='test reason';
       insert reason1;
        
        
       Case caseobj= new Case();
       caseobj.subject='TEST';
       caseobj.accountId=relationLevelacnt.id;
       caseobj.description = 'test';
       caseobj.SuppliedEmail='test@test.com';
       caseobj.AccountPhone__c='1234567890';
       caseobj.LM_current_postal_address__c='Test street';
       //caseobj.LM_current_country__c='IN';
       caseobj.LM_current_zip_code__c='4112';
       caseobj.contactid=c.id;   
       caseobj.Code_Event__c= code_event.id;
       caseObj.Code_Reason1__c= reason1.id;
       caseObj.suppliedPhone='12222';
       caseObj.suppliedemail='test@test.com';
       insert caseobj;  
       
      
    
    
    }
    
      static testMethod void converttoleadtest(){
     
        List<Case> caseobj= [select id,Account.ParentId  from case where subject='TEST' limit 1];
        
        System.assertEquals(1, caseobj.size()); // This will fail your test if there are no accounts
        Case c = caseobj.get(0);
        
       // pageReference refpage= Page.cs_Case_To_lead;
       // ID pageid = refpage.getParameters().put('id',c.id); //parameter id which you are passing in your page
       // Test.setCurrentPage(pageid);    
        System.Test.startTest();   
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        cs_Case_to_lead obj = new cs_Case_to_lead(sc);
        obj.saveLead();
        
        System.Test.stopTest();    

        }
    
    static testMethod void converttoleadtest1(){
     
         Lead l = new lead(lastname='testlead', company='test' , email='test@test.com');
        insert l;
        Case c = new Case();
        
        c.cs_lead_id__c =l.id;
        insert c;
        
       // pageReference refpage= Page.cs_Case_To_lead;
       // ID pageid = refpage.getParameters().put('id',c.id); //parameter id which you are passing in your page
       // Test.setCurrentPage(pageid);    
        System.Test.startTest();   
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        cs_Case_to_lead obj = new cs_Case_to_lead(sc);
        obj.saveLead();
        
        System.Test.stopTest();    

        }
        
        
         static testMethod void converttoleadtest3(){
     
        List<Case> caseobj= [select id,Account.ParentId,Code_Event__r.name,PostNumber__c,Code_Reason1__r.name, Code_Reason2__c,Service_Product__r.Name,description,Account.party_number__c,Account.Name,Contact.Name,suppliedPhone,suppliedEmail,Account.crm_Party_level_Account__c,Account.crm_Organization_number__c from case where subject='TEST' limit 1];
        
        System.assertEquals(1, caseobj.size()); // This will fail your test if there are no accounts
        Case c = caseobj.get(0);
        
       // pageReference refpage= Page.cs_Case_To_lead;
       // ID pageid = refpage.getParameters().put('id',c.id); //parameter id which you are passing in your page
       // Test.setCurrentPage(pageid);    
        System.Test.startTest();   
        
        Case_To_Lead_Controller AAC = new Case_To_Lead_Controller (new ApexPages.StandardController(c));
        Case_To_Lead_Controller.CaseDetails casedet = new Case_To_Lead_Controller.CaseDetails(c) ;
       
        
        
       // ApexPages.StandardController sc = new ApexPages.standardController(c);
       // Case_To_Lead_Controller obj = new Case_To_Lead_Controller(sc);
        
        
        System.Test.stopTest();    

        }


}