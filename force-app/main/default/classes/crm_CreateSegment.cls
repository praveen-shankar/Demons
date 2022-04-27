public class crm_CreateSegment {

//Apex class used by custom lightning componnet to create segments 

    @AuraEnabled
    public static List <SGWrapper> getOpportunityserviceGroups(String acctId) {
      Schema.DescribeSObjectResult oppinfo = Opportunity.SObjectType.getDescribe();
       Set<String> rtIds = new Set<String>();
         List<SGWrapper> serviceGroups=  new List<SGWrapper>();    
       for(Schema.RecordTypeInfo rt : oppinfo.getRecordTypeInfos()){
                if(rt.isAvailable())
                    rtIds.add(rt.getRecordTypeId());
            }
        
            Account acc = [SELECT Id, Customer_Converted__c FROM Account WHERE Id = : acctId LIMIT 1];
             
            crm_Opportunity_Record_Type__mdt[] recordTypes = [SELECT Id, DeveloperName, MasterLabel, crm_Id__c, crm_IsNew__c, Modified__c,Unavailable__c,Unchanged__c FROM crm_Opportunity_Record_Type__mdt
                                                              WHERE crm_Id__c IN :rtIds ORDER BY MasterLabel ASC];
            
     if (acc.Customer_Converted__c == 'Converted' || acc.Customer_Converted__c ==  'InPreparation') {
         for(crm_Opportunity_Record_Type__mdt o : recordTypes){
                     if(o.crm_IsNew__c || o.Modified__c|| o.Unchanged__c)
                      serviceGroups.add(new SGWrapper(o.MasterLabel, false));    
                }
            }  else if (acc.Customer_Converted__c != 'Converted' || String.isBlank(acc.Customer_Converted__c)) {   
                for(crm_Opportunity_Record_Type__mdt o : recordTypes){
                      if(!o.crm_IsNew__c)
                        serviceGroups.add(new SGWrapper(o.MasterLabel, false));    
                }
            } 
     /*  for(crm_Opportunity_Record_Type__mdt o : recordTypes){
           serviceGroups.add(new SGWrapper(o.MasterLabel, false)); 
       
       }     */ 
            
          
        
     return serviceGroups;
    }
    
    
   /*  @AuraEnabled
    public static List <SGWrapper> getOpportunityserviceGroups(String acctId)
    {
        List<SGWrapper> serviceGroups=  new List<SGWrapper>();    
        
        Schema.DescribeFieldResult fieldResult =  Opportunity.crm_Opp_Service_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            //options.put(f.getLabel(), f.getValue());
             serviceGroups.add(new SGWrapper(f.getValue(), false)); 
        }  
        System.debug('###'+serviceGroups);
        return serviceGroups;
    }*/
    
    @AuraEnabled
    public static  List<String> saveSegments(String acctId, List<String> selectedLists ){
         System.debug(acctId+ selectedLists);
         List<String> errorLogs;
         list<Database.Error> errlogs;
         Set<Id> segmentId = new Set<Id>(); 
         List <crm_Segment__c> segmentList= new List<crm_Segment__c>();
        
         
       Schema.DescribeSObjectResult oppinfo = Opportunity.SObjectType.getDescribe();
    
       Set<String> rtIds = new Set<String>();
       Map<String,String> recordtypeMap =  new Map<String,String>(); 
       for(Schema.RecordTypeInfo rt : oppinfo.getRecordTypeInfos()){
                if(rt.isAvailable())
                    rtIds.add(rt.getRecordTypeId());
       }
        
      crm_Opportunity_Record_Type__mdt[] recordTypes = [SELECT Id, DeveloperName, MasterLabel, crm_Id__c, crm_IsNew__c FROM crm_Opportunity_Record_Type__mdt
                                                              WHERE crm_Id__c IN :rtIds ORDER BY MasterLabel ASC];
                                                              
        Schema.DescribeFieldResult fieldResult =  Opportunity.crm_Opp_Service_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       
       Set<String> recortypeSet = new set<String>(); 
       for( Schema.PicklistEntry f : ple){
             System.debug('##111'+f.getLabel() + 'aa' + f.getValue()); 
          //  recordtypeMap.put(f.getLabel(), f.getValue()); 
           recordtypeMap.put(f.getValue(), f.getLabel());
           recortypeSet.add(f.getValue());
        } 
        
         System.debug('##'+recordtypeMap); 
         for (String sg: selectedLists){
            crm_segment__c seg= new crm_segment__c();
            seg.crm_Account__c=acctId;
            if(recortypeSet.contains(sg))
                seg.crm_Service_Group__c= sg; //  sg;
            seg.crm_Sales_Responsible__c= UserInfo.getUserId();
            segmentList.add(seg);
            
        }
        
        System.debug('##'+segmentList);
        try{
            if(segmentList.size()>0)
               {
                   errorLogs = new list<string>(); 
                   Database.UpsertResult[] srList = Database.Upsert(segmentList, false);
                   system.debug('~~~srList::'+srList);
                 
                   for (Database.UpsertResult sr : srList) 
                    {
                     system.debug('##sr' + sr);
                         if (!sr.isSuccess()) 
                            {   
                             system.debug('##srerror' +  sr.getErrors());
                                for (Database.Error error : sr.getErrors()) 
                                {   
                                     system.debug('##srerror' +  error.getMessage());
                                    string s= error.getMessage();
                                    Id segId = Id.valueOf(s.subStringAfter('ID: '));
                                    system.debug('##segId ' + segId );
                                    segmentId.add(segId);
                                   
                                 
                                }  
                }  
            }
             system.debug('##segmentId' + segmentId);
                   
                 List<crm_Segment__c> segList=[SELECT Id, crm_Service_Group__c FROM crm_Segment__c WHERE Id in :segmentId];
                    for (crm_segment__c seg:segList )
                         errorLogs.add(seg.crm_Service_Group__c);
            }
     }
           catch(Exception ex)
           {
                
                 
            }
        
         System.debug('##errorLogs'+errorLogs);
       
         return errorLogs;
    }
    
    public with sharing class SGWrapper
{
    @AuraEnabled
    public String sgroup {get; set;}
     
    @AuraEnabled
    public Boolean selected {get; set;}
    
     SGWrapper(String sgroup,Boolean selected){
            this.sgroup = sgroup;
            this.selected = selected;
        }
}
    
    
}