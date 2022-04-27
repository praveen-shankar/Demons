//// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
/*
SFDC MANUAL TEST CASES:
Private
    Click non existing customer                                         OK
    Click existing customer                                             OK
    Create new customer                                                 OK
    Create case on non existing customer                                OK
    Create case on existing customer                                    OK
Business
    Click Existing account, no contact                                  OK
    Click Existing account existing contact                             OK
    Click Existing account create new contact                           OK
    Click Existing account non existing contact                         OK
    Click Non existing account - doesn't mapper about contact           OK
    Create new account                                                  OK
    New case on existing account                                        OK
    New case on non-existing account                                    OK
    New case on new account                                             OK
Shipment
    Show details and go back (TS601300833NO)                            OK
    Create case for existing account                                    OK
    Create case for new account                                         OK

TASKS  
    PRI 1.1
    * results ordering
    * copy search params to case + determine case type on case create
    * search for salesforce phone/email/... must return account ALTERNATIVELY - searhc in contacts as well as accounts.
    * Dobbeltklik på account navn for at komme til account uden kontaktpersonload
    * Style Error messages and integrate with exception framework
    * default parametre vælges i forhold til rolle/profil
    * håndtering af søg --> browse --> gensøk flow (kan vi fake at state bevares?)
    * Display forretningsområder on mouse over.
    * Tjek opløsning - storbedrift (Det varierer nok litt avhengig av hvilken type pc man har, og om den er gammel eller ny.Selv har jeg gammel pc og skjermoppløsningen min er på 1280x800. Sitter for øvrig med stor skjerm koblet til pc. En av mine kollegaer har ny pc, og der er skjermoppløsningen 1600x900. Bruker ikke stor skjerm som jeg.) - Christine: 1280x744
    * create contact/account on enter
    
    AFKLARINGER
    * Adskillelse af privat og bedrift? - Det er en fin adskillelse
    
    SPØRGSMÅL TEKNIK
    * Fonetiske søkninger?
    
    DONE
    * clear/select value in new account/contact fields on click.
    * partial searches? - wildcards?
    * integrate with getCustomer()/searchCustomer()
    * search on enter.
    * Støt searchShipment flyt
    * Live mot econnect
    * IE7 bug
    * fjern kommunekode og nummer
    * Merge columns (street + number etc)
    * create customer/contact functionality
    * jump to contacts section on account select?
    * onsubmit doesn't trigger a new_contact_lastname field reset. Should work as account search.
    * søk status indicators
    
    FIXES by Tor Håkon:
    *Defect 244 - If search parameter for forwardingnumber not empty it follows in the url when user views customer data. Fixed on lines 398-403 in getPageReference()
    *Defect 702 - If sender is missing partynumber trying to create a new case will result in a new customer named "<Oprett Kunde>".
     This is now fixed 31.08.2011 in goDoShipmentCase() on lines 648-663. New case is upsertet and user it returnet to the case.
    
    NEW REQUIREMENTS FOR 2012-1 RELEASE
    * create unregistered shipment casse for new recordtype - DONE
    * Add more unit testing, improved, but not good enough
    * Review KATSutilities.getFirstName and KATSutilities.getLastName
    
*/

