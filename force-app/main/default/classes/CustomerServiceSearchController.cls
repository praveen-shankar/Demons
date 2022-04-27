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
*/

/*

Changed how search results from SF and eConnect are merged.
SF is master.
If clicked record is of type mail recipient it is updated when clicked.

Divisions are not updated.
Contacts should not be updated.

If one of these are true, then account should not be updated by the customer search
crm_Updated_by_CDH__c
Not used:
crm_Updated_by_FKB__c
crm_Account_Updated__c
crm_Account_Inserted__c

*/
// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
public with sharing class CustomerServiceSearchController {

    /* Enum definitions */
    public enum searchAspectType {PRIVATE_SEARCH, BUSINESS_SEARCH, SHIPMENT_SEARCH}
    public enum accountType {BUSINESS_ACCOUNT, PERSON_ACCOUNT, UNKNOWN}
    public enum forwardType {NEW_CASE, ACCOUNT, EXISTING_CASE}

public  PageReference pageref{set;get;}

    /* Search params - searchCustomer */
    private map<String, String> searchCustomerParams = new map<String, String>();
    //added as part of contact CR - C-07430
    //Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
  
  
  
    public String getSelectedRevenueArea() { return searchCustomerParams.get('selectedRevenueArea'); }
    public void setSelectedRevenueArea(String s) { addCustomerSearchParam('selectedRevenueArea', s); } 
    public String getorg_name() { return searchCustomerParams.get('org_name'); }
    public void setorg_name(String s) { addCustomerSearchParam('org_name', s); }
    public String getorg_fiscal_reference() { return searchCustomerParams.get('org_fiscal_reference'); }
    public void setorg_fiscal_reference(String s) { addCustomerSearchParam('org_fiscal_reference', s); }  
    public String getorg_contactName() { return searchCustomerParams.get('org_contactName'); } 
    public void setorg_contactName(String s) { addCustomerSearchParam('org_contactName', s); }
    public String getperson_first_name() { return searchCustomerParams.get('person_first_name'); }
    public void setperson_first_name(String s) { addCustomerSearchParam('person_first_name', s); }
    public String getperson_last_name() { return searchCustomerParams.get('person_last_name'); }
    public void setperson_last_name(String s) { addCustomerSearchParam('person_last_name', s); }
    public String getperson_full_name() {return searchCustomerParams.get('person_full_name'); }
    public void setperson_full_name(String s) { addCustomerSearchParam('person_full_name', s); } 
    public String getperson_national_identification_number() { return searchCustomerParams.get('person_national_identification_number'); }
    public void setperson_national_identification_number(String s) { if(getAllowFullPrivateSearch()) { addCustomerSearchParam('person_national_identification_number', s);}  }
    public String getaddress_city() { return searchCustomerParams.get('address_city'); }
    public void setaddress_city(String s) { addCustomerSearchParam('address_city', s); }
    public String getaddress_house_number() { return searchCustomerParams.get('address_house_number'); }
    public void setaddress_house_number(String s) { addCustomerSearchParam('address_house_number', s); }
    public String getaddress_house_letter() { return searchCustomerParams.get('address_house_letter'); }
    public void setaddress_house_letter(String s) { addCustomerSearchParam('address_house_letter', s); }
  //  public String getaddress_po_box_number() { return searchCustomerParams.get('address_po_box_number'); }
  //  public void setaddress_po_box_number(String s) { addCustomerSearchParam('address_po_box_number', s); }
    public String getaddress_postal_code() { return searchCustomerParams.get('address_postal_code'); }
    public void setaddress_postal_code(String s) { addCustomerSearchParam('address_postal_code', s); }
    public String getemail() { return searchCustomerParams.get('email'); }
    public void setemail(String s) { addCustomerSearchParam('email', s); }
    public String getphone() { return searchCustomerParams.get('phone'); }
    public void setphone(String s) {addCustomerSearchParam('phone', s); }
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

    public postenNoEconnectUtilities eConnect { get; set; } 
    private postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType cached_getCustomerReply; // New integration class for mapping response
    private String startSearch;
    public string currentModus{get;set;}
    public Boolean hasduplicate{get;set;}

    // Fields for Case search with same Kollinummer (Package Number) : C-02644
    public Boolean dispSimCases {get; set;}
    public Boolean personSearch{get; set;}                      // Controls the visibility of the section
    public List<Case> simCasesList {get; set;}                  // Holds the search result
    public String dateRange {get; set;}                         // This will hold codes for the Date range to search the Cases from: w - 1 Week, m - 1 month, q - 1 Quarter, h - Half Year, y - 1 Year
    public static string POSTEN_GLOBAL_ADRESSELISTE=KATSutilities.getGlobalAddressListName(); // This account is used for internal addresses and should not appear in search results
    public Boolean lightuser{get;set;}
    /**
     * Constructor. Sets up default search values and prepares state variables
     If the page is accessed from the Case link, the CaseID is also sent as a parameter
     */
    public CustomerServiceSearchController() {
        
        // Variables pased as URL parameters
        String caseId = System.currentPagereference().getParameters().get('caseId');   
        String phoneNumber = System.currentPagereference().getParameters().get('phone'); 
        String defaultSearchTab = System.currentPagereference().getParameters().get('searchTab');   // (optional) 'tabPrivate' || 'tabBusiness' || 'tabShipment' 
        startSearch = System.currentPagereference().getParameters().get('startSearch');
         
        setSelectedRevenueArea(postenNoEconnectSortingUtilities.REVENUE.POST_AND_LOGISTIKK.name());
        
        if(caseId != null) {
            system.debug('URL param "CaseId" provided as URL parameter. Getting case object from DB. Id: ' + caseId);
            right_case = [select Shipment_identification__c, Account.Name, Account.isPersonAccount, Account.crm_customer_number__c,id, CaseNumber, Subject, SuppliedCompany, SuppliedEmail, SuppliedName, SuppliedPhone, suppliedAddress__c,suppliedPartyNumber__c, suppliedCity__c,Invoice_no__c, suppliedOrganizationNo__c, suppliedPostalCode__c,change_address_ref_no__c, Shipment_number__c from case where id=:caseId limit 1];
            
           // system.debug('Search is in based on a case. Setup search params from the case data');
            
            if(right_case.AccountId == null) {
              //  system.debug('The case has no account selected. Using the hidden hint fields');
                setorg_name(right_case.SuppliedCompany);
                
                if(right_case.SuppliedCompany != null && right_case.SuppliedCompany != '' && right_case.SuppliedName != null && right_case.SuppliedName != '' && !right_case.SuppliedCompany.equals(right_case.SuppliedName)){
                    setorg_contactName(right_case.SuppliedName);
                }
                
                //setphone(right_case.SuppliedPhone);-P3 fix post deployment, phone number not in FAR
                //setemail(right_case.SuppliedEmail);-E2-IM012238385 fix
    
                if(right_case.SuppliedName != null && right_case.SuppliedName != '') {
                    setperson_full_name(right_case.SuppliedName); // NEW
                  //  setperson_first_name(KATSutilities.getFirstName(right_case.SuppliedName));
                  //  setperson_last_name(KATSutilities.getLastName(right_case.SuppliedName));
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
              //  system.debug('The case has an account defined. Using it as default search params');
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
            //system.debug('URL param "phone" provided. Setting it as search param');
            setphone(phoneNumber);
        }
        
        // Initialize variables (C-02644)
        dispSimCases = false;                       // Section will be hidden by default on page load
        simCasesList = new List<Case>();            // Initializing memory space for this list
        dateRange = 'w';                            // Default search will be 1 week

        eConnect = new postenNoEconnectUtilities();
        new_account = new Account(name='<'+System.Label.cs_Createcustomer+'>');
        new_contact = new Contact(lastName='<'+System.Label.cs_createContact+'>');
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
        
        ID lightprofile=[Select id from Profile where name='CS community'].id;
        ID userprofile=UserInfo.getprofileid();
        
        if(lightprofile==userprofile)
            lightuser=true;
        else
            lightuser=false;
          
    }
    
    
    /* Clears all search result lists */
   @testVisible private void clearSearch() {
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
    
    /* 
    The goDo method is called when any search results is clicked. 
    Attempts to take the user to the next screen. Performs appropriate state changes and returns a page ref */
    public pagereference goDo() {
        boolean returnNull = false; // Deremines if the page redirects or not?
        //system.debug('calling goDo() \nAccount: '+right_account);
    
        if(!returnNull && right_account == null) {         
            if(!prepareAccount()) {
                //system.debug('Not able to define the account. Return to user.');
                returnNull = true;
            }
        }
      // For all accounts that do not come from CDH
      System.debug('@@right_account.crm_Updated_by_CDH__c @@'+right_account.crm_Updated_by_CDH__c );
         if(  ! ( right_account.crm_Updated_by_CDH__c )){ 
         System.debug('@@@returnNull@'+returnNull+'@@@right_contact@'+'@@@isContactNeeded@@'+isContactNeeded());
            if(!returnNull && right_contact == null && isContactNeeded()) {
           system.debug('The contact is needed, and an account is selected: ' + right_account);

            if(getSelectedContactSearchResult() == null) {
              //  system.debug('No contact is selected.');
              //  system.debug('Account has partynumber. Persisting account syncrounously this will lead to a getCustomer call required to look for contacts');               
                 
                try{  // Searching backend for contacs here?
                      callGetCustomer(right_account.crm_customer_number__c,false);
                      DataPersistencyController.maintainAccount(cached_getCustomerReply);
                }
                catch(Exception e) {
                        //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Data for aktørnummer '+ right_account.crm_customer_number__c +' kan ikke hentes til KATS. (' + e.getMessage() + ')' ));
                        
                        //Csphase2 Supriya 28122016
                        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Data for aktørnummer '+ right_account.crm_customer_number__c + System.Label.cs_can_not_get_to_the_KATS+ '  (' + e.getMessage() + ')' ));
                                                  
                        cached_getCustomerReply = null;
                        // system.debug('PartyNumber was found using search customer, but is not returned by getCustomer()? This should never happen. .');
                        return null;
                 }
                 
                // system.debug('Right account is now: ' + right_account + ' Refreshing it from SFDC DB.');
                 try {
                     right_account = [select id, CurrencyIsoCode, status__c,  crm_new_account__c, crm_Account_Updated__c, crm_Account_Inserted__c, crm_Updated_by_CDH__c, crm_Updated_by_FKB__c, crm_Revenue_Last_Year__c, crm_Revenue_This_Year__c, CRMstatus__c, Sector__c, customer_segment__c, CustomerTeam__c, BillingStreet, BillingCity, BillingPostalCode, BillingCountry, isPersonAccount, PersonContactId, crm_customer_number__c, recordTypeId, name from Account where crm_customer_number__c=:right_account.crm_customer_number__c limit 1];    //Reloading the account from the DB to get correct values (isPersonAccount, PersonContactId etc.)
                     //system.debug('Ensure that salesforce ID is in the list of partyNumber-to-salesforceID list created with searchCustomer');
                     includePartyNumberToAccountIdMapping(right_account);
                 }
                 catch(Exception e) {
                    // system.debug('Partynumber not found. Go to customer search');
                     upsert new_case_data;   
                     return createShipmentCaseGoToCustomerSearch();
                 }
                 
                 //('Right account refreshed. Is now: ' + right_account);

            } else { system.debug('A contact has been selected. Therefore no need to call eConnect.getCustomer'); }   // end getSelectedContactSearchResult
           
            if(!prepareContact()) {
               // system.debug('Not able to define the contact. Searching for contacts and return to user.');
                searchContacts();
                if(hasduplicate==false)
                    returnNull = false;
                 else
                     returnNull=true;
            } else {
                //system.debug('Contact prepared. Upserting it in the DB');
                right_contact = KATSutilities.upsertAsSystem(right_contact);
            } // end prepareContact
           
        
        }
         else {
           // system.debug('No contact needed. Therefore we can now save the account and call the persistency @future');
            right_account = KATSutilities.upsertAsSystem(right_account);
            //system.debug('Ensure that salesforce ID is in the list of partyNumber-to-salesforceID list created with searchCustomer');
            includePartyNumberToAccountIdMapping(right_account);
            
            DataPersistencyController.updateAccount(right_account.id);
        } // End isContactNeeded
                
      } 
      else { // CM account
          if(!returnNull && right_contact == null && isContactNeeded()) {
              getSelectedContactSearchResult();       
                  if(!prepareContact()) {
                  //  system.debug('Not able to define the contact. Searching for contacts and return to user.');
                    searchContacts();
                    returnNull = true;
                  }
            }
       } 
       
       right_account = [select id, CurrencyIsoCode, status__c, crm_new_account__c, crm_Updated_by_FKB__c, crm_Updated_by_CDH__c, crm_Account_Inserted__c, crm_Account_Updated__c, crm_Revenue_Last_Year__c, crm_Revenue_This_Year__c, CRMstatus__c, Sector__c, customer_segment__c, CustomerTeam__c, BillingStreet, BillingCity, BillingPostalCode, BillingCountry, isPersonAccount, PersonContactId, crm_customer_number__c, recordTypeId, name from Account where id=:right_account.id limit 1];
        // system.debug('Account is good: ' + right_account.id + '/' + right_account);
       // common
        if(!returnNull && (go_to_type == forwardType.NEW_CASE || go_to_type == forwardType.EXISTING_CASE)) {
           // system.debug('Must create new case: ' + new_case_data);
            if(go_to_type == forwardType.NEW_CASE) {
                right_case = createCase(new_case_data);
            }
            addAccountToCase();
            upsert right_case; 
            
        }
       
        //system.debug('All do actions completed. Getting a relevant pagerefence and returning it to the user.');

        Pagereference r = (returnNull) ? null : getPageReference(); 
        return r;
    }  // end goDo  
    
    private boolean isContactNeeded() {
       System.debug('isContactNeeded: \n'
        +override_required_contact + '\n'
        +right_account.IsPersonAccount + '\n'
        +right_account.RecordTypeId);
        if(!override_required_contact && !(right_account.IsPersonAccount || right_account.RecordTypeId == KATSutilities.getRecordType('person_account') )  ) {
            return true;
        }
        return false;
    }
    
    /**
     * @return appropriate pagereference based on the state variables of the class
     */
    private Pagereference getPageReference() {
      //  Pagereference pageref;
        if(go_to_type == forwardType.NEW_CASE || go_to_type == forwardType.EXISTING_CASE) {
            pageref = new ApexPages.StandardController(right_case).view();
        }
        else if(go_to_type == forwardType.ACCOUNT) {
            pageref = new ApexPages.StandardController(right_account).view();
            if(searchCustomerParams.get('forwardingnumber') != null) {
                pageref.getParameters().put('adresse', searchCustomerParams.get('forwardingnumber'));
            }
        }
    //######################### Commentet out for the Console ###############################

        pageref.setRedirect(true);
         //System.debug('Returning: '+pageref.getUrl());
        return pageref; 

 //   return null; // Navigation is handeled by js in page
    }
   
    /*
    NEW: Accounts should only be updated if they are not managed by FKB.
    A flag on the account determines if it is possible to update or not (FAR__c).
    
    */
    /* Attempting to creates/update an account based on the information at hand. Returns false if that is not possible */
    @testVisible private boolean prepareAccount() {
        
        if(getSelectedAccountSearchResult() == null) { // when does this happen?
           // system.debug('No search result row selected. The user is manually creating a new account based on:' + new_account);
           // right_account = createAccount(new_account);
        }
        else { // RL account will have SF id. The else part of the statement below must be changed, updateAccount
           // system.debug('An account search result row has been selected by the user.');
            if(getSelectedAccountSearchResult().getSalesforceId() == null) {
               // system.debug('A row with an account which does not exist in salesforce is selected. Creating the account.');
                right_account = loadAccount( getSelectedAccountSearchResult() );
            }
            else { 
               // system.debug('A row with an existing salesforce account is selected. Updating it.');
                right_account = updateAccount( getSelectedAccountSearchResult() );      
            }
        }
        
        return true;
    }
    
    /* Attempting to creates/update a contact based on the information at hand. Returns false if that is not possible */
   @testVisible private boolean prepareContact() {
        System.debug('@@@@selected_contact_search_result@@'+selected_contact_search_result);
        if(selected_contact_search_result == null) {
           // system.debug('No contact is selected. Not able to prepare a contact');
            return false;
        }
        else {
           // system.debug('A contact is selected (new or search result)');
            
            if( getSelectedContactSearchResult() == null ) {
                //system.debug('No search result row selected. The user is manually creating a new contact');
                 Contact createdCon=new Contact();
                                 System.debug('@@@508@@');
                    createdCon= createContact(new_contact);
                    if(hasduplicate==false)
                    {    
                        right_contact=createdCon;
                        system.debug('@@before true@@');
                        
                    }
                     return false;             
            }
            else { 
               // system.debug('A contact search result row has been selected by the user.');
               
               // Silje: This should not be true as all contact will exist in salesforce
              /*  if(getSelectedContactSearchResult().getSalesforceId() == null) {
                    system.debug('A row with an account which does not exist in salesforce is selected. Creating the account.');
                    right_contact = loadContact( getSelectedContactSearchResult() );
                }
                else {
                    system.debug('A row with an existing salesforce contact is selected. Updating it.');
                    right_contact = updateContact( getSelectedContactSearchResult() );      
                } */
                 right_contact = updateContact( getSelectedContactSearchResult() );      
            }
        }
        
        return true;
    }  
 
    private Account loadAccount(AccountSearchResult searchResult ) {
        system.debug('Loading an account into KATS from the search result');
        Account acct = new Account();
        
        acct.crm_customer_number__c = searchResult.partyNumber;
     //   acct.FAR__c = true; // A row with an account which does not exist in salesforce is selected. Creating the account.
        if(searchResult.isPersonAccount) {
            //system.debug('The account is a person account');
            try{
                         acct.FirstName = searchResult.getFirstName(); 
                         if(acct.FirstName.length() > 40) { acct.FirstName = acct.FirstName.substring(0,39);}
                acct.LastName = searchResult.getLastName();
                if(acct.LastName.length() > 80) { acct.LastName = acct.LastName.substring(0,79);}
                } catch (System.NullPointerException e){
                        acct.lastName = '';
            }
            acct.RecordTypeId = KATSutilities.getRecordType('person_account');
            if(searchResult.Address==null)
            {
                acct.BillingStreet=System.Label.cs_Protected_Address;
                acct.ShippingStreet=System.Label.cs_Protected_Address;
            }
        } 
        else {
            //system.debug('The account is a business account');
            acct.Name = searchResult.name;
            acct.RecordTypeId = KATSutilities.getRecordType('business_account');
        }
        //system.debug('Account loaded: ' + acct);        
        return acct;
    }
    
    
    /* Creates a new account in the DB based on the received account *
    private Account createAccount(Account accountData) {
        Account a;
        if(activeSearchTab=='tabPrivate') {
            a = new Account();
            a.recordTypeId = KATSutilities.getRecordType('person_account');
            a.lastName = KATSutilities.getLastName(accountData.name);
            a.firstName = KATSutilities.getFirstName(accountData.name);
          //  a.FAR__c = true; // Person accounts should always be updatable
        }
        else { 
            a = accountData;
            a.RecordTypeId = KATSutilities.getRecordType('business_account'); // NPB: Must be changed to new record type Mail Recipient
     //       a.FAR__c = true; // If new search is enabeled, then accounts created from FAR should be updatable through FAR
        }
        return a;
    }
    */
    
    /*
    NEW: if the account is marked with FAR__c=true it should be updated. If not, do nothing
    
    */
    /* Updates the account defined in the search result and returns the account. */
    private Account updateAccount( AccountSearchResult searchResult ) {
       
        Account acct = new Account(id=searchResult.getSalesforceId());
        acct.crm_customer_number__c = searchResult.partyNumber;
      //  acct.FAR__c = searchResult.UseFARSource;
   
        // If flag is set to false it should not be updated and the account should be returned unchanged.
      if(searchResult.UseFARSource == false){return acct;}
     
     //system.debug('Updating account with id: ' + searchResult.getSalesforceId() + ' from search results');
     if(searchResult.isPersonAccount) {
            //system.debug('The account is a person account');
            acct.FirstName = searchResult.getFirstName();
            if(acct.FirstName.length() > 40) { acct.FirstName = acct.FirstName.substring(0,39);}
            acct.LastName = searchResult.getLastName();
            if(acct.LastName.length() > 80) { acct.LastName = acct.LastName.substring(0,79);}
            acct.RecordTypeId = KATSutilities.getRecordType('person_account');
        } 
        else {
           // system.debug('The account is a business account');
            acct.Name = searchResult.name;
            acct.RecordTypeId = KATSutilities.getRecordType('business_account');
        }
      
        return acct;
    }
    
    /*
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
    */
    
    /* Creates a new contact in the DB based on the received contact */
    
    @testVisible private Contact createContact(Contact contactData) {
        contactData.AccountId = right_account.id;
        
    //added as part of contact CR - C-07430
    RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'Customer_Service' And sObjectType = 'Contact' Limit 1];
    Id csRecordTypeId = null;
    If(rtypes.size() > 0) {
    csRecordTypeId  = rtypes.get(0).Id;
    }
    System.debug('Recordtype id: ' + csRecordTypeId);
        new_contact.recordtypeid=csRecordTypeId;
        new_contact.crm_Contact_Type__c='Customer Service';
        System.debug('@@katsutilities.hasduplicatecontact@'+hasduplicate);
        Database.UpsertResult sr = Database.upsert(contactData, false);
        
         StatusCode co=StatusCode.DUPLICATES_DETECTED;

        
            if (!sr.isSuccess()) 
            {
                for (Database.Error error : sr.getErrors()) 
                {
                    StatusCode code=error.getStatusCode();
                    System.debug('@@@@StatusCode@@'+code);
                    if(co==code)
                    {
                        hasduplicate=true;
                       
                    }
                    else
                    {
                        hasduplicate=false;
                    }
                   
                }
            }
            else
                hasduplicate=false;
       
        if(hasduplicate==false)
        {
            System.debug('@@insideif 653@@');
            return contactData;
        }
         else
         {
             System.debug('@@insideif 658@@');
             //hasduplicate=katsutilities.duplicateflag();
             return null;
         }
    }
    /* Updates the account defined in the search result and returns the account. */
   @testVisible private Contact updateContact( ContactSearchResult searchResult ) {
        Contact cnt = new Contact(id=searchResult.getSalesforceId());
        return cnt;
    }
    
   @testVisible private void addAccountToCase() {
       // system.debug('Relating the case ' + right_case + ' to the account ' + right_account + ' and the contact ' + right_contact);
        right_case.AccountId = right_account.id;
        
        if(right_account.IsPersonAccount || right_account.RecordTypeId == KATSutilities.getRecordType('person_account')) {
            right_case.ContactId = right_account.PersonContactId;
        }
        else if(isContactNeeded()){
        if(right_contact!=null)
            right_case.ContactId = right_contact.id;
        }
        else if(!isContactNeeded())
        {
            right_case.ContactId = null;
        }
        
    }
    
    private Case createCase(Case caseData) 
    {
        //system.debug('Creating new case based on data: ' + caseData);
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
        return godoShipmentcase(CustomerServiceSearchController.SHIPMENT, KATSutilities.getRecordType('simple_inquiry')); 
    }
    
    //This creates a Radgivining/Informasjon with the Receiver as the issue
    public PageReference godoRecieverShipmentcaseRI() 
    {
        return godoShipmentcase(CustomerServiceSearchController.SHIPMENT_RECIEVER, KATSutilities.getRecordType('simple_inquiry')); 
    }
    
    //This creates a Radgivining/Informasjon with the Sender as the issue
    public PageReference godoSenderShipmentcaseRI() 
    {
        return godoShipmentcase(CustomerServiceSearchController.SHIPMENT_SENDER, KATSutilities.getRecordType('simple_inquiry')); 
    }
    
    //This creates a Klage with the Receiver as the issue
    public PageReference godoRecieverShipmentcaseKlage() 
    {
        return godoShipmentcase(CustomerServiceSearchController.SHIPMENT_RECIEVER, KATSutilities.getRecordType('complaint')); 
    }
    
    //This creates a Klage with the Sender as the issue
    public PageReference godoSenderShipmentcaseKlage() 
    {
        return godoShipmentcase(CustomerServiceSearchController.SHIPMENT_SENDER, KATSutilities.getRecordType('complaint')); 
    }
    
    //This creates a Reklamasjon Gods as the issue
    public PageReference godoGodscase() 
    {
        return godoShipmentcase(CustomerServiceSearchController.CARGO_CLAIMS, KATSutilities.getRecordType('Cargo_Claims')); 
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
        PageReference page = new PageReference('/apex/customerServiceSearch');
        Map<String, String> pageParameters = page.getParameters();
        pageParameters.put('searchTab', 'tabPrivate');
        pageParameters.put('caseId', new_case_data.id);
        
        page.setRedirect(true);
        return page;
    }
    
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

            //System.debug('Date Range Selected: ' + dateRange);

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
                //system.debug('Incorrect Selection Parameter: Case search with similar kollinummer: Date Range selection is Incorrect');
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
        
       // system.debug('Creating a new case from the selected shipment: ' + right_shipment);
        displayShipmentDetailsPopup = false;
        
        //Preparing the case: set default parameters based on shipment data from eConnect
        new_case_data = prepareCase(right_shipment);
        
        go_to_type = forwardType.NEW_CASE;
        
        new_case_data.RecordTypeId = recTypeId;
        
        
        // Only complaints have details on the page, SHIPMENT_RECIEVER, SHIPMENT_SENDER, CARGO_CLAIMS
        if(shipmentType == CustomerServiceSearchController.SHIPMENT_SENDER || shipmentType == CustomerServiceSearchController.SHIPMENT_RECIEVER || shipmentType == CustomerServiceSearchController.CARGO_CLAIMS)  {
        if(new_case_data != null && !KATSutilities.isEmpty(new_case_data.Shipment_identification__c) && new_case_data.Shipment_identification__c != '0') { // Is false SHIPMENT_RECIEVER = shipment_case_reciever
        //system.debug('A new shipment case with a shipment ID is being created. Call datapersistencyController on cached getShipment data - case:' + new_case_data);
           // upsert new_case_data; nececeary?
            
            DataPersistencyController.maintainShipmentOnRegisteredCase(right_shipment.eConnectResponse, new_case_data, true);
        }
        }
        EConnectWrapper_GetShipmentData.ShipmentPartyAddress partyInfo;
        
        //Get correct partynumber
        if(shipmentType == CustomerServiceSearchController.SHIPMENT_SENDER || shipmentType == CustomerServiceSearchController.CARGO_CLAIMS) 
        {
            partynumber = right_shipment.shipmentUnitType.Sender.partyNumber;
            partyInfo = right_shipment.shipmentUnitType.Sender;
        }
        if(shipmentType == CustomerServiceSearchController.SHIPMENT_RECIEVER) 
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
            //system.debug('The selected shipment doesn\'t have a partynumber');
            // --- det er vel denne jeg må fikse opp i
            upsert new_case_data;
            
            pageref = new PageReference('/' + new_case_data.id + '/e?retURL='+new_case_data.id); //new ApexPages.StandardController(new_case_data).edit();
            
           // return pageref;
           return createShipmentCaseGoToCustomerSearch();
        }   
        
        //system.debug('The selected shipment has a partynumber');
        matchingAccounts = [select CurrencyIsoCode, crm_new_account__c, status__c, crm_Account_Updated__c, crm_Account_Inserted__c, crm_Updated_by_CDH__c , crm_Updated_by_FKB__c, crm_Revenue_Last_Year__c, crm_Revenue_This_Year__c, CRMstatus__c, Sector__c, customer_segment__c, CustomerTeam__c, BillingStreet, BillingCity, BillingPostalCode, BillingCountry,  recordTypeId, id, isPersonAccount, PersonContactId, crm_customer_number__c, name from Account where crm_customer_number__c=:partyNumber limit 1];
        
        if(matchingAccounts.size() > 0) 
        {
            shipmentAccount = matchingAccounts.get(0);
        } 
        else 
        {
            //system.debug('The shipments account is an account that does not exist in salesforce. Need to call getCustomer now to get account type.');
            
            shipmentAccount = new Account();
            shipmentAccount.crm_customer_number__c = partynumber;
            
            try {
                //Doing call to getCustomer. Note that this is not the same as persisting the account. That is done later in GoDo() if needed. This call is only to get the account type
                callGetCustomer(shipmentAccount.crm_customer_number__c,shipmentAccount.crm_Updated_by_CDH__c);
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
                //system.debug('No result returned when looking for the shipments sender party using partynumber: ' + shipmentAccount.crm_customer_number__c);
                //system.debug('Going to customer search...');
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
        //system.debug('Calling getShipment with: ' + getSelectedShipmentSearchResult().ShipmentUnitID);
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
          currentModus=setModus(currentSearchModus);
            ExceptionController.createErrorRecord(coe, 'SearchParams (modus: '+currentModus+'): '+searchCustomerParams);
            String userMessage=ExceptionController.translateExceptionMessage(coe.getMessage());
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Forbindelsen til eConnect feilet - ' + userMessage ));
            //Csphase2 Supriya 28122016
                        
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.cs_Connection_to_eConnect_failed+' - ' + userMessage ));
        }
        catch(TypeException te) {
         //   system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
        currentModus=setModus(currentSearchModus);

         ExceptionController.createErrorRecord(te, 'SearchParams (modus: '+currentModus+'): '+searchCustomerParams);
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
            //Csphase2 Supriya 28122016
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_Error_in_specified_values+' - ' + te.getMessage() ));
           
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
    System.debug('@@@@getSelectedContactSearchResult@@@'+selected_contact_search_result);
        if(selected_contact_search_result==null || selected_contact_search_result < 0 || contact_search_results == null) {
        System.debug('@@@@getSelectedContactSearchResult@@@'+selected_contact_search_result);
            return null;
        }
        else {
        System.debug('@@@@getSelectedContactSearchResult@@@'+selected_contact_search_result);
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
    public CustomerServiceSearchController getCustomerServiceSearchController(){
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
        personSearch=false;
        searchCustomerParams.put('party_type','ORGANIZATION');
        return searchAccounts();
    }
    
    /*Removes illegal parameters for searching people and performs search*/
    public pagereference searchPersonAccounts() 
    {

        dispSimCases = false;
        personSearch=true;
        searchCustomerParams.put('party_type','PERSON');
       
        return searchAccounts();
    }

    /* Perform search for account */
    public pagereference searchAccounts() {
    System.debug('@@@@1130@@@InsideSearchAccount');
      //System.debug('@@@buttonclicked at'+System.now());
        
        if(currentSearchModus == 'AR') {   
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
        else if(currentSearchModus == 'FOT' || System.currentPagereference().getParameters().get('searchTab') == 'tabPrivate')  {
        //else if(currentSearchModus == 'FOT') {
            
            if(currentSearchModus == ''){ 
                currentSearchModus = 'FAR'; 
            }
            //setparty_type('PERSON');
            addCustomerSearchParam('org_name', searchCustomerParams.get('person_full_name'));  // Integration only has one field for name, org_name and person_full_name should be sent in same parameter
            //Removing params for other moduses 
            searchCustomerParams.remove('org_fiscal_reference');
            searchCustomerParams.remove('org_contactName');
          //  searchCustomerParams.remove('org_contactFirstName');
          //  searchCustomerParams.remove('org_contactLastName');
            searchCustomerParams.remove('receivable_number');
            searchCustomerParams.remove('forwardingnumber');
            searchCustomerParams.remove('order_number');
          //  searchCustomerParams.remove('email');
          //  searchCustomerParams.remove('phone');
        }
        else { //Probably CAESAR...
            //setparty_type('ORGANIZATION');          
            //Removing params for other moduses
            searchCustomerParams.remove('person_national_identification_number');
            searchCustomerParams.remove('person_first_name');
            searchCustomerParams.remove('person_middle_name');
            searchCustomerParams.remove('person_last_name');
            searchCustomerParams.remove('person_full_name'); // NEW
            searchCustomerParams.remove('receivable_number');
            searchCustomerParams.remove('forwardingnumber');
            searchCustomerParams.remove('order_number');
        } 
          If( !searchCustomerParams.containskey('email') && !searchCustomerParams.containskey('phone') && !searchCustomerParams.containskey('org_contactName'))
            currentModus=setModus(currentSearchModus);
        else
            currentModus='SF';   
        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'SearchParams (modus: '+currentModus+'): '+searchCustomerParams ));
       
        
        
        clearSearch();

        account_search_results = new List<AccountSearchResult>();
      
       // postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerOutParameters eConnectReply = new postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerOutParameters();
        postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType[] econnectSearchPartyCRMReply=new postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType[]{} ;  
        postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType econnectSearchPartyFARReply=new postenNoEconnectAboCustomerpartyV1.SearchPartyFARResponseType();
        Map<String, AccountSearchResult> sfSearchResultsMap = new Map<String, AccountSearchResult>();
  
        try {
            if(Test.isRunningTest()) {
              econnectSearchPartyFARReply = mock_KatsSaksearchcustomer.getPrivateSearch();
            } else {
            
            
            if( currentSearchModus == 'AR' || currentSearchModus == 'FW' || currentSearchModus == 'OM')
            {
               econnectSearchPartyCRMReply=econnect.SearchPartyCRM(searchCustomerParams);
               
                 if(econnectSearchPartyCRMReply!=null)
                {
                    System.debug('@@@@line1201@@'+econnectSearchPartyFARReply);
                    string partynumbertoFAR='';
                    Integer count=0;
                  
                 for(postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType custList: econnectSearchPartyCRMReply)
                 {
                     System.debug('@@@@custList@@'+custList);
                    searchCustomerParams.put('party_number',custList.AccountNumber);
                     if(count==0)
                        partynumbertoFAR=custList.AccountNumber;
                     else
                        partynumbertoFAR=','+custList.AccountNumber;
                        
                     count++  ;
                 }
                 Map<String,String> SeachParamstoFAR=new Map<String,String>();
                    SeachParamstoFAR.put('party_number',partynumbertoFAR);
                    SeachParamstoFAR.put('party_type',searchCustomerParams.get('party_type'));
                    
                    econnectSearchPartyFARReply=econnect.searchCustomerFAR(SeachParamstoFAR);
                    System.debug('@@@@1218@@@'+econnectSearchPartyFARReply);
                    
                }
            }
            else
            {   
                System.debug('@@@@@searchCustomerParams@@@'+searchCustomerParams);
                if(!searchCustomerParams.containskey('email') && !searchCustomerParams.containskey('phone') && !searchCustomerParams.containskey('org_contactName'))
                {
                econnectSearchPartyFARReply = econnect.searchCustomerFAR(searchCustomerParams);
                System.debug('@@@@@EconnectReply@@@'+econnectSearchPartyFARReply);
               }
            }
          }  
           if( econnectSearchPartyFARReply!=null && econnectSearchPartyFARReply.PartyMaster!=null && econnectSearchPartyFARReply.PartyMaster.Size()>0)
            {    // Traverse results and map content by creating AccountSearchResult instances. Customer number is used to merge results with accounts in SF
           
                for(postenNoEconnectAboCustomerpartyV1.PartyMasterType replyElement:econnectSearchPartyFARReply.PartyMaster)
                {
                 
                    sfSearchResultsMap.put(String.valueOf(replyElement.PartyIds.PartyNumber[0]), new AccountSearchResult(replyElement, this));// account number or party number is not returned in search party FAR reply
                }
                system.debug('AccountSearchResult objects created for the serach response. Now looking for the same accounts in SFDC');
                
            }
            /*
            if(eConnectReply==null || eConnectReply.CustomerList == null || eConnectReply.CustomerList.Customer==null) {
                system.debug('Search: No results returned from eConnect');  
            }
            else {
                system.debug('Search: Reply from eConnect to be prepared for display: ' + eConnectReply);
                list<String> partyNumbersToSearch = new list<String>();
                for(postenNoEconnectKatsSaksearchcustome.Customer_element replyElement:eConnectReply.CustomerList.Customer) {
                    if(replyElement.PartyType == 'Organization' || (replyElement.PartyType == 'Person' && !getBlockPrivateSearch())) {
                        partyNumbersToSearch.add(replyElement.partyNumber);
                        sfSearchResultsMap.put(replyElement.partyNumber, new AccountSearchResult(replyElement, this));
                        System.debug('@@@@sfsearchResult@@'+sfSearchResultsMap);
                    }
                }
                
                system.debug('AccountSearchResult objects created for the serach response. Now looking for the same accounts in SFDC'); 
            }*/
        }
        catch(CalloutException coe) {
            //TODO: Exception handling
          //  system.debug('Something went wrong in the eConnect call');
          currentModus=setModus(currentSearchModus);

            ExceptionController.createErrorRecord(coe, 'SearchParams (modus: '+currentModus+'): '+searchCustomerParams);  
            String userMessage=ExceptionController.translateExceptionMessage(coe.getMessage());
           // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Forbindelsen til eConnect feilet - ' + userMessage));
            //Csphase2 Supriya 28122016
                        
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.cs_Connection_to_eConnect_failed+' - ' + userMessage ));
        }
        catch(TypeException te) {
        currentModus=setModus(currentSearchModus);

            ExceptionController.createErrorRecord(te, 'SearchParams (modus: '+currentModus+'): '+searchCustomerParams);   
            system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
           // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
            //Csphase2 Supriya 28122016
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_Error_in_specified_values+' - ' + te.getMessage() ));
        }
               
        // Search locally
        List<AccountSearchResult> sfAccounts = searchSFDCaccounts();
        // Add list of partyNumbersToSearch
        for(Account a:[SELECT id, CurrencyIsoCode, status__c, crm_new_account__c, crm_Account_Updated__c, crm_Account_Inserted__c, crm_Updated_by_CDH__c, crm_Updated_by_FKB__c , crm_Revenue_Last_Year__c, crm_Revenue_This_Year__c, CRMstatus__c, Sector__c, customer_segment__c, CustomerTeam__c, name, BillingStreet, BillingCity, BillingPostalCode, BillingCountry, recordTypeId, crm_customer_number__c, type, IsPersonAccount  from Account where crm_customer_number__c in :sfSearchResultsMap.keySet()]) {
            // Update map so reuslt gets SF details
            AccountSearchResult econAcc=sfSearchResultsMap.get(a.crm_customer_number__c);
            System.debug('####1392###'+econAcc);
            //E2-IM012768071 -Akshata
            a.BillingCity=econAcc.city;
            a.BillingPostalCode=econAcc.postalCode;
            a.BillingStreet=econAcc.street;
             //E2-IM012768071 -Akshata
            System.debug('@@@econAcc.street@@'+econAcc.street);
            sfSearchResultsMap.put(a.crm_customer_number__c, new AccountSearchResult(a, this ));
        }  
         System.debug('@@sfSearchResultsMap'+sfSearchResultsMap); 
        System.debug('@@sfAccounts '+sfAccounts); 
        Map<String,Integer> totalCase=new Map<String,Integer>();
        Map<String,Integer> OpenCase=new Map<String,Integer>();
       
        // Add search results to map so we can check if eConnect results exists in SF or not
        Set<String> SFAccountid=new Set<String>();
        for(AccountSearchResult  a : sfAccounts){
            SFAccountid.add(a.PartyNumber);
            if( sfSearchResultsMap.containsKey(a.partyNumber)){ 
                // Update map so reuslt gets SF details
                sfSearchResultsMap.put(a.partyNumber, a);
            } else {
                account_search_results.add(a); // Result is not in map so we add it
            }     
         }
        for(String custNum:sfSearchResultsMap.keySet())
         {
             System.debug('@@@@inside 1298'+custNum);
             SFAccountid.add(custNum);
         }
         for(AccountSearchResult customer: sfAccounts )
         {
             SFAccountid.add(customer.partyNumber);
         }
          System.debug('@@sfSearchResultsMap.keySet()@@'+sfSearchResultsMap.keySet());
         // account_search_results now contains all results that was not in eConnect since eConnect results was put in the map
         // Add map to account_search_results to add accounts found in FAR
        account_search_results.addAll(sfSearchResultsMap.values());
        
        if(personSearch)
        {
        Long beforecall=(System.now()).gettime();
           
              
        for(AggregateResult agg:[Select Count(id) totalcase, Account.crm_customer_number__c from Case where Account.crm_customer_number__c In:SFAccountid group by Account.crm_customer_number__c])
        {
            totalCase.put((String)agg.get('crm_customer_number__c'),(Integer)agg.get('totalcase'));
        }
        
        for(AggregateResult agg:[Select Count(id) opencase, Account.crm_customer_number__c from Case where Account.crm_customer_number__c In:SFAccountid and isclosed=false group by Account.crm_customer_number__c])
        {
            openCase.put((String)agg.get('crm_customer_number__c'),(Integer)agg.get('opencase'));
        }
         Long received=(System.now()).gettime();
         long timetaken=received-beforecall;
         System.debug('@@@time taked by Aggregate SOQL@@'+timetaken);
        
        //System.debug('@@@openCases@@'+openCase);
         // System.debug('@@@totalCase@@'+totalCase);
        for(AccountSearchResult  a : account_search_results)
        {
        
            if(openCase.containskey(a.partyNumber))
            {
               a.openCases=String.valueof(openCase.get(a.Partynumber));
            }
            if(TotalCase.containskey(a.partyNumber))
            {
               a.totalCases=String.valueof(TotalCase.get(a.Partynumber));
            }
        }
        }
        account_search_results.sort();  
        searchCustomerParams.clear();   
        return null;
    }
        
    public list<AccountSearchResult> searchSFDCaccounts() {
        
        list<AccountSearchResult> results = new list<AccountSearchResult>();
        list<Account> accounts = new list<Account>();
        String soql = '';
        String business_account =  KATSUtilities.getRecordType('business_account');
        String person_account =  KATSUtilities.getRecordType('person_account');
        String accountCriteria = '' ;
        String contactCriteria ='';// 'c.caesar_contact_id__c=\'\' AND ';
        boolean hasAccountCriteria = false;
        boolean hasContactCriteria = false;
        //System.debug('searchCustomerParams: '+searchCustomerParams);
        if(personsearch) { accountCriteria += 'a.isPersonAccount=true AND '; } 
        else {
            accountCriteria += 'a.isPersonAccount=false AND '; 
       }

        //system.debug('Building accountCriteria for SFDC account search');
        if(searchCustomerParams.containsKey('org_name')) { hasAccountCriteria=true; 
            accountCriteria += 'a.name like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('org_name')).trim().replace('*', '%') + '%\' AND '; }    
            
            // Org number
            if(searchCustomerParams.containsKey('org_fiscal_reference')) {
                 hasAccountCriteria=true; accountCriteria += 'a.Orga__c = \'' + String.escapeSingleQuotes(searchCustomerParams.get('org_fiscal_reference')).trim() + '\' AND ';
                  }  
            // partynumber
            if(searchCustomerParams.containsKey('party_number')) {
                 hasAccountCriteria=true; accountCriteria += 'a.crm_customer_number__c = \'' + String.escapeSingleQuotes(searchCustomerParams.get('party_number')).trim() + '\' AND ';
            }  
                  
            // address_postal_code - BillingPostalCode
            if(searchCustomerParams.containsKey('address_postal_code')) {
                 hasAccountCriteria=true; accountCriteria += 'a.BillingPostalCode = \'' + String.escapeSingleQuotes(searchCustomerParams.get('address_postal_code')).trim() + '\' AND ';
            }  
          
            // address_city - BillingCity
            if(searchCustomerParams.containsKey('address_city')) {
                 hasAccountCriteria=true; accountCriteria += 'a.BillingCity = \'' + String.escapeSingleQuotes(searchCustomerParams.get('address_city')).trim() + '\' AND ';
            }  
           
                            
            // BillingStreet= address_street_name, address_house_number, address_house_letter  
            String billingaddress='';
            if(searchCustomerParams.containsKey('address_street_name')) { billingaddress= String.escapeSingleQuotes(searchCustomerParams.get('address_street_name')).trim().replace('*', '%')+ '%'; }
            if(searchCustomerParams.containsKey('address_house_number')) { billingaddress += ' '+String.escapeSingleQuotes(searchCustomerParams.get('address_house_number')).trim(); }
            if(searchCustomerParams.containsKey('address_house_letter')) { billingaddress += String.escapeSingleQuotes(searchCustomerParams.get('address_house_letter')).trim();  }
        
            if(billingaddress!='') {
                 hasAccountCriteria=true; accountCriteria += 'a.BillingStreet like \'' + billingaddress + '\' AND ';
            }  
            
              
      if(searchCustomerParams.containsKey('person_first_name')) { hasAccountCriteria=true; accountCriteria += 'a.firstname like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('person_first_name')).trim().replace('*', '%') + '%\' AND '; }    
      if(searchCustomerParams.containsKey('person_last_name')) { hasAccountCriteria=true; accountCriteria += 'a.lastname like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('person_last_name')).trim().replace('*', '%') + '%\' AND '; }    
       // NEW
            if(searchCustomerParams.containsKey('person_full_name')) { hasAccountCriteria=true; accountCriteria += 'a.name like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('person_full_name')).trim().replace('*', '%') + '%\' AND '; }    
       
            if(searchCustomerParams.containsKey('phone')) { hasAccountCriteria=true; accountCriteria += 'a.phone = \'' + String.escapeSingleQuotes(searchCustomerParams.get('phone')).trim() + '\' AND '; }    
        // NEW
            if(searchCustomerParams.containsKey('email')) {
                if(activeSearchTab=='tabPrivate'){ hasAccountCriteria=true; accountCriteria += 'a.PersonEmail  = \'' + String.escapeSingleQuotes(searchCustomerParams.get('email')).trim() + '\' AND '; }
                else {  hasContactCriteria=true; contactCriteria += 'c.email = \'' + String.escapeSingleQuotes(searchCustomerParams.get('email')).trim() + '\' AND '; }    
            }
            if(accountCriteria.length()!=0){
                accountCriteria = accountCriteria.substring(0, accountCriteria.length()-4); //Remove ' AND ' from the end of the SOQL statement
            }
       
            if(searchCustomerParams.containsKey('org_contactName')) { hasContactCriteria=true; contactCriteria += 'c.name like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('org_contactName')).trim().replace('*', '%') + '%\' AND '; }
        //if(searchCustomerParams.containsKey('org_contactFirstName')) { hasContactCriteria=true; contactCriteria += 'c.firstname like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('org_contactFirstName')).trim().replace('*', '%') + '%\' AND '; }    
        //if(searchCustomerParams.containsKey('org_contactLastName')) { hasContactCriteria=true; contactCriteria += 'c.lastname like \'%' + String.escapeSingleQuotes(searchCustomerParams.get('org_contactLastName')).trim().replace('*', '%') + '%\' AND '; }    
            if(contactCriteria.length()!=0){
                contactCriteria = contactCriteria.substring(0, contactCriteria.length()-4); //Remove ' AND ' from the end of the SOQL statement
            }
            soql = 'SELECT id, CurrencyIsoCode, status__c, crm_new_account__c, crm_Revenue_Last_Year__c, crm_Revenue_This_Year__c, CRMstatus__c, Sector__c, customer_segment__c, CustomerTeam__c, crm_Account_Updated__c, crm_Account_Inserted__c, crm_Updated_by_CDH__c, crm_Updated_by_FKB__c, name, BillingStreet, BillingCity, BillingPostalCode, BillingCountry, recordTypeId, crm_customer_number__c, type, IsPersonAccount FROM Account a WHERE ' + accountCriteria;

            if(hasContactCriteria) {
                soql += ' AND id IN (SELECT accountId FROM contact c WHERE ' + contactCriteria + ')';
            }
            soql +=' AND Id!=\''+POSTEN_GLOBAL_ADRESSELISTE+'\'';
    //   soql += ' AND ( a.recordtypeID =\''+business_account+'\' OR   a.recordtypeID =\''+person_account+'\')' ;
            soql += ' AND ( (  a.recordtypeID =\''+business_account+'\' AND crm_customer_number__c !=null  ) OR  a.recordtypeID =\''+person_account+'\')' ;
            soql +=' ORDER BY crm_Revenue_This_Year__c DESC NULLS LAST,crm_Revenue_Last_Year__c  DESC NULLS LAST,  crm_customer_number__c NULLS LAST limit 200';
            
        if(hasAccountCriteria || hasContactCriteria) {
           system.debug('Querying SFDC for accountsearch (' + soql + ')');
            Long beforecall=(System.now()).gettime();
            accounts = Database.query(soql);
               Long received=(System.now()).gettime();
                long timetaken=received-beforecall;
               System.debug('@@@time taked by Search SOQL@@'+timetaken);
        }

        // Search locally in KATS for Contacts with parameter Phone
        if(!personsearch)
        {
            if(searchCustomerParams.containsKey('phone') && searchCustomerParams.get('phone') != null && searchCustomerParams.get('phone') != ''){
                list<Account> accountsFromContact = new list<Account>();
                accountsFromContact = findAccountFromContactPhone(searchCustomerParams.get('phone'));
                if(accountsFromContact.size() > 0){
                    for(Account acc:accountsFromContact) {
                        accounts.add(acc);
                    }
                }
            }
         }   

        for(Account acct:accounts) { 
            results.add(new AccountSearchResult(acct, this));
            
        }
        system.debug(results);
        return results;
    }
    
    /* 
    * Search contacts in Kats with aPhoneNumber equal to contact phone number.
    */
    @testvisible private List<Account> findAccountFromContactPhone(String aPhoneNumber) {
      String business_recordtype = KATSUtilities.getRecordType('business_account');
        List<Account> accountList = [Select a.CurrencyIsoCode, a.status__c, a.Id, a.crm_new_account__c, a.crm_Account_Updated__c, a.crm_Account_Inserted__c, a.crm_Updated_by_CDH__c, a.crm_Updated_by_FKB__c, a.crm_Revenue_Last_Year__c, a.crm_Revenue_This_Year__c, a.CRMstatus__c, a.Sector__c, a.customer_segment__c, a.CustomerTeam__c, a.name, a.BillingStreet, a.BillingCity, a.BillingPostalCode , a.BillingCountry , a.isPersonAccount, a.crm_customer_number__c, a.type, a.recordTypeId
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
            and Account.id!=:POSTEN_GLOBAL_ADRESSELISTE
            and Account.RecordtypeID = :business_recordtype )
            ];
        return accountList;
    }
    
     
    /* Perform search for shipments */
    public pagereference searchShipments() {
        clearSearch();
        checkKollinummerForCases();

        shipment_search_results = new List<ShipmentWrapper>();
        
        //system.debug('Searching shipments');
        
     
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
        currentModus=setModus(currentSearchModus);

        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'SearchParams (modus: '+currentModus+'): '+searchShipmentParams));

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
                //system.debug('Search: Reply from eConnect to be prepared for display: ' + eConnectReply);
                boolean setRightShipment = false;
                for(postenNoEconnectKatsSearchshipment.TShipmentUnit replyElement:eConnectReply)
                {
                   
                    if(Limits.getCallouts()>9){
                       // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Obs! Denne sendingen kan ha flere kolli. Bare de 10 første vises.' ));
                       //Csphase2 Supriya 28122016
                       KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.cs_more_than_one_package));
                       
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
        currentModus=setModus(currentSearchModus);

            ExceptionController.createErrorRecord(coe, 'SearchParams (modus: '+currentModus+'): '+searchShipmentParams);  
            String userMessage=ExceptionController.translateExceptionMessage(coe.getMessage());
           // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Forbindelsen til eConnect feilet - ' + userMessage ));
           //Csphase2 Supriya 28122016
                       
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.cs_Connection_to_eConnect_failed+' - ' + userMessage ));
        }
        catch(TypeException te)
        {
            //system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
            ExceptionController.createErrorRecord(te, 'SearchParams (modus: '+currentModus+'): '+searchShipmentParams);
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
            //Csphase2 Supriya 28122016
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_Error_in_specified_values+' - ' + te.getMessage() ));
        }
        
        return null;

    }
    
    
    /* Perform search for contacts under the selected account */
    
    // Silje: Only local contacts should be searched
    public pagereference searchContacts() {
        /*TODO: exception handling (including "no account selected" error) */
        
        //system.debug('Looking for contacts in cachedGetCustomerReply: ' + cached_getCustomerReply);
        contact_search_results = new List<ContactSearchResult>();
        list<String> caesarContactIdsToSearch = new list<String>();

         //contact record type filter added as part of contact CR - C-07430
         RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'Customer_Service' And sObjectType = 'Contact' Limit 1];
        Id csRecordTypeId = null;
        If(rtypes.size() > 0) {
        csRecordTypeId  = rtypes.get(0).Id;
        }
    System.debug('Recordtype id: ' + csRecordTypeId);
        for(Contact cnt:[select lastname, firstname, email, phone, department, title from Contact where accountId=:right_account.id and recordtypeid=: csRecordTypeId limit 60]) {
            contact_search_results.add(new ContactSearchResult(cnt));
        }
        System.debug('@@@@contact_search_results@@@'+contact_search_results);
