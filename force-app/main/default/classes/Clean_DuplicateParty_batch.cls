global class Clean_DuplicateParty_batch implements Database.Batchable<sObject>, Database.Stateful{

 global String [] email = new String[] {'postenbringsalesforce.no@capgemini.com'};//Add here your email address here
 
crm_AccountRecordTypes__c Party= crm_AccountRecordTypes__c.getValues('Party level Customer');
global Id PartyRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(Party.crm_Record_Type_Label__c).getRecordTypeId();
global Set<String> orgaNo = new Set<String>();

global Database.Querylocator start (Database.BatchableContext BC){



List<AggregateResult> orgList = [select Orga__c from Account where RecordType.id=:PartyRecordTypeId  GROUP BY Orga__c  HAVING count(Orga__c )>1 ];
for(AggregateResult agg : orgList){
        orgaNo.add(String.valueOf(agg.get('Orga__c')));
    }

System.debug('@@@ Duplicate'+orgaNo.size() + orgaNo);
String QueryString ='select id,  orga__c from Account where RecordType.id=:PartyRecordTypeId and Orga__c IN :orgaNo ';

            return Database.getQueryLocator(queryString);
  
}

   global void execute(Database.BatchableContext bcMain, List<Account> DuplicateAccountList){
   
    environment_settings__c  CDHuser= environment_settings__c.getValues('CDHUserId');
     environment_settings__c  DataMigrationUser= environment_settings__c.getValues('DataMigrationUserId');
      environment_settings__c  Batchjobuser= environment_settings__c.getValues('BatchjobUserId');
   
   String CDHUserId=CDHuser.value__c;
   String DataMigrationUserId=DataMigrationUser.value__c;
   String BatchjobuserId=Batchjobuser.value__c;
    System.debug('@@@ BatchjobuserId'+ BatchjobuserId  + BatchjobuserId);
   List<Account> dmbatchuserrecords = [select id,  orga__c from Account where RecordType.id=:PartyRecordTypeId and Orga__c IN :orgaNo AND (createdBy.id=:Batchjobuserid OR createdBy.id=:DataMigrationUserId)];
   System.debug('@@@ Data migration and  Batch user accounts:'+dmbatchuserrecords.size());
   
   
    List<Account> cdhbatchRecords = [select id,Orga__c from Account where RecordType.id=:PartyRecordTypeId and  Orga__c IN :orgaNo AND createdBy.id=:CDHuserid];
    System.debug('Batch Records:'+cdhbatchRecords.size());
      
    List<Account> alluserRecords = [select id,Orga__c from Account where RecordType.id=:PartyRecordTypeId and  Orga__c IN :orgaNo AND ( createdBy.id!=:CDHuserid  AND createdBy.id!=:Batchjobuserid  AND createdBy.id!=:DataMigrationUserId)];
    System.debug('alluserRecords:'+alluserRecords.size()); 
    System.debug('alluserRecords:'+alluserRecords); 
      
    
    // Creating a Map for each list to store the Account Id against Organisation number
    Map<string,id> DMbatchMap = new Map<string,id> ();
    Map<string,string> CDHbatchMap = new Map<string,string> ();
    Map<string,string> OtheruserMap = new Map<string,string> ();
    
     
    for(Account ab : dmbatchuserrecords){
         DMbatchMap.put(ab.Orga__c , ab.id);
                                     }
    
    for(Account ab1 : cdhbatchRecords){
        CDHbatchMap.put(ab1.Orga__c , ab1.id);
    }
    
   
   
   
List<Account> relationAccounts = [select id,parentId,Parent.orga__c, crm_Primary_Customer_Account__c from Account where parentid !=null and parentId IN : dmbatchuserrecords ]; // Displays the relation accounts related to DM accounts
List<Account> relationAccounts1 = new List<Account>(); 

for(Account a1 : relationAccounts){
    if(CDHbatchMap.containskey(a1.Parent.orga__c)){
    System.debug('@@orga in CDH'+ a1.Parent.orga__c);
      a1.ParentId = CDHbatchMap.get(a1.Parent.orga__c);
      a1.crm_Primary_Customer_Account__c = false;
      relationAccounts1.add(a1);
    }
   
 }
System.debug('@@relationAccounts to be copied ::'+ relationAccounts.size()+relationAccounts );
System.debug('@@ Updated relationAccounts::'+ relationAccounts1.size());
 try{ 
   if(relationAccounts1!=null && relationAccounts1.size()>0)
                    Database.update (relationAccounts1, false);
                }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }     
                
                
                List<crm_Segment__c> dataSegments=[select id,crm_Segment_Name__c,crm_Account__r.Orga__c from crm_Segment__c Where crm_Account__c IN : dmbatchuserrecords ];

// To change the Segment's account id reference from DM to batch
                List<crm_Segment__c> dataSegments1=new List<crm_Segment__c>();

                for(crm_Segment__c s :dataSegments ){
                 if(CDHbatchMap.containskey(s.crm_Account__r.Orga__c)){
                System.debug('@@orga in CDH  for segment'+ s.crm_Account__r.Orga__c);
                              s.crm_Account__c = CDHbatchMap.get(s.crm_Account__r.Orga__c);
                           dataSegments1.add(s);
              }
    }

 try{
    if(dataSegments1!=null && dataSegments1.size()>0)
                    Database.update (dataSegments1, false);
                }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  } 
                
                System.debug('@@dataSegmentsto be copied ::'+ dataSegments.size()+dataSegments);
                System.debug('@@Updated dataSegments::'+ dataSegments1.size());

  List<AccountContactRelation> relationshiplist=[Select id,Account.orga__c, accountid, contactid from AccountContactRelation where accountid in :dmbatchuserrecords];
 List<AccountContactRelation> relationshiplist1=new List<AccountContactRelation>();
 
 For (AccountContactRelation rel: relationshiplist){
 
        if(CDHbatchMap.containskey(rel.Account.Orga__c)){
        System.debug('@@orga in CDH for Account contacts'+ rel.Account.Orga__c);
        
     AccountContactRelation relationship=new AccountContactRelation();
     relationship.accountid= CDHbatchMap.get(rel.Account.Orga__c);
      relationship.contactid= rel.contactid;
     relationshiplist1.add(relationship);
}     
 }
 
 try{
    if(relationshiplist1!=null && relationshiplist1.size()>0)
                    Database.insert(relationshiplist1, false);
                    Delete relationshiplist;
                }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }

