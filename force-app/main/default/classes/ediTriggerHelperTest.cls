@IsTest
private class ediTriggerHelperTest {
    
    @IsTest
  

    public static void testHelperClassTerminateEDI() {
        Test.startTest();
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType relrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'business_account'];
        Map<String,Schema.RecordTypeInfo> rtMap = Edi_Information__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account acc = new Account(Name='Party',Orga__c='23482747242',RecordTypeId=partyrt.Id,crm_Updated_by_CDH__c=true);
        insert acc;
        Account relacc = new Account(Name='Relation',Orga__c='23482747242',RecordTypeId=relrt.Id,ParentId=acc.Id,crm_Updated_by_CDH__c=true,crm_Customer_Number__c='459839450');
        insert relacc;
        Edi_Information__c ediInfo = new Edi_Information__c(RecordTypeId = rtMap.get('Native').getRecordTypeId(),crm_Account__c = relAcc.Id, Status__c = 'New', EDI_Identificator__c = 'ABC827430', Kvalificator__c = '30-ISO 6523');
        insert ediInfo;
        
        string LMRecordTypeId = [Select Id From RecordType where sobjecttype = 'EDI_System_Status__c' and developername like 'LM' limit 1].Id; 
        EDI_System_Status__c SysStatus = new EDI_System_Status__c();
        SysStatus.EDI__c = ediInfo.id;
        SysStatus.System_Name__c = 'LM';
        SysStatus.recordtypeid= LMRecordTypeId ;  
        insert SysStatus;
        
        string MBRecordTypeId = [Select Id From RecordType where sobjecttype = 'EDI_System_Status__c' and developername like 'MB' limit 1].Id; 
        EDI_System_Status__c SysStatus1 = new EDI_System_Status__c();
        SysStatus1.EDI__c = ediInfo.id;
        SysStatus1.System_Name__c = 'MB';
        SysStatus1.recordtypeid= MBRecordTypeId ;  
        insert SysStatus1;
        
        
        
        EDI_System_Status__c c = [SELECT Id,EDI__c,EDI__r.Imported_Data__c,EDI__r.Disqualified_for_Integration__c,EDI__r.Status__c,EDI__r.EDI_Files_Approved__c,EDI__r.Labels_Approved__c,Message_Sent__c,Message_Sent_After_Data_Change__c 
                                  FROM EDI_System_Status__c WHERE EDI__c =:ediInfo.id limit 1];
        c.Message_Sent__c = true;
        update c; 
        
        
        Edi_Information__c ediForupdate = [Select Id,Status__c,EDI_Identificator__c,Outbound_Message_Type__c,EDI_Files_Approved__c,Path__c,Prefix__c,Type__c,ID_Domain__c,ID_Format__c,My_Bring_ID__c FROM Edi_Information__c WHERE Id = :ediInfo.Id];
        ediForupdate.Status__c = 'PhaseOut';
        ediForupdate.EDI_Files_Approved__c =  true;
        ediForupdate.Path__c = 'Testing';
        ediForupdate.ID_Domain__c = 'test';
        ediForupdate.ID_Format__c = 'Testing';
        ediForupdate.Type__c = 'Testing';
        ediForupdate.My_Bring_ID__c  = 'Testing';
        ediForupdate.Prefix__c = 'Testing';
        ediForupdate.Labels_Approved__c = true;
        ediForupdate.Disqualified_for_Integration__c = true;
        ediForupdate.Outbound_Message_Type__c = 'FO-J';
        update ediForupdate;
        
        Edi_Information__c ediForupdate1 = [Select Id,Status__c,EDI_Identificator__c,EDI_Files_Approved__c,Path__c,Prefix__c,Type__c,ID_Domain__c,ID_Format__c,My_Bring_ID__c FROM Edi_Information__c WHERE Id = :ediForupdate.Id];
        ediForupdate1.Status__c = 'Terminated';
        update ediForupdate1;
        
        Test.stopTest();
    }   
    
}