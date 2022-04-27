public class crm_NewCreateSegment 
{
    //To Get Opportunities Service Group
    @AuraEnabled 
    public static Map<String, String> getAllOpportunitiesServiceGroup()
    {
        Map<String, String> optionMap = new Map<String, String>();
        //System.debug('optionMap for Opportunities Service Group' + optionMap);
        Schema.DescribeFieldResult fieldResult =  Opportunity.crm_Opp_Service_Group__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntryList = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry objPicklist : picklistEntryList)
        {
            optionMap.put(objPicklist.getValue(), objPicklist.getLabel());
        }  
        
        return optionMap;
        
    }
    
    //To Get Proposed responsible seller from Custom Metadata Types
    @AuraEnabled
    public static Map < String, String > getresponsibleseller() 
    {
        Map < String, String > userMap = new Map < String, String > ();
        Map < String, String > fictioususerMap = new Map < String, String > ();
        CRM_ficticous_user__mdt[] userslist= [SELECT Id, DeveloperName, MasterLabel, username__c FROM CRM_ficticous_user__mdt order by username__c asc];
        
        Set<String> usernames=  new Set<String>();
        for(CRM_ficticous_user__mdt u : userslist )
        {
            usernames.add(u.username__c);
            userMap.put(u.username__c, u.MasterLabel);  
        }
      
        
        List<User> users= [Select id, username from  user where username in  : usernames];                                                          
        
        for(User u  : users)
        {
            fictioususerMap.put(u.id,userMap.get(u.username));
        }
        
        
       
        return fictioususerMap;
    }
    
    //After Save Create Responsible Seller
    @AuraEnabled
    public static List < String > savesegment(String json) {
        System.debug('&&&&json' + json);
        NewSegmentWrapper wrapper = NewSegmentWrapper.parse(json);
        System.debug(wrapper);
        List < crm_segment__c > segmentList = new List < crm_segment__c > ();
        for (Integer i = 0; i < wrapper.reqchangesegments.size(); i++) {
            
            
            if (wrapper.reqchangesegments[i].chkServiceGroupvalue){
                crm_segment__c segObj = new crm_segment__c();  
                
                if (String.isNotBlank(wrapper.accountId))
                    segObj.crm_Account__c = wrapper.accountId;
                
                if (String.valueof(wrapper.reqchangesegments[i].proposedresponsibleseller)!='') 
                    segObj.crm_Sales_Responsible__c =String.valueof(wrapper.reqchangesegments[i].proposedresponsibleseller); 
                
                if (String.isNotBlank(wrapper.reqchangesegments[i].serviceGroupvalue)) 
                    
                    segObj.crm_Service_Group__c = wrapper.reqchangesegments[i].serviceGroupvalue; 
                segmentList.add(segObj);
            }
        }
        
        List<String> errorLogs;
        list<Database.Error> errlogs;
        Set<Id> segmentId = new Set<Id>(); 
        try{
            if(segmentList.size()>0)
            {
                errorLogs = new list<string>(); 
                Database.UpsertResult[] srList = Database.Upsert(segmentList, false);
                system.debug('~~~srList::'+srList);
                if(srList.size()>0){
                for (Database.UpsertResult sr : srList) 
                {
                    if (!sr.isSuccess()) 
                    {   
                        
                        for (Database.Error error : sr.getErrors()) 
                        {   
                            
                            string s= error.getMessage();
                            Id segId = Id.valueOf(s.subStringAfter('id: '));
                            segmentId.add(segId);
                            
                            
                        }  
                    }  
                }
               }                
                List<crm_Segment__c> segList=[SELECT Id, crm_Service_Group__c FROM crm_Segment__c WHERE Id in :segmentId];
                for (crm_segment__c seg:segList )
                    errorLogs.add(seg.crm_Service_Group__c);
            }
        }
        catch(Exception ex)
        {
            
          System.debug('##ex'+ex);   
        }
        
        System.debug('##errorLogs'+errorLogs);
        
        return errorLogs;      
        
    }
}