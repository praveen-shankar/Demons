/***************************************************************************
** This class contains logic for sending case records to the NPS system   **
****************************************************************************
**                                                                        **
** How to change which fields are passed to the NPS system:               **
**                                                                        **
**  Adding a new field                                                    **
**  1. If a new field is to be added, it first needs to be queried in the **
**     method setCaseList.                                                **
**  2. The field must then be correctly populated into JSON format in the **
**     method writeJSONgenerator                                          **
**                                                                        **
**  Removing a field                                                      **
**  1. If a field is no longer sent to NPS, it should also be removed     **
**     from the query in setCaseList.                                     **
**  2. All references to the field should then be deleted from the method **
**     writeJSONgenerator                                                 **
**                                                                        **
***************************************************************************/
//Cs-Phase 2- Akshata Asukar - 03/01/2017 - Replaced all occurance of Account.party_number__c with Account.crm_customer_number__c

public with sharing class Case_SendToNPS {
            
    private static Map<Id,String> userRoleMap;
    private static List<Case> cases;
    private static List<Case> casesToNPS;
    
    // Status set for the field NPS_Status__c (variables are set to public as they are referenced by test methods)
    public static final String NPS_SUCCESS = 'Sent to NPS';
    public static final String NPS_FAILURE =  'Submission failed';
    public static final String NPS_NOT_QUALIFIED = 'Do not send to NPS'; // The record meets initial criteria (Closed and has a customer), but not enough information to send it to NPS.
    public static final String NPS_NO_SETTINGS = 'Environment not configured for submission of records to NPS-system';
    public static final String NPS_EXCEPTION = 'System exception';
    
    @future (callout=true) // indicates that this is an asynchronous call
    public static void sendCasesToNPS(List<Id> caseIds) {
        
        // Query the necessary fields from case and add to the List<Case> cases
        setCaseList(caseIds);
        
        // Query for login settings to the NPS system
        List<nps_settings__c> settings = nps_settings__c.getAll().values();
        
        if(settings.size() > 0 && settings[0].Send_to_NPS__c){
            // Create the Map<Id,String> userRoleMap where key is UserRoleId and value is UserRole.Name
            setUserRoleMap();
            
            // Create a JSON generator object, and populate message with fields from cases
            JSONGenerator gen = writeJSONgenerator();
            
            if(gen != null){
                // create a string from the JSON generator
                String JSONmessage = gen.getAsString();
                system.debug('JSONmessage String: ' + JSONmessage);
        
                // create an HTTPrequest object
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint(settings[0].endpoint_url__c);
                req.setTimeout(Integer.valueOf(120000));
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Content-Length', String.valueOf(JSONmessage.length()));
                req.setHeader('Accept','application/json');
                req.setHeader('Authorization', createBasicAuthentication(settings[0].Username__c, settings[0].Password__c));
                req.setBody(JSONmessage);        
                system.debug('Sending request: ' + req);  
                
                // Send request and update cases
                Http http = new Http();
                HTTPResponse resp;
                
                if(test.isRunningTest()) 
                { 
                    resp = new HTTPResponse();
                    resp.setStatusCode(200);
                    resp.setBody('Test');
                    setCaseStatus(NPS_SUCCESS, casesToNPS);
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
                            setCaseStatus(NPS_FAILURE, casesToNPS);
                        }
                        else 
                        {
                            //status code = 200, success. Update each Case.
                            setCaseStatus(NPS_SUCCESS, casesToNPS);
                        }
                    } 
                    catch (Exception ex)
                    {
                        setCaseStatus(NPS_EXCEPTION, casesToNPS);
                        system.debug('Sending email notification');
                        ExceptionController.handleException(false, settings[0].Send_Exception_Notification_Email__c, ex,
                            'Exception thrown when trying to send the following message to the NPS-System\n\n ' + JSONmessage, '');
                    }
                }
                
            }
        } 
        else 
        {
            setCaseStatus(NPS_NO_SETTINGS, cases);
        }
        update cases;
    }
    
    private static void setCaseList(List<Id> caseIds) 
    {
        /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
        cases = [SELECT
            AccountId,
                Account.IsPersonAccount,
                Account.Phone,
                Account.Name,
                Account.CRMStatus__c,
                Account.DUNS_number__c,
                Account.Orga__c,
                Account.TotalRevenueCurrentYear_L__c,
                Account.TotalRevenueCurrentYear_P__c,
                Account.TotalRevenuePreviousYear_L__c,
                Account.TotalRevenuePreviousYear_P__c,
            ContactId,
                Contact.Email, //Not in use, should be mapped?
                Contact.MobilePhone,
                Contact.Phone,
                Contact.Name,
            CreatedById,
                CreatedBy.Department,
                CreatedBy.Name,
                CreatedBy.UserRoleId, // Role Name needs to be mapped manually?
            CaseNumber,
            Code_Event__r.name,
                CDS_Service__r.Name,
            ClosedDate,
            CreatedDate,
            Description,
            Division__c,
            Id,
            IsClosed,
            LastModifiedDate,
            NPS_Status__c,
            Origin,
            OwnerId,
                Owner.Name,
                Owner.UserRoleId, // Role Name needs to be mapped manually?
                Parent.CaseNumber,
                Party_number__c,
                Preferred_Communications_Channel__c,
                Produkt__c,
                Service_Product__c,
                ProductId,           
                Service_Product__r.Name,
                Service_Product__r.Eier__c,
                Service_Product__r.Produktfamilie__r.Name,
                Service_Product__r.Produktfamilie__c,
                Code_Reason1__c,
                Code_Reason1__r.name,
                RecordType_Name__c,
                Status,
                Subject,
                SuppliedEmail,
                SuppliedPhone,
                Time_active__c,
                Type__c
                FROM Case 
                WHERE Id IN :caseIds
                 ];
    }
        
    private static JSONGenerator writeJSONgenerator() 
    {
        casesToNPS = new List<Case>();
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        
        String respChannel = null;
        
        for (Case c : cases) 
        {
            respChannel = setPreferredResponseChannel(c); // Set value based on Case fields
            if(respChannel != null)
            { 
                // Only send to NPS if criteria OK
                casesToNPS.add(c);
                
                // NOTE: The JSONGenerator.writeStringField(Object,Object) method can not handle null values!
                gen.writeStartObject();
                
                // Case fields
                gen.writeStringField('Subject', (c.Subject == null ? '' : c.Subject ) );
                gen.writeStringField('ParentCaseNumber', (c.Parent == null ? '' : c.Parent.CaseNumber ) );
                gen.writeStringField('CaseNumber', c.CaseNumber);
                /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
               // if(c.ProductId != null)  COMMENTED FOR SALES 
                if(c.Service_Product__c != null)
                {
                    gen.writeStringField('Product', c.Service_Product__r.Name);

                     if(c.Service_Product__r.Produktfamilie__c != null)
                    {
                        if(c.Service_Product__r.Produktfamilie__r.Name != null || c.Service_Product__r.Produktfamilie__r.Name.trim() != '')
                        {
                            gen.writeStringField('ProductFamily', (c.Service_Product__r.Produktfamilie__r.Name));
                        }
                    }
                    else
                    {
                /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                        gen.writeStringField('ProductFamily', (c.Service_Product__r.Name));  
                    }
                }
                else
                {
                    gen.writeStringField('Product', '');
                    gen.writeStringField('ProductFamily', '');
                }
                gen.writeStringField('Category', (c.Code_Event__c == null ? '' : c.Code_Event__r.name ) );
                gen.writeStringField('Reason', (c.Code_Reason1__c == null ? '' : c.Code_Reason1__r.name ) );
                //gen.writeStringField('RegType', (c.Type__c == null ? '' : c.Type__c ) ); deprecated field 
                gen.writeStringField('PartyNumber', (c.party_number__c == null ? '' : c.party_number__c ) );
                gen.writeStringField('Status', (c.Status == null ? '' : c.Status ) );
                gen.writeStringField('Origin', (c.Origin == null ? '' : c.Origin ) );
                //gen.writeStringField('PreferredCommunicationsChannel', (respChannel));
                gen.writeDateTimeField('DateTimeOpened', c.CreatedDate);
                gen.writeStringField('SuppliedEmail', (c.SuppliedEmail == null ? '' : c.SuppliedEmail) );
                gen.writeDateTimeField('LastModifiedDate', c.LastModifiedDate);
                gen.writeStringField('CaseRecordType', (c.RecordType_Name__c == null ? '' : c.RecordType_Name__c ) );
                gen.writeStringField('SuppliedPhone', (c.SuppliedPhone == null ? '' : c.SuppliedPhone) );
                /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
                gen.writeStringField('BusinessArea', ((c.Service_Product__r.Eier__c == null || c.Service_Product__r.Eier__c.trim() == '') ? '' : c.Service_Product__r.Eier__c) );
                gen.writeStringField('TimeWithCustomerSupport', (c.Time_active__c == null ? '' : c.Time_active__c) );
                if(c.IsClosed)
                {
                    gen.writeDateTimeField('DateTimeClosed', c.ClosedDate);
                } 
                else 
                {
                    gen.writeStringField('DateTimeClosed', '');
                }
                
                // Account fields
                if(c.Account == null ){
                    gen.writeNumberField('AccountRevenueThisYearPost', 0.0);
                    gen.writeNumberField('AccountRevenueThisYearLogistics', 0.0);
                    gen.writeNumberField('AccountRevenueLastYearPost', 0.0);
                    gen.writeNumberField('AccountRevenueLastYearLogistics', 0.0);
                    gen.writeStringField('AccountName', '');
                    gen.writeStringField('AccountPhone', '');
                    gen.writeStringField('AccountKsStatus','');
                    gen.writeStringField('AccountDunsNumber','');
                    gen.writeStringField('AccountOrgNumber','');
                    gen.writeStringField('IsPersonAccount',''); 
                } else {
                    gen.writeBooleanField('IsPersonAccount', c.Account.IsPersonAccount);
                    gen.writeStringField('AccountName', (c.Account.Name == null ? '' : c.Account.Name ) );
                    if(c.Account.IsPersonAccount){
                        gen.writeStringField('ContactName', '');
                        gen.writeStringField('ContactMobile', '');
                        gen.writeNumberField('AccountRevenueThisYearPost', 0.0);
                        gen.writeNumberField('AccountRevenueThisYearLogistics', 0.0);
                        gen.writeNumberField('AccountRevenueLastYearPost', 0.0);
                        gen.writeNumberField('AccountRevenueLastYearLogistics', 0.0);
                        gen.writeStringField('AccountPhone', (c.Account.Phone == null ? '' : c.Account.Phone ) );
                        gen.writeStringField('AccountKsStatus', '');
                        gen.writeStringField('AccountDunsNumber', '');
                        gen.writeStringField('AccountOrgNumber', '');
                    } else {
                        gen.writeNumberField('AccountRevenueThisYearPost', (c.Account.TotalRevenueCurrentYear_P__c == null ? 0.0 : c.Account.TotalRevenueCurrentYear_P__c) );
                        gen.writeNumberField('AccountRevenueThisYearLogistics', (c.Account.TotalRevenueCurrentYear_L__c == null ? 0.0 : c.Account.TotalRevenueCurrentYear_L__c) );
                        gen.writeNumberField('AccountRevenueLastYearPost', (c.Account.TotalRevenuePreviousYear_P__c == null ? 0.0 : c.Account.TotalRevenuePreviousYear_P__c) );
                        gen.writeNumberField('AccountRevenueLastYearLogistics', (c.Account.TotalRevenuePreviousYear_L__c == null ? 0.0 : c.Account.TotalRevenuePreviousYear_L__c) );
                        gen.writeStringField('AccountPhone', '');
                        gen.writeStringField('AccountKsStatus', (c.Account.CRMStatus__c == null ? '' : c.Account.CRMStatus__c ) );
                        gen.writeStringField('AccountDunsNumber', (c.Account.DUNS_number__c == null ? '' : c.Account.DUNS_number__c ) );
                        gen.writeStringField('AccountOrgNumber', (c.Account.Orga__c == null ? '' : c.Account.Orga__c ) );
                        // Contact fields, only if non-person account
                        if(c.Contact == null ){
                            gen.writeStringField('ContactName', '');
                            gen.writeStringField('ContactMobile', '');
                        } else {
                            gen.writeStringField('ContactName', (c.Contact.Name == null ? '' : c.Contact.Name ) );
                            gen.writeStringField('ContactMobile', (c.Contact.MobilePhone == null ? (c.Contact.Phone == null ? '' : c.Contact.Phone) : c.Contact.MobilePhone ) );
                        }
                    }
                }
                
                // CDS Service fields
                gen.writeStringField('CDSServiceName', (c.CDS_Service__r == null ? '' : c.CDS_Service__r.Name) );
                
                // User fields
                gen.writeStringField('CaseOwner', (c.Owner.Name == null ? '' : c.Owner.Name ) );
                gen.writeStringField('CreatedBy', (c.CreatedBy.Name == null ? '' : c.CreatedBy.Name ) );
                gen.writeStringField('CreatedByDepartment', (c.CreatedBy.Department == null ? '' : c.CreatedBy.Department ) );
                
                // User role fields
                gen.writeStringField('CaseOwnerRole', (userRoleMap.get(c.Owner.UserRoleId) == null ? '' : userRoleMap.get(c.Owner.UserRoleId)) ); // Roles are not available automatically
                gen.writeStringField('CreatedByRole', (userRoleMap.get(c.CreatedBy.UserRoleId) == null ? '' : userRoleMap.get(c.CreatedBy.UserRoleId)) ); // Roles are not available automatically
                      
                gen.writeEndObject();
            } 
            else 
            {
                c.NPS_Status__c = NPS_NOT_QUALIFIED;
            }
        }
        // close the JSON generator
        gen.writeEndArray();
        
        // If at least one record satisfies submit criterias, return a JSONgenerator object
        if(casesToNPS.size() > 0)
        {
            return gen;
        }
        return null; // No records meet submit criterias, return null
    }
    
    private static void setUserRoleMap() {
        // Can not get the name of the user role directly from the Case query, needs to be mapped manually
        //public Map<Id,String> userRoleMap = new Map<Id,String>();
        if(userRoleMap == null){
            userRoleMap = new Map<Id,String>();
            for(UserRole ur : [Select Name, Id From UserRole]){
                userRoleMap.put(ur.Id, ur.Name);
            }
        }       
    }
    
    
    // This method returns 'Email', 'SMS' or null, depending on c.Origin
    private static String setPreferredResponseChannel(Case c) 
    {
        String email = 'Email';
        String sms = 'SMS';
        
        //Commenting this complete section as we are no longer using this field - Preferred_Communications_Channel__c for deciding the response channel
        /*
        // Set preferred response channel based on Preferred_Communications_Channel__c
        if(c.Preferred_Communications_Channel__c == 'Epost'){
            return email;
        } else if(c.Preferred_Communications_Channel__c == 'Telefon' || c.Preferred_Communications_Channel__c == 'SMS') {
            return sms;
        } else if(c.Preferred_Communications_Channel__c == 'Brev' || c.Preferred_Communications_Channel__c == 'Fax' || c.Preferred_Communications_Channel__c == 'Ingen tilbakemelding') {
            return null; // Do not send out survey for this case, therefore return null
        }
        */
        
        // Set response channel based on Origin
        /*if(c.Origin == 'Email' || c.Origin.contains('Epost') || c.Origin.contains('Raw') || c.Origin.contains('Web') || c.Origin.contains('Mybring')){
            return email;
        } else if(c.Origin.contains('Telefon') || c.Origin.contains('Phone') || c.Origin.contains('Chat') || c.Origin.contains('Brev') || c.Origin.contains('Fax') || c.Origin.contains('Manuelt') || c.Origin.contains('Import')){
            return sms;
        }*/
        
        
 If(c.RecordType_Name__c =='internal_support'){
            return null;
            c.NPS_Status__c = NPS_NOT_QUALIFIED;
        }else if(c.Origin == 'Email' || c.Origin.contains('Epost') || c.Origin.contains('Raw') || c.Origin.contains('Web') || c.Origin.contains('Mybring')){
            return email;
        } else if(c.Origin.contains('Telefon') || c.Origin.contains('Phone') || c.Origin.contains('Chat') || c.Origin.contains('Brev') || c.Origin.contains('Fax') || c.Origin.contains('Manuelt') || c.Origin.contains('Import')){
            return sms;
        }
        
        // Do not send out survey for this case, therefore return null
        return null;
    }
    
    private static void setCaseStatus(String s, List<Case> cs) 
    {
        for (Case c : cs) 
        {
            c.NPS_Status__c = s;
        }
    }

    private static String createBasicAuthentication(String username, string password)
    {
        Blob b = Blob.valueOf(username + ':' + password);   
        String encodedValue = EncodingUtil.base64Encode(b);   
        return 'Basic ' + encodedValue;
    }
}