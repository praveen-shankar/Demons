@isTest
public class crm_CreditNote_ResponseHandlerTest {
	 public static testMethod void wrapParseDataTest() {
         Test.startTest();
        Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'POST',
                                                 'OK',
                                                 '[{"userName":"Tes","phoneNumber":"","emailAddress":"marianne@ostbye.net","transactionDate":"2018-03-13","transactionAmount":"370,- NOK","transactionId":"2fda92e8d17b46e68157508d6900b5c4","orderNumber":"7000047980","shipmentNumber":"70438101413852360"}]',
                                                 null));
        String strRequestJSON = crm_CreditNoteController.getRequestJSON('test','','','','');
        String token = '{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiJodjhtV0c5OUBEIXVvTzVXQXlhMHBQcmEyTUY5IUpEYiIsInJvbGVzIjoiUkVGVU5EX1RSQU5TQUNUSU9OLERJUkVDVF9DQVBUVVJFX1RSQU5TQUNUSU9OX1NFQVJDSCIsImV4cCI6MTU5NzE3MzY5MCwiaWF0IjoxNTk3MTcxODkwfQ.XiUXH1B80lM0kXfgYX1-WF9kDIsG34UtVur42S7pM6PIBLRcgeaEk0xZ192A6cei-X4t00LbTZZo0dwBMXC_IOhlbqTaUaobIr9yOksthqbp2Q7J9_JpZk3F91wpwq6CrzhFj3twxZJMfjZs6wWqRpWVZ6aGelYJDfjvlEASfVzgb-ddmkuRlpOLlYV2B4A-cHPUBDTa9J9mBg_sN6HEZmmNh2k6mQseEOjojQOZZ_cDI"}';
	    System.debug('strRequestJSON test class ------------------'+strRequestJSON);
        HttpResponse res = crm_CreditNoteAPIHandler.getResponseFromPaymentWeb(strRequestJSON);
        System.debug('res test class ------------------'+res);
        crm_CreditNote_ResponseHandler.parse(res.getBody());
	
        
        Test.stopTest();
     }
            
}