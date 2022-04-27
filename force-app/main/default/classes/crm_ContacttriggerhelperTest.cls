/*Date: 20th April 2018
Test class: Test class for the Contacttriggerhelper
*/

@isTest
public class crm_ContacttriggerhelperTest{

    static TestMethod void testcreatecontact() {
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

        Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();

        ContactTriggerSetting__c  objConCustomSetting = new ContactTriggerSetting__c();
        objConCustomSetting.Contact_Trigger_Status__c=true;
        objConCustomSetting.Name = 'Contact';
        insert objConCustomSetting;
        
        environment_settings__c  objCustomSetting1 = new environment_settings__c ();
        objCustomSetting1.value__c='System Administrator';
        objCustomSetting1.Name = 'Agreed_to_marketing_access';
        insert objCustomSetting1 ;
        
       /* environment_settings__c  objCustomSettingint = new environment_settings__c ();
        objCustomSettingint.value__c='true';
        objCustomSettingint.Name = 'ContactBringIntegrationSwitch';
        insert objCustomSettingint ;*/
        
         environment_settings__c  objCustomSettingint = new environment_settings__c ();
        objCustomSettingint.value__c='true';
        objCustomSettingint.Name = 'ContactBringIntegrationSwitch';
        insert objCustomSettingint ;

        List<Contact> conList = New List<Contact>();
        for(integer i=0; i<2; i++){
            Contact con=new Contact();
            con.lastname='testmaping'+i;
            con.email='Testmapping'+i+'@cap.com';
            con.AccountId=partyLevelacnt.id;
            con.crm_Contact_Type__c='Sales';
            con.recordtypeid=salesRecordTypeId;
            con.Status__c='Aktiv';
            con.Master_Reference_Id__c=null;
            con.crm_Has_agreed_to_Marketing_actvities__c= false;
            conList.add(con);
    	}
        insert conList;
        system.debug('Con : '+ conList);
        conList[0].crm_Has_agreed_to_Marketing_actvities__c=true;
        conList[0].MobilePhone='1234567890';
        update conList[0];
        
        conList[1].status__c ='Inaktiv';
        update conList[1];
        
        
        
        //for no to marketing activities coveragr
        Test.starttest();
        Contact con1=new contact();
        con1.lastname='testmaping';
        con1.email='Testmapping@cap.com';
        con1.AccountId=partyLevelacnt.id;
        con1.crm_contact_Type__c='Sales';
        con1.recordtypeid=salesRecordTypeId;
        con1.Status__c='Aktiv';
        con1.crm_Lead_map_field_for_Contact__c =true;
        con1.Master_Reference_Id__c=null;
        con1.crm_Has_agreed_to_Marketing_actvities__c= true;
        insert con1;
        system.debug('con1 : '+ con1);
        con1.MobilePhone='1234567890';
        con1.crm_Lead_map_field_for_Contact__c=false;
        update con1;
         test.stopTest();
        
        
       
            
    }

   

}