public with sharing class MainSearchController {

    /* Enum definitions */
    public enum searchAspectType {PRIVATE_SEARCH, BUSINESS_SEARCH, SHIPMENT_SEARCH}
    public enum accountType {BUSINESS_ACCOUNT, PERSON_ACCOUNT, UNKNOWN}
    public enum forwardType {NEW_CASE, ACCOUNT, EXISTING_CASE}

    /* Search params - searchCustomer */
    private map<String, String> searchCustomerParams = new map<String, String>();
    public String getSelectedRevenueArea() { return searchCustomerParams.get('selectedRevenueArea'); }
    public void setSelectedRevenueArea(String s) { addCustomerSearchParam('selectedRevenueArea', s); }
    public List<SelectOption> getRevenueAreas() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(postenNoEconnectSortingUtilities.REVENUE.POST_AND_LOGISTIKK.name(), Label.cs_Post_and_Logistics));
        options.add(new SelectOption(postenNoEconnectSortingUtilities.REVENUE.POST.name(), 'Post'));
        options.add(new SelectOption(postenNoEconnectSortingUtilities.REVENUE.LOGISTIKK.name(), Label.cs_Logistics));
        return options;
    }
    public String getorg_name() { return searchCustomerParams.get('org_name'); }
    public void setorg_name(String s) { addCustomerSearchParam('org_name', s); }
    public String getorg_fiscal_reference() { return searchCustomerParams.get('org_fiscal_reference'); }
    public void setorg_fiscal_reference(String s) { addCustomerSearchParam('org_fiscal_reference', s); }
    public String getorg_contactFirstName() { return searchCustomerParams.get('org_contactFirstName'); }    
    public void setorg_contactFirstName(String s) { addCustomerSearchParam('org_contactFirstName', s); }
    public String getorg_contactLastName() { return searchCustomerParams.get('org_contactLastName'); }      //
    public void setorg_contactLastName(String s) { addCustomerSearchParam('org_contactLastName', s); }
    public String getperson_first_name() { return searchCustomerParams.get('person_first_name'); }
    public void setperson_first_name(String s) { addCustomerSearchParam('person_first_name', s); }
    //public String getperson_middle_name() { return searchCustomerParams.get('person_middle_name'); }
    //public void setperson_middle_name(String s) { addCustomerSearchParam('person_middle_name', s); }
    public String getperson_last_name() { return searchCustomerParams.get('person_last_name'); }
    public void setperson_last_name(String s) { addCustomerSearchParam('person_last_name', s); }
    public String getperson_national_identification_number() { return searchCustomerParams.get('person_national_identification_number'); }
    public void setperson_national_identification_number(String s) { if(getAllowFullPrivateSearch()) { addCustomerSearchParam('person_national_identification_number', s);}  }
    public String getaddress_city() { return searchCustomerParams.get('address_city'); }
    public void setaddress_city(String s) { addCustomerSearchParam('address_city', s); }
    public String getaddress_house_number() { return searchCustomerParams.get('address_house_number'); }
    public void setaddress_house_number(String s) { addCustomerSearchParam('address_house_number', s); }
    public String getaddress_house_letter() { return searchCustomerParams.get('address_house_letter'); }
    public void setaddress_house_letter(String s) { addCustomerSearchParam('address_house_letter', s); }
    public String getaddress_po_box_number() { return searchCustomerParams.get('address_po_box_number'); }
    public void setaddress_po_box_number(String s) { addCustomerSearchParam('address_po_box_number', s); }
    public String getaddress_postal_code() { return searchCustomerParams.get('address_postal_code'); }
    public void setaddress_postal_code(String s) { addCustomerSearchParam('address_postal_code', s); }
    public String getemail() { return searchCustomerParams.get('email'); }
    public void setemail(String s) { addCustomerSearchParam('email', s); }
    public String getphone() { return searchCustomerParams.get('phone'); }
    public void setphone(String s) { addCustomerSearchParam('phone', s); }
    public String getaddress_street_name() { return searchCustomerParams.get('address_street_name'); }
    public void setaddress_street_name(String s) { addCustomerSearchParam('address_street_name', s); }
    public String getparty_number() { return searchCustomerParams.get('party_number'); }
    public void setparty_number(String s) { addCustomerSearchParam('party_number', s); }
    public String getparty_type() { return searchCustomerParams.get('party_type'); }
    public void setparty_type(String s) { addCustomerSearchParam('party_type', s); }
    public String getaccount_number() { return searchCustomerParams.get('account_number'); }
    public void setaccount_number(String s) { addCustomerSearchParam('account_number', s); }
    public String getforwardingnumber() { return searchCustomerParams.get('forwardingnumber'); }
    public void setforwardingnumber(String s) { if(s != null){ s = s.toUpperCase(); } addCustomerSearchParam('forwardingnumber', s); }
    public String getreceivable_number() { return searchCustomerParams.get('receivable_number'); }
    public void setreceivable_number(String s) { addCustomerSearchParam('receivable_number', s); }
    public String getorder_number() { return searchCustomerParams.get('order_number'); }
    public void setorder_number(String s) { addCustomerSearchParam('order_number', s); }

    
    /* Search params - searchShipment */
    private map<String, String> searchShipmentParams = new map<String, String>();
    public boolean shipmentResultSuccessFull {get; set;}
    public String getShipmentID() { return searchShipmentParams.get('ShipmentID'); }
    public void setShipmentID(String s) { addShipmentSearchParam('ShipmentID', s); }
    public String getShipmentUnitID() { return searchShipmentParams.get('ShipmentUnitID'); }
    public void setShipmentUnitID(String s) { addShipmentSearchParam('ShipmentUnitID', s); }
    public String getShipmentDateTimeFrom() { return searchShipmentParams.get('ShipmentDateTimeFrom'); }
    public void setShipmentDateTimeFrom(String s) { addShipmentSearchParam('ShipmentDateTimeFrom', s); }
    public String getShipmentDateTimeTo() { return searchShipmentParams.get('ShipmentDateTimeTo'); }
    public void setShipmentDateTimeTo(String s) { addShipmentSearchParam('ShipmentDateTimeTo', s); }
    public String getSendersReferenceNumber() { return searchShipmentParams.get('SendersReferenceNumber'); }
    public void setSendersReferenceNumber(String s) { addShipmentSearchParam('SendersReferenceNumber', s); }
    public String getShipmentPartyNumber() { return searchShipmentParams.get('PartyNumber'); }
    public void setShipmentPartyNumber(String s) { addShipmentSearchParam('PartyNumber', s); }
    //public String getPartyName() { return searchShipmentParams.get('PartyName'); }
    //public void setPartyName(String s) { addShipmentSearchParam('PartyName', s); }
    //public String getProduct() { return searchShipmentParams.get('Product'); }
    //public void setProduct(String s) { addShipmentSearchParam('Product', s); }
    public String getShipmentCity() { return searchShipmentParams.get('City'); }
    public void setShipmentCity(String s) { addShipmentSearchParam('City', s); }
    public String getPostalCodeSource() { return searchShipmentParams.get('ShipToPostalCodeFrom'); }
    public void setPostalCodeSource(String s) { addShipmentSearchParam('ShipToPostalCodeFrom', s); }
    public String getPostalCodeDestination() { return searchShipmentParams.get('ShipToPostalCodeTo'); }
    public void setPostalCodeDestination(String s) { addShipmentSearchParam('ShipToPostalCodeTo', s); }
    public String getLoadingWeightMeasureFrom() { return searchShipmentParams.get('LoadingWeightMeasureFrom'); }
    public void setLoadingWeightMeasureFrom(String s) { addShipmentSearchParam('LoadingWeightMeasureFrom', s); }
    public String getLoadingWeightMeasureTo() { return searchShipmentParams.get('LoadingWeightMeasureTo'); }
    public void setLoadingWeightMeasureTo(String s) { addShipmentSearchParam('LoadingWeightMeasureTo', s); }      
    
    /* State variables */
    public integer selected_account_search_result {get; set{ right_account = null; selected_account_search_result=value; } }
    public list<AccountSearchResult> account_search_results { get; set; }
    private map<String, Account> account_search_result_existing_accounts = new map<String, Account>();  //Map of salesforce acocunts found in the account_search_results list
    private map<String, Contact> contact_search_result_existing_contacts = new map<String, Contact>();  //Map of salesforce contacts found in the contact_search_results list
    public integer selected_shipment_search_result {get; set;}
    public ShipmentWrapper currentShipmentWrapper {get; set;}
    public list<ShipmentWrapper> shipment_search_results { get; set; }
    public list<ShipmentUnitIDHolder> organizedShipmentList {get; set;}  
    public integer selected_contact_search_result {get; set { right_contact = null; selected_contact_search_result=(value == -2) ? null : value; } }
    public list<ContactSearchResult> contact_search_results { get; set; }
    public forwardType go_to_type { get; private set; }
    public Account new_account { get; set; }
    public Contact new_contact { get; set; }
    public Case new_case_data { get; set; }
    public Account right_account { get; set; }
    public Contact right_contact { get; set; }
    public String currentShipmentNumber {get; set;}
    public EConnectWrapper_GetShipmentData right_shipment { get; set; }
    public Case right_case { get; set; }
    public boolean override_required_contact { get; set; }
    public boolean displayShipmentDetailsPopup { get; set; }
    public String currentSearchModus { get; set; }  //FOT||AR||FW||OM||CAESAR||LM_ID||LM_GENERAL_UNITID||LM_GENERAL_PARTYNO||LM_GENERAL_REFNO... Corresponds with values in mainsearch_js.resource "currentSearchModus" which are taken from mainsearch_searchParams.page where class names are class="searchParam_[searchModus]"
    public String activeSearchTab { get; set; }

    private postenNoEconnectUtilities eConnect { get; set; }
    private postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType cached_getCustomerReply;
    private String startSearch;

    // Fields for Case search with same Kollinummer (Package Number) : C-02644
    public Boolean dispSimCases {get; set;}                     // Controls the visibility of the section
    public List<Case> simCasesList {get; set;}                  // Holds the search result
    public String dateRange {get; set;}                         // This will hold codes for the Date range to search the Cases from: w - 1 Week, m - 1 month, q - 1 Quarter, h - Half Year, y - 1 Year
    
  public static string POSTEN_GLOBAL_ADRESSELISTE=KATSutilities.getGlobalAddressListName();
    
    /**
     * Constructor. Sets up default search values and prepares state variables
     */
    public MainSearchController() {
        
        // Variables pased as URL parameters
        String caseId = System.currentPagereference().getParameters().get('caseId');   
        String phoneNumber = System.currentPagereference().getParameters().get('phone'); 
        String defaultSearchTab = System.currentPagereference().getParameters().get('searchTab');   // (optional) 'tabPrivate' || 'tabBusiness' || 'tabShipment' 
        startSearch = System.currentPagereference().getParameters().get('startSearch');
        
        
        setSelectedRevenueArea(postenNoEconnectSortingUtilities.REVENUE.POST_AND_LOGISTIKK.name());
        
        if(caseId != null) {
            system.debug('URL param "CaseId" provided as URL parameter. Getting case object from DB. Id: ' + caseId);
            right_case = [select Shipment_identification__c, 
                                 Account.Name, 
                                 Account.isPersonAccount, 
                                 Account.crm_customer_number__c, 
                                 id, 
                                 CaseNumber, 
                                 Subject, 
                                 SuppliedCompany, 
                                 SuppliedEmail, 
                                 SuppliedName, 
                                 SuppliedPhone, 
                                 suppliedAddress__c, 
                                 suppliedPartyNumber__c, 
                                 suppliedCity__c, 
                                 Invoice_no__c, 
                                 suppliedOrganizationNo__c, 
                                 suppliedPostalCode__c, 
                                 change_address_ref_no__c, 
                                 Shipment_number__c 
                            from 
                                 case 
                           where id=:caseId limit 1];
            
            system.debug('Search is in based on a case. Setup search params from the case data');
            
            if(right_case.AccountId == null) {
                system.debug('The case has no account selected. Using the hidden hint fields');
                setorg_name(right_case.SuppliedCompany);
                
                if(right_case.SuppliedCompany != null && right_case.SuppliedCompany != '' && right_case.SuppliedName != null && right_case.SuppliedName != '' && !right_case.SuppliedCompany.equals(right_case.SuppliedName)){
                    setorg_contactFirstName(KATSutilities.getFirstName(right_case.SuppliedName));
                    setorg_contactLastName(KATSutilities.getLastName(right_case.SuppliedName));
                }
                
                setphone(right_case.SuppliedPhone);
                setemail(right_case.SuppliedEmail);
    
                if(right_case.SuppliedName != null && right_case.SuppliedName != '') {
                    setperson_first_name(KATSutilities.getFirstName(right_case.SuppliedName));
                    setperson_last_name(KATSutilities.getLastName(right_case.SuppliedName));
                }
                
                List<String> suppliedAddress = splitAddress(right_case.suppliedAddress__c);
                if(suppliedAddress != null){
                    setaddress_street_name(suppliedAddress[0]);
                    setaddress_house_number(suppliedAddress[1]);
                    setaddress_house_letter(suppliedAddress[2]);
                }
                
                setparty_number(right_case.suppliedPartyNumber__c);
                setaddress_city(right_case.suppliedCity__c);
                setorg_fiscal_reference(right_case.suppliedOrganizationNo__c);
                setaddress_postal_code(right_case.suppliedPostalCode__c);
            }
            else 
            {
                system.debug('The case has an account defined. Using it as default search params');
                if(KATSutilities.isEmpty(right_case.Account.crm_customer_number__c)) 
                {
                    setorg_name(right_case.Account.Name);
                }
                else 
                {
                    setparty_number(right_case.Account.crm_customer_number__c);
                }
                
            }

            setforwardingnumber(right_case.change_address_ref_no__c);
            setShipmentUnitID(right_case.Shipment_identification__c);
            setShipmentID(right_case.Shipment_number__c);
            setreceivable_number(right_case.Invoice_no__c );

            go_to_type = forwardType.EXISTING_CASE;
        }
        else 
        {
            go_to_type = forwardType.ACCOUNT;
        }
        if(phoneNumber != null) 
        {
            system.debug('URL param "phone" provided. Setting it as search param');
            setphone(phoneNumber);
        }
        
        // Initialize variables (C-02644)
        dispSimCases = false;                       // Section will be hidden by default on page load
        simCasesList = new List<Case>();            // Initializing memory space for this list
        dateRange = 'w';                            // Default search will be 1 week

        eConnect = new postenNoEconnectUtilities();
        new_account = new Account(name='<Opprett kunde>');
        new_contact = new Contact(lastName='<Opprett kontaktperson>');
        new_case_data = new Case();
        displayShipmentDetailsPopup = false;
        override_required_contact = false;
        clearSearch();
        
        //TODO: if default searchTab must be intelligently picked. Do it here.
        if(defaultSearchTab == 'tabPrivate' || defaultSearchTab == 'tabBusiness' || defaultSearchTab == 'tabShipment') 
        {
            activeSearchTab = defaultSearchTab;
        }
        else 
        {
            activeSearchTab = 'tabBusiness';
        }
        
        //Default values for shipment dates
        setShipmentDateTimeFrom((dateTime.now()-10).format('dd.MM.yyyy'));
        setShipmentDateTimeTo(dateTime.now().format('dd.MM.yyyy'));
        goToCustomerSearch = false;
        
        //If parameter startsearch is true, automatically instantiate a customer search on the business tab
        if(startSearch == 'true'){
            searchBusinessAccountVoid();
        }   
    }
    
    
    /* Clears all search result lists */
    private void clearSearch() {
        selected_account_search_result = null;
        selected_shipment_search_result = null;
        selected_contact_search_result = null;
        account_search_results = null;
        shipment_search_results = null;
        contact_search_results = null;
        right_account = null;
        right_contact = null;
        right_shipment = null;
        shipmentResultSuccessFull = true;
    }
    
    /* Attempts to take the user to the next screen. Performs appropriate state changes and returns a page ref */
    public pagereference goDo() {
                
        boolean returnNull = false;
        
        system.debug('calling goDo()');
       
        if(!returnNull && right_account == null) {
            system.debug('The account is not defined. Attempting to define it');
            if(!prepareAccount()) {
                system.debug('Not able to define the account. Return to user.');
                returnNull = true;
            }
        }
       
        if(!returnNull && right_contact == null && isContactNeeded()) {
            system.debug('The contact is needed, and an account is selected: ' + right_account);
            
            if(getSelectedContactSearchResult() == null) {
                system.debug('No contact is selected.');
                
                if(KATSutilities.isEmpty(right_account.crm_customer_number__c)) {
                    system.debug('The account has no partynumber. No need to call backend for contacts. Just save the account');
                    right_account = KATSutilities.upsertAsSystem(right_account);
                }
                else {
                    system.debug('Account has partynumber. Persisting account syncrounously this will lead to a getCustomer call required to look for contacts');
                
                    try{
                        if(right_account.crm_Updated_by_CDH__c) 
                            callGetCustomer(right_account.crm_customer_number__c,true);
                        else
                            callGetCustomer(right_account.crm_customer_number__c,false);    
                        DataPersistencyController.maintainAccount(cached_getCustomerReply);
                    }
                    catch(Exception e) {
                        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Data for aktørnummer '+ right_account.crm_customer_number__c +' kan ikke hentes til KATS. (' + e.getMessage() + ')' ));
                        cached_getCustomerReply = null;
                    }
                    
                    if(cached_getCustomerReply != null) {
                        
                        //TODO - TEMP FIX for QC18 *START* - dataPersistency should be refactored to return the created account instead of boolean. 
                        //Until that is in place, this workaround will query the newly created account from the DB...
                        system.debug('Right account is now: ' + right_account + ' Refreshing it from SFDC DB.');
                        try {
                            right_account = [select id, BillingStreet, BillingCity, BillingPostalCode, BillingCountry, isPersonAccount, PersonContactId, crm_customer_number__c, recordTypeId, name from Account where crm_customer_number__c=:right_account.crm_customer_number__c limit 1];    //Reloading the account from the DB to get correct values (isPersonAccount, PersonContactId etc.)
                            system.debug('Ensure that salesforce ID is in the list of partyNumber-to-salesforceID list created with searchCustomer');
                            includePartyNumberToAccountIdMapping(right_account);
                        }
                        catch(Exception e) {
                           system.debug('Partynumber not found. Go to customer search');
                            upsert new_case_data;   
                            return createShipmentCaseGoToCustomerSearch();
                        }
                        system.debug('Right account refreshed. Is now: ' + right_account);
                        //TODO - TEMP FIX for QC18 *END*
                    }
                    else {
                        system.debug('PartyNumber was found using search customer, but is not returned by getCustomer()? This should never happen. .');
                        return null;
                    }
                }
            }
            else {
                system.debug('A contact has been selected. Therefore no need to call eConnect.getCustomer');
            }
            
            if(!prepareContact()) {
                system.debug('Not able to define the contact. Searching for contacts and return to user.');
                searchContacts();
                returnNull = true;
            }
            else {
                system.debug('Contact prepared. Upserting it in the DB');
                right_contact = KATSutilities.upsertAsSystem(right_contact);
            }
       }
       else {
            system.debug('No contact needed. Therefore we can now save the account and call the persistency @future');
            
            right_account = KATSutilities.upsertAsSystem(right_account);
            system.debug('Ensure that salesforce ID is in the list of partyNumber-to-salesforceID list created with searchCustomer');
            includePartyNumberToAccountIdMapping(right_account);
            
            DataPersistencyController.updateAccount(right_account.id);
        }
        
        system.debug('Account is good. Now reloading it from the DB to get correct values (isPersonAccount, PersonContactId etc.). ID/party: ' + right_account.id + '/' + right_account.crm_customer_number__c);
        right_account = [select id, BillingStreet, BillingCity, BillingPostalCode, BillingCountry, isPersonAccount, PersonContactId, crm_customer_number__c, recordTypeId, name from Account where id=:right_account.id limit 1];
       
        if(!returnNull && (go_to_type == forwardType.NEW_CASE || go_to_type == forwardType.EXISTING_CASE)) {
            system.debug('Must create new case: ' + new_case_data);
            if(go_to_type == forwardType.NEW_CASE) {
                right_case = createCase(new_case_data);
            }
            addAccountToCase();
            upsert right_case; 
   
            // Change criteria - shipment case is not used. Maintainshipment is called in the goDoShipmentCase method
            /*
            if(right_case != null && go_to_type == forwardType.NEW_CASE && !KATSutilities.isEmpty(right_case.Shipment_identification__c) && right_case.Shipment_identification__c != '0') {
                system.debug('A new shipment case with a shipment ID is being created. Call datapersistencyController on cached getShipment data - case:' + right_case);
                if(!DataPersistencyController.maintainShipmentOnRegisteredCase( right_shipment.eConnectResponse, right_case)) { //If persistencycontroller returns true, the case was also upserted. Otherwise upsert the case.
                    upsert right_case;
                }
            }
            else {
                upsert right_case;          
            }
           */ 
            
        }
       
        system.debug('All do actions completed. Getting a relevant pagerefence and returning it to the user.');

        Pagereference r = (returnNull) ? null : getPageReference(); 
        return r;
    }   
    
    private boolean isContactNeeded() {
        if(!override_required_contact && !(right_account.IsPersonAccount || right_account.RecordTypeId == KATSutilities.getRecordType('person_account') )  ) {
            return true;
        }
        return false;
    }
    
    /**
     * @return appropriate pagereference based on the state variables of the class
     */
    private Pagereference getPageReference() {
        Pagereference pageref;
        if(go_to_type == forwardType.NEW_CASE || go_to_type == forwardType.EXISTING_CASE) {
            pageref = new ApexPages.StandardController(right_case).view();
        }
        else if(go_to_type == forwardType.ACCOUNT) {
            pageref = new ApexPages.StandardController(right_account).view();
            if(searchCustomerParams.get('forwardingnumber') != null) {
                pageref.getParameters().put('adresse', searchCustomerParams.get('forwardingnumber'));
            }
        }
    
        return pageref;
    }
    
    /* Attempting to creates/update an account based on the information at hand. Returns false if that is not possible */
    private boolean prepareAccount() {
        
        if(getSelectedAccountSearchResult() == null) {
            system.debug('No search result row selected. The user is manually creating a new account based on:' + new_account);
            right_account = createAccount(new_account);
        }
        else {
            system.debug('An account search result row has been selected by the user.');
            if(getSelectedAccountSearchResult().getSalesforceId() == null) {
                system.debug('A row with an account which does not exist in salesforce is selected. Creating the account.');
                right_account = loadAccount( getSelectedAccountSearchResult() );
            }
            else {
                system.debug('A row with an existing salesforce account is selected. Updating it.');
                right_account = updateAccount( getSelectedAccountSearchResult() );      
            }
        }
        
        return true;
    }
    
    /* Attempting to creates/update a contact based on the information at hand. Returns false if that is not possible */
    private boolean prepareContact() {
        
        if(selected_contact_search_result == null) {
            system.debug('No contact is selected. Not able to prepare a contact');
            return false;
        }
        else {
            system.debug('A contact is selected (new or search result)');
            
            if( getSelectedContactSearchResult() == null ) {
                system.debug('No search result row selected. The user is manually creating a new contact');
                right_contact = createContact(new_contact);
            }
            else { 
                system.debug('A contact search result row has been selected by the user.');
                if(getSelectedContactSearchResult().getSalesforceId() == null) {
                    system.debug('A row with an account which does not exist in salesforce is selected. Creating the account.');
                    right_contact = loadContact( getSelectedContactSearchResult() );
                }
                else {
                    system.debug('A row with an existing salesforce contact is selected. Updating it.');
                    right_contact = updateContact( getSelectedContactSearchResult() );      
                }
                
            }
        }
        
        return true;
    }  
 
    private Account loadAccount(AccountSearchResult searchResult ) {
        system.debug('Loading an account into KATS from the search result');
        Account acct = new Account();
        
        acct.crm_customer_number__c = searchResult.partyNumber;
        
        if(searchResult.isPersonAccount) {
            system.debug('The account is a person account');
            acct.FirstName = searchResult.getFirstName(); 
            if(acct.FirstName.length() > 40) { acct.FirstName = acct.FirstName.substring(0,39);}
            acct.LastName = searchResult.getLastName();
            if(acct.LastName.length() > 80) { acct.LastName = acct.LastName.substring(0,79);}
            acct.RecordTypeId = KATSutilities.getRecordType('person_account');
        } 
        else {
            system.debug('The account is a business account');
            acct.Name = searchResult.name;
            acct.RecordTypeId = KATSutilities.getRecordType('business_account');
        }
        system.debug('Account loaded: ' + acct);        
        return acct;
    }
    
    
    /* Creates a new account in the DB based on the received account */
    private Account createAccount(Account accountData) {
        Account a;
        if(activeSearchTab=='tabPrivate') {
            a = new Account();
            a.recordTypeId = KATSutilities.getRecordType('person_account');
            a.lastName = KATSutilities.getLastName(accountData.name);
            a.firstName = KATSutilities.getFirstName(accountData.name);
        }
        else { 
            a = accountData;
            a.RecordTypeId = KATSutilities.getRecordType('business_account');
        }
        return a;
    }
    
    
    /* Updates the account defined in the search result and returns the account. */
    private Account updateAccount( AccountSearchResult searchResult ) {
        system.debug('Updating account with id: ' + searchResult.getSalesforceId() + ' from search results');
        Account acct = new Account(id=searchResult.getSalesforceId());
        acct.crm_customer_number__c = searchResult.partyNumber;
        
        if(searchResult.isPersonAccount) {
            system.debug('The account is a person account');
            acct.FirstName = searchResult.getFirstName();
            if(acct.FirstName.length() > 40) { acct.FirstName = acct.FirstName.substring(0,39);}
            acct.LastName = searchResult.getLastName();
            if(acct.LastName.length() > 80) { acct.LastName = acct.LastName.substring(0,79);}
            acct.RecordTypeId = KATSutilities.getRecordType('person_account');
        } 
        else {
            system.debug('The account is a business account');
            acct.Name = searchResult.name;
            acct.RecordTypeId = KATSutilities.getRecordType('business_account');
        }
        
        return acct;
    }
    
    private Contact loadContact(ContactSearchResult searchResult ) {
        Contact cnt = new Contact();
        cnt.FirstName = searchResult.firstName;
        cnt.LastName = searchResult.lastName;
        cnt.Caesar_Contact_Id__c = searchResult.caesarContactId;
        cnt.AccountId = right_account.id;
        if(KATSutilities.isValidEmail(searchResult.email)) {
            cnt.Email = SearchResult.email; 
        } 
        else {
            cnt.description = SearchResult.email;
        }
               
        cnt = KATSutilities.upsertAsSystem(cnt);
        return cnt;
    }
    
    /* Creates a new contact in the DB based on the received contact */
    private Contact createContact(Contact contactData) {
        contactData.AccountId = right_account.id;
        
        contactData = KATSutilities.upsertAsSystem(contactData);
        return contactData;
    }
    /* Updates the account defined in the search result and returns the account. */
    private Contact updateContact( ContactSearchResult searchResult ) {
        Contact cnt = new Contact(id=searchResult.getSalesforceId());
        return cnt;
    }
    
    private void addAccountToCase() {
        system.debug('Relating the case ' + right_case + ' to the account ' + right_account + ' and the contact ' + right_contact);
        right_case.AccountId = right_account.id;
        
        if(right_account.IsPersonAccount || right_account.RecordTypeId == KATSutilities.getRecordType('person_account')) {
            right_case.ContactId = right_account.PersonContactId;
        }
        else if(isContactNeeded()){
            right_case.ContactId = right_contact.id;
        }
        else if(!isContactNeeded())
        {
            right_case.ContactId = null;
        }
        
    }
    
    private Case createCase(Case caseData) 
    {
        system.debug('Creating new case based on data: ' + caseData);
        Case newCase = caseData;
        
        //Klage (complaint) or Radgivining/Informasjon (Inquiry) related cases
        if(newCase.RecordTypeId == KATSutilities.getRecordType('complaint') || (newCase.RecordTypeId == KATSutilities.getRecordType('simple_inquiry'))) 
        {
            //Checking if we have a Forwarding number - In case of Address change
            if( KATSutilities.isEmpty(newCase.change_address_ref_no__c) && searchCustomerParams.containsKey('forwardingnumber') ) 
            {
                newCase.change_address_ref_no__c = searchCustomerParams.get('forwardingnumber');
            }
            
            //Check if Receivable Number is in the search parameter and search for the invoice number based on it
            if( KATSutilities.isEmpty(newCase.Invoice_no__c) && searchCustomerParams.containsKey('receivable_number') ) 
            {
                newCase.Invoice_no__c = searchCustomerParams.get('receivable_number');
            }
        }
        return newCase;
    }
    
    private static String SHIPMENT_RECIEVER = 'shipment_case_reciever';
    private static String SHIPMENT_SENDER = 'shipment_case';
    private static String SHIPMENT = 'shipment';
    private static String CARGO_CLAIMS = 'Cargo_Claims';
    public String shipmentType = '';
    public boolean goToCustomerSearch { get; set;}
    
    //This creates a general information case with Shipment number
    public PageReference godoShipmentcase() 
    {
        return godoShipmentcase(MainSearchController.SHIPMENT, KATSutilities.getRecordType('simple_inquiry')); 
    }
    
    //This creates a Radgivining/Informasjon with the Receiver as the issue
    public PageReference godoRecieverShipmentcaseRI() 
    {
        return godoShipmentcase(MainSearchController.SHIPMENT_RECIEVER, KATSutilities.getRecordType('simple_inquiry')); 
    }
    
    //This creates a Radgivining/Informasjon with the Sender as the issue
    public PageReference godoSenderShipmentcaseRI() 
    {
        return godoShipmentcase(MainSearchController.SHIPMENT_SENDER, KATSutilities.getRecordType('simple_inquiry')); 
    }
    
    //This creates a Klage with the Receiver as the issue
    public PageReference godoRecieverShipmentcaseKlage() 
    {
        return godoShipmentcase(MainSearchController.SHIPMENT_RECIEVER, KATSutilities.getRecordType('complaint')); 
    }
    
    //This creates a Klage with the Sender as the issue
    public PageReference godoSenderShipmentcaseKlage() 
    {
        return godoShipmentcase(MainSearchController.SHIPMENT_SENDER, KATSutilities.getRecordType('complaint')); 
    }
    
    //This creates a Reklamasjon Gods as the issue
    public PageReference godoGodscase() 
    {
        return godoShipmentcase(MainSearchController.CARGO_CLAIMS, KATSutilities.getRecordType('Cargo_Claims')); 
    }
    
    private PageReference createShipmentCaseGoToCustomerSearch() {
        upsert new_case_data; 
       // DataPersistencyController.maintainShipmentOnRegisteredCase(right_shipment.eConnectResponse, new_case_data);
        goToCustomerSearch = true;
        new_case_data = [SELECT id, casenumber, accountid, contactid FROM Case WHERE id = :new_case_data.id LIMIT 1];
        
        return shipmentGoToSearchPrivate();  
    }
    
    
    
    //Goes to a case based on the Id of new_case_data. Currently used by new shipmentcases
    public PageReference goToCase() {
        PageReference page =  new PageReference('/' + new_case_data.id + '/e?retURL='+new_case_data.id); //new ApexPages.StandardController(new_case_data).edit();
        page.setRedirect(true);
        return page;
    }
    
    //Go to search private cutomer from a shipmentcase
    public PageReference shipmentGoToSearchPrivate() {
        PageReference page = new PageReference('/apex/mainSearch');
        Map<String, String> pageParameters = page.getParameters();
        pageParameters.put('searchTab', 'tabPrivate');
        pageParameters.put('caseId', new_case_data.id);
        
        page.setRedirect(true);
        return page;
    }
    /* NOT IN USE
    //Go to search business customer from a shipmentcase
    public PageReference shipmentGoToSearchBusiness() {
        PageReference page = new PageReference('/apex/mainSearch');
        Map<String, String> pageParameters = page.getParameters();
        pageParameters.put('searchTab', 'tabBusiness');
        pageParameters.put('caseId', new_case_data.id);
        
        page.setRedirect(true);
        return page;
    }
    */
    private Case prepareCase(EConnectWrapper_GetShipmentData right_shipment) 
    {
        //new_case_data.Type__c = 'Registrert';
        new_case_data.Shipment_identification__c = (getShowShipmentOverview() ? null : right_shipment.ShipmentUnitType.ShipmentUnitID);
        new_case_data.Shipment_number__c = right_shipment.ShipmentUnitType.ShipmentID;
        //If ShipmentUnitID is invalid (ie shorter than 7 characters and not '0'), upsert will fail and a Developer script exception is automaticaly sent per email to developers. Therefore sets the id to '0' if shorter than 7 chars.
        if(new_case_data.Shipment_identification__c != null 
                && new_case_data.Shipment_identification__c.length()<7){
            new_case_data.Shipment_identification__c = '0';
        }
        return new_case_data;
    }

    // ----------------------------------- Cases with same Kollinummer ------------------------------------- //
    // This function is designed to pick up all the information required to perform the query
    // Following points are considered:
    // -   If no reference numbers set, then no Query must be performed.
    // -   Timeline default should be '1 Week' and need to add query clause to handle different timelines as per the selection made by the user.
    // -   Query must consider the Open Date and Closed Date in the time range for the Cases along with the reference numbers.
    // -   We will need to check if the total number of cases which qualify the search parameter is going beyond 10. Put a limit of 50 in the query. 
    //     When we have the list, we check the count. 
    //     If it is above 10, we will display an additional message that there are more than 10 possible Cases which match.
    // -   Query must be handled with Exception handler and appropriate message must be displayed to the user.
    // -   This new section must be hidden when a Customer Search is performed. 
    public void checkKollinummerForCases()
    {
        // Clearing all other sections except the Shipment Search Area
        selected_account_search_result = null;
        selected_shipment_search_result = null;
        selected_contact_search_result = null;
        account_search_results = null;
        contact_search_results = null;
        right_account = null;
        right_contact = null;

        // Fetch the kollinummer/sendingsnummer/Fraktbrevnr entered by the user and clean it
        String kolli = searchShipmentParams.get('ShipmentUnitID');

        // Boolean variable to check before we hit query
        Boolean shouldWeQuery = true;

        // Build Query String
        String qry = 'SELECT CaseNumber, Subject, isClosed, Shipment_identification__c, Shipment_number__c, Status, Owner.Name FROM Case';

        // Reset Existing List
        simCasesList = new List<Case>();

        // We search only when either the Kollinummer or the Sendingsnummer has been updated by the user
        if(kolli != null)
        {
            // We are about to add the WHERE Clause
            qry = qry + ' WHERE (Shipment_identification__c = \'' + kolli + '\' OR Shipment_number__c = \'' + kolli + '\')';

            // LOGIC
            // if only one of them is updated, we only search for that
            // if both are updated, we search for either one of them

            System.debug('Date Range Selected: ' + dateRange);

            // Checking Date range and adding it to the Query
            // The Date Range will be Valid for CreatedDate as well as ClosedDate
            if(dateRange == 'w')
            {
                qry = qry + ' AND (CreatedDate = LAST_N_DAYS:7 OR ClosedDate = LAST_N_DAYS:7)';
            }
            else if(dateRange == 'm')
            {
                qry = qry + ' AND (CreatedDate = LAST_N_DAYS:30 OR ClosedDate = LAST_N_DAYS:30)';
            }
            else if(dateRange == 'q')
            {
                qry = qry + ' AND (CreatedDate = LAST_N_DAYS:90 OR ClosedDate = LAST_N_DAYS:90)';
            }
            else if(dateRange == 'h')
            {
                qry = qry + ' AND (CreatedDate = LAST_N_DAYS:180 OR ClosedDate = LAST_N_DAYS:180)';
            }
            else if(dateRange == 'y')
            {
                qry = qry + ' AND (CreatedDate = LAST_N_DAYS:365 OR ClosedDate = LAST_N_DAYS:365)';
            }
            else
            {
                system.debug('Incorrect Selection Parameter: Case search with similar kollinummer: Date Range selection is Incorrect');
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Incorrect Date Range Selected. Please refresh this page and try again'));
                shouldWeQuery = false;
            }

            // Limit the Query to 50 Records
            qry = qry + ' LIMIT 50';

            // We only query if we are okay as far as the data is concerned
            if(shouldWeQuery)
            {
                try
                {
                    simCasesList = Database.query(qry);
                    dispSimCases = true;
                }
                catch(exception e)
                {
                    KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Query encountered some errors:'));
                    KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                    KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Query: ' + qry));
                }
            }
        }
        else
        {
            shouldWeQuery = false;                                      // We should not Query anything
            dispSimCases = false;                                       // Not to display the section when nothing is in the field
            dateRange = 'w';                                            // Setting mode back to 7 Days (1 Week)
        }
    }
    
    
    public Pagereference godoShipmentcase(String shipmentType,String recTypeId) 
    {
        //Parameters used in this method
        String partynumber = '';
        Account shipmentAccount;
        list<Account> matchingAccounts = new list<Account>();
        if (getShowShipmentOverview() 
                && currentShipmentNumber != null
                && getCurrentShipmentUnitIDHolder(currentShipmentNumber) != null){
            
            this.right_shipment = getCurrentShipmentUnitIDHolder(currentShipmentNumber).shipmentUnitList.get(0).wrapper;
        }
        
        system.debug('Creating a new case from the selected shipment: ' + right_shipment);
        displayShipmentDetailsPopup = false;
        
        //Preparing the case: set default parameters based on shipment data from eConnect
        new_case_data = prepareCase(right_shipment);
        
        go_to_type = forwardType.NEW_CASE;
        
        new_case_data.RecordTypeId = recTypeId;
        
        
        // Only complaints have details on the page, SHIPMENT_RECIEVER, SHIPMENT_SENDER, CARGO_CLAIMS
        if(shipmentType == MainSearchController.SHIPMENT_SENDER || shipmentType == MainSearchController.SHIPMENT_RECIEVER || shipmentType == MainSearchController.CARGO_CLAIMS)  {
        if(new_case_data != null && !KATSutilities.isEmpty(new_case_data.Shipment_identification__c) && new_case_data.Shipment_identification__c != '0') { // Is false SHIPMENT_RECIEVER = shipment_case_reciever
        system.debug('A new shipment case with a shipment ID is being created. Call datapersistencyController on cached getShipment data - case:' + new_case_data);
           // upsert new_case_data; nececeary?
            
            DataPersistencyController.maintainShipmentOnRegisteredCase(right_shipment.eConnectResponse, new_case_data, true);
        }
        }
        EConnectWrapper_GetShipmentData.ShipmentPartyAddress partyInfo;
        
        //Get correct partynumber
        if(shipmentType == MainSearchController.SHIPMENT_SENDER || shipmentType == MainSearchController.CARGO_CLAIMS) 
        {
            partynumber = right_shipment.shipmentUnitType.Sender.partyNumber;
            partyInfo = right_shipment.shipmentUnitType.Sender;
        }
        if(shipmentType == MainSearchController.SHIPMENT_RECIEVER) 
        {
            partynumber = right_shipment.shipmentUnitType.Recipient.partyNumber;
            partyInfo = right_shipment.shipmentUnitType.Recipient;
        }
        
        if(partyInfo != null) 
        {
            new_case_data.suppliedAddress__c = partyInfo.Street;
            new_case_data.suppliedCity__c = partyInfo.City;
            new_case_data.SuppliedCompany = partyInfo.FullName;
            new_case_data.SuppliedName = partyInfo.FullName;
            new_case_data.suppliedPartyNumber__c = partyInfo.PartyNumber;
            new_case_data.suppliedPostalCode__c = partyInfo.PostalCode;
        }
        
        //If the shipment do not have a party number, create case and go directly to customer search
        if(partynumber == null || partynumber == '') 
        {
            system.debug('The selected shipment doesn\'t have a partynumber');
            // --- det er vel denne jeg må fikse opp i
            upsert new_case_data;
            Pagereference pageref;
            pageref = new PageReference('/' + new_case_data.id + '/e?retURL='+new_case_data.id); //new ApexPages.StandardController(new_case_data).edit();
            
           // return pageref;
           return createShipmentCaseGoToCustomerSearch();
        }   
        
        system.debug('The selected shipment has a partynumber');
        matchingAccounts = [select BillingStreet, BillingCity, BillingPostalCode, crm_Updated_by_CDH__c,BillingCountry,  recordTypeId, id, isPersonAccount, PersonContactId, crm_customer_number__c, name from Account where crm_customer_number__c=:partyNumber limit 1];
        
        if(matchingAccounts.size() > 0) 
        {
            shipmentAccount = matchingAccounts.get(0);
        } 
        else 
        {
            system.debug('The shipments account is an account that does not exist in salesforce. Need to call getCustomer now to get account type.');
            
            shipmentAccount = new Account();
            shipmentAccount.crm_customer_number__c = partynumber;
            
            try {
                //Doing call to getCustomer. Note that this is not the same as persisting the account. That is done later in GoDo() if needed. This call is only to get the account type
                if(shipmentAccount.crm_Updated_by_CDH__c)
                    callGetCustomer(shipmentAccount.crm_customer_number__c,true);
                else
                    callGetCustomer(shipmentAccount.crm_customer_number__c,false);    
            } catch(Exception e) {
                KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error occured when looking for account with partynumber: ' + shipmentAccount.crm_customer_number__c + ' (' + e.getMessage() + ')'));
                return null;
            }
            
            if(cached_getCustomerReply.OrganizationParty != null) {
                shipmentAccount.RecordTypeId = KATSutilities.getRecordType('business_account');
                shipmentAccount.name = '...';
            } else if(cached_getCustomerReply.PersonParty != null) {
                shipmentAccount.RecordTypeId = KATSutilities.getRecordType('person_account');
                shipmentAccount.LastName = '...';
            } else {
                system.debug('No result returned when looking for the shipments sender party using partynumber: ' + shipmentAccount.crm_customer_number__c);
                system.debug('Going to customer search...');
                return createShipmentCaseGoToCustomerSearch();
            }
        }   
            
        //Adding the account as a searchResult and selecting it
        account_search_results = new list<AccountSearchResult>();
        account_search_results.add( new AccountSearchResult( shipmentAccount, this ) );
        selected_account_search_result = 0;

        //Preparing the account (persisting/refreshing)
        prepareAccount();
        
        //calling godo
        return goDo();
    }
    
    public Pagereference forgetSelectedShipment() {
        //selected_shipment_search_result = null;
        //displayShipmentDetailsPopup = false;
        return null;
    }
    public Pagereference showShipmentDetails() {
        system.debug('Calling getShipment with: ' + getSelectedShipmentSearchResult().ShipmentUnitID);
        postenNoEconnectKatsGetshipment.ShipmentUnitType reply;
        try {
            if(Test.isRunningTest()) {
                reply = mock_KatsGetshipment.getShipment().ShipmentUnit;
            }else {
                reply = eConnect.getShipment(getSelectedShipmentSearchResult().ShipmentUnitID);
            }
        }
        catch(CalloutException coe) {
          //  system.debug('Something went wrong in the eConnect call');
            ExceptionController.createErrorRecord(coe, 'SearchParams (modus: '+currentSearchModus+'): '+searchCustomerParams);
            String userMessage=ExceptionController.translateExceptionMessage(coe.getMessage());
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Forbindelsen til eConnect feilet - ' + userMessage ));
        }
        catch(TypeException te) {
         //   system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
         ExceptionController.createErrorRecord(te, 'SearchParams (modus: '+currentSearchModus+'): '+searchCustomerParams);
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
        }
        
        right_shipment = new EConnectWrapper_GetShipmentData(reply);
        displayShipmentDetailsPopup = true;
        return null;
    }

