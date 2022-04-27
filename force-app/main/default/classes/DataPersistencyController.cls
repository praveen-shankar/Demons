// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
global class DataPersistencyController {

    // Variables to hold the values to be later updated to the case for Specific data and dates.
    private static LM_Shipment_Event__c innPost {get; set;}
    private static LM_Shipment_Event__c utlevert {get; set;}
    private static String innPost_PostalUnit {get; set;}
    private static String utlevert_PostalUnit {get; set;}
    private static LM_Shipment_Event__c firstReg {get; set;}        // This will hold the first event details [C-03099]
    private static String firstReg_PostalUnit {get; set;}          // This will hold the Postal unit related to the first event [C-03099]
    public Static String[] InformationType{get;set;}


    @Future(callout=true)
    public static void updateAccount(String accountId) {
        system.debug('Calling DataPersistencyController.updateAccount on account with id ' + accountId);
        Account acct;
        boolean isUpdateSucessfull = false;
        try {
            acct = [SELECT id, crm_Account_Updated__c, crm_Account_Inserted__c, crm_Updated_by_CDH__c, crm_Updated_by_FKB__c, crm_customer_number__c, status_update__c FROM Account WHERE Id = :accountId LIMIT 1];
            if(acct != null && acct.crm_customer_number__c != null && acct.crm_customer_number__c != '') {
                try { 
                // Get forwarding and adress    only - FKB accounts
                /*
                    if( ( acct.crm_Account_Updated__c || acct.crm_Account_Inserted__c || acct.crm_Updated_by_FKB__c  )&& !acct.crm_Updated_by_CDH__c  ) {
                        Boolean sucsess = DataPersistencyController.maintainAdressAndForwarding(acct.crm_customer_number__c);
                        
                        if(sucsess) {
                            isUpdateSucessfull = true;
                            acct.status_update__c = 'Klar for oppdatering';
                        }
                    }   
                    // Only forwardings - CM accounts
                    else */
                    // Below IF part is commented as part of incident E2-IM018151066 and change - E2-C00829358

               /*  if(  acct.crm_Updated_by_CDH__c ) {
                    // Only update forwardings, not the account
                        Boolean sucsess = DataPersistencyController.maintainForwarding(acct.crm_customer_number__c);
                        if(sucsess) {
                            isUpdateSucessfull = true;
                            // CSPhase2 , Dinesh , 28/12/2016
                            // acct.status_update__c = 'Klar for oppdatering';
                            acct.status_update__c = 'Ready for update';
                        }
                    }
                    // Everything - FAR accounts
                    else { */
                    
                   InformationType=new String[]{'CustomerDetails','ForwardingDetails'};
                        Account returnedAccount = DataPersistencyController.maintainAccount(acct.crm_customer_number__c,InformationType);
                        system.debug('Returned Account: ' + returnedAccount);
                        if(returnedAccount != null) {
                            isUpdateSucessfull = true;
                        }
                  //  } 
                    
                
                } catch (Exception ex) {
                    system.debug('Something went wrong in updating the account with id ' + accountId);
                    // CSPhase2 , Dinesh , 28/12/2016
                    // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Kunne ikke oppdatere kunden - ' + ex.getMessage() ));
                    KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error1 + ex.getMessage() ));
                }
            }
            acct = [SELECT id, status_update__c, last_updated__c FROM Account WHERE Id = :accountId LIMIT 1];
            if(!isUpdateSucessfull) {
                // CSPhase2 , Dinesh , 28/12/2016
                // acct.status_update__c = 'Sist oppdatering feilet';
                acct.status_update__c = 'Last update failed';
            }
            KATSutilities.upsertAsSystem(acct);
        } catch(Exception ex) {
            system.debug('Something went wrong in the querying account with id ' + accountId);
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Kunne ikke laste kunden - ' + ex.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error2 + ex.getMessage() ));
        }
    }
    
    
    //call getcusotmer and creates/updates the account with ID accountId and returns the account is persisted
    // If crm_userFARSource__c is true
    public static Account maintainAccount(String partyNumber,String[] InformationTypeParameters) {
        system.debug('Calling DataPersistencyController.maintainAccount with partyNumber: ' + partyNumber);
        Account[] accounts = [SELECT Id,crm_Updated_by_CDH__c FROM Account WHERE crm_Updated_by_CDH__c = true AND crm_Customer_Number__c = :partyNumber AND RecordType.DeveloperName IN ('business_account','person_account')];
        if(!KATSutilities.isEmpty(partyNumber)) {
            try {
                postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
                if(accounts.size() > 0)
                    return maintainAccount(eConnect.getCustomer( null,partyNumber,InformationTypeParameters ));//Added CDHCustomerNumber param in method signature CR 7176 - 10th March 2018
                else
                    return maintainAccount(eConnect.getCustomer( partyNumber,null,InformationTypeParameters ));    
                } 
            //Should get better exception messages!
            catch(CalloutException coe) {
                system.debug('Something went wrong in the eConnect call');
                // CSPhase2 , Dinesh , 28/12/2016
                // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelsen til eConnect ble brutt/nFeilmelding:/n' + coe.getMessage() ));
                   KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error3 + coe.getMessage() ));
            }
            catch(TypeException te) {
                system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
                // CSPhase2 , Dinesh , 28/12/2016
                // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier/nFeilmelding:/n' + te.getMessage() ));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error4 + te.getMessage() ));
            }
            
        }
        system.debug('Missing PartNymber from account');
        // CSPhase2 , Dinesh , 28/12/2016
        // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Aktørnummer på kunde mangler!' ));
        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error5 ));
        return null;
    }
      
      
        public static Boolean maintainForwarding(String partyNumber) {
        system.debug('Calling DataPersistencyController.maintainAccount with partyNumber: ' + partyNumber);
      
            if(!KATSutilities.isEmpty(partyNumber)) {
                    try {
                        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
                        
                        //postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters eConnectResponse = eConnect.getCustomer( partyNumber );
                        InformationType=new String[]{'CustomerDetails','ForwardingDetails'};
                        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectResponse= new postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType();
                        if(test.isrunningTest())
                        {
                             eConnectResponse=mock_Crmgetcustome.getPrivateAccount();
                        }
                        else
                        {
                             eConnectResponse= eConnect.getCustomer(null,partyNumber,InformationType );
                        }
                        if(KATSutilities.isEconnectCustomerOrganization(eConnectResponse)) {
                            postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType data = eConnectResponse.OrganizationParty;
                            Account acct;
                            if(data!=null && data.partyNumber!=null){
                                acct = [SELECT crm_customer_number__c, RecordTypeId, status__c, Name, DUNS_number__c, Orga__c, Phone, BillingCity, BillingCountry, BillingPostalCode, BillingStreet, ShippingCity, ShippingCountry, ShippingPostalCode, ShippingStreet FROM Account WHERE crm_customer_number__c = :PartyNumber LIMIT 1];
                                    //acct = [SELECT id, Name, BillingCity, crm_customer_number__c, RecordTypeId FROM Account WHERE crm_customer_number__c = :PartyNumber LIMIT 1];
                            }
                            
                            if(acct.id != null){
                                if(data.Forwardings != null && data.Forwardings.Forwarding != null) {
                                        DataPersistencyController.maintainForwardingTypes(acct.id, data.Forwardings.Forwarding);
                                }
                                acct = DataPersistencyController.persistAccount(acct);
                            }
                        }
                        
                        
                        return true;
                    }
                    catch(CalloutException coe) {
                            system.debug('Something went wrong in the eConnect call: '+coe.getMessage());
                            // CSPhase2 , Dinesh , 28/12/2016
                            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelsen til eConnect ble brutt/nFeilmelding:/n' + coe.getMessage() ));
                            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error6 + coe.getMessage() ));
                    }
                    catch(TypeException te) {
                            system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
                            // CSPhase2 , Dinesh , 28/12/2016
                            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier/nFeilmelding:/n' + te.getMessage() ));
                            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error7 + te.getMessage() ));
                    }
                    
                }


        system.debug('Missing PartNymber from account');
        // CSPhase2 , Dinesh , 28/12/2016
        // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Aktørnummer på kunde mangler!' ));
        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error8 ));
        return false;
    }