System.debug('@@Contact relation to be copied '+ relationshiplist);
System.debug('@@Contact relation updated '+ relationshiplist1);
List<crm_Caesar_Document__c> ceasardocs=[select id,crm_Account__r.Orga__c from crm_Caesar_Document__c Where crm_Account__c IN : dmbatchuserrecords];
                


// To change the Segment's account id reference from DM to batch
                List<crm_Caesar_Document__c> ceasardocs1=new List<crm_Caesar_Document__c>();

                for(crm_Caesar_Document__c s :ceasardocs ){
               
                if(CDHbatchMap.containskey(s.crm_Account__r.Orga__c)){
                System.debug('@@orga in CDH for caesar docs'+ s.crm_Account__r.Orga__c);
                          s.crm_Account__c = CDHbatchMap.get(s.crm_Account__r.Orga__c);
                           ceasardocs1.add(s);
                           }
    }

 try{
    if(ceasardocs1!=null && ceasardocs1.size()>0)
                    Database.update(ceasardocs1, false);
                  
                }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }
 System.debug('@@ caesar docs to be copied'+ ceasardocs.size()+ceasardocs);
  System.debug('@@ caesar docs updated'+ ceasardocs1.size());
 
 List<crm_Caesar_Activity_Document__c> ceasaractdocs=[select id,crm_Account__r.Orga__c from crm_Caesar_Activity_Document__c Where crm_Account__c IN : dmbatchuserrecords];
                