/*
        if(cached_getCustomerReply != null && cached_getCustomerReply.OrganizationParty != null && cached_getCustomerReply.OrganizationParty.Contacts != null) {
            for( postenNoEconnectKatsSakgetcustomer.ContactComplexType eConnectContact: cached_getCustomerReply.OrganizationParty.Contacts.contact ) {
                caesarContactIdsToSearch.add(eConnectContact.ContactID);
                contact_search_results.add(new ContactSearchResult(eConnectContact, this));
            }
        }
        //system.debug('ContactSearchResult objects created for the serach response. Now looking for the same contacts in SFDC');
        contact_search_result_existing_contacts = new map<String, Contact>();
        for(Contact c:[select id, Caesar_Contact_Id__c from Contact where Caesar_Contact_Id__c in :caesarContactIdsToSearch]) {
            contact_search_result_existing_contacts.put(c.Caesar_Contact_Id__c, c);
        }
   */ 
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
    private void callGetCustomer(String partyNumber, Boolean isCDHTrue) {
       // system.debug('calling getCustomer (which might be cached) for partynumber: ' + partyNumber);
        
        String cachedPartyNumber;
        if(cached_getCustomerReply == null)                         { cachedPartyNumber = null; }
        else if(cached_getCustomerReply.OrganizationParty != null)  { cachedPartyNumber = cached_getCustomerReply.OrganizationParty.PartyNumber; }
        else if(cached_getCustomerReply.PersonParty != null)        { cachedPartyNumber = cached_getCustomerReply.PersonParty.PartyNumber; }
        //System.debug('cachedPartyNumber: '+cachedPartyNumber);
        if( cachedPartyNumber != partyNumber ) {
            //system.debug('Calling getCustomer straight from MainSearchCustomer and caching it');
            String[] InformationType=new String[]{'CustomerDetails'};
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
 @testVisible   private List<String> splitAddress(String fullAddress){
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
    public class AccountSearchResult extends SearchResult implements Comparable  {
        
        //private postenNoEconnectKatsSaksearchcustome.Customer_element eConnectRow { get; set; }
        private postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType econnectCRMreply{get;set;}
        private postenNoEconnectAboCustomerpartyV1.PartyMasterType econnectFARreply{get;set;}
       
        private CustomerServiceSearchController controller { get; set; }
        public String openCases         {get;set;}
        public String totalCases        {get;set;}  
   
        public Integer compareTo(Object compareTo) {  
            AccountSearchResult compareToEmp = (AccountSearchResult)compareTo;
            Decimal thisYear = revenueThisYear == null?0:revenueThisYear;
            Decimal thisYearComp = compareToEmp.revenueThisYear == null?0:compareToEmp.revenueThisYear;
            Decimal lastYear = revenueLastYear == null?0:revenueLastYear;
            Decimal lastYearComp = compareToEmp.revenueLastYear == null?0:compareToEmp.revenueLastYear;
            if (thisYear == thisYearComp) {
                // check last year
                if(lastYear == lastYearComp){ return 0; }
                if(lastYear > lastYearComp){return -1;}
                if(lastYear < lastYearComp){return 1;}
            }
            if (thisYear > thisYearComp){ return -1; }
            return 1;
        }
        
        public AccountSearchResult(postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType econnectCRMreply, CustomerServiceSearchController con)
        {
            this.econnectCRMreply = econnectCRMreply;
            this.controller = controller;
            String selectedRevenueArea = controller.getSelectedRevenueArea();
        }
        public AccountSearchResult(postenNoEconnectAboCustomerpartyV1.PartyMasterType econnectFARreply, CustomerServiceSearchController con)
        {
            this.econnectFARreply = econnectFARreply;
            this.controller = con;
            String selectedRevenueArea = controller.getSelectedRevenueArea();
        }
        
        /* Constructor for eConnect search results   */
       /* public AccountSearchResult(postenNoEconnectKatsSaksearchcustome.Customer_element eConnectRow, CustomerServiceSearchController controller) {
            this.eConnectRow = eConnectRow;
            this.controller = controller;
            String selectedRevenueArea = controller.getSelectedRevenueArea();
           
        }*/

        /*Constructor for creating accounts not coming from a searchReply (newly created accounts or accounts for shipments) */
        public AccountSearchResult(Account new_account, CustomerServiceSearchController controller) {
            //postenNoEconnectKatsSaksearchcustome.Customer_element newParty = new postenNoEconnectKatsSaksearchcustome.Customer_element();
             postenNoEconnectAboCustomerpartyV1.PartyMasterType newParty = new postenNoEconnectAboCustomerpartyV1.PartyMasterType();
                  //System.debug('@@@@New Acc@@@'+new_account);
            // Need to updae to
            postenNoEconnectAboCustomerpartyV1.PartyNameType name=new postenNoEconnectAboCustomerpartyV1.PartyNameType();
            List<postenNoEconnectAboCustomerpartyV1.PartyNameType> nameList=new List<postenNoEconnectAboCustomerpartyV1.PartyNameType>();
            
          /*  if(new_account.ispersonAccount==true)
            {
             name.PersonFirstName=new_Account.FirstName;
             name.PersonMiddleName='';
             name.PersonLastName=new_Account.LastName; 
            }
            else*/
            name.PartyName= new_account.name;
            
            nameList.add(name);   
            newParty.Name=nameList;
            newParty.PartyType = (new_account.isPersonAccount || new_account.recordTypeId == KATSutilities.getRecordType('person_account')) ? 'Person' : 'Organization';
            postenNoEconnectAboCustomerpartyV1.PartyIdType partyId=new postenNoEconnectAboCustomerpartyV1.PartyIdType();
            List<String> partynumberlist=new List<String>();
            partynumberList.add(new_account.crm_customer_number__c);
            partyId.PartyNumber=partynumberlist;
            newParty.PartyIds=partyId;
            List<postenNoEconnectAboCustomerpartyV1.LocationType> locationTypeList=new List<postenNoEconnectAboCustomerpartyV1.LocationType>();
            postenNoEconnectAboCustomerpartyV1.LocationType locationinfo=new postenNoEconnectAboCustomerpartyV1.LocationType();
            List<postenNoEconnectAboCustomerpartyV1.AddressType> AddressTypeList=new List<postenNoEconnectAboCustomerpartyV1.AddressType>();
            postenNoEconnectAboCustomerpartyV1.AddressType address=new postenNoEconnectAboCustomerpartyV1.AddressType();
            address.StreetName = new_account.billingStreet;
            address.PostalCode = new_account.billingPostalCode;
            address.CityName = new_account.billingCity;
            AddressTypeList.add(address);
            locationinfo.Address=AddressTypeList;
            locationTypeList.add(locationinfo);
            newParty.location=locationTypeList;
              
            String selectedRevenueArea = controller.getSelectedRevenueArea();
            Boolean useFar =  !( new_account.crm_Updated_by_CDH__c );
            useFARSource =  salesforceId==null ? true : useFar; // If the new search is activated, then use the field value. Else, all accounts should be updatable, use true.
            isOld = new_account.crm_new_account__c == null ? false : true;
            revenueLastYear = new_account.crm_Revenue_Last_Year__c;
            revenueThisYear = new_account.crm_Revenue_This_Year__c;
            
            // Set segmentation data for columns Post and Logistics
            String segmentPost  = '';
            if(new_account.CustomerTeam__c != null) {segmentPost+=new_account.CustomerTeam__c +', '; }
            if(new_account.customer_segment__c != null) {segmentPost+=new_account.customer_segment__c; }
            segmentPost =  segmentPost.removeEnd(', ');
            String segmentLogistics  = '';
            if(new_account.CRMStatus__c != null) {segmentLogistics+=new_account.CRMStatus__c +', '; }
            if(new_account.Sector__c != null) {segmentLogistics+=new_account.Sector__c ; }
            segmentLogistics = segmentLogistics.removeEnd(', ');
            servicesegmentL = segmentLogistics;
            servicesegmentP = segmentPost; 
            postenNoEconnectAboCustomerpartyV1.StatusType statusinfo=new postenNoEconnectAboCustomerpartyV1.StatusType();
            statusinfo.Status=new_account.status__c;         
            newParty.status = Statusinfo;
            
            salesforceId = new_account.id;
            this.econnectFARreply = newParty;
           // this.econnectFARreply = newParty; // Need to swich this to either econnectFARreply or econnectCRMreply
           // this.econnectCRMreply = newParty; // Need to swich this to either econnectFARreply or econnectCRMreply
            this.controller = controller;
            
            CurrencyIsoCode = new_account.CurrencyIsoCode;
        }
        
        /* Get and set methods */
        public String CurrencyIsoCode {get;set;} 
        public Decimal revenueLastYear {get;set;} 
        public Decimal revenueThisYear {get;set;} 
        public Boolean useFARSource {get;set;}
        public Boolean isOld {get;set;}
        // public String partyNumber       { get { return eConnectRow.PartyNumber; } }
        public String partyNumber       { get { return econnectFARreply.PartyIds.PartyNumber[0]; } }
        //public String name              { get { return eConnectRow.PartyName; } }
        public String name              { get { 
        if((econnectFARreply.PartyType=='PERSON' || econnectFARreply.PartyType=='Person' )&&(econnectFARreply.Name[0].PersonFirstName!=null || econnectFARreply.Name[0].PersonMiddleName!=null || econnectFARreply.Name[0].PersonLastName!=null))
        return econnectFARreply.Name[0].PersonFirstName+' '+econnectFARreply.Name[0].PersonMiddleName+' '+econnectFARreply.Name[0].PersonLastName;
        else
        return econnectFARreply.Name[0].PartyName; } }
       // public String status            { get {if(status!=null){return status;} return eConnectRow.status; } set; }
        public String status            { get {if(status!=null){return status;} return getStatus(econnectFARreply.status.Status); } set; }
       
        public boolean hasTurnover      { get { return true; } }
        public boolean isPersonAccount  { get { return getAccountType() == CustomerServiceSearchController.accountType.PERSON_ACCOUNT; } }
        //public String fiscalReference   { get { return eConnectRow.FiscalReference; } }
        //public String street            { get { if(eConnectRow.ResponseAddress != null) { return KATSutilities.clean(eConnectRow.ResponseAddress.AddressName) + ' ' + KATSutilities.clean(eConnectRow.ResponseAddress.DwellingNumber); } return ''; } }
        public String street            { get { if(econnectFARreply.Location != null) { return KATSutilities.clean(econnectFARreply.Location[0].Address[0].StreetName) + ' ' + KATSutilities.clean(econnectFARreply.Location[0].Address[0].BuildingNumber)+' '+KATSutilities.clean(econnectFARreply.Location[0].Address[0].Unit)+' '+KATSutilities.clean(econnectFARreply.Location[0].Address[0].PostOfficeBox); } return ''; } }
        //public String postalCode        { get { if(eConnectRow.ResponseAddress != null) { return KATSutilities.clean(eConnectRow.ResponseAddress.PostalCode); } return ''; } }
        public String postalCode        { get { if(econnectFARreply.Location != null) { return KATSutilities.clean(econnectFARreply.Location[0].Address[0].PostalCode); } return ''; } }
        //public String city              { get { if(eConnectRow.ResponseAddress != null) { return KATSutilities.clean(eConnectRow.ResponseAddress.City); } return ''; } } 
        //public String city              { get { if(econnectFARreply.Location != null) { return KATSutilities.clean(eConnectRow.econnectFARreply.Location[0].Address[0].CityName); } return ''; } } 
          public String city{ get { if(econnectFARreply.Location != null) { return KATSutilities.clean(econnectFARreply.Location[0].Address[0].CityName); } return ''; } }
        //public String city{ {get{return econnectFARreply.Location[0].Address[0].CityName;}}
        private ID salesforceId;
        /*public String address           { get { 
            if(eConnectRow.ResponseAddress != null) {
                return  KATSutilities.clean(eConnectRow.ResponseAddress.AddressName) + ' ' + KATSutilities.clean(eConnectRow.ResponseAddress.DwellingNumber) + ', ' +
                        KATSutilities.clean(eConnectRow.ResponseAddress.PostalCode) + ' ' + KATSutilities.clean(eConnectRow.ResponseAddress.City);
                }
            else { return '-'; }
        }}*/
         public String address           { get { 
            if(econnectFARreply.Location != null) {
          /* return KATSutilities.clean(econnectFARreply.Location[0].Address[0].StreetName) + ' ' + KATSutilities.clean(econnectFARreply.Location[0].Address[0].BuildingNumber) +
                        KATSutilities.clean(econnectFARreply.Location[0].Address[0].PostalCode) + ' ' + KATSutilities.clean(econnectFARreply.Location[0].Address[0].CityName);
               */ 
               String address='';
              // address= KATSutilities.clean(econnectFARreply.Location[0].Address[0].StreetName) + ' ' + KATSutilities.clean(econnectFARreply.Location[0].Address[0].BuildingNumber);
               
               
               if((econnectFARreply.Location[0].Address[0].BuildingNumber=='' || econnectFARreply.Location[0].Address[0].BuildingNumber==null)&&(econnectFARreply.Location[0].Address[0].StreetName=='' || econnectFARreply.Location[0].Address[0].StreetName==null)&&(econnectFARreply.Location[0].Address[0].Unit=='' || econnectFARreply.Location[0].Address[0].Unit==null)&&(econnectFARreply.Location[0].Address[0].PostalCode=='' || econnectFARreply.Location[0].Address[0].PostalCode==null ) && (econnectFARreply.Location[0].Address[0].CityName=='' || econnectFARreply.Location[0].Address[0].CityName==null))
              {
              if((econnectFARreply.PartyType=='PERSON' || econnectFARreply.PartyType=='Person' ))
               address=System.Label.cs_Protected_Address;
               }
               else
               {
                   address= KATSutilities.clean(econnectFARreply.Location[0].Address[0].StreetName) + ' ' + KATSutilities.clean(econnectFARreply.Location[0].Address[0].BuildingNumber) + ' ' +KATSutilities.clean(econnectFARreply.Location[0].Address[0].Unit);
                   if(((econnectFARreply.Location[0].Address[0].PostalCode!='' && econnectFARreply.Location[0].Address[0].PostalCode!=null ) || (econnectFARreply.Location[0].Address[0].CityName!='' && econnectFARreply.Location[0].Address[0].CityName!=null) )&& address!=' ')
                   {
                  System.debug('@@@inside1887@@'+econnectFARreply.Location[0].Address[0].PostalCode);
                  System.debug('@@@inside1887@@'+econnectFARreply.Location[0].Address[0].CityName);
                  System.debug('@@@inside1887@@'+address);
                   address+=','+ KATSutilities.clean(econnectFARreply.Location[0].Address[0].PostalCode)+' '+KATSutilities.clean(econnectFARreply.Location[0].Address[0].CityName);
                   
                   }else
                   {
                  System.debug('@@@inside1887@@'+econnectFARreply.Location[0].Address[0].PostalCode);
                  System.debug('@@@inside1887@@'+econnectFARreply.Location[0].Address[0].CityName);
                   address+= KATSutilities.clean(econnectFARreply.Location[0].Address[0].PostalCode)+' '+KATSutilities.clean(econnectFARreply.Location[0].Address[0].CityName);
                   }
               }   
               return address;
                }
            else { 
            if((econnectFARreply.PartyType=='PERSON' || econnectFARreply.PartyType=='Person' ))
               return System.Label.cs_Protected_Address;
              
               else
            return '-';
             }
        }}
       
       
        public String servicesegment {get;set;}
         public String servicesegmentP {get;set;}
          public String servicesegmentL{get;set;}
        public ID getSalesforceId() { 
            if(this.salesforceId != null) { return salesforceId; }
            return controller.getSfdcAccountIdFor(partyNumber);         
        }
        
        public CustomerServiceSearchController.accountType getAccountType() {
            return (econnectFARreply.PartyType == 'Organization') ? CustomerServiceSearchController.accountType.BUSINESS_ACCOUNT : CustomerServiceSearchController.accountType.PERSON_ACCOUNT;
        }
        
        public String getLastName() {
            String lastName = '';
            for(String s:econnectFARreply.Name[0].PartyName.split(' ', 0)) {
                lastName = s;
            }
            return lastName + '';
        }
         public String getFirstName() {
            String previousName = '';
            String firstName = '';
            try{
            for(String s:econnectFARreply.Name[0].PartyName.split(' ', 0)) {
                firstName += previousName + ' ';
                previousName = s;
            }
            return firstName.trim(); 
        }  catch(System.NullPointerException e) {
               
                return '';
        }
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
                    //system.debug('added another wrapper to the list with key: ' + wrapper.shipmentNumber);
                    holder.shipmentUnitList.add(wrapper);
                }
                else {
                    List<ShipmentWrapper> wrapperList = new List<ShipmentWrapper>();
                    wrapperList.add(wrapper);
                    organizedShipmentList.add(new ShipmentUnitIDHolder(wrapper.shipmentNumber, wrapperList));
                    //system.debug('added new map entry list with key: ' + wrapper.shipmentNumber);
                }
            }
        }
    }
    
    public static string StatusValue(String Status)
    {
        if(Status=='Gyldig' || Status=='Valid')
            return System.Label.cs_valid;
         if(Status=='Dead'  || Status=='Død')
             return System.Label.cs_Dead;
         if(Status=='Bankrupt'||Status=='Konkurs')
         return System.Label.cs_Bankrupt;
         else
             return Status;
        
    }
    
    /* Class for representing a search result row in the shipments search results table */
    public class ShipmentSearchResult extends SearchResult {
        
        private postenNoEconnectKatsSearchshipment.TShipmentUnit eConnectRow { get; set; }
        private CustomerServiceSearchController controller { get; set; }

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
        public ShipmentSearchResult(postenNoEconnectKatsSearchshipment.TShipmentUnit eConnectRow, CustomerServiceSearchController controller) {
            this.eConnectRow = eConnectRow;
            this.controller = controller;
        } 
        
        //public ID salesforce_accountId { get; set; }     

    }

    /* Class for representing a search result row in the contact search results table */
    public class ContactSearchResult extends SearchResult {
        private postenNoEconnectKatsSakgetcustomer.ContactComplexType eConnectRow { get; set; }
        private CustomerServiceSearchController controller { get; set; }
        
        public string name { get{ return firstName + ' ' + lastName; } }
        public string firstName { get{ return KATSutilities.clean(eConnectRow.ContactName.firstname) + ' ' + KATSutilities.clean(eConnectRow.ContactName.middlename); } }
        public string lastName { get{ return KATSutilities.clean(eConnectRow.ContactName.lastName); } }
        public string title { get{ return eConnectRow.title; } }
        public string department { get{ return eConnectRow.department; } }
        public string email { get{ if(eConnectRow.Communication != null) return KATSutilities.clean(eConnectRow.Communication.EMailAddress); else return ''; } }
        public string phone { get{ if(eConnectRow.Communication != null) return KATSutilities.clean(eConnectRow.Communication.PhoneNumber); else return ''; } }
        public string caesarContactId { get{ return eConnectRow.contactId; } }
        private ID salesforceId;
        
        public ContactSearchResult(postenNoEconnectKatsSakgetcustomer.ContactComplexType eConnectRow, CustomerServiceSearchController controller) {
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
    public Static String getStatus(String StatusReceived)
    {
        if(StatusReceived=='Gyldig' || StatusReceived=='Valid')
            return System.Label.cs_Valid;
         
        else if(StatusReceived=='Død' || StatusReceived=='Dead')
             return System.Label.cs_Dead;
        else if(StatusReceived=='Konkurs' || StatusReceived=='Bankrupt')
             return System.Label.cs_Bankrupt;
        else if(StatusReceived=='Duplikat' || StatusReceived=='Duplicate')
             return System.Label.cs_Duplicate;
        else if(StatusReceived=='Forsvunnet' || StatusReceived=='Disappeared')
             return System.Label.cs_Disappeared; 
        
        else if(StatusReceived=='Fusjonert' || StatusReceived=='Merged')
             return System.Label.cs_Merged;   
         else if(StatusReceived=='Likvidert' || StatusReceived=='Liquidated')
             return System.Label.cs_Liquidated; 
          else   if(StatusReceived=='Opphørt' || StatusReceived=='Ceased to exist')
             return System.Label.cs_Ceased_to_exist; 
          else   if(StatusReceived=='Aktive' || StatusReceived=='Active')
             return System.Label.cs_Active;
           else  if(StatusReceived=='Inaktive' || StatusReceived=='Inactive')
             return System.Label.cs_Inactive;     
            else       
             return StatusReceived;
         
    }
      public Static String setModus(string modus)
        {
            If(modus=='FOT' || modus=='CAESAR')
                modus='FAR';
            
            return modus;
        } 
        
     public pagereference creatduplicateContact()
    {
    System.debug('@@@createduplicate325@@@');
        new_contact.Accountid=right_account.id;
        //added as part of contact CR - C-07430
        RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'Customer_Service' And sObjectType = 'Contact' Limit 1];
        Id csRecordTypeId = null;
        If(rtypes.size() > 0) {
        csRecordTypeId  = rtypes.get(0).Id;
        }
        new_contact.recordtypeid=csRecordTypeId;
        new_contact.crm_Contact_Type__c='Customer Service';
        right_contact=createduplicatecon(new_contact);
         addAccountToCase();
            upsert right_case; 
      
        //system.debug('All do actions completed. Getting a relevant pagerefence and returning it to the user.');

        Pagereference r = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/'+right_case.id);
        
        System.debug('@@@r@@'+r);
        r.setredirect(true);
        return r;
    }
    
     public Contact createduplicatecon(Contact contactData)
    {
        contactData = KATSutilities.upsertAsSystem(contactData);
        return contactData;
    }
}