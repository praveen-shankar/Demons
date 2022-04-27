/*
Created By:Supriya Goel
Date:14th may 2017
Mark the user and last modified date

*/

global class crm_markUseronContact_Batch implements Database.batchable<sObject>,Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext BC){
      
    Id salesRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
       //select the custom metadatyypes values
       
       List<Contact_CR__mdt> customvalues= [Select id, MasterLabel,DeveloperName,  values__c from Contact_CR__mdt where DeveloperName ='crm_markUseronContact_Batch' limit 1];
       List<String> valuesList = new List<String>();
       Set <String> valuesSet = new Set<String>();
       Set <String> contacttype= new Set<String>{'Sales'};
       Set <String> status= new Set<String>{'Aktiv'};
       
       if (customvalues[0].values__c!= null) {
           valuesList = customvalues[0].values__c.split(',');
           
           valuesSet.addAll(valuesList);
           }
       
       //select all contacts where account !=private
       String query = 'Select id, email from Contact where recordtypeid = :salesRecordTypeId  and email!=null and ProcessedContactHistory__c=false '; 
      
        if(valuesSet.size()>0 )
           query += ' and id =  :valuesSet '; // in :valuesSet ';
           query += ' and ExcludedFromDeDup__c = false' ;
       System.debug(query + ' ' + valuesSet);    
       return database.getquerylocator(query);
    }    
    
