/*
    Helper class to delete Cross references from CDH to ensure SF always has the fresh payload
    Author: Rajeev Shekhar
    Project: Customer Conversion CR
    Called by crm_crossReferencesTrigger
*/

public without sharing class crm_crossReferencesTriggerHelper {
    
    public static void process(crm_Account_Cross_Reference__c[] newRecords,System.TriggerOperation triggerEvent) {
        environment_settings__c env = environment_settings__c.getValues('isCrossReferencesTriggerON');
        if((env != null && env.value__c == 'true') || Test.isRunningTest()) {        
            Set <String> customerIds = new Set <String> ();
            Map<String,String> accountMap = new Map<String,String>();
            for(crm_Account_Cross_Reference__c cr: newRecords) {
                if(cr.crm_Customer_Number__c != null)
                    customerIds.add(cr.crm_Customer_Number__c);
            }
            for(Account a : [SELECT Id, crm_Customer_Number__c FROM Account WHERE crm_Customer_Number__c IN :customerIds And RecordType.DeveloperName IN ('business_account','person_account')]) {
                accountMap.put(a.crm_Customer_Number__c,a.Id);
            }
            
            switch on triggerEvent {
                when BEFORE_INSERT{                    
                    if (customerIds.size() > 0) {
                        try {
                            delete [SELECT Id FROM crm_Account_Cross_Reference__c WHERE crm_Account__c IN :accountMap.values() Limit 5000];
                        } Catch(DMLException e) {
                            System.debug('Exception occured while deletion:' + e);
                            crm_Exception_handler.createExceptionRecords(e);
                        }
                    }                
                }
                when AFTER_INSERT {
                    crm_Account_Cross_Reference__c[] toupdatelist = new List<crm_Account_Cross_Reference__c>();
                    for(crm_Account_Cross_Reference__c c : [SELECT Id, crm_Account__c, crm_Customer_Number__c FROM crm_Account_Cross_Reference__c WHERE Id IN :newRecords]) {
                        if(c.crm_Account__c == null && (accountMap.containsKey(c.crm_Customer_Number__c)) && (accountMap.get(c.crm_Customer_Number__c) != null)) {
                            c.crm_Account__c = accountMap.get(c.crm_Customer_Number__c);
                            toupdatelist.add(c);
                        }
                    }
                    if(toupdatelist.size() > 0) {
                        try{
                            update toupdatelist;
                        }catch(Exception e) {
                            System.debug('Exception occured while deletion:' + e);
                            crm_Exception_handler.createExceptionRecords(e);
                        }
                    }
                }
            }
        }               
    }
    
    
    public static void sendemailsforconverted(List<crm_Account_Cross_Reference__c> accountreflist) {

environment_settings__c recipientlist = environment_settings__c.getValues('ToRecipientList');
environment_settings__c recipientCClist = environment_settings__c.getValues('ToRecipientListCC');
  List < String > toAddress = new List < String > ();
  List < String > toAddressCC = new List < String > ();
  
  if (recipientlist != null && recipientlist.value__c != null) {
   toAddress = recipientlist.value__c.split(';');


  }
  
  if (recipientCClist != null && recipientCClist.value__c != null) {
   toAddressCC = recipientCClist.value__c.split(';');


  }
 Set<Id> crossrefids = new Set<Id>();

 
 for (crm_Account_Cross_Reference__c obj: accountreflist){
 if(obj.crm_Origin_System__c =='AMPHORA_SPN')
  crossrefids.add(obj.crm_Account__c);
  
 
 }
 
 List<Account> relAccountsList= [Select id, parentid from account where id in :crossrefids and parent.Customer_Converted__c='Converted'];
 
 Set<id> relids= new Set<Id>();
 for (Account a : relAccountsList) {
     relids.add(a.id);
 
 }
 
 System.debug('###crossrefids' + crossrefids);
 List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
  
 List<crm_Account_Cross_Reference__c> crossList= [Select  id, crm_Account__r.orga__c, crm_customer_number__c ,Customer_Numberf__c, crm_Account__r.name, crm_Account__r.crm_customer_number__c, crm_Origin_System_Reference__c from  crm_Account_Cross_Reference__c where crm_Account__c  in :relids]; 
  System.debug('###crossList' + crossList);
 if (crossList.size()>0) {
 for(crm_Account_Cross_Reference__c obj:crossList ) {
 
  
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   
   String formattedDate= DateTime.newInstance(System.now().year(),System.now().month(),System.now().day()).format('d-MM-YYYY');
    
     mail.setToAddresses(toAddress);
     mail.setCcAddresses(toAddressCC);
    // mail.setTargetObjectId(opps.crm_Primary_Opportunity_Contact__c);
     mail.setSaveAsActivity(false);
     mail.setUseSignature(false);
   //  String subj='1';
    String subj='Mark as converted - ' +obj.Customer_Numberf__c+ ' is added to <' + obj.crm_Account__r.orga__c + '> < '+ obj.crm_Account__r.Name + '> on ' + formattedDate ;
     mail.setSubject(subj);    
     string body = 'Account details ' ;
     body = body + '<br/> <br/> Org. no- ' + obj.crm_Account__r.orga__c;
     body = body + '<br/> <br/> Org. name- ' + obj.crm_Account__r.Name;
     body = body + '<br/> <br/> Customer Master number- ' + obj.Customer_Numberf__c;
     body = body + '<br/> <br/> Amphora SPN customer number- ' + obj.crm_Origin_System_Reference__c;
     
     body = body + '<br/> <br/> Date and time when this customer was received in Salesforce from CDH- ' + formattedDate ;
     
    
     body = body + '<br/> <br/> Thanks, <br/> Salesforce Support';
     
     System.debug('###body ' + body );
     mail.setHtmlBody(body);

     allmsg.add(mail);
     
      System.debug('###allmsg' + allmsg);
     try {
      Messaging.sendEmail(allmsg, false);
     } catch (Exception e) {
      System.debug(e.getMessage());
     }
    }
  
 }
 //send email 
 }
 
}