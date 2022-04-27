@isTest
public class cs_DisqualifyHandler_Test {
 @TestSetup
    public static void setupTestData(){
        Id partyRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('crm_Party_level_Customer').getRecordTypeId();
        Id relationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('business_account').getRecordTypeId();
        
        Account partyAcc = New Account(Name='Test Party Customer', orga__c='980089', recordTypeId=partyRecordTypeID);
        insert partyAcc;
        
        Account relAcc = New Account(Name='Test Relation Customer', crm_Customer_Number__c='125521',  ParentId=partyAcc.Id, recordTypeId=relationRecordTypeId);
        insert relAcc;
        
        Digitoll_Urls__c disqualifierApi_GetRequest = New Digitoll_Urls__c();
        disqualifierApi_GetRequest.Name = 'Get disqualified status from PB';
        disqualifierApi_GetRequest.Api_Url__c = 'https://api.qa.posten.cloud/private-base/disqualifier?partynumber=';
        disqualifierApi_GetRequest.Username__c = 'SALESFORCE';
        disqualifierApi_GetRequest.Password__c = 'SALESFORCE_password';
        insert disqualifierApi_GetRequest;      
              
    }
    
    @isTest
    public static void getdisqualifyStatus(){
        Account rel_Acc = [Select id, crm_Customer_Number__c from account where crm_Customer_Number__c='125521'];
 
        String body = ' [{"preferenceTypeCode": "RESERVATION_CUSTOMS_CLEARANCE","preferenceValue": true,"preferenceDescription": "","preferenceCategory": ""},';
        body += '{"preferenceTypeCode": "RESERVATION_CUSTOMS_DIGITAL","preferenceValue": true,"preferenceDescription": "Reservasjon mot elektronisk tollbehandling","preferenceCategory": "Customs"}]';
                
        RequestMock disqualifierAPI_GetResponse = New RequestMock(200, 'OK', '{"personId": 12345, "disqualifiedStatus": true}');
        
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://api.qa.posten.cloud/private-base/disqualifier?partynumber=125521',disqualifierAPI_GetResponse);
        
        
        Test.startTest();
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        ApexPages.StandardController sc = New ApexPages.StandardController(rel_Acc);
        cs_DisqualifyHandler apiHandler = New cs_DisqualifyHandler(sc);
        PageReference page = apiHandler.getdisqualifyStatusFromPB();
        Test.StopTest();
    }
    
    @isTest
    public static void nonNumericFarPartyNumber(){
        Account rel_Acc = [Select id, crm_Customer_Number__c from account where crm_Customer_Number__c='125521'];
        
        rel_Acc.crm_Customer_Number__c = 'FAR125521';
        update rel_Acc;
        
        ApexPages.StandardController sc = New ApexPages.StandardController(rel_Acc);
        cs_DisqualifyHandler apiHandler = New cs_DisqualifyHandler(sc);
        PageReference page = apiHandler.getdisqualifyStatusFromPB();
    }
    
    @isTest
    public static void errorInDisqualifierGetCall_400(){
        Account rel_Acc = [Select id, crm_Customer_Number__c from account where crm_Customer_Number__c='125521'];
 
        Test.startTest();
        String respBody = '{"timeStamp": "2020-11-19T15:56:49.711974","status": "BAD_REQUEST","error": "Person Not Found Exception",';
        respBody += '"message": "personId: 12345 doesnt exist.","correlationId": "4fcb6f1a-0826-42be-88b0-c39f759c136d"}';
        
        Test.setMock(HttpCalloutMock.class, new RequestMock(400, 'OK', respBody));
        
        ApexPages.StandardController sc = New ApexPages.StandardController(rel_Acc);
        cs_DisqualifyHandler apiHandler = New cs_DisqualifyHandler(sc);
        PageReference page = apiHandler.getdisqualifyStatusFromPB();
        Test.StopTest();
    }
    
    @isTest
    public static void errorInDisqualifierGetCall(){
        Account rel_Acc = [Select id, crm_Customer_Number__c from account where crm_Customer_Number__c='125521'];
 
        Test.startTest();
        String respBody = '{"timeStamp": "2020-11-19T15:56:49.711974","status": "FORBIDDEN","error": "No Access","message": "","correlationId": ""}';
        
        Test.setMock(HttpCalloutMock.class, new RequestMock(403, 'null', respBody));
        
        ApexPages.StandardController sc = New ApexPages.StandardController(rel_Acc);
        cs_DisqualifyHandler apiHandler = New cs_DisqualifyHandler(sc);
        PageReference page = apiHandler.getdisqualifyStatusFromPB();
        Test.StopTest();        
    }
}