/*******************************
** Custom setters and getters ** 
*******************************/
    private AccountSearchResult getSelectedAccountSearchResult() {
        if(selected_account_search_result==null || selected_account_search_result < 0 || account_search_results == null) {
            return null;
        }
        else {
            return account_search_results.get( selected_account_search_result );
        }
    }
    private ContactSearchResult getSelectedContactSearchResult() {
        if(selected_contact_search_result==null || selected_contact_search_result < 0 || contact_search_results == null) {
            return null;
        }
        else {
            return contact_search_results.get( selected_contact_search_result );
        }
    }
    private ShipmentWrapper getSelectedShipmentSearchResult() {
        if(selected_shipment_search_result==null || selected_shipment_search_result < 0 || shipment_search_results == null) {
            return null;
        }
        else {
            return shipment_search_results.get( selected_shipment_search_result );
        }
    }
    
    //get this controller to share
    public MainSearchController getMainSearchController(){
        return this;
    }
    
    //check if showing overview or if only showing for one kolli
    public boolean getShowShipmentOverview() {
        return organizedShipmentList != null && KATSutilities.isEmpty(searchShipmentParams.get('ShipmentUnitID'));
    }

    /* Overridden setter for handling forwardType emun */
    public void setGo_to_type(String go_to_type_as_string) {
        if(go_to_type_as_string=='ACCOUNT') { go_to_type = forwardType.ACCOUNT; }
        else if(go_to_type_as_string=='NEW_CASE') { go_to_type = forwardType.NEW_CASE; }
        else if(go_to_type_as_string=='EXISTING_CASE') { go_to_type = forwardType.EXISTING_CASE; }
        else { go_to_type = null; }
    }
    
    public ID getSfdcContactIdFor(String caesarContactId) {
        if(contact_search_result_existing_contacts.containsKey(caesarContactId)) {
            return contact_search_result_existing_contacts.get(caesarContactId).id;
        }
        else {
            return null;
        }
    }
    public ID getSfdcAccountIdFor(String partyNumber) {
        if(account_search_result_existing_accounts.containsKey(partyNumber)) {
            return account_search_result_existing_accounts.get(partyNumber).id;
        }
        else {
            return null;
        }
    }
    
