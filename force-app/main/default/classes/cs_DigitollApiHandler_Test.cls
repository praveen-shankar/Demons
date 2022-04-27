@isTest
public class cs_DigitollApiHandler_Test {
        
    @TestSetup
    public static void setupTestData(){
        Id partyRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('crm_Party_level_Customer').getRecordTypeId();
        Id relationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('business_account').getRecordTypeId();
        
        Account partyAcc = New Account(Name='Test Party Customer', orga__c='980089', recordTypeId=partyRecordTypeID);
        insert partyAcc;
        
        Account relAcc = New Account(Name='Test Relation Customer', crm_Customer_Number__c='125521',  ParentId=partyAcc.Id, recordTypeId=relationRecordTypeId);
        insert relAcc;
        
        /*Digitoll_Urls__c disqualifierApi_GetRequest = New Digitoll_Urls__c();
        disqualifierApi_GetRequest.Name = 'Get disqualified status from PB';
        disqualifierApi_GetRequest.Api_Url__c = 'https://api.qa.posten.cloud/private-base/disqualifier?partynumber=';
        disqualifierApi_GetRequest.Username__c = 'SALESFORCE';
        disqualifierApi_GetRequest.Password__c = 'SALESFORCE_password';
        insert disqualifierApi_GetRequest;*/
        
        Digitoll_Urls__c preferenceApi = New Digitoll_Urls__c();
        preferenceApi.Name = 'Person Preference';
        preferenceApi.Api_Url__c = 'https://api.qa.posten.cloud/private-base/person-preference?';//updated as part of Endpoint change 24March2021
        //preferenceApi.Api_Url__c = 'https://api.qa.posten.cloud/private-base/person-preference/';
        preferenceApi.Username__c = 'SALESFORCE';
        preferenceApi.Password__c = 'SALESFORCE_password';
        insert preferenceApi;
        
        Digitoll_Urls__c disqualifierApi_PutRequest = New Digitoll_Urls__c();
        disqualifierApi_PutRequest.Name = 'Update disqualified status to PB';
        disqualifierApi_PutRequest.Api_Url__c = 'https://api.qa.posten.cloud/private-base/disqualifier/{status}?personid=';
        disqualifierApi_PutRequest.Username__c = 'SALESFORCE';
        disqualifierApi_PutRequest.Password__c = 'SALESFORCE_password';
        insert disqualifierApi_PutRequest;
    }
    
    /*@isTest
    public static void getdisqualifyStatusAndConsent(){
        Account rel_Acc = [Select id, crm_Customer_Number__c from account where crm_Customer_Number__c='125521'];
 
        String body = ' [{"preferenceTypeCode": "RESERVATION_CUSTOMS_CLEARANCE","preferenceValue": true,"preferenceDescription": "","preferenceCategory": ""},';
        body += '{"preferenceTypeCode": "RESERVATION_CUSTOMS_DIGITAL","preferenceValue": true,"preferenceDescription": "Reservasjon mot elektronisk tollbehandling","preferenceCategory": "Customs"}]';
                
        RequestMock disqualifierAPI_GetResponse = New RequestMock(200, 'OK', '{"personId": 12345, "disqualifiedStatus": true}');
        RequestMock preferenceAPI_GetResponse = New RequestMock(200, 'OK', body);
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://api.qa.posten.cloud/private-base/disqualifier?partynumber=125521',disqualifierAPI_GetResponse);
        //updated as part of Endpoint change 24March2021
        endpoint2TestResp.put('https://api.qa.posten.cloud/private-base/person-preference?partynumber=125521',preferenceAPI_GetResponse);
        //--End update 24March2021--
        //endpoint2TestResp.put('https://api.qa.posten.cloud/private-base/person-preference/12345',preferenceAPI_GetResponse);
        
        Test.startTest();
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        ApexPages.StandardController sc = New ApexPages.StandardController(rel_Acc);
        cs_DigitollApiHandler apiHandler = New cs_DigitollApiHandler(sc);
        //cs_DigitollApiHandler.isTestClass=true;//updated as part of Endpoint change 24March2021
        PageReference page = apiHandler.getdisqualifyStatusFromPB();
        Test.StopTest();
    }
    
    @isTest
    public static void nonNumericFarPartyNumber(){
        Account rel_Acc = [Select id, crm_Customer_Number__c from account where crm_Customer_Number__c='125521'];
        
        rel_Acc.crm_Customer_Number__c = 'FAR125521';
        update rel_Acc;
        
        ApexPages.StandardController sc = New ApexPages.StandardController(rel_Acc);
        cs_DigitollApiHandler apiHandler = New cs_DigitollApiHandler(sc);
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
        cs_DigitollApiHandler apiHandler = New cs_DigitollApiHandler(sc);
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
        cs_DigitollApiHandler apiHandler = New cs_DigitollApiHandler(sc);
        PageReference page = apiHandler.getdisqualifyStatusFromPB();
        Test.StopTest();        
    }
    
    @isTest
    public static void errorInGetPersonPreference(){
        Account rel_Acc = [Select id, crm_Customer_Number__c from account where crm_Customer_Number__c='125521'];
 
        String respBody = '{"timeStamp": "2020-11-19T15:56:49.711974","status": "FORBIDDEN","error": "No Access","message": "","correlationId": ""}';
        
        RequestMock disqualifierAPI_GetResponse = New RequestMock(200, 'OK', '{"personId": 12345, "disqualifiedStatus": true}');
        RequestMock preferenceAPI_GetResponse = New RequestMock(403, 'null', respBody);
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('https://api.qa.posten.cloud/private-base/disqualifier?partynumber=125521',disqualifierAPI_GetResponse);
        //updated as part of Endpoint change 24March2021
        endpoint2TestResp.put('https://api.qa.posten.cloud/private-base/person-preference?partynumber=125521',preferenceAPI_GetResponse);
        //--end update 24March2021--
        //endpoint2TestResp.put('https://api.qa.posten.cloud/private-base/person-preference/12345',preferenceAPI_GetResponse);
        
        Test.startTest();
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        ApexPages.StandardController sc = New ApexPages.StandardController(rel_Acc);
        cs_DigitollApiHandler apiHandler = New cs_DigitollApiHandler(sc);
        //cs_DigitollApiHandler.isTestClass=true;//updated as part of Endpoint change 24March2021
        PageReference page = apiHandler.getdisqualifyStatusFromPB();
        Test.StopTest();
    }*/
    
