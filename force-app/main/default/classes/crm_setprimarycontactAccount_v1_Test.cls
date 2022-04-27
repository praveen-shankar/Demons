/* Date:12/1/2018
 * Test class for Create Contact lightning component
 */

@isTest
public class crm_setprimarycontactAccount_v1_Test {
    
    @testSetup static void setup() {
     crm_TestDataFactory.CreateCustomSetting();
   
       Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt1;
       
       
        Account partyLevelacnt2= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt2;
       
        Account partyLevelacnt3= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt3;
       
       
        Account partyLevelacnt4= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt4;
       
       Account partyLevelacnt5= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt5;
       
       Account partyLevelacnt6= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt6;
        
       Account partyLevelacnt7= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt7;
       
        
     Contact c1 = new Contact();
     c1.lastname= 'c1lastname';
     c1.email= 'c1email@test.com';
     c1.crm_Contact_Type__c ='Sales';
     c1.Status__c ='Aktiv';
     c1.Accountid= partyLevelacnt1.id;
     c1.crm_functional_decision_level__c ='Decision maker';
     insert c1;  
     
     Contact c2 = new Contact();
     c2.lastname= 'c2lastname';
     c2.email= 'c2email@test.com';
     c2.crm_Contact_Type__c ='Sales';
     c2.Status__c ='Aktiv';
     c2.Accountid= partyLevelacnt2.id;
     c2.crm_functional_decision_level__c ='Influencer';
     insert c2;  
     
     Contact c3 = new Contact();
     c3.lastname= 'c3lastname';
     c3.email= 'c3email@test.com';
     c3.crm_Contact_Type__c ='Sales';
     c3.Status__c ='Aktiv';
     c3.Accountid= partyLevelacnt3.id;
     c3.crm_functional_decision_level__c ='User';
     insert c3;  
     
     Contact c4 = new Contact();
     c4.lastname= 'c4lastname';
     c4.email= 'c4email@test.com';
     c4.crm_Contact_Type__c ='Sales';
     c4.Status__c ='Aktiv';
     c4.Accountid= partyLevelacnt4.id;
     c4.crm_functional_decision_level__c ='';
     insert c4;  
     
     Contact c5 = new Contact();
     c5.lastname= 'c5lastname';
     c5.email= 'c5email@test.com';
     c5.crm_Contact_Type__c ='Sales';
     c5.Status__c ='Aktiv';
     c5.Accountid= partyLevelacnt5.id;
     c5.crm_functional_decision_level__c ='Beslutningstaker';
     insert c5; 
        
     Contact c6 = new Contact();
     c6.lastname= 'c6lastname';
     c6.email= 'c6email@test.com';
     c6.crm_Contact_Type__c ='Sales';
     c6.Status__c ='Aktiv';
     c6.Accountid= partyLevelacnt6.id;
     c6.crm_functional_decision_level__c ='Påvirker';
     insert c6;
        
     Contact c7 = new Contact();
     c7.lastname= 'c7lastname';
     c7.email= 'c7email@test.com';
     c7.crm_Contact_Type__c ='Sales';
     c7.Status__c ='Aktiv';
     c7.Accountid= partyLevelacnt7.id;
     c7.crm_functional_decision_level__c ='Bruker';
     insert c7;
        
    }
   
   
   static TestMethod void testbatch()
      {  
            
       crm_setprimarycontactAccount_v1_Batch   acb = new crm_setprimarycontactAccount_v1_Batch(''); 
        System.Test.startTest();
        
        environment_settings__c  objCustomSetting = new environment_settings__c ();
        objCustomSetting.value__c='posten.salesforce@tcs.com';
        objCustomSetting.Name = 'BatchEmailNotification';
        insert objCustomSetting ;
                
        Database.executeBatch(acb);    
        
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