/* Date:12/1/2018
 * Test class for Create Contact lightning component
 */

@isTest
public class crm_setprimarycontactAccount_BatchTest {
    
    @testSetup static void setup() {
     crm_TestDataFactory.CreateCustomSetting();
        List<Account> acclist = new List<account>();
   
        Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt1.crm_EDI_API_status__c = 'Ikke oppdatert';
        acclist.add(partyLevelacnt1);
        
        Account partyLevelacnt2= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt2.crm_EDI_API_status__c = 'Ikke oppdatert';
        acclist.add(partyLevelacnt2);
        
        Account partyLevelacnt3= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt3.crm_EDI_API_status__c = 'Ikke relevant';
        acclist.add(partyLevelacnt3);
        
        Account partyLevelacnt4= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt4.crm_EDI_API_status__c = 'Ikke relevant';
        acclist.add(partyLevelacnt4);
        
        Account partyLevelacnt5= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt5.crm_EDI_API_status__c = 'Ikke oppdatert';
        acclist.add(partyLevelacnt5);
         if (!acclist.isEmpty())
            insert acclist;
                
        Account relLevelacnt1 = crm_TestDataFactory.createRelationlevelAccount();
        insert relLevelacnt1;
        
        Edi_Information__c test_edi = new Edi_Information__c ();
        test_edi.name = 'Test Edi 01';
        test_edi.EDI_Identificator__c = '829987112';
        test_edi.TA_Vendor__c = 'Bleken Data AS';
        test_Edi.Party__c = partyLevelacnt1.id;
        test_edi.Account_Id__c = relLevelacnt1.id;
        test_Edi.Kvalificator__c = 'NEP-NorStella';
        test_Edi.Status__c = 'New';
        insert test_edi;
        
        test_Edi.Status__c = 'Testing';
        update test_Edi;
        
        test_edi.Status__c = 'Production';
        update test_Edi;
        
             
        List <Contact> conlist = new List<contact> ();
     Contact c1 = new Contact();
     c1.lastname= 'c1lastname';
     c1.email= 'c1email@test.com';
     c1.crm_Contact_Type__c ='Sales';
     c1.Status__c ='Aktiv';
     c1.Accountid= partyLevelacnt1.id;
     c1.crm_functional_decision_level__c ='Decision maker';
     conlist.add(c1);  
     
     Contact c2 = new Contact();
     c2.lastname= 'c2lastname';
     c2.email= 'c2email@test.com';
     c2.crm_Contact_Type__c ='Sales';
     c2.Status__c ='Aktiv';
     c2.Accountid= partyLevelacnt2.id;
     c2.crm_functional_decision_level__c ='Influencer';
     conlist.add(c2);  
        
     Contact c3 = new Contact();
     c3.lastname= 'c3lastname';
     c3.email= 'c3email@test.com';
     c3.crm_Contact_Type__c ='Sales';
     c3.Status__c ='Aktiv';
     c3.Accountid= partyLevelacnt3.id;
     c3.crm_functional_decision_level__c ='User';
     conlist.add(c3);  
     
     Contact c4 = new Contact();
     c4.lastname= 'c4lastname';
     c4.email= 'c4email@test.com';
     c4.crm_Contact_Type__c ='Sales';
     c4.Status__c ='Aktiv';
     c4.Accountid= partyLevelacnt4.id;
     c4.crm_functional_decision_level__c ='';
     conlist.add(c4);  
        
     Contact c5 = new Contact();
     c5.lastname= 'c5lastname';
     c5.email= 'c5email@test.com';
     c5.crm_Contact_Type__c ='Sales';
     c5.Status__c ='Aktiv';
     c5.crm_function_working_area__c = 'IT';
     c5.Accountid= partyLevelacnt1.id;
     c5.crm_functional_decision_level__c ='Decision maker';
     conlist.add(c5); 
        
     Contact c6 = new Contact();
     c6.lastname= 'c6lastname';
     c6.email= 'c6email@test.com';
     c6.crm_Contact_Type__c ='Sales';
     c6.Status__c ='Aktiv';
     c6.crm_function_working_area__c = 'IT';
     c6.Accountid= partyLevelacnt2.id;
     c6.crm_functional_decision_level__c ='Influencer';
     conlist.add(c6); 
        
     Contact c7 = new Contact();
     c7.lastname= 'c7lastname';
     c7.email= 'c7email@test.com';
     c7.crm_Contact_Type__c ='Sales';
     c7.Status__c ='Aktiv';
     c7.crm_function_working_area__c = 'IT';
     c7.Accountid= partyLevelacnt5.id;
     c7.crm_functional_decision_level__c ='User';
     conlist.add(c7); 
        
     Contact c8 = new Contact();
     c8.lastname= 'c8lastname';
     c8.email= 'c8email@test.com';
     c8.crm_Contact_Type__c ='Sales';
     c8.Status__c ='Aktiv';
     c8.Accountid= partyLevelacnt2.id;
     c8.crm_functional_decision_level__c ='';
     conlist.add(c8); 
        
        if(!conlist.isempty())
        insert conlist;
        
        Api_status__c api = new Api_status__c(value__c = 'Ikke oppdatert', name = 'APIStatus');
        insert api;
        
        EDI_Status__c edi = new EDI_Status__c(value__c = 'Ikke oppdatert', name = 'EDIStatus');
        insert edi;
        
        EDI_Vendor_Status__c edi_vndr = new EDI_Vendor_Status__c(value__c = 'Production', name = 'VendorStatus');
        insert edi_vndr;
     
   }
   
   static TestMethod void testbatch()
      {  
            
       crm_setprimarycontactAccount_Batch   acb = new crm_setprimarycontactAccount_Batch(''); 
        System.Test.startTest();
        Database.executeBatch(acb);           
        crm_setprimarycontactAcct_EDIAPI_Batch   spc = new crm_setprimarycontactAcct_EDIAPI_Batch(''); 
        Database.executeBatch(spc);    
        
        System.Test.stopTest(); 
        
       }
       
     static TestMethod void testtrigger()  {
       List<Contact> clist=[Select id, crm_functional_decision_level__c from Contact order by crm_functional_decision_level__c asc ];
       clist[0].crm_functional_decision_level__c ='User';
       update clist[0];
       
       clist[1].crm_functional_decision_level__c = 'User';
       update clist[1];
    }
    
  }