    @isTest
    public static void requalifyCustomer_success(){
        Account rel_Acc = [Select id, crm_Customer_Number__c, person_Id__c, Disqualified__c from account where crm_Customer_Number__c='125521'];
        rel_Acc.Person_Id__c = '12345';
        rel_Acc.Disqualified__c = true;
        update rel_Acc;
        system.debug('New Person Id and Disqualified status ========== ' + rel_Acc.Person_Id__c + ' ' + rel_Acc.Disqualified__c);
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new RequestMock(200, 'OK', ''));
            rel_Acc.Disqualified__c = false;
            update rel_Acc;
        Test.stopTest();
    }
    
    @isTest
    public static void requalifyCustomer_error_400(){
        Account rel_Acc = [Select id, crm_Customer_Number__c, person_Id__c, Disqualified__c from account where crm_Customer_Number__c='125521'];
        rel_Acc.Person_Id__c = '12345';
        rel_Acc.Disqualified__c = true;
        update rel_Acc;
        system.debug('New Person Id and Disqualified status ========== ' + rel_Acc.Person_Id__c + ' ' + rel_Acc.Disqualified__c);
        
        Test.startTest();
        String respBody = '{"timeStamp": "2020-11-19T15:56:49.711974","status": "BAD_REQUEST","error": "Person Not Found Exception",';
        respBody += '"message": "personId: 12345 doesnt exist.","correlationId": "4fcb6f1a-0826-42be-88b0-c39f759c136d"}';

            Test.setMock(HttpCalloutMock.class, new RequestMock(400, 'null', respBody));
            rel_Acc.Disqualified__c = false;
            update rel_Acc;
        Test.stopTest();
    }
    
    @isTest
    public static void requalifyCustomer_error(){
        Account rel_Acc = [Select id, crm_Customer_Number__c, person_Id__c, Disqualified__c from account where crm_Customer_Number__c='125521'];
        rel_Acc.Person_Id__c = '12345';
        rel_Acc.Disqualified__c = true;
        update rel_Acc;
        system.debug('New Person Id and Disqualified status ========== ' + rel_Acc.Person_Id__c + ' ' + rel_Acc.Disqualified__c);
        
        Test.startTest();
            String respBody = '{"timeStamp": "2020-11-19T15:56:49.711974","status": "FORBIDDEN","error": "No Access","message": "","correlationId": ""}';

            Test.setMock(HttpCalloutMock.class, new RequestMock(403, 'null', respBody));
            rel_Acc.Disqualified__c = false;
            update rel_Acc;
        Test.stopTest();
    }
    
    @isTest
    public static void updatePersonPreference_success(){
        Account rel_Acc = [Select id, crm_Customer_Number__c, person_Id__c, Do_not_want_custom_clearance__c from account where crm_Customer_Number__c='125521'];
        rel_Acc.Person_Id__c = '12345';
        update rel_Acc;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new RequestMock(200, 'OK', ''));
            rel_Acc.Do_not_want_custom_clearance__c = true;
            update rel_Acc;
        Test.stopTest();
    }
    
    @isTest
    public static void updatePersonPreference_error_400(){
        Account rel_Acc = [Select id, crm_Customer_Number__c, person_Id__c, Do_not_want_custom_clearance__c from account where crm_Customer_Number__c='125521'];
        rel_Acc.Person_Id__c = '12345';
        update rel_Acc;
        
        Test.startTest();
        String respBody = '{"timeStamp": "2020-11-19T15:56:49.711974","status": "400","error": "Bad Request",';
        respBody += '"message": "personId: 12345 doesnt exist.","path": ""/person-preference/12345"}';

            Test.setMock(HttpCalloutMock.class, new RequestMock(400, 'null', respBody));
            rel_Acc.Do_not_want_custom_clearance__c = true;
            update rel_Acc;
        Test.stopTest();
    }
    
    @isTest
    public static void updatePersonPreference_error(){
        Account rel_Acc = [Select id, crm_Customer_Number__c, person_Id__c, Do_not_want_custom_clearance__c from account where crm_Customer_Number__c='125521'];
        rel_Acc.Person_Id__c = '12345';
        update rel_Acc;
        
        Test.startTest();
        String respBody = '{"timeStamp": "2020-11-19T15:56:49.711974","status": "403","error": "FORBIDDEN",';
        respBody += '"message": "FORBIDDEN ACCESS","path": ""/person-preference/12345"}';

            Test.setMock(HttpCalloutMock.class, new RequestMock(403, 'null', respBody));
            rel_Acc.Do_not_want_custom_clearance__c = true;
            update rel_Acc;
        Test.stopTest();
    }
    
}