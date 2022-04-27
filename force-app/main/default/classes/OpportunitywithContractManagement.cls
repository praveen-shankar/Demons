public class OpportunitywithContractManagement {
    @AuraEnabled 
    public static Opportunity getOpportunity(Id Opportunityid){
        System.debug('@@OppId'+ Opportunityid);
        Opportunity o=[Select Id,crm_Enriched_In_PriceEngine__c,crm_Verified_by_Contract_Management__c,Date_of_Bid_Verification__c,Bid_Verified_By__c,Bid_Verified_By__r.Name,Bid_Team_Comments__c, Linked_agreements__c,Customer_Numbers_for_linked_agreements__c, Send_Shell_Agreement__c from Opportunity where Id=:Opportunityid LIMIT 1];
     	System.debug('@@o'+o);
        return o;   
    }
    
     @AuraEnabled 
    public static List<User> getUser(String Username){
        System.debug('@@Username'+ Username);
        String Uname='\'%'+Username+'%\'';
        String s= 'Select Id,Name from User where Name like '+ Uname;
        List<User> u=Database.query(s);
        System.debug('@@U'+u);
        return u;   
    }
    
     @AuraEnabled
     public static boolean getprofilename()
    {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName);
        
        List<User> roleNameList = [Select id, name, userrole.name  from user  where id= :userinfo.getUserId() limit 1];
        String role='';
        if(roleNameList.size()> 0 && roleNameList[0].userrole.name!=null) 
                role=roleNameList[0].userrole.name;
        
        system.debug('role'+role);
        
        List<GroupMember> gm = [Select Id, UserOrGroupId,GroupId,Group.type From GroupMember Where group.name= 'Contract/Bid Management Team'];
        Set<Id> members = new Set<Id>();
        for(GroupMember g:gm)
        {
        members.add(g.UserOrGroupId);
        }
        system.debug(members);
        Map<string,string> profNameMap = new Map<string,string>();
        Map<string,string> roleNameMap = new Map<string,string>();
        // Getting profiles names from custom setting 
        AccountConversionProfileName__c profilenames = AccountConversionProfileName__c.getValues('Opportunity_allowed_Profiles');
        AccountConversionProfileName__c rolenames = AccountConversionProfileName__c.getValues('Opportunity_allowed_Roles');
        
        string pnames = profilenames.ProfileName__c; 
        string rolename = rolenames.ProfileName__c;
         for(string st : pnames.split(',')){
             profNameMap.put(st, st);         
        }
        
         for(string st : rolename.split(',')){
             roleNameMap.put(st, st);         
        }
        
         system.debug('profNameMap'+profNameMap);
         system.debug('roleNameMap'+roleNameMap);
         
         if(profNameMap.get(profileName)!=null  || roleNameMap.get(role)!=null || members.contains(userinfo.getUserId())){
            return true;
        }
        else{            
            return false;
        }
    }  
      @AuraEnabled 
    public static String saveOpportunity(Opportunity Opp, String userId){
        System.debug('Opportunity'+ Opp);
        if(userId!=null  && userId.length()>0)
         Opp.Bid_Verified_By__c=userId;
        try {
        Update Opp;
        return 'success';
        }
        catch(Exception e){
            return e.getMessage();
        }
        
    }
    
    @AuraEnabled
 public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val,
  Integer lim, String fld_API_Search, String searchText) {
 System.debug('@Newmethod'+ objectName+'---'+fld_API_Text+'---'+fld_API_Val+'---'+lim+'---'+fld_API_Search+'---'+searchText);
  searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';

  String userType = 'Sales';
  String query = 'SELECT ' + fld_API_Text + ' ,' + fld_API_Val +
   ' FROM ' + objectName +
   ' WHERE ' + fld_API_Search + ' LIKE ' + searchText +
   ' and isactive = true  and crm_User_Type__c = :userType LIMIT ' + lim;
      
      System.debug(query);

  List < User > sobjList = Database.query(query);
  List < ResultWrapper > lstRet = new List < ResultWrapper > ();

  for (User s: sobjList) {
   ResultWrapper obj = new ResultWrapper();
   obj.objName = objectName;
   obj.val = String.valueOf(s.get(fld_API_Text));
   obj.text = String.valueOf(s.get(fld_API_Val));
   lstRet.add(obj);
  }
  return JSON.serialize(lstRet);
 }

 public class ResultWrapper {
  public String objName {
   get;
   set;
  }
  public String text {
   get;
   set;
  }
      public String val {
   get;
   set;
  }

 }    

}