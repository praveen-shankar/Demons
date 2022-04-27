@IsTest
private class crm_edi_IntegrationController_test
{

    @testSetup static void setup() 
    {
        RecordType partyrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'crm_Party_level_Customer'];
        RecordType relrt = [Select Id From RecordType Where SObjectType = 'Account' And DeveloperName = 'business_account'];
        Account acc = new Account(Name='Party',Orga__c='2348274724',RecordTypeId=partyrt.Id,crm_Updated_by_CDH__c=true);
        insert acc;
        Account relacc = new Account(Name='Relation',Orga__c='2348274724',RecordTypeId=relrt.Id,ParentId=acc.Id,crm_Updated_by_CDH__c=true,crm_Customer_Number__c='45983945');
        insert relacc;
        
        Edi_Information__c objEdi= new Edi_Information__c();
        objEdi.name = 'test';
        objEdi.crm_Account__c = relacc.id;
        objEdi.Status__c = 'New';
        objEdi.Labels_Approved__c = true; 
        objEdi.EDI_Files_Approved__c = true;
        objEdi.EDI_Identificator__c = '2';
        objEdi.Kvalificator__c = '3';
        objEdi.Start_Date__c = system.today();
        objEdi.End_Date__c = system.today().addDays(10);
        objEdi.Inbound_Message_Type__c ='Inbound value';
        objEdi.Outbound_Message_Type__c ='outbound value';
        objEdi.Path__c = 'ash/to/next';
        objEdi.Prefix__c = 'aa';
        objEdi.My_Bring_ID__c = '1234';
        objEdi.Type__c = 'abcd';
        objEdi.ID_Domain__c = '1';
        objEdi.ID_Format__c = '2';
      
        insert objEdi; 
        
        string LMRecordTypeId = [Select Id From RecordType where sobjecttype = 'EDI_System_Status__c' and developername like 'LM' limit 1].Id;   
        
        EDI_System_Status__c statusobj=new EDI_System_Status__c();
        statusobj.EDI__c=objEdi.id;
        statusobj.System_Name__c= 'LM';  
        statusobj.recordtypeid= LMRecordTypeId ;    
        insert statusobj;
        
       string MBRecordTypeId = [Select Id From RecordType where sobjecttype = 'EDI_System_Status__c' and developername like 'MB' limit 1].Id; 
       EDI_System_Status__c SysStatus1 = new EDI_System_Status__c();
       SysStatus1.EDI__c = objEdi.id;
       SysStatus1.System_Name__c = 'MB';
       SysStatus1.recordtypeid= MBRecordTypeId ;  
       insert SysStatus1;
                       
    } 
      
    static testMethod void testSuccessResponse()
    {             
        Edi_Information__c objEdi =[Select id ,name from Edi_Information__c where name= 'test' limit 1];
        System.debug(objEdi.id);
        EDI_System_Status__c[]  ediData = [SELECT Id, Name,  System_Name__c from EDI_System_Status__c   WHERE EDI__c =:objEdi.id];
               
        Test.startTest();
              
        crm_edi_LightningIntegrationController.getInitialData(objEdi.id);
        
        Test.setMock(HttpCalloutMock.class, new crm_ediIntegration_mock('SUCCESS')); 
        crm_edi_LightningIntegrationController.process(objEdi.id, 'LM');  
        
        crm_edi_LightningIntegrationController.process(objEdi.id, 'MB');
           
        objEdi.Status__c = 'Testing';
        objEdi.Active__c= false; 
        update objEdi;    
            
        crm_edi_LightningIntegrationController.process(objEdi.id, 'LM');      
                         
        Test.stopTest();
                       
    }
    
    static testMethod void testErrorResponse()
    {
             
       Edi_Information__c objEdi =[Select id ,name from Edi_Information__c where name= 'test' limit 1];
              
       Test.startTest();
       Test.setMock(HttpCalloutMock.class, new crm_ediIntegration_mock('ERROR')); 
       crm_edi_LightningIntegrationController.process(objEdi.id, 'LM');  
                   
       Test.stopTest();
                       
    }
    
    static testMethod void testNotOkresponse()
    {
             
       Edi_Information__c objEdi =[Select id ,name from Edi_Information__c where name= 'test' limit 1];
        
       Test.startTest();
        
       Test.setMock(HttpCalloutMock.class, new crm_ediIntegration_mock('NOT_OK')); 
       crm_edi_LightningIntegrationController.process(objEdi.id, 'LM');  
       
       Test.stopTest();
                       
    }
    
    static testMethod void testNotNoresponse()
    {
             
       Edi_Information__c objEdi =[Select id ,name from Edi_Information__c where name= 'test' limit 1];
              
       Test.startTest();
        
       Test.setMock(HttpCalloutMock.class, new crm_ediIntegration_mock('NORESPONSE')); 
       crm_edi_LightningIntegrationController.process(objEdi.id, 'LM');  
        
       Test.stopTest();
                       
    }
}