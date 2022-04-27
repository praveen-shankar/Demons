/* NOTES

    When propper Webform handling is implemented in KATS the following methods should be removed:
    - getWebformStructureSFDCFields
    - doesWebformStructureExist
    - processWebformEmail
    - getWebformStructureFormFields
    - parseWebform
    - getWebwebformStructureFromEmail

*/

public without sharing class EmailReceiverHelpers {
    
    /*
    *   Method for processing cases that are created by Email2Case, the method is called from EmailRecieverTrigger
    *
    *   @param Map<ID, EmailMessage> map containing case Id's and email messages
    */
    public void processCases(set<ID> ids) {
        
        set<ID> caseIds = ids;
        set<Case> casesToUpdate = new set<Case>();
        set<Case> casesForExtendedSenderSearch = new set<Case>();
        
        for(Case c:[select id, accountId, contactId, RecordTypeId, Origin, suppliedEmail, description, subject from case where id IN :caseIds AND origin LIKE 'Raw%']) {
            
            if(!KatsUtilities.isEmpty(c.Origin) && c.Origin.contains('Raw')) { // Setting the correct Case Origin, Raw should be replaced by Epost
                c.Origin = c.Origin.replace('Raw', 'Epost');
            }
            
            //Check if webform or not
            String webformSubject = '';
            if(!KATSutilities.isEmpty(c.subject)) {
                webformSubject = c.subject.split(':', 2)[0].trim() + ':';
                webformSubject = (webformSubject.length() > 38) ? webformSubject.substring(0,38) : webformSubject;
            }

            if(doesWebformStructureExist(webformSubject))
            {
                processWebformEmail(c, webformSubject);       
            }

            casesToUpdate.add(c);
            
            //Check for customers
            if(c.accountId == null && c.contactId == null)
            {
                casesForExtendedSenderSearch.add(c);
            }
            
        }
        EmailReceiverHelpers.shouldThrowAutoresponse(casesToUpdate);
        //KATSutilities.searchCustomer(casesForExtendedSenderSearch); This is now done in dummy update cases until a proper fix is in place
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.assignmentRuleHeader.useDefaultRule = true;
        list<Case> casesToUpdateAsList = new list<Case>(casesToUpdate);
        database.update(casesToUpdateAsList, dml);
    }

    /*
    *   Check if the address is subject for autoreply or not
    */
    public static void shouldThrowAutoresponse(Set<Case> cases)
    {
        //First check the autoresponse filter
        List<Autresponse_Filter__c> filters = Autresponse_Filter__c.getAll().values();
        
        for(Case c : cases) {
            c.Send_Autoresponse__c = true;
            for(Autresponse_Filter__c filter : filters) {
                if(c.suppliedEmail==null || c.suppliedEmail==''){
                    c.Send_Autoresponse__c = false;
                }
                else if(Pattern.matches(filter.Regex__c, c.suppliedEmail)) {
                    c.Send_Autoresponse__c = false;
                }
            }
            
            //Then see if the same sender have created a case in the same minute
            if(c.Send_Autoresponse__c)
            {
                try 
                {
                    Case lastCase =  [SELECT ID,
                                             CreatedDate,
                                             subject,
                                             origin 
                                        FROM Case 
                                       WHERE SuppliedEmail = :c.suppliedEmail 
                                         AND (NOT(id = :c.id)) 
                                         AND CreatedDate = TODAY 
                                    order by CreatedDate desc limit 1];
                    
                    if(lastCase.CreatedDate > System.now().addMinutes(-1))
                    {
                        c.Send_Autoresponse__c = false;
                    }        
                } 
                catch(QueryException e)
                {
                    //Customer never created case, return true
                }
            }
        }
    }

    /*
    *   Called from the trigger emailAttachmentReassigner. Copys attachments from emails and inserts the copies with a reference to Case
    */
    public static void reassignAttachments(list<Attachment> attachmentsToInvestigate) 
    {
        map<Id, EmailMessage> emails = new map<Id, EmailMessage>();
        list<Id> emailsToInvestigate = new list<Id>();
        list<Attachment> newAtt = new list<Attachment>();
        list<Id> parentCaseId = new list<Id>();
        
        for(Attachment a : attachmentsToInvestigate) { //Collect the id for the emails to investigate
            emailsToInvestigate.add(a.parentId);
        }
        
        for(EmailMessage em : [select id, parentID, incoming from EmailMessage where id in :emailsToInvestigate]) { //Assign the emails to a map
            emails.put(em.id, em);
        }
        
        for(Attachment a : attachmentsToInvestigate)
        { 
            //Go through the attachments, create new ones
            if(!isEmailSignature(a))
            {
                EmailMessage em = emails.get(a.parentId);
                
                String fname = '';
                if(em.Incoming) 
                {
                    fname = System.Label.cs_Emailin;
                } 
                else
                {
                    fname = System.Label.cs_EmailOut;
                }
                
                Attachment b = new Attachment(  Body = a.Body,
                                                ContentType = a.ContentType,
                                                IsPrivate = a.IsPrivate,
                                                Name = fname + a.name,
                                                ParentId = em.ParentId);
                newAtt.add(b);
                parentCaseId.add(em.ParentId);
            }
        }
        if(newAtt.size()>0)
        {
            // Insert the new attachments and notify the cases if an attachment fails.
            try 
            {
                insert newAtt;
            }
            catch(Exception e) 
            {
                List<Case> cases = [SELECT id, attachment_from_email_failed__c FROM Case WHERE id in :parentCaseId];
                for(Case c : cases) 
                {
                    c.attachment_from_email_failed__c = true;
                }
                upsert cases;
            }
        }   
    }

    
    public static boolean isEmailSignature(Attachment a)
    {
        if(Test.isRunningTest())
        {
            return false; // No attachments are "signature" in the test
        }
        else if(Email_Attachment_Filter__c.getInstance('Default')==null)
        {
            return false; // Custom setting 'Default' is not created. 
        }

        Integer attSize=a.bodyLength;
        
        Decimal sizeInKB=Email_Attachment_Filter__c.getInstance('Default').Size__c;
        String content_type=Email_Attachment_Filter__c.getInstance('Default').content_type__c;  
        
        // Assume filter is off if values are empty. No attachments are filtered.
        if(sizeInKB==null){return false;} 
        if(content_type==null || content_type==''){return false;}  
        
        if(content_type=='*'){content_type=a.contentType; } // Match all content types
            
        // If the attachment is both bigger than limit and is of an unwanted content type
        if(attSize<=(sizeInKb*1024) && content_type.contains(a.contentType))
        {
            return true; // This is a signature
        } 
        else
        {           
            return false;   // This is not a signature  
        }
    }
    // end method isEmailSignature
    
    public String[] getWebformStructureSFDCFields(String emailWebformSubject)
    {
        return (webform_structures__c.getInstance(emailWebformSubject).field_mappings__c + ';:::END:::').split(';',0);
    }
    
    public boolean doesWebformStructureExist(String emailWebformSubject)
    {
        try
        {
            if(webform_structures__c.getInstance(KATSutilities.truncate(emailWebformSubject, 38, true)) != null)
            {
                return true;
            }
        }
        catch(Exception e)
        {
            system.debug('email subject was not for a webform.');
            //This is to catch issues with non-latin characters in custom setting values ('æøå'.length() != 3 for custom settings.)
        }

        return false;
    }
    
    public void processWebformEmail(Case c, String webformSubject)
    {
        String[] formValues = parseWebform(webformSubject, c.description);
        String[] toFields = getWebformStructureSFDCFields(webformSubject);
        String[] formFieldNames = getWebformStructureFormFields(webformSubject);
             
        //Setting webform default values:
        c.origin = c.Origin.replace('Epost', 'Web');
        
        c.subject = 'Web: ' + webformSubject;
        
        //Setting case record type based on webform default value
        if(KATSutilities.getRecordType(webform_structures__c.getInstance(webformSubject).default_record_type__c) != null)
        {
            c.recordTypeId = KATSutilities.getRecordType(webform_structures__c.getInstance(webformSubject).default_record_type__c);
        }

        for(integer i=0; i<formValues.size(); i++)
        {
            if(toFields[i] == 'ignore')
            {
                //do nothing - data is still preserved in the emailMessage
            }
            else if(toFields[i] == 'shipment_identification')
            {
                c.shipment_identification__c = (formValues[i] == '') ? '?' : formValues[i];
                c.type__c = 'Registrert';
            }
            else if(toFields[i] == 'phone')
            {
                c.suppliedPhone = formValues[i];
            }
            else if(toFields[i] == 'change_address_ref_no')
            {
                c.change_address_ref_no__c = formValues[i];
            }
            else if(toFields[i] == 'company') {
                c.suppliedCompany = formValues[i];
            }
            else if(toFields[i] == 'org_number') {
                c.suppliedOrganizationNo__c = formValues[i];
            }
            else if(toFields[i] == 'address') {
                c.suppliedAddress__c = formValues[i];
            }
            else if(toFields[i] == 'postal_code') {
                c.suppliedPostalCode__c = formValues[i];
            }
            else if(toFields[i] == 'city') {
                c.suppliedCity__c = formValues[i];
            }
            else if(toFields[i] == 'party_number') {
                c.suppliedPartyNumber__c = formValues[i];
            }
        }
    }
    
    private String[] getWebformStructureFormFields(String emailWebformSubject)
    {
        String fieldNames = webform_structures__c.getInstance(emailWebformSubject).field_names_1__c;
        if(webform_structures__c.getInstance(emailWebformSubject).field_names_2__c != null)
        {
            fieldNames += webform_structures__c.getInstance(emailWebformSubject).field_names_2__c;
        }
        fieldNames += ';:::END:::';
        
        return (fieldNames).split(';',0);
    }
    
    public String[] parseWebform(String webformName, String body)
    {
        return getWebwebformStructureFromEmail(getWebformStructureFormFields(webformName), body);
    }
   
    //Get fields from email and return the values as a String array
    private String[] getWebwebformStructureFromEmail(String[] webformStructureForm, String body)
    {
        if(webformStructureForm != null && !webformStructureForm.isEmpty())
        {
            String[] field = new String[webformStructureForm.size()-1];

            for (Integer i = 0; i < webformStructureForm.size(); i++)
            {
                Integer startIndex = body.indexOf(webformStructureForm.get(i));
                startIndex += webformStructureForm[i].length();
                
                if((i+1) < webformStructureForm.size())
                {
                    Integer endIndex = body.indexOf(webformStructureForm[i+1]);
                    if(endIndex >= 0) {
                        field[i] = body.substring(startIndex, endIndex);
                    } else {
                        field[i] = body.substring(startIndex);
                    }
                }
                else
                {
                    break;
                }
            }
            return field;
        }
        return null;
    }
}