/* Created By: Supriya goel
Date: 6th july 2017
Test class: crm_setpartyacccountontask_batch
*/

@isTest
public class crm_setpartyacccountontask_batchTest{

@testSetup static void setup() {
    
    //create party level account   
    
    crm_TestDataFactory.CreateCustomSetting();
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
    
    Task t = crm_TestDataFactory.createTask();
    t.whoid= con.id;
    Insert t;
    
    }
    
    
     static TestMethod void testBatch()
        {
            System.Test.StartTest();
            Database.executeBatch(new crm_setpartyacccountontask_batch('test'));
            System.Test.StopTest();
        }
    
    }