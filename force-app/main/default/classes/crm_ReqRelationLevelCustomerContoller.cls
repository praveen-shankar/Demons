public class crm_ReqRelationLevelCustomerContoller
{
    public Account acc{get;set;}
    public crm_Request_RelationCustomer__c customerObj {get;set;}
    Map<String,String> ISOcountryCodeMap;
    public List<SelectOption> options {get;set;}
    public String billingCountry{get;set;}
    public String shippingCountry{get;set;}
    
    public crm_ReqRelationLevelCustomerContoller(ApexPages.StandardController controller) {
        this.acc= (Account)controller.getRecord();
        customerObj  = new crm_Request_RelationCustomer__c ();
        customerObj.crm_AdditionalInformation__c = 'Salesforce contact: '+ UserInfo.getUserEmail();
        ISOcountryCodeMap = new Map<String,String>();
        options = new List<SelectOption>();
        countryList();
    }
    
    //User Authorization
    private String createBasicAuthentication(String username, string password){
        Blob b = Blob.valueOf(username + ':' + password);   
        String encodedValue = EncodingUtil.base64Encode(b);   
        return 'Basic ' + encodedValue;
    }     
    
    //List of countries and respective ISO codes
    public void countryList() {
        List<String> countryNames = new List<String>();
        Map<String,crm_ISO_Country_Codes__c> countriesMap = new Map<String,crm_ISO_Country_Codes__c>();
        
        for(crm_ISO_Country_Codes__c c : crm_ISO_Country_Codes__c.getAll().values()){
            countryNames.add(c.crm_Country__c);
            countriesMap.put(c.crm_Country__c,c); 
        }
        countryNames.sort();
        for(String s : countryNames){
            crm_ISO_Country_Codes__c iso = countriesMap.get(s);
            options.add(new SelectOption(iso.crm_ISO_Country_Code__c,iso.crm_Country__c.capitalize()));
            ISOcountryCodeMap.put(iso.crm_Country__c,iso.crm_ISO_Country_Code__c);
        }
    }
    
    
    public Pagereference requestcustomer()
    {   
        try{
            Account Accountinfo=[Select Name,Orga__c,id,ShippingStreet,BillingCity,BillingState,BillingCountry,ShippingPostalCode,ShippingCity,ShippingState,BillingStreet,BillingPostalCode,ShippingCountry, crm_ISO_Countrycode_for_Customer_Company__c from Account where id=:acc.id];
            if(!String.isEmpty(Accountinfo.crm_ISO_Countrycode_for_Customer_Company__c) && !String.isEmpty(Accountinfo.Name) && !String.isEmpty(Accountinfo.Orga__c)){
                postenNoEconnectCreatecustomerparty.CreateCustomerPartyPort  postenEconnect=new postenNoEconnectCreatecustomerparty.CreateCustomerPartyPort();

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
                orgTypeInfo.CountryCode= ISOcountryCodeMap.get(AccountInfo.crm_ISO_Countrycode_for_Customer_Company__c.toLowerCase());
                orgTypeInfo.RegistrationType = 'SPO';
                
                //Customer Account Info
                postenNoEconnectCreatecustomerparty.CustomerAccountType customerAccInfo=new postenNoEconnectCreatecustomerparty.CustomerAccountType();
                
                //Addresstype- shipping Address
                postenNoEconnectCreatecustomerparty.AddressType Shippingaddress= new postenNoEconnectCreatecustomerparty.AddressType();
                
                //Addresstype- Billing address
                postenNoEconnectCreatecustomerparty.AddressType Billingaddress= new postenNoEconnectCreatecustomerparty.AddressType();
                
                //populate address information for shipping address
                Shippingaddress.AddressLine1 = customerObj.crm_Shipping_Street__c;
                if(customerObj.crm_Shipping_Postal_Code__c!=null)
                    Shippingaddress.PostalCode=customerObj.crm_Shipping_Postal_Code__c;
                Shippingaddress.City=customerObj.crm_Shipping_City__c;
                Shippingaddress.State=customerObj.crm_Shipping_State__c;
                Shippingaddress.County=customerObj.crm_Shipping_Country__c;
                Shippingaddress.CountryCode=shippingCountry;
                Shippingaddress.AddrTYPE='DeliveryAddress';
                
                //populate address information for billing address
                Billingaddress.AddressLine1=customerObj.crm_Billing_Street__c;
                if(customerObj.crm_Billing_Postal_Code__c!=null)
                    Billingaddress.PostalCode=customerObj.crm_Billing_Postal_Code__c;
                Billingaddress.City=customerObj.crm_Billing_City__c;
                Billingaddress.State=customerObj.crm_Billing_State__c;
                Billingaddress.County=customerObj.crm_Billing_Country__c;
                Billingaddress.CountryCode=billingCountry;
                Billingaddress.AddrTYPE='BillingAddress';
                
                //Addresslist holds billing and shipping address
                postenNoEconnectCreatecustomerparty.AddressType[] addressList=new postenNoEconnectCreatecustomerparty.AddressType[]{Shippingaddress,Billingaddress};
                    
                //contactInfo holds the Contact details for the Account
                customerObj.crm_Party_Account_Id__c = Accountinfo.id;
                customerObj.crm_Customer__c = Accountinfo.id;
                
                 //Addresslist holds billing and shipping address
                
                if(Shippingaddress != null)
                    addressList.add(Shippingaddress);
                if(Billingaddress != null)
                    addressList.add(Billingaddress);
                
                //Assigning values to properties of customerAccInfo of type Customer Account Type
                
                customerAccInfo.AccountName=customerObj.Name;
                customerAccInfo.Address=addressList;

                customerAccInfo.CustomerReference = customerObj.crm_InvoiceReference__c;
                
                customerAccInfo.Addressee = customerObj.crm_Addresse__c;
                customerAccInfo.OnBehalfOf = customerObj.crm_OnBehalfOf__c;
                customerAccInfo.AdditionalInformation = customerObj.crm_AdditionalInformation__c;
                
                //Response object
                postenNoEconnectCreatecustomerparty.CreateCustomerResponseType response=new postenNoEconnectCreatecustomerparty.CreateCustomerResponseType();
                
                //Sending request to Create New Relation Level Account
                crm_nps_settings_sales__c nps = crm_nps_settings_sales__c.getValues('eConnect ICC');
                
                postenEconnect.endpoint_x = nps.endpoint_url__c;
                postenEconnect.inputHttpHeaders_x = new Map<String,String>();
                postenEconnect.inputHttpHeaders_x.put('Authorization',createBasicAuthentication(nps.Username__c,nps.Password__c));
                
                //Timeout
                postenEconnect.timeout_x = nps.crm_timeout__c.intValue();
                
                //response
                response=postenEconnect.CreateCustomerParty(orgTypeInfo,customerAccInfo);
                
                System.debug('@@respone++'+response);
                if(response.Result.equalsIgnoreCase('F')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING ,response.CreateException.ExceptionMessage));
                    return null;
                }else if(String.isEmpty(response.Result)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING ,response.CreateException.ExceptionReason));
                    return null;
                }else  if(response.Result.equalsIgnoreCase('E')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, response.CreateException.ExceptionMessage));
                    return null;
                }else{
                    try{
                        insert customerObj;
                    }Catch(Exception e){crm_Exception_handler.createExceptionRecords(e);}
                    return new Pagereference('/'+acc.Id);
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.crm_Request_New_Account_Required_Fields));
                return null;
            }
        }catch(Exception exp){
            System.debug('----------------'+exp);
            String exceptionMessage = NULL;
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