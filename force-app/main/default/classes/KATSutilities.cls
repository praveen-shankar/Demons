//// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c

public with sharing class KATSutilities { 

    private static map<Id, Entitlement> entitlementMap;
    private static map<Id, BusinessHours> businessHoursMap;
    private static map<Id, QueueDetails__c> queueDetailsMap;
    private static map<Id, RecordType> recordTypeIdsMap;
    private static map<Id, User> fullUsers;
    private static map<Id, CaseStatus> caseStatusMap;
    private static map<String, RecordType> recordTypesDevNameMap;
    private static BusinessHours defaultbh;
    public static string POSTEN_GLOBAL_ADRESSELISTE=getGlobalAddressListName();
    public static map<id, Code_event__c> CodeeventMap;
    //private static Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
    


    // Change Id:  C-01599
    // Developer:  Rohit Paul
    // Date Added: 14-Mar-2016
    // Solution:   This function will accept the endpoint url of iTella where the PDF of the invoice is located
    //             We will read the content of the URL and save the file to the Case
    public static Boolean addInvoiceToCase(String uri, String fileName, String fileType, Id parentId)
    {
        // Checking if we have all the required values
        if(String.isEmpty(uri) || String.isEmpty(fileName) || String.isEmpty(fileType) || String.isEmpty(parentId))
        {
            return false;
        }

        //setting other headers
        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri);
        req.setMethod('GET');
        req.setTimeout(60000);
        req.setHeader('content-type','application/x-www-form-urlencoded; charset=utf-8');
        

        try
        {
            // Sending request
            Http http = new Http();
            HTTPResponse res = http.send(req); 

            // Checking response from endpoint
            if(res.getStatusCode() == 200)
            {
                transient Blob blbPDFContent = res.getBodyAsBlob();                 
                transient Attachment attachmentPDF = new Attachment();
                attachmentPdf.parentId = parentId;
                attachmentPdf.name = fileName + '.' + fileType;
                attachmentPdf.body = blbPDFContent;

                Database.insert(attachmentPDF);
                
                return true;
            }
        }
        catch(Exception e)
        {
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error while fetching PDF: ' + e.getMessage()));
            return false;
        }
        return false;
    } 



    public static String truncate(String s, integer length) {
        return truncate(s, length, false);
    }
    public static String getEventFromId(String ID){
        if (ID==null) return null;
        if(CodeeventMap == null) {
            // Load map
            CodeeventMap = new map<id, Code_event__c>();
            for(Code_event__c ce:[select id, Name from code_event__c]) {
                CodeeventMap.put(ce.id, ce);
               
            }
        }
        return (CodeeventMap.containsKey(ID)) ? CodeeventMap.get(ID).name : null;
    }
    
    public static ID getGlobalAddressListName(){
        if(GlobalAddressListName__c.getInstance('Default')==null){
            system.debug('Failed to retreive the POSTEN_GLOBAL_ADRESSELISTE name/id. This might cause problems for the search controller.');
            system.debug('PLEASE CHECK IF THERE IS A CUSTOM SETTING GlobalAddressListName__c RECORD NAMED Default ! OTHERWISE THIS MUST BE IMPORTED FOR THE SEARCH TO FUNCTION.');
            return null;
        }
        else{
            try{
                return ID.valueOf(GlobalAddressListName__c.getInstance('Default').Name__c);}
            catch(System.StringException se){ return null;}
    }
  
    }
    
    /**
    *
    *   @useBlobSize will convert to blob before truncating and thereby count non-latin characters double. This is handy to overcome the Salesforce issue where custom settings name has max length of 38 LATIN CHARACTERS
    */
    public static String truncate(String s, integer length, boolean useBlobSize) {
        if(useBlobSize && s != null) {
            
            String sTruncated = '';
            String sNextTruncated = '';
            Integer i = 0;
            while(i <= s.length() && Blob.valueOf(sNextTruncated).size() <= length) {
                i++;
                sTruncated = sNextTruncated;
                if(i<=s.length()) { 
                    sNextTruncated = s.substring(0,i);
                }
            }
            return sTruncated;

        }
        else {
            if(s.length() > length) {
                return s.substring(0,length);
            }
        }
        
        return s;
    }
    
    public static String washEmailAddress(String address) {
        String washedEmail = '';
        if(String.isNotBlank(address) && address.contains('@') && address.contains('.')) {
            if(address.contains('mailto:')) {
                address = address.substring(7, address.length());
            }
            
            address = address.replaceAll('[ ,:(*)"\'\\[\\]]*','');
            address = address.deleteWhitespace();
            
            washedEmail = address.toLowerCase();
        }
        if(KATSutilities.isValidEmail(washedEmail)) {
                return washedEmail;
        }
        
        return null;
    }
    
    /**
    * returns a string containing the output from the call to eConnect
    * CR 7176 - CDHCustomerNumber param added - 10th March 2018
    */
    public static String getCustomerOutputEconnect(String partynumber,String[] InformationType) {
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
       //return eConnect.getCustomer(partynumber,CDHCustomerNumber,InformationType).toString();
       return null;
    }
    
    public static boolean isEconnectCustomerOrganization(postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectResponse) {
        if(eConnectResponse.OrganizationParty != null) {
            return true;
        }
        return false;
    }
    
    public static boolean isEconnectCustomerPrivate(postenNoEconnectAboCrmCrmgetcustome.CRMGetCustomerPartyResponseType eConnectResponse) {
        if(eConnectResponse.PersonParty != null) {
            return true;
        }
        return false;
    }
    
    public static User getFullUser(ID userId) {
        if(fullUsers == null || !fullUsers.containsKey(userId) ) {
            fullUsers = new map<ID, User>();
            system.debug('looking for userobject for ' + userId + '. Not cached. Loading it.');
            fullUsers.put(userId, [select id, ldap_username__c, username from User where id=:userId limit 1]);
        }
        return fullUsers.get(userId);
    }
    
    public static String toUpperCase(String s) {
        if(s == null) {
            return s;
        }
        return s.toUpperCase();
    }
    
    public static Account upsertAsSystem(Account a) {
        a.is_system_update__c = true;
        if(KATSutilities.isEmpty(a.crm_customer_number__c)) {
            upsert a;
        } else {
            Database.Upsert(a, Account.crm_customer_number__c);
        }
        return a;
    }
    public static list<Account> upsertAsSystem(list<Account> accounts) {
        list<Account> accountWithPartyNumber = new list<Account>();
        list<Account> accountWithoutPartyNumber = new list<Account>();
        
        for(Account a: accounts) {
            a.is_system_update__c = true;
            if(KATSutilities.isEmpty(a.crm_customer_number__c)){
                accountWithoutPartyNumber.add(a);
            } else {
                accountWithPartyNumber.add(a);
            }
        }
        
        if(accountWithPartyNumber.size() > 0) {
            Database.upsert(accountWithPartyNumber, Account.crm_customer_number__c);
        }
        
        if(accountWithoutPartyNumber.size() > 0) {
            upsert accountWithoutPartyNumber;
        }
        
        accounts.clear();
        accounts.addAll(accountWithPartyNumber);
        accounts.addAll(accountWithoutPartyNumber);
        
        return accounts;        
    }
    public static Contact upsertAsSystem(Contact c) {
          c.is_system_update__c = true;
       
         Database.DMLOptions dml = new Database.DMLOptions();
         dml.DuplicateRuleHeader.AllowSave = true; 
         Database.SaveResult srList = Database.Insert(c,dml);
        //upsert c;
        return c;              
}      
    
    public static list<Contact> upsertAsSystem(list<Contact> contacts) {
        for(Contact c: contacts) {
            c.is_system_update__c = true;
        }
        upsert contacts;
        return contacts;        
    }
    
    public static list<RecordType> getRecordTypeList() {
        if(recordTypeIdsMap == null) {
            loadRecordTypes();
        }
        return recordTypeIdsMap.values();
    }
    
    public static ID getRecordType(String developerName) {
        if(recordTypesDevNameMap == null) {
            loadRecordTypes();
        }
        return (recordTypesDevNameMap.containsKey(developerName)) ? recordTypesDevNameMap.get(developerName).id : null;
    }

    // This function is designed to accept the Label (Record Type) and return back the Id of the Record Type
    public static ID getRecordTypeByName(String recTypeName)
    {
        if(recordTypesDevNameMap == null)
        {
            loadRecordTypes();
        }

        if(recTypeName != null)
        {
            for(RecordType rt: recordTypesDevNameMap.values())
            {
                if(rt.Name.equalsIgnoreCase(recTypeName.trim()))
                {
                    return rt.Id;
                }
            }
        }
        return null;
    }
    
    public static String getRecordType(ID id) {
        if(recordTypeIdsMap == null) {
            loadRecordTypes();
        }
        return (recordTypeIdsMap.containsKey(id)) ? recordTypeIdsMap.get(id).developerName : null;
    }
    
    public static String getRecordTypeName(Id id) {
        if(recordTypesDevNameMap == null) {
            loadRecordTypes();
        }
        return (recordTypeIdsMap.containsKey(id)) ? recordTypeIdsMap.get(id).Name : null;
    }
       
    private static void loadRecordTypes() {
        recordTypesDevNameMap = new map<String, RecordType>();
        recordTypeIdsMap = new map<ID, RecordType>();
        for(RecordType rt:[select id, Name, IsPersonType, developerName, SobjectType from recordtype where isActive=true]) {
            recordTypesDevNameMap.put(rt.developerName, rt);
            recordTypeIdsMap.put(rt.id, rt);
        }
    }
    
        public static String getRecordTypeNameDeveloper(Id id) {
        if(recordTypesDevNameMap == null) {
            loadRecordTypes();
        }
        System.debug('====================recordTypeIdsMap'+recordTypeIdsMap);
        return (recordTypeIdsMap.containsKey(id)) ? recordTypeIdsMap.get(id).developerName: null;
    }

    
    public static ID getDefaultBusinessHours() {
        if(defaultbh == null) {
            loadBusinessHours();
        }
        return defaultbh.Id;
    }
    
    public static String removeLeadingZeros(String s) {
        if(s==null) { return null; }
        return s.replaceFirst('^0+', '');
    }
    
    public static void completeMilestone(List<Id> caseIds, String milestoneName, DateTime complDate) {
        List<CaseMilestone> cmsToUpdate = [select Id, completionDate from CaseMilestone cm where caseId in :caseIds and cm.MilestoneType.Name=:milestoneName and completionDate = null limit 1];
        if (cmsToUpdate.isEmpty() == false){
            for (CaseMilestone cm : cmsToUpdate){
                cm.completionDate = complDate;
            }
            update cmsToUpdate;
        }
    }
    public static void completeAllMilestones(List<Id> caseIds, DateTime complDate) {
        List<CaseMilestone> cmsToUpdate = [select Id, completionDate from CaseMilestone cm where caseId in :caseIds and completionDate = null];
        if (cmsToUpdate.isEmpty() == false){
            for (CaseMilestone cm : cmsToUpdate){
                cm.completionDate = complDate;
            }
            update cmsToUpdate;
        }
    }
    public static void reopenMilestone(List<Id> caseIds, String milestoneName) {
        List<CaseMilestone> cmsToUpdate = [select Id, StartDate, completionDate, CaseId, Case.BusinessHoursId, Case.Time_With_Customer__c  from CaseMilestone cm where caseId in :caseIds and cm.MilestoneType.Name=:milestoneName and completionDate != null limit 1];

        if (cmsToUpdate.isEmpty() == false){
            for (CaseMilestone cm : cmsToUpdate){
                //Case caseWMilestone = new Case (id = cm.CaseId);
                Double businessHoursClosed = (BusinessHours.diff (cm.Case.BusinessHoursId, cm.CompletionDate, System.now()) / 1000.0 / 60 / 60);
                System.debug('cm.CompletionDate'+cm.CompletionDate);                
                System.debug('System.now()'+System.now());              

                /*
                System.debug('businessHoursClosed ' +businessHoursClosed);
                Double businessHoursWCust = cm.Case.Time_With_Customer__c;
                Double businessHoursWSupport = cm.Case.Time_With_Support__c;
                System.debug('businessHoursWCust ' +businessHoursWCust);
                */
                Double timeInInt = (businessHoursClosed);// + businessHoursWCust - businessHoursWSupport);
                System.debug('timinInt ' +timeInInt.intValue());
                System.debug('cm.Case.BusinessHoursId' + cm.Case.BusinessHoursId);
                Datetime tempStartDate = BusinessHours.addGmt (cm.Case.BusinessHoursId, cm.StartDate,(timeInInt * 60 * 60 * 1000L).longValue());
                
                System.debug('tempStartDate ' +tempStartDate);
                System.debug('cm.StartDate ' +cm.StartDate);
                cm.completionDate = null;
                cm.StartDate = tempStartDate;
                
            }
            try{
            update cmsToUpdate;}
            catch(Exception e){
                
                System.debug('Could not reopen milestone');
            }
        }
    }
    
    public static String setHashedUrlOnCase(Case c) {
        DateTime now = System.now();        
        String formattednow = now.formatGmt('yyyy-MM-dd')+'T'+ now.formatGmt('HH:mm:ss')+'.'+now.formatGMT('SSS')+'Z';
        String canonical = c.Subject + formattednow;
        Blob bsig = Crypto.generateDigest('MD5', Blob.valueOf(canonical));
        String token =  EncodingUtil.base64Encode(bsig);
        if(token.length() > 255) { token =  token.substring(0,254); }
        return Encodingutil.urlEncode(token, 'UTF-8').replaceAll('%','_');
    }
    
    private static boolean displayUserMessage = true;
    private static boolean isDisplayUserMessageSet = false;
    private static boolean isDisplayUserMessage(){
        if(isDisplayUserMessageSet){return displayUserMessage; }
        
        if(Filter_info_message__c.getInstance('Default') == null) {
            return true;
        }
        
        if(ApexPages.currentPage() == null) {
            return true;
        }
        
        if(ApexPages.currentPage().getUrl() == null) {
            return true;
        }
        
        if(ApexPages.currentPage().getUrl().contains('mainSearch') == false) {
            return true;
        }
        
        if(UserInfo.getProfileId() == [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Systemadministrator'].Id) {
            return true;
        }
        
        displayUserMessage = Filter_info_message__c.getInstance('Default').Display_User_Message__c;
        isDisplayUserMessageSet = true;
        return displayUserMessage;
    }
        
    public static void addMessage(ApexPages.message m) {
        if(Apexpages.currentPage() == null) {
            system.debug(m.getSeverity() + ': ' + m.getSummary());
        }
        else {
            if(m.getSeverity() == ApexPages.Severity.INFO){
                if(KATSutilities.isDisplayUserMessage()){
                    ApexPages.addMessage(m);
                } else{ 
                    system.debug(m);
                }   
            } else {
                ApexPages.addMessage(m);
            }
        }
    }
    
    public static boolean isEmpty(String s) { 
        return (s==null || s==''); 
    }
    
    public static String clean(String s) { 
        if(s == null) { return ''; }
        return s; 
    }
    
    public class Timer {
        private long timeForRequest;
        private long timeForReply;
        
        
        public void startTimer() {
            timeForRequest = System.now().getTime();
        }
        public void stopTimer() {
            timeForReply = System.now().getTime();
        }
    }
    public static String getLastName(String name) {
        if(name == null) {  return ''; }
        
        if(name.contains(',') && !name.equals(',') ){ return name.split(',')[0].trim() + ''; }
        
        String lastName = name;
        for(String s:name.split(' ', 0)) {
            lastName = s;
        }
        return lastName + ''; 
    }
    public static String getFirstName(String name) {
        if(name == null) {  return ''; }
        
        if(name.contains(',') && !name.equals(',') && name.split(',').size()>1){ return name.split(',',2)[1].trim() + ''; }
        
        String previousName = '';
        String firstName = '';
        for(String s:name.split(' ', 0)) {
            firstName += previousName + ' ';
            previousName = s;
        }
        
        return firstName.trim();
    }
    
    private static set<String> currentUsersGroupNames;
    public static final String GROUP_NAME_FOR_FULL_PRIVATE_CUSTOMER_SEARCH = 'Permission- full private customer search';
    public static final String GROUP_NAME_FOR_NO_PRIVATE_CUSTOMER_SEARCH = 'Permission- no private customer search';
    public static boolean isCurrentUserMemberOfGroup(String groupName) {
        
        if(currentUsersGroupNames == null) {
            system.debug('Querying and caching current user\'s group memberships');
            currentUsersGroupNames = new set<String>();
            for(GroupMember gm : [SELECT gm.id, gm.group.name FROM GroupMember gm  WHERE gm.Group.Type='Regular' AND gm.UserOrGroupId=:UserInfo.getUserId()]) {
                currentUsersGroupNames.add(gm.group.name);
            }
            system.debug('Current user is member of: ' + currentUsersGroupNames);
        }
        return currentUsersGroupNames.contains(groupName);
    }
    
    public static boolean isValidEmail(String email) {
        return Pattern.matches('^[a-zA-Z0-9]{1}[a-zA-Z0-9\\.\\-_]{1,}@[a-zA-Z0-9]{1}[a-zA-Z0-9\\.\\-]{1,}\\.{1}[a-zA-Z]{2,4}$', email);
    }
    
    public static boolean shouldTriggerRun() {
        /*if(UserInfo.getUserName() == 'tor-hakon.sigurdsen@posten.capgemini.com'){// || UserInfo.getUserName() == 'soren.krabbe@posten.capgemini.com'){
            return false;
        }*/
        
        return true;
    }
    
    /* A current bug? in Salesforce means that is a case has an entitlement object added when only 
    the case.owner field is updated, the entitlement logic does not seem to recalculate the milestones 
    on the case. To overcome this, this dummy update can be invoked to ensure that the owner change 
    results in a true case update which will make the entitlement functionality recalculate. 
    
    Now further functionality has been added to copy data from case milestones to the case object. 
    This is to allow advanced reporting. Hence the call to copyResolutionMilestoneToCase
    
    Important to note that nothing in this method must do changes to a case which could result in an 
    @future call on that case (it's not allowed - exception gets thrown). See caseFollowUpTaskMaintainer.trigger for details about what causes @future invocations. */
    @future
    public static void dummyUpdateCase(list<ID> caseIds) {
        system.debug('Dummy updating');
        list<Case> cases = new list<Case>();
        //for(ID caseId:caseIds) {
            //system.debug('Dummy updating case with id:' + caseId);
            //Case c = new Case(id=caseId);
            //cases.add(c);
        //}
        cases = copyResolutionMilestoneToCase(caseIds);
        
        system.debug(cases);
        update cases;
        
        
        //cases.clear();
        //cases = [SELECT id, accountId, suppliedEmail, contactId FROM Case WHERE id in :caseIds];
        
        //update KATSutilities.performExtendedSenderSearch(cases);
    }

    /* For each caseId the case.hidden_solution_SLA_deadline__c value will be set equal to the related caseMilestone.targetDate.
    a list containing all cases defined in the caseIds list will be returned
    (this is because this is an extension of the bugfix described in method dummyUpdateCase()) */
    public static list<case> copyResolutionMilestoneToCase(list<ID> caseIds) {
        system.debug('calling copyResolutionTimeMilestoneToCase');
        
        list<case> casesWithMilestones = [select id, subject, hidden_solution_SLA_deadline__c, (select id, targetDate from casemilestones where MilestoneType.Name = 'Løsningsfrist') from case where id in :caseIds]; //No approprite custom setting to place 'Løsningsfrist' in. Should be the name of the milestone which indicates resolution deadline.
        list<case> casesToReturn = new list<case>();

        for(Case c : casesWithMilestones) {
            if( c.caseMilestones.size()==0 ) {
                system.debug('case has no related milestones');
                if(c.hidden_solution_SLA_deadline__c != null) {
                    c.hidden_solution_SLA_deadline__c = null;
                    
                }
                casesToReturn.add(c); 
            }
            else {
                system.debug('case has no >0 related milestones');
                if(c.hidden_solution_SLA_deadline__c != c.caseMilestones.get(0).targetDate ) {
                    c.hidden_solution_SLA_deadline__c = c.caseMilestones.get(0).targetDate;
                    casesToReturn.add(c);
                }
            }
        }
        system.debug('cases to return by copyResolutionMilestoneToCase');
        system.debug(casesToReturn);
        return casesToReturn;
    }

    
    public static Datetime addMinutesToDateWithRespectToBusinessHours(integer minutes, Datetime beforeDate, BusinessHours bh) {
        System.assertNotEquals(minutes, null);
        if(beforeDate == null) {
            beforeDate = DateTime.now();
        }
        System.assertNotEquals(bh, null);
        System.assertNotEquals(bh.Id, null);
        return BusinessHours.add(bh.Id, beforeDate, minutes*60*1000L);
    }
    
    private static void loadQueueDetails() {
        queueDetailsMap = new map<Id, QueueDetails__c>();
        for(QueueDetails__c qd : [SELECT id, OwnerId, entitlement__c,
                                            Default_Division_In_Queue__c,
                                            Business_Hours__c,
                                            Code_Event__c,
                                            Product__c,
                                            Code_Reason1__c,
                                            Code_Reason2__c,
                                            Code_Event__r.Name,
                                            Product__r.Name,
                                            Code_Reason1__r.Name,
                                            Code_Reason2__r.Name,
                                            is_inactive_queue__c,
                                            queueEmailAddress__c,
                                            fetch_from_cti__c,
                                            queue_owner__c,
                                            queue_owner__r.email,
                                            Queue_id_route_to__c,
                                            Auto_Close_Case__c
                                            FROM QueueDetails__c]) {
            QueueDetailsMap.put(qd.id, qd);
        }
    }
    
    public static map<Id, QueueDetails__c> getQueueDetails() {
        if(queueDetailsMap == null) {
            KATSutilities.loadQueueDetails();
        }
        return queueDetailsMap;
    }
    
    private static void loadCaseStatus() {
        caseStatusMap = new map<Id, CaseStatus>();
        for(CaseStatus cs : [SELECT Id, MasterLabel, IsClosed, ApiName  FROM CaseStatus]) {
            caseStatusMap.put(cs.id, cs);
        }
    }
    
    public static map<Id, CaseStatus> getCaseStatuses() {
        if(caseStatusMap == null) {
            KATSutilities.loadCaseStatus();
        }
        return caseStatusMap;
    }
    
    private static void loadBusinessHours() {
        businessHoursMap = new map<Id, BusinessHours>();
        list<BusinessHours> bhList = [SELECT IsActive, Id, Name, CreatedById,
                                                CreatedDate, IsDefault, FridayEndTime,
                                                FridayStartTime, LastModifiedById,
                                                LastModifiedDate, MondayEndTime,
                                                MondayStartTime, SaturdayEndTime,
                                                SaturdayStartTime, SundayEndTime,
                                                SundayStartTime, SystemModstamp,
                                                ThursdayEndTime, ThursdayStartTime,
                                                TimeZoneSidKey, TuesdayEndTime,
                                                TuesdayStartTime, WednesdayEndTime,
                                                WednesdayStartTime FROM BusinessHours];
        for(BusinessHours bh : bhList) {
            businessHoursMap.put(bh.id, bh);
            if(bh.IsDefault) {
                defaultbh = bh;
            }
        }
    }
    
    private static void loadEntitlements() {
        entitlementMap = new map<Id, Entitlement>();
        
        list<Entitlement> entitlementList = [SELECT Id, Name FROM Entitlement];
        
        for(Entitlement e : entitlementList) {
            entitlementMap.put(e.id, e);
        }
    }
    
    public static map<Id, Entitlement> getEntitlements() {
        if(entitlementMap == null) {
            KATSutilities.loadEntitlements();
        }
        return entitlementMap;
    }
    
    public static map<Id, BusinessHours> getBusinessHours() {
        if(businessHoursMap == null) {
            KATSutilities.loadBusinessHours();
        }
        return businessHoursMap;
    }
    
    public static BusinessHours getBusinessHours(Case c) {
        if(queueDetailsMap == null) {
            KATSutilities.loadQueueDetails();
        }
        for(QueueDetails__c qd : queueDetailsMap.values()) {
            if(c.ownerId == qd.ownerId) {
                return KATSutilities.getBusinessHours().get(qd.Business_Hours__c);
            }
        }
        return null;
    }
    
    /*
    *   Doing a local search in KATS for contact using the contact email and case.SuppliedEmail.
    *   Getting the latest updated match and assigns contact and customer.
    */
    public static void getContactFromEmail(list<Case> cases) {
        
    RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'Customer_Service' And sObjectType = 'Contact' Limit 1];
    Id csRecordTypeId = null;
    If(rtypes.size() > 0) {
    csRecordTypeId  = rtypes.get(0).Id;
    }
    System.debug('Recordtype id: ' + csRecordTypeId);
        map<String, Contact> contactMap = new Map<String, Contact>();
        list<String> emails = new list<String>();
        for(Case c : cases) {
            if(c.AccountId == null && c.contactId == null && !KATSutilities.isEmpty(c.suppliedEmail)) {
                emails.add(c.suppliedEmail);
            }
        }
        try {
            if(emails.size()>0){
            //contact record type filter added as part of contact CR - C-07430
            
        List<Contact> con1 = [SELECT id, AccountId, Account.RecordTypeid, email FROM Contact WHERE email in :emails AND (status__c='Aktiv' OR status__c='') AND isPersonAccount =false AND Account.Id!=:POSTEN_GLOBAL_ADRESSELISTE and recordtypeid=: csRecordTypeId ORDER BY LastModifiedDate DESC ];
        for (Contact con:con1)
        {
           //Csphase2 Supriya 27122016
           // for(Contact con : [SELECT id, AccountId, email FROM Contact WHERE email in :emails AND (status__c='Active' OR status__c='') AND isPersonAccount = false AND Account.Id!=:POSTEN_GLOBAL_ADRESSELISTE ORDER BY LastModifiedDate DESC ]) {
                
            String Acc_recordtypeDevName = getRecordType(con.Account.RecordTypeid);
            if(!(Acc_recordtypeDevName.contains('crm_Party_level_Customer') || Acc_recordtypeDevName.toLowerCase().contains('crm_Prospect')) ){
                if(!contactMap.containsKey(con.email)) 
                {
                    contactMap.put(con.email, con);
                }

                }
            }
            }
        } catch(Exception e) {
             ExceptionController.handleException(false, true, e, '', '');
            }
        
        for(Case c : cases) {
            if(c.AccountId == null && c.contactId == null && contactMap.containsKey(c.suppliedEmail)) {
                Contact con = contactMap.get(c.suppliedEmail);
                 if(con != null) {
                    c.contactId = con.id;
                     c.accountId = con.AccountId;
                            
                   
                    if(c.SuppliedEmail != null && c.SuppliedEmail !=''){
                        c.Preferred_Communications_Channel__c = 'Epost';
                    }
                }
            }
        }
    }
    
    /*
    *   Max !!! (call outs) Supported.
    *   
    *   Search eConnect for customer in FOT/CAESAR
    *
    */
