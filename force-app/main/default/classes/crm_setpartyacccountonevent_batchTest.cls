/* Created By: Supriya goel
Date: 31 may 2017
Test class: crm_setpartyacccountonevent_batch
*/

@isTest
public class crm_setpartyacccountonevent_batchTest{

@testSetup static void setup() {
    
    //create party level account   
    
    crm_TestDataFactory.CreateCustomSetting();
    environment_settings__c envSetting = new environment_settings__c();
    envSetting.Name = 'BatchEmailNotification'; 
  //  envSetting.ReplyToEmailAddress__c = 'test.salesforce@tcs.com';
    envSetting.value__c = 'test@posten.no';
    insert envSetting;
    Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
    partyLevelacnt.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  partyLevelacnt; 
    
    //create relation level accounts  
    Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
    relationLevelacnt1.parentId=partyLevelacnt.id;
    relationLevelacnt1.crm_Customer_Number__c='12345';
    relationLevelacnt1.crm_Posten_Source_Comp_for_datarecord_ER__c='BLNOCMP';
    insert  relationLevelacnt1;
    
    Contact con= crm_TestDataFactory.createContact();
    con.accountid=relationLevelacnt1.id;
    insert con;
    
    Contact con1= crm_TestDataFactory.createContact();
    con1.accountid=partyLevelacnt.id;
    insert con1;
    
    Event e = crm_TestDataFactory.createEvent();
    e.whoid= con.id;
    Insert e;
    
    Event e1 = crm_TestDataFactory.createEvent();
    e1.whoid= con1.id;
    Insert e1;
    
    }
    
    
     static TestMethod void testBatch()
        {
            System.Test.StartTest();
            Database.executeBatch(new crm_setpartyacccountonevent_batch('test'));
            System.Test.StopTest();
        }
    
    }