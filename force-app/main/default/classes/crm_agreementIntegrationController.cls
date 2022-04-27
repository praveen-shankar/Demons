/*Author: Rajeev Shekhar*/

public with sharing class crm_agreementIntegrationController implements Queueable, Database.AllowsCallouts {

    //Initializing Variables
    List < String > opportunityIds;
    String actionType = null;
    //PA14012021 String PA_startDate = null; 

    //Constructor
    //Pass List of Opportunity Ids to this class, along with actionType. The valid values for actionType is fetched from Custom setting : environment_settings__c.getValues('AgeementMasterCodes')
    public crm_agreementIntegrationController(List < String > opportunityIds, String actionType) {
        this.opportunityIds = opportunityIds;
        if (String.isNotBlank(actionType)) this.actionType = actionType;
    }

    //Main method
    /*Conditions for the main method to run:
        1.Agreement master interface switch must be set to true
        2.List of OpportunityIds passed to the constructor must not be empty
        3.Opportunity's Account must be converted to use new services
        4.No Old Services should be added to Opportunity
        5.Callout Status field must not be blank and the value must be Callout Pending
        6.Opportunity must be verified by contract management
        7.Opportunity must be Closed Won
    */
    public void execute(QueueableContext context) {
        environment_settings__c env = environment_settings__c.getValues('AgeementMasterInterfaceSwitch');
        if ((env != null && env.value__c == 'true') || Test.isRunningTest()) {
            if (!opportunityIds.isEmpty()) {
                String oppToProcessId = null;
                /********************************Shell agreement Start 17731******************************/
                List<String> listRelationCustomers = new List<String>();
                List<String> setRelationCustomers= new List<String>();
                List <Account> relationAccountList = new List<Account>();
                /********************************Shell agreement Stop***17731***************************/
                oppToProcessId = opportunityIds.get(opportunityIds.size() - 1); //get last element
                system.debug('opportunityIds--else---'+opportunityIds);
                //Copy_Existing_Agreement_in_PE__c Add to query
                Opportunity opp = [Select Id, crm_Parent_Opp__c, RecordType.DeveloperName,Customer_NOs_For_Agreement__c,StageName, crm_Callout_Status__c, IsWon, crm_Verified_by_Contract_Management__c, send_Shell_Agreement__c, crm_Adjustment_Date__c, crm_Agreement__r.crm_Status__c,
                    crm_exceptions_standardPrice__c, crm_Agreement_Start_Date__c, crm_Agreement_End_Date__c, crm_Opp_Service_Family__c, crm_Agreement__c, crm_Agreement__r.crm_Agreement_End_Date__c, crm_Agreement_Interface_TransactionId__c,
                    crm_Opp_Service_Group__c, CurrencyIsoCode, Type, Account.Orga__c,Account.Name, AccountId, crm_Inherited_From__c, crm_Agreement__r.Name, crm_Agreement__r.crm_Agreement_Name__c From Opportunity Where Id =: oppToProcessId
                ];
                Integer oldServicesCount = [Select Count() From OpportunityLineItem Where Product2.crm_New_Service__c = false and OpportunityId =: opp.Id And Product2.crm_Service_Type__c = 'Actual Service'];

                if ((oldServicesCount == 0) && String.isNotBlank(opp.crm_Callout_Status__c) && opp.crm_Callout_Status__c.equalsIgnoreCase('Callout Pending') && opp.crm_Verified_by_Contract_Management__c && opp.IsWon) {
                    List < OpportunityLineItem > oppLineItemsAS = [Select Id, IsPayerReceiverorSender__c,OpportunityId, crm_Product_Name__c, crm_Free_Pickup__c, crm_Max_Weight__c,crm_Min_Weight__c,crm_Passive_return__c ,crm_lineItemsGroupId__c, crm_Price_List_Business_Delivery__c, Product2.crm_Distribution_System_Agreement_Master__c, Product2Id, Product2.Name, crm_Conversion_Factor__c, crm_Direction__c, crm_Discount__c, crm_Local__c, Product2.IsActive,
                        crm_Minimum_Price__c, crm_Minimum_PricePercent__c, crm_Price_Unit__c, crm_Terminals__c, crm_Unit_Price__c, Product2.crm_New_Service__c, crm_Opp_Prod_Type__c, Product2.ProductCode,
                        Product2.crm_global_Service_Area__c, Product2.crm_global_Service_Family__c, Product2.crm_global_Service_Group__c, Product2.crm_Service_Type__c, Product2.crm_ERP_Product_ID__c,
                        crm_Actual_Service__c, crm_Actual_Service__r.crm_ERP_Product_ID__c, crm_Actual_Service__r.Productcode From OpportunityLineItem Where OpportunityId =: opp.Id And Product2.crm_Service_Type__c = 'Actual Service'
                    ];
                    
                    List < OpportunityLineItem > oppLineItemsAdditional = [Select Id, IsPayerReceiverorSender__c,OpportunityId, crm_Product_Name__c, crm_Free_Pickup__c, crm_Max_Weight__c,crm_Min_Weight__c,crm_Passive_return__c ,crm_lineItemsGroupId__c, crm_Price_List_Business_Delivery__c, Product2.crm_Distribution_System_Agreement_Master__c, Product2Id, Product2.Name, crm_Conversion_Factor__c, crm_Direction__c, crm_Discount__c, crm_Local__c, Product2.IsActive,
                        crm_Minimum_Price__c, crm_Minimum_PricePercent__c, crm_Price_Unit__c, crm_Terminals__c, crm_Unit_Price__c, Product2.crm_New_Service__c, crm_Opp_Prod_Type__c, Product2.ProductCode,
                        Product2.crm_global_Service_Area__c, Product2.crm_global_Service_Family__c, Product2.crm_global_Service_Group__c, Product2.crm_Service_Type__c, Product2.crm_ERP_Product_ID__c,
                        crm_Actual_Service__c, crm_Actual_Service__r.crm_ERP_Product_ID__c,  crm_Actual_Service__r.Productcode From OpportunityLineItem Where OpportunityId =: opp.Id And Product2.crm_Service_Type__c IN('VAS', 'Surcharge', 'Value-Added Service')
                    ];

                    Map < String, List < OpportunityLineItem >> oppLineItemMap = new Map < String, List < OpportunityLineItem >> ();
                    System.debug('oppLineItemMap------'+oppLineItemsAdditional);
                    
                    for (OpportunityLineItem ol: oppLineItemsAdditional) {
                        if (String.isNotBlank(ol.crm_Actual_Service__c) && ol.Product2.crm_Service_Type__c != 'Actual Service') {
                            if (!oppLineItemMap.containsKey(ol.crm_lineItemsGroupId__c))
                                oppLineItemMap.put(ol.crm_lineItemsGroupId__c, new List < OpportunityLineItem > {
                                    ol
                                });
                            else
                                oppLineItemMap.get(ol.crm_lineItemsGroupId__c).add(ol);
                        }
                    }
                    System.debug('oppLineItemMap------'+oppLineItemMap);
                    crm_agreementIntegrationServicesWrapper main = new crm_agreementIntegrationServicesWrapper();
                    crm_agreementIntegrationServicesWrapper.cls_agreement oppinfo = new crm_agreementIntegrationServicesWrapper.cls_agreement();
                    crm_agreementIntegrationServicesWrapper.cls_party partyInfo = new crm_agreementIntegrationServicesWrapper.cls_party();
                    List < crm_agreementIntegrationServicesWrapper.cls_services > serviceinfoList = new List < crm_agreementIntegrationServicesWrapper.cls_services > ();
                    List < crm_agreementIntegrationServicesWrapper.cls_customer > custinfoList = new List < crm_agreementIntegrationServicesWrapper.cls_customer > ();
                    System.debug('opp.RecordType.DeveloperName----'+opp.RecordType.DeveloperName);
                    
                    if(opp.RecordType.DeveloperName == 'Small_Pick_Up'){
                        listRelationCustomers  = opp.Customer_NOs_For_Agreement__c.split(';');
                        setRelationCustomers.addAll(listRelationCustomers);
                        system.debug('setRelationCustomers-----'+setRelationCustomers);
                        relationAccountList = [Select Id, Name, crm_Customer_Number__c, crm_Updated_by_CDH__c from Account where ParentId =: opp.AccountId AND crm_Customer_Number__c IN : setRelationCustomers];
                        system.debug('relationAccountList ---iff--'+relationAccountList);
                    }else{
                    
                        relationAccountList = [Select Id, Name, crm_Customer_Number__c, crm_Updated_by_CDH__c from Account where ParentId =: opp.AccountId And RecordType.DeveloperName = 'business_account'];
                        system.debug('relationAccountList --else---'+relationAccountList);
                    }
                    Map < String, String > codeMap = new Map < String, String > ();
                    if (environment_settings__c.getValues('AgeementMasterCodes') != null) {
                        for (String s: environment_settings__c.getValues('AgeementMasterCodes').value__c.split(',')) {
                            codeMap.put(s.substringBefore('='), s.substringAfter('='));
                        }
                    }
                    oppinfo.agreementId = opp.Id;
                    oppinfo.agreementName = opp.crm_Agreement__r.Name;
                    oppinfo.agreementStartDate = formatDate(opp.crm_Agreement_Start_Date__c);  //formatDate
                    oppinfo.agreementEndDate = formatDate(opp.crm_Agreement__r.crm_Agreement_End_Date__c);
                    oppinfo.agreementServiceGroup = opp.crm_Opp_Service_Group__c;
                    oppinfo.agreementServiceFamily = opp.crm_Opp_Service_Family__c;
                    oppinfo.currencyCode = opp.CurrencyIsoCode;
                    oppinfo.agreementType = opp.Type;
                    oppinfo.exceptionsToStandardPriceAdjustment = opp.crm_exceptions_standardPrice__c;
                    oppinfo.exceptionsToStandardPriceAdjustmentDate = formatDate(opp.crm_Adjustment_Date__c);
                    oppinfo.agreementInheritedFrom = opp.crm_Inherited_From__c;
                    oppinfo.agreementStatus = opp.crm_Agreement__r.crm_Status__c;
                    oppinfo.agreementAggregatorId = opp.crm_Agreement__c;
                    /********************************Shell agreement Start********17731**********************
                     if(opp.Send_Shell_Agreement__c && opp.Copy_Existing_Agreement_in_PE__c){
                      oppinfo.copyExistingAgreementInPE = String.valueOf(opp.Copy_Existing_Agreement_in_PE__c);
                    }
                    
                    ********************************Shell agreement Stop**********17731********************/
                    oppinfo.agreementAggregatorName = opp.crm_Agreement__r.crm_Agreement_Name__c;
                    
                    system.debug('actionType - '+actionType);
                    if (String.isBlank(actionType))
                        oppinfo.actionType = codeMap.get(opp.Type.toLowerCase());
                    else
                        oppinfo.actionType = codeMap.get(actionType.toLowerCase());
                    
                    system.debug('oppInfo.actionType - '+oppinfo.actionType);
                    
                    for (Account a: relationAccountList) {
                        crm_agreementIntegrationServicesWrapper.cls_customer custinfo = new crm_agreementIntegrationServicesWrapper.cls_customer();
                        custinfo.customer_number = a.crm_Customer_Number__c;
                        custinfo.customerName = a.Name;
                        if (a.crm_Updated_by_CDH__c) {
                            custinfo.customerSource = 'CDH';
                        } else {
                            custinfo.customerSource = 'NON-CDH';
                        }
                        custinfoList.add(custinfo);
                    }

                    partyInfo.party_Id = opp.Account.Orga__c;
                    partyInfo.party_Name = opp.Account.Name;
                    partyInfo.accounts = custinfoList;

                    oppinfo.party = partyInfo;
                    /********************PA14012021 Start***************/
                   /* List<String> servicesList = New List<String>();
                    for(OpportunityLineItem o : oppLineItemsAS){
                        servicesList.add(o.crm_Product_name__c);
                    }
                    
                    List<Price_Adjustment__c> priceAdList = New List<Price_Adjustment__c>();
                    If(servicesList.size()>0 && actionType == 'priceadjustment'){
                        priceAdList = [Select Id, Adjustment_percent__c, Service__c, Adjustment_Date__c, Rounding_Up__c, Sent_to_price_Engine__c, Callout_Status__c From Price_Adjustment__c
                                       Where opportunity_Id__c =: opp.Id AND service__c IN :servicesList and Verified_by_Contract_Manager__c = true];
                    }
                    Boolean PaDetailsAdded = false;
                    String PriceAdjId = '';*/
                   /********************PA14012021 Stop***************/
                    for (OpportunityLineItem oli: oppLineItemsAS) {
                        crm_agreementIntegrationServicesWrapper.cls_services serviceinfo = new crm_agreementIntegrationServicesWrapper.cls_services();
                        serviceinfo = createServiceInstance(oli);
                        /********************PA14012021 Start***************/
                       /* if(actionType =='priceadjustment'){
                          if(PriceAdList.size()>0){
                            for(Price_Adjustment__c pa : priceAdList){
                                if(pa.service__c == oli.crm_Product_Name__c && !pa.Sent_to_price_Engine__c && pa.Callout_Status__c.equalsIgnoreCase('Callout Pending')){
                                    serviceinfo.standardPriceAdjustment = oli.crm_Discount__c != null ? oli.crm_Discount__c : 0;
                                    serviceinfo.customPriceAdjustment   = pa.Adjustment_percent__c;
                                    //serviceinfo.priceAdjustmentStartDate = String.valueOf(pa.Adjustment_Date__c);
                                    PA_startDate = String.valueOf(pa.Adjustment_Date__c);
                                    oppinfo.priceAdjustmentStartDate = PA_startDate;
                                    serviceinfo.decimalRoundOffPosition = pa.Rounding_Up__c ? 'true' : 'false';
                                    paDetailsAdded = true;
                                    PriceAdjId = pa.Id;
                                }
                            }
                        }
                            if(!paDetailsAdded){
                                continue;
                            }
                        }*/
                        /********************PA14012021 Stop***************/
                        
                        List < crm_agreementIntegrationServicesWrapper.cls_services > additionalServicesList = new List < crm_agreementIntegrationServicesWrapper.cls_services > ();
                        System.debug('oppLineItemMap'+oppLineItemMap.get(oli.crm_lineItemsGroupId__c));
                        if (oppLineItemMap.containsKey(oli.crm_lineItemsGroupId__c)) {
                            for (OpportunityLineItem opl: oppLineItemMap.get(oli.crm_lineItemsGroupId__c)) {
                                crm_agreementIntegrationServicesWrapper.cls_services serviceinfoSurVAS = new crm_agreementIntegrationServicesWrapper.cls_services();
                                serviceinfoSurVAS = createServiceInstance(opl);
                                additionalServicesList.add(serviceinfoSurVAS);
                            }
                        }
                      /********************PA14012021 Start***************/
                      //if(actionType != 'priceadjustment'){
                            serviceinfo.additionalServices = additionalServicesList; //(not part of price adjustment)
                       // }
                        /********************PA14012021 Stop***************/
                        
                        serviceinfoList.add(serviceinfo);
                        
                        /********************PA14012021 Start***************/
                        /*If(PaDetailsAdded){
                           Break; 
                        }*/
                        /********************PA14012021 Stop***************/
                    }
                    
                    if(!opp.Send_Shell_Agreement__c){
                        oppinfo.services = serviceinfoList;
                    }
                    
                    /********************PA14012021 Start***************/
                    
                    /*Price_Adjustment__c PAobj = New Price_Adjustment__c();
                    if(actionType == 'priceadjustment'){
                        PAobj = [Select Id, Callout_Status__c, Sent_to_Price_Engine__c From Price_Adjustment__c Where Id = :PriceAdjId];
                    } */
                    /********************PA14012021 Stop***************/
                    main.agreementInformation = oppinfo;
                    String tId = opp.Id + String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
                   //PA14012021 String PaTranId = PriceAdjId + String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
                    System.debug('JSON BODY'+JSON.serialize(main, true));
                    system.debug('Header - '+String.valueOf(System.now().getTime())+', '+Userinfo.getUserId()+', '+Userinfo.getName()+', '+opp.Id+', '+tid);
                    HttpRequest req = new HttpRequest();
                    req.setBody(JSON.serialize(main, true));
                    req.setEndpoint('callout:crm_Agreement_master_eConnect_endpoint');
                    req.setHeader('TimestampPublish', String.valueOf(System.now().getTime()));
                    req.setHeader('InitiatedById', Userinfo.getUserId());
                    req.setHeader('InitiatedBy', Userinfo.getName());
                    req.setHeader('SourceSystem', 'Salesforce');
                    req.setHeader('agreementId', opp.Id);
                    req.setHeader('TransactionId', tId);
                    req.setHeader('Content-Type', 'application/json;charset=UTF-8'); 
                    req.setMethod('POST');
                    req.setTimeout(20000);

                    Http http = new Http();

                    try {
                        HTTPResponse res = http.send(req);
                        if (res.getStatus() == 'OK' && res.getStatusCode() == 200) {
                            opp.crm_Callout_Status__c = 'Callout Finished';
                            system.debug('##Callout Status'+opp.crm_Callout_Status__c);
                            opp.crm_Agreement_Interface_TransactionId__c = tId;
                            update opp;
                            
                           /********************PA14012021 Start***************/
                            /*if(actionType == 'priceadjustment'){
                            PAobj.Callout_Status__c = 'Callout Finished';
                            PAobj.Sent_to_Price_Engine__c = true;
                            PAobj.Price_Adjustment_Interface_TransactionId__c = PaTranId;
                            update PAobj;
                            }*/
                            /********************PA14012021 Stop***************/
                        } 
                        else if (res.getStatus() != 'OK' && res.getStatusCode() != 200) {
                            system.debug('Not 200 OK');
                            crm_Exception_handler.createNonExceptionRecords(res.getStatus(), res.getStatusCode(), opp.Id, tId, 'Class.crm_agreementIntegrationController');
                            opp.crm_Agreement_Interface_TransactionId__c = tId;
                            update opp;
                            /********************PA14012021 Start***************/
                            /*if(actionType == 'priceadjustment'){
                                PAobj.Price_Adjustment_Interface_TransactionId__c = PaTranId;
                                update PAobj;
                            }*/
                            /********************PA14012021 Stop***************/
                        }
                    }
                    Catch(Exception general) {
                        crm_Exception_handler.createExceptionRecordsAnyType(general, opp.Id);
                        system.debug('Call unsuccessful');
                    }
                }

                //Prepare for next job
                opportunityIds.remove(opportunityIds.size() - 1); //remove last element and send this updated list to next chained job

                if (Test.isRunningTest() == false) {
                    System.enqueueJob(new crm_agreementIntegrationController(opportunityIds, actionType)); //submit next job
                }
            }
        }

    }

    //Create wrapper for Services
    private crm_agreementIntegrationServicesWrapper.cls_services createServiceInstance(OpportunityLineItem oli) {
        System.debug('oli------------------'+oli);
        crm_agreementIntegrationServicesWrapper.cls_services serviceinfo = new crm_agreementIntegrationServicesWrapper.cls_services();
        if (oli.Product2.crm_Service_Type__c == 'Actual Service') {
            serviceinfo.actualServiceId = oli.Product2.crm_ERP_Product_ID__c.split('-')[0];
            System.debug('oli-Actual service-----------------'+serviceinfo.actualServiceId);
            serviceinfo.freePickup = oli.crm_Free_Pickup__c;
        }    
        if (oli.Product2.crm_Service_Type__c == 'Surcharge') {
            serviceinfo.additionalServiceID = oli.Product2.ProductCode;       
            System.debug('oli-additionalServiceID---------------'+serviceinfo.additionalServiceID);

            serviceinfo.relatedActualServiceId = (oli.crm_Actual_Service__r.crm_ERP_Product_ID__c != null) ? (oli.crm_Actual_Service__r.crm_ERP_Product_ID__c.split('-')[0]) : null;
        }
        if (oli.Product2.crm_Service_Type__c == 'Value-Added Service' || oli.Product2.crm_Service_Type__c == 'VAS') {
            serviceinfo.additionalServiceID= oli.Product2.ProductCode;
            System.debug('oli-VAS ---------------'+serviceinfo.additionalServiceID);

            serviceinfo.relatedActualServiceId = (oli.crm_Actual_Service__r.crm_ERP_Product_ID__c != null) ? (oli.crm_Actual_Service__r.crm_ERP_Product_ID__c.split('-')[0]) : null;
        }
               
        serviceinfo.serviceName = oli.Product2.Name;
        serviceinfo.minimumPrice = oli.crm_Minimum_Price__c;
        
        serviceinfo.passiveReturn=oli.crm_Passive_Return__c;
        serviceinfo.conversionFactor = oli.crm_Conversion_Factor__c;
        serviceinfo.direction = oli.crm_Direction__c;
        serviceinfo.serviceType = oli.Product2.crm_Service_Type__c;
        serviceinfo.serviceFamily = oli.Product2.crm_global_Service_Family__c;
        serviceinfo.discountPercentage = oli.crm_Discount__c;
        serviceinfo.discountTypeRegion = oli.crm_Local__c;
        
        if(String.IsNotBlank(oli.crm_Terminals__c)) {
            serviceinfo.direction = oli.crm_Direction__c;
            serviceinfo.terminals = formatTerminals(oli.crm_Terminals__c);
        }
        serviceinfo.unitPrice = oli.crm_Unit_Price__c;
        serviceinfo.fromWeight = oli.crm_Min_Weight__c;
        serviceinfo.toWeight = oli.crm_Max_Weight__c;
        serviceinfo.salesforceLineID = oli.crm_lineItemsGroupId__c; //oli.Id;
        
        if(String.IsNotBlank(oli.IsPayerReceiverorSender__c) && Boolean.valueOf(Label.isPayerReceiverorSenderSwitch)) {
            serviceinfo.isPayerReceiverorSender = oli.IsPayerReceiverorSender__c;
        }   //updated on 14122020
        if (oli.Product2.crm_Service_Type__c == 'Actual Service' && String.isNotBlank(oli.Product2.crm_Distribution_System_Agreement_Master__c)) {
            List < crm_agreementIntegrationServicesWrapper.cls_systems > systems = new List < crm_agreementIntegrationServicesWrapper.cls_systems > ();
            for (Integer i = 0; i < oli.Product2.crm_Distribution_System_Agreement_Master__c.split(';').size(); i++) {
                crm_agreementIntegrationServicesWrapper.cls_systems sys = new crm_agreementIntegrationServicesWrapper.cls_systems();
                sys.distributionSystem = oli.Product2.crm_Distribution_System_Agreement_Master__c.split(';').get(i);
                systems.add(sys);
            }
            serviceinfo.distributionSystems = systems;
            
            
        }
        if (oli.Product2.crm_Service_Type__c == 'Actual Service' && (oli.Product2.crm_ERP_Product_ID__c == '5000-2' || oli.Product2.crm_ERP_Product_ID__c == '5100-2'))
            serviceinfo.priceListForBusinessDelivery = 'Pricelist 2';
        if (oli.Product2.crm_Service_Type__c == 'Actual Service' && (oli.Product2.crm_ERP_Product_ID__c == '5000' || oli.Product2.crm_ERP_Product_ID__c == '5100'))
            serviceinfo.priceListForBusinessDelivery = 'Pricelist 1';    
        return serviceinfo;
    }
    
    String formatDate(Date d) {
        if(d != null)
            return String.valueOf(d.year()) + '-' + String.valueOf(d.month()).leftPad(2, '0') + '-' + String.valueOf(d.day()).leftPad(2, '0');
        else
            return null;    
    }
    
    private String formatTerminals(String terminal) {
        String rval = null;
        if(terminal != null) {            
            Map<String,crm_Agreement_Terminals__c> terminalCodeMap = new Map<String,crm_Agreement_Terminals__c>(crm_Agreement_Terminals__c.getAll());
            List<String> terminalList = terminal.split(';');
            if(terminalList.size() == 1) {
                rval = terminalCodeMap.get(terminalList[0]).crm_Code__c;
            } else if(terminalList.size() > 1) {
                for(String s : terminalList) {
                    rval += ';' + terminalCodeMap.get(s).crm_Code__c;
                }
                rval = rval.removeStart('null');
                rval = rval.removeStart(';');
                rval = rval.removeEnd(';');
            }
        }        
        return rval;
    }
}