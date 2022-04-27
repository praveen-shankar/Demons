global class FixPhoneInPostalUnitsContact implements Database.Batchable<sObject>
{

   global final String query;

   global FixPhoneInPostalUnitsContact(String q)
   {
      query = q;
   }

   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope)
   {
       List<contactPoint__c> cpList = new List<contactPoint__c>();
       cpList = (List<contactPoint__c>)scope;
       
       if(cpList.size() > 0)
       {
           for(contactPoint__c cp: cpList)
           {
                if(cp.phone_number__c != null)
                {
                    cp.phone_number__c = cp.phone_number__c.replaceAll(' ','').trim();
                }
                if(cp.fax__c != null)
                {
                    cp.fax__c = cp.fax__c.replaceAll(' ','').trim();
                }
           }
           
           database.update(cpList);
       }
   }

   global void finish(Database.BatchableContext BC)
   {
   }
}