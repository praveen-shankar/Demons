/*
Created By:Supriya Goel
Date: 14th march  2018
Set record type for contact Inactive , Sales , Customer service
*/

global class crm_CopyRelatedrecords_Batch implements Database.batchable<sObject>
{    
 
global Database.QueryLocator start(Database.BatchableContext BC){

 Id csRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer Service').getRecordTypeId();
  //select the custom metadatyypes values
       
       List<Contact_CR__mdt> customvalues= [Select id, MasterLabel,DeveloperName,  values__c from Contact_CR__mdt where DeveloperName ='crm_CopyRelatedrecords_Batch' limit 1];
       List<String> valuesList = new List<String>();
       Set <String> valuesSet = new Set<String>();
       
        if ((customvalues.size() > 0) && (customvalues[0].values__c!= null))
           valuesList = customvalues[0].values__c.split(',');
           
           valuesSet.addAll(valuesList);
       
 String query = 'Select id, Master_Reference_Id__c, Recordtypeid from Contact where Master_Reference_Id__c != null  and recordtypeid=:csRecordTypeId '; 
  if(valuesSet.size()>0 )
           query += ' and id in :valuesSet ';
           System.debug('## valuesSet ' + valuesSet );
       query += ' order by lastmodifieddate desc';
       System.debug('## query' + query);
       return database.getquerylocator(query);

}

global void execute(Database.BatchableContext BC, List<Contact> ContactList) {

Map<Id, Id> CsSalesIdsMap=  new Map<Id, Id>();
for (Contact con :ContactList) {
    CsSalesIdsMap.put(con.id, con.Master_Reference_Id__c );

}



//Get all the related objects and map from CS contacts to  Sales contact 

List<sobject> sObjectList=  new  List<sObject>();
List<Opportunity> updatedprimaryoppList = new List<Opportunity>();
List<Opportunity> primaryoppList = new List<Opportunity>();
List<OpportunityContactRole> updatedcontactroleList= new List<OpportunityContactRole>();
List<crm_agreement__c> updatedagrList= new List<crm_agreement__c>();
List<Task> updatedtaskList= new List<Task>();
List<event> updatedEventList= new List<Event>();
List<crm_Tender_Contact_Role__c> updatedtenderroleList= new List<crm_Tender_Contact_Role__c>();

List<et4ae5__IndividualEmailResult__c> updatedemailresultlist= new List<et4ae5__IndividualEmailResult__c>();
List<et4ae5__SendDefinition__c> updatedemailsendresultlist= new List<et4ae5__SendDefinition__c>();





//opportunities

List<Opportunity> opportunityList = [Select id ,crm_Primary_Opportunity_Contact__c from Opportunity  where crm_Primary_Opportunity_Contact__c in :CsSalesIdsMap.keyset()];
for (Opportunity opp:opportunityList ){
    opp.crm_Primary_Opportunity_Contact__c = CsSalesIdsMap.get(opp.crm_Primary_Opportunity_Contact__c);
    updatedprimaryoppList.add(opp);
}

//contact roles 

List<OpportunityContactRole> Opp_OCR = [select id, contactid, Opportunityid, role, isprimary from OpportunityContactRole where contactid in :CsSalesIdsMap.keyset()];
for (OpportunityContactRole contactrole: Opp_OCR ){
    contactrole.contactid= CsSalesIdsMap.get(contactrole.contactid);
    updatedcontactroleList.add(contactrole);
}

//agreements 

List<crm_agreement__c> agreementList = [Select id, crm_Agreement_Primary_Contact__c from crm_agreement__c where crm_Agreement_Primary_Contact__c in :CsSalesIdsMap.keyset()];
for (crm_agreement__c agr : agreementList ){
    agr.crm_Agreement_Primary_Contact__c = CsSalesIdsMap.get(agr.crm_Agreement_Primary_Contact__c );
    updatedagrList.add(agr);
}

//tasks
List<Task> taskList =[Select id, whoid from task where whoid in :CsSalesIdsMap.keyset() and what.type!='Case'];
for (Task t : taskList){
    t.whoid= CsSalesIdsMap.get(t.whoid);
    updatedtaskList.add(t);
}

//events 
List<Event> eventList =[Select id, whoid from Event where whoid in :CsSalesIdsMap.keyset() and what.type!='Case' ];
for (Event e  : eventList){
    e.whoid= CsSalesIdsMap.get(e.whoid);
    updatedEventList.add(e);
}

//copy campaign members to sales contacts
List<Campaignmember> campaignmemberList= [SELECT id,campaignid, contactid FROM CampaignMember  WHERE contactid in :CsSalesIdsMap.keyset()];
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
        cm.contactid= CsSalesIdsMap.get(contactid);
        campaignmemberListNew.add(cm);
    }
    
 
}

   
 if(campaignmemberList.size()>0)
    Database.delete(campaignmemberList);
System.debug('##campaignmemberListNew ' + campaignmemberListNew );


if(campaignmemberListNew .size()>0)
    Database.insert(campaignmemberListNew );
    
    
  

//tender contact role

List<crm_Tender_Contact_Role__c> tenderContactList= [Select id,crm_Contact__c  from crm_Tender_Contact_Role__c where  crm_Contact__c in :CsSalesIdsMap.keyset()];
for (crm_Tender_Contact_Role__c contactrole: tenderContactList){
    contactrole.crm_Contact__c  =  CsSalesIdsMap.get(contactrole.crm_Contact__c);
    updatedtenderroleList.add(contactrole);

}


//Individual Email Results

List<et4ae5__IndividualEmailResult__c> emailresults= [Select id, et4ae5__Contact__c from  et4ae5__IndividualEmailResult__c where  et4ae5__Contact__c  in :CsSalesIdsMap.keyset()];
for (et4ae5__IndividualEmailResult__c email: emailresults){
    email.et4ae5__Contact__c =  CsSalesIdsMap.get(email.et4ae5__Contact__c );
    updatedemailresultlist.add(email);

}
//email send

List<et4ae5__SendDefinition__c> emailsendresults= [Select id, et4ae5__Contact__c from  et4ae5__SendDefinition__c where  et4ae5__Contact__c  in :CsSalesIdsMap.keyset()];
for (et4ae5__SendDefinition__c email: emailsendresults){
    email.et4ae5__Contact__c =  CsSalesIdsMap.get(email.et4ae5__Contact__c );
    updatedemailsendresultlist.add(email);

}


//notes and attachments
//HTML Email Status
//Files

//assets
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
   


}

global void finish(Database.BatchableContext BC) {
                
    }


}