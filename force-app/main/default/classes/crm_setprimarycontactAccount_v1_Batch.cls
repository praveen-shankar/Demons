/*
Created By:Supriya Goel
Date: 11 th june 2019 
setprimary contact on account 

*/

global class crm_setprimarycontactAccount_v1_Batch implements Database.batchable<sObject>,Database.Stateful{
    public string callback = '';        
    global crm_setprimarycontactAccount_v1_Batch (String callback){
        this.callback = callback;   
    }
    
   global Database.QueryLocator start(Database.BatchableContext BC){
         crm_AccountRecordTypes__c rTParty= crm_AccountRecordTypes__c.getValues('Party level Customer');
         Id PartyLevelRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(rTParty.crm_Record_Type_Label__c).getRecordTypeId();
         
        
              
        String query = 'Select id,  Primary_contact__c, Warrants_Postage__c, Set_Primary_Contact__c from account  where RecordTypeId = :PartyLevelRecordTypeId and Set_Primary_Contact__c = false order by createddate desc '; 
        if(callback!='')
            query = 'Select id,  Primary_contact__c, Warrants_Postage__c, Set_Primary_Contact__c from account  where RecordTypeId = :PartyLevelRecordTypeId and id =:callback and Set_Primary_Contact__c = false order by createddate desc '; 
        return Database.getQueryLocator(query);                      
    }

    global void execute(Database.BatchableContext BC, List<Account> acclist) {
    
     
     Map<id, Id> DecisionmakerMap= new Map<Id,Id>();
     Map<id, Id> InfluencerMap= new Map<Id,Id>();
     Map<id, Id> ContactUserMap= new Map<Id,Id>();
     Map<id, Id> ContactBlankMap= new Map<Id,Id>();
     Map<id, Id> ContactMap= new Map<Id,Id>();
     Set<Id> Accountids = new Set<Id>();
     
     for (Account a:acclist )
         Accountids.add(a.id);
     
     List<AccountContactRelation > AccountContactRelationlist =[Select id ,contactid, contact.status__c, account.name , contact.name , contact.crm_functional_decision_level__c  from AccountContactRelation where accountid in : Accountids and contact.status__c ='Aktiv' and contact.email!=null and contact.crm_Contact_Type__c ='Sales' order by createddate desc];
     
      List<AccountcontactrelationCustom__c> listtoadd = new List<AccountcontactrelationCustom__c>();
        
     for (AccountContactRelation  c:  AccountContactRelationlist ){
      AccountcontactrelationCustom__c obj= new AccountcontactrelationCustom__c();
      
      List<AccountcontactrelationCustom__c> listtodel= new List<AccountcontactrelationCustom__c>();
      
       if(c.contact.crm_functional_decision_level__c == 'Decision maker' || c.contact.crm_functional_decision_level__c == 'Beslutningstaker'){
            if(!DecisionmakerMap.containskey(c.accountid)){
                DecisionmakerMap.put(c.accountid, c.contactid);
                
                 
               
                  for (Integer i = 0; i < listtoadd.size(); i++) {
                if (listtoadd.get(i).Accountid__c == c.accountid){
                   //listtoadd.remove(i);
                   
                     listtodel.add(listtoadd[i]); 
                    
                    }
               }
                }
               if(listtodel.size() >0){ 
               for(integer i= listtodel.size()-1 ;i>=0;i--) {              if(listtoadd.contains(listtodel[i]))         listtoadd.remove(i);                 
                 } 
                 
                 }
               
                obj.Accountid__c=c.accountid;
                obj.Contactid__c= c.contactid;
                obj.Functional_Decision_level__c ='Descision Maker';
                listtoadd.add(obj);
            }
            
             system.debug('## listtoadd after DM'+  listtoadd );  
            
         
        if(c.contact.crm_functional_decision_level__c == 'Influencer' || c.contact.crm_functional_decision_level__c == 'Påvirker'){
        
       
            if(!InfluencerMap.containskey(c.accountid) &&  !DecisionmakerMap.containskey(c.accountid)) {
                InfluencerMap.put(c.accountid, c.contactid);
                
                 //List<AccountcontactrelationCustom__c> listtodel= new List<AccountcontactrelationCustom__c>();
                
                  for (Integer i = 0; i < listtoadd.size(); i++) {          if (listtoadd.get(i).Accountid__c == c.accountid){        listtodel.add(listtoadd[i]); 
                    
                    }
               }
                }
                if(listtodel.size() >0){            for(integer i= listtodel.size()-1 ;i>=0;i--) {  if(listtoadd.contains(listtodel[i]))   listtoadd.remove(i);
                 
                 } 
                 }
                if(!DecisionmakerMap.containskey(c.accountid)){
                obj.Accountid__c=c.accountid;
                obj.Contactid__c= c.contactid;
                obj.Functional_Decision_level__c ='Influencer';
                listtoadd.add(obj);
                 }
                
                
            
        }   
        
          system.debug('## listtoadd after influencer'+  listtoadd ); 
         
        if(c.contact.crm_functional_decision_level__c == 'User' || c.contact.crm_functional_decision_level__c == 'Bruker'){
            if(!ContactUserMap.containskey(c.accountid) && !InfluencerMap.containskey(c.accountid) && !DecisionmakerMap.containskey(c.accountid) ){
                ContactUserMap.put(c.accountid, c.contactid);
                
                system.debug('###in user part ContactUserMap'+ ContactUserMap);
                             
                for (Integer i = 0; i < listtoadd.size(); i++) {
                System.debug( i + '##c ' + c);
                 system.debug('###templist.get(i).Accountid__c '+ listtoadd.get(i).Accountid__c   + 'c.accountid'  + c.accountid ); 
                if (listtoadd.get(i).Accountid__c == c.accountid){
                    // listtoadd.remove(i);
                     listtodel.add(listtoadd[i]); 
                    
                    }
               }
                }
                if(listtodel.size() >0){  for(integer i= listtodel.size()-1 ;i>=0;i--) {  if(listtoadd.contains(listtodel[i]))     listtoadd.remove(i);
                 
                 } 
               }  
                 
                
                 System.debug( '## listtoadd after removing  ' + listtoadd);
                if(!InfluencerMap.containskey(c.accountid) && !DecisionmakerMap.containskey(c.accountid) ){
                obj.Accountid__c=c.accountid;
                obj.Contactid__c= c.contactid;
                obj.Functional_Decision_level__c ='User';
                listtoadd.add(obj);
            }
        }   
        
        system.debug('## listtoadd after user'+  listtoadd ); 
         
        
          if(c.contact.crm_functional_decision_level__c == '' || c.contact.crm_functional_decision_level__c == null){
            if(!ContactUserMap.containskey(c.accountid) && !InfluencerMap.containskey(c.accountid) && !DecisionmakerMap.containskey(c.accountid) && !ContactBlankMap.containskey(c.accountid)){
                ContactBlankMap.put(c.accountid, c.contactid);
                               
                for (Integer i = 0; i < listtoadd.size(); i++) {
                if (listtoadd.get(i).Accountid__c == c.accountid){
                    //listtoadd.remove(i);
                    listtodel.add(listtoadd[i]); 
                    
                    }
               }
                }
                
                 if(listtodel.size() >0){
                
                for(integer i= listtodel.size()-1 ;i>=0;i--) { if(listtoadd.contains(listtodel[i]))listtoadd.remove(i);
                 
                 } 
                 
                 }
                if(!InfluencerMap.containskey(c.accountid) && !DecisionmakerMap.containskey(c.accountid) && !ContactUserMap.containskey(c.accountid)){
                obj.Accountid__c=c.accountid;
                obj.Contactid__c= c.contactid;
                obj.Functional_Decision_level__c ='';
                listtoadd.add(obj);
            }
        } 
        
         system.debug('## listtoadd after blank'+  listtoadd );   
        
        if(!ContactMap.containskey(c.accountid))
                ContactMap.put(c.accountid, c.contactid);
     
     }//end of for
     
     
     system.debug('## InfluencerMap '+  InfluencerMap );
     system.debug('## DecisionmakerMap ' + DecisionmakerMap);
     system.debug('## ContactUserMap' + ContactUserMap);
     system.debug('## ContactBlankMap' + ContactBlankMap);
     system.debug('## ContactMap'+  ContactMap);
     
     
     set<id> accountid = new set<id>();
     
     for (AccountcontactrelationCustom__c a1:listtoadd )
         accountid.add(a1.accountid__c);
      List<AccountcontactrelationCustom__c>  listtodelete= [Select id from AccountcontactrelationCustom__c  where accountid__c in : accountid];
      
       if(listtodelete.size()>0)
            delete listtodelete ;
     
      if(listtoadd.size()>0)
            insert  listtoadd ;
            
      system.debug('## listtoadd '+  listtoadd );       
            
    Map<Id, Integer> AggresultsMap = new Map<Id, Integer>();         
            
    list<AggregateResult> AggregateResultList=[select Accountid__c,count(id)total  from AccountcontactrelationCustom__c    group by Accountid__c having count(id) >=5]; 
    if(AggregateResultList!= null && AggregateResultList.size() > 0){ 
        for(AggregateResult agg:AggregateResultList){ 
           if(!AggresultsMap.containskey((id)agg.get('Accountid__c')))
               AggresultsMap.put((id)agg.get('Accountid__c'), (Integer)agg.get('total'));
        }  
    }      
   
     for (Account a : acclist){
         
          if(DecisionmakerMap.containskey(a.id)){
            a.Primary_contact__c= DecisionmakerMap.get(a.id);
            a.Set_Primary_Contact__c = true;
           if(AggresultsMap.containskey(a.id)) a.Warrants_Postage__c= true;
             else
                a.Warrants_Postage__c = false;
           
            }
        else if(InfluencerMap.containskey(a.id)){
            a.Primary_contact__c= InfluencerMap.get(a.id);
            a.Set_Primary_Contact__c = true;
           if(AggresultsMap.containskey(a.id))
                a.Warrants_Postage__c= true; else
                a.Warrants_Postage__c = false;
           
            }
       
          
     else   if(ContactUserMap.containskey(a.id)){
            a.Primary_contact__c= ContactUserMap.get(a.id);
            a.Set_Primary_Contact__c = true;
           if(AggresultsMap.containskey(a.id))a.Warrants_Postage__c= true;
             else
                a.Warrants_Postage__c = false;
          
            }
            
        else if(ContactBlankMap.containskey(a.id)){
            a.Primary_contact__c= ContactBlankMap.get(a.id);
            a.Set_Primary_Contact__c = true;
             a.Warrants_Postage__c = true;
          
          
            }
            
     else   if(ContactMap.containskey(a.id)){
            a.Primary_contact__c= ContactMap.get(a.id);a.Set_Primary_Contact__c = true;a.Warrants_Postage__c = true;
          
            }
       
     
     }
       update  acclist;
      
    
    
    }
    
     global void finish(Database.BatchableContext BC) {
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
        mail.setSubject('Set primary contact on  Account');
        mail.setPlainTextBody(str);
        
        // Send the email for the developer reference
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
        
          
      } 


    }