// Method created to handle accounts that only should have their adress from FAR, but no other details
  public static Boolean maintainAdressAndForwarding(String partyNumber) {
        system.debug('Calling DataPersistencyController.maintainAccount with partyNumber: ' + partyNumber);

        if(!KATSutilities.isEmpty(partyNumber)) {
        try {
            postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
            InformationType=new String[]{'ForwardingDetails'};
            
            postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectResponse =new postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType();
            if(test.isrunningTest())
            {eConnectResponse=mock_Crmgetcustome.getBusinessAccount();}
            //else{eConnectResponse=eConnect.getCustomer( partyNumber,InformationType );}
            //postenNoEconnectKatsSakgetcustomer.KATS_SakGetCustomerOutParameters eConnectResponse = eConnect.getCustomer( partyNumber );
            if(KATSutilities.isEconnectCustomerOrganization(eConnectResponse)) {
                postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType data = eConnectResponse.OrganizationParty;
                Account acct;
                if(data!=null && data.partyNumber!=null){
                    acct = [SELECT crm_customer_number__c, RecordTypeId, status__c, Name, DUNS_number__c, Orga__c, Phone, BillingCity, BillingCountry, BillingPostalCode, BillingStreet, ShippingCity, ShippingCountry, ShippingPostalCode, ShippingStreet FROM Account WHERE crm_customer_number__c = :PartyNumber LIMIT 1];
                        //acct = [SELECT id, Name, BillingCity, crm_customer_number__c, RecordTypeId FROM Account WHERE crm_customer_number__c = :PartyNumber LIMIT 1];
                }
                
                if(acct.id != null){
                    if(data.Addresses != null && data.Addresses.Address != null) {
                        DataPersistencyController.setAccountAddress(acct, data.Addresses.Address, false);
                    }
                    if(data.Forwardings != null && data.Forwardings.Forwarding != null) {
                            DataPersistencyController.maintainForwardingTypes(acct.id, data.Forwardings.Forwarding);
                    }
                    acct = DataPersistencyController.persistAccount(acct);
                }
            }
            
            
            return true;
        }
        catch(CalloutException coe) {
                system.debug('Something went wrong in the eConnect call: '+coe.getMessage());
                // CSPhase2 , Dinesh , 28/12/2016
                //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelsen til eConnect ble brutt/nFeilmelding:/n' + coe.getMessage() ));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error6 + coe.getMessage() ));
        }
        catch(TypeException te) {
                system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
                // CSPhase2 , Dinesh , 28/12/2016
                // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier/nFeilmelding:/n' + te.getMessage() ));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error7 + te.getMessage() ));
        }
        
    }
        
        system.debug('Missing PartNymber from account');
        // CSPhase2 , Dinesh , 28/12/2016
        // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Aktørnummer på kunde mangler!' ));
        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error8 ));
        return false;
    }

    //call get customer and creates/updates the account with ID accountId and returns the getCustomer response
    public static postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType maintainAccount(Account acct) {
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectOutParameters=new postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType();
        
        try {
           if(acct.crm_Updated_by_CDH__c)
               eConnectOutParameters = eConnect.getCustomer(null,acct.crm_customer_number__c,InformationType);
           else
               eConnectOutParameters = eConnect.getCustomer(acct.crm_customer_number__c,null,InformationType);
                   
           if(eConnectOutParameters.ServiceException.Error==null && eConnectOutParameters.ServiceException.Error.Size()==0)
           {
            maintainAccount(eConnectOutParameters);
            return eConnectOutParameters;
           }
           else
           {
           CalloutException coe;
           KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error9 + coe.getMessage() ));
           throw coe;
           }
            
        }
        catch(CalloutException coe) {
            system.debug('Something went wrong in the eConnect call');
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelsen til eConnect feilet - ' + coe.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error9 + coe.getMessage() ));
        }
        catch(TypeException te) {
            system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error10 + te.getMessage() ));
        }
        return null;
    }

    //recieves a getcusotmer response and creates/updates the account and returns true if the account is persisted
    public static Account maintainAccount(postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectResponse) {
        if(KATSutilities.isEconnectCustomerOrganization(eConnectResponse)) {
            return maintainOrganizationAccount(eConnectResponse.OrganizationParty);
        } 
        else if(KATSutilities.isEconnectCustomerPrivate(eConnectResponse)) {
            return maintainPrivateAccount(eConnectResponse.PersonParty);
        }
        else {
           // CSPhase2 , Dinesh , 28/12/2016
           // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No data was returned from Econnect:/n' + eConnectResponse));
           KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.cs_DataPersistencyController_error11));
        }
        
        return null;
    }
    
    //recieves getCusotmerOutParameters.organizationType and creates/updates the account and returns the getCustomer response
    public static Account maintainOrganizationAccount(postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType data) {
        system.debug('Calling DataPersistencyController.maintainAccount with KATS_SakCustomerOrganizationType. Data = '+data);    
        
            Account acct = DataPersistencyController.getAccount(data.PartyNumber, false);
            
            DataPersistencyController.populateBusinessAccount(acct, data);
            
            acct = DataPersistencyController.persistAccount(acct);
           
            if(data.Forwardings != null && data.Forwardings.Forwarding != null) {
               DataPersistencyController.maintainForwardingTypes(acct.id, data.Forwardings.Forwarding);
            }
            system.debug('Returning the following account: ' + acct);
            
            return DataPersistencyController.persistAccount(acct);
        
        return null;
    }
    
    public static Account populateBusinessAccount(Account acc, postenNoEconnectAboCrmCrmgetcustome.CustomerOrganizationType data) {
        if(data != null){
            if(String.isNotBlank(data.CDHCustomerNumber)) acc.CDH_customer_number_converted__c = data.CDHCustomerNumber;
            if(String.isNotBlank(data.StatusCode)) {
                acc.status__c = OrganizationStatus(data.StatusCode,data.status);
            } else {
                acc.status__c = 'Blank';
            }
            
             if(String.isNotBlank(data.DigipostID)) {
             if(data.DigipostID =='Y')
                acc.Has_Digipost__c = true;
                else
                {
                acc.Has_Digipost__c = false;
                }
            }
            
            
            if(!KATSutilities.isEmpty(data.LegalName)) {
               acc.Name = data.LegalName;
            }
            
            if(!KATSutilities.isEmpty(data.DUNSNo)) {
                acc.DUNS_number__c = data.DUNSNo;
            }
            
            if(data.FiscalCode != null){
                acc.Orga__c = data.FiscalCode;
            }
            
            if(data.Addresses != null && data.Addresses.Address != null) {
               DataPersistencyController.setAccountAddress(acc, data.Addresses.Address, false);
            }
            
            if(data.Communications != null && data.Communications.Communication != null) {
                for(postenNoEconnectAboCrmCrmgetcustome.CommunicationType communication : data.Communications.Communication) {
                    if(KATSutilities.isEmpty(acc.Phone)) { // Salesforce overstyrer fagsystemet
                        acc.Phone = communication.PhoneNumber;
                    }
                }
            }
            
        }
        return acc;
    }
    
 
    
    //recieves getCusotmerOutParameters.personType and creates/updates the account and returns the getCustomer response
    public static Account maintainPrivateAccount( postenNoEconnectAboCrmCrmgetcustome.CustomerPersonType data) {
        system.debug('Calling DataPersistencyController.maintainPrivateAccount with KATS_SakCustomerPersonType');
        if(data != null) {
            Account acct = getAccount(data.PartyNumber, true);
            
            acct = DataPersistencyController.populatePrivateAccount(acct, data);
            
            DataPersistencyController.persistAccount(acct);
            if(data.Forwardings != null && data.Forwardings.Forwarding != null) {
                DataPersistencyController.maintainForwardingTypes(acct.id, data.Forwardings.Forwarding);
            }
            return DataPersistencyController.persistAccount(acct);
        }
        return null;
    }
    
    public static Account populatePrivateAccount(Account acc, postenNoEconnectAboCrmCrmgetcustome.CustomerPersonType data) {
        if(data != null) {
            if(data.Names != null){
                DataPersistencyController.setNamePrivateAccount(acc, data.names);
            }
             System.debug('@@@data@@'+data );
            if(String.isNotBlank(data.StatusCode)) {
                acc.status__c = PersonStatus(data.StatusCode,data.status);
            } else {
                 acc.status__c = 'Blank';
            }
            
            
             if(String.isNotBlank(data.DigipostID)) {
             if(data.DigipostID =='Y')
                acc.Has_Digipost__c = true;
                else
                {
                acc.Has_Digipost__c = false;
                }
            }
            if(String.isNotBlank(data.CDHCustomerNumber)) acc.CDH_customer_number_converted__c = data.CDHCustomerNumber;
            
            System.debug('@@@AccAddress@@'+data.Addresses );
            if(data.Addresses != null && data.Addresses.Address != null) {
               DataPersistencyController.setAccountAddress(acc, data.Addresses.Address, true);
            }
            
        }
        return acc;
    }
    
    public static void setNamePrivateAccount(Account acc,  postenNoEconnectAboCrmCrmgetcustome.PersonNameType nameType) {
        String firstName = null;
        String lastName = null;
        System.debug('@@@response@@1'+nameType.FirstName);
         System.debug('@@@response@@1'+nameType.MiddleName);
          System.debug('@@@response@@1'+nameType.lastName);
        if(String.isNotBlank(nameType.FirstName))   { 
            firstName = nameType.FirstName.trim();
            }
       
       
        if(String.isNotBlank(nameType.MiddleName))  { 
            firstName = firstName + ' ' + nameType.MiddleName.trim();  
            System.debug('@FirstName@'+firstName );
            }
        
        
        if(String.isBlank(firstName))               { firstName = '<Mangler fornavn>'; }
        if(firstName.length() > 40)                 { firstName = firstName.substring(0,40);}
         System.debug('@FirstName@'+firstName );
        if(String.isNotBlank(nameType.LastName))    { lastName = nameType.LastName.trim();}
        if(String.isBlank(nameType.LastName))       { lastName = '<Mangler etternavn>';}
        if(lastName.length() > 80)                  { lastName = lastName.substring(0,80);}
        System.debug('@LastName@'+lastName );
        acc.FirstName = firstName;
        acc.LastName = lastName;
    }
    
    public static void setAccountAddress(Account acc, list< postenNoEconnectAboCrmCrmgetcustome.AddressType> addressList, boolean isPrivateAccount) {
        Boolean isSetPrivateAddress = false;
        Boolean isBillingAddress = false;
        for(postenNoEconnectAboCrmCrmgetcustome.AddressType address : addressList) {
            system.debug('~~~address.AddrTYPE::'+address.AddrTYPE);
            if(isPrivateAccount == false && address.AddrTYPE == 'BillingAddress') {
             
            acc.BillingStreet='';
                acc.BillingCity = address.CityName;
                acc.BillingCountry = address.CountryCode;
                acc.BillingPostalCode = address.PostalCode;
                if(address.StreetName!=null && address.StreetName!='')
                   acc.BillingStreet= address.StreetName;
                if(address.PostOfficeBox!=null && address.PostOfficeBox!='')
                   acc.BillingStreet+= ' '+address.PostOfficeBox;  
                If(address.BuildingNumber!=null && address.BuildingNumber!='')
                   acc.BillingStreet +=' '+address.BuildingNumber;
                if(address.BuildingName!=null && address.BuildingName!='')
                   acc.BillingStreet+= ' '+address.BuildingName;
                   
                 isBillingAddress = true;
            }
            if(isPrivateAccount == false && address.AddrTYPE== 'DeliveryAddress') {
              
             acc.ShippingStreet='';
                acc.ShippingCity = address.CityName;
                acc.ShippingCountry = address.CountryCode;
                acc.ShippingPostalCode = address.PostalCode;
                If(address.StreetName!=null && address.StreetName!='')
                   acc.ShippingStreet = address.StreetName;
                if(address.PostOfficeBox!=null && address.PostOfficeBox!='')
                   acc.ShippingStreet += ' '+address.PostOfficeBox; 
                If(address.BuildingNumber!=null && address.BuildingNumber!='')
                   acc.ShippingStreet += ' '+address.BuildingNumber;
                if(address.BuildingName!=null && address.BuildingName!='')
                   acc.ShippingStreet += ' '+address.BuildingName;
                  
            }
            
            // CR- 8212 - address type == postal
            
            if(isPrivateAccount == false && address.AddrTYPE == 'PostalAddress' && isBillingAddress == false) {
            system.debug('~~~isBillingAddress ::'+isBillingAddress);
                        
            acc.BillingStreet='';
                acc.BillingCity = address.CityName;
                acc.BillingCountry = address.CountryCode;
                acc.BillingPostalCode = address.PostalCode;
                if(address.StreetName!=null && address.StreetName!='')
                   acc.BillingStreet= address.StreetName;
                if(address.PostOfficeBox!=null && address.PostOfficeBox!='')
                   acc.BillingStreet+= ' '+address.PostOfficeBox;  
                If(address.BuildingNumber!=null && address.BuildingNumber!='')
                   acc.BillingStreet +=' '+address.BuildingNumber;
                if(address.BuildingName!=null && address.BuildingName!='')
                   acc.BillingStreet+= ' '+address.BuildingName;
                  
                 
            }

            
            if(isPrivateAccount == true && address.AddrTYPE == 'PostalAddress' && !isSetPrivateAddress) { 
                // The first XXAD_POST address recieved is the latest/current address (The sorting is done in FOT/FAR before 
                // the list is sent to KATS. The list is sorted by newest start date as the first element.) See POB 6153(KATS)/6907(FOT/FAR)
                isSetPrivateAddress = true;
                
                //BILL to
                acc.BillingStreet='';
                acc.BillingCity = address.CityName;
                acc.BillingCountry = address.CountryCode;
                acc.BillingPostalCode = address.PostalCode;
                If(address.StreetName!=null && address.StreetName!='')
                   acc.BillingStreet = address.StreetName;
                If(address.BuildingNumber!=null && address.BuildingNumber!='')
                   acc.BillingStreet +=' '+ address.BuildingNumber;
                if(address.BuildingName!=null && address.BuildingName!='')
                   acc.BillingStreet += ' '+address.BuildingName;
                if(address.Unit!=null && address.Unit!='')      
                   acc.BillingStreet += ' '+address.Unit;
                if(address.PostOfficeBox!=null && address.PostOfficeBox!='')
                   acc.BillingStreet += ' '+address.PostOfficeBox;   
                
                //SHIP to
                acc.ShippingStreet ='';
                acc.ShippingCity = address.CityName;
                acc.ShippingCountry = address.CountryCode;
                acc.ShippingPostalCode = address.PostalCode;
                 If(address.StreetName!=null && address.StreetName!='')
                   acc.ShippingStreet = address.StreetName;
                If(address.BuildingNumber!=null && address.BuildingNumber!='')
                   acc.ShippingStreet +=' '+  address.BuildingNumber;
                if(address.BuildingName!=null && address.BuildingName!='')
                   acc.ShippingStreet += ' '+address.BuildingName;
                if(address.Unit!=null && address.Unit!='')      
                   acc.ShippingStreet +=' '+address.Unit;
                if(address.PostOfficeBox!=null && address.PostOfficeBox!='')
                   acc.ShippingStreet += ' '+address.PostOfficeBox;
            }
            
            // Fill in other address on account. The address is rendered on the page 
            // Lightuser_CaseDetailView only if shipping street is blank.
            // An asterisk is added on the page address field if the address shown 
            // is other address instead of shipping address.
            if(acc.ShippingStreet!=null){ // Kan fjernes om begge felt skal stå i layout
                acc.other_adress__c=acc.ShippingStreet + '\r\n '+ acc.ShippingPostalCode + '\r\n' + acc.ShippingCity + '\r\n' + acc.ShippingCountry;
            } else if(address.AddrTYPE =='PostalAddress' && (address.BuildingNumber!=null || address.BuildingName!=null || address.PostOfficeBox!=null)){
                    acc.other_adress__c= constructOtherAddress(address);
                
            }  else if(address.AddrTYPE =='VisitAddress' && (address.BuildingNumber!=null || address.BuildingName!=null || address.PostOfficeBox!=null) ){
                    acc.other_adress__c= constructOtherAddress(address);
                
            } else if(address.AddrTYPE =='BillingAddress' && (address.BuildingNumber!=null || address.BuildingName!=null || address.PostOfficeBox!=null) ){
                    acc.other_adress__c= constructOtherAddress(address);
                    
            }        
        }
    }
    private static String constructOtherAddress(postenNoEconnectAboCrmCrmgetcustome.AddressType address){
        return address.BuildingNumber+'\r\n'+address.BuildingName+'\r\n'+address.PostOfficeBox+'\r\n '+ address.PostalCode + '\r\n' + address.CityName + '\r\n' + address.CountryCode;
    }
    // Checks if the account exist in SF
    public static Account getAccount(String partyNumber, boolean isPrivateAccount) {
        Account acct;
        try {
            if(isPrivateAccount) {
                acct = [SELECT id, CDH_customer_number_converted__c,FirstName, LastName, BillingCity, crm_customer_number__c, RecordTypeId FROM Account WHERE crm_customer_number__c = :PartyNumber LIMIT 1];
            } else {
                acct = [SELECT crm_customer_number__c,CDH_customer_number_converted__c, RecordTypeId, status__c, Name, DUNS_number__c, Orga__c, Phone, BillingCity, BillingCountry, BillingPostalCode, BillingStreet, ShippingCity, ShippingCountry, ShippingPostalCode, ShippingStreet FROM Account WHERE crm_customer_number__c = :PartyNumber LIMIT 1];
                //acct = [SELECT id, Name, BillingCity, crm_customer_number__c, RecordTypeId FROM Account WHERE crm_customer_number__c = :PartyNumber LIMIT 1];
            }
            return acct;
        } catch(Exception e) {
            system.debug('Account doesn\'t exist in sf');
        }
        if(isPrivateAccount) {
            // CSPhase2 , Dinesh , 28/12/2016
            // return KATSutilities.upsertAsSystem(new Account(LastName = '_', crm_customer_number__c = partyNumber, status_update__c = 'Aldri oppdatert'));
            return KATSutilities.upsertAsSystem(new Account(LastName = '_', crm_customer_number__c = partyNumber, status_update__c = 'never updated'));
        }
        if(!isPrivateAccount) {
            // CSPhase2 , Dinesh , 28/12/2016
            // return KATSutilities.upsertAsSystem(new Account(Name = '_', crm_customer_number__c = partyNumber, status_update__c = 'Aldri oppdatert'));
            return KATSutilities.upsertAsSystem(new Account(Name = '_', crm_customer_number__c = partyNumber, status_update__c = 'never updated'));
        }
        return null;
    }
    
    //saves/updates the account returns true if the operation is successfull
    public static Account persistAccount(Account acct) {
        system.debug('Calling DataPersistencyController.persistAccount with account ' + acct);
        
        // CSPhase2 , Dinesh , 28/12/2016
        // acct.status_update__c = 'Klar for oppdatering';
        acct.status_update__c = 'Ready for update';
        acct.last_updated__c = DateTime.now();
        
        KATSutilities.upsertAsSystem(acct);
        return acct;
    }
    
    public static ForwardingAddressChange__c populateForwardingType(postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwardingType, Id accountId) {
        ForwardingAddressChange__c ft = new ForwardingAddressChange__c();
        if(String.isNotBlank(forwardingType.ForwardingNumber)) { ft.Name = forwardingType.ForwardingNumber;}
        if(String.isNotBlank(forwardingType.ForwardingNumber)) { ft.number__c = forwardingType.ForwardingNumber;}
        if(String.isNotBlank(forwardingType.ReferenceOMA)) { ft.referenceOMA__c = forwardingType.ReferenceOMA;}
        if(String.isNotBlank(forwardingType.Type_x)) { ft.type__c = forwardingType.Type_x;}
        if(String.isNotBlank(forwardingType.Source)) { ft.source__c = forwardingType.Source;}
        if(String.isNotBlank(forwardingType.OEBSURI)) { ft.oebsuri__c = forwardingType.OEBSURI;}
        if(forwardingType.StartDate != null) { ft.startDate__c = forwardingType.StartDate;}
        if(forwardingType.EndDate != null) { ft.endDate__c = forwardingType.EndDate;}
        if(forwardingType.HoldDate != null) { ft.holdDate__c = forwardingType.HoldDate;}
        system.debug('ToAddress: '+forwardingType.ToAddress);
        system.debug('FromAddress: '+forwardingType.FromAddress);
        
        if(forwardingType.ToAddress != null) {
        //remaing addressline fields should be added, lenght on forwarding address is 100 char restricted
            if(String.isNotBlank(forwardingType.ToAddress.StreetName)) { ft.toStreet__c = forwardingType.ToAddress.StreetName;}
           
            if(String.isNotBlank(forwardingType.ToAddress.BuildingNumber)) { ft.toStreet__c +=' '+ forwardingType.ToAddress.BuildingNumber;}
            if(String.isNotBlank(forwardingType.ToAddress.BuildingName)) { ft.toStreet__c +=','+ forwardingType.ToAddress.BuildingName;}
            if(String.isNotBlank(forwardingType.ToAddress.PostalCode)) { ft.toPostalCode__c = forwardingType.ToAddress.PostalCode;}
            if(String.isNotBlank(forwardingType.ToAddress.CityName)) { ft.toCity__c = forwardingType.ToAddress.CityName;}
        }
        if(forwardingType.FromAddress != null) {
        //remaing addressline fields should be added, lenght on forwarding address is 100 char restricted
           if(String.isNotBlank(forwardingType.FromAddress.StreetName)) { ft.fromStreet__c = forwardingType.FromAddress.StreetName;}
            if(String.isNotBlank(forwardingType.FromAddress.BuildingNumber)) { ft.fromStreet__c +=' '+ forwardingType.FromAddress.BuildingNumber;}
            
            if(String.isNotBlank(forwardingType.FromAddress.BuildingName)) { ft.fromStreet__c +=','+ forwardingType.FromAddress.BuildingName;}
            if(String.isNotBlank(forwardingType.FromAddress.PostalCode)) { ft.fromPostalCode__c = forwardingType.FromAddress.PostalCode;}
            if(String.isNotBlank(forwardingType.FromAddress.CityName)) { ft.fromCity__c = forwardingType.FromAddress.CityName;}
        }
        
        ft.account__c = accountId;
        
        return ft;
    }
    
    public static ForwardingPerson__c populateForwardingPerson(postenNoEconnectAboCrmCrmgetcustome.PersonNameType forwardingPerson) {
        ForwardingPerson__c fp = new ForwardingPerson__c();
        if(String.isNotBlank(forwardingPerson.FirstName)) { fp.firstName__c = forwardingPerson.FirstName; }
        if(String.isNotBlank(forwardingPerson.MiddleName)) { fp.middleName__c = forwardingPerson.MiddleName; }
        if(String.isNotBlank(forwardingPerson.LastName)) { fp.lastName__c = forwardingPerson.LastName; }
        fp.name = fp.firstName__c + ' ' + fp.lastName__c;
        
        return fp;
    }
     
    public static list<ForwardingPerson__c> connectForwardingPersonMapToForwardingTypeList(map<string, list<ForwardingPerson__c>> personToConnectMap, list<ForwardingAddressChange__c> forwardingList) {
        list<ForwardingPerson__c> personsToUpsert = new list<ForwardingPerson__c>();
        for(ForwardingAddressChange__c fac : forwardingList) {
            if(personToConnectMap.containsKey(fac.number__c)) {
                for(ForwardingPerson__c p : personToConnectMap.get(fac.number__C)) {
                    p.forwardingAddress__c = fac.id;
                    personsToUpsert.add(p);
                }
            }
        }
        
        upsert personsToUpsert;
        
        return personsToUpsert;
    }
    
    //Requires upto 3 SOQL statements per run
    public static list<ForwardingAddressChange__c> maintainForwardingTypes(Id accountId, List<postenNoEconnectAboCrmCrmgetcustome.ForwardingType> forwardings) {
        list<ForwardingAddressChange__c> forwardingsToUpsert = new list<ForwardingAddressChange__c>();
        list<ForwardingPerson__c> personsToDelete = new list<ForwardingPerson__c>();
        
        map<string, list<ForwardingPerson__c>> personsToAdd = new map<string, list<ForwardingPerson__c>>();
        
        for(postenNoEconnectAboCrmCrmgetcustome.ForwardingType forwarding : forwardings) {
            ForwardingAddressChange__c forwardingType = DataPersistencyController.populateForwardingType(forwarding, accountId);
            forwardingsToUpsert.add(forwardingType);
            
            //Add persons to the forwarding address
            if(forwarding.OtherParties != null && forwarding.OtherParties.party != null) {
                list<ForwardingPerson__c> persons = new list<ForwardingPerson__c>();
                for(postenNoEconnectAboCrmCrmgetcustome.PersonNameType person : forwarding.OtherParties.party) {
                    persons.add(DataPersistencyController.populateForwardingPerson(person));
                }
                personsToAdd.put(forwardingType.number__c, persons);
            }
        }
        
        Database.Upsert(forwardingsToUpsert, ForwardingAddressChange__c.number__c);
        
        personsToDelete = [SELECT id FROM ForwardingPerson__c WHERE forwardingAddress__c in :forwardingsToUpsert];
        if(personsToDelete.size() > 0) {
            delete personsToDelete;
        }
        
        
        
        if(personsToAdd.size() > 0) {
            DataPersistencyController.connectForwardingPersonMapToForwardingTypeList(personsToAdd, forwardingsToUpsert);
        }
        return forwardingsToUpsert;
     }
    
  
   
  
    
    public static String validateEmail(String email) {
        
        if(email.contains('mailto:')) {
            email = email.substring(7, email.length());
        }
        while(email.trim().endsWith('.') || email.trim().endsWith(',')) {
                if(email.trim().endsWith('.')) {
                    email=email.trim().substring(0, email.trim().lastIndexOf('.'));
                } else {
                    email=email.trim().substring(0, email.trim().lastIndexOf(','));
                }
        }
        email = email.trim();
        if(KATSutilities.isValidEmail(email)) {
            return email;
        }
        return null;
    }
    
    public static boolean maintainShipmentOnRegisteredCase(Case c) {
        system.debug('START - DataPersistencyController - maintainShipmentOnRegisteredCase(Case)');
        try {
            c = [SELECT id, Shipment_identification__c, CaseNumber, Type__c FROM Case WHERE Id = :c.id LIMIT 1];
            System.debug('~~case'+c);
            String shipmentUnitID = c.Shipment_identification__c;
            postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
            postenNoEconnectKatsGetshipment.ShipmentUnitType data = eConnect.getShipment( ShipmentUnitID );
            System.debug('~~data'+data);
            
            system.debug('END - DataPersistencyController - maintainShipmentOnRegisteredCase(Case)');
            return maintainShipmentOnRegisteredCase(data, c);
            
        } catch(CalloutException coe) {
            system.debug('Something went wrong in the eConnect call');
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelse til eConnect feilet - ' + coe.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error12 + coe.getMessage() ));
        } catch(TypeException te) {
            system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error13 + te.getMessage() ));
        }
        system.debug('END - DataPersistencyController - maintainShipmentOnRegisteredCase(Case)');
        return false;
    }


    public static boolean maintainShipmentOnRegisteredCase(postenNoEconnectKatsGetshipment.ShipmentUnitType data, Case c)
    {
        return maintainShipmentOnRegisteredCase(data,c,false);
    }

    public static boolean maintainShipmentOnRegisteredCase(postenNoEconnectKatsGetshipment.ShipmentUnitType data, Case c, Boolean noCaseCommit) 
    {
        system.debug('START - DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case)');
        
        try {
            if (!KATSUtilities.isEmpty(c.Id)){
                c = [SELECT id, Shipment_identification__c, CaseNumber, Shipment_number__c,Type__c FROM Case WHERE Id = :c.id LIMIT 1];
                                
            }
            if(data != null)
            {
                //c.Produkt__c = data.ProductName;
                c.LM_Product_Code__c = data.ProductCode;

                if (c.Shipment_identification__c != null)
                {   
                    c.Shipment_number__c = data.ShipmentID;
                    c.Shipment_identification__c = data.ShipmentUnitID;
                }
                
                if (c.Shipment_number__c != null)
                {                   
                    c.Shipment_identification__c = data.ShipmentUnitID; 
                    c.Shipment_number__c = data.ShipmentID;
                }    
                
                if(data.SenderReference == null)
                {
                    c.LM_sender_reference__c = '';
                }
                else{
                    c.LM_sender_reference__c = data.SenderReference;
                }
                                              
                if(data.PostingTerminal != null && data.PostingTerminal.UnitNumber != null && data.PostingTerminal.UnitNumber != '')
                {
                    system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - PostingTerminal - ' + data.PostingTerminal);
                    try {
                        c.Submission_place__c = [SELECT id FROM PostalUnit__c WHERE unit_number__c = :data.PostingTerminal.UnitNumber LIMIT 1].id;
                    } catch(QueryException qe) {
                        system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - Something went wrong when performing a query for postal unit: ' + qe.getMessage() );
                        // CSPhase2 , Dinesh , 28/12/2016
                        // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Kunne ikke finne enhet med enhetsnummer: ' + data.PostingTerminal.UnitNumber + ', innleveringssted er derfor ikke fylt ut - ' + qe.getMessage() ));
                        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error14a + data.PostingTerminal.UnitNumber + System.Label.cs_DataPersistencyController_error14b + qe.getMessage() ));
                    }
                }
                
                if(data.ShipmentDescription != null) {
                    system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - ShipmentDescription - ' + data.ShipmentDescription);
                    if(!(data.ShipmentDescription.WeightMeasure == null)) { c.Vekt_pr_sending__c = (Decimal.valueOf(data.ShipmentDescription.WeightMeasure)/1000); } else { c.Vekt_pr_sending__c = 0.0; }
                    if(!(data.ShipmentDescription.Description == null)) { c.LM_Product_description__c = data.ShipmentDescription.Description; }
                }
                
                if(data.CurrentCity != null)
                {
                    system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - Gjeldende  - ' + data.CurrentCity);
                    if(!(data.CurrentCity.Country == null)) { c.LM_current_country__c = data.CurrentCity.Country; }
                    if(!(data.CurrentCity.CountryCode == null)) { c.LM_current_country_code__c = data.CurrentCity.CountryCode; }
                    if(!(data.CurrentCity.City == null)) { c.LM_current_postal_address__c = data.CurrentCity.City; }
                    if(!(data.CurrentCity.PostalCode == null)) { c.LM_current_zip_code__c = data.CurrentCity.PostalCode; }
                }

                if(data.ShipToAddress != null) 
                {
                    system.debug('data.ShipToAddress.Street ' + data.ShipToAddress.Street);
                    // If LM has information about the reciever delivery address, this information should not be overwritten elsewhere in the code.
                    // The checkbox hidden_is_package_with_edi__c-field is set to true so that triggers/classes will not overwrite information.
                    // To set another receiver address the user must do so manually.
                    if(!(data.ShipToAddress.Street == null) && !(data.ShipToAddress.Street == '')){
                        c.hidden_is_package_with_edi__c = true;
                        c.reciever_address__c = data.ShipToAddress.Street;
                        if(!(data.ShipToAddress.Country == null)) { c.reciever_country__c = data.ShipToAddress.Country; }
                        if(!(data.ShipToAddress.CountryCode == null)) { c.Reciever_CountryCode__c = data.ShipToAddress.CountryCode; }
                        if(!(data.ShipToAddress.City == null)) { c.reciever_postal_address__c = data.ShipToAddress.City; }
                        if(!(data.ShipToAddress.PostalCode == null)) { c.reciever_zip_code__c = data.ShipToAddress.PostalCode; }
                    }
                }
                                
                if(data.Sender != null) {
                    system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - Sender - ' + data.Sender);
                    if(!(data.Sender.FullName == null)) { c.shipper_name__c = data.Sender.FullName; }
                    if(!(data.Sender.Street == null)) { c.shipper_address__c = data.Sender.Street; }
                    if(!(data.Sender.City == null)) { c.shipper_postal_address__c = data.Sender.City; }
                    if(!(data.Sender.PostalCode == null)) { c.shipper_zip_code__c = data.Sender.PostalCode; }
                    if(!(data.Sender.Country == null)) { c.shipper_country__c = data.Sender.Country; }
                    if(!(data.Sender.CountryCode == null)) { c.Shipper_CountryCode__c = data.Sender.CountryCode; }
                }
                
                if(data.Recipient != null) {
                    system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - Recipient - ' + data.Recipient);
                    if(!(data.Recipient.FullName == null)) { c.reciever_name__c = data.Recipient.FullName; }
                    if(!c.hidden_is_package_with_edi__c){ // Checks if LM has delivery information on the package.
                        if(!(data.Recipient.Street == null)) { c.reciever_address__c = data.Recipient.Street; }
                        if(!(data.Recipient.City == null)) { c.reciever_postal_address__c = data.Recipient.City; }
                        if(!(data.Recipient.PostalCode == null)) { c.reciever_zip_code__c = data.Recipient.PostalCode; }
                        if(!(data.Recipient.Country == null)) { c.reciever_country__c = data.Recipient.Country; }
                        if(!(data.Recipient.CountryCode == null)) { c.Reciever_CountryCode__c = data.Recipient.CountryCode;}
                    }
                }
                
                if(data.ValueAddedServices != null && data.ValueAddedServices.ValueAddedService != null) {
                    system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - ValueAddedServices - ' + data.ValueAddedServices);
                    for(postenNoEconnectKatsGetshipment.ValueAddedService vas : data.ValueAddedServices.ValueAddedService) {
                        if(!(vas.ServiceName == null)) {
                            if(c.Value_added_services__c != null) {
                                c.Value_added_services__c += vas.ServiceName + ';';
                            } else {
                                c.Value_added_services__c = vas.ServiceName + ';';
                            }
                        }
                        if(!(vas.BankAccountNumber == null || vas.BankAccountNumber == '')) { 
                            c.Value_added_services_account__c = vas.BankAccountNumber; 
                        }
                    }
                    c.PO_Amount__c = retrievePostalOrderAmount(data.ValueAddedServices.ValueAddedService);
                }
                
                if(data.Events != null && data.Events.Event != null) 
                {
                    system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - Events - ' + data.Events);
                    
                    if(noCaseCommit == false)
                    {
                        maintainShipmentEvent(c, data.Events.Event);
                    }

                    // Setting the values for Innlevert Postkontor
                    if(innPost != null)
                    {
                        c.Submission_date__c = innPost.date__c.date();
                        c.Delivery_place__c = innPost_PostalUnit;
                    }

                    // Setting the latest value of Utlevert
                    if(utlevert != null)
                    {
                        c.Date_recieved__c = utlevert.date__c.date();
                        c.Place_recieved__c = utlevert_PostalUnit;
                    }

                    // Setting the First Registered Event Details
                    if(firstReg != null)
                    {
                        if(!String.isEmpty(firstReg.Name))
                        {
                            c.LM_FirstReg_PostalUnit__c = firstReg_PostalUnit;
                            c.LM_FirstReg_Event__c = firstReg.Name;
                            c.LM_FirstReg_EventDate__c = firstReg.date__c.date();
                        }
                    }
                }
            }
            
            // CSPhase2 , Dinesh , 28/12/2016
            // c.shipment_event_status__c = 'Klar for oppdatering';
            c.shipment_event_status__c = 'Ready for update';
            c.shipment_last_updated__c = DateTime.now();
            
            if(noCaseCommit == false)
            {
                upsert c;    
            }
            
            system.debug('END - DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - TRUE');
            return true;
        } catch(CalloutException coe) {
            system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - Something went wrong in the eConnect call');
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelse til eConnect feilet - ' + coe.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error15 + coe.getMessage() ));
        }
        catch(TypeException te) {
            system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - Something went wrong when preparing the eConnect call: ' + te.getMessage() );
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error16 + te.getMessage() ));
        }
        catch(DmlException de) {
            system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - Something went wrong when persisting the shipment : ' + de.getMessage() );
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil under lagring av informasjon fra LM - ' + de.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error17 + de.getMessage() ));
        }
        
        try {
            c.shipment_event_status__c = 'Sist oppdatering feilet';
            c.shipment_last_updated__c = DateTime.now();
            upsert c;
        } catch (Exception ex) {
            system.debug('DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - Something went wrong when persisting the case : ' + c.CaseNumber + ' - ' + ex.getMessage() );
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil under lagring av saken - ' + ex.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error18 + ex.getMessage() ));
        }
        system.debug('END - DataPersistencyController - maintainShipmentOnRegisteredCase(ShipmentUnitType, Case) - FALSE');
        return false;
    }
    

    
    
    
    
     public static boolean maintainShipmentSender(postenNoEconnectKatsGetshipment.ShipmentUnitType data, Case c) {
        system.debug('-');
        
        if( data!=null){
            if(data.Sender != null && data.Sender.PartyNumber!=null ) {
                List<Account> accounts = [SELECT id, crm_customer_number__c from Account where crm_customer_number__c=:data.Sender.PartyNumber limit 1];
                 system.debug('-'+data.Sender.PartyNumber);
                if(accounts.size()==1){
                    c.AccountId=accounts.get(0).id;
                     upsert c;
                } else if(accounts.size()==0){
                    // Do callout
                    Account a;
                    a=DataPersistencyController.maintainAccount(data.Sender.PartyNumber,InformationType);
                    if(a!=null){
                        c.Account=a;
                         upsert c;
                    } else{
                        // CSPhase2 , Dinesh , 28/12/20
                        // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Fant ingen kunde med aktørnr: '+data.Recipient.PartyNumber));
                        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.cs_DataPersistencyController_error19 +data.Recipient.PartyNumber));
                    }
                }
            }
            else{
                         // CSPhase2 , Dinesh , 28/12/20
                         // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Fant ingen kunde med aktørnr: '+data.Recipient.PartyNumber));
                         KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.cs_DataPersistencyController_error20 +data.Recipient.PartyNumber));
                    }
        }
       
        return false;
    }
    
     public static boolean maintainShipmentSender(Case c) {
        system.debug('START - DataPersistencyController - maintainShipmentOnRegisteredCase(Case)');
        try {
            c = [SELECT id, Shipment_identification__c, CaseNumber, Type__c FROM Case WHERE Id = :c.id LIMIT 1];
            String shipmentUnitID = c.Shipment_identification__c;
            postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
            postenNoEconnectKatsGetshipment.ShipmentUnitType data = eConnect.getShipment( ShipmentUnitID );
            
            system.debug('END - DataPersistencyController - maintainShipmentOnRegisteredCase(Case)');
            return maintainShipmentSender(data, c);
            
        } catch(CalloutException coe) {
            system.debug('Something went wrong in the eConnect call');
            // CSPhase2 , Dinesh , 28/12/201
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelse til eConnect feilet - ' + coe.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error21  + coe.getMessage() ));
        } catch(TypeException te) {
            system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
            // CSPhase2 , Dinesh , 28/12/201
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error22 + te.getMessage() ));
        }
        system.debug('END - DataPersistencyController - maintainShipmentOnRegisteredCase(Case)');
        return false;
    }
    
    
    
     public static boolean maintainShipmentReciever(postenNoEconnectKatsGetshipment.ShipmentUnitType data, Case c) {
        system.debug('-');
        system.debug(data.Recipient.PartyNumber);
        if( data!=null){
            if(data.Recipient != null && data.Recipient.PartyNumber!=null ) {
                List<Account> accounts = [SELECT id, crm_customer_number__c from Account where crm_customer_number__c=:data.Recipient.PartyNumber limit 1];
                if(accounts.size()==1){
                    c.AccountId=accounts.get(0).id;
                      upsert c;
                } else if(accounts.size()==0){
                    // Do callout
                    Account a;
                    a=DataPersistencyController.maintainAccount(data.Recipient.PartyNumber,InformationType);
                    System.debug(a);
                    if(a!=null){
                        c.Account=a;
                         upsert c;
                    } else{
                         // CSPhase2 , Dinesh , 28/12/2016
                         // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Fant ingen kunde med aktørnr: '+data.Recipient.PartyNumber));
                         KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.cs_DataPersistencyController_error23 +data.Recipient.PartyNumber));
                    }
                }
            }else{
                         // CSPhase2 , Dinesh , 28/12/2016
                         // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Fant ingen kunde med aktørnr: '+data.Recipient.PartyNumber));
                         KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.cs_DataPersistencyController_error24 +data.Recipient.PartyNumber));
                    }
        }
      
        return false;
    }
    public static boolean maintainShipmentReciever(Case c) {
        system.debug('START - DataPersistencyController - maintainShipmentOnRegisteredCase(Case)');
        try {
            c = [SELECT id, Shipment_identification__c, CaseNumber, Type__c FROM Case WHERE Id = :c.id LIMIT 1];
            String shipmentUnitID = c.Shipment_identification__c;
            postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
            postenNoEconnectKatsGetshipment.ShipmentUnitType data = eConnect.getShipment( ShipmentUnitID );
            
            system.debug('END - DataPersistencyController - maintainShipmentOnRegisteredCase(Case)');
            return maintainShipmentReciever(data, c);
            
        } catch(CalloutException coe) {
            system.debug('Something went wrong in the eConnect call');
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelse til eConnect feilet - ' + coe.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error25 + coe.getMessage() ));
        } catch(TypeException te) {
            system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error26 + te.getMessage() ));
        }
        system.debug('END - DataPersistencyController - maintainShipmentOnRegisteredCase(Case)');
        return false;
    }
    
    
    public static void maintainShipmentEvent(Case c, List<postenNoEconnectKatsGetshipment.ShipmentEventType> events)
    {
        innPost = null;
        utlevert = null;
        innPost_PostalUnit = '';
        utlevert_PostalUnit = '';

        // Setting initial values [C-03099]
        firstReg = new LM_Shipment_Event__c();
        firstReg_PostalUnit = '';

        if(events != null)
        {
            List<LM_Shipment_Event__c> oldEvents;
            try
            {
                oldEvents = [SELECT date__c, EventCode__c FROM LM_Shipment_Event__c WHERE case__c = :c.Id];
            }
            catch (Exception ex) 
            {
                oldEvents = new List<LM_Shipment_Event__c>();
            }
            
            List<LM_Shipment_Event__c> newEvents = new List<LM_Shipment_Event__c>();
            try 
            {
                for(postenNoEconnectKatsGetshipment.ShipmentEventType e : events) 
                {
                    // Following code will pickup the first Event registered and save it under the variable: firstReg
                    if(String.isEmpty(firstReg.Name))
                    {
                        firstReg.Name = e.EventName;
                        firstReg.date__c = e.Date_x;
                        firstReg_PostalUnit = e.UnitNumber;
                    }
                    else
                    {
                        Datetime temp = e.Date_x;

                        if(firstReg.date__c < temp)
                        {
                            firstReg.Name = e.EventName;
                            firstReg.date__c = e.Date_x;
                            firstReg_PostalUnit = e.UnitNumber;
                        }
                    }

                    if(e.EventCode == 'Q' || e.EventCode == 'I' || e.EventCode == 'P' || e.EventCode == 'R')
                    {
                        
                        LM_Shipment_Event__c newEvent = new LM_Shipment_Event__c();
                        newEvent.Name = e.EventName;
                        newEvent.Case__c = c.Id;
                        newEvent.date__c = e.Date_x;
                        newEvent.EventCode__c = e.EventName;
                        
                        if(e.EventCode == 'Q')
                        {
                        c.Shelf_Id__c =e.ShelfID;
                        }
                        
                        try 
                        {
                            newEvent.PostalUnit__c = [SELECT Id, Name FROM PostalUnit__c WHERE name = :e.UnitNumber LIMIT 1].Id;
                        } 
                        catch (Exception ex) 
                        {
                            system.debug('DataPersistencyController - maintainShipmentEvent - Something went wrong when retrieving postal unit: ' + ex.getMessage() );
                            // CSPhase2 , Dinesh , 28/12/2016
                            // KATSutilities.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil oppstått under lagring av sendingshendelse, ' + e.EventName + '. Kunne ikke finne Enhet med enhetsnummer: ' + e.UnitNumber + ' - '  + ex.getMessage() ));
                            KATSutilities.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error27a + e.EventName + System.Label.cs_DataPersistencyController_error27b + e.UnitNumber + ' - '  + ex.getMessage() ));
                        }
                        newEvent.ReceivedBy__c = e.ReceivedBy;
                        
                        //Checking all the Events with the name INNLEVERINGSREGISTRERT
                        if(newEvent.Name.trim().equalsIgnoreCase('innleveringsregistrert'))
                        {
                            // This logic will pick up the latest value of this event
                            if(innPost != null)
                            {
                                if(innPost.date__c < newEvent.date__c)
                                {
                                    innPost = newEvent;
                                    innPost_PostalUnit = e.UnitNumber;
                                }

                            }
                            else
                            {
                                innPost = newEvent;
                                innPost_PostalUnit = e.UnitNumber;
                            }
                        }

                        //Checking all the Events with the name UTLEVERT
                        if(newEvent.Name.equalsIgnoreCase('utlevert'))
                        {
                            // This logic will pick up the latest value of this event
                            if(utlevert != null)
                            {
                                if(utlevert.date__c < newEvent.date__c)
                                {
                                    utlevert = newEvent;
                                    utlevert_PostalUnit = e.UnitNumber;
                                }

                            }
                            else
                            {
                                utlevert = newEvent;
                                utlevert_PostalUnit = e.UnitNumber;
                            }
                        }

                        if(oldEvents.size() > 0) {
                            boolean exists = false;
                            for(LM_Shipment_Event__c oldEvent : oldEvents) {
                                if(oldEvent.date__c == newEvent.date__c && oldEvent.EventCode__c == newEvent.EventCode__c) {
                                    exists = true;
                                }
                            }
                            if(!exists) {
                                newEvents.add(newEvent);
                            }
                            
                        } else {
                            newEvents.add(newEvent);
                        }
                    }
                }
                upsert(newEvents);
            } catch (Exception ex) {
                system.debug('Something went wrong when persisting shipmentEvents: ' + ex.getMessage() );
                // CSPhase2 , Dinesh , 28/12/2016
                // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Det oppsto en feil under lagring av hendelser fra LM på saken - ' + ex.getMessage() ));
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error28  + ex.getMessage() ));
            }
        } else {
            // CSPhase2 , Dinesh , 28/12/2016
            // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Fant ingen hendelses objekter' ));
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_DataPersistencyController_error29 ));
        }
    }
    
    public static Double retrievePostalOrderAmount(List<postenNoEconnectKatsGetshipment.ValueAddedService> vas) {
        Double poAmount = 0.0;
        for(postenNoEconnectKatsGetshipment.ValueAddedService v : vas) {
            if(!(v.BankAccountNumber == null || v.BankAccountNumber == '')) {
                if(!(v.CoDAmount == null || v.CoDAmount == '')) {
                    poAmount = Decimal.valueOf(v.CoDAmount);
                }
            }
        }
        return poAmount;
    }/**/
    
    public static String PersonStatus(String StatusCode,String StatusValue)
    {
    System.debug('@@@ststuscode@@@'+StatusCode);
        if(StatusCode!=null && StatusCode!='')
        {
            cs_PersonCustomerStatus__c Status= cs_PersonCustomerStatus__c.getValues(StatusCode);
            if(Status!=null)
                return Status.StatusValue__c;
            else
                return StatusValue;
        }
        else
            return null;
    }
    
     public Static String OrganizationStatus(String StatusCode,String StatusValue)
    {
        if(StatusCode!=null && StatusCode!='')
        {
            cs_BusinessCustomerStatus__c Status= cs_BusinessCustomerStatus__c.getValues(StatusCode);
            if(Status!=null)
                return Status.StatusValue__c;
            else
                return StatusValue;
        }
        else
            return null;
    }
}