/* Created By: Supriya Goel
Date:25th jan 2019
Test class: crm_sendcontactstoMybringBatch
*/

@isTest()
public class crm_sendcontactstoMybringBatch_Test{

@testSetup static void setup() {

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
        
        Contact con=new Contact();
        con.lastname='testmaping';
        con.email='Testmapping@cap.com';
        con.AccountId=partyLevelacnt.id;
        con.crm_Contact_Type__c='Sales';
        con.recordtypeid=salesRecordTypeId;
        con.Status__c='Aktiv';
        con.My_Bring_Userid__c='1234';
        con.mybringStatus__c='active';
        insert con;


}

static testMethod void testmethodsynccontact(){
        crm_sendcontactstoMybringBatch acb = new crm_sendcontactstoMybringBatch(); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
}