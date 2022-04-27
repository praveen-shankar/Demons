/* Created By: Supriya Goel
Date: 14th may 2019 
Test class: crm_setcdhrowidonprivate_Batch
*/

@isTest()
public class crm_setcdhrowidonprivate_BatchTest{

@testSetup static void setup() {

       crm_TestDataFactory.CreateCustomSetting();
       //create party level account
       Account privateacnt = new Account();
      
     
       
       //create relation level account
       privateacnt.firstname='Privatetest';
       privateacnt.lastname='account';
       string RecordTypeId = [Select Id From RecordType where sobjecttype = 'Account' and name like 'Privat' limit 1].Id;   
       privateacnt.recordtypeid=RecordTypeId;
       privateacnt.crm_CDH_RowId__c ='123';
       insert  privateacnt;
       
       }
       
        static testMethod void testparty(){
        crm_setcdhrowidonprivate_Batch acb = new crm_setcdhrowidonprivate_Batch('test'); 
        System.Test.startTest();
        Database.executeBatch(acb);    
        
        System.Test.stopTest(); 
    }
}