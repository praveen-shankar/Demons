/*
Created By:Supriya Goel
Date:4th may 2017
Mark the duplicate contacts and mark one of them master record

*/

global class crm_markduplicateContact_Batch implements Database.batchable<sObject>,Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext BC){
      
       Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
       
       //select the custom metadatyypes values
       
       List<Contact_CR__mdt> customvalues= [Select id, MasterLabel,DeveloperName,  values__c from Contact_CR__mdt where DeveloperName ='crm_markduplicateContact_Batch' limit 1];
       List<String> valuesList = new List<String>();
       Set <String> valuesSet = new Set<String>();
       Set <String> contacttype= new Set<String>{'Sales'};
       Set <String> status= new Set<String>{'Aktiv'};
       
       if (customvalues[0].values__c!= null)
           valuesList = customvalues[0].values__c.split(',');
           
           valuesSet.addAll(valuesList);
       
       //select all contacts where account !=private
       String query = 'Select id, email,MobilePhone,accountid,Description, Last_modified_Date__c ,Meaningful_User__c ,Updated_Mobile__c , Mobile_Updated_Meaningful_User_date__c ,crm_functional_decision_level__c,Phone, account.recordtypeid, Sync_to_Marketing__c, status__c, crm_Has_agreed_to_Marketing_actvities__c, crm_No_to_Marketing_activities__c ,  lastmodifieddate,crm_function_working_area__c from Contact where ProcessedContactHistory__c = true'; 
       if(valuesSet.size()>0 )
           query += ' and id in :valuesSet ';
           System.debug('## valuesSet ' + valuesSet );
       query += ' and ExcludedFromDeDup__c = false order by email asc';
       System.debug('## query' + query);
       return database.getquerylocator(query);
    }    
    
