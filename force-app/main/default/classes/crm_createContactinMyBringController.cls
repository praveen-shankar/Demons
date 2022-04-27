/*
Created by :Supriya Goel
Date: 25th march 2019
crm_createContactinMyBringController

*/

global class crm_createContactinMyBringController
{
    public Contact contactobj {get;set;}
    
    public crm_createContactinMyBringController(ApexPages.StandardController stdController){
        this.contactobj = (Contact)stdController.getRecord();
    }
    
    
    public Pagereference createContactinMyBring() 
    { 
        
        Contact conobj =[Select id, firstname,lastname ,email, mobilephone, phone, Accountid, Preferred_Language__c,My_Bring_Userid__c, Mobile_Country_Code__c , createddate from Contact where id=:contactobj.id limit 1 ];
        
        if  (conobj.My_Bring_Userid__c!='' && conobj.My_Bring_Userid__c!=null)
            return new Pagereference('/apex/contact_created_inmybring?conid='+contactobj.Id);
        
        environment_settings__c prefLanguage = environment_settings__c.getValues('Preferred_Language');
        List < String > valuesList = new List < String > ();
        List < String > value = new List < String > ();
        Map < String, string > prefLanguageMap = new Map < String, String > ();
        if (prefLanguage != null && prefLanguage.value__c != null) {
            valuesList = prefLanguage.value__c.split(',');
            
            for (String str: valuesList) {
                value = str.split('=');
                prefLanguageMap.put(value[1], value[0]);
                
            }
        } 
        
        crm_newContactWrapper wrapperobj= new crm_newContactWrapper();
        
        wrapperobj.usingCustomerNumber = false;
        wrapperobj.firstName= conobj.firstname;
        wrapperobj.lastName= conobj.lastName;
        wrapperobj.userName =conobj.email;
        wrapperobj.phoneNumber= conobj.Mobile_Country_Code__c + conobj.mobilephone;
        
        wrapperobj.createdDateTime = String.valueof(conobj.createddate);
        
        Map<String, String> additionalMap = new Map<String, String>();
        additionalMap.put('Accountid','Myaccount');
        wrapperobj.additionalDetails = additionalMap ;
        
        if (conobj.Preferred_Language__c != null && prefLanguageMap.containskey(conobj.Preferred_Language__c))
            wrapperobj.language= prefLanguageMap.get(conobj.Preferred_Language__c);
        else
            wrapperobj.language = 'EN';
        
        
        String tId = contactobj.Id + String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
        System.debug('JSON BODY' + JSON.serialize(wrapperobj, true));
        HttpRequest req = new HttpRequest();
        req.setBody(JSON.serialize(wrapperobj, true));
        
        environment_settings__c env1 = environment_settings__c.getValues('MyBring_Contact_Insert_Integration');
        if(env1 != null)
            req.setEndpoint(env1.value__c);
        else
            req.setEndpoint('https://www.qa.mybring.com/useradmin/open/api/application/user/signUp'); 
        
        // req.setHeader('X-Salesforce-Api-Name', 'apiUserName');
        // req.setHeader('X-Salesforce-Api-Key', 'apiKey');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        
        
        req.setTimeout(20000);
        System.debug('## req' + req);
        Http http = new Http();
        Pagereference Pref;
        
        try 
        {
            HTTPResponse res = http.send(req);
            System.debug('###res' + res);
            if (res.getStatus() == 'OK' && res.getStatusCode() == 200) 
            {
                conobj.crm_Callout_Status__c = 'Callout Finished';
                conobj.crm_contact_Interface_TransactionId__c = tId;
                update conobj;
                System.debug(conobj);
                Pref = new Pagereference('/apex/Mybringsucess?conid='+contactobj.Id+'&email='+conobj.email);
                
            } 
            
            else //if (res.getStatus() != 'OK' && res.getStatusCode() != 200) 
            {
                crm_Exception_handler.createNonExceptionRecords(res.getStatus(), res.getStatusCode(), conobj.Id, tId, 'Class.crm_contactIntegrationController');
                conobj.crm_contact_Interface_TransactionId__c = tId;
                update conobj;
                System.debug(conobj);
                System.debug(res.getStatusCode());
                Pref = new Pagereference('/apex/MybringFailure?conid='+contactobj.Id+'&email='+conobj.email);
            }
            
            System.debug(conobj);
        }
        Catch(Exception general) {
            crm_Exception_handler.createExceptionRecordsAnyType(general, conobj.Id);
        }
        return Pref;
        
    }
    
}