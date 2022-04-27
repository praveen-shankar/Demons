/* Date:  5th april 2018
 * Test class for crm_ContactCleanup_Batch 
 */

@isTest
public class crm_ContactCleanup_BatchCS_Test {
    
    @testSetup static void setup() {
       crm_TestDataFactory.CreateCustomSetting();
   
       Account partyLevelacnt1= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt1;
      
       Account relationLevelacnt1= crm_TestDataFactory.createRelationlevelAccount();
       relationLevelacnt1.parentId=partyLevelacnt1.id;
       insert  relationLevelacnt1;
       
       Id RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('External Contact').getRecordTypeId();
            
       Contact con= crm_TestDataFactory.createContact();
       con.accountid=relationLevelacnt1.id;
       con.Status__c='Aktiv';
       con.crm_Contact_Type__c='Sales/Customer Service';
       con.Recordtypeid=RecordTypeId;
       insert con;
       
       Contact con1= crm_TestDataFactory.createContact();
       con1.accountid=relationLevelacnt1.id;
       con1.Status__c='Aktiv';
       con1.crm_Contact_Type__c='Sales';
       con1.Recordtypeid=RecordTypeId;
       insert con1;
              
       }
       
        static TestMethod void testBatch()
        {
            System.Test.StartTest();
            Database.executeBatch(new crm_ContactCleanup_BatchCS());
            System.Test.StopTest();
        }
        
     }