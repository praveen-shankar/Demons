@isTest
public class crm_CreditNoteControllerTest {
    public static testMethod void setAtrributeTest() {
        crm_CreditNoteController.getUIThemeDescription();
        Test.startTest();
        
       // User userDetails = getUserDetails();
       // System.runAs(userDetails){
        Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'POST',
                                                 'OK',
                                                 '{"userName" : "tes", "phoneNumber" : "","emailAddress" : "","orderNumber" : "", "shipmentNumber" : ""}',
                                                 null));
         crm_CreditNoteController.setAttribute('test','','','','');
           
        //String testzxcv = crm_CreditNoteAPIHandler.sendTransactionRecord('test','test');
       // }
        
        Test.stopTest();
    
    }
    
     public static testMethod void setAtrributeErrorTest() {
            
        Test.startTest();
        
       // User userDetails = getUserDetails();
       // System.runAs(userDetails){
        Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(401,'POST','Unauthorized',
                                                 '{"errorCode" : "jwt_token_expired" ,"message" : "The Token is expired in every 30 minutes.Please request a new Token"}',null));
                                                
         crm_CreditNoteController.setAttribute('test','','','','');
           
        //String testzxcv = crm_CreditNoteAPIHandler.sendTransactionRecord('test','test');
       // }
        
        Test.stopTest();
    
    }
    
    public static testMethod void bindWrapResponseTest() {
            
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
        crm_CreditNoteController.bindWrapDataToDisplay(res,token);
    
        
        Test.stopTest();
    
    }
    
    public static testMethod void selectedDataTest() {
         Case c = caseCreation();
        insert c;     
       
           
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'PUT','OK','',null));
        Map<String,String> mapSelectedData = new Map<String,String>();
        //Map<String,String> testMAp = '{emailAddress=marianne@ostbye.net, orderNumber=7000047980, phoneNumber=, shipmentNumber=70438101413852360, transactionAmount=370,- NOK, transactionDate=2018-03-13, transactionId=2fda92e8d17b46e68157508d6900b5c4, userName=Tes}';
        // Case caseRecord = crm_CreditNoteAPIHandler.caseTestRecord();
        mapSelectedData.put('emailAddress', 'marianne@ostbye.net');
        mapSelectedData.put('orderNumber', '7000047980');
        mapSelectedData.put('phoneNumber', '');
        mapSelectedData.put('shipmentNumber', '70438101413852360');
        mapSelectedData.put('transactionAmount', '370,- NOK');
        mapSelectedData.put('transactionDate', '2018-03-13');
        mapSelectedData.put('transactionId', '2fda92e8d17b46e68157508d6900b5c4');
        mapSelectedData.put('userName', 'Tes');
        
        String token = '{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiJodjhtV0c5OUBEIXVvTzVXQXlhMHBQcmEyTUY5IUpEYiIsInJvbGVzIjoiUkVGVU5EX1RSQU5TQUNUSU9OLERJUkVDVF9DQVBUVVJFX1RSQU5TQUNUSU9OX1NFQVJDSCIsImV4cCI6MTU5NzE3MzY5MCwiaWF0IjoxNTk3MTcxODkwfQ.XiUXH1B80lM0kXfgYX1-WF9kDIsG34UtVur42S7pM6PIBLRcgeaEk0xZ192A6cei-X4t00LbTZZo0dwBMXC_IOhlbqTaUaobIr9yOksthqbp2Q7J9_JpZk3F91wpwq6CrzhFj3twxZJMfjZs6wWqRpWVZ6aGelYJDfjvlEASfVzgb-ddmkuRlpOLlYV2B4A-cHPUBDTa9J9mBg_sN6HEZmmNh2k6mQseEOjojQOZZ_cDI';
        String TransactionId= '2fda92e8d17b46e68157508d6900b5c4';
        crm_CreditNoteController.selectedData(mapSelectedData,token, TransactionId);
        
		 crm_CreditNoteController.recordCreation(mapSelectedData,c.id , 'OK' , '' , '');        
        Test.stopTest();
    
    }
    
    public static testMethod void recordCreationTest() {
        
         Case c = caseCreation();
        insert c;
        
        Test.startTest();
       // Case caseRecord = crm_CreditNoteAPIHandler.caseTestRecord();
        Map<String,String> mapSelectedData = new Map<String,String>();
        
       
        //Map<String,String> testMAp = '{emailAddress=marianne@ostbye.net, orderNumber=7000047980, phoneNumber=, shipmentNumber=70438101413852360, transactionAmount=370,- NOK, transactionDate=2018-03-13, transactionId=2fda92e8d17b46e68157508d6900b5c4, userName=Tes}';

        mapSelectedData.put('emailAddress', 'marianne@ostbye.net');
        mapSelectedData.put('orderNumber', '7000047980');
        mapSelectedData.put('phoneNumber', '');
        mapSelectedData.put('shipmentNumber', '70438101413852360');
        mapSelectedData.put('transactionAmount', '370,- NOK');
        mapSelectedData.put('transactionDate', '2018-03-13');
        mapSelectedData.put('transactionId', '2fda92e8d17b46e68157508d6900b5c4');
        mapSelectedData.put('userName', 'Tes');
        
      
        crm_CreditNoteController.recordCreation(mapSelectedData,c.id , 'OK' , '' , '');
        
        
           //Map<String,String> testMAp = '{emailAddress=marianne@ostbye.net, orderNumber=7000047980, phoneNumber=, shipmentNumber=70438101413852360, transactionAmount=370,- NOK, transactionDate=2018-03-13, transactionId=2fda92e8d17b46e68157508d6900b5c4, userName=Tes}';
    
        
        Test.stopTest();
    
    }
     public static testMethod void digitollSelectedDataTest(){
        Case c = caseCreation();
        insert c;
        Digitoll_Urls__c setting = getDigitollURLsRecord('Order Refund' , 'https://api-orderbase-dev.azurewebsites.net/privatbasen/order/');
        insert setting; 
		System.debug('setting Test Class-----'+setting);        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'PUT','OK','{"reason": "16401178"}',null));
        Map<String, String > mapSelectedData = createMapForSelectedData('marianne@ostbye.net','34','4746443715','PK123460','950.5','','2fda92e8d17b46e68157508d6900b5c4','Test');
        mapSelectedData.put('Status', 'Paid');
        mapSelectedData.put('currencyCode', 'NOK');
        mapSelectedData.put('orderType', 'Digitoll');
        crm_CreditNote__c newCredit =  createCreditNoteRecord(c.id ,'OK' , 'OK' , 'credited','Digitoll');
         insert newCredit;
        crm_CreditNoteController.digitollSelectedData(mapSelectedData , c.Id, newCredit.Id);
        
         Test.stopTest();
    }
	
    
    public static testMethod void cancelTransactionPrivateBasenTest(){
        Case c = caseCreation();
        insert c;
        Digitoll_Urls__c setting = getDigitollURLsRecord('Order Refund' , 'https://api-orderbase-dev.azurewebsites.net/privatbasen/order/');
        insert setting; 
		        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'PUT','OK','{"reason": "16401178"}',null));
        Map<String, String > mapSelectedData = createMapForSelectedData('marianne@ostbye.net','34','4746443715','PK123460','950.5','','2fda92e8d17b46e68157508d6900b5c4','Test');
        mapSelectedData.put('Status', 'OPEN');
        mapSelectedData.put('currencyCode', 'NOK');
        mapSelectedData.put('orderType', 'Digitoll');
        crm_CreditNote__c newCredit =  createCreditNoteRecord(c.id ,'OK' , 'OK' , 'cancelled','Digitoll');
         insert newCredit;
        crm_CreditNoteController.cancelTransactionPrivateBasen(mapSelectedData , c.Id);
        
         Test.stopTest();
    }
    
    public static testMethod void selectedDataErrorTest() {
        
        Case c = caseCreation();
        insert c;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(401,'POST','Unauthorized',
                                                 '{"errorCode" : "jwt_token_expired" ,"message" : "The Token is expired in every 30 minutes.Please request a new Token"}',null));
       // Case caseRecord = crm_CreditNoteAPIHandler.caseTestRecord();
        Map<String,String> mapSelectedData = new Map<String,String>();
        
       
        //Map<String,String> testMAp = '{emailAddress=marianne@ostbye.net, orderNumber=7000047980, phoneNumber=, shipmentNumber=70438101413852360, transactionAmount=370,- NOK, transactionDate=2018-03-13, transactionId=2fda92e8d17b46e68157508d6900b5c4, userName=Tes}';

        mapSelectedData.put('emailAddress', 'marianne@ostbye.net');
        mapSelectedData.put('orderNumber', '7000047980');
        mapSelectedData.put('phoneNumber', '');
        mapSelectedData.put('shipmentNumber', '70438101413852360');
        mapSelectedData.put('transactionAmount', '370,- NOK');
        mapSelectedData.put('transactionDate', '2018-03-13');
        mapSelectedData.put('transactionId', '2fda92e8d17b46e68157508d6900b5c4');
        mapSelectedData.put('userName', 'Tes');
        
        String token = '{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiJodjhtV0c5OUBEIXVvTzVXQXlhMHBQcmEyTUY5IUpEYiIsInJvbGVzIjoiUkVGVU5EX1RSQU5TQUNUSU9OLERJUkVDVF9DQVBUVVJFX1RSQU5TQUNUSU9OX1NFQVJDSCIsImV4cCI6MTU5NzE3MzY5MCwiaWF0IjoxNTk3MTcxODkwfQ.XiUXH1B80lM0kXfgYX1-WF9kDIsG34UtVur42S7pM6PIBLRcgeaEk0xZ192A6cei-X4t00LbTZZo0dwBMXC_IOhlbqTaUaobIr9yOksthqbp2Q7J9_JpZk3F91wpwq6CrzhFj3twxZJMfjZs6wWqRpWVZ6aGelYJDfjvlEASfVzgb-ddmkuRlpOLlYV2B4A-cHPUBDTa9J9mBg_sN6HEZmmNh2k6mQseEOjojQOZZ_cDI';
        String TransactionId= '2fda92e8d17b46e68157508d6900b5c4';
        crm_CreditNoteController.selectedData(mapSelectedData,c.id , TransactionId);
        
        
           //Map<String,String> testMAp = '{emailAddress=marianne@ostbye.net, orderNumber=7000047980, phoneNumber=, shipmentNumber=70438101413852360, transactionAmount=370,- NOK, transactionDate=2018-03-13, transactionId=2fda92e8d17b46e68157508d6900b5c4, userName=Tes}';
    
        
        Test.stopTest();
    
    }
    
   public static Map<String,String> createMapForSelectedData(String emailAdress ,String orderNumber ,String phoneNumber ,String shipmentNumber ,String transactionAmount ,String transactionDate , String transactionId , String userName){
        Map<String,String> mapSelectedData = new Map<String,String>();
        //Map<String,String> testMAp = '{emailAddress=marianne@ostbye.net, orderNumber=7000047980, phoneNumber=, shipmentNumber=70438101413852360, transactionAmount=370,- NOK, transactionDate=2018-03-13, transactionId=2fda92e8d17b46e68157508d6900b5c4, userName=Tes}';

        mapSelectedData.put('emailAddress', 'marianne@ostbye.net');
        mapSelectedData.put('orderNumber', '7000047980');
        mapSelectedData.put('phoneNumber', '');
        mapSelectedData.put('shipmentNumber', '70438101413852360');
        mapSelectedData.put('transactionAmount', '370,- NOK');
        mapSelectedData.put('transactionDate', '2018-03-13');
        mapSelectedData.put('transactionId', '2fda92e8d17b46e68157508d6900b5c4');
        mapSelectedData.put('userName', 'Tes');
        
        return mapSelectedData;
    }
      public static crm_CreditNote__c createCreditNoteRecord(String strRecordId , String strDigiStamp_Status , String strDigitollStatus , String strDigitollSenStatus,String strType){
        crm_CreditNote__c newCredit = new crm_CreditNote__c();
        
            newCredit.Case__c = strRecordId;
            newCredit.Email_Address__c = 'test@test.com';
            newCredit.Transaction_Id__c = 'e95881b8ab13471d96523e9859689ae6';
            newCredit.isRefunded__c = true;
            newCredit.Order_Number__c = 34;
            newCredit.Phone_Number__c = '4746443715';
            newCredit.ShipmentNumber__c = 'PK123460';
			newCredit.Transaction_Date__c = null;
            newCredit.Username__c = 'Test';
            newCredit.Digital_Stamp_Status__c = strDigiStamp_Status;
            newCredit.Digitoll_Status__c = strDigitollStatus;
            newCredit.Digitoll_Send_Status__c = strDigitollSenStatus;
            newCredit.Transaction_Amount__c = 404.00;
            newCredit.CurrencyIsoCode = 'NOK';
            newCredit.Type__c = strType;
          return newCredit;
    }
    
     public static testMethod void getDigitollResposnseDataTest() {
        Case c = new Case();       
        Digitoll_Urls__c setting = getDigitollURLsRecord('Consignment Search' , 'https://api-orderbase-dev.azurewebsites.net/privatbasen/orders');
        insert setting;
        CreditNote_Headers__c headerSetting = getCreditNoteHeaders();
        insert headerSetting ;
        String response = '[{"orderId":38,"personId":156000,"consignmentNumber":"PK123456","customerReference":"xxxx","orderInfoToCustomer":{"ConsignorName":"Amazon","ConsignorCountry":"UK","CurrencyConversionDate":"2020-08-10","NatureOfTransaction":11,"GoodsWeight":1.0,"GoodsAmount":720.3,"PostageAmount":0.0,"PostageVAT":0.0,"GoodsItem":[{"GoodsItemNumber":1,"GoodsDescription":"Shoes","CountryOfOrigin":"NO","OriginalCurrencyCode":"NOK","OriginalGoodsAmount":378.0,"CurrencyConversionRate":1.0,"GoodsWeight":1.0,"GoodsAmount":150.0,"DutiesAmount":30.0,"VATAmount":102.0},{"GoodsItemNumber":2,"GoodsDescription":"Dress","CountryOfOrigin":"NO","OriginalCurrencyCode":"NOK","OriginalGoodsAmount":100.3,"CurrencyConversionRate":1.0,"GoodsWeight":1.0,"GoodsAmount":150.0,"DutiesAmount":30.0,"VATAmount":102.0},{"GoodsItemNumber":3,"GoodsDescription":"Shirt","CountryOfOrigin":"NO","OriginalCurrencyCode":"NOK","OriginalGoodsAmount":450.0,"CurrencyConversionRate":1.0,"GoodsWeight":1.0,"GoodsAmount":378.0,"DutiesAmount":30.0,"VATAmount":102.0}]},"receiverName":"MarcusTierney","status":{"statusCode":"OPEN","statusDescription":"Openorder,notpaid","valid":true},"orderType":"digitoll","accountingLossStatus":null,"statusReason":"Orderwasinitiatedasstatus:[OPEN]","transactionId":null,"totalGrossAmount":950.5,"currencyCode":"NOK","orderSourceId":"ENRICHER","updatedBy":null,"sourceReference":"1","orderDate":"2020-07-29","dueDate":"2020-07-31","receiverPhone":{"countryCode":"+47","phoneNumber":"46443715"},"receiverEmail":null,"receiverAddressLine1":"Storgata1A","receiverAddressLine2":"Venstreinngang","receiverPostalCode":"0101","receiverCity":"Oslo","receiverCountryCode":"NO","lines":[{"lineNumber":1,"item":{"itemCode":"102345","itemDescription":"UtlagtTollLavgrense","valid":true},"lineDescription":"string","quantity":1,"quantityUOM":"STK","unitNetPrice":100.0,"lineNetAmount":100.0,"totalLineAmount":0.0,"tax":{"taxCode":"3","taxDescription":"MVAhøysats","taxPercent":25.0,"validTaxCode":true},"taxAmount":25.0},{"lineNumber":2,"item":{"itemCode":"102346","itemDescription":"UtlagtMvaLavgrense","valid":true},"quantity":1,"quantityUOM":"STK","unitNetPrice":10.0,"lineNetAmount":200.0,"totalLineAmount":0.0,"tax":{"taxCode":"7","taxDescription":"IngenMVA","taxPercent":0.0,"validTaxCode":true},"taxAmount":0.0},{"lineNumber":3,"item":{"itemCode":"15682","itemDescription":"Forenkletfortollingpakker","valid":true},"quantity":1,"quantityUOM":"STK","unitNetPrice":10.0,"lineNetAmount":300.0,"totalLineAmount":0.0,"tax":{"taxCode":"7","taxDescription":"IngenMVA","taxPercent":0.0,"validTaxCode":true},"taxAmount":0.0}]}]';   
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'GET','OK',response ,null));
        
        crm_CreditNoteController.getDigitollResposnseData('','PK123456', '');
        crm_CreditNoteController.getDigitollResposnseData('','', '4746443715');
        
        Test.stopTest();
    
    }
    
 /* public static testMethod void getDigitollResposnseDataForPhoneTest() {
        Case c = new Case();       
        Digitoll_Urls__c setting = getDigitollURLsRecord();
        insert setting;
        CreditNote_Headers__c headerSetting = getCreditNoteHeaders();
        insert headerSetting ;
        String response = '[{"orderId":32,"personId":354682,"consignmentNumber":"Sales00","customerReference":null,"orderInfoToCustomer":{"ConsignorName":"Amazon","ConsignorCountry":"US","CurrencyConversionDate":"2020-08-05","NatureOfTransaction":31,"GoodsWeight":10.0,"GoodsAmount":100.0,"PostageAmount":0.0,"PostageVAT":0.0,"GoodsItem":[{"GoodsItemNumber":1,"GoodsDescription":"Dress","CountryOfOrigin":"NO","OriginalCurrencyCode":"NOK","CurrencyConversionRate":1.0,"GoodsWeight":10.0,"GoodsAmount":100.0,"DutiesAmount":8.0,"VATAmount":27.0},{"GoodsItemNumber":2,"GoodsDescription":"Dress","CountryOfOrigin":"NO","OriginalCurrencyCode":"NOK","CurrencyConversionRate":1.0,"GoodsWeight":10.0,"GoodsAmount":100.0,"DutiesAmount":8.0,"VATAmount":27.0}]},"receiverName":"Salesforce","status":{"statusCode":"OPEN","statusDescription":"Openorder,notpaid","valid":true},"orderType":"digitoll","accountingLossStatus":null,"statusReason":"Orderwasinitiatedasstatus:[OPEN]","transactionId":null,"totalGrossAmount":100.0,"currencyCode":"SEK","orderSourceId":"ENRICHER","updatedBy":null,"sourceReference":"1","orderDate":"2020-09-08","dueDate":"2020-08-20","receiverPhone":{"countryCode":"+47","phoneNumber":"123456"},"receiverEmail":"A.b@norge.com","receiverAddressLine1":"Storgata1A","receiverAddressLine2":"Venstreinngang","receiverPostalCode":"0101","receiverCity":"Oslo","receiverCountryCode":"NO","lines":[{"lineNumber":1,"item":{"itemCode":"15681","itemDescription":"Forenkletfortollingbrev","valid":true},"lineDescription":"FancyClips","quantity":2,"quantityUOM":"2","unitNetPrice":10.0,"lineNetAmount":10.0,"totalLineAmount":10.0,"tax":{"taxCode":"3","taxDescription":"MVAhøysats","taxPercent":25.0,"validTaxCode":true},"taxAmount":25.0},{"lineNumber":2,"item":{"itemCode":"102345","itemDescription":"UtlagtTollLavgrense","valid":true},"lineDescription":"CustomsDeclaration","quantity":2,"quantityUOM":"2","unitNetPrice":10.0,"lineNetAmount":10.0,"totalLineAmount":10.0,"tax":{"taxCode":"3","taxDescription":"MVAhøysats","taxPercent":25.0,"validTaxCode":true},"taxAmount":25.0}]}]';   
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new crm_CreditNoteCalloutMockTest(200,'GET','OK',response ,null));
        
        crm_CreditNoteController.getDigitollResposnseData('32','', '');
       
        
        Test.stopTest();
    
    }*/
    
    
    public static testmethod void getCaseNumberTest(){
        Case caseObj = caseCreation();
        insert caseObj;
        crm_CreditNoteController.getCaseNumber(caseObj.Id);
    }
    
    public static Case caseCreation(){
        Case c = new Case();       
       //   Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(System.label.CreditNote_RecordType).getRecordTypeId();
        c.Subject = 'Test Case';
        c.Origin ='Manuelt';
        c.Status = 'New';
        c.Description ='Test';
        return c;
    }
    
    
    public static Digitoll_Urls__c getDigitollURLsRecord(String strSettingName , String strUrl){
        Digitoll_Urls__c setting = new Digitoll_Urls__c ();
        setting.Name = strSettingName ;
        setting.Username__c  = 'SALESFORCE';
        setting.Password__c = 'PASSWORD';
        setting.API_Url__c  = strUrl;
        return setting;
    }
    
    public static CreditNote_Headers__c getCreditNoteHeaders(){
        CreditNote_Headers__c setting = new CreditNote_Headers__c ();
        setting.Name = 'Digitoll';
        setting.HeaderLabels__c  = 'Order Number;Shipment Number;Transaction Amount;Status;Transaction Date;User Name;Email Address;Phone Number;Transaction Id';
        
        
        return setting;
    }
    /*public static User getUserDetails(){
        Profile objProfile = [Select Id, Name from Profile where Name =: 'System Administrator' limit 1];

        User objeUser = new User(Alias = 'admint', Email='adminuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = objProfile.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='creditNote@testorg.com');

    return  objeUser;  
    }*/
}