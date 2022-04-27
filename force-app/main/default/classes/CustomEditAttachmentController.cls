public class CustomEditAttachmentController {
    public String selectedManagerStatus {get;set;}
    public String nextvalue {get;set;}
    public String currentRecordId {get;set;}
    public List<String> selectedValue {get;set;}
    public List<String> valuepresent {get;set;}
    public String keyword{get;set;}
    public List<SelectOption> allMembers {get;set;}
    public String groupType {get;set;}
    public List<SelectOption> optionList;
    public boolean checkstatus{get;set;}
    Public List<String> getAvailableMembers {get;set;}
    Public List<String> getSelectedMembers {get;set;}
    Public List<Group> membersPresent {get;set;}
    public String description {get;set;}
    public Case_Attachment__c  caseObj {get;set;} 
    public String fileName {get;set;}
    public Blob fileBody {get;set;}
    public List<group> group_id; 
    public List<User> user_id; 
    public List<UserRole> role_id; 
    Set<Id> idList = new Set<Id>();
    Set<Id> useridList = new Set<Id>();
    Set<Id> roleidList = new Set<Id>();
    
    public String custAttachId {get;set;}
    
    
    //public CustomEditAttachmentController(){}
    public CustomEditAttachmentController(ApexPages.StandardController controller) { 
        this.caseObj = (Case_Attachment__c )controller.getRecord();
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        allMembers = new List<SelectOption>();
        group_id  = new  List<group>();
        user_id  = new  List<User>();
        role_id  = new  List<UserRole>();
        List<Custom_Attachment_Details__c> tmp = [select id,GroupId__c,Attachment__c,Role__c,Selected_Users__c from Custom_Attachment_Details__c where Case_Number__c = :caseObj.Case__c and Attachment__c =:currentRecordId];
        
        for(Custom_Attachment_Details__c c: tmp)
        {
            idList.add(c.GroupId__c);
            useridList.add(c.Selected_Users__c);
            roleidList.add(c.Role__c);
        }
        //membersPresent = [select Id,name from Group where id in :idList];
        for( Group grp: [select Id,name from Group where id in :idList] )
            // if(groups.indexOf(grp) != -1)
            group_id.add( grp);
        system.debug('group_id in constructor'+group_id);   
        
        for( User u: [select Id,name from User where id in :useridList] )
            user_id.add(u);
        system.debug('user_id in constructor'+user_id);   
        
        for( UserRole ur: [select Id,name from UserRole where id in :roleidList] )
            role_id.add(ur);
        system.debug('role_id in constructor'+role_id);   
        /* if(groupType == 'Public Groups')
{
membersPresent = [select name from Group where id in :idList];
//List<Group> grpList = [SELECT Id, Name FROM Group WHERE Type = 'Regular'];
for( Group grp: membersPresent )
group_id.add( new SelectOption(grp.id, 'Group: '+grp.name) );
}*/
    }
    
    public void change()
    {
        optionList = new List<SelectOption>();
        String whereclause='';
        if(keyword!='')
        {
            whereclause = 'where name like \'%' + keyword + '%\'';
        }
        String whereclause1='';
        if(keyword!='')
        {
            whereclause1 = 'and name like \'%' + keyword + '%\' ';
        }
        system.debug('Inside change function');
        if(groupType == 'Public Groups')
        {
            String query= 'SELECT Id, Name FROM Group where Type = \'Regular\''+whereclause1+ 'limit 50';
            List<Group> groupList = Database.query(query);
            system.debug('grupp id initial'+group_id);
            system.debug('grupp id initial'+groupList);
            for( Group g: groupList )
            {
                //system.debug('grpid 1111'+group_id.get(g.id));
                if(!group_id.contains(g))
                    optionList.add( new SelectOption(g.id, 'Group: '+g.name) );
            }
            
            system.debug('INSIDE Public Groups  ');
            system.debug('optionList'+optionList);
        }
        else if(groupType == 'Roles')
        {
            
            String query='SELECT Id,name FROM UserRole '+whereclause;
            List<UserRole> roleList = Database.query(query);
            for( UserRole u: roleList )
            {
                if(!role_id.contains(u))
                    optionList.add( new SelectOption(u.id, 'Role: '+u.name) );
            }
            
            system.debug('INSIDE ROLES');
            system.debug('optionList'+optionList);
        }
        else if(groupType == 'Users')
        {
            system.debug('INSIDE USERS');
            //List<SelectOption> optionList = new List<SelectOption>();
            system.debug('Keyword'+Keyword); 
            String query='SELECT Id,name FROM User ' +whereclause +'limit 50';
            List<User> roleList =Database.query(query);
            
            system.debug('rolelist'+roleList);
            for( User u: roleList )
            {
                if(!user_id.contains(u))
                    optionList.add( new SelectOption(u.id, 'User: '+u.name) );
            }
        }
        
    }
    Public List<SelectOption> getallOptions(){ 
        system.debug('INSIDE getAllMembers');
        system.debug('optionList'+optionList);
        List<Integer> indexList = new List<Integer>();
        List<SelectOption> tmpList = new List<SelectOption>();
        /* if(getSelected() != null)
{
tmpList = getSelected();
tmpList = new List<SelectOption>(new Set<SelectOption>(tmpList));
system.debug('tmpList : '+tmpList);
if(optionList.size() == 0 || tmpList.size() == 0)
return optionList;
for(SelectOption opt : tmpList){
if(optionList.indexOf(opt) != -1)
indexList.add(optionList.indexOf(opt));
}
for(Integer idx : indexList)
optionList.remove(idx);
system.debug('optionList Final : '+optionList);
return optionList;
}*/
        List<SelectOption> tempOptionList1=new List<SelectOption>();
        Set<Integer> removeIndex1  = new Set<Integer>();
        /* if(groupType == 'Public Groups')
{
system.debug('group list'+group_id);
for(integer i=0;i<group_id.Size();i++)
{
tempOptionList1.add(new SelectOption(group_id[i].getValue(),group_id[i].getLabel()));
}
group_id.clear();  
for(integer i=0;i<tempOptionList1.Size();i++)
{
if(idList.contains(tempOptionList1[i].getValue()))
{
// system.debug('optionvalue'+optionList[i].getValue());
removeIndex1.add(i);
// tempOptionList.remove(i);
system.debug('initial group_id options'+optionList);

}

}

for(integer i=0;i<tempOptionList1.Size();i++)
{
if(!removeIndex1.contains(i))
{
group_id.add(new SelectOption(tempOptionList1[i].getValue(),tempOptionList1[i].getLabel()));
}
else
{
optionList.add(new SelectOption(tempOptionList1[i].getValue(),tempOptionList1[i].getLabel()));
}
}
return optionList;
}*/
        //else
        {
            return optionList;
        }
    }
    
    public void add(){
        List<SelectOption> tempOptionList = new List<SelectOption>();
        Set<Integer> removeIndex = new Set<Integer>();
        for(integer i=0;i<optionList.Size();i++)
        {
            tempOptionList.add(new SelectOption(optionList[i].getValue(),optionList[i].getLabel()));
        }
        
        system.debug('Inside add');
        if(groupType == 'Public Groups')
        {
            //List<Group> gm = [SELECT Id, Name FROM Group where Id IN :selectedValue];  
            //   group_id  = new  List<SelectOption>();
            for(Group g:[SELECT Id, Name FROM Group where Id IN :selectedValue]){
                group_id.add(g);
            }
            
        }
        else  if(groupType == 'Users')
        {
            //List<User> userlist = [SELECT Id, Name FROM User where Id IN :selectedValue];  
            for(User u:[SELECT Id, Name FROM User where Id IN :selectedValue]){
                user_id.add(u);
            }
        }
        else  if(groupType == 'Roles')
        {
            // List<UserRole> userRoleList = [SELECT Id, Name FROM UserRole where Id IN :selectedValue];  
            for(UserRole ur:[SELECT Id, Name FROM UserRole where Id IN :selectedValue]){
                role_id.add(ur);
            }
        }
        Set<String> selvalue = new set<String>();
        for(String s:selectedValue)
        {
            selvalue.add(s);
        }
        system.debug('selectvalue'+selvalue);
        optionList.clear();  
        for(integer i=0;i<tempOptionList.Size();i++)
        {
            if(selvalue.contains(tempOptionList[i].getValue()))
            {
                // system.debug('optionvalue'+optionList[i].getValue());
                removeIndex.add(i);
                // tempOptionList.remove(i);
                system.debug('afterremoveoptionList'+optionList);
                
            }
            
        }
        
        for(integer i=0;i<tempOptionList.Size();i++)
        {
            if(!removeIndex.contains(i))
            {
                optionList.add(new SelectOption(tempOptionList[i].getValue(),tempOptionList[i].getLabel()));
            }
        }
        
    }
    public void remove(){
        List<SelectOption> tempOptionList = new List<SelectOption>();
        Set<Integer> removeIndex = new Set<Integer>();
        Set<String> selvalue = new set<String>();
        for(String s:valuepresent)
        {
            selvalue.add(s);
        }
        system.debug('selectvalue'+selvalue);
        if(groupType == 'Public Groups')
        {
            Integer m = group_id.Size()-1;
            for(integer i=m;i>=0;i--)
            {
                system.debug('group name'+group_id.Size());
                if(selvalue.contains(group_id[i].Id))
                {
                    optionList.add(new Selectoption(group_id[i].id, 'Group: '+group_id[i].name));
                    group_id.remove(i);
                    //removeIndex.add(i);
                }
            }
            /* for(Integer i:removeIndex)
{
optionList.add(new Selectoption(group_id[i].id, 'Group: '+group_id[i].name));
//group_id.remove(i);
}*/
            system.debug('group'+group_id);
            /* for(integer i=0;i<group_id.Size();i++)
{
tempOptionList.add(new SelectOption(group_id[i].id,group_id[i].name));
}
group_id.clear();  
for(integer i=0;i<tempOptionList.Size();i++)
{
if(selvalue.contains(tempOptionList[i].getValue()))
{
// system.debug('optionvalue'+optionList[i].getValue());
removeIndex.add(i);
// tempOptionList.remove(i);
system.debug('afterremoveoptionList-in groups'+optionList);

}

}

for(integer i=0;i<tempOptionList.Size();i++)
{
if(!removeIndex.contains(i))
{
//group_id.add(new SelectOption(tempOptionList[i].getValue(),tempOptionList[i].getLabel()));
}
else
{
optionList.add(new SelectOption(tempOptionList[i].getValue(),tempOptionList[i].getLabel()));
}
}*/
            
            
        }
        else if(groupType == 'Users')
        {
            Integer m = user_id.Size()-1;
            for(integer i=m;i>=0;i--)
            {
                system.debug('user_id size'+user_id.Size());
                if(selvalue.contains(user_id[i].Id))
                {
                    optionList.add(new Selectoption(user_id[i].id, 'User: '+user_id[i].name));
                    user_id.remove(i);
                    //removeIndex.add(i);
                }
            }
            system.debug('user'+user_id);
            /* for(integer i=0;i<user_id.Size();i++)
{
tempOptionList.add(new SelectOption(user_id[i].getValue(),user_id[i].getLabel()));
}
user_id.clear();  
for(integer i=0;i<tempOptionList.Size();i++)
{
if(selvalue.contains(tempOptionList[i].getValue()))
{
// system.debug('optionvalue'+optionList[i].getValue());
removeIndex.add(i);
// tempOptionList.remove(i);
system.debug('afterremoveoptionList-in users'+optionList);

}

}

for(integer i=0;i<tempOptionList.Size();i++)
{
if(!removeIndex.contains(i))
{
user_id.add(new SelectOption(tempOptionList[i].getValue(),tempOptionList[i].getLabel()));
}
else
{
optionList.add(new SelectOption(tempOptionList[i].getValue(),tempOptionList[i].getLabel()));
}
}*/
            
        }
        else if(groupType == 'Roles')
        {
            Integer m = role_id.Size()-1;
            for(integer i=m;i>=0;i--)
            {
                system.debug('role_id size'+role_id.Size());
                if(selvalue.contains(role_id[i].Id))
                {
                    optionList.add(new Selectoption(role_id[i].id, 'User: '+role_id[i].name));
                    role_id.remove(i);
                    //removeIndex.add(i);
                }
            }
            system.debug('role'+role_id);   
            /* for(integer i=0;i<role_id.Size();i++)
{
tempOptionList.add(new SelectOption(role_id[i].getValue(),role_id[i].getLabel()));
}
role_id.clear();  
for(integer i=0;i<tempOptionList.Size();i++)
{
if(selvalue.contains(tempOptionList[i].getValue()))
{
// system.debug('optionvalue'+optionList[i].getValue());
removeIndex.add(i);
// tempOptionList.remove(i);
system.debug('afterremoveoptionList-in users'+optionList);

}

}

for(integer i=0;i<tempOptionList.Size();i++)
{
if(!removeIndex.contains(i))
{
role_id.add(new SelectOption(tempOptionList[i].getValue(),tempOptionList[i].getLabel()));
}
else
{
optionList.add(new SelectOption(tempOptionList[i].getValue(),tempOptionList[i].getLabel()));
}
}*/
            
        }
    }
    
    Public List<SelectOption> getSelected(){ 
        system.debug('INSIDE Selected');
        //group_id = new List<SelectOption>();
        List<SelectOption> groups = new List<SelectOption>();
        List<SelectOption> grpOptions = new List<SelectOption>();
        List<SelectOption> userOptions = new List<SelectOption>();
        List<SelectOption> roleOptions = new List<SelectOption>();
        if(groupType == 'Public Groups')
        {
            
            // group_id.addAll(groups);
            system.debug('group_id '+group_id);
            
            for (group g : group_id)
            {
                grpOptions.add(new Selectoption(g.id, 'Group: '+g.name));
            }
            return grpOptions;
        }
        else
            if(groupType == 'Users')
        {
            system.debug('user_id List'+user_id);
            for (User u : user_id)
            {
                userOptions.add(new Selectoption(u.id, 'User: '+u.name));
            }
            return userOptions;
            // return user_id;
        }
        else  if(groupType == 'Roles')
        {
            system.debug('role_id List'+role_id);
            for (UserRole ur : role_id)
            {
                roleOptions.add(new Selectoption(ur.id, 'Role: '+ur.name));
            }
            return roleOptions;
        }
        else return null;
    }
    
    public PageReference save()
    {
        
        if(groupType=='Users')
        {
            List<Custom_Attachment_Details__c> custAttach = new List<Custom_Attachment_Details__c>();
            Set<String> usrset = new Set<String>();
            custAttach=[Select id,GroupType__c from Custom_Attachment_Details__c where GroupType__c='Users'and Attachment__c=:currentRecordId];
            if(custAttach.size()>0)
                delete custAttach;
            List<Custom_Attachment_Details__c> attachmentList = new List<Custom_Attachment_Details__c>();
            String usrId;
            for( Custom_Attachment_Details__c custAttach1: [Select id,GroupType__c,Selected_Users__c from Custom_Attachment_Details__c where Attachment__c=:currentRecordId])
            {
                usrset.add(custAttach1.Selected_Users__c); 
            }
            
            for(integer i=0;i<user_id.Size();i++)
            {
                if(!usrset.contains(user_id[i].id))
                {
                    usrId = (String)user_id[i].id;
                    Custom_Attachment_Details__c custAttachnew = new Custom_Attachment_Details__c();
                    custAttachnew.Case_Number__c=caseObj.Case__c;
                    custAttachnew.Attachment__c=currentRecordId;
                    custAttachnew.GroupType__c=groupType;
                    custAttachnew.Selected_Users__c=usrId;
                    attachmentList.add(custAttachnew);
                }
                
            }
            insert attachmentList;
        }
        if(groupType=='Public Groups')
        {
            List<Custom_Attachment_Details__c> custAttach = new List<Custom_Attachment_Details__c>();
            custAttach=[Select id,GroupType__c from Custom_Attachment_Details__c where GroupType__c='Public Groups' and Attachment__c=:currentRecordId];
            system.debug('custAttach'+custAttach);
            if(custAttach.size()>0)
                delete custAttach;
            List<Custom_Attachment_Details__c> attachmentList = new List<Custom_Attachment_Details__c>();
            String grpId;
            for(integer i=0;i<group_id.Size();i++)
            {
                Set<ID> userIDs = New Set<ID>();
                User[] usrs = New User[]{};
                    for(GroupMember g : [SELECT Id, GroupId, UserOrGroupId 
                                         FROM GroupMember 
                                         WHERE GroupId = :group_id[i].id]){
                                             if(g.UserOrGroupID.getsObjectType() == Schema.User.sObjectType)
                                                 userIDs.add(g.UserOrGroupID);
                                             grpId = (String)group_id[i].id;              
                                         }
                
                usrs = [Select ID From User Where ID IN :userIDs];
                for(User u:usrs)
                {
                    Custom_Attachment_Details__c custAttachnew = new Custom_Attachment_Details__c();
                    custAttachnew.Case_Number__c=caseObj.Case__c;
                    custAttachnew.Attachment__c=currentRecordId;
                    custAttachnew.GroupType__c=groupType;
                    custAttachnew.Selected_Users__c=u.Id;
                    custAttachnew.GroupId__c = grpId;
                    attachmentList.add(custAttachnew);
                }
            }
            insert attachmentList;
        }
        if(groupType=='Roles')
        {
            List<Custom_Attachment_Details__c> custAttach = new List<Custom_Attachment_Details__c>();
            custAttach=[Select id,GroupType__c,Role__c from Custom_Attachment_Details__c where GroupType__c='Roles' and Attachment__c=:currentRecordId];
            if(custAttach.size()>0)
                delete custAttach;
            List<Custom_Attachment_Details__c> attachmentList = new List<Custom_Attachment_Details__c>();
            Set<String> usrset = new Set<String>();
            for( Custom_Attachment_Details__c custAttach1: [Select id,GroupType__c,Selected_Users__c from Custom_Attachment_Details__c where Attachment__c=:currentRecordId])
            {
                usrset.add(custAttach1.Selected_Users__c); 
            }
            
            for(integer i=0;i<role_id.Size();i++)
            {
                
                for(User u : [select Id, name,UserRoleId from User where UserRoleId =:role_id[i].id]){
                    if(!usrset.contains(user_id[i].id))
                    {
                        Custom_Attachment_Details__c custAttachnew = new Custom_Attachment_Details__c();
                        custAttachnew.Case_Number__c=caseObj.Case__c;
                        custAttachnew.Attachment__c=currentRecordId;
                        custAttachnew.GroupType__c=groupType;
                        custAttachnew.Selected_Users__c=u.Id;
                        custAttachnew.Role__c=(String)role_id[i].id;
                        attachmentList.add(custAttachnew);
                    }
                }
                
            }
            insert attachmentList;
        }
        //  Case_Attachment__c ca= new Case_Attachment__c();
        //  ca.Description__c=caseObj.Description__c;
        update caseObj;
        return new PageReference('/'+caseObj.Id);
        
    }
    
    public PageReference back() {
        return new PageReference('/'+caseObj.Id);
    }
    
    public void NEXT()
    {
        nextvalue= 'selectusers';
        
    }
}