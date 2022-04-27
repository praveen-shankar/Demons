/*Date: 25th jan 2019
Test class: Test class for the crm_contactIntegrationController
*/

@isTest
public class crm_contactIntegrationControllerTest{

	@IsTest static void testcontactintegration() {
    //create party level account
        crm_TestDataFactory.CreateCustomSetting();
        //BusinessStreet, BusinessCity, BillingState, BusinessPostalCode,  BusinessCountry,
        Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
        partyLevelacnt.crm_Count_of_Relation_level_Accounts__c=1;
        insert  partyLevelacnt;

        //create relation level account
        Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt.parentId=partyLevelacnt.id;
        relationLevelacnt.crm_Primary_Customer_Account__c = true;
        insert  relationLevelacnt;
        
         //insert custom setting
       environment_settings__c env = new environment_settings__c();
  	   env.Name = 'ContactBringIntegrationSwitch';
       env.value__c = 'true';
       insert env;
        
       environment_settings__c lang = new environment_settings__c();
  	   lang.Name = 'Preferred_Language';
       lang.value__c = 'Danish=DK,English=EN,Finnish=FI,Norwegian=NO,Swedish=SV';
       insert lang;
        
        environment_settings__c mybringCredentials = New environment_settings__c(name = 'MyBringcredentials', value__c = 'X-Salesforce-Api-Name:salesforce@bring.com;X-Salesforce-Api-Key:mXNBiw1qAuich9K5Atlh4NKVdXMDYmyLLLW4IXuSTc6BlQFvK2;');
        insert mybringCredentials;
        
        environment_settings__c envMobCode = New environment_settings__c(name='MobileCountryCodes', value__c='+47=NO, +1=US');
    	insert envMobCode;
          Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        List<Contact> conList = New List<Contact>();
        for(integer i=0; i<2; i++){
            Contact con1=new Contact();
            con1.lastname='testmaping'+i;
            con1.email='Testmapping'+i+'@cap.com';
            con1.AccountId=partyLevelacnt.id;
            con1.crm_Contact_Type__c='Sales';
            con1.recordtypeid=salesRecordTypeId;
            con1.Status__c='aktiv';
            con1.crm_Has_agreed_to_Marketing_actvities__c=false;
            con1.mybringStatus__c='active';
            con1.et4ae5__Mobile_Country_Code__c='NO';
            con1.Preferred_Language__c='English';
            con1.My_Bring_Userid__c='testid'+i;
            conList.add(con1);
    	}
        insert conList;
        
        Test.setMock(HttpCalloutMock.class, new crm_convertCustomerIntegration_mock());
        conList[0].Phone='1233';
        update conList[0];
        
        System.enqueueJob(new crm_contactIntegrationController(new List<Id>{conList[0].Id}));
        
        conList[1].status__c = 'Inactive';
        conList[1].et4ae5__Mobile_Country_Code__c = null;
        conList[1].My_Bring_Userid__c = null;
        update conList[1];
        System.enqueueJob(new crm_contactIntegrationController(new List<Id>{conList[1].Id}));
        
    }
}