trigger contactPointBeforeTrigger on contactPoint__c (before insert, before update) 
{
    // Fixing Phone Number issue
    // The following process will fix the Phone number and remove all the gaps
    for(contactPoint__c cp: Trigger.New)
    {
        if(cp.phone_number__c != null)
        {
            cp.phone_number__c = cp.phone_number__c.replaceAll(' ','').trim();
            
            //Added a new Phone field to enable click to dial. 04 Oct 2017 - Rajeev Shekhar
            cp.Contact__c = cp.phone_number__c;
        }
        if(cp.fax__c != null)
        {
            cp.fax__c = cp.fax__c.replaceAll(' ','').trim();
        }
    }

}