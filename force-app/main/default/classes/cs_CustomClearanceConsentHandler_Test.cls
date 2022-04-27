@isTest
public class cs_CustomClearanceConsentHandler_Test {
	
    @TestSetup
    public static void setupTestData(){
        Id partyRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('crm_Party_level_Customer').getRecordTypeId();
        Id relationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('business_account').getRecordTypeId();
        
        Account partyAcc = New Account(Name='Test Party Customer', orga__c='980089', recordTypeId=partyRecordTypeID);
        insert partyAcc;
        
        Account relAcc = New Account(Name='Test Relation Customer', crm_Customer_Number__c='125521',  ParentId=partyAcc.Id, recordTypeId=relationRecordTypeId);
        insert relAcc;
        
               
        Digitoll_Urls__c preferenceApi = New Digitoll_Urls__c();
        preferenceApi.Name = 'Person Preference';
        preferenceApi.Api_Url__c = 'https://api.qa.posten.cloud/private-base/person-preference?';
        preferenceApi.Username__c = 'SALESFORCE';
        preferenceApi.Password__c = 'SALESFORCE_password';
        insert preferenceApi;        
    }
    
    @isTest
    public static void getConsent(){
        Account rel_Acc = [Select id, crm_Customer_Number__c from account where crm_Customer_Number__c='125521'];
 
        String body = ' [{"preferenceTypeCode": "RESERVATION_CUSTOMS_CLEARANCE","preferenceValue": true,"preferenceDescription": "","preferenceCategory": ""},';
        body += '{"preferenceTypeCode": "RESERVATION_CUSTOMS_DIGITAL","preferenceValue": true,"preferenceDescription": "Reservasjon mot elektronisk tollbehandling","preferenceCategory": "Customs"}]';
                
        RequestMock preferenceAPI_GetResponse = New RequestMock(200, 'OK', body);
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://api.qa.posten.cloud/private-base/person-preference?partynumber=125521',preferenceAPI_GetResponse);
                
        Test.startTest();
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        ApexPages.StandardController sc = New ApexPages.StandardController(rel_Acc);
        cs_CustomClearanceConsentHandler apiHandler = New cs_CustomClearanceConsentHandler(sc);
        PageReference page = apiHandler.getCustomClearanceConsentFromPB();
        Test.StopTest();
    }
    
    @isTest
    public static void nonNumericFarPartyNumber(){
        Account rel_Acc = [Select id, crm_Customer_Number__c from account where crm_Customer_Number__c='125521'];
        
        rel_Acc.crm_Customer_Number__c = 'FAR125521';
        update rel_Acc;
        
        ApexPages.StandardController sc = New ApexPages.StandardController(rel_Acc);
        cs_CustomClearanceConsentHandler apiHandler = New cs_CustomClearanceConsentHandler(sc);
        PageReference page = apiHandler.getCustomClearanceConsentFromPB();
    }
    
    @isTest
    public static void errorInGetPersonPreference(){
        Account rel_Acc = [Select id, crm_Customer_Number__c from account where crm_Customer_Number__c='125521'];
 
        String respBody = '{"timeStamp": "2020-11-19T15:56:49.711974","status": "FORBIDDEN","error": "No Access","message": "","correlationId": ""}';
        
        RequestMock preferenceAPI_GetResponse = New RequestMock(403, 'null', respBody);
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://api.qa.posten.cloud/private-base/person-preference?partynumber=125521',preferenceAPI_GetResponse);
                
        Test.startTest();
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        ApexPages.StandardController sc = New ApexPages.StandardController(rel_Acc);
        cs_CustomClearanceConsentHandler apiHandler = New cs_CustomClearanceConsentHandler(sc);
        PageReference page = apiHandler.getCustomClearanceConsentFromPB();
        Test.StopTest();
    }
}