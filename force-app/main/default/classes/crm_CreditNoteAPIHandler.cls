public class crm_CreditNoteAPIHandler {
    
     public static HttpResponse getResponseFromPaymentWeb(String strRequestJSON){
         HttpResponse responseSearchData;
         try{
            String jwtAccessToken = crm_CreditNoteAPIHandler.getAccessToken();
            Http http = new Http();
            Httprequest objRequest = getHttpReq(CommonConstants.POST_METHOD,jwtAccessToken ,CommonConstants.NAMED_CRED_REQUEST_DATA);
    
            objRequest.setBody(strRequestJSON);
            responseSearchData = http.send(objRequest);
             System.debug('objRequest--------------------------- '+objRequest);
            System.debug('responseBody: objRequest '+responseSearchData);
            System.debug('responseBody: body '+responseSearchData.getBody());
            System.debug('responseBody: status '+responseSearchData.getStatus());
            System.debug('responseBody: status code'+responseSearchData.getStatuscode());
          
        }catch(CalloutException ex) {
        	System.debug('Get Response from payment web: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'Response from PaymentWeb: '+responseSearchData);
		}
        
         return responseSearchData;
        
     }
    
    public static String sendTransactionRecord(String transactionId, String jwtAccessToken, String paymentprovider){
        System.debug('transactionId: '+transactionId);
        System.debug('jwtAccessToken: '+jwtAccessToken);
        System.debug('UserInfo.getUserId()----------------'+UserInfo.getUserId());
        HttpResponse response;
        String strStatusMsg = '';
        try{
            Http http = new Http();
            Httprequest request = getHttpReq(CommonConstants.PUT_METHOD,jwtAccessToken , CommonConstants.NAMED_CRED_SEND_TRANSACTION_ID +transactionId +CommonConstants.SLASH +paymentprovider);
            
            //request.setBody(jsonData);
            System.debug('responseBody: '+request);
            response = http.send(request);
            System.debug('responseBody: '+response.getBody());
       	    System.debug('responseBody: '+response.getBody());
            system.debug('response.getStatus()+Handler+++'+response.getStatus());
            system.debug('response.getStatuscode()+Handler+++'+response.getStatuscode());
            if(response.getStatuscode() == CommonConstants.STATUS_CODE_200){
                strStatusMsg = response.getStatus();
            }
            else if(response.getStatuscode() == CommonConstants.STATUS_CODE_401){
                strStatusMsg = getErrorDetails(response);
            }
            
        	System.debug('strStatusMsg: '+strStatusMsg);
        }catch(CalloutException ex) {
        	System.debug('Send Transaction Record: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'Send Transaction Record: '+response);
		}
        
           // {"errorCode":"jwt_token_expired","message":"Token is expired"}
        return strStatusMsg;
    }
    
    @testVisible
    private static HttpRequest getHttpReq(String method,String jwtAccessToken,String endpoint){
        Httprequest objRequest = new HttpRequest();
        try{
            objRequest.setMethod(method);
            objRequest.setHeader('Content-Type', 'application/json');
            objRequest.setHeader('user_id',UserInfo.getUserId());
            if(String.isNotBlank(jwtAccessToken))
                objRequest.setHeader('jwt_token',jwtAccessToken);
            objRequest.setEndpoint(endpoint);
        
        }catch(Exception ex) {
        	System.debug('Get HttpReq: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'Get HttpReq: '+endpoint + '@@@@' +jwtAccessToken);
		}
        
        return objRequest;
    } 
    
    
    public static HttpRequest getHttpPrivateBasenReq(String method,String endpoint , String applicationJSON,String username ,String password){
        Httprequest objRequest = new HttpRequest();
        try{
            objRequest.setMethod(method);
            objRequest.setHeader('Content-Type', applicationJSON);
            objRequest.setEndpoint(endpoint);
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            objRequest.setHeader('Authorization', authorizationHeader);
        
        }catch(Exception ex) {
        	System.debug('Get HttpReq: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'getHttpPrivateBasenReq: '+endpoint + '@@@@' +method);
		}
        
        return objRequest;
    } 
    
    public static String getErrorDetails(HttpResponse responseErrorData){
        WrapResponseStatus responseStatus;
        String strStatusMsg;
        try{
            if(!String.isEmpty(responseErrorData.getBody())){
                System.debug('response.getBody() 401 api handler'+responseErrorData.getBody());
                responseStatus = (WrapResponseStatus)JSON.deserialize(responseErrorData.getBody(), WrapResponseStatus.class);
                strStatusMsg = responseStatus.errorCode;
        	}
        }catch(Exception ex) {
        	System.debug('Get Error Details: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'Get Error Details: '+responseStatus);
		}
        
        system.debug('responseStatus+Handler+++'+responseStatus);
        return strStatusMsg;
    }
    
    public static String getTokenFromCache(){
        String cachedToken = CommonConstants.BLANK;
        try{
            Cache.OrgPartition orgPart = Cache.Org.getPartition(CommonConstants.SESSION_CACHE);
        cachedToken = (String)orgPart.get(CommonConstants.CACHE_ACCESS_TOKEN);
        }catch(Exception ex) {
        	System.debug('Get Cache: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'Get Cache Access Token: '+cachedToken);
		}
        return cachedToken;
    }
    
    public static String getAccessToken() {
        String token = CommonConstants.BLANK;
        String cachedToken = getTokenFromCache();
        HttpResponse response;
        System.debug('Authenticate:');
        try{
            if (String.isNotBlank(cachedToken)) {
                token = cachedToken;
                System.debug('cachedToken: '+cachedToken);
            } 
            else {
                Http http = new Http();
                Httprequest request = getHttpReq(CommonConstants.POST_METHOD,CommonConstants.BLANK , CommonConstants.NAMED_CRED_REQUEST_TOKEN);
    
                System.debug('responseBody: '+request);
                response = http.send(request);
                System.debug('responseBody: '+response.getBody());
                if (response.getStatusCode() == CommonConstants.STATUS_CODE_200) {
                    Map<String,object> results = (Map<String,object>) JSON.deserializeUntyped(response.getBody());
                    token = String.valueOf(results.get(CommonConstants.TOKEN));
                    Cache.Org.put('local.CreditNotePartition.AccessTokenCreditNote', token);
                    System.debug('results: '+token);
                }
            }
        }catch(CalloutException ex) {
        	System.debug('Get Access Token Callout : ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'Get Access Token: '+response);
		}catch(Exception e) {
        	System.debug('Get Access Token: ' + e.getMessage());
            ExceptionController.createErrorRecord(e, 'Get Access Token: '+response);
		}
      

        return token;
    }
    
    public class WrapResponseStatus {
        String errorCode;
        String message;
    }
    
   
    

}