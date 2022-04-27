public class cs_DisqualifyHandler {
public account accObj;
    public string errorMessage{get;set;}
    public string errorMessageClassic{get;set;}
    public string personId;
    public boolean disqualifyStatus;
    public string farPartyNumber;  
        
    public cs_DisqualifyHandler(ApexPages.StandardController stdController){
        this.accObj = (account)stdController.getRecord();
        system.debug('account --> '+accObj);        
    }
    
       
    public pageReference getdisqualifyStatusFromPB(){
        
        farPartyNumber = [select Id, crm_Customer_Number__c from account where id = :accObj.Id].crm_Customer_Number__c;
        system.debug('farPartyNumber --> '+farPartyNumber);
                
        if(farPartyNumber.isNumeric()){
            try{
                Http http = New Http();
            
                HttpRequest req = New HttpRequest();
                Digitoll_Urls__c digitollUrls = Digitoll_Urls__c.getValues('Get disqualified status from PB');
            	String urlEndpoint = digitollUrls.API_Url__c;
                req.setEndpoint(urlEndpoint + farPartyNumber);
                String userName = digitollUrls.Username__c;
                String password = digitollUrls.Password__c;
                Blob headerValue = Blob.valueOf(username+':'+password);
                String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
                system.debug('urlEndpoint --> '+urlEndpoint);
            
                req.setHeader('Content-Type','application/json;charset=UTF-8');
                req.setHeader('Content-Length','0');
                req.setHeader('Authorization', authorizationHeader);
                req.setTimeout(20000);
                req.setMethod('GET');
                
                HttpResponse res = http.send(req);
                
                system.debug('http callout status --> '+ res.getStatusCode()+ ' ' + res.getStatus());
                system.debug('JSON Response --> '+res.getBody());
                string responseBody = res.getBody();
                customerQualifierDetails wrapper = (customerQualifierDetails) json.deserialize(responseBody, customerQualifierDetails.class);
                system.debug('wrapper --> '+wrapper);
            
                if(res.getStatusCode() == 200 && res.getStatus() == 'OK'){
                    personId = String.valueOf(wrapper.personId);
                    disqualifyStatus = Boolean.valueOf(wrapper.disqualifiedStatus);
                    system.debug('PersonId -->' + personId);
                    system.debug('disqualifyStatus -->' + disqualifyStatus);
                                        
                    //Boolean calloutSuccess = getPersonPreferenceFromPB(personId);
                    
                    //if(!calloutSuccess){
                    // return null;
                    //}
                    accObj.Person_Id__c=personId;
                    accObj.Disqualified__c=disqualifyStatus;
                    accObj.Not_updated_from_trigger__c = true;
                    accObj.Last_private_basen_sync__c = string.valueOf(system.now());
                    update accObj;
                    
                    String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
                    String currentRecordUrl = baseUrl+'/'+accObj.Id;
                    PageReference page = New PageReference(currentRecordUrl);
                    page.setRedirect(true);
                    return page;
                }
                else{
                    if(res.getStatusCode() == 400 || wrapper.status == 'BAD_REQUEST'){
                        errorMessage = system.label.FAR_party_number_does_not_exist;
                        errorMessage = errorMessage.replace('####', farPartyNumber);
                    	errorMessageClassic = errorMessage;
                    }
                    else {
                        errorMessage = System.Label.Private_Basen_callout_failed + res.getStatusCode() + ' ' + res.getStatus();
                        //errorMessageClassic = 'ERROR : Callout Failed - Connection Issue. ' + res.getStatusCode() + ' ' + res.getStatus();
                        errorMessageClassic = errorMessage;
                    }
                    
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
    
    //******************************************Wrapper Classes********************************************************

    public class customerQualifierDetails{
        public string personId;
        public string disqualifiedStatus;
        public string status;
        public string error;
        public string message;
        public string correlationId;
    }
}