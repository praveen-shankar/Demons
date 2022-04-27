//Author: Rajeev S
//CTI Project

public without sharing class OmniChannelQueueMembershipController{
    
    //Initializations
    public List<Group> groupDetails;
    public List<queueMemberWrapper> allQueues {get;set;}
    public Map<Id,Set<Id>> groupUsersMap;
    public List<GroupMember> omnipublicgroups;
    public Map<Id,String> groupDetailsMap;
    public Map<Id,Integer> workmapsize;
    public User currentuser;
    public Boolean autorefresh {get;set;}
    public String btnName {get;set;}
        
    //Constructor
    //Query all Queues associated with Omni Channel
    public OmniChannelQueueMembershipController(){
        allQueues = new List<queueMemberWrapper>();
        groupUsersMap = new Map<Id,Set<Id>>();
        groupDetailsMap = new Map<Id,String>();
        workmapsize = new Map<Id,Integer>();
        List<String> allowedgroups = new List<String>();
        Set<Id> allowedgroupdIds = new Set<Id>();
        
        currentuser = [Select Id, Omni_Membership_Auto_Refresh__c From User Where Id = :Userinfo.getUserId()];
        autorefresh = currentuser.Omni_Membership_Auto_Refresh__c;
        btnName = (autorefresh) ? Label.Omni_Auto_Refresh_btnName2 : Label.Omni_Auto_Refresh_btnName1;
                
        Agent_Omni_Configuration__c[] agentsomni = [Select Allowed_Public_Groups__c From Agent_Omni_Configuration__c Where Agent_Id__c = :Userinfo.getUserId() Limit 1];
        if(agentsomni.size() > 0 && String.isNotBlank(agentsomni[0].Allowed_Public_Groups__c)) allowedgroups = agentsomni[0].Allowed_Public_Groups__c.split('\r\n');        
        if(allowedgroups.size() == 1){
            allowedgroups.clear();
            allowedgroups = agentsomni[0].Allowed_Public_Groups__c.split('\n');
        }
        
        for(Group g : [Select Id From Group Where DeveloperName In :allowedgroups])
            allowedgroupdIds.add(g.Id);

        //Select all Queues related to Omni Channel
        omnipublicgroups = [Select Id, GroupId, UserOrGroupId, Group.QueueRoutingConfigId, Group.Type, Group.Name, Group.DeveloperName From GroupMember Where 
                            UserOrGroupId IN :allowedgroupdIds Order By Group.Name ASC];
               
        //Query all public groups starting with "OMNI"                        
        groupDetails = [Select Id, Name, Type From Group Where Developername Like '%omni%' And Type = 'Regular'];
        
        for(Group g : groupDetails)
            groupDetailsMap.put(g.Id,g.Name);
        
        createUserGroupMap();
        findPendingWorkItems();
        queryAllQueues();
        
    }
    
    
    //Query all pending workitems assigned to Omni channel queues
    private void findPendingWorkItems(){
        Set<Id> QueueIds = new Set<Id>();
        for(GroupMember gm : omnipublicgroups){
            QueueIds.add(gm.GroupId);
        }
        AggregateResult[] chatresult = [Select COUNT(Id) wi,OwnerId from LiveChatTranscript Where OwnerId IN :QueueIds Group By OwnerId];
        AggregateResult[] caseresult = [Select COUNT(Id) wi,OwnerId from Case Where OwnerId IN :QueueIds Group By OwnerId];
        for(AggregateResult ar : chatresult){ 
            workmapsize.put((Id)ar.get('OwnerId'),(Integer)ar.get('wi'));                 
        }
        for(AggregateResult ar : caseresult){ 
            workmapsize.put((Id)ar.get('OwnerId'),(Integer)ar.get('wi'));                 
        }
    }
    
    
    //Create a wrapper of rows to be displayed on the VF page
    private void queryAllQueues(){
        for(GroupMember gm : omnipublicgroups){
            allQueues.add(new queueMemberWrapper(gm.UserOrGroupId,gm.Group.Name,gm.Group.Type,gm.Group.QueueRoutingConfigId,checkMembership(gm.UserOrGroupId),
            groupDetailsMap.get(gm.UserOrGroupId),workmapsize.get(gm.GroupId)));
        }
    }
    
    
    //Create a map of Queue and Queue members
    private void createUserGroupMap(){
        Set<Id> groupids = new Set<Id>();
        for(GroupMember g : omnipublicgroups)
            groupids.add(g.UserOrGroupId);
        for(GroupMember gm : [Select GroupId, UserOrGroupId From GroupMember Where GroupId In :groupids]){
            if((gm.UserOrGroupId.getSObjectType() == Schema.User.sObjectType)){
                if(!groupUsersmap.containsKey(gm.GroupId))
                    groupUsersmap.put(gm.GroupId,new Set<Id>{gm.UserOrGroupId});
                else    
                    groupUsersmap.get(gm.GroupId).add(gm.UserOrGroupId);
            }
        }
    }
    
    
    //Check if a user in Salesforce is a part of the Queue
    private String checkMembership(Id groupid){
        String returns = null;
        if(groupid != null && groupUsersmap.containsKey(groupid) && (groupUsersmap.get(groupid).contains(UserInfo.getUserId())))
            returns = Label.Member;
        else
            returns = '-';
            
       return returns;             
    }
    
    
    //Method to delete group membership
    public PageReference removeMembership(){
        Set<Id> queuememberobjects = new Set<Id>();
        for(queueMemberWrapper q : allQueues){
            if(q.selection)
                queuememberobjects.add(q.usergroupid);
        }
        
        delete [Select Id from GroupMember Where GroupId In :queuememberobjects AND UserOrGroupId = :Userinfo.getUserId()];
      return null;  
    }
    
    
    //Method to insert group membership
    public PageReference addMembership(){
        Set<Id> queuememberobjects = new Set<Id>();
        List<GroupMember> members = new List<GroupMember>();
        for(queueMemberWrapper q : allQueues){
            if(q.selection)
                queuememberobjects.add(q.usergroupid);
        }
        
        for(Id id : queuememberobjects){
            GroupMember gm = new GroupMember(GroupId = id, UserOrGroupId = Userinfo.getUserId());
            members.add(gm);
        }
        
        insert members;
      return null;  
    }
   
   
   //Returns reference to current page
   public Pagereference refresh(){
       return Page.OmniChannelQueueMembership.setRedirect(true);
   }
   
   public Pagereference setAutoRefresh(){
       if(currentuser.Omni_Membership_Auto_Refresh__c)
           currentuser.Omni_Membership_Auto_Refresh__c = false;
       else
           currentuser.Omni_Membership_Auto_Refresh__c = true;
       
       update currentuser;
      return refresh();          
   }
   
   //Wrapper class
   public class queueMemberWrapper{
        public String queuename{get;set;}
        public Id usergroupid{get;set;}
        public String reason{get;set;}
        public Boolean selection{get;set;}
        public String routingConfig{get;set;}
        public String member{get;set;}
        public String publicgroupname{get;set;}
        public Integer workitemsize{get;set;}
        public queueMemberWrapper(Id i, String q, String r, String rc, String member, String publicgroupname,Integer workitemsize){
            usergroupid = i;
            queuename = q;
            reason = r;
            selection = false;
            routingConfig = rc;
            this.member = member;
            this.publicgroupname = publicgroupname;
            this.workitemsize = workitemsize;
        }
    }

}