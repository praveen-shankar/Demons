/* Created By: Supriya Goel
Date: 4th april  2016
Test class: crm_AgreementNotification
*/

@isTest
public class crm_NoRevenueAgreementNotificationTest{

@testSetup static void setup() {

        crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       insert  partyLevelacnt;
       
       //create agreement
        crm_Agreement__c agreement= crm_TestDataFactory.createAgreement();
        agreement.crm_Agreement_Name__c='test agreement';
        agreement.crm_Account__c = partyLevelacnt.id;
        agreement.crm_Status__c ='Draft';
        insert agreement;
       
       }

    static testMethod void testAgreementNotification(){
        
        crm_NoRevenueAgreementNotification classObj= new  crm_NoRevenueAgreementNotification('test');
        crm_Agreement__c  agr =[Select crm_Status__c from crm_Agreement__c where crm_Agreement_Name__c= 'test agreement' limit 1 ]  ;
        agr.crm_Status__c= 'Active';
        agr.crm_Send_Mail_to_owner__c=false;
        agr.crm_Realized_Contract_Value__c=0;
        agr.crm_Agreement_Start_Date__c  =System.today().adddays(-40);
        update agr;
        System.Test.startTest();
        Database.executeBatch(classObj);
        System.Test.stopTest();
     
    }
}