global void execute(Database.BatchableContext BC, List<Contact> ContactList) {

 System.debug(ContactList);  
Set<Id> contactids = new Set<Id>();
Map<Id, Contact> ContactMap= new Map<Id, Contact>();
for (Contact con : ContactList){
        contactids.add(con.id);  //sales contact id
        ContactMap.put(con.id, con);
        }
        
         
  Set <String> fields= new Set<String>{'crm_Has_agreed_to_Marketing_actvities__c','crm_No_to_Marketing_activities__c','MobilePhone','Email','Phone','crm_function_working_area__c', 'crm_functional_decision_level__c','firstname', 'lastname','Description'};
  
  Map<id,List<Contacthistory>> SalesContacthistoryMap = new Map<id, List<Contacthistory>>();
  Map<id,Contacthistory> mobileContacthistoryMap = new Map<id, Contacthistory>();
        
  List<Contacthistory>  salescontactHistoryList=[SELECT  OldValue, NewValue,ContactId , Field, CreatedById, CreatedDate FROM ContactHistory where ContactId in : contactids and field in :fields order by createddate desc  ];  //and Createddate = LAST_N_DAYS:90 
  for (contactHistory hist: salescontactHistoryList ){
    
      if (!mobileContacthistoryMap.containskey(hist.ContactId) && hist.field =='MobilePhone') {
            mobileContacthistoryMap.put(hist.ContactId, hist); 
            }
             
            if(SalesContacthistoryMap.containskey(hist.contactId)){    List < Contacthistory > templist = new List < Contacthistory > ();  templist = SalesContacthistoryMap.get(hist.ContactId);    templist.add(hist);    SalesContacthistoryMap.put(hist.ContactId, templist);
            } else {
                List < Contacthistory > templist = new List < Contacthistory > ();  templist.add(hist);  SalesContacthistoryMap.put(hist.ContactId, templist);  
                
            }  
    
  
  }  
  
  system.debug('@@SalesContacthistoryMap after sales ' + SalesContacthistoryMap);
  system.debug('@@mobileContacthistoryMap after sales' + mobileContacthistoryMap);
  
  Set<Id> checkServiceContactsids = new Set<Id>();
  
  for (Contact con : ContactList){
      if (!SalesContacthistoryMap.containskey(con.id))
            checkServiceContactsids.add(con.id);   
  
  }
        
   List<Contact> CSContacts= [Select id , Master_Reference_Id__c from contact where Master_Reference_Id__c!='' and Master_Reference_Id__c  in :checkServiceContactsids];
   Map<Id,Id> salesCSContactsMap = new Map<Id, Id>(); 
    for (Contact con : CSContacts){
         salesCSContactsMap.put(con.id, con.Master_Reference_Id__c);  //cs , sales 
    }
 
  
  List<Contacthistory>  contactHistoryList=[SELECT  OldValue, NewValue,ContactId , Field, CreatedById, CreatedDate FROM ContactHistory where ContactId in : salesCSContactsMap.keyset() and field in :fields  order by createddate desc ];//and Createddate = LAST_N_DAYS:90
  for (contactHistory hist: contactHistoryList ){
      Id salesid = salesCSContactsMap.get(hist.ContactId);
      
      if(!mobileContacthistoryMap.containskey(salesid) && hist.field =='MobilePhone'){ mobileContacthistoryMap.put(salesid,hist);   }
     if (SalesContacthistoryMap.containskey(salesid)) { List < Contacthistory > templist = new List < Contacthistory > (); templist = SalesContacthistoryMap.get(salesid); templist.add(hist);  SalesContacthistoryMap.put(salesid, templist);
                } else {
                    List < Contacthistory > templist = new List < Contacthistory > ();   templist.add(hist);  SalesContacthistoryMap.put(salesid, templist);  
                    
                }  
      
  }
  
  system.debug('@@SalesContacthistoryMap' + SalesContacthistoryMap);
  system.debug('@@mobileContacthistoryMap' + mobileContacthistoryMap);
  
   Set<String> Userids = new Set<String>();
    
    List<User> marketingClouduser = [Select id from User where alias ='mmark' limit 1];
    if (marketingClouduser!=null && marketingClouduser.size()>0)
       Userids.add(marketingClouduser[0].id); 
    
   List<Contact> UpdatedContactList = new List<Contact>();
   List<User> Userlist =[Select id, crm_user_type__c from user];
      
   Map<Id,User> userMap=  new Map<Id,User>();
   
   for (User u: Userlist)
       userMap.put(u.id, u);
       
  
  for (Contact con : ContactList){
  //for (String ContactId : ContacthistoryMap.keyset() ){
   List <Contacthistory > templist = SalesContacthistoryMap.get(con.Id);
   system.debug('##templist' + templist);
   Contact contactobj= ContactMap.get(con.id);
   if (templist !=null && templist.size()>0) {
           
          
              for (Contacthistory conhist:templist){
                                     
                  if(Userids.contains(conhist.CreatedById)){  
                      contactobj.Last_modified_Date__c=conhist.CreatedDate ;  contactobj.Meaningful_User__c = conhist.createdbyId; contactobj.ProcessedContactHistory__c=true;UpdatedContactList.add(contactobj); break; 
                      }
              }

       }
  }
  
  System.debug('###UpdatedContactList marketing user ' +UpdatedContactList  );
   update  UpdatedContactList;

List<Contact> ContactlistNotother= [Select id from Contact where id in :contactids and ProcessedContactHistory__c=false ];
System.debug('###ContactlistNotother  ' +ContactlistNotother);
for (Contact con : ContactlistNotother){
 List <Contacthistory> templist = SalesContacthistoryMap.get(con.id);
   Contact contactobj= ContactMap.get(con.Id);
   if (templist !=null && templist.size()>0) {
        for (Contacthistory conhist:templist){
                   String userType = userMap.get(conhist.CreatedById).crm_User_Type__c ;
                   System.debug('##userType ' + userType );
                    if(userType !='Other'  ){
                          contactobj.Last_modified_Date__c=conhist.CreatedDate ; contactobj.Meaningful_User__c = conhist.createdbyId;contactobj.ProcessedContactHistory__c= true; UpdatedContactList.add(contactobj);break;
                      } 
                }
        
        }   
   }
   System.debug('###UpdatedContactList no other user ' +UpdatedContactList  );
update  UpdatedContactList;  

List<Contact> Contactlistother= [Select id from Contact where id in :contactids and ProcessedContactHistory__c=false ];
for (Contact con : Contactlistother){
 List <Contacthistory> templist = SalesContacthistoryMap.get(con.id);
   Contact contactobj= ContactMap.get(con.Id);
   if (templist !=null && templist.size()>0) {
        for (Contacthistory conhist:templist){ String userType = userMap.get(conhist.CreatedById).crm_User_Type__c ;
                       
                      if(userType =='Other' && !Userids.contains(conhist.CreatedById) ){
                          contactobj.Last_modified_Date__c=conhist.CreatedDate; contactobj.Meaningful_User__c = conhist.createdbyId;contactobj.ProcessedContactHistory__c= true;UpdatedContactList.add(contactobj);break;
                        
                      }
                   
              }
        }   
  }
   System.debug('###UpdatedContactList  other user ' +UpdatedContactList  );
  update  UpdatedContactList;
  
  System.debug('UpdatedContactList' + UpdatedContactList);
  update UpdatedContactList;
  
  List<Contact> Contactlistnohistory= [Select id, CreatedDate, createdbyId, Last_modified_Date__c, Meaningful_User__c, ProcessedContactHistory__c    from Contact where id in :contactids and ProcessedContactHistory__c=false ];
  for (Contact con : Contactlistnohistory){
     con.Last_modified_Date__c =con.CreatedDate ;
      con.Meaningful_User__c = con.createdbyId;
      con.ProcessedContactHistory__c= true;
      UpdatedContactList.add(con); 
  }
  
  System.debug('###UpdatedContactList no history ' +UpdatedContactList  );
  update  UpdatedContactList;
  
  
  
  
  for (Contact con: contactList){
       if (mobileContacthistoryMap.containskey(con.id)){
           con.Updated_Mobile__c = String.valueof(mobileContacthistoryMap.get(con.id).NewValue);  con.Mobile_Updated_Meaningful_User_date__c = mobileContacthistoryMap.get(con.id).CreatedDate;
       }   
      
  }
  
  update contactList;
  

}

global void finish(Database.BatchableContext BC) {
    
    }
 
}