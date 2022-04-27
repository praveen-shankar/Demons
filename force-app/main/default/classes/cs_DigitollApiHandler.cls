public class cs_DigitollApiHandler {
	
    public account accObj;
    public string errorMessage{get;set;}
    public string errorMessageClassic{get;set;}
    public string personId;
    public boolean disqualifyStatus;
    public string farPartyNumber;
        
        
    public cs_DigitollApiHandler(ApexPages.StandardController stdController){
        this.accObj = (account)stdController.getRecord();
        system.debug('account --> '+accObj);        
    }
    
       
    /*public pageReference getdisqualifyStatusFromPB(){
        
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
                                        
                    Boolean calloutSuccess = getPersonPreferenceFromPB(personId);
                    
                    if(!calloutSuccess){
                        return null;
                    }
                    
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
    
    
    public boolean getPersonPreferenceFromPB(string personId){
        Account acc = [Select id, crm_Customer_Number__c, person_Id__c, disqualified__c, Do_not_want_custom_clearance__c, Last_private_basen_sync__c, Not_updated_from_trigger__c from account where crm_Customer_Number__c = :farPartyNumber];
        system.debug('acc --> '+acc);        
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
              
            //req.setEndpoint(urlEndpoint+personId);
            //req.setEndpoint(urlEndpoint + farPartyNumber);--old 
            req.setMethod('GET');
            req.setTimeout(20000);
            
            HttpResponse res = http.send(req);
            system.debug('Callout Response--> '+res.getStatusCode() + ' ' + res.getStatus());
            
            if(res.getStatusCode()==200 && res.getStatus()=='OK'){
                system.debug('Response Body --> '+res.getBody());
                String responseBody = res.getBody();
                List<personPreference> personPreference_Wrapper = (List<personPreference>) JSON.deserialize(responseBody, List<personPreference>.class);
                system.debug('personPreference_Wrapper --> '+ personPreference_Wrapper);
                
                acc.person_Id__c = personId;
                acc.Disqualified__c = disqualifyStatus;
                acc.Not_updated_from_trigger__c = true;
                acc.Last_private_basen_sync__c = string.valueOf(system.now());
                for(personPreference pf : personPreference_Wrapper){
                    if(pf.preferenceTypeCode == 'RESERVATION_CUSTOMS_CLEARANCE'){
                        acc.Do_not_want_custom_clearance__c = Boolean.valueOf(pf.preferenceValue);
                    }
                }
                //acc.Do_not_want_custom_clearance__c = Boolean.valueOf(personPreference_Wrapper[1].preferenceValue);
                update acc;
                
            }
            else{
                system.debug('Callout Failed. ' + res.getStatusCode() + ' ' + res.getStatus());
                errorMessage = System.Label.Private_Basen_callout_failed + res.getStatusCode() + ' ' + res.getStatus();
                errorMessageClassic = errorMessage;
                
                return false;
            }
			return true;
        }
        catch(exception e){
            system.debug('Exception --> Error occured at line '+ e.getLineNumber() + ' with message '+ e.getMessage() + '.' + 'Stack trace - '+ e.getStackTraceString());
            errorMessage = System.Label.Digitol_Exception + e.getMessage();
            errorMessage = errorMessage.replace('####', string.valueOf(e.getLineNumber()));
        	errorMessageClassic = errorMessage;
            return false;
        }
    }*/
    
    
    @Future(Callout=true)
    public static void setQualifyStatusInPB(Boolean disqualifiedStatus, String personId, String customerId){
        Account acc = [Select id, crm_Customer_Number__c,person_Id__c, Disqualified__c, Last_private_basen_sync__c, trigger_callout_status__c, trigger_callout_message__c from account where Id = :customerId];
        try{
            Http http = New Http();
            HttpRequest req = New HttpRequest();
            
            Digitoll_Urls__c digitollUrls = Digitoll_Urls__c.getValues('Update disqualified status to PB');
            String urlEndpoint = digitollUrls.API_Url__c;
            urlEndpoint = urlEndpoint.replace('{status}', String.valueOf(disqualifiedStatus));
            String userName = digitollUrls.Username__c;
            String password = digitollUrls.Password__c;
            Blob headerValue = Blob.valueOf(username+':'+password);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            system.debug('urlEndpoint --> '+urlEndpoint);
            
            req.setEndpoint(urlEndpoint + personId);
            //req.setEndpoint(urlEndpoint + farPartyNumber);
            system.debug(urlEndpoint + '/' + disqualifiedStatus);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type','application/json;charset=UTF-8');
            req.setHeader('Content-Length','0');
            req.setTimeout(20000);
            req.setMethod('PUT');
            
            HttpResponse res = http.send(req);
            system.debug('http callout status --> '+ res.getStatusCode()+ ' ' + res.getStatus());
            system.debug('JSON Resonse --> '+res.getBody());
            if(res.getStatusCode() == 200 && res.getStatus() == 'OK'){
                acc.Last_private_basen_sync__c = String.valueOf(system.Now());
                acc.Trigger_Callout_Status__c = 'Success';
                acc.trigger_callout_message__c = System.Label.Trigger_callout_success;
                update acc;
            }
            else{
                disqualifierApiError errorResponseWrapper = (disqualifierApiError) json.deserialize(res.getBody(),disqualifierApiError.class);
                system.debug('Error Response --> ' + errorResponseWrapper);
                system.debug('StringValue --> '+string.valueOf(errorResponseWrapper.status));
                if(res.getStatusCode() == 400){
                    system.debug('Error - Record Not Present In Private Basen');
                    
                    acc.Trigger_Callout_Status__c = 'Error';
                    acc.Trigger_Callout_Message__c = System.Label.Record_not_present_in_PB;
                }
                else{
                    system.debug('Error - ' + res.getStatusCode() + ' ' + res.getStatus());
                    acc.Trigger_Callout_Status__c = 'Error';
                    acc.Trigger_Callout_Message__c = System.Label.Private_Basen_callout_failed + res.getStatusCode() + ' ' + res.getStatus();
                }
                update acc;
            }
        }
        catch(exception e){
            system.debug('Exception --> Error occured at line '+ e.getLineNumber() + ' with message '+ e.getMEssage() + '.' + 'Stack trace - '+ e.getStackTraceString());
        	acc.Trigger_Callout_Status__c = 'Error';
            String exp = System.Label.Digitol_Exception + e.getMessage();
            exp = exp.replace('####', string.valueOf(e.getLineNumber()));
            acc.Trigger_Callout_Message__c = exp;
            update acc;
        }
        
    }
    
        
    @Future(Callout=true)
    public static void setCustomClearancePreferenceInPB(Boolean customClearance, String personId, String customerId){
        Account acc = [Select id, crm_Customer_Number__c,person_Id__c, Disqualified__c, Last_private_basen_sync__c, Trigger_Callout_Status__c, Trigger_Callout_Message__c from account where Id = :customerId];
       
        //updated as part of Endpoint change 24March2021
        string farPartyNumber = acc.crm_Customer_Number__c;
        system.debug('farPartyNumber --> '+farPartyNumber);
        //--end update 24March2021--
        
        try{
            Http http = New Http();
            HttpRequest req = New HttpRequest();
            
            Digitoll_Urls__c digitollUrls = Digitoll_Urls__c.getValues('Person Preference');
            String urlEndpoint = digitollUrls.API_Url__c;
            String userName = digitollUrls.Username__c;
            String password = digitollUrls.Password__c;
            Blob headerValue = Blob.valueOf(username+':'+password);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            system.debug('urlEndpoint --> '+urlEndpoint);
            
            List<updatePreference> updatePreferenceList = New List<updatePreference>();
            updatePreference updatePreferenceObj = New updatePreference();
            updatePreferenceObj.preferenceTypeCode = 'RESERVATION_CUSTOMS_CLEARANCE';
            updatePreferenceObj.preferenceValue = String.valueOf(customClearance);
			updatePreferenceList.add(updatePreferenceObj);  
            system.debug('JSON body to send--> ' + JSON.serialize(updatePreferenceList, true));
            
            //updated as part of Endpoint change 24March2021
            req.setEndpoint(urlEndpoint+'partynumber='+farPartyNumber);
            //--End update 24March2021-- */
            
            //req.setEndpoint(urlEndpoint + personId);
            //system.debug(urlEndpoint + personId);
            req.setHeader('Authorization', authorizationHeader);
            req.setBody(JSON.serialize(updatePreferenceList, true));
            req.setHeader('Content-Type','application/json;charset=UTF-8');
            req.setHeader('Content-Length','0');
            req.setTimeout(20000);
            req.setMethod('PUT');
            
            HttpResponse res = http.send(req);
            system.debug('http callout status --> '+ res.getStatusCode()+ ' ' + res.getStatus());
            system.debug('JSON Resonse --> '+res.getBody());
            if(res.getStatusCode() == 200 && res.getStatus() == 'OK'){
                acc.Last_private_basen_sync__c = String.valueOf(system.Now());
                acc.Trigger_Callout_Status__c = 'Success';
                acc.Trigger_Callout_Message__c = System.Label.Trigger_callout_success;
                update acc;
            }
            else{
                if(res.getStatusCode() == 400){
                    system.debug('Error - Record Not Present In Private Basen');
                    acc.Trigger_Callout_Status__c = 'Error';
                    acc.Trigger_Callout_Message__c = System.Label.Record_not_present_in_PB;
                }
                else{
                    system.debug('Error - ' + res.getStatusCode() + ' ' + res.getStatus());
                    acc.Trigger_Callout_Status__c = 'Error';
                    acc.Trigger_Callout_Message__c = System.Label.Private_Basen_callout_failed + res.getStatusCode() + ' ' + res.getStatus();
                }
                update acc;
            }
        }
        catch(exception e){
            system.debug('Exception --> Error occured at line '+ e.getLineNumber() + ' with message '+ e.getMEssage() + '.' + 'Stack trace - '+ e.getStackTraceString());
        	acc.Trigger_Callout_Status__c = 'Error';
            String exp = System.Label.Digitol_Exception + e.getMessage();
            exp = exp.replace('####', string.valueOf(e.getLineNumber()));
            acc.Trigger_Callout_Message__c = exp;
            update acc;
        }
        
    }

/******************************************Wrapper Classes********************************************************/

    
    /*public class customerQualifierDetails{
        public string personId;
        public string disqualifiedStatus;
        public string status;
        public string error;
        public string message;
        public string correlationId;
    }
    
    public class personPreference{
        public string preferenceTypeCode;
        public string preferenceValue;
        public string preferenceDescription;
        public string preferenceCategory;
    }*/
    
    public class disqualifierApiError{
        public string timestamp;
        public string status;
        public string error;
        public string message;
        public string path;
    }
    
    public class updatePreference{
        public string preferenceTypeCode;
        public string preferenceValue;
    } 
}