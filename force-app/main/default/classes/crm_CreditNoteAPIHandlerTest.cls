@isTest
public class crm_CreditNoteAPIHandlerTest {
    public static testMethod void getResponseFromPaymentwebTest() {
        
        Test.startTest();
        
       // User userDetails = getUserDetails();
        //System.runAs(userDetails){
            String strRequestJSON = crm_CreditNoteController.getRequestJSON('test','','','','');
        Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'POST',
                                                 'OK',
                                                 '{"userName" : "tes", "phoneNumber" : "","emailAddress" : "","orderNumber" : "", "shipmentNumber" : ""}',
                                                 null));
        HttpResponse res = crm_CreditNoteAPIHandler.getResponseFromPaymentWeb(strRequestJSON);
           System.debug('res-----------'+res);
            System.debug('Consdtrucvtor response ----------------'+new crm_CreditNoteCalloutMockTest(200,'POST',
                                                 'Complete',
                                                 '{"userName" : "tes", "phoneNumber" : "","emailAddress" : "","orderNumber" : "", "shipmentNumber" : ""}',
                                                 null));
            
        //String testzxcv = crm_CreditNoteAPIHandler.sendTransactionRecord('test','test');
       // }
        
        Test.stopTest();
    
    }
    
     public static testMethod void getResponseFromPaymentwebExceptionTest() {
        
        Test.startTest();
        
        Profile objProfile = [Select Id, Name from Profile where Name =: 'System Administrator' limit 1];

        User objeUser = new User(Alias = 'admint', Email='adminuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = objProfile.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='creditNote@testorg.com');
        insert objeUser;
         
        System.runAs(objeUser){
            String strRequestJSON = crm_CreditNoteController.getRequestJSON('test','','','','');
        Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'POST',
                                                 'OK',
                                                 '{"userName" : "tes", "phoneNumber" : "","emailAddress" : "","orderNumber" : "", "shipmentNumber" : ""}',
                                                 null));
        HttpResponse res = crm_CreditNoteAPIHandler.getResponseFromPaymentWeb(strRequestJSON);
           System.debug('res-----------'+res);
            System.debug('Consdtrucvtor response ----------------'+new crm_CreditNoteCalloutMockTest(200,'POST',
                                                 'Complete',
                                                 '{"userName" : "tes", "phoneNumber" : "","emailAddress" : "","orderNumber" : "", "shipmentNumber" : ""}',
                                                 null));
            
        //String testzxcv = crm_CreditNoteAPIHandler.sendTransactionRecord('test','test');
        }
        
        Test.stopTest();
    
    }
    
    
    public static testMethod void getResponseFromPaymentwebErrorTest() {
 
        Test.startTest();
       // User userDetails = getUserDetails();
       // System.runAs(userDetails){
            String token = '{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiJodjhtV0c5OUBEIXVvTzVXQXlhMHBQcmEyTUY5IUpEYiIsInJvbGVzIjoiUkVGVU5EX1RSQU5TQUNUSU9OLERJUkVDVF9DQVBUVVJFX1RSQU5TQUNUSU9OX1NFQVJDSCIsImV4cCI6MTU5NzE3MzY5MCwiaWF0IjoxNTk3MTcxODkwfQ.XiUXH1B80lM0kXfgYX1-WF9kDIsG34UtVur42S7pM6PIBLRcgeaEk0xZ192A6cei-X4t00LbTZZo0dwBMXC_IOhlbqTaUaobIr9yOksthqbp2Q7J9_JpZk3F91wpwq6CrzhFj3twxZJMfjZs6wWqRpWVZ6aGelYJDfjvlEASfVzgb-ddmkuRlpOLlYV2B4A-cHPUBDTa9J9mBg_sN6HEZmmNh2k6mQseEOjojQOZZ_cDI';
            String TransactionId= '2fda92e8d17b46e68157508d6900b5c4';
        	String paymentProvider = 'NETS';
            String strRequestJSON = crm_CreditNoteController.getRequestJSON('test','','','','');
            
            Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(401,'POST','Unauthorized',
                                                                                  '{"errorCode" : "jwt_token_expired" ,"message" : "The Token is expired in every 30 minutes.Please request a new Token"}',null));
            HttpResponse res = crm_CreditNoteAPIHandler.getResponseFromPaymentWeb(strRequestJSON);
            crm_CreditNoteAPIHandler.sendTransactionRecord(TransactionId,token,paymentProvider);
            
            crm_CreditNoteAPIHandler.getErrorDetails(res);
            //String testzxcv = crm_CreditNoteAPIHandler.sendTransactionRecord('test','test');
        //}
        Test.stopTest();
    
    }
    
     public static testMethod void getTokenTest() {
            
         Test.startTest();
         //User userDetails = getUserDetails();
        // System.runAs(userDetails){
             Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'POST','OK','{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiJodjhtV0c5OUBEIXVvTzVXQXlhMHBQcmEyTUY5IUpEYiIsInJvbGVzIjoiUkVGVU5EX1RSQU5TQUNUSU9OLERJUkVDVF9DQVBUVVJFX1RSQU5TQUNUSU9OX1NFQVJDSCIsImV4cCI6MTU5NzI4ODc5OCwiaWF0IjoxNTk3Mjg2OTk4fQ.WVn0L_WIMcx7uvJxvnczGO1FQALhzhWeSkS4Jgpb5RVNGzaYYyCVb_Fz7h8kWfSha68WCJoIFLjEakj0NUbed9w5AP3c1jQmjpvcM6go63kjz6txNsyt7-ckslnOiHsXonSKawnL4mf0znC9Xm_fpptOmJ81Ul-97cEJmX7CBKXNAxNVXrzOpLcmVMM5dKdedbh5xqZss3HujFsMXKKB7_ELjO-7ci_sq-dxgn-HgAiyQ',null));
             crm_CreditNoteAPIHandler.getAccessToken();
             //String testzxcv = crm_CreditNoteAPIHandler.sendTransactionRecord('test','test');
             Test.stopTest();
       //  }
    
    }
    
     public static testMethod void getTokenExceptionTest() {
            
        Test.startTest();
        Profile objProfile = [Select Id, Name from Profile where Name =: 'System Administrator' limit 1];

        User objeUser = new User(Alias = 'admint', Email='adminuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = objProfile.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='creditNote@testorg.com');
        insert objeUser;
         
        System.runAs(objeUser){
             Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'POST','OK','{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiJodjhtV0c5OUBEIXVvTzVXQXlhMHBQcmEyTUY5IUpEYiIsInJvbGVzIjoiUkVGVU5EX1RSQU5TQUNUSU9OLERJUkVDVF9DQVBUVVJFX1RSQU5TQUNUSU9OX1NFQVJDSCIsImV4cCI6MTU5NzI4ODc5OCwiaWF0IjoxNTk3Mjg2OTk4fQ.WVn0L_WIMcx7uvJxvnczGO1FQALhzhWeSkS4Jgpb5RVNGzaYYyCVb_Fz7h8kWfSha68WCJoIFLjEakj0NUbed9w5AP3c1jQmjpvcM6go63kjz6txNsyt7-ckslnOiHsXonSKawnL4mf0znC9Xm_fpptOmJ81Ul-97cEJmX7CBKXNAxNVXrzOpLcmVMM5dKdedbh5xqZss3HujFsMXKKB7_ELjO-7ci_sq-dxgn-HgAiyQ',null));
             crm_CreditNoteAPIHandler.getAccessToken();
             //String testzxcv = crm_CreditNoteAPIHandler.sendTransactionRecord('test','test');
             Test.stopTest();
       }
    
    }
    
    public static testMethod void sendTransactionIdTest() {
        
        Test.startTest();
        //User userDetails = getUserDetails();
        //System.runAs(userDetails){
            Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'PUT','OK','',null));
    
            String token = '{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiJodjhtV0c5OUBEIXVvTzVXQXlhMHBQcmEyTUY5IUpEYiIsInJvbGVzIjoiUkVGVU5EX1RSQU5TQUNUSU9OLERJUkVDVF9DQVBUVVJFX1RSQU5TQUNUSU9OX1NFQVJDSCIsImV4cCI6MTU5NzE3MzY5MCwiaWF0IjoxNTk3MTcxODkwfQ.XiUXH1B80lM0kXfgYX1-WF9kDIsG34UtVur42S7pM6PIBLRcgeaEk0xZ192A6cei-X4t00LbTZZo0dwBMXC_IOhlbqTaUaobIr9yOksthqbp2Q7J9_JpZk3F91wpwq6CrzhFj3twxZJMfjZs6wWqRpWVZ6aGelYJDfjvlEASfVzgb-ddmkuRlpOLlYV2B4A-cHPUBDTa9J9mBg_sN6HEZmmNh2k6mQseEOjojQOZZ_cDI';
            String TransactionId= '2fda92e8d17b46e68157508d6900b5c4';
        	String paymentProvider = 'NETS';
            crm_CreditNoteAPIHandler.sendTransactionRecord(TransactionId,token,paymentProvider);
            //String testzxcv = crm_CreditNoteAPIHandler.sendTransactionRecord('test','test');
        //}
        Test.stopTest();
    
    }
    
    public static testMethod void sendTransactionIdErrorTest() {
        
        Test.startTest();
        
        Profile objProfile = [Select Id, Name from Profile where Name =: 'System Administrator' limit 1];

        User objeUser = new User(Alias = 'admint', Email='adminuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = objProfile.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='creditNote@testorg.com');
        insert objeUser;
        //User userDetails = getUserDetails();
        System.runAs(objeUser){
            Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'PUT','OK','',null));
    
            String token = '{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiJodjhtV0c5OUBEIXVvTzVXQXlhMHBQcmEyTUY5IUpEYiIsInJvbGVzIjoiUkVGVU5EX1RSQU5TQUNUSU9OLERJUkVDVF9DQVBUVVJFX1RSQU5TQUNUSU9OX1NFQVJDSCIsImV4cCI6MTU5NzE3MzY5MCwiaWF0IjoxNTk3MTcxODkwfQ.XiUXH1B80lM0kXfgYX1-WF9kDIsG34UtVur42S7pM6PIBLRcgeaEk0xZ192A6cei-X4t00LbTZZo0dwBMXC_IOhlbqTaUaobIr9yOksthqbp2Q7J9_JpZk3F91wpwq6CrzhFj3twxZJMfjZs6wWqRpWVZ6aGelYJDfjvlEASfVzgb-ddmkuRlpOLlYV2B4A-cHPUBDTa9J9mBg_sN6HEZmmNh2k6mQseEOjojQOZZ_cDI';
            String TransactionId= '2fda92e8d17b46e68157508d6900b5c4';
            String paymentProvider = 'NETS';
            crm_CreditNoteAPIHandler.sendTransactionRecord(TransactionId,token,paymentProvider);
            //String testzxcv = crm_CreditNoteAPIHandler.sendTransactionRecord('test','test');
        }
        Test.stopTest();
    
    }
    
    /*public static User getUserDetails(){
        Profile objProfile = [Select Id, Name from Profile where Name =: 'System Administrator' limit 1];

        User objeUser = new User(Alias = 'admint', Email='adminuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = objProfile.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='creditNote@testorg.com');
        insert objeUser;
    return  objeUser; 
    }*/ 
    
    public static testMethod void getHttpPrivateBasenReqTest() {
        
        Test.startTest();
        
       
        crm_CreditNoteAPIHandler.getHttpPrivateBasenReq('GET','https://api.qa.posten.cloud/private-base/order/32575' , '','test','test');
          
        
        Test.stopTest();
    
    }

}