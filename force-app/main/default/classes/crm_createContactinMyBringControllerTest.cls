@isTest
public class crm_createContactinMyBringControllerTest{

    @isTest
    private static void testcreateContactinMyBring() {
         
      Account partyLevelacnt= new Account();
        partyLevelacnt.Name='ABC TEST PARTY';
        partyLevelacnt.recordTypeId='012w000000072at';
        partyLevelacnt.crm_Count_of_Relation_level_Accounts__c=1;
        insert  partyLevelacnt;

        /*create relation level account
        Account relationLevelacnt= crm_TestDataFactory.createRelationlevelAccount();
        relationLevelacnt.parentId=partyLevelacnt.id;
        relationLevelacnt.crm_Primary_Customer_Account__c = true;
        insert  relationLevelacnt;*/
     
     //insert custom setting
        environment_settings__c lang = new environment_settings__c();
       lang.Name = 'Preferred_Language';
       lang.value__c = 'Danish=DK,English=EN,Finnish=FI,Norwegian=NO,Swedish=SV';
       insert lang; 
       
        Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        List<Contact> conlist= new List<Contact>();
        
         Contact con1=new Contact();
        con1.lastname='testmaping1';
        con1.email='Testmapping@cap.com';
        con1.AccountId=partyLevelacnt.id;
        con1.crm_Contact_Type__c='Sales';
        con1.recordtypeid=salesRecordTypeId;
        con1.Status__c='aktiv';
        con1.crm_Has_agreed_to_Marketing_actvities__c=false;
        con1.mybringStatus__c='active';
        con1.et4ae5__Mobile_Country_Code__c='NO';
        con1.Preferred_Language__c='English';
        insert con1;
        conlist.add(con1);
        
          Contact con2=new Contact();
        con2.lastname='testmapin2';
        con2.email='Testmapping2@cap.com';
        con2.AccountId=partyLevelacnt.id;
        con2.crm_Contact_Type__c='Sales';
        con2.recordtypeid=salesRecordTypeId;
        con2.Status__c='aktiv';
        con2.crm_Has_agreed_to_Marketing_actvities__c=false;
        con2.mybringStatus__c='active';
        con2.et4ae5__Mobile_Country_Code__c='NO';
        con2.Preferred_Language__c='English';
        con2.My_Bring_Userid__c='testid';
        insert con2;
        
        PageReference pref = Page.createcontact;       
        pref.getParameters().put('id',con1.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController stc = new ApexPages.StandardController(con1);
        crm_createContactinMyBringController objCtrl = new crm_createContactinMyBringController(stc);
        PageReference objPageRef = objCtrl.createContactinMyBring();
        //System.assertEquals (null,pref);
        //
      
        PageReference pref2 = Page.createcontact;       
        pref.getParameters().put('id',con2.id);
        Test.setCurrentPage(pref2);
        ApexPages.StandardController stc1 = new ApexPages.StandardController(con2);
        crm_createContactinMyBringController objCtrl1 = new crm_createContactinMyBringController(stc1);
        PageReference objPageRef1 = objCtrl1.createContactinMyBring();
    
    }
}