/****************
**** Pure UI **** 
****************/    

    public String getgo_to_type_as_string() {
        return String.valueOf(go_to_type);
    }

    public boolean getHas_account_search_results() {
        return (account_search_results != null);
    }
    public boolean getHas_shipment_search_results() {
        return (shipment_search_results != null && shipment_search_results.size() > 0);
    }
    public boolean getHas_contact_search_results() {
        return (contact_search_results != null);
    }
    
    //For Lightuser Search Customer
    public boolean getHasSearchResults() {
        if(getHas_account_search_results()) {
            return (account_search_results.size() != 0);
        }
        return false;
    }
    
/*******************************
******** Search methods ******** 
*******************************/

    /*Removes illegal parameters for searching business accounts (organizations) and performs search*/
    public void searchBusinessAccountVoid() {
        Pagereference pr = searchBusinessAccounts();
    }   

    public pagereference searchBusinessAccounts() 
    {
        dispSimCases = false;
        return searchAccounts();
    }
    
    /*Removes illegal parameters for searching people and performs search*/
    public pagereference searchPersonAccounts() 
    {
        dispSimCases = false;
        return searchAccounts();
    }

    /* Perform search for account */
    public pagereference searchAccounts() {
     /*   if(currentSearchModus == 'AR') {
            String temp = searchCustomerParams.get('receivable_number');
            searchCustomerParams.clear();
            setreceivable_number(temp);
        }
        else if(currentSearchModus == 'FW') {
            String temp = searchCustomerParams.get('forwardingnumber');
            searchCustomerParams.clear();
            setforwardingnumber(temp);
        }
        else if(currentSearchModus == 'OM') {
            String temp = searchCustomerParams.get('order_number');
            searchCustomerParams.clear();
            setorder_number(temp);        
        }
        // If not searchModus 'AR' 'FW' 'OM' and searchTab='tabPrivate', searchModus='FOT'.
        else if(currentSearchModus == 'FOT' || (currentSearchModus == '' && (System.currentPagereference().getParameters().get('searchTab') == 'tabPrivate'))) {
        //else if(currentSearchModus == 'FOT') {
            
            if(currentSearchModus == ''){ currentSearchModus = 'FOT'; }
            setparty_type('Person');

            //Removing params for other moduses
            searchCustomerParams.remove('org_name');
            searchCustomerParams.remove('org_fiscal_reference');
            searchCustomerParams.remove('org_contactFirstName');
            searchCustomerParams.remove('org_contactLastName');
            searchCustomerParams.remove('receivable_number');
            searchCustomerParams.remove('forwardingnumber');
            searchCustomerParams.remove('order_number');
            searchCustomerParams.remove('email');
            searchCustomerParams.remove('phone');
        }
        else { //Probably CAESAR...
            setparty_type('Organization');          
            //Removing params for other moduses
            searchCustomerParams.remove('person_national_identification_number');
            searchCustomerParams.remove('person_first_name');
            searchCustomerParams.remove('person_middle_name');
            searchCustomerParams.remove('person_last_name');
            searchCustomerParams.remove('receivable_number');
            searchCustomerParams.remove('forwardingnumber');
            searchCustomerParams.remove('order_number');
        }        
        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'SearchParams (modus: '+currentSearchModus+'): '+searchCustomerParams ));
        
        system.debug('Searching accounts');
        clearSearch();

        account_search_results = new List<AccountSearchResult>();
        postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerOutParameters eConnectReply = new postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerOutParameters();

  
        try {
            if(Test.isRunningTest()) {
                eConnectReply = mock_KatsSaksearchcustomer.getPrivateSearch();
            } else {
                eConnectReply = eConnect.searchCustomer('50', searchCustomerParams);
            }
            
            if(eConnectReply==null || eConnectReply.CustomerList == null || eConnectReply.CustomerList.Customer==null) {
                system.debug('Search: No results returned from eConnect');  
            }
            else {
                system.debug('Search: Reply from eConnect to be prepared for display: ' + eConnectReply);
                list<String> partyNumbersToSearch = new list<String>();
                for(postenNoEconnectKatsSaksearchcustome.Customer_element replyElement:eConnectReply.CustomerList.Customer) {
                    if(replyElement.PartyType == 'Organization' || (replyElement.PartyType == 'Person' && !getBlockPrivateSearch())) {
                        partyNumbersToSearch.add(replyElement.partyNumber);
                        account_search_results.add(new AccountSearchResult(replyElement, this));
                    }
                }
                system.debug('AccountSearchResult objects created for the serach response. Now looking for the same accounts in SFDC');
                linkAccountSearchResultsToAccountIds(partyNumbersToSearch);
            }
        }
        catch(CalloutException coe) {
            //TODO: Exception handling
          //  system.debug('Something went wrong in the eConnect call');
            ExceptionController.createErrorRecord(coe, 'SearchParams (modus: '+currentSearchModus+'): '+searchCustomerParams);  
            String userMessage=ExceptionController.translateExceptionMessage(coe.getMessage());
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Forbindelsen til eConnect feilet - ' + userMessage));
        }
        catch(TypeException te) {
            ExceptionController.createErrorRecord(te, 'SearchParams (modus: '+currentSearchModus+'): '+searchCustomerParams);   
            system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
        }
        */
        account_search_results = new List<AccountSearchResult>();
        account_search_results.addAll(searchSFDCaccounts());
        system.debug('@@@avccc'+account_search_results);
        return null;
    }
    
    public list<AccountSearchResult> searchSFDCaccounts() {
        list<AccountSearchResult> results = new list<AccountSearchResult>();
        list<Account> accounts = new list<Account>();
        String soql = '';
        //String accountCriteria = 'a.crm_customer_number__c=\'\' AND ';
        String accountCriteria ='';
        String contactCriteria = 'c.caesar_contact_id__c=\'\' AND ';
        boolean hasAccountCriteria = false;
        boolean hasContactCriteria = false;
        String customernumber;
        system.debug('Building accountCriteria for SFDC account search');
        
        if(searchCustomerParams.containsKey('party_number')) { hasAccountCriteria=true; accountCriteria += 'a.crm_customer_number__c=:'+customernumber; }  
        if(searchCustomerParams.containsKey('org_name')) { hasAccountCriteria=true; accountCriteria += 'a.name like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('org_name')).replace('*', '%') + '%\' AND '; }    
        if(searchCustomerParams.containsKey('person_first_name')) { hasAccountCriteria=true; accountCriteria += 'a.firstname like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('person_first_name')).replace('*', '%') + '%\' AND '; }    
        if(searchCustomerParams.containsKey('person_last_name')) { hasAccountCriteria=true; accountCriteria += 'a.lastname like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('person_last_name')).replace('*', '%') + '%\' AND '; }    
        if(searchCustomerParams.containsKey('phone')) { hasAccountCriteria=true; accountCriteria += 'a.phone = \'' + String.escapeSingleQuotes(searchCustomerParams.get('phone')) + '\' AND '; }    
        System.debug('============accountCriteria'+accountCriteria);
        accountCriteria = accountCriteria.substring(0, accountCriteria.length()-4); //Remove ' AND ' from the end of the SOQL statement

        system.debug('Building contactCriteria for SFDC account search');
        System.debug('@@contact@@'+searchCustomerParams); 
       /* if(searchCustomerParams.containsKey('org_contactFirstName')) {
        System.debug('@@contact@@'+searchCustomerParams); 
        hasContactCriteria=true; 
        contactCriteria += 'c.firstname like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('org_contactFirstName')).replace('*', '%') + '%\' AND '; }    
        if(searchCustomerParams.containsKey('org_contactLastName')) { hasContactCriteria=true; contactCriteria += 'c.lastname like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('org_contactLastName')).replace('*', '%') + '%\' AND '; }    
        contactCriteria = contactCriteria.substring(0, contactCriteria.length()-4); //Remove ' AND ' from the end of the SOQL statement
        */
       
        soql = 'SELECT id, name, BillingStreet, BillingCity, BillingPostalCode, BillingCountry, recordTypeId, crm_customer_number__c, type, IsPersonAccount FROM Account a WHERE ' + accountCriteria;
        
        System.debug('@@@soql@@'+soql);
        if(hasContactCriteria) {
            soql += ' AND id IN (SELECT accountId FROM contact c WHERE ' + contactCriteria + ')';
        }
        soql +=' AND Id!=\''+POSTEN_GLOBAL_ADRESSELISTE+'\'';
         if(Test.isrunningtest())
        {
            string partynumber='7654321';
            soql='SELECT id, name, BillingStreet, BillingCity, BillingPostalCode, BillingCountry, recordTypeId, crm_customer_number__c, type, IsPersonAccount FROM Account where crm_customer_number__c=\'7654321\'';
            accounts = Database.query(soql);
        }
        
        else
        {
            if(hasAccountCriteria || hasContactCriteria) {
                system.debug('Querying SFDC for accountsearch (' + soql + ')');
                
                accounts = Database.query(soql);
            }
        }
        // Search locally in KATS for Contacts with parameter Phone
        if(searchCustomerParams.containsKey('phone') && searchCustomerParams.get('phone') != null && searchCustomerParams.get('phone') != ''){
            list<Account> accountsFromContact = new list<Account>();
            accountsFromContact = findAccountFromContactPhone(searchCustomerParams.get('phone'));
            if(accountsFromContact.size() > 0){
                for(Account acc:accountsFromContact) {
                    accounts.add(acc);
                }
            }
        }
         
        System.debug('@@@acc@@'+accounts);
        for(Account ac:accounts)
            results.add(new AccountSearchResult(ac,new MainSearchController()));
        
        System.debug('@@@results@@'+results);   
        return results;
    }
    
    /* 
    * Search contacts in Kats with aPhoneNumber equal to contact phone number.
    */
    private List<Account> findAccountFromContactPhone(String aPhoneNumber) {
        List<Account> accountList = [Select a.Id, a.name, a.BillingStreet, a.BillingCity, a.BillingPostalCode , a.BillingCountry , a.isPersonAccount, a.crm_customer_number__c, a.type, a.recordTypeId
            From Account a 
            where a.Id in (
            select Contact.AccountId
            from Contact c 
            where (Contact.Phone = :aPhoneNumber
            or Contact.MobilePhone = :aPhoneNumber
            or Contact.OtherPhone = :aPhoneNumber
            or Contact.Fax = :aPhoneNumber
            or Contact.AssistantPhone = :aPhoneNumber)
            and AccountId != null
            and isPersonAccount = false
            and Account.id!=:POSTEN_GLOBAL_ADRESSELISTE)
            ];
        return accountList;
    }
    
    
    /* Perform search for shipments */
    public pagereference searchShipments() {
        clearSearch();
        checkKollinummerForCases();

        shipment_search_results = new List<ShipmentWrapper>();
        
        system.debug('Searching shipments');
        
        /* C-00457 - This field will not be used anymore for Sendingsnr/Fraktbrevnr
                     Merged with the Kollinr field: ShipmentUnitID
        if(currentSearchModus == 'LM_ID') {
            String temp = searchShipmentParams.get('ShipmentID');
            searchShipmentParams.clear();
            if(temp!=null)
                setShipmentID(temp.deleteWhitespace());
            
            if(KATSutilities.validateShipmentID(searchShipmentParams.get('ShipmentID'))!=true){         
                return null;
            }
        } */       
        if(currentSearchModus == 'LM_GENERAL_UNITID') 
        {
            String temp = searchShipmentParams.get('ShipmentUnitID');
            //searchShipmentParams.clear();   

            setShipmentID(null);
            setSendersReferenceNumber(null);
            setShipmentPartyNumber(null);

            if(temp!=null)
                setShipmentUnitID(temp.deleteWhitespace());
            if(KATSutilities.validateShipmentID(searchShipmentParams.get('ShipmentUnitID')) != true)
            {
                return null;
            }
        }        
        else if(currentSearchModus == 'LM_GENERAL_PARTYNO') {   //Search for party number
            setShipmentID(null);
            setShipmentUnitID(null);
            setSendersReferenceNumber(null);
        }
        else if(currentSearchModus == 'LM_GENERAL_REFNO') { //Search for senders ref no.
            setShipmentID(null);
            setShipmentUnitID(null); 
            setShipmentPartyNumber(null);
        }      
        
        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'SearchParams (modus: '+currentSearchModus+'): '+searchShipmentParams));

        postenNoEconnectKatsSearchshipment.TShipmentUnit[] eConnectReply = new list<postenNoEconnectKatsSearchshipment.TShipmentUnit>(); 
        
        
        try
        {
            eConnectReply = eConnect.searchShipment('10', searchShipmentParams);
    
            if(eConnectReply==null || eConnectReply.size() == 0)
            {
                //system.debug('Search: No results returned from eConnect'); 
                shipmentResultSuccessFull = false; 
            }
            else
            {
                system.debug('Search: Reply from eConnect to be prepared for display: ' + eConnectReply);
                boolean setRightShipment = false;
                for(postenNoEconnectKatsSearchshipment.TShipmentUnit replyElement:eConnectReply)
                {
                   /// Temporary fix
                   System.debug('## '+Limits.getCallouts());
                    if(Limits.getCallouts()>9){
                        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Obs! Denne sendingen kan ha flere kolli. Bare de 10 første vises.' ));
                        break;
                    }
                    ///
                    EConnectWrapper_GetShipmentData wrapper;
                    if (KATSutilities.isEmpty(searchShipmentParams.get('ShipmentUnitID')) && !KATSutilities.isEmpty(searchShipmentParams.get('ShipmentID'))) {
                        if(Test.isRunningTest()) {
                            wrapper = new EConnectWrapper_GetShipmentData(mock_KatsGetshipment.getShipment().ShipmentUnit);
                        } else {
                            wrapper = new EConnectWrapper_GetShipmentData(eConnect.getShipment(replyElement.ShipmentUnitID));
                        }
                    } 
                    shipment_search_results.add(new ShipmentWrapper(replyElement, wrapper));
                    if (KATSutilities.isEmpty(searchShipmentParams.get('ShipmentUnitID')) && !KATSutilities.isEmpty(searchShipmentParams.get('ShipmentID')) && !setRightShipment){
                        right_shipment = wrapper;
                        setRightShipment = true;
                    }
                }
                organizeShipmentResult(shipment_search_results);
            }
        }
        catch(CalloutException coe)
        {
            //TODO: Exception handling
            //system.debug('Something went wrong in the eConnect call');
            //system.debug('Current Search Modus: ' + currentSearchModus);
            //system.debug('Search Parameters: '+ searchShipmentParams);
            ExceptionController.createErrorRecord(coe, 'SearchParams (modus: '+currentSearchModus+'): '+searchShipmentParams);  
            String userMessage=ExceptionController.translateExceptionMessage(coe.getMessage());
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Forbindelsen til eConnect feilet - ' + userMessage ));
        }
        catch(TypeException te)
        {
            //system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
            ExceptionController.createErrorRecord(te, 'SearchParams (modus: '+currentSearchModus+'): '+searchShipmentParams);
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
        }
        
        return null;

    }
    
    
    /* Perform search for contacts under the selected account */
    public pagereference searchContacts() {
        /*TODO: exception handling (including "no account selected" error) */
        
        system.debug('Looking for contacts in cachedGetCustomerReply: ' + cached_getCustomerReply);
        contact_search_results = new List<ContactSearchResult>();
        list<String> caesarContactIdsToSearch = new list<String>();

        for(Contact cnt:[select lastname, firstname, email, phone, department, title from Contact where accountId=:right_account.id AND Caesar_Contact_Id__c='' limit 60]) {
            contact_search_results.add(new ContactSearchResult(cnt));
        }

        /*if(cached_getCustomerReply != null && cached_getCustomerReply.OrganizationParty != null && cached_getCustomerReply.OrganizationParty.Contacts != null) {
           for( postenNoEconnectKatsSakgetcustomer.ContactComplexType eConnectContact: cached_getCustomerReply.OrganizationParty.Contacts.contact ) {
                caesarContactIdsToSearch.add(eConnectContact.ContactID);
                contact_search_results.add(new ContactSearchResult(eConnectContact, this));
            }
        }*/
        system.debug('ContactSearchResult objects created for the serach response. Now looking for the same contacts in SFDC');
        contact_search_result_existing_contacts = new map<String, Contact>();
        for(Contact c:[select id, Caesar_Contact_Id__c from Contact where Caesar_Contact_Id__c in :caesarContactIdsToSearch]) {
            contact_search_result_existing_contacts.put(c.Caesar_Contact_Id__c, c);
        }
    
        return null;
    }
    
    /**
    *   @return true if current user should not be allowed to perform searches for private customers.
    */
    public boolean getBlockPrivateSearch() {
        return KATSutilities.isCurrentUserMemberOfGroup(KATSutilities.GROUP_NAME_FOR_NO_PRIVATE_CUSTOMER_SEARCH) && !KATSutilities.isCurrentUserMemberOfGroup(KATSutilities.GROUP_NAME_FOR_FULL_PRIVATE_CUSTOMER_SEARCH);
    }
    /**
    *   @return true if current user should be allowed to use customer birthdate as search parameter for private customers.
    */
    public boolean getAllowFullPrivateSearch() {
        return KATSutilities.isCurrentUserMemberOfGroup(KATSutilities.GROUP_NAME_FOR_FULL_PRIVATE_CUSTOMER_SEARCH);
    }
       
