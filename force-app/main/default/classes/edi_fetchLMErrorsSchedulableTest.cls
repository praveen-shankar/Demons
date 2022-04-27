@isTest
public class edi_fetchLMErrorsSchedulableTest{ 
    static testmethod void schedulerTest() {
        String CRON_EXP = '0 0 0 15 3 ? *';
        // Create your test data
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType relrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'business_account'];
        Map<String,Schema.RecordTypeInfo> rtMap = Edi_Information__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account acc = new Account(Name='Party',Orga__c='23482747241',RecordTypeId=partyrt.Id,crm_Updated_by_CDH__c=true);
        insert acc;
        Account relacc = new Account(Name='Relation',Orga__c='23482747241',RecordTypeId=relrt.Id,ParentId=acc.Id,crm_Updated_by_CDH__c=true,crm_Customer_Number__c='459839451');
        insert relacc;
        Edi_Information__c edi = new Edi_Information__c(E_mail_for_LM_error_notifications__c='abc@gmail.com',RecordTypeId = rtMap.get('Native').getRecordTypeId(),crm_Account__c = relAcc.Id, Status__c = 'New', EDI_Identificator__c = '98466118504', Kvalificator__c = '30-ISO 6523');
        insert edi;
        
        environment_settings__c env = new environment_settings__c ();
        env.Name = 'EDI_LM_Callout_interval_minutes';
        env.value__c='-30';
        insert env;    
           
        Test.setMock(HttpCalloutMock.class, new edi_getRejectedLM_API_Mock());
        Test.startTest();
        String jobId = System.schedule('edi_fetchLMErrorsAndEmailJob','0 0 * * * ?' , new edi_fetchLMErrorsSchedulable());
        Test.stopTest();
    }    
}