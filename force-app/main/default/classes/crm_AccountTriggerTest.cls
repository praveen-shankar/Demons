@isTest()
public class crm_AccountTriggerTest{

   static testmethod void insertaccounttest(){

       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       partyLevelacnt.crm_Lead_mapped_field__c = '1';
       insert  partyLevelacnt;
    
       
       update partyLevelacnt;
       
       //create relation level account
           
       }
       
     }