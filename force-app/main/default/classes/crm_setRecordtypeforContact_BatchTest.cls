/* Date:  5th april 2018
 * Test class for crm_setRecordtypeforContact_Batch 
 */

@isTest
public class crm_setRecordtypeforContact_BatchTest {
    
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
       con.crm_Contact_Type__c='Sales';
       con.Recordtypeid=RecordTypeId;
       insert con;
       
       Contact con1= crm_TestDataFactory.createContact();
       con1.accountid=relationLevelacnt1.id;
       con1.Status__c='Aktiv';
       con1.crm_Contact_Type__c='Customer Service';
       con1.Recordtypeid=RecordTypeId;
       insert con1;
       
       Contact con2= crm_TestDataFactory.createContact();
       con2.accountid=relationLevelacnt1.id;
       con2.Status__c='Inaktiv';
       con2.crm_Contact_Type__c='Customer Service';
       con2.Recordtypeid=RecordTypeId;
       insert con2;
              
       }
       
        static TestMethod void testBatch()
        {
            System.Test.StartTest();
            Database.executeBatch(new crm_setRecordtypeforContact_Batch());
            System.Test.StopTest();
        }
        
     }