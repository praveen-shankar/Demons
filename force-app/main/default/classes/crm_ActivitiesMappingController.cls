global class crm_ActivitiesMappingController implements Database.batchable<sObject>,Database.Stateful{
           
global Database.querylocator start(Database.BatchableContext BC){
        string query = 'SELECT crm_what_Id__c,crm_who_Id__c ,Whatid , whoid , crm_Owner_Temp__c ,ownerId  FROM Event WHERE crm_who_Id__c != null OR crm_what_Id__c != null';//Getting all the Events where CRM Who and What id are null
        return Database.getQueryLocator(query);
            }

global void execute(Database.BatchableContext BC, List<Event> scope){

      List<Event> events= new List<Event>();      
      for(Event e: scope ){
          
        if(e.crm_what_Id__c != null || e.crm_who_Id__c != null || e.crm_Owner_Temp__c != null){
           e.Whatid = e.crm_what_Id__c; // passing values of crm what id to whatid
           e.whoid = e.crm_who_Id__c; // passing values of crm whoid id to whoid 
            if(e.crm_Owner_Temp__c != null)
               e.ownerId = e.crm_Owner_Temp__c; // passing values of crm owner Temp to ownerId
           events.add(e);                       
            }      
      }
      update events; //updating the events
      events.clear();
    }
    
global void finish(Database.BatchableContext BC){ // Sending mails to Migration Team
    
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    List < string > toAddress = new List < string > ();
    environment_settings__c emailnotifications = environment_settings__c.getValues('BatchEmailNotification');
    List < String > valuesList1 = new List < String > ();
     //System.debug('****** emailnotifications :   '+emailnotifications);
     System.debug('****** emailnotifications.value__c :   '+emailnotifications.value__c);
    //if (emailnotifications != null && emailnotifications.value__c != null) 
    if(emailnotifications.value__c != null)
    valuesList1 = emailnotifications.value__c.split(',');
    System.debug('****** List Of Email :   '+valuesList1);

       for (String emailuser:valuesList1 )
            toAddress.add(emailuser);
            System.debug('****** List Of toAddress :   '+toAddress);  
  //below code will send an email to User about the status
    mail.setToAddresses(toAddress);
    mail.setSenderDisplayName('Event Batch Executed');
    mail.setSubject('Event Batch');
    mail.setPlainTextBody('Event BATCH finished');     
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}


}