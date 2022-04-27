/* Date:12/1/2018
 * Test class for Search Account lightning component
 */


@isTest
public class searchAccountController_Test {
    
    @testSetup static void setup() {
       //create party level account
       crm_TestDataFactory.CreateCustomSetting();
         //BusinessStreet, BusinessCity, BillingState, BusinessPostalCode,  BusinessCountry,
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       partyLevelacnt.crm_bus_addr_City__c='Oslo';
       partyLevelacnt.crm_Company_Group_Name__c='ABB';
       partyLevelacnt.crm_bus_addr_Street__c='Park Street';
       partyLevelacnt.crm_bus_addr_Zip_Code__c='578394';
       partyLevelacnt.crm_bus_addr_Country__c='Norway';
       insert  partyLevelacnt;
       }
    
    static TestMethod void testSearchAccount()
      {         
          searchAccountController.fetchAccount('');
          searchAccountController.fetchAccount('parent test');
      }
}