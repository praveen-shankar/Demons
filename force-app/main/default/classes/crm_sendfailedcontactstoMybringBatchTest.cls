@isTest
public class crm_sendfailedcontactstoMybringBatchTest {

    @isTest
     static void crm_sendfailedcontactstoMybring() {
        Account partyLevelacnt= new Account();
        partyLevelacnt.Name='ABC TEST PARTY';
        partyLevelacnt.recordTypeId='012w000000072at';
        partyLevelacnt.crm_Count_of_Relation_level_Accounts__c=1;
        insert  partyLevelacnt;
        
          Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        
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
        con1.crm_Callout_Status__c='Callout Pending';
         con1.My_Bring_Userid__c='testid';
        insert con1;
         
        // crm_sendfailedcontactstoMybringBatch acb = new crm_sendfailedcontactstoMybringBatch('test'); 
        System.Test.startTest();
        crm_sendfailedcontactstoMybringBatch obj= new crm_sendfailedcontactstoMybringBatch();
         Database.executeBatch(obj);
        
        System.Test.stopTest();
         
}
}