public with sharing class Case_SimpleInquiry {
    /**
    *   Method for creating a Case of type SimpleInquiry. To create a SimpleInquiry one needs a phone number and a cdsServiceName.
    *   The cdsServiceName is the name of the service sent in from the CDS-agent. The cdsServiceName is mapped to the custom
    *   object CDS_Service__c which holds default values for different case fields.
    */
    
    public static Case createSimpleInquiry(String anumber, String cdsServiceName)
    {
        Case c;
        Account a;
        Contact con;
        List<CDS_Service__c> serviceList;
        CDS_Service__c service;
        Id recordTypeId;
        Id accountId;
        Id contactId;
        Id postalId;

        if(!KATSutilities.isEmpty(cdsServiceName))
        {
            serviceList = [Select c.Id, 
                                  c.QueueDetails__r.OwnerId,
                                  c.QueueDetails__r.queue_name__c,
                                  c.QueueDetails__r.Queue_id_route_to__c,
                                  c.Case_default_type__c,
                                  c.Case_default_division__c,
                                  c.Code_Event__c,
                                  c.Code_Event__r.name,
                                  c.Def_Rec_Type__c,
                                  c.Auto_Search_Customer__c,
                                  c.Auto_Search_PostUnit__c
                             From CDS_Service__c c 
                            WHERE c.CDS_Service_Group_Name__c = :cdsServiceName LIMIT 1];

            if(!serviceList.isEmpty())
                service = serviceList.get(0);
        }

        String queueId;
        String queueName;
        String serviceId;
        Boolean searchForCustomer = true;

        if(service != null)
        {
            serviceId = service.Id;
            queueId = service.QueueDetails__r.OwnerId;  
            queueName = service.QueueDetails__r.queue_name__c;           
        
            // Checking if the CDS Servicer has a default value set or not
            if(!KATSutilities.isEmpty(service.Def_Rec_Type__c))
            {
                // Fetching the record type id based on the Label of the Record Type
                recordTypeId = KATSutilities.getRecordType(service.Def_Rec_Type__c);
                system.debug('This is recordtype from CDS'+ service.Def_Rec_Type__c);
                system.debug('RecordtypeID:'+recordTypeId);
            }

            // Checking if we need to search for Customer (Account) or Postal Unit with the provided Phone number
            if((service.Auto_Search_Customer__c == false) && (service.Auto_Search_PostUnit__c == true))
                searchForCustomer = false;
        }

        if(searchForCustomer == true)
        {
            if(!KATSutilities.isEmpty(anumber))
            {
                cti_CustomerInfo customerInfo = new cti_CustomerInfo();
                a = customerInfo.getAccountByAPhoneNumber(anumber, false);
            }


            if(a != null)
            {
                accountId = a.Id;
                if(!a.IsPersonAccount)
                {
                    con = getAccountContact(anumber, accountId);
                    if(con != null)
                    {
                        contactId = con.Id;
                    }
                }
            }
        }
        else
        {
            if(!KATSutilities.isEmpty(anumber))
            {
                postalId = KATSutilities.getPostalUnitbyPhone(anumber);
            }
        }

        // If the record type is not found - we will set the default record type
        if(recordTypeId == null)
        {
            recordTypeId = KATSUtilities.getRecordType('simple_inquiry');   // Default Record Type
        }

        c = new Case();
        c.SuppliedPhone = anumber;
        c.hidden_queue_id__c = queueId;
        c.hidden_queue_name__c = queueName;
        c.Origin = 'Telefon';
        c.Status = 'Under behandling';
        
        if(searchForCustomer == true)
        {
            c.accountId = accountId;
            c.ContactId = contactId;
        }
        else
        {
            c.unit_to_blame__c = postalId;
        }
        c.recordTypeId = recordTypeId;
        c.CDS_Service__c = serviceId;
        c.get_Queue_Defaults__c = true;

        database.upsert(c);
        return c;
    }
    
    private static Contact getAccountContact(String anumber, Id accId) {
        
         //added as part of contact CR - C-07430       
        // Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
      
        RecordType[] rtypes = [SELECT Id FROM RecordType Where DeveloperName = 'Customer_Service' And sObjectType = 'Contact' Limit 1];
        Id csRecordTypeId = null;
        If(rtypes.size() > 0) {
        csRecordTypeId  = rtypes.get(0).Id;
        }
        System.debug('Recordtype id: ' + csRecordTypeId);
        

        Contact contactAtCustomer; 
        List<Contact> contactList = [
            select Contact.AccountId, Contact.Id 
            from Contact c 
            where Contact.AccountId = :accId and
            isPersonAccount = false and
            (Contact.Phone = :anumber
            or Contact.MobilePhone = :anumber
            or Contact.OtherPhone = :anumber
            or Contact.Fax = :anumber
            or Contact.AssistantPhone = :anumber) and
            recordtypeid=:csRecordTypeId 
            ];  
             //record type filter added as part of contact CR - C-07430  
        if(contactList.size() > 0) {
            contactAtCustomer = contactList.get(0);  // assume the first result is the contact at the customer
        }
        return contactAtCustomer;
    }
}