// To change the Segment's account id reference from DM to batch
                List<crm_Caesar_Activity_Document__c> ceasaractdocs1=new List<crm_Caesar_Activity_Document__c>();

                for(crm_Caesar_Activity_Document__c  s :ceasaractdocs ){
                
                if(CDHbatchMap.containskey(s.crm_Account__r.Orga__c)){
                System.debug('@@orga in CDH for caesar activity  docs'+ s.crm_Account__r.Orga__c);
                        s.crm_Account__c = CDHbatchMap.get(s.crm_Account__r.Orga__c);
                           ceasaractdocs1.add(s);
                           }
    }


 try{
    if(ceasaractdocs1!=null && ceasaractdocs1.size()>0)
                    Database.update(ceasaractdocs1, false);
                  
                }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }
                 System.debug('@@ caesar activity docs to be copied'+ ceasaractdocs.size()+ceasaractdocs);
  System.debug('@@ caesar activity docs updated'+ ceasaractdocs1.size());

 List<crm_Customer_Event__c> customerevents = [select id,crm_Account__r.orga__c from crm_Customer_Event__c where crm_Account__c IN : dmbatchuserrecords]; // Displays the relation accounts related to DM accounts
  List<crm_Customer_Event__c> customerevents1 = new List<crm_Customer_Event__c>(); 

for(crm_Customer_Event__c  a1 : customerevents ){
       
                if(CDHbatchMap.containskey(a1.crm_Account__r.orga__c)){
                    System.debug('@@orga in CDH for customer events'+ a1.crm_Account__r.orga__c);
          a1.crm_account__c = CDHbatchMap.get(a1.crm_Account__r.orga__c);
        customerevents1.add(a1);
        }
}

 try{
    if(customerevents1!=null && customerevents1.size()>0)
                    Database.update(customerevents1, false);
                  
                }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }
                
 System.debug('@@ customer events to be copied'+ customerevents.size());
  System.debug('@@ customer events updated'+ customerevents1.size());
                
                 List<crm_Request_RelationCustomer__c> requestedrelationcustomers = [select id,crm_Customer__r.orga__c from crm_Request_RelationCustomer__c where crm_Customer__c IN : dmbatchuserrecords]; // Displays the relation accounts related to DM accounts
  List<crm_Request_RelationCustomer__c> requestedrelationcustomers1 = new List<crm_Request_RelationCustomer__c>(); 

for(crm_Request_RelationCustomer__c  a1 : requestedrelationcustomers){

                if(CDHbatchMap.containskey(a1.crm_Customer__r.orga__c)){
                    System.debug('@@orga in CDH for req relation accounts'+ a1.crm_Customer__r.orga__c);
      a1.crm_Customer__c = CDHbatchMap.get(a1.crm_Customer__r.orga__c);
    requestedrelationcustomers1.add(a1);
    }
}

 try{
    if(requestedrelationcustomers1!=null && requestedrelationcustomers1.size()>0)
                    Database.update(requestedrelationcustomers1, false);
                  
                }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }
                
                 System.debug('@@ requestedrelationcustomers to be copied'+ requestedrelationcustomers.size());
  System.debug('@@ requestedrelationcustomers updated'+ requestedrelationcustomers1.size());
                
                
                List<Opportunity> oppty = [select id,Account.orga__c,stagename,crm_reason_won__c, crm_agreement__c from Opportunity Where AccountId IN : dmbatchuserrecords];


List<Opportunity> opps = new List<Opportunity>();
Set<Id> agrset = new Set<Id>();
Map<Id,Id> Agrmap = new Map<Id, id>();

for(Opportunity o :oppty ){
    if(CDHbatchMap.containskey(o.Account.orga__c)){
                              o.AccountId = CDHbatchMap.get(o.Account.orga__c);
    if(o.stagename=='Closed Won')
             o.crm_reason_won__c='Solution';
    if(o.stagename=='Closed Lost')
             o.crm_reason_lost__c='Not started';   
        
        
        if(o.crm_Language_for_Offer__c ==null  || o.crm_Language_for_Offer__c =='' )
            o.crm_Language_for_Offer__c='NO';
                              agrset.add(o.crm_agreement__c);
                              Agrmap.put(o.crm_agreement__c,CDHbatchMap.get(o.Account.orga__c));
                              
                           opps.add(o);
    }
    }
    
    
