//Author: Supriya Goel
//Contact CR: Batch Apex for manual mass Contact merge

public class crm_ContactMergeBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        String status = 'NotInitiated';
              
        //select the custom metadatyypes values
       
       List<Contact_CR__mdt> customvalues= [Select id, MasterLabel,DeveloperName,  values__c from Contact_CR__mdt where DeveloperName ='crm_ContactMergeBatch' limit 1];
       List<String> valuesList = new List<String>();
       Set <String> valuesSet = new Set<String>();
       Set <String> contacttype= new Set<String>{'Sales'};
       
       
       if (customvalues[0].values__c!= null)
           valuesList = customvalues[0].values__c.split(',');
       
        valuesSet.addAll(valuesList);
        String query = 'SELECT Id, crm_Parent_ContactId__c, crm_Child_ContactId__c, crm_Merge_Status__c, crm_create_ACR_status__c, Name, crm_Exception_Message__c FROM crm_ContactMerge__c WHERE crm_create_ACR_status__c = :status ' ;
        if(valuesSet.size()>0 )
           query += ' and id =  :valuesSet '; // in :valuesSet ';
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, crm_ContactMerge__c[] records) {
    
          Set<Id> childcontactIds = new set<Id>();
          Set<Id> parentcontactIds = new set<Id>();
          Map<Id,Set<Id>> accountmergeMap = new Map<Id,Set<Id>>();
          Map<Id,Id> childmasterMap= new Map<Id,Id>();
          Map<Id,Id> childrecordMap= new Map<Id,Id>();
                
          for(crm_ContactMerge__c record: records) {
              parentcontactIds.add(record.crm_Parent_ContactId__c); 
              childcontactIds.add(record.crm_Child_ContactId__c); 
              childmasterMap.put(record.crm_Child_ContactId__c,record.crm_Parent_ContactId__c);
              childrecordMap.put(record.crm_Child_ContactId__c,record.id);
              
              if (accountmergeMap.containskey(record.crm_Parent_ContactId__c)){
    
                Set<Id> tempSet = accountmergeMap.get(record.crm_Parent_ContactId__c);
                tempSet.add(record.crm_Child_ContactId__c);
                accountmergeMap.put(record.crm_Parent_ContactId__c,tempSet );
                
            
            } else {
               Set<Id>  tempset= new Set<Id>();
               tempset.add(record.crm_Child_ContactId__c);
               accountmergeMap.put(record.crm_Parent_ContactId__c,tempSet);
            }
          }
          
       
        List<Opportunity> updatedprimaryoppList = new List<Opportunity>();
        List<Opportunity> primaryoppList = new List<Opportunity>();
        List<OpportunityContactRole> updatedcontactroleList= new List<OpportunityContactRole>();
        List<crm_agreement__c> updatedagrList= new List<crm_agreement__c>();
        List<Task> updatedtaskList= new List<Task>();
        List<event> updatedEventList= new List<Event>();
        List<crm_Tender_Contact_Role__c> updatedtenderroleList= new List<crm_Tender_Contact_Role__c>();
        
        List<et4ae5__IndividualEmailResult__c> updatedemailresultlist= new List<et4ae5__IndividualEmailResult__c>();
        List<et4ae5__SendDefinition__c> updatedemailsendresultlist= new List<et4ae5__SendDefinition__c>();
        
        List<Attachment> updatedattachmentlist= new List<Attachment>();
        List<Note> updatednotelist= new List<Note>();
        
        //opportunities
        
        List<Opportunity> opportunityList = [Select id ,crm_Primary_Opportunity_Contact__c from Opportunity  where crm_Primary_Opportunity_Contact__c in :childcontactIds ];
        for (Opportunity opp:opportunityList ){
            if (childmasterMap.containskey(opp.crm_Primary_Opportunity_Contact__c)){
                opp.crm_Primary_Opportunity_Contact__c = childmasterMap.get(opp.crm_Primary_Opportunity_Contact__c);
                updatedprimaryoppList.add(opp);
        
        
            }
                
        }
        
        
        //contact roles 

List<OpportunityContactRole> Opp_OCR = [select id, contactid, Opportunityid, role, isprimary from OpportunityContactRole where contactid in :childcontactIds ];
for (OpportunityContactRole contactrole: Opp_OCR ){
    if (childmasterMap.containskey(contactrole.contactid)){
        contactrole.contactid= childmasterMap.get(contactrole.contactid);
        updatedcontactroleList.add(contactrole);
        }
}       

//agreements 

List<crm_agreement__c> agreementList = [Select id, crm_Agreement_Primary_Contact__c from crm_agreement__c where crm_Agreement_Primary_Contact__c in :childcontactIds ];
for (crm_agreement__c agr : agreementList ){
    if(childmasterMap.containskey(agr.crm_Agreement_Primary_Contact__c )){
        agr.crm_Agreement_Primary_Contact__c = childmasterMap.get(agr.crm_Agreement_Primary_Contact__c );
        updatedagrList.add(agr);
    }
}
    

//tasks
List<Task> taskList =[Select id, whoid from task where whoid in :childcontactIds  ];
for (Task t : taskList){
    if(childmasterMap.containskey(t.whoid)){
    t.whoid= childmasterMap.get(t.whoid);
    updatedtaskList.add(t);
    }
}   

//events 
List<Event> eventList =[Select id, whoid from Event where whoid in :childcontactIds ];
for (Event e  : eventList){
    if(childmasterMap.containskey(e.whoid)){
        e.whoid= childmasterMap.get(e.whoid);
        updatedEventList.add(e);
    }
}
    

//copy campaign members to sales contacts
List<Campaignmember> campaignmemberList= [SELECT id,campaignid, contactid FROM CampaignMember  WHERE contactid in :childcontactIds ];
Map<id, List<Id>> campaignmembersMap = new Map<Id, List<Id>>();

for (CampaignMember c: campaignmemberList){
     if (campaignmembersMap.containskey(c.campaignid)){
         list<Id> contactIds = new List<Id>();
         contactIds = campaignmembersMap.get(c.campaignid);
         contactIds.add(c.contactid);
         campaignmembersMap.put(c.campaignid, contactIds);
        }
        else{
         list<Id> contactIds = new List<Id>();
         contactIds.add(c.contactid);
         campaignmembersMap.put(c.campaignid, contactIds);
         } 
         
       }  
         
      List<Campaignmember> campaignmemberListNew = new List<Campaignmember>();
  System.debug('##campaignmembersMap' + campaignmembersMap);
         
  for (Id campaignid: campaignmembersMap.keyset()){
    
    List<Id> contactids= campaignmembersMap.get(campaignid);
    
     System.debug('##campaignmembersMap' + campaignid   +   contactids);
    for (Id contactid: contactids){
        Campaignmember cm = new Campaignmember();
        cm.campaignid=campaignid;
        cm.contactid= childmasterMap.get(contactid);
        campaignmemberListNew.add(cm);
    }
    
 
}

   
 if(campaignmemberList.size()>0)
    Database.delete(campaignmemberList, false);
System.debug('##campaignmemberListNew ' + campaignmemberListNew );


if(campaignmemberListNew .size()>0)
    Database.insert(campaignmemberListNew, false );
    
    
  

//tender contact role

List<crm_Tender_Contact_Role__c> tenderContactList= [Select id,crm_Contact__c  from crm_Tender_Contact_Role__c where  crm_Contact__c in :childcontactIds ];
for (crm_Tender_Contact_Role__c contactrole: tenderContactList){
    if(childmasterMap.containskey(contactrole.crm_Contact__c)){
        contactrole.crm_Contact__c  =  childmasterMap.get(contactrole.crm_Contact__c);
        updatedtenderroleList.add(contactrole);
    }
}


//Individual Email Results

List<et4ae5__IndividualEmailResult__c> emailresults= [Select id, et4ae5__Contact__c from  et4ae5__IndividualEmailResult__c where  et4ae5__Contact__c  in :childcontactIds ];
for (et4ae5__IndividualEmailResult__c email: emailresults){
    if(childmasterMap.containskey(email.et4ae5__Contact__c)){
        email.et4ae5__Contact__c =  childmasterMap.get(email.et4ae5__Contact__c );
        updatedemailresultlist.add(email);
    }   

}
//email send

List<et4ae5__SendDefinition__c> emailsendresults= [Select id, et4ae5__Contact__c from  et4ae5__SendDefinition__c where  et4ae5__Contact__c  in :childcontactIds ];
for (et4ae5__SendDefinition__c email: emailsendresults){
    if(childmasterMap.containskey(email.et4ae5__Contact__c )){
        email.et4ae5__Contact__c =  childmasterMap.get(email.et4ae5__Contact__c );
        updatedemailsendresultlist.add(email);

    }
} 


//select attachment
/*List<Attachment> attachmentList= [Select id, ParentId, Body, IsPrivate, Name, OwnerId,  Description, ContentType from Attachment where parentid in :childcontactIds ];
for (Attachment a : attachmentList){
    Attachment a1 = a.clone(false, true);
    a.parentid =  childmasterMap.get(a.parentid);
    updatedattachmentlist.add(a);
}

 insert updatedattachmentlist;
 delete attachmentList;

//select notes  

List<Note> noteList= [Select id, body, IsDeleted, IsPrivate, OwnerId, ParentId, Title from Note where parentid in :childcontactIds];
for(Note n: noteList){
    Note n1= n.clone(false, true);
    n1.parentid= childmasterMap.get(n1.parentid);
    updatednotelist.add(n1);
}

insert updatednotelist;
delete updatednotelist;

*/

Map<Id,Set<Id>> parentaccountContactRelMap=  new Map<Id,Set<Id>>();
          
         List<AccountContactRelation> parentaccountContactRellist =[Select id, Contactid , AccountId from AccountContactRelation where contactid in :parentcontactIds];
         for (AccountContactRelation acr : parentaccountContactRellist ){
              Set<Id> tempid = new Set<Id>();
              if (parentaccountContactRelMap.containskey(acr.Contactid)){
                tempid=parentaccountContactRelMap.get(acr.Contactid);
                tempid.add(acr.accountid);  
                parentaccountContactRelMap.put(acr.Contactid,tempid);
                  
              }
              else{
                tempid.add(acr.accountid);  
                parentaccountContactRelMap.put(acr.Contactid,tempid);  
                  
              }
                
          }


 List<AccountContactRelation> accountContactRellist =[Select id, Contactid , AccountId from AccountContactRelation where contactid in :childcontactIds];
        Map<Id,Set<Id>>  accountContactRelMap=  new Map<Id,Set<Id>> ();
        for (AccountContactRelation acr: accountContactRellist){
            Set<Id> tempid = new Set<Id>();
            if(accountContactRelMap.containskey(acr.Contactid)){
                tempid=accountContactRelMap.get(acr.Contactid);
                tempid.add(acr.accountid);
                accountContactRelMap.put(acr.Contactid, tempid);        
                }
                else {
                    
                tempid.add(acr.accountid);
                accountContactRelMap.put(acr.Contactid, tempid);    
                    
                }
                
        }       
          
          List<AccountContactRelation> acrList = new List<AccountContactRelation>();
            Map<Id, Set<Id>> mastercontactAccountMap = new Map<Id, Set<Id>>();
          for (String masterid : accountmergeMap.keyset()){
              Set<id> childSet = accountmergeMap.get(masterid);  //all child conyacts
               Set<Id> ACRparentset = new Set<Id>();               
               ACRparentset = parentaccountContactRelMap.get(masterid) ; // accounts related 
               system.debug('##ACRparentset ' + ACRparentset ) ;
              
              for (String childid: childSet ){
                  Set<Id> ACRchildset = accountContactRelMap.get(childid) ; // accounts related 
                   Set<Id> checkAcntsid= new Set<Id>();
                   system.debug('##ACRchildset ' + ACRchildset ) ;
                  if(ACRchildset!=null ){
                  for (String accountid : ACRchildset) {
                    checkAcntsid.add(accountid);
                      if((ACRparentset==null ||  !ACRparentset.contains(accountid) ) && !checkAcntsid.contains(accountid)){
                             
                             AccountContactRelation acr = new AccountContactRelation();
                             acr.contactid = masterid;
                             acr.accountid = accountid;
                            
                             acrList.add(acr);  
                             system.debug('##acrList' + acrList) ;
                                                   
                          
                      }
                      
                      
                  }
                }//end of null  
                  
             
              
           
              } //end of if
                  
          }
       
          
          system.debug('###acrList' + acrList);
          if(acrList.size() > 0)
             Database.insert(acrList, false);
             
         
    
    
    if(updatedprimaryoppList.size()>0)
        Database.update(updatedprimaryoppList, false);
        
    if(updatedcontactroleList.size()>0)
        Database.update(updatedcontactroleList, false);
    if(updatedagrList.size()>0)
        Database.update(updatedagrList, false);
    if(updatedtaskList.size()>0)
        Database.update(updatedtaskList, false);
    if(updatedEventList.size()>0)
        Database.update(updatedEventList, false);
    if(updatedtenderroleList.size()>0)
        Database.update(updatedtenderroleList, false);
    if(updatedemailresultlist.size()>0)
        Database.update(updatedemailresultlist, false);
    if(updatedemailsendresultlist.size()>0)
        Database.update(updatedemailsendresultlist, false);
        
        
    
    
   List<Contact> childContactList = [Select id  from contact where id in :childcontactIds ];  
   List< crm_ContactMerge__c> mergeList= new  List<crm_ContactMerge__c>();
   for (Contact c : childContactList ){
       crm_ContactMerge__c record = new crm_ContactMerge__c ();
       record.id= childrecordMap.get(c.id);
       record.crm_create_ACR_status__c= 'Success';
       mergeList.add(record);
   }
      
    update mergeList;
    delete childContactList; 
      
    }
    
    public void finish(Database.BatchableContext context) {
            
    }
}