public class cs_CustomClearanceConsentHandler {
	public account accObj;
    public string errorMessage{get;set;}
    public string errorMessageClassic{get;set;}
    public string farPartyNumber;    
    
        
    public cs_CustomClearanceConsentHandler(ApexPages.StandardController stdController){
        this.accObj = (account)stdController.getRecord();
        system.debug('account --> '+accObj);        
    }
    
       
    public pageReference getCustomClearanceConsentFromPB(){
        
        farPartyNumber = [select Id, crm_Customer_Number__c from account where id = :accObj.Id].crm_Customer_Number__c;
        system.debug('farPartyNumber --> '+farPartyNumber);
                
        if(farPartyNumber.isNumeric()){
            try{    
                Http http = New Http();
            	HttpRequest req = New HttpRequest();
            
            	Digitoll_Urls__c digitollUrls = Digitoll_Urls__c.getValues('Person Preference');
            	String urlEndpoint = digitollUrls.API_Url__c;
            	String userName = digitollUrls.Username__c;
            	String password = digitollUrls.Password__c;
            	Blob headerValue = Blob.valueOf(username+':'+password);
            	String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            	system.debug('urlEndpoint -----> '+urlEndpoint);
            
            	req.setHeader('Content-Type','application/json;charset=UTF-8');
            	req.setHeader('Content-Length','0');
            	req.setHeader('Authorization', authorizationHeader);                     
            	req.setEndpoint(urlEndpoint+'partynumber='+farPartyNumber);            
            	req.setMethod('GET');
            	req.setTimeout(20000);
            
            	HttpResponse res = http.send(req);
            	system.debug('Callout Response--> '+res.getStatusCode() + ' ' + res.getStatus());
            
            	if(res.getStatusCode()==200 && res.getStatus()=='OK'){
                	system.debug('Response Body --> '+res.getBody());
                	String responseBody = res.getBody();
                	List<personPreference> personPreference_Wrapper = (List<personPreference>) JSON.deserialize(responseBody, List<personPreference>.class);
                	system.debug('personPreference_Wrapper --> '+ personPreference_Wrapper);
                
                	accObj.Not_updated_from_trigger__c = true;
                	accObj.Last_private_basen_sync__c = string.valueOf(system.now());
                	for(personPreference pf : personPreference_Wrapper){
                    	if(pf.preferenceTypeCode == 'RESERVATION_CUSTOMS_CLEARANCE'){
                        	accObj.Do_not_want_custom_clearance__c = Boolean.valueOf(pf.preferenceValue);
                   	 	}
                	}
                	update accObj;
                	String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
                    String currentRecordUrl = baseUrl+'/'+accObj.Id;
                    PageReference page = New PageReference(currentRecordUrl);
                    page.setRedirect(true);
                    return page;
                }else{
                    system.debug('Callout Failed. ' + res.getStatusCode() + ' ' + res.getStatus());
                	errorMessage = System.Label.Private_Basen_callout_failed + res.getStatusCode() + ' ' + res.getStatus();
                	errorMessageClassic = errorMessage;
                    return null; 
                }
            }
            catch(exception e){
                system.debug('Exception --> Error occured at line '+ e.getLineNumber() + ' with message '+ e.getMessage() + '.' + 'Stack trace - '+ e.getStackTraceString());
                errorMessage = System.Label.Digitol_Exception + e.getMessage();
                errorMessage = errorMessage.replace('####', string.valueOf(e.getLineNumber()));
                return null;
            }
        }
        else{
            errorMessage = System.Label.Alphanumeric_FAR_Party_Number;
            errorMessageClassic = errorMessage;
            return null;
        }
        
    }    
   
 /******************************************Wrapper Classes********************************************************/
    
    public class personPreference{
        public string preferenceTypeCode;
        public string preferenceValue;
        public string preferenceDescription;
        public string preferenceCategory;
    }   
    
}