/* Created By: Supriya Goel
Date: 2 july 2019
Test class: crm_AccountConversionRetrialBatch 
*/

@isTest()
public class crm_AccountConversionRetrialBatchTest{

@IsTest
static void testconvertedparty(){

       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account partyLevelacnt= crm_TestDataFactory.createPartylevelAccount();
       partyLevelacnt.Customer_Converted__c ='InPreparation';
       insert  partyLevelacnt;
       
       partyLevelacnt.Customer_Converted__c ='Converted';
       update partyLevelacnt;
       
       String status='Converted';
       List<Account> alist= [Select id from Account where Customer_Converted__c  =: status];
             
        crm_AccountConversionRetrialBatch  acb = new crm_AccountConversionRetrialBatch (alist[0].id); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
}