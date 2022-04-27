global class crm_CreatePartyCustomer{
    
    public Account acc{get;set;}
    public static Account Accountinfo;
    public crm_Request_RelationCustomer__c customerObj {get;set;}
    Map<String,String> ISOcountryCodeMap;
    public boolean requiredFlag{get;set;}
    
    public crm_CreatePartyCustomer(ApexPages.StandardController controller) {
        this.acc= (Account)controller.getRecord();
        customerObj  = new crm_Request_RelationCustomer__c ();
        customerObj.Name = String.ValueOf(this.acc.id);
        customerObj.crm_AdditionalInformation__c = 'Salesforce contact: '+ UserInfo.getUserEmail();
        customerObj.crm_Credit_Needed__c = true;
        requiredFlag = customerObj.crm_Credit_Needed__c;
        ISOcountryCodeMap = new Map<String,String>();
        for(crm_ISO_Country_Codes__c c : crm_ISO_Country_Codes__c.getAll().values())
            ISOcountryCodeMap.put(c.crm_Country__c,c.crm_ISO_Country_Code__c);    
    }
    
    
    //User Authorization
    private String createBasicAuthentication(String username, string password){
        Blob b = Blob.valueOf(username + ':' + password);   
        String encodedValue = EncodingUtil.base64Encode(b);   
        return 'Basic ' + encodedValue;
    } 
    
    public void toggleStatus(){
        System.debug('-------------');
        if(customerObj.crm_Credit_Needed__c)
            requiredFlag = true;
        else
            requiredFlag = false;
    }
    
    public PageReference convertToParty(){
        
        try{
            Accountinfo=[Select Id,crm_Sent_to_CDH__c,crm_Requested_Credit_Amount__c,crm_On_Behalf_of__c,crm_Addressee__c,Name,Orga__c,crm_ISO_Countrycode_for_Customer_Company__c,crm_Credit_Limit__c,crm_Invoice_reference__c,ShippingStreet,BillingCity,BillingState,BillingCountry,ShippingPostalCode,ShippingCity,ShippingState,BillingStreet,BillingPostalCode,ShippingCountry
            from Account where id=:acc.id];
 
            if((String.isNotBlank(Accountinfo.crm_ISO_Countrycode_for_Customer_Company__c) && String.isNotBlank(Accountinfo.Orga__c)) && (Accountinfo.crm_Sent_to_CDH__c == false)
                &&((AccountInfo.ShippingPostalCode != null && AccountInfo.ShippingCity != null && AccountInfo.ShippingCountry != null && ISOcountryCodeMap.containsKey(AccountInfo.ShippingCountry.trim().toLowerCase()) 
                )||(AccountInfo.BillingPostalCode != null && AccountInfo.BillingCity != null && AccountInfo.BillingCountry != null && ISOcountryCodeMap.containsKey(AccountInfo.BillingCountry.trim().toLowerCase())))){
                postenNoEconnectCreatecustomerparty.CreateCustomerPartyPort  postenEconnect=new postenNoEconnectCreatecustomerparty.CreateCustomerPartyPort ();
                
                //Setting headers required by eConnect
                postenNoEconnectCommonHeaderV1.HeaderType headers = new postenNoEconnectCommonHeaderV1.HeaderType();
                
                headers.MessageId = Accountinfo.Id;
                headers.ServiceName = 'T50572_CreateCustomerPartyCRM_PS';
                headers.MessageType = 'T50572_CreateCustomerPartyCRM';
                headers.OperationName = 'CreateCustomerParty';
                headers.IntergationURI = 'T50572_CreateCustomerPartyCRM/ProxyServices/T50572_CreateCustomerPartyCRM_PS';
                headers.ResubmissionPoint = 'PROXY';
                headers.FirstProcessedTimestamp = System.now();
                headers.ProcessedTimestamp = System.now();
                headers.SourceSystemTimestamp = System.now();
                headers.SourceSystemUser = UserInfo.getUserId();
                headers.SourceSystemRef =  UserInfo.getOrganizationId();
                headers.MessageMode = 'REQUEST';
                headers.SourceSystem = 'CRM';
                headers.SourceCompany = 'POS';
                postenEconnect.SOAP_HeaderPart = headers;
                
                
                //orgType info
                postenNoEconnectCreatecustomerparty.OrganizationType orgTypeInfo=new postenNoEconnectCreatecustomerparty.OrganizationType();
                orgTypeInfo.FiscalCode=Accountinfo.Orga__c;
                orgTypeInfo.OrganizationName=Accountinfo.Name;
                if(ISOcountryCodeMap.containsKey(AccountInfo.crm_ISO_Countrycode_for_Customer_Company__c.toLowerCase()))
                orgTypeInfo.CountryCode=ISOcountryCodeMap.get(AccountInfo.crm_ISO_Countrycode_for_Customer_Company__c.toLowerCase());
                orgTypeInfo.RegistrationType = 'SPO';
                
                //Customer Account Info
                postenNoEconnectCreatecustomerparty.CustomerAccountType customerAccInfo=new postenNoEconnectCreatecustomerparty.CustomerAccountType();
                
                //Addresstype- shipping Address
                postenNoEconnectCreatecustomerparty.AddressType Shippingaddress;
                
                //Addresstype- Billing address
                postenNoEconnectCreatecustomerparty.AddressType Billingaddress;
                
                //populate address information for shipping address 
                    if(AccountInfo.ShippingPostalCode != null && AccountInfo.ShippingCity != null && AccountInfo.ShippingCountry != null && ISOcountryCodeMap.containsKey(AccountInfo.ShippingCountry.trim().toLowerCase())){
                    Shippingaddress= new postenNoEconnectCreatecustomerparty.AddressType();
                    Shippingaddress.AddressLine1=AccountInfo.ShippingStreet;
                    Shippingaddress.PostalCode=AccountInfo.ShippingPostalCode.deleteWhiteSpace();
                    Shippingaddress.City=AccountInfo.ShippingCity;
                    Shippingaddress.State=AccountInfo.ShippingState;
                    Shippingaddress.County=AccountInfo.ShippingCountry;
                    Shippingaddress.CountryCode= ISOcountryCodeMap.get(AccountInfo.ShippingCountry.trim().toLowerCase());
                    Shippingaddress.AddrTYPE='DeliveryAddress';
                    }
                
                //populate address information for billing address    
                    if(AccountInfo.BillingPostalCode != null && AccountInfo.BillingCity != null && AccountInfo.BillingCountry != null && ISOcountryCodeMap.containsKey(AccountInfo.BillingCountry.trim().toLowerCase())){
                    Billingaddress= new postenNoEconnectCreatecustomerparty.AddressType();
                    Billingaddress.AddressLine1=AccountInfo.BillingStreet;
                    Billingaddress.PostalCode=AccountInfo.BillingPostalCode.deleteWhiteSpace();
                    Billingaddress.City=AccountInfo.BillingCity;
                    Billingaddress.State=AccountInfo.BillingState;
                    Billingaddress.County=AccountInfo.BillingCountry;
                    Billingaddress.CountryCode=ISOcountryCodeMap.get(AccountInfo.BillingCountry.trim().toLowerCase());
                    Billingaddress.AddrTYPE='BillingAddress';
                    }
                    
                //Addresslist holds billing and shipping address
                List<postenNoEconnectCreatecustomerparty.AddressType> addressList=new List<postenNoEconnectCreatecustomerparty.AddressType>();
                if(Shippingaddress != null)
                    addressList.add(Shippingaddress);
                if(Billingaddress != null)
                    addressList.add(Billingaddress);
                
                //contactInfo holds the Contact details for the Account
                postenNoEconnectCreatecustomerparty.CustomerAccountContactType contactInfo=new postenNoEconnectCreatecustomerparty.CustomerAccountContactType();
                contactInfo.FirstName=customerObj.crm_First_Name__c;
                contactInfo.LastName=customerObj.crm_Last_Name__c;
                contactInfo.MobileNumber=customerObj.crm_Mobile__c;
                contactInfo.EmailAddress=customerObj.crm_Email__c;
                
                
                //Assigning values to properties of customerAccInfo of type Customer Account Type
                customerAccInfo.AccountName=Accountinfo.Name;
                customerAccInfo.Address=addressList;
                customerAccInfo.CustomerAccountContact=contactInfo;
                customerObj.crm_Party_Account_Id__c = Accountinfo.id;
                customerObj.crm_Customer__c = Accountinfo.id;
                
                // Assigning value as per new mapping
                if(customerObj.crm_Credit_Needed__c)
                    customerAccInfo.CreditNeeded = 'Y';
                else
                    customerAccInfo.CreditNeeded = 'N';
                
                customerAccInfo.CustomerReference = AccountInfo.crm_Invoice_reference__c;
                
                
                if(!String.isEmpty(String.valueof(Accountinfo.crm_Credit_Limit__c)))
                    customerAccInfo.RequestedCreditAmount = String.valueof(Accountinfo.crm_Credit_Limit__c);
                if(addressList != null && addressList.size() > 0)
                {
                customerAccInfo.Addressee = Accountinfo.crm_Addressee__c;
                customerAccInfo.OnBehalfOf = Accountinfo.crm_On_Behalf_of__c;
                }
                
                customerAccInfo.AdditionalInformation = customerObj.crm_AdditionalInformation__c;
                
                //Response object
                postenNoEconnectCreatecustomerparty.CreateCustomerResponseType response=new postenNoEconnectCreatecustomerparty.CreateCustomerResponseType();
                
                //Sending request to CreateCustomerParty
                crm_nps_settings_sales__c nps = crm_nps_settings_sales__c.getValues('eConnect ICC');
                
                postenEconnect.endpoint_x = nps.endpoint_url__c;
                postenEconnect.inputHttpHeaders_x = new Map<String,String>();
                postenEconnect.inputHttpHeaders_x.put('Authorization',createBasicAuthentication(nps.Username__c,nps.Password__c));
                
                //Timeout
                postenEconnect.timeout_x = nps.crm_timeout__c.intValue();
                
                //response
                response=postenEconnect.CreateCustomerParty(orgTypeInfo,customerAccInfo);
                System.debug('------------response'+response);
                if(response.Result.equalsIgnoreCase('F')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, response.CreateException.ExceptionMessage));
                    return null;
                }else if(String.isEmpty(response.Result)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, response.CreateException.ExceptionReason));
                    return null;
                }else if(response.Result.equalsIgnoreCase('E')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Fatal, response.CreateException.ExceptionMessage));
                    return null;
                }else{
                    Accountinfo.crm_Sent_to_CDH__c =  true;
                    Accountinfo.crm_Requested_Credit_Amount__c = acc.crm_Requested_Credit_Amount__c;
                    try{
                        update Accountinfo;
                        insert customerObj;
                    }Catch(Exception e){crm_Exception_handler.createExceptionRecords(e);}
                    
                    return new Pagereference('/'+acc.Id);
                }
            }else{
                if(Accountinfo.crm_Sent_to_CDH__c){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.crm_Prospect_Already_Sent));
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.crm_Mandatory_Fields_Missing));
                }
                return null;
            } 
        }catch(Exception exp){
            String exceptionMessage = NULL;
            System.debug('------------exp'+exp);
            if(exp.getTypeName().containsIgnoreCase('System.CalloutException') && exp.getMessage().containsIgnoreCase('IO Exception: Read timed out'))
            exceptionMessage = Label.crm_Connection_Timeout;
            else if(exp.getTypeName().containsIgnoreCase('System.CalloutException')) exceptionMessage = System.Label.crm_convert_to_customer;
            else exceptionMessage = Label.crm_Processing_Failed;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,exceptionMessage));
            crm_Exception_handler.createExceptionRecordsAnyType(exp,acc.Id);
            upsert customerObj;
            return null;
        }
    } 
    
}