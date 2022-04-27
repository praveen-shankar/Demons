/*
Created By:Supriya goel
Date:12th oct 2019
Test class for Delete_EDIErrorLogsBatch
*/

@isTest
public class Delete_EDIErrorLogsBatchTest
{
   @testSetup static void setup() 
   {
   
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType relrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'business_account'];
        Map<String,Schema.RecordTypeInfo> rtMap = Edi_Information__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Account acc = new Account(Name='Party',Orga__c='23482747241',RecordTypeId=partyrt.Id,crm_Updated_by_CDH__c=true);
        insert acc;
        Account relacc = new Account(Name='Relation',Orga__c='23482747241',RecordTypeId=relrt.Id,ParentId=acc.Id,crm_Updated_by_CDH__c=true,crm_Customer_Number__c='459839451');
        insert relacc;
        Edi_Information__c edi = new Edi_Information__c(E_mail_for_LM_error_notifications__c='abc@gmail.com',RecordTypeId = rtMap.get('Native').getRecordTypeId(),crm_Account__c = relAcc.Id, Status__c = 'New', EDI_Identificator__c = '98466118504', Kvalificator__c = '30-ISO 6523');
        insert edi;
        
        EDI_LM_Error__c  errObj=new EDI_LM_Error__c ();
        errObj.Name ='testerror';
        errObj.Status__c ='error';
        errObj.Parcel_Number__c ='1202';
        errObj.Failure_Message__c ='error';
        errObj.EDI__c = edi.id;
             
        insert errObj; 
       
   }
   
   testMethod static void DeleteTempTest()
   {    
        System.Test.startTest();
        Delete_EDIErrorLogsBatch batchObj=new Delete_EDIErrorLogsBatch();
        DataBase.executebatch(batchObj,10);
        System.Test.StopTest();
        
       
   }
}