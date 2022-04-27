/**
* cti_CaseService consists of webservices needed for Dolphin CTI/CDS telephone system to access and distribute Salesforce cases between 
* representatives at customer service. For more information see https://service.projectplace.com/pp/pp.cgi/r594686809 
*/

global class cti_CaseService {
    private static final String HOST_NAME = environment_settings__c.getInstance('salesforce_hostname').value__c;
//    private static final String HOST_NAME = URL.getSalesforceBaseUrl().toExternalForm();
  @testVisible
    private static final String baseURL = HOST_NAME + '/';
  
  /**
  * Returns a list of Queue Ids and names CTI uses to retrieve Cases from queue Ids are used on getCases
  */
    webService static List<QueueDetails__c> getQueues() {
        List<QueueDetails__c> queues = [ SELECT QueueDetails__c.Id, QueueDetails__c.queue_name__c 
            FROM QueueDetails__c  where fetch_from_cti__c = true]; // where available_for_Cti is true
        return queues;
    }
    
    /**
    * Returns a list of Case Ids and names CTI uses to distribute Cases. 
    * @param queueDetailsId Id returned from getQueues
    * @param assignedToCTI fetch Cases where assignedToCTI is TRUE/FALSE
    * @param assignedToCTI fetch Cases where assignedToCTIAgent is TRUE/FALSE
    * @return List of Cases with Case.Id and Case.Case_URL__c (URL in Salesforce to Case)
    */
    webService static List<Case> getCases(Id queueDetailsId, Boolean assignedToCTI, Boolean assignedToCTIAgent) {
        List<QueueDetails__c> qdList = [SELECT q.ownerId FROM QueueDetails__c q where q.Id = :queueDetailsId LIMIT 1];
        if(qdList.size() == 0) 
            return null;
        QueueDetails__c qd = qdList.get(0);
        List<Case> casesForQueue;
        if(assignedToCTI != null && assignedToCTIAgent != null) {
            casesForQueue = [SELECT c.Id From Case c where c.OwnerId = :qd.OwnerId and Assigned_to_CTI__c = :assignedToCTI and Assigned_to_CTI_Agent__c = :assignedToCTIAgent order by c.CreatedDate asc];
        } else if(assignedToCTI == null && assignedToCTIAgent != null) {
            casesForQueue = [SELECT c.Id From Case c where c.OwnerId = :qd.OwnerId and Assigned_to_CTI_Agent__c = :assignedToCTIAgent order by c.CreatedDate asc];
        } else if(assignedToCTIAgent == null && assignedToCTI != null) {
            casesForQueue = [SELECT c.Id From Case c where c.OwnerId = :qd.OwnerId and Assigned_to_CTI__c = :assignedToCTI order by c.CreatedDate asc];
        } else {
            casesForQueue = [SELECT c.Id From Case c where c.OwnerId = :qd.OwnerId order by c.CreatedDate asc];
        }
        for(Case c : casesForQueue) {
            // this is actually a redirect to the Visualforce page openCaseFromCTI that resets Case flags Assigned_to_CTI__c and Assigned_to_CTI_Agent__c
            PageReference pageRef = new PageReference(HOST_NAME + '/apex/openCaseFromCTI?id=' + c.Id);
            c.Case_URL__c = pageRef.getUrl();
        }
        return casesForQueue;
    }
    
    /**
     *  Once a Case is distributed, getCase is called to get data needed to present and pop a Case in a user web browser
     *  @param caseId the Id to the Case to be returned
     *  @return the Case along with Case.Id, Case.Case_URL__c, Case.CreatedDate, Case.Subject, Case.Customer_name__c, Case.Entry_Email_Address__c, Case.RecordType.Name, Case.SuppliedEmail, Case.Assigned_to_CTI, Case.Assigned_to_CTI_Agent__c
     */
    webService static Case getCase(Id caseId) {
        //List<Case> cList = [select c.Id, c.Case_URL__c, c.CreatedDate, c.Subject, c.Customer_name__c, c.Entry_Email_Address__c, c.RecordType.Name, c.SuppliedEmail, c.Assigned_to_CTI__c, c.Assigned_to_CTI_Agent__c, c.cti_deadline__c from Case c where c.Id = :caseId];
        List<Case> cList = [select c.Id, c.Case_URL__c, c.CreatedDate, c.Subject, c.Customer_name__c, c.Entry_Email_Address__c, c.RecordType.Name, c.SuppliedEmail, c.Assigned_to_CTI__c, c.Assigned_to_CTI_Agent__c from Case c where c.Id = :caseId];
        if(cList.size() > 0) {
            Case c = cList.get(0);
            // this is actually a redirect to the Visualforce page openCaseFromCTI that resets Case flags Assigned_to_CTI__c and Assigned_to_CTI_Agent__c
            PageReference pageRef = new PageReference(HOST_NAME + '/apex/openCaseFromCTI?id=' + c.Id);
            c.Case_URL__c = pageRef.getUrl();
            return c; 
        }
        else return null;
    }
    
    /**
     * This method is used switch the flags needed to control what Cases are retrieved from getCases
     * @param caseId the Id of a Case whose flags are to be set
     * @param assignedToCTI if assigned to CTI it is TRUE otherwise FALSE
     * @param assignedToCTIAgent if assigned to CTI Agent it is TRUE otherwise FALSE
     */
    webService static void setCaseStatus(Id caseId, Boolean assignedToCTI, Boolean assignedToCTIAgent) {
        List<Case> cList = new List<Case>();
        cList = [SELECT c.Id from Case c where c.Id = :caseId LIMIT 1];
        System.debug('+++ caseId ' + caseId + ' cList.size' + cList.size());
        if(cList.size() > 0) {
            Case c = cList.get(0);
            if(assignedToCTI != null)
                c.Assigned_to_CTI__c = assignedToCTI;
            if(assignedToCTIAgent != null)
                c.Assigned_to_CTI_Agent__c = assignedToCTIAgent;
            update c;
        }
    }
    
    /**
     * This method resets Case Statuses, but is not in use. Instead Dolphin uses setCaseStatus on each indiviudal Case
     *
     * @param queueDetailsId the Id of a QueueDetails__c.Id returned from getQueues 
     */
    webService static void resetCaseStatuses(Id queueDetailsId) {
        List<QueueDetails__c> qdList = [SELECT q.ownerId FROM QueueDetails__c q where q.Id = :queueDetailsId LIMIT 1];
        if(qdList.size() > 0) {
            QueueDetails__c qd = qdList.get(0);
            List<Case> casesToBeReset = [SELECT c.Id, c.Assigned_to_CTI__c, c.Assigned_to_CTI_Agent__c from Case c where c.OwnerId = :qd.OwnerId];
            for(Case c : casesToBeReset) {
                c.Assigned_to_CTI__c = false;
                c.Assigned_to_CTI_Agent__c = true;
            }
            update casesToBeReset;
        }
    }
    
    /**
     * This method is to get the URL to pop a web browser window with customer info for a telephone number. For use by Dolphin IVR agents/scripts.
     * This method is used independantly of the other web services. It is part of the telephone channel
     *
     *      if business account exists in Kats return URL to account. 
     *		if no business account found in KATS, search for person account in KATS
     *      if no accounts found locally, return url to the search page for business accounts.
     *			A search is automatically instantiated with anumber as input parameter.
     *
     * @param anumber telephone number of either a customer or a contact registrered with a customer
     * @return the URL represented as a String to a page in Salesforce with the customer info
     */
    webService static String getURLWithCustomerInfo(String anumber) {
        String url; // 22222222/oiu324098adf
        cti_CustomerInfo customerInfo = new cti_CustomerInfo();     
        if(String.isNotBlank(anumber)) {
            boolean checkBackSystems = false;
            system.debug('Anumber is: ' + anumber);
            Account customer = customerInfo.getAccountByAPhoneNumber(anumber, checkBackSystems);
            system.debug('Account found: ' + customer);
            if(customer != null) { //
                url = createUrl(customer);          
            } else {
                url = createUrl(anumber);
            }
        }
        else {
            url = createUrlForSimpleInquiry();
        }
        return url;
        
    }
    
     /**
     * Caller recognition used by IVR to recognized incomming call and route the caller to correct queue in KSL IVR
     *          VIP - Caller is placed in VIP queue  
     *          SK - (Storkunde) Caller is presented with KSL input menu
     *          NONE - Caller is routed to PBK IVR
     * @param anumber telephone number of the incomming caller
     * @return the segment of the recognized account (VIP, SK, SMB, or empty string);
     */
    webservice static String getSegmentByCallerId(String anumber) {
        String segment = '';
        boolean checkBackSystems = false;
        boolean checkPriority = true;
        Account customer = null;
        if (!KATSutilities.isEmpty(anumber)){
            cti_CustomerInfo customerInfo = new cti_CustomerInfo();
            customer = customerInfo.getAccountByAPhoneNumber(anumber, checkBackSystems, checkPriority);
        }
        String none = 'NONE';
        String crmStatus = (customer != null ? customer.CRMStatus__c : none);
       
       if(crmStatus!=null){
        if(crmStatus.equals('VIP') && !KATSUtilities.isEmpty(customer.Sector__c)){ 
        	crmStatus+='_'+customer.Sector__c.replaceAll(' ', '_');       	
        }
       }
        
        //This is done to ensure non segmentet customers also returns NONE
        return (!KATSUtilities.isEmpty(crmStatus) ? crmStatus : none); 
    }
    public static boolean hasCustomerSector( Account customer){  
    	return (customer.Sector__c!=null ? true : false);
    }
    
    public static String getPhone(String anumber) {
        return anumber.split('/').get(0);
    }
    
    public static Id getQueueId(String anumber) {
        Id id = anumber.split('/').get(1);

        return id;
    }
    
    public static String createUrl(String anumber) {
        String customerSearchURL = new PageReference(baseURL + 'apex/action?action=' + ActionController.SEARCH_CUSTOMER 
        	+ '&' + ActionController.SEARCH_TYPE + '=business'
        	+ '&' + ActionController.PHONE_PARAMETER_NAME + '=' + anumber
        	+ '&' + ActionController.START_SEARCH + '=true'
        	).getUrl();
        return customerSearchURL;
    }
    
    public static String createUrl(Account customer) {
        
        if(customer != null) {
            String accountURL = new PageReference(baseURL + customer.Id).getUrl();
            return accountURL;
        } else 
            return baseURL;
    }
    
    public static String createUrl(Case c) {
        String caseUrl;
        if(c != null) {
            caseUrl = new PageReference(baseURL + c.Id).getUrl();
        } else {
            return new PageReference(baseURL).getUrl(); 
        }
        return caseUrl;
    }
    
    public static String createUrlForSimpleInquiry() {
        String url = new PageReference(baseURL + 'apex/action?action=' + ActionController.CREATE_SIMPLE_INQUERY).getUrl();
        return url;
    }

    
}