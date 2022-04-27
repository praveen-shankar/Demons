@isTest
public class ErrorVFCallerController_Test {
    
    @TestSetup
    public static void testRecords(){
        Id partyRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('crm_Party_level_Customer').getRecordTypeId();
        Id relationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('business_account').getRecordTypeId();
        
        Account partyAcc = New Account(Name='Test Party Customer', orga__c='980089', recordTypeId=partyRecordTypeID);
        insert partyAcc;
        
        Account relAcc = New Account(Name='Test Relation Customer', crm_Customer_Number__c='125521',  ParentId=partyAcc.Id, recordTypeId=relationRecordTypeId);
        insert relAcc;
    }
    
    @isTest
    public static void updateErrorField_Account_Error(){
        Account acc = [Select Id, Trigger_Callout_Status__c, Trigger_Callout_Message__c from Account where name = 'Test Relation Customer'];
        acc.Trigger_Callout_Status__c = 'Error';
        acc.Trigger_Callout_Message__c = 'An Error Occured';
        update acc;
                
        Test.StartTest();
            ErrorVFCallerController.updateErrorField(acc.Id);
        Test.StopTest();

    }
    
    @isTest
    public static void updateErrorField_Account_Success(){
        Account acc = [Select Id, Trigger_Callout_Status__c, Trigger_Callout_Message__c from Account where name = 'Test Relation Customer'];
                
        acc.Trigger_Callout_Status__c = 'Success';
        acc.Trigger_Callout_Message__c = 'Success : Record Updated Successfully';
        update acc;
        
        Test.startTest();
            ErrorVFCallerController.updateErrorField(acc.Id);
        Test.stopTest();
    }
}