/*    @future(callout=true)
    public static void performExtendedSenderSearchAsync(set<Id> caseIds) {
        list<Case> casesToUpdate = new list<Case>();
        list<Case> cases = [SELECT id, accountId, contactId, SuppliedEmail FROM Case WHERE id in :caseIds];
        
        casesToUpdate = KATSutilities.performExtendedSenderSearch(cases);
        
        if(casesToUpdate.size() > 0) {
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.assignmentRuleHeader.useDefaultRule = true;
            database.update(casesToUpdate, dml);
            //upsert casesToUpdate;
            //Log error messages are unclear when update is called through "database.". However it's needed to run assignmentrules after update.
        }
    }
*/    
    public static Case performExtendedSenderSearch(Case c) {
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        map<String, String> eConnectSearchParams;
        String matchingPartyNumber;
        
        if(c.AccountId == null && c.ContactId == null) {
            eConnectSearchParams = new map<String, String>();
            if(!KATSutilities.isEmpty(c.change_address_ref_no__c)) {
                eConnectSearchParams.put('forwardingnumber', c.change_address_ref_no__c.toUpperCase());
            } else if(!KATSutilities.isEmpty(c.Invoice_no__c)) {
                eConnectSearchParams.put('invoice_number', c.Invoice_no__c);
            } else if(!KATSutilities.isEmpty(c.suppliedEmail)) {
                eConnectSearchParams.put('email', c.suppliedEmail);
                if(!KATSutilities.isEmpty(c.Division__c)) {
                    if(c.Division__c.contains('privat')) {
                        eConnectSearchParams.put('party_type', 'Person');
                    } else {
                        eConnectSearchParams.put('party_type', 'Organization');
                    }
                }
            }
            
            if(eConnectSearchParams.size() > 0) {
                try {
                    postenNoEconnectAboCrmCrmsearchcust.CustomerPartyListType[]  eConnectReply = eConnect.SearchPartyCRM(eConnectSearchParams);
                    if(eConnectReply.size() > 0) {
                        system.debug('Contact/account match found in eConnect: ' + eConnectReply);
                        
                        if(eConnectReply != null && eConnectReply.Size()>0 && eConnectReply.get(0) != null) {
                            matchingPartyNumber = eConnectReply.get(0).AccountNumber;
                            String[] InformationType;
                           DataPersistencyController.maintainAccount(matchingPartyNumber,InformationType);
                            Account a = [select id, isPersonAccount from Account where crm_customer_number__c=:matchingPartyNumber limit 1];
                            

                            c.AccountId = a.id;
                            if(a.IsPersonAccount) {
                                c.ContactId = a.PersonContactId;
                            }
                        }
                    }
                }
                catch(Exception e) {
                    KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Something went wrong when looking for the case.supplied e-mail in eConnect - ' + e.getMessage() ));
                }
            }
        }
        return c;
    }
    
    public static list<Case> performExtendedSenderSearch(list<Case> cases) {
        list<Case> casesToUpdate = new list<Case>();
        postenNoEconnectUtilities eConnect = new postenNoEconnectUtilities();
        map<String, String> eConnectSearchParams;
        String matchingPartyNumber;

        for(Case c : cases) {
            if(!KATSutilities.isEmpty(c.SuppliedEmail) && c.AccountId == null && c.ContactId == null) {
                system.debug('No contact matches (by email) found in salesforce. Asking eConnect regarding case: ' + c);
                eConnectSearchParams = new map<String, String>();
                eConnectSearchParams.put('email', c.suppliedEmail);
                
                try {
                    /*postenNoEconnectKatsSaksearchcustome.KATS_SakSearchCustomerOutParameters eConnectReply = eConnect.searchCustomer('1', eConnectSearchParams);
                    if(eConnectReply.TotalNumberOfRecords > 0) {
                        system.debug('Contact/account match found in eConnect: ' + eConnectReply);
                        
                        if(eConnectReply.CustomerList != null && eConnectReply.CustomerList.Customer != null && eConnectReply.CustomerList.Customer.get(0) != null) {
                            matchingPartyNumber = eConnectReply.CustomerList.Customer.get(0).partyNumber;
                            String[] InformationType;
                            DataPersistencyController.maintainAccount(matchingPartyNumber,InformationType);*/
                            Account a = [select id,RecordType.DeveloperName, isPersonAccount from Account where PersonEmail=:c.suppliedEmail limit 1];
                            if(a!=null)
                            if(!(a.RecordType.DeveloperName.toLowerCase().contains('crm_Party_level_Customer') || a.RecordType.DeveloperName.toLowerCase().contains('crm_Prospect')) ){
                            c.AccountId = a.id;
                            }

                            if(a.IsPersonAccount) {
                                c.ContactId = a.PersonContactId;
                            }
                            casesToUpdate.add(c);
                        
                    
                }
                catch(Exception e) {
                    KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Something went wrong when looking for the case.supplied e-mail in eConnect - ' + e.getMessage() ));
                }
            }
        }
        return casesToUpdate;
    }
    
      /* Validate shipmentID or shipmentUnitID*/
    /* A valid ID should consists of only alphanumeric characters. Size must be between 9 and 35 */
    /* returns true if valid */
   public static boolean validateShipmentID(String shipmentId){
    boolean isValid=true;
    if(shipmentId==null){
      //  KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Det ser ikke ut som om du har lagt inn gyldig referanse. Postens referansenummer har fra 9 - 35 tegn'));
      //Csphase2 Supriya 27122016
      KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.label.cs_valid_reference));
        isValid= false;
    }
    // Check size. 9< size <35
    else if(shipmentId.length()<9 || shipmentId.length()>35){
        //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Det ser ikke ut som om du har lagt inn gyldig referanse. Postens referansenummer har fra 9 - 35 tegn'));
        //Csphase2 Supriya 27122016
      KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.label.cs_valid_reference));
        isValid= false;
        isValid= false;
    }
    // Check valid characters
    else if(!shipmentId.isAlphanumeric()){
        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Det ser ikke ut som om du har lagt inn gyldig referanse. Bare alfanumeriske tegn er tillatt i referansen'));
        //Csphase2 Supriya 2712216
        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.label.cs_valid_reference_alphanumeric));
    isValid= false;
    }
    return isValid;
   }
    
    public static void removeAccountFromCase(List<Case> newCaseList){
        for(Case c : newCaseList) {      
            if(c.AccountID!=null){      
                if(c.AccountID==POSTEN_GLOBAL_ADRESSELISTE){
                    c.AccountID=null;
                    c.ContactID=null;
                }
            }
        }
    }


    // This function will accept the Phone number from CDS Servicer
    // Search for the related Postal Unit using the phone number in:
    // - Kontaktpunkt (contactPoint__c)
    // - Enhetskontakter (Unit_Contact__c)
    // Return back the ID of the Postal Unit
    public static Id getPostalUnitbyPhone(String anumber)
    {
        // NULL check
        if(anumber != null)
        {
            // BLANK check
            if(anumber.trim() != '')
            {
                // Prepares a LIST of possible numbers by removing Leading Zeroes (0) one by one
                String numList = KATSutilities.getAllPossiblePhoneNumbers(anumber);

                // SOSL for the contactPoint__c OBJECT
                List<List<SObject>> contactPointSOSL = [FIND :numList IN ALL FIELDS RETURNING contactPoint__c (postal_unit__c WHERE postal_unit__r.is_active_int__c = true)];
                // SOSL for the Unit_Contact__c OBJECT
                List<List<SObject>> unitContSOSL = [FIND :numList IN ALL FIELDS RETURNING Unit_Contact__c (postal_unit__c WHERE postal_unit__r.is_active_int__c = true)];

                // Result Sets
                List<contactPoint__c> cpList = (List<contactPoint__c>)contactPointSOSL[0];
                List<Unit_Contact__c> ucList = (List<Unit_Contact__c>)unitContSOSL[0];
                
                // Checking for possible scenarios
                // The Phone numbers of Postal Units are very unique.
                // The Logic below is created on the Assumption that we are going to get a very unique Unit_Contact AND/OR contactPoint
                // for the number received

                // contactPoint found, but NO Unit_Contact found 
                // Making sure that we have got a single Postal Unit. 
                // In Case of multiple search results we do not link the Case to Postal Unit.
                if(cpList.size() == 1 && ucList.size() == 0)
                {
                    return cpList[0].postal_unit__c;
                }

                // Unit_Contact found, but NO contactPoint found
                // Making sure that we have got a single Postal Unit. 
                // In Case of multiple search results we do not link the Case to Postal Unit.
                else if(cpList.size() == 0 && ucList.size() == 1)
                {
                    return ucList[0].postal_unit__c;
                }   

                // BOTH Unit_Contact and contactPoint have matches
                // Making sure that we have got a single Postal Unit. 
                // In Case of multiple search results we do not link the Case to Postal Unit.
                else if(cpList.size() == 1 && ucList.size() == 1)
                {
                    // We will return value only when both Unit_Contact and contactPoint point to the SAME Postal Unit
                    if(cpList[0].postal_unit__c == ucList[0].postal_unit__c)
                    {
                        return ucList[0].postal_unit__c;
                    }
                    // Else we see an issue in the data and the Postal Unit must be added manually by the User
                }

            }
        }

        return null;
    }


    //Function to create a String of all possible numbers by truncating the additional zeroes at the beginning of the number
    //Example: The number received from CTI is 0004045
    //Output of this function: '0004045 OR 004045 OR 04045 OR 4045'
    //This value will be passed into the SOSL query for the Customer Search
    public static String getAllPossiblePhoneNumbers(String aNumber)
    {
        String temp = aNumber;
        String numList = temp;
        
        while(temp.startsWith('0'))
        {
            temp = temp.substring(1);
            numList = numList + ' OR ' + temp;
        }
        
        return numList;
    }
    
    @future
    public static void setCommunityassignmentrule(set<Id> caseIds) {
        list<Case> casesToUpdate = [SELECT id,hidden_queue_id__c FROM Case WHERE id in :caseIds];
                
      /*  if(casesToUpdate.size() > 0) {
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.assignmentRuleHeader.useDefaultRule = true;
            database.update(casesToUpdate, dml);*/
            System.debug('@@@ in update');
            
            for (Case cs: casesToUpdate ){
            if(cs.hidden_queue_id__c==null)
            {
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.assignmentRuleHeader.useDefaultRule = true;
                cs.setoptions(dml);
             }   
               
            
            }
            
             try {update(casesToUpdate );}
    catch (DmlException e) {  System.debug('in exception'+e);}

            
             System.debug('@@@ after update');
        //}
    }
  
}