public class crm_OppToPricingToolIntegration Implements Queueable, Database.AllowsCallouts{
    //Variable initiation
    Public Static Boolean firstCall = true;
    public List <String> oppIds;
    public String dmlOperation;
    public List<Opportunity> opportunityList;
    
    //Constructor
    public crm_OppToPricingToolIntegration(List<String> oppIds, String dmlOperation, List<Opportunity> opportunityList){
        this.oppIds = oppIds;
        this.dmlOperation = dmlOperation;
        system.debug('dmlOperation --> '+dmlOperation);
		this.opportunityList = opportunityList;
    }
   
    public void execute(QueueableContext context){
        environment_settings__c integrationSwitch = environment_settings__c.getValues('PricingToolInterfaceSwitch');
        if ((integrationSwitch != null && integrationSwitch.value__c.equalsIgnoreCase('true')) || Test.isRunningTest()) {
            if(!oppIds.isEmpty() && oppIds!=null){
                system.debug('oppIds-->'+oppIds);
            	String oppIdToProcess = oppIds.get(oppIds.size() - 1);
                system.debug('oppIdToProcess-->'+oppIdToProcess);
        		
                Opportunity opp = New Opportunity();
                if(dmlOperation == 'delete'){
                    opp = opportunityList.get(opportunityList.size() - 1);
                    system.debug('opp -->'+opp);
                }
                    else{
                       opp = [Select Id, name, ownerId, owner.Name, owner.email, accountId, account.name, account.Orga__c, account.ShippingCountry, type, CurrencyIsoCode,crm_Opp_Service_Family__c, crm_Opp_Service_Group__c, 
                              createdDate, Pricing_Tool_Callout_Status__c from opportunity where Id= :oppIdToProcess];

                    }
                
        		List<OppToPricingTool_Wrapper.opp_CustomerDetails> opp_CustomerInfo = New List<OppToPricingTool_Wrapper.opp_CustomerDetails>();
                
                if(Opp.Pricing_Tool_Callout_Status__c == 'Callout Pending'){
                    OppToPricingTool_Wrapper.opp_CustomerDetails customerOppInfo = New OppToPricingTool_Wrapper.opp_CustomerDetails();
					
                    String metaCountryCodeWithName = [SELECT MasterLabel, Value__c FROM Country_Code_Name__mdt limit 1].Value__c;
                    system.debug('metaCountryCodeWithName --> '+metaCountryCodeWithName);
                    List<String> countryCodeList = metaCountryCodeWithName.split(',');
                    system.debug('countryCodeList --> '+countryCodeList);

                    Map<String,String> countryCodeMap = New Map<String,String>();
                    if(countryCodeList.size() > 0){
                        for(String str : countryCodeList){
                            String CountryCodeStr = str.substringAfter('=');
                            countryCodeMap.put(CountryCodeStr.substringAfter('=').toLowerCase(),CountryCodeStr.substringBefore('='));
                        }
                    }
                    system.debug('countryCodeMap-->'+countryCodeMap);
                    
                    customerOppInfo.function = dmlOperation;
            		customerOppInfo.partyId = opp.accountId;
            		customerOppInfo.partyName = opp.account.name;
                    customerOppInfo.orgNo = opp.account.Orga__c;
            		customerOppInfo.partyCountry = opp.account.ShippingCountry;
                    String countryId = opp.account.ShippingCountry;
                    system.debug('countryId-->'+countryId);
                    if(countryId!=null && countryId.containsWhiteSpace()){
                        countryId = opp.account.ShippingCountry.remove(' ');
                    }
                    
                    customerOppInfo.partyCountryId = (countryId!=null) ? countryCodeMap.get(countryId.toLowerCase()) : null;
                    system.debug('customerOppInfo.partyCountryId -->'+customerOppInfo.partyCountryId);
            		customerOppInfo.opportunityId = opp.Id;
            		customerOppInfo.opportunityName = opp.Name;
                    customerOppInfo.sellerId = opp.owner.email;
                    customerOppInfo.sellerName = opp.owner.Name;
            		customerOppInfo.oppCurrency = opp.CurrencyIsoCode;
            		customerOppInfo.serviceGroup = opp.crm_Opp_Service_Group__c;
            		customerOppInfo.serviceFamily = opp.crm_Opp_Service_Family__c;
                    
                    DateTime dt = opp.createdDate;
                    Date oppCreatedDate = date.newInstance(dt.year(), dt.month(), dt.day());
                	customerOppInfo.opportunityDate = String.valueOf(oppCreatedDate); 
                	customerOppInfo.opportunityType = opp.Type; 
                                        
                    opp_CustomerInfo.add(customerOppInfo);
                    OppToPricingTool_Wrapper customerDataPayload = New OppToPricingTool_Wrapper();
                    customerDataPayload.CustomerData = opp_CustomerInfo;
                    
                    System.debug('JSON BODY'+JSON.serialize(customerDataPayload, false));
            		HttpRequest req = new HttpRequest();
                    String clientSecret = string.valueOf(SPPIntegrationDetails__c.getValues('SPP_CustomerFetch_ClientSecret').Value__c);
                    String endpointUrl = string.valueOf(SPPIntegrationDetails__c.getValues('PricingTool_EndpointUrl').Value__c);
            		req.setBody(JSON.serialize(customerDataPayload,false));
            		req.setEndpoint(endpointUrl);
                    req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                    req.setHeader('clientSecret', clientSecret);
                    req.setMethod('POST');
                    req.setTimeout(20000);
            	
                    Http http = New Http();
                
                    try{
                        HttpResponse res = Http.send(req);
                        //if(res.getStatusCode()==200 && res.getStatus()=='OK'){
                        if(res.getStatusCode()==200){
                            if(dmlOperation != 'delete'){
                                opp.Pricing_Tool_Callout_Status__c = 'Callout Finished';
                                update opp;
                            }
                            system.debug('Callout Status --> 200 OK');
                            system.debug('res.getStatus() --> '+res.getStatus());
                            system.debug('res.getStatusCode() --> '+res.getStatusCode());
                            system.debug('res.getBody() --> '+res.getBody());
                            system.debug('Pricing_Tool_Callout_Status__c --> '+ opp.Pricing_Tool_Callout_Status__c);
                            
                            system.debug('DeletedOpp --> '+opp);
                        }
                        //else if (res.getStatus() != 'OK' && res.getStatusCode() != 200) 
                        else{
                            crm_Exception_handler.createNonExceptionRecords(res.getStatus(), res.getStatusCode(), opp.Id, null, 'Class.crm_OppToPricingToolIntegration');
                            system.debug('Callout Status --> NOT 200 OK');
                            system.debug('res.getStatus() --> '+res.getStatus());
                            system.debug('res.getStatusCode() --> '+res.getStatusCode());
                            system.debug('res.getBody() --> '+res.getBody());
                        }
                    }
                    catch(Exception e){
                        crm_Exception_handler.createExceptionRecordsAnyType(e, opp.Id);
            			system.debug('Callout Status --> Exception --> Error occured at line '+ e.getLineNumber() + ' with message '+ e.getMessage() + '.' + 'Stack trace - '+ e.getStackTraceString());
                    }
                }
        		
				//Prepare for next job
                oppIds.remove(oppIds.size() - 1); //remove last element and send this updated list to next chained job
                opportunityList.remove(opportunityList.size()-1);

                if (Test.isRunningTest() == false) {
                    System.enqueueJob(new crm_OppToPricingToolIntegration(oppIds, dmlOperation, opportunityList)); //submit next job
                }        	
            }
        } 
    }

}