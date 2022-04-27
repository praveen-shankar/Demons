/*
Created By: Supriya Goel
Object  :Batch job to put the Party Level Account into the Related To field on Event if this is empty
Date: 30 may 2017
*/

global class crm_setpartyacccountonevent_batch implements Database.Batchable<SObject>{

        String queryString = '';
        public string callback = '';
                        
        public crm_setpartyacccountonevent_batch (String callback){
            this.callback = callback;
                                  
            queryString += 'SELECT Id,whatid, whoid from Event where isrecurrence=false and whatid= null order by createddate desc ';
            
           
          
        }

       global Database.QueryLocator start(Database.BatchableContext bcMain){   
            return Database.getQueryLocator(queryString);
        }
  
       global void execute(Database.BatchableContext bcMain, List<Event> eventList){
           Set<id> Contactids = new Set<Id>();
           Map<Id,Id> EventContactMap = new Map<Id,Id>();
           Map<Id,Id> ContactAcntMap = new Map<Id,Id>();
           Map<Id,Id> ParentAcntMap = new Map<Id,Id>();
           
           for (Event e:  EventList){
           if(e.whoid!=null){
               if(e.whoid.getsobjecttype()==contact.sobjecttype){
                   Contactids.add(e.whoid);
                   EventContactMap.put(e.id,e.whoid); 
           
               }
              }
           }
           
           List<Contact> ContactList= [Select  id, accountid from Contact where id in :Contactids];
           for(Contact con: ContactList){
               ContactAcntMap.put(con.id, con.accountid);
               
               }
               
           // crm_AccountRecordTypes__c rTRelation= crm_AccountRecordTypes__c.getValues('Relation level Customer');    
           //Id RelationLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTRelation.crm_Record_Type_Label__c).getRecordTypeId();    
           List<Account> ParentAccountList=[Select id, parentid from Account  where id in :ContactAcntMap.values() ];//and recordtypeid=:RelationLevelRecordTypeId
             for(Account acnt: ParentAccountList){
                 if(acnt.parentid!=null)
                   ParentAcntMap.put(acnt.id, acnt.parentid);
                  else
                   ParentAcntMap.put(acnt.id, acnt.id); 
               
               }
               
           System.debug('###'+ ParentAcntMap);    
               
               for (Event evnt :EventList){
               if(EventContactMap.containskey(evnt.id)){
                 Id Contactid=EventContactMap.get(evnt.id);
                 Id Relationid=ContactAcntMap.get(Contactid);
                 evnt.whatid=ParentAcntMap.get(Relationid);
               }
            }
               
               Update EventList;
          
       
       }
       
       global void finish(Database.BatchableContext bc){
           String str = '';
        AsyncApexJob[] a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ApexClass.Name from AsyncApexJob where Id =:bc.getJobId() ];
        
        if(callback != '' && callback != null)
           str += callback + '\n';
        if(a != null && a.size() > 0){
                    str += a[0].ApexClass.Name + ' ( '+ a[0].Id + ' ' + a[0].status + ')  processed ' + a[0].TotalJobItems + ' batches with '+ a[0].NumberOfErrors + ' failures.';
                }
        
                  
        //send mail 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List < string > toAddress = new List < string > ();
        environment_settings__c emailnotifications = environment_settings__c.getValues('BatchEmailNotification');
        List < String > valuesList1 = new List < String > ();
        if (emailnotifications != null && emailnotifications.value__c != null) 
        valuesList1 = emailnotifications.value__c.split(',');
     
       for (String emailuser:valuesList1 )
            toAddress.add(emailuser);  
       //below code will send an email to User about the status
        mail.setToAddresses(toAddress);
        mail.setSenderDisplayName('Posten');
        mail.setSubject('Summary for all the batch for SET 1 (Customer, Revenue, agreement , count relation accounts , set primary contact ,whatid set for event) classes');
        mail.setPlainTextBody(str);
        
        // Send the email for the developer reference
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
             
    }
        
}