List<crm_Agreement__c> aggrements = [select id,crm_Account__r.Orga__c from crm_Agreement__c Where crm_Account__c IN : dmbatchuserrecords ];
List<crm_Agreement__c> aggrements1 = new List<crm_Agreement__c>();  
for(crm_Agreement__c ag1 :aggrements ){
                              ag1.crm_Account__c  = Agrmap.get(ag1.id);
                              aggrements1.add(ag1);
           
    }   
    
     try{
    if(opps!=null && opps.size()>0)
                    Database.update(opps, false);
                  
                }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }
                
                 try{
    if(aggrements1!=null && aggrements1.size()>0)
                    Database.update(aggrements1, false);
                  
                }catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }
                
  
  //move events
  
  List<Event> eventList = [Select id, whatid from event where whatid in :dmbatchuserrecords];
  Map<Id, Id> AccountEventMap = new Map<Id, Id>();
  for(Event e: eventList ){
     AccountEventMap.put(e.id, e.whatid);
    }
    
    System.debug('%%%'+eventList.size()+ eventList ) ;   
   
   List<Account> AcntList =[Select id,orga__c from  Account where  id in :AccountEventMap.values()];
   Map<Id, string> TempMap= new Map<Id, String>();
   for (Account a :AcntList )   
    TempMap.put(a.id, a.orga__c);
  
  
  List<Event> eventList1 = new List<Event>();
   for (Event e : eventList){
      Id Acntid=AccountEventMap.get(e.id);      
      String orga= TempMap.get(Acntid);
      if(CDHbatchMap.containskey(orga)){
        e.whatid= CDHbatchMap.get(orga);  ///orga, acnt.id
        eventList1.add(e);                       
   
   }
 }
   
   System.debug('%%%'+eventList1 );
    try{
    if(eventList1!=null && eventList1.size()>0)
                    Database.update(eventList1 , false);
    } catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }
   
   //move Tasks

  
  List<Task> taskList = [Select id, whatid from task where whatid in :dmbatchuserrecords];
  System.debug('%%%'+taskList  );
  Map<Id, Id> AccountTaskMap = new Map<Id, Id>();
  for(Task t: taskList ){
     AccounttaskMap.put(t.id, t.whatid);
    }
   
   AcntList =[Select id,orga__c from  Account where  id in :AccounttaskMap.values()];
   
   for (Account a :AcntList )   
    TempMap.put(a.id, a.orga__c);
  
  
  List<Task> taskList1 = new List<Task>();
   for (Task t : taskList){
      Id Acntid=AccountTaskMap.get(t.id);      
      String orga= TempMap.get(Acntid);
      if(CDHbatchMap.containskey(orga)){
        t.whatid= CDHbatchMap.get(orga);  ///orga, acnt.id
        taskList1.add(t);                       
   
   }
 }
   
     System.debug('%%%'+taskList1  );
    try{
    if(taskList1!=null && taskList1.size()>0)
                    Database.update(taskList1, false);
    } catch(Exception e) {  crm_Exception_handler.createExceptionRecords(e);  }
    
    Map<String,Account> TodeleteAcnts= new Map<String,Account >();

  
  
   }//end if execute

global void finish(Database.BatchableContext BC){

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors, a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById, a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];//get the job Id
   System.debug('$$$ Jobid is'+BC.getJobId());

  List < string > toAddress = new List < string > ();
    environment_settings__c emailnotifications = environment_settings__c.getValues('BatchEmailNotification');
    List < String > valuesList1 = new List < String > ();
    if (emailnotifications != null && emailnotifications.value__c != null) 
    valuesList1 = emailnotifications.value__c.split(',');
       for (String emailuser:valuesList1 )
            toAddress.add(emailuser);  
  //below code will send an email to User about the status
  mail.setToAddresses(toAddress);
  mail.setSenderDisplayName('Apex Batch Duplicate Party Accounts');
  mail.setSubject('Batch Processing '+a.Status);
  mail.setPlainTextBody('The Batch Apex job processed  '+a.TotalJobItems+' batches with  '+a.NumberOfErrors+' failures'+'Job Item processed are '+a.JobItemsProcessed);
  Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});

    }//End of finish method. Called after all batches are processed. Use to send confirmation emails or execute post - processing operations.
   

}//End of class