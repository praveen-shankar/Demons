@RestResource(urlmapping='/MybringCommunicationResult/*')

global without sharing class crm_MybringCommunicationResultController {

@HttpPost
global static string MybringCommResult() {
  RestRequest request = RestContext.request;
  MybringCommunicationResult__c messobj = new MybringCommunicationResult__c();
  
  //Extracting the data from the JSON HTTP request object sent from iPad
  RestRequest req = RestContext.request;
  RestResponse res = RestContext.response;
  Blob body = req.requestBody;
  String jsonToParse = body.toString();
  // messobj = (MybringCommunicationResult__c)System.JSON.deserialize(jsonToParse ,MybringCommunicationResult__c.class);
  crm_MybringresWrapper wrapper = crm_MybringresWrapper.parse(jsonToParse);
  System.debug('wrapper object::'+wrapper);
  messobj.Name = wrapper.messageName;
  messobj.crm_Subject_Line__c = wrapper.messageSubject;
  messobj.crm_Message_Body__c = wrapper.messageBody;
  messobj.crm_email_id__c = wrapper.email;  
  messobj.crm_contact__c= wrapper.contactkey;
  messobj.crm_Opened__c = Boolean.valueOf(wrapper.open);
  messobj.crm_Date_Sent__c = Datetime.valueof(wrapper.sentDate);
  messobj.crm_Message_Opened_Date__c = Datetime.valueof(wrapper.messageOpenedDate);  

   System.debug('Message object::'+messobj);
  try{
     insert messobj;
     System.debug('Message inserted successfully');
     return 'Inserted Successfully';
    }Catch(Exception e) {
    return e.getMessage();
    }
    
    
}
 
}