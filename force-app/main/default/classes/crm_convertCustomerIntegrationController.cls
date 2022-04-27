/*  Author: Rajeev Shekhar
    Created for Convert Customer Interface Project
    Last Modified Date: 29 April 2018
    Interface must be switched on from custom setting
    User in context must have edit access on Account and relevant fields
*/

public with sharing class crm_convertCustomerIntegrationController implements Queueable, Database.AllowsCallouts {

    //Init
    List < Id > accIds = new List < Id > ();

    //Constructor
    //Pass Account Ids
    public crm_convertCustomerIntegrationController(List < Id > accIds) {
        this.accIds = accIds;
        System.debug('accIds----------- contructor'+accIds);
    }
    
    //Execute method
    public void execute(QueueableContext context) {
        environment_settings__c env = environment_settings__c.getValues('ConvertCustomerInterfaceSwitch');
        System.debug('env ---------'+env);
 
        //Perform callout if the switch is ON
        if ((env != null && env.value__c == 'true') || Test.isRunningTest()) {
            final String CONVERTED = 'Converted';
            final String NOT_CONVERTED = 'NotConverted';
            final String IN_PREP = 'InPreparation';
            
      /*environment_settings__c recipientlist = environment_settings__c.getValues('ToRecipientList');
      environment_settings__c recipientCClist = environment_settings__c.getValues('ToRecipientListCC');
      List < String > toAddress = new List < String > ();
      List < String > toAddressCC = new List < String > ();
      
      if (recipientlist != null && recipientlist.value__c != null) {
       toAddress = recipientlist.value__c.split(';');
    
    
      }
      
      if (recipientCClist != null && recipientCClist.value__c != null) {
       toAddressCC = recipientCClist.value__c.split(';');
    
    
      } */
      
     System.debug('accIds---------'+accIds);
      //List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
               
            if (!accIds.isEmpty()) {
                String accId = null;
                accId = accIds.get(accIds.size() - 1); //get last element

                Account[] partyAccount = [SELECT Id, Name, Orga__c, Customer_Converted__c, crm_customer_converted_date__c,crm_Posten_Source_Comp_for_datarecord_ER__c,
                                          crm_Updated_by_CDH__c,crm_Customer_Conversion_Transaction_Id__c,crm_CDH_RowId__c FROM Account WHERE Id = :accId LIMIT 1];

                System.debug('partyAccount---------'+partyAccount);
                if (partyAccount.size() > 0) {
                    //Wrapper class init
                    crm_convertCustomerWrapper wrapper = new crm_convertCustomerWrapper();
                    crm_convertCustomerWrapper.cls_party party = new crm_convertCustomerWrapper.cls_party();
                    crm_convertCustomerWrapper.cls_account[] accounts = new crm_convertCustomerWrapper.cls_account[] {};

                    //Creating instance of cls_party
                    party.name = partyAccount[0].Name;
                    party.partyNumber = partyAccount[0].crm_CDH_RowId__c;
                    party.organizationNumber = partyAccount[0].Orga__c;
                    party.conversionStatus = partyAccount[0].Customer_Converted__c;
                    party.customerSource = partyAccount[0].crm_Updated_by_CDH__c ? 'CDH' : 'NON_CDH';
                    party.sourceCompany = partyAccount[0].crm_Posten_Source_Comp_for_datarecord_ER__c;
                    
                    Date d = null;
                    System.debug('partyAccount[0].Customer_Converted__c=-------------------- '+partyAccount[0].Customer_Converted__c);
                    System.debug('partyAccount[0].crm_customer_converted_date__c=-------------------- '+partyAccount[0].crm_customer_converted_date__c);
                    if(partyAccount[0].Customer_Converted__c == CONVERTED && partyAccount[0].crm_customer_converted_date__c != null){
                        d = partyAccount[0].crm_customer_converted_date__c;
                    }
                    else if(partyAccount[0].Customer_Converted__c == CONVERTED) {
                        d = System.today();
                    
                    } else if(partyAccount[0].Customer_Converted__c == NOT_CONVERTED || partyAccount[0].Customer_Converted__c == IN_PREP) {
                        d = (partyAccount[0].crm_customer_converted_date__c != null) ? partyAccount[0].crm_customer_converted_date__c : null;
                    }
                    if(d != null) {
                        party.conversionDate = String.valueOf(d.year()) + '-' + String.valueOf(d.month()).leftPad(2, '0') + '-' + String.valueOf(d.day()).leftPad(2, '0');
                    }
                    System.debug('dddddddddddd=-------------------- '+d);
                    wrapper.party = party;
                    System.debug('wrapper.party-------------------- '+wrapper.party);
                    //Query relation acocunts and cross references of party in context
                    Account[] relationAccounts = new List < Account > ();
                    relationAccounts = [SELECT Id, Name, crm_Customer_Number__c,crm_Updated_by_CDH__c,orga__c,Parent.crm_Updated_by_CDH__c,
                        (SELECT Id, Name, crm_Account__c, crm_Origin_System__c, crm_Origin_System_Reference__c, crm_Status__c, Customer_Numberf__c, createddate FROM Related_Account__r WHERE crm_Status__c = 'A') 
                        FROM Account WHERE ParentId =: partyAccount[0].Id
                    ];
                    System.debug('relationAccounts ---------'+relationAccounts);
                    for (Account a: relationAccounts) {
                        //Creating instance of cls_account
                        if(a.crm_Updated_by_CDH__c) {
                            crm_convertCustomerWrapper.cls_account cls_ac = new crm_convertCustomerWrapper.cls_account();
                            crm_convertCustomerWrapper.cls_crossReferences[] cross_References = new crm_convertCustomerWrapper.cls_crossReferences[] {};
                            cls_ac.accountNumber = a.crm_Customer_Number__c;
                            cls_ac.name = a.Name;
    
                            for (crm_Account_Cross_Reference__c c: a.Related_Account__r) {
                                crm_convertCustomerWrapper.cls_crossReferences cr = new crm_convertCustomerWrapper.cls_crossReferences();
                                cr.originReference = c.crm_Origin_System_Reference__c;
                                cr.originSystem = c.crm_Origin_System__c;
                                cr.status = c.crm_Status__c;
                                cross_References.add(cr);
                                //check for spn 
                                
                                if(c.crm_Origin_System__c =='AMPHORA_SPN') {
                                
                                 String formattedDate= DateTime.newInstance(c.createddate.year(),c.createddate.month(),c.createddate.day()).format('d-MM-YYYY');
                               /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                                 mail.setToAddresses(toAddress);
                         mail.setCcAddresses(toAddressCC);
                        // mail.setTargetObjectId(opps.crm_Primary_Opportunity_Contact__c);
                         mail.setSaveAsActivity(false);
                         mail.setUseSignature(false);
                       //  String subj='1';
                        String subj='Mark as converted - ' +c.Customer_Numberf__c+ ' is added to <' + a.orga__c + '> < '+ a.Name + '> on ' + formattedDate ;
                         mail.setSubject(subj);    
                         string body = 'Account details ' ;
                         body = body + '<br/> <br/> Org. no- ' + a.orga__c;
                         body = body + '<br/> <br/> Org. name- ' + a.Name;
                         body = body + '<br/> <br/> Customer Master number- ' + c.Customer_Numberf__c;
                         body = body + '<br/> <br/> Amphora SPN customer number- ' + c.crm_Origin_System_Reference__c;
                         body = body + '<br/> <br/> Date and time when this customer was received in Salesforce from CDH- ' + formattedDate ;
                         
                        
                         body = body + '<br/> <br/> Thanks, <br/> Salesforce Support';
                         
                         System.debug('###body ' + body );
                         mail.setHtmlBody(body);
                         allmsg.add(mail); */
                          }                         
                                
                            }                                         
                            cls_ac.accountCrossReferences = cross_References;    
                            accounts.add(cls_ac);
                        }
                    }
                    wrapper.accounts = accounts;

                    //Unique transaction Id
                    String tId = accId + String.valueOf(Datetime.now().getTime()) + String.valueOf(Math.abs(Crypto.getRandomLong()));
                    System.debug('JSON: ' + JSON.serialize(wrapper));
                    //Creating instance of HttpRequest                   
                    HttpRequest req = new HttpRequest();
                    req.setBody(JSON.serialize(wrapper));
                    req.setEndpoint('callout:crm_convertCustomer_eConnect_endpoint');
                    req.setHeader('TimestampPublish', String.valueOf(System.now().getTime()));
                    req.setHeader('InitiatedById', Userinfo.getUserId());
                    req.setHeader('InitiatedBy', Userinfo.getName());
                    req.setHeader('SourceSystem', 'Salesforce');
                    req.setHeader('SalesforceRecordId', accId);
                    req.setHeader('Content-Type', 'application/json;charset=utf-8');
                    req.setHeader('TransactionId', tId);
                    req.setMethod('POST');
                    req.setTimeout(20000);

                    Http http = new Http();

                    //Final callout
                    try {
                        HTTPResponse res = http.send(req);
                        if (res.getStatus() == 'OK' && res.getStatusCode() == 200) 
                        {
                            System.debug('res.getStatusCode()---------'+res.getStatusCode());
                            if(partyAccount[0].Customer_Converted__c == CONVERTED && partyAccount[0].crm_customer_converted_date__c != null)
                            {
                                Date tempConvertedDate = partyAccount[0].crm_customer_converted_date__c;
                                partyAccount[0].crm_customer_converted_date__c = tempConvertedDate ;
                                //Messaging.sendEmail(allmsg, false);
                            }
                            else if(partyAccount[0].Customer_Converted__c == CONVERTED) 
                            {
                                partyAccount[0].crm_customer_converted_date__c = System.today(); //Converted Date should correspond to today
                                //Messaging.sendEmail(allmsg, false);
                            }
                            
                        } else {crm_Exception_handler.createNonExceptionRecords(res.getStatus(),res.getStatusCode(),accId,tId,'Class.crm_convertCustomerIntegrationController');
                               }
                    } Catch(DMLException dml) {
                        crm_Exception_handler.createExceptionRecords(dml);
                    } Catch(CalloutException call) {
                        crm_Exception_handler.createExceptionRecordsAnyType(call, accId);
                    } Catch(Exception general) {
                        crm_Exception_handler.createExceptionRecordsAnyType(general, accId);
                    } finally {
                          partyAccount[0].crm_Customer_Conversion_Transaction_Id__c = tId; //Always capture the Transaction Id for reference
                        try {
                            update partyAccount;
                        } Catch(Exception e) {
                            System.debug('Exception while updating: '+ e);
                            crm_Exception_handler.createExceptionRecords(e);
                       }
                    }
                }

                //Prepare for next job
                accIds.remove(accIds.size() - 1); //remove last element and send this updated list to next chained job
                if (Test.isRunningTest() == false) {
                    System.enqueueJob(new crm_convertCustomerIntegrationController(accIds)); //submit next job
                }
            }
        }

    }
}