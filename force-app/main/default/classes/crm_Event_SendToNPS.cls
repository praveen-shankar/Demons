/***************************************************************************
** This class contains logic for sending event records to the NPS system  **
****************************************************************************
**                                                                        **
** How to change which fields are passed to the NPS system:               **
**                                                                        **
**  Adding a new field                                                    **
**  1. If a new field is to be added, it first needs to be queried in the **
**     method setEventList.                                               **
**  2. The field must then be correctly populated into JSON format in the **
**     method writeJSONgenerator                                          **
**                                                                        **
**  Removing a field                                                      **
**  1. If a field is no longer sent to NPS, it should also be removed     **
**     from the query in setEventList.                                    **
**  2. All references to the field should then be deleted from the method **
**     writeJSONgenerator                                                 **
**                                                                        **
***************************************************************************/


public with sharing class crm_Event_SendToNPS {
    
    private static Map<Id,String> userRoleMap;
    private static List<Event> events;
    private static List<Event> eventsToNPS;
    private static Map<Id,Contact> contactsToNPS;
    private static Map<Id,Opportunity> opportunitiesToNPS;
    
    // Status set for the field NPS_Status__c (variables are set to public as they are referenced by test methods)
    public static final String NPS_SUCCESS = 'Sent to NPS';
    public static final String NPS_FAILURE =  'Submission failed';
    public static final String NPS_NOT_QUALIFIED = 'Do not send to NPS'; // The record meets initial criteria (Closed), but not enough information to send it to NPS.
    public static final String NPS_NO_SETTINGS = 'Environment not configured for submission of records to NPS-system';
    public static final String NPS_EXCEPTION = 'System exception';
    
    
    @future (callout=true) // indicates that this is an asynchronous call
    public static void sendEventsToNPS(List<Id> eventIds) {
        
        // Query the necessary fields from case and add to the List<Case> cases
        setEventList(eventIds);
        
        // Query for login settings to the NPS system
        crm_nps_settings_sales__c settings = crm_nps_settings_sales__c.getAll().get('Medallia');

        if(settings != NULL && settings.Send_to_NPS__c != NULL && settings.Send_to_NPS__c){
            // Create the Map<Id,String> userRoleMap where key is UserRoleId and value is UserRole.Name
            setUserRoleMap();
            
            // Create a JSON generator object, and populate message with fields from cases
            String JSONmessage = writeJSONgenerator();
            if(JSONmessage != null){
                // create an HTTPrequest object
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint(settings.endpoint_url__c);
                req.setTimeout(Integer.valueOf(120000));
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Content-Length', String.valueOf(JSONmessage.length()));
                req.setHeader('Accept','application/json');
                // req.setClientCertificateName(settings.client_certificate__c);
                req.setHeader('Authorization', createBasicAuthentication(settings.Username__c, settings.Password__c));
                req.setBody(JSONmessage);        
                system.debug('Sending request: ' + req);  
                system.debug('JSON'+JSONmessage);
                
                // Send request and update cases
                Http http = new Http();
                HTTPResponse resp;
                
                if(test.isRunningTest()) 
                { 
                    resp = new HTTPResponse();
                    resp.setStatusCode(200);
                    resp.setBody('Test');
                    setEventStatus(NPS_SUCCESS, eventsToNPS);
                } 
                else 
                {
                    try
                    {
                        resp = http.send(req);
                        // Update status on cases sent to NPS based on response
                        if (resp.getStatusCode() != 200) 
                        { 
                            // If status code != 200, transmission failed.
                            System.debug('Service returned an error. Statuscode: '+ resp.getStatusCode() + '. Message: ' + resp.getBody() + '. Setting NPS status to failed.');
                            setEventStatus(NPS_FAILURE, eventsToNPS);
                        }
                        else 
                        {
                            //status code = 200, success. Update each Case.
                            setEventStatus(NPS_SUCCESS, eventsToNPS);
                        }
                    } 
                    catch (Exception ex)
                    {
                        setEventStatus(NPS_EXCEPTION, eventsToNPS);
                    }
                }
                
            }
        } 
        else 
        {
            setEventStatus(NPS_NO_SETTINGS, events);
        }
        update events; 
    }
    
    
    private static void setEventList(List<Id> eventIds) 
    {
        List<Id> contactIds = new List<Id>();
        List<Id> opportunityIds = new List<Id>();
        events = [SELECT
                  id,
                  subject,
                  crm_Interaction_Type__c,
                  crm_Interaction_Type_Category__c,
                  crm_NPS_Status__c,
                  who.id,
                  who.type,
                  what.id,
                  what.type,
                  StartDateTime,
                  EndDateTime,
                  ownerId,
                  owner.name,
                  owner.userRoleId,
                  owner.firstName,
                  owner.lastName
                  FROM Event 
                  WHERE Id IN :eventIds
                 ];
        
        for (Event e: events){
            if (e.who.type == 'Contact'){
                contactIds.add(e.who.id);
            }
            if(e.what.type == 'Opportunity'){
                opportunityIds.add(e.what.id);
            }
        }
        
        setContacts(contactIds);
        setOpportunities(opportunityIds);
    }
    
    
    private static void setContacts(List<Id> contactIds){
        List<Contact> contactsForEvents = null;
        contactsForEvents = [SELECT
                             id,
                             firstName,
                             lastName,
                             phone,
                             email,
                             account.id,
                             account.crm_Account_Number_Unique__c,
                             account.phone,
                             account.crm_bus_addr_Country__c,
                             account.crm_Sales_External_Segment__c,
                             account.name
                             FROM Contact 
                             WHERE Id IN :contactIds
                            ];
        contactsToNPS = new Map<Id,contact>();
        contactsToNPS.putAll(contactsForEvents);
        
    }
    
    
    private static void setOpportunities(List<Id> opportunityIds){
        List<Opportunity> opportunitiesForEvents = null;
        // TODO : Need to add fields for business status, business type, product and value
        opportunitiesForEvents =[   SELECT
                                 id,
                                 description,
                                 StageName,
                                 crm_Opp_Service_Family__c,
                                 Type,
                                 Amount
                                 FROM Opportunity 
                                 WHERE Id IN :opportunityIds
                                ];
        opportunitiesToNPS = new Map<Id,Opportunity>();
        opportunitiesToNPS.putAll(opportunitiesForEvents);      
    }
    
    
    private static String writeJSONgenerator() 
    {
        eventsToNPS = new List<Event>();
        
        List<crm_NPS_Request_Type> requestList = new List<crm_NPS_Request_Type>();
        crm_NPS_Request_Type npsRequest = null;
        
        for(Event e: events){
            // send to NPS only if Contact has email or phone
            Contact c = contactsToNPS.get(e.who.id);
            Opportunity p = opportunitiesToNPS.get(e.what.id);
            
            if ( c!= null && (c.email != null || c.phone != null)){
                eventsToNPS.add(e);
                npsRequest = new crm_NPS_Request_Type();
                
                // set the attributes for req - start
                npsRequest.CustomerID = getBlankiFNull(c.account.id);
                npsRequest.CustomerNumber = getBlankiFNull(c.account.crm_Account_Number_Unique__c);
                npsRequest.CustomerPhone = getBlankiFNull(c.account.phone);
                // as per the defect 449, customer country now mapped to business country of SF
                npsRequest.CustomerCountry = getBlankiFNull(c.account.crm_bus_addr_Country__c);
                npsRequest.CustomerName = getBlankiFNull(c.account.name) ; 
                
                npsRequest.ActivityID = getBlankiFNull(e.id);
                npsRequest.ActivityName = getBlankiFNull(e.subject);
                npsRequest.ActivityType = getBlankiFNull(e.crm_Interaction_Type__c) ;
                npsRequest.ActivityCategory = getBlankiFNull(e.crm_Interaction_Type_Category__c);
                npsRequest.ActivityStart = getBlankiFNull(e.StartDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss'));
                npsRequest.ActivityEnd = getBlankiFNull(e.EndDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss'));
                npsRequest.ActivityCustomerService = ''; // leaving it BLANK as per the confirmation from Business
                npsRequest.ActivitySegment = getBlankiFNull(c.account.crm_Sales_External_Segment__c);
                
                if (p != null ){
                    npsRequest.BusinessID = getBlankiFNull(p.id);
                    npsRequest.BusinessDescritpion = getBlankiFNull(p.description);
                    npsRequest.BusinessStatus = getBlankiFNull(p.StageName);//'Ny mulighet';
                    npsRequest.BusinessType = getBlankIFNull(p.Type);//'Kryss-salg';
                    npsRequest.BusinessProduct = getBlankIFNull(p.crm_Opp_Service_Family__c);
                    npsRequest.BusinessValue = getBlankIFNull(string.valueOf(p.Amount));
                    npsRequest.BusinessCustomerService = '';//leaving it BLANK as per the confirmation from Business
                    npsRequest.BusinessSegment = '';//leaving it BLANK as per the confirmation from Business
                }
                
                npsRequest.ActivityResponsibleCaesarUserID = getBlankiFNull(e.ownerId);
                npsRequest.ActivityResponsibleFirstName = getBlankiFNull(e.owner.firstName);
                npsRequest.ActivityResponsibleSurname = getBlankiFNull(e.owner.lastName);
                npsRequest.ActivityResponsibleUnit = getBlankiFNull(userRoleMap.get(e.owner.userRoleId));//'Postens salgsorganisasjon\\Post Bring/Mail\\Salg Norge\\Team 4';
                
                npsRequest.ContactID = getBlankiFNull(c.id);
                npsRequest.ContactFirstName = getBlankiFNull(c.firstName);
                npsRequest.ContactSurname = getBlankiFNull(c.lastName);
                npsRequest.ContactPhoneMobile = getBlankiFNull(c.phone);
                npsRequest.ContactEmail = getBlankiFNull(c.email);
                
                
                // set the attributes for req - end
                requestList.add(npsRequest);            
            }
        }
        
        // If at least one record satisfies submit criterias, return a JSONgenerator object
        if(eventsToNPS.size() > 0)
        {
            return JSON.serialize(requestList); 
        }
        
        return null; // No records meet submit criterias, return null
    }
    
    
    //Creating UserRole Map
    private static void setUserRoleMap() {
        // Can not get the name of the user role directly from the Case query, needs to be mapped manually
        if(userRoleMap == null){
            userRoleMap = new Map<Id,String>();
            for(UserRole ur : [Select Name, Id From UserRole]){
                userRoleMap.put(ur.Id, ur.Name);
            }
        }       
    }
    
    
    //Setting Event Status
    private static void setEventStatus(String s, List<Event> es) 
    {
        for (Event e : es) 
        {
            e.crm_NPS_Status__c = s;
        }
    }
    
    
    //User Authorization
    private static String createBasicAuthentication(String username, string password)
    {
        Blob b = Blob.valueOf(username + ':' + password);   
        String encodedValue = EncodingUtil.base64Encode(b);   
        return 'Basic ' + encodedValue;
    } 
    
    
    //Function to return blank or string
    private static string getBlankiFNull(String s) {
        return (s==null)? '' : s;
    }      
    
}