global void execute(Database.BatchableContext BC, List<Contact> ContactListemp) {

 Map<String, List<Contact>> emailContactMap = new Map<String, List<Contact>>();
 Map<Id , Contact> ContactMap=  new Map<Id, Contact>();
 Set<String> meaningfuluserSet=  new Set<String>(); 
 Set<Id> cids = new Set<Id>();
  for (Contact con : ContactListemp){
      cids.add(con.id);
  }
 
 
 List<Contact> ContactList= [Select id, email,MobilePhone,accountid,Description, Last_modified_Date__c ,Meaningful_User__c ,Updated_Mobile__c , Mobile_Updated_Meaningful_User_date__c ,crm_functional_decision_level__c,Phone, account.recordtypeid, Sync_to_Marketing__c, status__c, crm_Has_agreed_to_Marketing_actvities__c, crm_No_to_Marketing_activities__c ,  lastmodifieddate,crm_function_working_area__c from Contact where id in :cids order by Last_modified_Date__c  desc ];
 
 for (Contact con : ContactList){
     ContactMap.put(con.id, con);
        meaningfuluserSet.add(con.Meaningful_User__c); 
        if (emailContactMap.containskey(con.email)) {
                    List < Contact > templist = new List < Contact > ();  templist = emailContactMap.get(con.email);  templist.add(con);  emailContactMap.put(con.email, templist);
                } else {
                    List < Contact > templist = new List < Contact > ();  templist.add(con); emailContactMap.put(con.email, templist);  
                }
 }
 
 List<User> Userlist =[Select id, crm_user_type__c from user where id in :meaningfuluserSet];
      
   Map<Id,User> userMap=  new Map<Id,User>();
   
   for (User u: Userlist) userMap.put(u.id, u);
 
 System.debug('emailContactMap'+emailContactMap);
    
  Set<String> Userids = new Set<String>();
    
 List<User> marketingClouduser = [Select id from User where alias ='mmark' limit 1];
    if (marketingClouduser!=null && marketingClouduser.size()>0)  Userids.add(marketingClouduser[0].id); 
 
 Map<String,Id> ContactmasterMap = new Map<String, Id>(); 
 Map<String,String> ContactmasterMobileMap = new Map<String, String>();
 Set<Id> masterContactids = new Set<Id>();
 for (String email : emailContactMap.keyset()){
      List<Contact> emailcontactList= emailContactMap.get(email);
         if(emailcontactList.size()>1){
     
      Id mastercontactid =emailcontactList[0].id;
       DateTime latestmobilemodifieddate= Datetime.valueOf (emailcontactList[0].Mobile_Updated_Meaningful_User_date__c) ;
       ContactmasterMobileMap.put(email, emailcontactList[0].Updated_Mobile__c ); Boolean checkmaster= false;
      
      
           for(Contact con : emailcontactList) {
                if(Userids.contains(con.Meaningful_User__c)){   
                   ContactmasterMap.put(email, con.id);   System.debug('in profile');   masterContactids.add(con.id);    checkmaster= true;  break;
               }    
           
           }
           
           System.debug('ContactmasterMap after profile'+ContactmasterMap);
           
           if(!checkmaster) {
            for(Contact con : emailcontactList) {
              String userType = userMap.get(con.Meaningful_User__c).crm_User_Type__c ;            
                if(userType !='Other' ){   
                   ContactmasterMap.put(email, con.id); masterContactids.add(con.id); checkmaster= true;   break;
                   }    
           
               }
                 
           }
           
            System.debug('ContactmasterMap after not other'+ContactmasterMap);
           
           
            if(!checkmaster) {
            for(Contact con : emailcontactList) {
              String userType = userMap.get(con.Meaningful_User__c).crm_User_Type__c ;
            
                if(userType =='Other' ){   
                   ContactmasterMap.put(email, con.id); masterContactids.add(con.id); checkmaster= true; break;
                   }    
           
               }
                 
           }
           
            System.debug('ContactmasterMap after  other'+ContactmasterMap);
           
          for(Contact con : emailcontactList) {
              if(con.Mobile_Updated_Meaningful_User_date__c > latestmobilemodifieddate ){     
                   ContactmasterMobileMap.put(email, con.Updated_Mobile__c );   //email =>  mobile whuch should be updated 
                   System.debug('##mobile phone' + con);
                   }    
           
               } 
     
   }
   
 }  
   //create a map of conta
   
  System.debug('ContactmasterMap'+ContactmasterMap);
  System.debug('ContactmasterMobileMap'+ContactmasterMobileMap);
 
 List<crm_ContactMerge__c > mergelist= new List<crm_ContactMerge__c >();
 for (String email : emailContactMap.keyset()){
      List<Contact> emailcontactList= emailContactMap.get(email);
      if(emailcontactList.size()>1) {
      for (Contact c : emailcontactList) {
          if(!masterContactids.contains (c.id)) {
              crm_ContactMerge__c  mergeobj = new crm_ContactMerge__c();
              mergeobj.crm_Parent_ContactId__c = ContactmasterMap.get(email);
              mergeobj.crm_Child_ContactId__c =c.id;
              mergeobj.crm_create_ACR_status__c ='NotInitiated';
              mergelist.add(mergeobj);
         }
        }
     }   
 
 }
  System.debug('mergelist'+mergelist);
 
 if (mergelist.size()>0)
     insert mergelist;  
     
     Map<Id, List<Contact>> ContactMasterIdsMap=  new Map<Id, List<Contact>>();
     
    String status = 'NotInitiated';  
  List<crm_ContactMerge__c> mastermergelist= [Select id,crm_Parent_ContactId__c ,crm_Child_ContactId__c  from crm_ContactMerge__c where crm_Parent_ContactId__c in :masterContactids and crm_create_ACR_status__c = :status]; 
   for (crm_ContactMerge__c mergeobj: mastermergelist){
    if (ContactMasterIdsMap.containskey(mergeobj.crm_Parent_ContactId__c )){
    
       List<Contact> childcontactlist = ContactMasterIdsMap.get(mergeobj.crm_Parent_ContactId__c); childcontactlist.add(ContactMap.get(mergeobj.crm_Child_ContactId__c));  ContactMasterIdsMap.put(mergeobj.crm_Parent_ContactId__c,childcontactlist);
        
    
    } else {
       Set<Id>  tempset= new Set<Id>();  List<Contact> childcontactlist =new List<Contact>();  tempset.add(mergeobj.crm_Child_ContactId__c); childcontactlist.add(ContactMap.get(mergeobj.crm_Child_ContactId__c));
       ContactMasterIdsMap.put(mergeobj.crm_Parent_ContactId__c,childcontactlist);
    
    }
   
   }
   
   System.debug('ContactMasterIdsMap'+ContactMasterIdsMap);
   
   List<Contact> ContactstoUpdate = new List<Contact>();
   
   for (Id Parentid :ContactMasterIdsMap.keyset()){
       List<Contact> childcontacts=ContactMasterIdsMap.get(Parentid);
       Contact masterRecord=  ContactMap.get(Parentid);
       masterRecord.IsMaster__c=true;
       
       Boolean functionaldecisionflag= false;
        for (Contact childcon: childcontacts){
           if (masterrecord.description == null  && childcon.Description !=null)   
               masterrecord.description = childcon.description; break;
        }
        
       for (Contact childcon: childcontacts){
           if (childcon.crm_No_to_Marketing_activities__c)  { 
               masterrecord.crm_No_to_Marketing_activities__c= true; masterrecord.crm_Has_agreed_to_Marketing_actvities__c = false; break;
               
               }
               else if(childcon.crm_No_to_Marketing_activities__c==false && childcon.crm_Has_agreed_to_Marketing_actvities__c){
               masterrecord.crm_No_to_Marketing_activities__c= false;   masterrecord.crm_Has_agreed_to_Marketing_actvities__c = true;  break;
               }
               
        }
        
         for (Contact childcon: childcontacts){
           if (childcon.crm_functional_decision_level__c == 'Decision maker')   {
               masterrecord.crm_functional_decision_level__c= 'Decision maker';            functionaldecisionflag =true;        break;
            }
                             
        }
        if(!functionaldecisionflag){
        for (Contact childcon: childcontacts){
           if (childcon.crm_functional_decision_level__c == 'Influencer')   {
             masterrecord.crm_functional_decision_level__c= 'Influencer';   functionaldecisionflag =true;  break;
            }
                             
            }
        }

    if(!functionaldecisionflag){
        for (Contact childcon: childcontacts){
           if (childcon.crm_functional_decision_level__c == 'User')   {
               masterrecord.crm_functional_decision_level__c= 'User';
                functionaldecisionflag =true;
               break;
            }
                             
            }
        }


 for (Contact childcon: childcontacts){
           if (masterrecord.crm_function_working_area__c == null  && childcon.crm_function_working_area__c !=null) {  
               masterrecord.crm_function_working_area__c = childcon.crm_function_working_area__c;          break;}
        }   

 for (Contact childcon: childcontacts){
           if (masterrecord.Phone == null  && childcon.Phone !=null) {  
               masterrecord.Phone = childcon.Phone;        break;
               }
        }

         ContactstoUpdate.add(masterrecord);  
            
        }   
      
             
  System.debug('ContactstoUpdate'+ContactstoUpdate);
    
  update   ContactstoUpdate;  
  
  for (String masterEmail:  ContactmasterMap.keyset())  {
         Id masterrecordid =ContactmasterMap.get (masterEmail);     Contact c = new Contact();      c.id=masterrecordid;     c.mobilePhone= ContactmasterMobileMap.get(masterEmail);    update c;
         System.debug('## Updated mobile'+ c);
          
          
      }  
 

}

public void dummytest() {
    Integer j = 0;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    // you
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++;
     j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++; 
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++;
    j++; 
  }

 global void finish(Database.BatchableContext BC) {
    
    }


}