/**
This class is used by TriggerHandler_Case which is used by CaseBeforeTrigger to assign reciever and sender info to reciever and sender cases respectively.
It is commonly used in cases where the case origin is from e-mail or webforms where the user only provides one adress.
It also contains methods for searching accounts/customers based on Shipment Number, Shipment Id, Invoice number and Address Change Reference.
*/ 

/*CS Phase 2, Changed the method for Datapersistency.MaintainAccount method*/
public with sharing class CaseUtil {
    private static Id senderRecordTypeId = KATSUtilities.getRecordType('complaint');
    private static Id recieverRecordTypeId = KATSUtilities.getRecordtype('complaint');
    private static Id recieverCargoClaimsId = KATSUtilities.getRecordtype('Cargo_Claims');
    public Static String[] InformationType{get;set;}
    
    public static void assignRecieverInfoToCase(Case c)
    {
        // If LM has information about the delivery address (not necessarily equal to recipents address), the reciever address will not be changed, as the delivery address from LM is the address which is written on the package.
        if(!c.hidden_is_package_with_edi__c)
        {
            if(c.accountId != null)
            {
                Account a = [select Id, name, ShippingStreet, ShippingPostalCode, ShippingCity, ShippingCountry from Account where Id = :c.AccountId];
                c.reciever_name__c = a.Name;
                c.reciever_address__c = a.ShippingStreet;
                c.reciever_zip_code__c = a.ShippingPostalCode;
                c.reciever_postal_address__c = a.ShippingCity;
                c.reciever_country__c = null;
                //c.Reciever_CountryCode__c = a.ShippingCountry;
            }
            else
            {
                if(KATSutilities.isEmpty(c.reciever_name__c)) c.reciever_name__c = c.SuppliedName; // null check in case reciever info is already assigned
                if(KATSutilities.isEmpty(c.reciever_address__c)) c.reciever_address__c = c.suppliedAddress__c;
                if(KATSutilities.isEmpty(c.reciever_zip_code__c)) c.reciever_zip_code__c = c.suppliedPostalCode__c;
                if(KATSutilities.isEmpty(c.reciever_postal_address__c)) c.reciever_postal_address__c= c.suppliedCity__c;
            }
        }
    }
    
    public static void assignSenderInfoToCase(Case c)
    {
        if(c.accountId != null)
        {
            Account a = [select Id, name, ShippingStreet, ShippingPostalCode, ShippingCity, ShippingCountry from Account where Id = :c.AccountId];
            c.shipper_name__c = a.Name;
            c.shipper_address__c = a.ShippingStreet;
            c.shipper_zip_code__c = a.ShippingPostalCode;
            c.shipper_postal_address__c = a.ShippingCity;
            c.shipper_country__c = null;
            //c.Shipper_CountryCode__c = a.ShippingCountry;
        }
        else
        {
            if(KATSutilities.isEmpty(c.shipper_name__c)) c.shipper_name__c = c.SuppliedName; // null check in case shipper info is already assigned
            if(KATSutilities.isEmpty(c.shipper_address__c)) c.shipper_address__c = c.suppliedAddress__c;
            if(KATSutilities.isEmpty(c.shipper_zip_code__c)) c.shipper_zip_code__c = c.suppliedPostalCode__c;
            if(KATSutilities.isEmpty(c.shipper_postal_address__c)) c.shipper_postal_address__c= c.suppliedCity__c;
        }
    }
    
    public static boolean isRecieveShipment(Case caseShipmentRecieve)
    {
        if(caseShipmentRecieve.RecordTypeId == recieverRecordTypeId)
            return true;
        else
            return false;
    }
    
    public static boolean isSenderShipment(Case caseShipmentSender)
    {
        if(caseShipmentSender.RecordTypeId == senderRecordTypeId)
            return true;
        else
            return false;
    }
    
    public static boolean isCargoClaims(Case caseCargoClaims)
    {
        if(caseCargoClaims.RecordTypeId == recieverCargoClaimsId)
        {
            return true;
        }
        else return false;
    }
    
    /* */
    public static void maintainPreviousForwardingAddress(List<Case> cases)
    {
        list<string> refNumbers = new list<string>();
        list<Case> casesToUpdate = new list<Case>();
        list<ForwardingAddressChange__c> forwardings = new list<ForwardingAddressChange__c>();
        
        for(Case c : cases)
        {
            refNumbers.add(c.change_address_ref_no__c);
        }
        
        forwardings = [SELECT id,
                              number__c,
                              referenceOMA__c,
                              type__c
                         FROM ForwardingAddressChange__c 
                        WHERE number__c in :refNumbers 
                           OR referenceOMA__c in :refNumbers];
        
        for(ForwardingAddressChange__c fac: forwardings)
        {
            //Should have used a map, but several cases can have the same reference number,
            //it is therefore a possibility that two cases with the same referece number is added!
            for(Integer i = 0; i < cases.size(); i++)
            {
                if(cases.get(i).change_address_ref_no__c == fac.number__c || cases.get(i).change_address_ref_no__c == fac.referenceOMA__c)
                {
                    cases.get(i).forwardingAddress__c = fac.id;
                    if(fac.type__c == 'hold')
                    {
                       // cases.get(i).produkt__c = 'Oppbevaring';
                    }
                    else if(fac.type__c == 'permanent')
                    {
                        //cases.get(i).produkt__c = 'Warehousing';
                    }
                    else if(fac.type__c == 'temporary')
                    {
                        //cases.get(i).produkt__c = 'Logistics parcels';
                    }
                    
                    casesToUpdate.add(cases.remove(i));
                } 
            }
        }
    }
    
    @Future(callout=true)
    public static void maintainPreviousForwardingAddressFuture(List<ID> caseIds, boolean addAccountToCase)
    {
        list<Case> cases = [SELECT id,
                                   change_address_ref_no__c,
                                   forwardingAddress__c,
                                   AccountId 
                              FROM Case 
                             WHERE id in :caseIds];

        if(cases.size() > 0)
        {
            list<Case> casesToUpdate = new list<Case>();
            String partynumber;
            Account acc;
            map<string, string> searchCustomerParams = new map<string, string>();
            
            postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
            postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType[] eConnectReply
                = new  postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType[]{};
            
            for(Case c : cases)
            {
                system.debug('Running maintainPreviousForwardingAddressFuture on Case with id: ' + c.Id + ' . change_address_ref_no__c is: ' + c.change_address_ref_no__c + '. addAccountToCase is :' + addAccountToCase);
                searchCustomerParams.put('forwarding_number', c.change_address_ref_no__c);
                
                try
                {
                // CS- Phase 2, Akshata Asukar 02/01/2017 Call SearchPartyCRM to get customer number for forwarding details
                 eConnectReply = eConnect.SearchPartyCRM(searchCustomerParams);
                   
                   
                   eConnectReply=eConnect.SearchPartyCRM(searchCustomerParams);
                   if(!test.isRunningTest() && (eConnectReply==null || eConnectReply.size()<1) ) {
                        system.debug('Search: No results returned from eConnect');  
                    } 
                    else
                    {
                        partynumber = ( test.isRunningTest() ? 'TestPartyNumber' : eConnectReply[0].AccountNumber);
                        InformationType=new string[]{'CustomerDetails'};
                        if(!KATSutilities.isEmpty(partynumber)){
                            acc = ( test.isRunningTest() ? KatsTestUtilities.getTestBusinessAccount() : DataPersistencyController.maintainAccount(eConnectReply[0].AccountNumber,InformationType) );
                            if(addAccountToCase && acc != null && !KATSutilities.isEmpty(acc.Id)){
                                c.AccountId = acc.Id;
                            }
                            casesToUpdate.add(c);
                        }
                    }
                }
                catch(CalloutException coe) {
                    system.debug('Something went wrong in the eConnect call');
                    KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_ErrorUtil2 + coe.getMessage() ));
                }
                catch(TypeException te) {
                    system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
                    KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_ErrorUtil1 + te.getMessage() ));
                }
            }
            
            if(!casesToUpdate.isEmpty())
            {
                list<string> refNumbers = new list<string>();
                list<ForwardingAddressChange__c> forwardings = new list<ForwardingAddressChange__c>();
                
                for(Case c : casesToUpdate) {
                    if(c.forwardingAddress__c == null){
                        refNumbers.add(c.change_address_ref_no__c);
                    }
                }
                
                forwardings = [SELECT id, number__c, referenceOMA__c, type__c FROM ForwardingAddressChange__c WHERE number__c in :refNumbers OR referenceOMA__c in :refNumbers];
                
                for(ForwardingAddressChange__c fac: forwardings)
                {
                    //Should have used a map, but several cases can have the same reference number,
                    //it is therefore a possibility that two cases with the same referece number is added!
                    for(Integer i = 0; i < cases.size(); i++)
                    {
                        if(casesToUpdate.get(i).forwardingAddress__c == null && (casesToUpdate.get(i).change_address_ref_no__c == fac.number__c || casesToUpdate.get(i).change_address_ref_no__c == fac.referenceOMA__c))
                        {
                            casesToUpdate.get(i).forwardingAddress__c = fac.id;
                            if(fac.type__c == 'hold')
                            {
                                //casesToUpdate.get(i).produkt__c = 'Oppbevaring';
                            }
                            else if(fac.type__c == 'permanent')
                            {
                                //casesToUpdate.get(i).produkt__c = 'Warehousing';
                            }
                            else if(fac.type__c == 'temporary')
                            {
                                //casesToUpdate.get(i).produkt__c = 'Logistics parcels';
                            }
                        } 
                    }
                }
                update casesToUpdate;
            }
        }
    }
    
    @Future(callout=true)
    public static void searchAccountFromInvoiceNumberFuture(List<ID> caseIds)
    {
        list<Case> cases = [SELECT id,
                                   Invoice_no__c,
                                   AccountId
                              FROM Case 
                             WHERE id in :caseIds];

        if(cases.size() > 0)
        {
            list<Case> casesToUpdate = new list<Case>();
            map<string, string> searchCustomerParams = new map<string, string>();
            Account acc;
            
            postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
            postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType[] eConnectReply
                = new  postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType[]{};
            
            for(Case c : cases)
            {
                system.debug('Running searchAccountFromInvoiceNumberFuture on Case with id: ' + c.Id + ' . Invoice number is: ' + c.Invoice_no__c);
                // Only perform search if case has no account
                if(c.AccountId == null)
                {
                    searchCustomerParams.put('invoice_number', c.Invoice_no__c);
                    try
                    {
                      // CS- Phase 2, Akshata Asukar 02/01/2017 Call SearchPartyCRM to get customer number for invoice details 
                        eConnectReply = eConnect.SearchPartyCRM(searchCustomerParams);
                        
                        if(!test.isRunningTest() && (eConnectReply==null|| eConnectReply.size()<1) )
                        {
                            system.debug('Search: No results returned from eConnect');  
                        }
                        else
                        {
                            InformationType=new string[]{'CustomerDetails'};
                            acc = ( test.isRunningTest() ? KatsTestUtilities.getTestBusinessAccount() : DataPersistencyController.maintainAccount(eConnectReply[0].AccountNumber,InformationType) );
                            if(acc != null && !KATSutilities.isEmpty(acc.Id))
                            {
                                c.AccountId = acc.Id;
                                casesToUpdate.add(c);
                            }
                        }
                    }
                    catch(CalloutException coe)
                    {
                        system.debug('Something went wrong in the eConnect call');
                       // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelsen til eConnect feilet - ' + coe.getMessage() ));
                        //cspahse2 supriya 26122016
                         KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, +System.Label.cs_Connection_to_eConnect_failed +' - ' + coe.getMessage() ));
                    }
                    catch(TypeException te)
                    {
                        system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
                       // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
                         //cspahse2 supriya 26122016
                         KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_Error_in_specified_values+' - ' + te.getMessage() ));
                         
                    }
                }
            }

            if(!casesToUpdate.isEmpty())
            {
                update casesToUpdate;
            }
        }
    }
    
    // The same logic applies for shipment number and shipment id searches, therefore calls the same method for both cases.
    private static String SHIPMENT_NUMBER_TYPE = 'SHIPMENT_NUMBER'; // sendingsnummer
    private static String SHIPMENT_ID_TYPE = 'SHIPMENT_ID'; //kollinummer
    
    @Future(callout=true)
    public static void searchAccountFromShipmentNumberFuture(List<ID> caseIds)
    {
        searchAccountFromShipmentReference(caseIds, SHIPMENT_NUMBER_TYPE);
    }
    
    @Future(callout=true)
    public static void searchAccountFromShipmentIdFuture(List<ID> caseIds)
    {
        searchAccountFromShipmentReference(caseIds, SHIPMENT_ID_TYPE);
    }
    
    /* Method for connecting the right account with the case based on shipment ID/number.
    *  The method will potentially make 4 calls to econnect.
    *  1. Try to find a shipment by calling eConnect.searchShipment. The information recieved from this call does not include the senders partynumber.
    *  2. Get the shipment by calling eConnect.getShipment.
    *  3. If shipment info contains the senders partynumber, call eConnect.searchCustomer with the partynumber as input.
    *  4. If a customer is found, call DataPersistencyController.maintainAccount. Connect the account to the case.
    */
    public static void searchAccountFromShipmentReference(List<ID> caseIds, String Type)
    {
        list<Case> cases = [SELECT id, Shipment_identification__c, Shipment_number__c, AccountId  FROM Case WHERE id in :caseIds];
        if(cases.size() > 0) {
            list<Case> casesToUpdate = new list<Case>();
            map<string, string> searchCustomerParams = new map<string, string>();
            map<string, string> searchShipmentParams = new map<string, string>();
            Account acc;
            
            postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
             List<postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType> eConnectReply =new List<postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType>();
            List<postenNoEconnectKatsSearchshipment.TShipmentUnit> eConnectSearchShipmentReply 
             = new List<postenNoEconnectKatsSearchshipment.TShipmentUnit>();
            postenNoEconnectKatsGetshipment.ShipmentUnitType eConnectGetShipmentReply
             = new postenNoEconnectKatsGetshipment.ShipmentUnitType();
            
            for(Case c : cases) {
                system.debug('Running searchAccountFromShipmentReference on Case with id: ' + c.Id + ' . Shipment_identification__c is: ' + c.Shipment_identification__c + ' . Shipment_number__c is: ' + c.Shipment_number__c);
                // Only perform search if case has no account
                if(c.AccountId == null){
                    if(Type == SHIPMENT_NUMBER_TYPE){
                        searchShipmentParams.put('ShipmentID', c.Shipment_number__c); // sendingsnummer
                    } else if(Type == SHIPMENT_ID_TYPE){
                        searchShipmentParams.put('ShipmentUnitID', c.Shipment_identification__c); // kollinummer
                    }
                    
                    try {
                        eConnectSearchShipmentReply = eConnect.searchShipment('1', searchShipmentParams);
                        
                        if(eConnectSearchShipmentReply==null || eConnectSearchShipmentReply.size() < 1 || KATSutilities.isEmpty(eConnectSearchShipmentReply.get(0).ShipmentUnitID) ) {
                            system.debug('Search: No results returned from eConnect for the shipment search');  
                        } else {
                            eConnectGetShipmentReply = eConnect.getShipment(eConnectSearchShipmentReply.get(0).ShipmentUnitID);
                            
                            if(eConnectGetShipmentReply == null || eConnectGetShipmentReply.Sender == null){
                                system.debug('Search returned a shipment with ShipmentUnitID (kollinummer) ' + c.Shipment_identification__c + 'but getShipment failed to fetch the shipment');
                            } else if (eConnectGetShipmentReply.Sender == null || KATSutilities.isEmpty(eConnectGetShipmentReply.Sender.PartyNumber) ){
                                system.debug('Shipment was found, but data did not contain information about sender or senders partynumber');
                            } else{
                                searchCustomerParams.put('party_number', eConnectGetShipmentReply.Sender.PartyNumber);
                                ////CS-Phase2 to be changed once SearchPartyFAR response is available
                                eConnectReply = eConnect.searchPartyCRM(searchCustomerParams);
                                
                                if(eConnectReply==null ||  eConnectReply.size()<1) {
                                    system.debug('Search: No results returned from eConnect for search with Partynumber: ' + eConnectGetShipmentReply.Sender.PartyNumber);  
                                } else {
                                 InformationType=new string[]{'CustomerDetails'};
                                 
                                   acc = ( test.isRunningTest() ? KatsTestUtilities.getTestBusinessAccount() : DataPersistencyController.maintainAccount(eConnectReply[0].AccountNumber,InformationType) );
                                    // Can this be the bug? eConnectGetShipmentReply.Sender.PartyNumber = 00001560358, while Party number = 1560358.
                                    if(acc != null){
                                        //system.debug('eConnectGetShipmentReply.Sender.PartyNumber = ' + eConnectGetShipmentReply.Sender.PartyNumber);
                                        //system.debug('acc.Party_number__c = ' + acc.Party_number__c);
                                    }
                                    //if(acc != null && !KATSutilities.isEmpty(acc.Id) && eConnectGetShipmentReply.Sender.PartyNumber == acc.Party_number__c){ // Do not add account to case unless party numbers are exact match
                                    if(acc != null && !KATSutilities.isEmpty(acc.Id)){ // Removed check that PartyNumbers are exact match, as the PartyNumber on the shipment often contains leading 0's
                                        c.AccountId = acc.Id;
                                        casesToUpdate.add(c);
                                    }
                                }
                            }
                        }
                    }
                     catch(CalloutException coe)
                    {
                        system.debug('Something went wrong in the eConnect call');
                       // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelsen til eConnect feilet - ' + coe.getMessage() ));
                        //cspahse2 supriya 26122016
                         KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, +System.Label.cs_Connection_to_eConnect_failed +' - ' + coe.getMessage() ));
                    }
                    catch(TypeException te)
                    {
                        system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
                       // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
                         //cspahse2 supriya 26122016
                         KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_Error_in_specified_values+' - ' + te.getMessage() ));
                         
                    }
                }
            }

            if(!casesToUpdate.isEmpty()) {
                update casesToUpdate;
            }
        }
    }
}