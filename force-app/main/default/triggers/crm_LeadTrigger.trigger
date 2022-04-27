trigger crm_LeadTrigger on Lead(before insert, before update, after insert, after update) {

    Map < String, String > ISOcountryCodeMap = new Map < String, String > ();
    for (crm_ISO_Country_Codes__c c: crm_ISO_Country_Codes__c.getAll().values())
        ISOcountryCodeMap.put(c.crm_Country__c, c.crm_ISO_Country_Code__c);
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            for (Lead ld: Trigger.New) {
                if (!String.isEmpty(ld.Country)) {
                    if (!ISOcountryCodeMap.containsKey(ld.Country.toLowerCase())) {
                        ld.addError(System.Label.crm_CountryValidation);
                    } else {
                        ld.Country = ld.Country.capitalize();
                    }
                }
            }
        }
    }

    //Added By Sakshi For lead: 
    if (Trigger.IsUpdate && Trigger.isBefore) {
        List < Lead > leadList = new List < Lead > ();

        for (Lead l: Trigger.new) {
            Lead oldLead = Trigger.oldMap.get(l.id);
           // if (l.crm_Has_Agreed_to_Marketing_Activities__c != oldLead.crm_Has_Agreed_to_Marketing_Activities__c || l.crm_Has_declined_Marketing_activities__c != oldLead.crm_Has_declined_Marketing_activities__c)
                crm_leadTriggerHelper.updatemarketingfields(Trigger.new, Trigger.oldMap);
            if (l.crm_website_country__c != oldLead.crm_website_country__c && l.crm_website_country__c != '' && l.crm_website_country__c != null)
                crm_leadTriggerHelper.updateWebsiteCountry(Trigger.new);


        }
    }

    if (Trigger.isInsert && Trigger.isBefore) {
        System.debug('@@' + Trigger.new);
       // crm_leadTriggerHelper.updatemarketingfieldsoninsert(Trigger.new);
        crm_leadTriggerHelper.updateWebsiteCountry(Trigger.new);
    }


}