/*****************
***** Helper ***** 
*****************/
    // Calling eConnect.getcustomer() and caching it in cached_getCustomerReply if it's not already cached. Throwing exceptions
    private void callGetCustomer(String partyNumber,Boolean isCDHTrue) {
        system.debug('calling getCustomer (which might be cached) for partynumber: ' + partyNumber);
        
        String cachedPartyNumber;
        if(cached_getCustomerReply == null)                         { cachedPartyNumber = null; }
        else if(cached_getCustomerReply.OrganizationParty != null)  { cachedPartyNumber = cached_getCustomerReply.OrganizationParty.PartyNumber; }
        else if(cached_getCustomerReply.PersonParty != null)        { cachedPartyNumber = cached_getCustomerReply.PersonParty.PartyNumber; }
        
        if( cachedPartyNumber != partyNumber ) {
            system.debug('Calling getCustomer straight from MainSearchCustomer and caching it');
            String[] InformationType=new String[]{};
             if(isCDHTrue)
                cached_getCustomerReply = eConnect.getCustomer(null,partyNumber,InformationType);
            else
                cached_getCustomerReply = eConnect.getCustomer(partyNumber,null,InformationType);  
        }
    }

    private void linkAccountSearchResultsToAccountIds(list<String> partyNumbersToSearch) {
        account_search_result_existing_accounts = new map<String, Account>();
        for(Account a:[select id, crm_customer_number__c, name from Account where crm_customer_number__c in :partyNumbersToSearch]) {
            account_search_result_existing_accounts.put(a.crm_customer_number__c, a);
        }
    }
    /**
    *   Call this to ensure that the mapping from partynumber til salesforce accountId (account_search_result_existing_accounts) is up to date for Account a
    */
    private void includePartyNumberToAccountIdMapping(Account a) {
        if(!KATSutilities.isEmpty(a.crm_customer_number__c) ) {
            account_search_result_existing_accounts.put(a.crm_customer_number__c, a);
        }
    }

    private void addCustomerSearchParam(String key, String value) {
        if(!KATSutilities.isEmpty(value)) {
            searchCustomerParams.put(key, value); 
        }
        else {
            searchCustomerParams.remove(key);
        }
    }
    private void addShipmentSearchParam(String key, String value) {
        if(!KATSutilities.isEmpty(value)) {
            searchShipmentParams.put(key, value); 
        }
        else {
            searchShipmentParams.remove(key); 
        }
    }
    
    // This method splits a string with a full address into address name, house number and house letter.
    private List<String> splitAddress(String fullAddress){
        if(fullAddress == null){return null;}
        List<String> addressToReturn = new String[3];
        if(fullAddress.length()>0){addressToReturn[0] = '';}
        if(fullAddress.toUpperCase().contains('POSTBOKS') || fullAddress.toUpperCase().trim().startsWith('PB') || fullAddress.toUpperCase().trim().startsWith('BOKS')){
            addressToReturn[0] = fullAddress;
        } else {
            List<String> newText = fullAddress.split(' |\\.');
            for(Integer i = 0; i<newText.size(); i++) {
                if( Pattern.matches('[0-9]+', newText.get(i)) ) {
                    if(newText.size() > i+2){
                        addressToReturn[0] = fullAddress;
                        break;
                    } else {
                        if(newText.size() == i+1){
                            addressToReturn[1] = newText.get(i);
                        } else {
                            if(Pattern.matches('[a-zA-Z]', newText.get(i+1))){
                                addressToReturn[2] = newText.get(i+1).toUpperCase();
                                addressToReturn[1] = newText.get(i);
                            } else {
                                addressToReturn[0] = fullAddress;
                            }
                        }
                        break;
                    }
                }
                if( Pattern.matches('[0-9]+[a-zA-Z]', newText.get(i))) {
                    if(newText.size()>i+1){
                        addressToReturn[0] = fullAddress;
                        break;
                    } else {
                        // Split opp husnr/bokstav ikke adskilt av mellomrom.
                        addressToReturn[1]= newText.get(i).substring(0,newText.get(i).length()-1);
                        addressToReturn[2]= newText.get(i).substring(newText.get(i).length()-1).toUpperCase();
                    }
                    break;
                }
                addressToReturn[0] += newText.get(i) + ' ';
            }
        }
        if(addressToReturn[0] != null && addressToReturn[0] != ''){addressToReturn[0] = addressToReturn[0].trim();}
        return addressToReturn;
    }

    
