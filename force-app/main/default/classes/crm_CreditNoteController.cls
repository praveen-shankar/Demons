public class crm_CreditNoteController{
   
    public static String accessToken = '';
    public static String jsonData ='';
    
    @AuraEnabled
    public static String getUIThemeDescription() {
        String strTheme = UserInfo.getUiThemeDisplayed();
        return strTheme;
    }
    
    @AuraEnabled
    public static WrapTableData
        setAttribute(String customerName,String orderNumber,String shipmentNumber,String phoneNumber, String customerEmail) {
        //Declare Variables
        String strRequestJSON;
        WrapTableData objWrapToDisplay = new WrapTableData();
            
        accessToken = crm_CreditNoteAPIHandler.getAccessToken(); // Get access Token
        
        strRequestJSON = getRequestJSON(customerName, orderNumber, shipmentNumber, phoneNumber, customerEmail);
        System.debug('strRequestJSON-' + strRequestJSON);
            
        HttpResponse responseFromPaymentWeb = crm_CreditNoteAPIHandler.getResponseFromPaymentWeb(strRequestJSON);
            System.debug('responseFromPaymentWeb: '+responseFromPaymentWeb);
        System.debug('responseBody: body '+responseFromPaymentWeb.getBody());
        System.debug('responseBody: status '+responseFromPaymentWeb.getStatus());

        //String responseOfSearchData = '[{"userName":"Test","phoneNumber":"4745577790","emailAddress":"vishal.singhal@posten.no","transactionDate":"2020-06-12","transactionAmount":"15,-NOK","transactionId":"edcf9ce2534b4af1a911314a8972fd26","orderNumber":"7000063768","shipmentNumber":"370438100746180042"},{"userName":"Test","phoneNumber":"45046446","emailAddress":"marianne.saebo@posten.no","transactionDate":"2020-02-25","transactionAmount":"225,-NOK","transactionId":"c076d32b48304c9eb63d22c9752569f3","orderNumber":"7000060675","shipmentNumber":"70438103432326167"}]';
        if(responseFromPaymentWeb.getStatusCode() == CommonConstants.STATUS_CODE_200  && String.isNotBlank(responseFromPaymentWeb.getBody())){
            try{
                objWrapToDisplay = bindWrapDataToDisplay(responseFromPaymentWeb , accessToken);
                System.debug('first integration if: '+objWrapToDisplay);

            }catch(Exception ex) {
                System.debug('Get Rsp from Payment Web if: ' + ex.getMessage());
                ExceptionController.createErrorRecord(ex, 'Response From Payment Web if: '+responseFromPaymentWeb);
            }
            
            return objWrapToDisplay;  
        }
        else{
            try{
                if(responseFromPaymentWeb.getStatuscode() == CommonConstants.STATUS_CODE_401){
                System.debug('First Integration ');

                String strStatusMsg = crm_CreditNoteAPIHandler.getErrorDetails(responseFromPaymentWeb);
                    if(String.isNotBlank(strStatusMsg) && (strStatusMsg == CommonConstants.ERR_TOKEN_EXPIRED || strStatusMsg == CommonConstants.ERR_TOKEN_VERIFICATION_FAILED)){
                            
                        Cache.OrgPartition orgPart = Cache.Org.getPartition(CommonConstants.SESSION_CACHE);
                        orgPart.remove(CommonConstants.CACHE_ACCESS_TOKEN);
                        
                        HttpResponse reprocessResPaymentWeb = crm_CreditNoteAPIHandler.getResponseFromPaymentWeb(strRequestJSON);
                    
                        System.debug('reprocessResPaymentWeb'+reprocessResPaymentWeb);
        
                        if(reprocessResPaymentWeb.getStatusCode() == CommonConstants.STATUS_CODE_200 && String.isNotBlank(reprocessResPaymentWeb.getBody())){
                           System.debug('reprocessResPaymentWeb.getStatusCode()---'+reprocessResPaymentWeb.getStatusCode());
                           System.debug('reprocessResPaymentWeb.getBody()---'+reprocessResPaymentWeb.getBody());
            
                            objWrapToDisplay = crm_CreditNoteController.bindWrapDataToDisplay(reprocessResPaymentWeb, accessToken);
                            System.debug('First Integration else------------'+objWrapToDisplay);            
                        }
                    }
                }
            }catch(Exception ex) {
                System.debug('Get Rsp from Payment Web: ' + ex.getMessage());
                ExceptionController.createErrorRecord(ex, 'Response From Payment Web: '+responseFromPaymentWeb);
            }
            
            return objWrapToDisplay;               
        } 
    }
    
     @AuraEnabled
    public static WrapTableData getDigitollResposnseData(String orderId,String consignmentNumber,String phoneNumber){
        System.debug('getDigitollResposnseData:------------------ '+phoneNumber);
        Digitoll_Urls__c digitollURLSetting = Digitoll_Urls__c.getValues('Consignment Search');
        
        String strSearchField = '';
        String customresponseUrl = '';
        WrapTableData objWrapToDisplay = new WrapTableData();
        Http http = new Http();
            if(String.isNotBlank(consignmentNumber)){
                customresponseUrl = digitollURLSetting.API_Url__c + CommonConstants.QUESTION_MARK + CommonConstants.CONSIGNMENT_NUMBER + CommonConstants.EQUALTO + consignmentNumber;
                strSearchField = CommonConstants.CONSIGNMENT_NUMBER;
                System.debug('customresponseUrl--4564-----------------------'+customresponseUrl);
                
            }else if(String.isNotBlank(orderId)){
                customresponseUrl = digitollURLSetting.API_Url__c + CommonConstants.SLASH+ orderId ;
                strSearchField = CommonConstants.ORDER_ID;
                System.debug('customresponseUrl--4564-----------------------'+customresponseUrl);
            }
            else if(String.isNotBlank(phoneNumber)){
                customresponseUrl = digitollURLSetting.API_Url__c + CommonConstants.QUESTION_MARK + CommonConstants.PHONE_Number + CommonConstants.EQUALTO + phoneNumber;
                strSearchField = CommonConstants.PHONE_Number;
                System.debug('customPhoneUrl--4564-----------------------'+customresponseUrl);
            }
            
        Httprequest objRequest = crm_CreditNoteAPIHandler.getHttpPrivateBasenReq(CommonConstants.GET_METHOD,customresponseUrl , CommonConstants.APPLICATION_JSON,digitollURLSetting.Username__c , digitollURLSetting.Password__c);

        HttpResponse response = http.send(objRequest);
        System.debug('responseBody: '+response.getBody());
        
        if(response.getStatuscode() == CommonConstants.STATUS_CODE_200){
            objWrapToDisplay = bindDigitollWrapToDisplay(response , strSearchField);
        }
        return objWrapToDisplay;
    }
    
    public static WrapTableData bindWrapDataToDisplay(HttpResponse responseFromPaymentWeb , String jwtAccessToken){
        List<crm_CreditNote_ResponseHandler> responseFromCreditNote = crm_CreditNote_ResponseHandler.parse(responseFromPaymentWeb.getBody());
        System.debug('responseFromPaymentWeb-----test-----'+responseFromPaymentWeb);
        System.debug('responseFromCreditNote----test------'+responseFromCreditNote);
        WrapTableData objWrap = new WrapTableData();
        Map<integer,Map<String, String>> mapResponseFromPaymentWeb = new Map<integer,Map<String, String>>();
        for(integer i=0;i<responseFromCreditNote.size();i++)
        {   
            map<string,string> mapKeyVsValue = new map<string,string>();
            
            //lstFieldsFromMetaPerSelection
            mapKeyVsValue.put(CommonConstants.ORDER_NUMBER, responseFromCreditNote[i].orderNumber != null ? responseFromCreditNote[i].orderNumber : '');
            mapKeyVsValue.put(CommonConstants.SHIPMENT_NUMBER, responseFromCreditNote[i].shipmentNumber != null ? responseFromCreditNote[i].shipmentNumber : '');
            mapKeyVsValue.put(CommonConstants.TRANSACTION_AMOUNT, responseFromCreditNote[i].transactionAmount);
            mapKeyVsValue.put(CommonConstants.TRANSACTION_DATE, String.valueOf(responseFromCreditNote[i].transactionDate ) != null ? responseFromCreditNote[i].transactionDate : '');
            mapKeyVsValue.put(CommonConstants.USERNAME, String.isNotBlank(responseFromCreditNote[i].userName) ? responseFromCreditNote[i].userName : '' );
            mapKeyVsValue.put(CommonConstants.EMAIL_ADDRESS, String.isNotBlank(responseFromCreditNote[i].emailAddress) ? responseFromCreditNote[i].emailAddress : '');
            mapKeyVsValue.put(CommonConstants.PHONE_Number, responseFromCreditNote[i].phoneNumber != null ? responseFromCreditNote[i].phoneNumber : '');
            mapKeyVsValue.put(CommonConstants.TRANSACTION_ID, String.valueOf(responseFromCreditNote[i].transactionId) != null ? String.valueOf(responseFromCreditNote[i].transactionId) : '');
            //Adding New Key Value to the  map - Payment Type
            mapKeyVsValue.put(CommonConstants.PAYMENT_PROVIDER, responseFromCreditNote[i].paymentProvider);
            System.debug('mapKeyVsValue inside*************'+mapKeyVsValue);
            mapResponseFromPaymentWeb.put(i,mapKeyVsValue);
        }
          System.debug('mapResponseFromPaymentWeb *************'+mapResponseFromPaymentWeb);  
        try{
            if(!responseFromCreditNote.isEmpty() || responseFromCreditNote != null){
                CreditNote_Headers__c headersPaymentWeb = CreditNote_Headers__c.getValues(CommonConstants.CUSTOM_SETTING_PAYMENT_WEB);
                objWrap.headersLabels = headersPaymentWeb.HeaderLabels__c.Split(';');
                objWrap.responseTableData = mapResponseFromPaymentWeb;
                System.debug('objWrap.responseTableData--------------------------------------'+objWrap.responseTableData);
                objWrap.accessJWTToken = jwtAccessToken;
            }
        }catch(Exception ex) {
            System.debug('Bind Wrap Data to display: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'Bind Wrap Data to display: '+responseFromCreditNote);
        }
        
        return objWrap;
        
    }
    
    
    public static WrapTableData bindDigitollWrapToDisplay(HttpResponse responseFromDigitoll , String strSearchField){
        List<Crm_DigitollResponseHandler> lstResponseFromDigitollHandler;
        WrapTableData objWrap = new WrapTableData();
        Map<integer,Map<String, String>> mapResponseFromDigitoll = new Map<integer,Map<String, String>>();
        String strPhoneNumber ='';
        System.debug('strSearchField-----'+strSearchField);
        if( strSearchField == 'orderId'){
            String strjson = '[' + responseFromDigitoll.getBody() + ']';
            System.debug('strjson-----'+strjson);
            lstResponseFromDigitollHandler = Crm_DigitollResponseHandler.parse(strjson);
            
            System.debug('lstResponseFromDigitollHandler--orderId---'+lstResponseFromDigitollHandler);
            //lstResponseFromDigitollHandler.add(responseHandlrSingleRecord);
            
        }else{
            lstResponseFromDigitollHandler = Crm_DigitollResponseHandler.parse(responseFromDigitoll.getBody()); 
 
        }
        System.debug('lstResponseFromDigitollHandler----test------'+lstResponseFromDigitollHandler);
        
        for(integer i=0;i<lstResponseFromDigitollHandler.size();i++)
        {   
            map<string,string> mapKeyVsValue = new map<string,string>();
            System.debug('lstResponseFromDigitollHandler[i].orderType------'+lstResponseFromDigitollHandler[i].orderType);
            //lstFieldsFromMetaPerSelecction
            mapKeyVsValue.put(CommonConstants.ORDER_NUMBER,lstResponseFromDigitollHandler[i].orderId != null ? String.valueOf(lstResponseFromDigitollHandler[i].orderId) : '');
            mapKeyVsValue.put(CommonConstants.SHIPMENT_NUMBER,String.isNotBlank(lstResponseFromDigitollHandler[i].consignmentNumber)  ? String.valueOf(lstResponseFromDigitollHandler[i].consignmentNumber) : '');
            
            mapKeyVsValue.put(CommonConstants.TRANSACTION_AMOUNT,  String.valueOf(lstResponseFromDigitollHandler[i].totalGrossAmount) + ',- ' + String.valueOf(lstResponseFromDigitollHandler[i].currencyCode));
            
            mapKeyVsValue.put(CommonConstants.STATUS, lstResponseFromDigitollHandler[i].status.statusCode);

            mapKeyVsValue.put(CommonConstants.TRANSACTION_DATE, CommonConstants.BLANK);
            mapKeyVsValue.put(CommonConstants.USERNAME, String.isNotBlank(lstResponseFromDigitollHandler[i].receiverName) ? lstResponseFromDigitollHandler[i].receiverName : '' );
            mapKeyVsValue.put(CommonConstants.EMAIL_ADDRESS, String.isNotBlank(lstResponseFromDigitollHandler[i].receiverEmail) ? lstResponseFromDigitollHandler[i].receiverEmail : '');
            if(lstResponseFromDigitollHandler[i].receiverPhone.phoneNumber != null && lstResponseFromDigitollHandler[i].receiverPhone.countryCode != null){
                strPhoneNumber =String.valueOf(lstResponseFromDigitollHandler[i].receiverPhone.countryCode) + String.valueOf(lstResponseFromDigitollHandler[i].receiverPhone.phoneNumber);
            }else{
                strPhoneNumber = '';
            }
            
            mapKeyVsValue.put(CommonConstants.PHONE_Number,String.isNotBlank(strPhoneNumber) ? strPhoneNumber : '');
            mapKeyVsValue.put(CommonConstants.TRANSACTION_ID, String.valueOf(lstResponseFromDigitollHandler[i].transactionId) != null ? String.valueOf(lstResponseFromDigitollHandler[i].transactionId) : '');
            mapKeyVsValue.put(CommonConstants.ORDER_TYPE, String.isNotBlank(lstResponseFromDigitollHandler[i].orderType) ? String.valueOf(lstResponseFromDigitollHandler[i].orderType) : 'digitoll');
            mapKeyVsValue.put(CommonConstants.CURRENCY_CODE,lstResponseFromDigitollHandler[i].currencyCode); 
            //Adding New Key Value pair for payment type
            mapKeyVsValue.put(CommonConstants.PAYMENT_TYPE, String.isNotBlank(lstResponseFromDigitollHandler[i].paymentType) ? String.valueOf(lstResponseFromDigitollHandler[i].paymentType) : '');
            System.debug('mapKeyVsValue inside*************'+mapKeyVsValue);
            mapResponseFromDigitoll.put(i,mapKeyVsValue);
        }
            
        try{
            if(!lstResponseFromDigitollHandler.isEmpty() || lstResponseFromDigitollHandler != null){
                CreditNote_Headers__c headersPaymentWeb = CreditNote_Headers__c.getValues(CommonConstants.CUSTOM_SETTING_Digitoll);
                objWrap.headersLabels = headersPaymentWeb.HeaderLabels__c.Split(';');
                objWrap.responseTableData = mapResponseFromDigitoll;
               
            }
        }catch(Exception ex) {
            System.debug('Bind Wrap Data to display: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'Bind Wrap Data to display: '+lstResponseFromDigitollHandler);
        }
       
        return objWrap;
        
    }
    
     public static String getRequestJSON(String customerName,String orderNumber,String shipmentNumber,String phoneNumber, string customerEmail){
         /*************************** Generate Request JSON Start *********************************/
         JSONGenerator gen = JSON.createGenerator(true);
         try{
             gen.writeStartObject();     
             gen.writeStringField(CommonConstants.USERNAME, customerName != null ? customerName : '');
             gen.writeStringField(CommonConstants.PHONE_NUMBER, String.valueOf(phoneNumber) != null ? String.valueOf(phoneNumber) : '' );
             gen.writeStringField(CommonConstants.EMAIL_ADDRESS, customerEmail != null ? customerEmail : '');
             gen.writeStringField(CommonConstants.ORDER_NUMBER, String.valueOf(orderNumber) != null ? String.valueOf(orderNumber) : '' );
             gen.writeStringField(CommonConstants.SHIPMENT_NUMBER, String.valueOf(shipmentNumber) != null ? String.valueOf(shipmentNumber) : '' );
             
             gen.writeEndObject();
             jsonData = gen.getAsString();
         }
         catch(Exception ex) {
            System.debug('Generate JSON: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'Generate JSON: '+jsonData);
        }
        
         /*************************** Generate Request JSON End *********************************/
         
         return jsonData;
         
     }
    
    @AuraEnabled
    public static String selectedData(Map<String,String> selectedRefundData ,String recordId ,String jwtAccessToken){
        System.debug('selectedRefundData--------------'+selectedRefundData);
        System.debug('recordId--------------'+recordId);
        String transactionId = selectedRefundData.get(CommonConstants.TRANSACTION_ID);
        String transactionStatus;
        String creditNoteId = '';
        String strTransStatusCreditNote = '';
        String paymentprovider;
        if(selectedRefundData.get(CommonConstants.PAYMENT_TYPE) != null){
            paymentprovider = selectedRefundData.get(CommonConstants.PAYMENT_TYPE);
        }
        else if(selectedRefundData.get(CommonConstants.PAYMENT_PROVIDER) != null){
            paymentprovider = selectedRefundData.get(CommonConstants.PAYMENT_PROVIDER);
        }
        else{
            paymentprovider = '';
        }
        //String accessToken = crm_CreditNoteAPIHandler.authenticate(); 
        System.debug('selectedRefundData--------------'+selectedRefundData);
        
        String cachedToken = crm_CreditNoteAPIHandler.getAccessToken();
         System.debug('cachedToken--------------'+cachedToken);
        try{
            if (!selectedRefundData.isEmpty()) {
                transactionStatus = crm_CreditNoteAPIHandler.sendTransactionRecord(transactionId , cachedToken, paymentprovider);
                
                System.debug('transactionStatus--------------'+transactionStatus);
                if(String.isNotBlank(transactionStatus) && transactionStatus == CommonConstants.STATUS_MSG_OK){
                creditNoteId = recordCreation(selectedRefundData,recordId , transactionStatus ,'','');
                    System.debug('creditNoteId-----1st------'+creditNoteId);
                    if(String.isNotBlank(creditNoteId)){
                        strTransStatusCreditNote = transactionStatus + CommonConstants.DOUBLE_ATRATE_SPILT + creditNoteId;
                        System.debug('strTransStatusCreditNote-----1st------'+strTransStatusCreditNote);
                         /*if(selectedRefundData.containsKey('orderType')){
                            if(selectedRefundData.get('orderType') == 'digitoll')
                                strTransStatusCreditNote = strTransStatusCreditNote + '@@' + selectedRefundData.get('orderType');
                            //digitollSelectedData(selectedRefundData,recordId , creditNoteId);
                        
                        }*/
                    }
                   
                
                }else if(String.isNotBlank(transactionStatus) && (transactionStatus == CommonConstants.ERR_TOKEN_EXPIRED || transactionStatus == CommonConstants.ERR_TOKEN_VERIFICATION_FAILED)){
                    Cache.OrgPartition orgPart = Cache.Org.getPartition(CommonConstants.SESSION_CACHE);
                    orgPart.remove(CommonConstants.CACHE_ACCESS_TOKEN);
                    
                    String reprocessAccessToken = crm_CreditNoteAPIHandler.getAccessToken();
                    String reprocessStatus = crm_CreditNoteAPIHandler.sendTransactionRecord(transactionId , reprocessAccessToken, paymentprovider);
                    System.debug('transactionStatus------else---------'+transactionStatus);
                    if(reprocessStatus == CommonConstants.STATUS_MSG_OK){
    
                        transactionStatus = reprocessStatus;
                       
                        System.debug('transactionStatus--2nd----else---------'+transactionStatus);
    
                        creditNoteId = recordCreation(selectedRefundData,recordId ,reprocessStatus,'','' );
                        if(String.isNotBlank(creditNoteId)){
                            strTransStatusCreditNote = transactionStatus + CommonConstants.DOUBLE_ATRATE_SPILT + creditNoteId;
                            System.debug('creditNoteId-----2nd------'+creditNoteId);
                                                    }
                    }
                }
            }
        }catch(Exception ex) {
            System.debug('Selected Data: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'Selected Data: '+selectedRefundData);
        }
        
        System.debug('strTransStatusCreditNote------last---------'+strTransStatusCreditNote);
        return strTransStatusCreditNote;
    }
    
    
    @AuraEnabled
    public static String digitollSelectedData(Map<String,String> selectedRefundData ,String recordId , String CreditNoteId){
        System.debug('selectedRefundData----digitollSelectedData-------'+selectedRefundData);
        String strStatusMsg;
        HttpResponse response = new HttpResponse();
        crm_CreditNote__c creditNoteObj;
        try{
           Digitoll_Urls__c digitollURLSetting = Digitoll_Urls__c.getValues('Order Refund');
        String orderNumber = selectedRefundData.get('orderNumber');
        String caseNumber = getCaseNumber(recordId);
        String body = '{"reason": "' + caseNumber + '"}';
        Http http = new Http();
        //String strTrasactionSatusOfPaymentWeb = selectedData(selectedRefundData ,recordId ,'');
        //if(strTrasactionSatusOfPaymentWeb == CommonConstants.STATUS_MSG_OK){
            String customCreditedUrl = digitollURLSetting.API_Url__c + orderNumber + CommonConstants.SLASH + CommonConstants.CREDITED;
            System.debug('customCreditedUrl------digitoll---------'+customCreditedUrl);
            Httprequest objRequest = crm_CreditNoteAPIHandler.getHttpPrivateBasenReq(CommonConstants.PUT_METHOD,customCreditedUrl , CommonConstants.APPLICATION_JSON,digitollURLSetting.Username__c , digitollURLSetting.Password__c);
            objRequest.setBody(body);
            response = http.send(objRequest);
            System.debug('response------digitoll---------'+response.getStatuscode() );
            if(response.getStatuscode() == CommonConstants.STATUS_CODE_200){
                strStatusMsg = response.getStatus();
                creditNoteObj = [Select Type__c,Digitoll_Status__c,Digitoll_Send_Status__c from crm_CreditNote__c where Id =: CreditNoteId];
                if(creditNoteObj != null){
                    if(selectedRefundData.containsKey(CommonConstants.ORDER_TYPE))
                        creditNoteObj.Type__c = selectedRefundData.get(CommonConstants.ORDER_TYPE);
                    creditNoteObj.Digitoll_Status__c = strStatusMsg;
                    creditNoteObj.Digitoll_Send_Status__c = CommonConstants.CREDITED;
                    System.debug('creditNoteObj------digitoll---------'+creditNoteObj);
                    Database.update(creditNoteObj);
                }
                
                 //recordCreation(selectedOpenData,recordId , '',response.getStatus(), CommonConstants.CommonConstants.CREDITED);
            }else{
                strStatusMsg = response.getStatus();
            } 
        }catch(CalloutException ex) {
            System.debug('digitollSelectedData Callout: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'digitollSelectedData Callout : '+response);
        }catch(DmlException ex) {
            System.debug('digitollSelectedData DML: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'digitollSelectedData DML: '+creditNoteObj);
        }
        
            
        //}
        
        return strStatusMsg;
    }
    
    
    @AuraEnabled
    public static String getCaseNumber(String recordId){
        case caseObj;
        try{
            if(String.isNotBlank(recordId)){
                caseObj  = [Select id , CaseNumber from Case where Id =:recordId];
            }
        }catch(Exception ex) {
            System.debug('getCaseNumber: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'getCaseNumber: '+ ex.getMessage());
            
        }
        
        
        return caseObj.CaseNumber;
    }
    
    @AuraEnabled
    public static String cancelTransactionPrivateBasen(Map<String,String> selectedOpenData ,String recordId){
        String strStatusMsg;
        Http http = new Http();
        HttpResponse response = new HttpResponse();
        System.debug('selectedOpenData-------------'+selectedOpenData);
        System.debug('recordId-------------'+recordId);
         try{
            Digitoll_Urls__c digitollURLSetting = Digitoll_Urls__c.getValues(CommonConstants.ORDER_REFUND);
            String orderNumber = selectedOpenData.get(CommonConstants.ORDER_NUMBER);
           
            String caseNumber = getCaseNumber(recordId);
            String body = '{"reason": "' + caseNumber + '"}';
           
            String customCancelledUrl = digitollURLSetting.API_Url__c + orderNumber + CommonConstants.SLASH + CommonConstants.TRANSACTION_STATUS_CANCELLED;
            System.debug('customCancelledUrl-------'+customCancelledUrl);
            Httprequest objRequest = crm_CreditNoteAPIHandler.getHttpPrivateBasenReq(CommonConstants.PUT_METHOD,customCancelledUrl , CommonConstants.APPLICATION_JSON,digitollURLSetting.Username__c , digitollURLSetting.Password__c);
            objRequest.setBody(body);
            response = http.send(objRequest);
            System.debug('response.getStatuscode()----'+response.getStatuscode());
            System.debug('response.getStatus()----'+response.getStatus());
            if(response.getStatuscode() == CommonConstants.STATUS_CODE_200){
                strStatusMsg = response.getStatus();
                recordCreation(selectedOpenData,recordId , '',response.getStatus(), CommonConstants.TRANSACTION_STATUS_CANCELLED);
            }else{
                strStatusMsg = response.getStatus();
            }
         }catch(CalloutException ex) {
            System.debug('cancelTransactionPrivateBasen: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'cancelTransactionPrivateBasen : '+response);
        }
        return strStatusMsg;
    }
    
    public static String recordCreation(Map<String,String> mapselectedData , String strRecordId , String strDigiStamp_Status , String strDigitollStatus , String strDigitollSenStatus){
        crm_CreditNote__c newCredit = new crm_CreditNote__c();
        String creditNoteId ='';
        try{
            newCredit.Case__c = strRecordId;
            newCredit.Email_Address__c = mapselectedData.get(CommonConstants.EMAIL_ADDRESS);
            newCredit.Transaction_Id__c = mapselectedData.get(CommonConstants.TRANSACTION_ID);
            newCredit.isRefunded__c = true;
            newCredit.Order_Number__c = Decimal.valueOf(mapselectedData.get(CommonConstants.ORDER_NUMBER)) != null ? Decimal.valueOf(mapselectedData.get(CommonConstants.ORDER_NUMBER)) : null ;
            newCredit.Phone_Number__c = mapselectedData.get(CommonConstants.PHONE_NUMBER);
            newCredit.ShipmentNumber__c = String.valueOf(mapselectedData.get(CommonConstants.SHIPMENT_NUMBER)) != null ? String.valueOf(mapselectedData.get(CommonConstants.SHIPMENT_NUMBER)) : '';
            if(!mapselectedData.containsKey(CommonConstants.ORDER_TYPE))
                newCredit.Transaction_Date__c = Date.valueOf(mapselectedData.get(CommonConstants.TRANSACTION_DATE));     
            
            newCredit.Username__c =  String.isNotBlank(mapselectedData.get(CommonConstants.USERNAME)) ? mapselectedData.get(CommonConstants.USERNAME) : '';
            newCredit.Digital_Stamp_Status__c = String.isNotBlank(strDigiStamp_Status) ? strDigiStamp_Status : '';
            newCredit.Digitoll_Status__c = String.isNotBlank(strDigitollStatus) ? strDigitollStatus : '';
            newCredit.Digitoll_Send_Status__c = String.isNotBlank(strDigitollSenStatus) ? strDigitollSenStatus : '';
            if(mapselectedData.containsKey(CommonConstants.ORDER_TYPE)){
                newCredit.Type__c = mapselectedData.get(CommonConstants.ORDER_TYPE);
                System.debug('Digitoll Type'+newCredit.Type__c);
            }
            else{
                
                 newCredit.Type__c = CommonConstants.DIGITAL_STAMPS;
                System.debug('Type'+newCredit.Type__c);
            }
            
            //Adding New Payment Type for Digital Stamps.
            if(mapselectedData.containsKey(CommonConstants.PAYMENT_PROVIDER)){
                newCredit.Payment_Type__c = mapselectedData.get(CommonConstants.PAYMENT_PROVIDER);
                System.debug('Digital Stamp Payment Type'+newCredit.Payment_Type__c);
            }
            else if(mapselectedData.containsKey(CommonConstants.PAYMENT_TYPE)){
                newCredit.Payment_Type__c = mapselectedData.get(CommonConstants.PAYMENT_TYPE);
                System.debug('Digital Stamp Payment Type'+newCredit.Payment_Type__c);
            }
            else{
                 newCredit.Payment_Type__c = '';
                System.debug('Digitoll Payment Type'+newCredit.Payment_Type__c);
            }
           
            if(mapselectedData.get(CommonConstants.TRANSACTION_AMOUNT)  != null || mapselectedData.get(CommonConstants.TRANSACTION_AMOUNT)  != '' ){
                System.debug('Transaction Amount digitoll-- '+mapselectedData.containsKey(CommonConstants.ORDER_TYPE));
               /* if(mapselectedData.containsKey(CommonConstants.ORDER_TYPE)) {
                   System.debug('check order is type  present');
                    newCredit.Transaction_Amount__c = Decimal.valueOf(mapselectedData.get(CommonConstants.TRANSACTION_AMOUNT));
                    newCredit.CurrencyIsoCode = String.valueOf(mapselectedData.get(CommonConstants.CURRENCY_CODE));
                }
                else{*/
                     System.debug('Transaction Amount digistamp--  '+mapselectedData.get(CommonConstants.TRANSACTION_AMOUNT));
                     List<String> lstTransactionAmount = (mapselectedData.get(CommonConstants.TRANSACTION_AMOUNT)).split(',- ');
                     newCredit.Transaction_Amount__c = Decimal.valueOf(lstTransactionAmount.get(0));
                     newCredit.CurrencyIsoCode = lstTransactionAmount.get(1);
                //}
               
            }
            Database.insert(newCredit);
            if(String.isNotBlank(newCredit.Id)){
                creditNoteId = newCredit.Id;
            }
        }catch(DmlException ex) {
            System.debug('Credit Note Insertion: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'CreditNote_NewRecord: '+newCredit);
        }
       return creditNoteId;
    }
    
    
    public Class WrapTableData{
        @AuraEnabled
        public List<String> headersLabels;
        //@AuraEnabled
        //public List<crm_CreditNote_ResponseHandler> responseTableData;
        @AuraEnabled
        public map<integer,map<string , String>> responseTableData;
        @AuraEnabled
        public String accessJWTToken;
    }
}