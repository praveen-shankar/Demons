public with sharing class ActionController {

        private String ACTION = '';
        
        /* ACTION PARAMETERS*/
        public static final string CREATE_SIMPLE_INQUERY = 'createSimpleInquiry';
        public static final String SEARCH_CUSTOMER = 'searchCustomer';
        
        /*OTHER URL PARAMETERS*/
        public static final String PHONE_PARAMETER_NAME = 'phone';
        private final String SERVICE_PARAMETER_NAME = 'cdsServiceGroupName';
        public static final String SEARCH_TYPE = 'searchType';
        private final String CASE_ID = 'caseId';
        public static final String START_SEARCH = 'startSearch';
        
        /**
        * The time stamp parameter was added to the url received from the CDS-agent after error searching.
        * Browser logic on the Posten pc's requires a unique id for each url that is popped in the browser, 
        * otherwise the redirect goes to the same case each time. The time stamp parameter is not persisted,
        * in KATS, and is included solely for the purpose of ensuring that a new case is created each time
        * the url is popped in a browser window.
        */
        private final String TIME_STAMP_PARAMETER_NAME = 'Timestamp';
        public map<String,String> parameters {get;set;}
        
        public String timestamp { get{ return Datetime.now().format('EEE dd.MM.yyyy HH:mm:ss'); } }
        
        public ActionController() {
        PageReference page = ApexPages.currentPage();
        parameters = page.getParameters();
        ACTION = parameters.get('action');
    }
    
        /**
    * Get parameters from the URL and call on various methods.
    * Example input url received from cds agent (production): 
    * https://kats.my.salesforce.com/apex/action?action=createSimpleInquiry&phone=91185684&cdsServiceGroupName=Bedrift_Sporing
    * Example url to instantiate a customer search.
    * https://kats.my.salesforce.com/apex/action?phone=123&action=searchCustomer&searchType=business&startSearch=true
    */
        public pageReference goDo() {
                if(ACTION == CREATE_SIMPLE_INQUERY) {
                        System.debug('Creating new simple inquiry from call from CDS agent. Input url is: ' + ApexPages.currentPage().getUrl() );
                System.debug('TimeStamp recieved from CDS-agent: ' + getPageParameter(TIME_STAMP_PARAMETER_NAME) );
                String phone = getPageParameter(PHONE_PARAMETER_NAME);
                        String serviceName = getPageParameter(SERVICE_PARAMETER_NAME);
                try{
                                Case c = Case_SimpleInquiry.createSimpleInquiry(phone, serviceName);
                        
                                PageReference casePage = new ApexPages.StandardController(c).view();
                                casePage.setRedirect(true);
                        
                        return casePage;
                } catch(Exception e) {
                    ExceptionController.handleException(false, true, e,
                       // 'Det oppsto en feil i en av ActionController/Case_SimpleInquiry klassene.',
                       // CSPhase2, 16122016, Supriya ->Added the labels --> 
                       System.Label.cs_error_in_Action_controller,
                        null
                    );
                    //parameters.put('FEILMELDING', 'Det oppsto en feil i systemet når det ble forsøkt opprettet en ny sak fra en telefonhenvendelse');
                    parameters.put('FEILMELDING', System.Label.cs_Error_telephone_inquiry);
                    // CSPhase2, 16122016, Supriya ->Added the labels --> 
                    
                    
                }
        }
        if(ACTION == SEARCH_CUSTOMER) {
                String url = '/apex/';
                String caseId = getPageParameter(CASE_ID);
                String searchType = getPageParameter(SEARCH_TYPE);
                String phone = getPageParameter(PHONE_PARAMETER_NAME);
                String startSearch = getPageParameter(START_SEARCH);
                
                /* 
                * New search controller call for returning the new customer search pages
                */
                if(String.isNotEmpty(searchtype))
                {
                        if(searchType == 'private')
                        {
                                url += 'customersearch_private';
                        }
                        if(searchType == 'business')
                        {
                                url += 'customersearch_business';
                        }
                } 
                else
                {
                        url += 'customersearch_chooseSearchType';
                }
                
                
                /* 
                * Call for returning the classic main search page
                *
                if(String.isNotEmpty(searchtype) && searchType == 'private') {
                        url += 'mainSearch?searchTab=tabPrivate';
                } else {
                        url += 'mainSearch?searchTab=tabBusiness';
                }*/
                
                if(String.isNotEmpty(caseId)) {
                        url += getPageParameterPrefix(url) + 'caseId='+caseId;
                }
                
                if(string.isNotBlank(phone)) {
                        url += getPageParameterPrefix(url) + 'phone='+phone;
                }
                
                if(startSearch=='true') {
                        url += getPageParameterPrefix(url) + 'startSearch=true';
                }
                        
                return new PageReference(url);
        }
        return null;
        }
        
        /** getPageParameter - 
          * Utility method to fetch parameters from the URL: for instance:
          * https://kats.my.salesforce.com/apex/action?action=createSimpleInquiry&phone=91185684&cdsServiceGroupName=Bedrift_Sporing
          * getParameter(phone) would return the String value "41470099".
          *
          **/
        private String getPageParameter(String paramName) {
                return ApexPages.currentPage().getParameters().get(paramName);
        }
        
        private String getPageParameterPrefix(String currentUrl) {
                if(String.isNotBlank(currentUrl)) {
                        if(currentUrl.contains('?')) {
                                return '&';
                        }
                        return '?';
                }
                return null;
        }
        
        
}