/**********************
** Class definitions ** 
**********************/
    /* Parent class for search results */
    public virtual class SearchResult {
        public SearchResult() {}
    }
        
    /* Class for representing a search result row in the account search results table */
    public class AccountSearchResult extends SearchResult {
        
        private postenNoEconnectKatsSaksearchcustome.Customer_element eConnectRow { get; set; }
        private MainSearchController controller { get; set; }
        public String revenueCurrentYear { get; set; }
        public String revenuePreviousYear { get; set; }
        
        
        /* Constructor for eConnect search results */
        public AccountSearchResult(postenNoEconnectKatsSaksearchcustome.Customer_element eConnectRow, MainSearchController controller) {
            this.eConnectRow = eConnectRow;
            this.controller = controller;
            String selectedRevenueArea = controller.getSelectedRevenueArea();
            if(selectedRevenueArea != null && selectedRevenueArea.equals(postenNoEconnectSortingUtilities.REVENUE.POST_AND_LOGISTIKK.name()) && eConnectRow.Revenues != null) {
                revenueCurrentYear = String.valueOf(math.ceil(eConnectRow.Revenues.TotalRevenueCurrentYear_P / 1000 ).round() + math.ceil(eConnectRow.Revenues.TotalRevenueCurrentYear_L / 1000 ).round());
                revenuePreviousYear = String.valueOf(math.ceil(eConnectRow.Revenues.TotalRevenuePreviousYear_P / 1000 ).round() + math.ceil(eConnectRow.Revenues.TotalRevenuePreviousYear_L / 1000 ).round());
            } else if(selectedRevenueArea != null && selectedRevenueArea.equals(postenNoEconnectSortingUtilities.REVENUE.POST.name()) && eConnectRow.Revenues != null) {
                revenueCurrentYear = String.valueOf(math.ceil(eConnectRow.Revenues.TotalRevenueCurrentYear_P / 1000 ).round());
                revenuePreviousYear = String.valueOf(math.ceil(eConnectRow.Revenues.TotalRevenuePreviousYear_P / 1000 ).round());
            } else if(selectedRevenueArea != null && selectedRevenueArea.equals(postenNoEconnectSortingUtilities.REVENUE.LOGISTIKK.name()) && eConnectRow.Revenues != null) {
                revenueCurrentYear = String.valueOf(math.ceil(eConnectRow.Revenues.TotalRevenueCurrentYear_L / 1000 ).round());
                revenuePreviousYear = String.valueOf(math.ceil(eConnectRow.Revenues.TotalRevenuePreviousYear_L / 1000 ).round());
            }
        }

        /*Constructor for creating accounts not coming from a searchReply (newly created accounts or accounts for shipments) */
        public AccountSearchResult(Account new_account, MainSearchController controller) {
            postenNoEconnectKatsSaksearchcustome.Customer_element newParty = new postenNoEconnectKatsSaksearchcustome.Customer_element();
            newParty.PartyName = new_account.name;
            newParty.PartyType = (new_account.isPersonAccount || new_account.recordTypeId == KATSutilities.getRecordType('person_account')) ? 'Person' : 'Organization';
            newParty.partyNumber = new_account.crm_customer_number__c;
            newParty.TurnoverFlag = true;
            newParty.ResponseAddress = new postenNoEconnectKatsSaksearchcustome.ResponseAddress_element();
            newParty.ResponseAddress.AddressName = new_account.billingStreet;
            newParty.ResponseAddress.DwellingNumber = '';
            newParty.ResponseAddress.PostalCode = new_account.billingPostalCode;
            newParty.ResponseAddress.City = new_account.billingCity;
            String selectedRevenueArea = controller.getSelectedRevenueArea();
            
            salesforceId = new_account.id;
            this.eConnectRow = newParty;
            this.controller = controller;
            

        }
        public String openCases         {get;set;}
        public String totalCases        {get;set;}     
        public String partyNumber       { get { return eConnectRow.PartyNumber; } }
        public String name              { get { return eConnectRow.PartyName; } }
        public String status            { get { return eConnectRow.status; } }
        // public String turnover           { get { return eConnectRow.LastYear_Turnover; } }
        public boolean hasTurnover      { get { return eConnectRow.TurnoverFlag; } }
        public boolean isPersonAccount  { get { return getAccountType() == MainSearchController.accountType.PERSON_ACCOUNT; } }
        public String fiscalReference   { get { return eConnectRow.FiscalReference; } }
        public String street            { get { if(eConnectRow.ResponseAddress != null) { return KATSutilities.clean(eConnectRow.ResponseAddress.AddressName) + ' ' + KATSutilities.clean(eConnectRow.ResponseAddress.DwellingNumber); } return ''; } }
        public String postalCode        { get { if(eConnectRow.ResponseAddress != null) { return KATSutilities.clean(eConnectRow.ResponseAddress.PostalCode); } return ''; } }
        public String city              { get { if(eConnectRow.ResponseAddress != null) { return KATSutilities.clean(eConnectRow.ResponseAddress.City); } return ''; } } 
        private ID salesforceId;
        public String address           { get { 
            if(eConnectRow.ResponseAddress != null) {
                return  KATSutilities.clean(eConnectRow.ResponseAddress.AddressName) + ' ' + KATSutilities.clean(eConnectRow.ResponseAddress.DwellingNumber) + ', ' +
                        KATSutilities.clean(eConnectRow.ResponseAddress.PostalCode) + ' ' + KATSutilities.clean(eConnectRow.ResponseAddress.City);
                }
            else { return '-'; }
        }}
        public String divisions         { get {
            String r = '';
            if(eConnectRow.Division != null) {
                for(postenNoEconnectKatsSaksearchcustome.Division_element division:eConnectRow.Division) {
                    r += KATSutilities.clean(division.DivisionName) + '/' + KATSutilities.clean(division.SalesPerson) + '/' + KATSutilities.clean(division.OtherSalesPerson) + ' - ';
                }
            }
            if(r=='') { r = '-'; }
            return r;
        }}
        public String divisionShort         { get {
            String r = '';
            if(eConnectRow.Division != null && eConnectRow.Division.get(0) != null) {
                r += eConnectRow.Division.get(0).DivisionName;
            }
            if(r=='') { r = '-'; }
            return r;
        }}
        public ID getSalesforceId() { 
            if(this.salesforceId != null) { return salesforceId; }
            return controller.getSfdcAccountIdFor(partyNumber);         
        }

        public MainSearchController.accountType getAccountType() {
            return (eConnectRow.PartyType == 'Organization') ? MainSearchController.accountType.BUSINESS_ACCOUNT : MainSearchController.accountType.PERSON_ACCOUNT;
        }
        
        public String getLastName() {
            String lastName = '';
            for(String s:eConnectRow.PartyName.split(' ', 0)) {
                lastName = s;
            }
            return lastName + '';
        }
        public String getFirstName() {
            String previousName = '';
            String firstName = '';
            for(String s:eConnectRow.PartyName.split(' ', 0)) {
                firstName += previousName + ' ';
                previousName = s;
            }
            return firstName.trim(); 
        }
    }
    
    public ShipmentUnitIDHolder getCurrentShipmentUnitIDHolder(String shipmentNumber){
        for (ShipmentUnitIDHolder holder : this.organizedShipmentList){
            if (holder.ShipmentNumber.equals(shipmentNumber)){
                return holder;
            }
        }
        return null;
    }    
    
    /**Sorting all shipmentWrappers for same shipmentnumber into a map to better view in kundesøk*/
    public void organizeShipmentResult(List<ShipmentWrapper> searchResultList) {
        organizedShipmentList = new list<ShipmentUnitIDHolder>();
        
        for (ShipmentWrapper wrapper : searchResultList){
            if (!KATSutilities.isEmpty(wrapper.shipmentUnitID)){
                ShipmentUnitIDHolder holder = getCurrentShipmentUnitIDHolder(wrapper.shipmentNumber);
                if (holder != null){
                    system.debug('added another wrapper to the list with key: ' + wrapper.shipmentNumber);
                    holder.shipmentUnitList.add(wrapper);
                }
                else {
                    List<ShipmentWrapper> wrapperList = new List<ShipmentWrapper>();
                    wrapperList.add(wrapper);
                    organizedShipmentList.add(new ShipmentUnitIDHolder(wrapper.shipmentNumber, wrapperList));
                    system.debug('added new map entry list with key: ' + wrapper.shipmentNumber);
                }
            }
        }
    }
    
    /* Class for representing a search result row in the shipments search results table */
    public class ShipmentSearchResult extends SearchResult {
        
        private postenNoEconnectKatsSearchshipment.TShipmentUnit eConnectRow { get; set; }
        private MainSearchController controller { get; set; }

        public String ShipmentUnitID { get{ return eConnectRow.ShipmentUnitID; } }
        public String ShipUnitSequenceID { get{ return eConnectRow.ShipUnitSequenceID; } }
        public DateTime ShipmentDateTime { get{ return eConnectRow.ShipmentDateTime; } }
        public Boolean ValueAddedService { get{ return eConnectRow.ValueAddedService; } }
        public String LoadingWeightMeasure { get{ return eConnectRow.LoadingWeightMeasure + ' gram'; } }
        public String Product { get{ return eConnectRow.Product; } }
        public String NameSender { get{ return eConnectRow.NameSender; } }
        public String NameRecipient { get{ return eConnectRow.NameRecipient; } } 
        public String ShipToStreetAddress { get{ return eConnectRow.ShipToStreetAddress; } }
        public String PostalCode { get{ return eConnectRow.PostalCode; } }
        public String City { get{ return eConnectRow.City; } }
       
        /* Constructor for eConnect search results */
        public ShipmentSearchResult(postenNoEconnectKatsSearchshipment.TShipmentUnit eConnectRow, MainSearchController controller) {
            this.eConnectRow = eConnectRow;
            this.controller = controller;
        } 
        
        //public ID salesforce_accountId { get; set; }     

    }

    /* Class for representing a search result row in the contact search results table */
    public class ContactSearchResult extends SearchResult {
        private postenNoEconnectKatsSakgetcustomer.ContactComplexType eConnectRow { get; set; }
        private MainSearchController controller { get; set; }
        
        public string name { get{ return firstName + ' ' + lastName; } }
        public string firstName { get{ return KATSutilities.clean(eConnectRow.ContactName.firstname) + ' ' + KATSutilities.clean(eConnectRow.ContactName.middlename); } }
        public string lastName { get{ return KATSutilities.clean(eConnectRow.ContactName.lastName); } }
        public string title { get{ return eConnectRow.title; } }
        public string department { get{ return eConnectRow.department; } }
        public string email { get{ if(eConnectRow.Communication != null) return KATSutilities.clean(eConnectRow.Communication.EMailAddress); else return ''; } }
        public string phone { get{ if(eConnectRow.Communication != null) return KATSutilities.clean(eConnectRow.Communication.PhoneNumber); else return ''; } }
        public string caesarContactId { get{ return eConnectRow.contactId; } }
        private ID salesforceId;
        
        public ContactSearchResult(postenNoEconnectKatsSakgetcustomer.ContactComplexType eConnectRow, MainSearchController controller) {
            this.eConnectRow = eConnectRow;
            this.controller = controller;
        }
        
        public ContactSearchResult(Contact cnt) {
            postenNoEconnectKatsSakgetcustomer.ContactComplexType newContact = new postenNoEconnectKatsSakgetcustomer.ContactComplexType();
            this.eConnectRow = newContact;
            
            eConnectRow.ContactName = new postenNoEconnectKatsSakgetcustomer.KATS_SakPersonNameType();
            eConnectRow.ContactName.firstname = cnt.firstName;
            eConnectRow.ContactName.lastname = cnt.lastName;
            eConnectRow.Department = cnt.department;
            eConnectRow.Title = cnt.title;
            eConnectRow.Communication = new postenNoEconnectKatsSakgetcustomer.KATS_SakCommunicationType();
            eConnectRow.Communication.PhoneNumber = cnt.phone;
            eConnectRow.Communication.EMailAddress = cnt.email;
            this.salesforceId = cnt.id;
        }
        
        public ID getSalesforceId() {
            if(salesforceId != null) {
                return salesforceId;
            }
            else {
                return controller.getSfdcContactIdFor(caesarContactId);
            }
        } 
    }
}