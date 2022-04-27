/*Sakshi: C-09492 - CR for give an alert message if the manager is inactive*/
public class AttachmentUploadController 
{
    public String selectedManagerStatus {get;set;}
    public String nextvalue {get;set;}
    public List<String> selectedValue {get;set;}
    public List<String> valuepresent {get;set;}
    public String keyword{get;set;}
    public List<SelectOption> allMembers {get;set;}
    public String groupType {get;set;}
    public List<SelectOption> optionList;
    public boolean checkstatus{get;set;}
    Public List<String> getAvailableMembers {get;set;}
    Public List<String> getSelectedMembers {get;set;}
    public String description {get;set;}
    public Case caseObj {get;set;} 
    public String fileName {get;set;}
    public Blob fileBody {get;set;}
    public List<SelectOption> group_id; 
    public List<SelectOption> user_id; 
    public List<SelectOption> role_id; 
    public String custAttachId {get;set;}
    //  public Case_Attachment__c  caseattachObj {get;set;}
    
    
    public AttachmentUploadController(ApexPages.StandardController controller) { 
        this.caseObj = (Case)controller.getRecord();
        allMembers = new List<SelectOption>();
        // optionList = new List<SelectOption>();
        group_id  = new  List<SelectOption>();
        user_id  = new  List<SelectOption>();
        role_id  = new  List<SelectOption>();
        //  checkstatus=true;
        
        
        List<Group> grpList = [SELECT Id, Name FROM Group WHERE Type = 'Regular'];
        for( Group grp: grpList )
            allMembers.add( new SelectOption(grp.id, 'Group: '+grp.name) );
    }   
    
    // creates a new Case_Attachment__c record
    private Database.SaveResult saveCustomAttachment() {
        Case_Attachment__c obj = new Case_Attachment__c();
        obj.Case__c = caseObj.Id; 
        obj.Description__c = description;
        obj.Choose_Seller_Manager_Status__c = selectedManagerStatus;
        /*obj.If_Seller_Manager_Inactive__c = selectedAwesomeness;*/
        // fill out cust obj fields
        return Database.insert(obj);
    }
    
    // create an actual Attachment record with the Case_Attachment__c as parent
    private Database.SaveResult saveStandardAttachment(Id parentId) {
        Database.SaveResult result;
        
        Attachment attachment = new Attachment();
        attachment.body = this.fileBody;
        attachment.name = this.fileName;
        attachment.parentId = parentId;
        // inser the attahcment
        result = Database.insert(attachment);
        fileBody = Blob.valueOf(' ');
        return result;
        
        // reset the file for the view state
        
        
    }
    
    
    /**
* Upload process is:
*  1. Insert new Case_Attachment__c record
*  2. Insert new Attachment with the new Case_Attachment__c record as parent
*  3. Update the Case_Attachment__c record with the ID of the new Attachment
**/
    public void processUpload() {
        Database.SaveResult customAttachmentResult = saveCustomAttachment();
        if(filebody!=null)
        {
            system.debug('Filebody'+fileBody);
            Database.SaveResult attachmentResult = saveStandardAttachment(customAttachmentResult.getId());
            try {
                
                Case_Attachment__c customAttachment = [select id from Case_Attachment__c where id = :customAttachmentResult.getId()];
                Attachment attachment = [select id from Attachment where id = :attachmentResult.getId()];
                System.debug('customAttachment'+ customAttachment);
                if (customAttachmentResult == null || !customAttachmentResult.isSuccess() ||  attachment.Id==null) {
                    system.debug('Inside deleting custom attachment ');
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                               'Could not save attachment.'));
                    delete customAttachment;
                    //  return null;
                }
                
                // Database.SaveResult attachmentResult = saveStandardAttachment(customAttachmentResult.getId());
                //  Attachment attachment = [select id from Attachment where id = :attachmentResult.getId()];
                System.debug('attachmentResult'+ attachmentResult);
                if (attachmentResult == null || !attachmentResult.isSuccess()) {
                    system.debug('Inside deleting standard attachment');
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                               'Could not save attachment.'));            
                    //  return null;
                    delete attachment;
                    delete customAttachment;
                } else {
                    
                    System.debug('in else');
                    // update the custom attachment record with some attachment info
                    
                    customAttachment.name = this.fileName;
                    customAttachment.Attachment__c = attachmentResult.getId();
                    //customAttachment.Description__c=caseattachObj.description__c;
                    update customAttachment;
                    custAttachId=customAttachment.Id;
                    nextvalue= 'selectusers';
                }
                
            } catch (Exception e) {
                system.debug('inside catch');
                ApexPages.AddMessages(e);
                //   return null;
            }
        }
        else
        {
            Case_Attachment__c ca = new Case_Attachment__c();
            ca.Id = customAttachmentResult.getId();
            delete ca;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'File Cannot Be Blank !!!');
            ApexPages.addMessage(msg);
        }
    }
    
    
    public PageReference back() {
        return new PageReference('/'+caseObj.Id);
    }
    
    public void NEXT()
    {
        nextvalue= 'selectusers';
        
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
            for( Group g: groupList )
                optionList.add( new SelectOption(g.id, 'Group: '+g.name) );
            system.debug('INSIDE Public Groups  ');
            system.debug('optionList'+optionList);
        }
        else  if(groupType == 'Roles')
        {
            
            String query='SELECT Id,name FROM UserRole '+whereclause;
            List<UserRole> roleList = Database.query(query);
            for( UserRole u: roleList )
                optionList.add( new SelectOption(u.id, 'Role: '+u.name) );
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
                optionList.add( new SelectOption(u.id, 'User: '+u.name) );
        }
        
    }
    
    Public List<SelectOption> getallOptions(){ 
        system.debug('INSIDE getAllMembers');
        system.debug('optionList'+optionList);
        return optionList;
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
            List<Group> gm = [SELECT Id, Name FROM Group where Id IN :selectedValue];  
            //   group_id  = new  List<SelectOption>();
            for(Group g:gm){
                group_id.add(new SelectOption(g.id,'Group: '+g.Name));
            }
            
        }
        else  if(groupType == 'Users')
        {
            List<User> userlist = [SELECT Id, Name FROM User where Id IN :selectedValue];  
            for(User u:userlist){
                user_id.add(new SelectOption(u.id,'User: '+u.Name));
            }
        }
        else  if(groupType == 'Roles')
        {
            List<UserRole> userRoleList = [SELECT Id, Name FROM UserRole where Id IN :selectedValue];  
            for(UserRole ur:userRoleList){
                role_id.add(new SelectOption(ur.id,'Role: '+ur.Name));
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
        
        
        /* List<USER> users_1  = [SELECT name from User where id in :group_id];
users_id = new List<SelectOption>();
for(User u:users_1 ){
users_id.add(new SelectOption(u.name,u.name));
}*/
        
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
            for(integer i=0;i<group_id.Size();i++)
            {
                tempOptionList.add(new SelectOption(group_id[i].getValue(),group_id[i].getLabel()));
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
                    group_id.add(new SelectOption(tempOptionList[i].getValue(),tempOptionList[i].getLabel()));
                }
                else
                {
                    optionList.add(new SelectOption(tempOptionList[i].getValue(),tempOptionList[i].getLabel()));
                }
            }
            
        }
        else if(groupType == 'Users')
        {
            for(integer i=0;i<user_id.Size();i++)
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
            }
            
        }
        else if(groupType == 'Roles')
        {
            for(integer i=0;i<role_id.Size();i++)
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
            }
            
        }
    }
    Public List<SelectOption> getSelected(){ 
        system.debug('INSIDE Selected');
        if(groupType == 'Public Groups')
        {
            system.debug('group_id List'+group_id);
            return group_id;
        }
        else
            if(groupType == 'Users')
        {
            system.debug('user_id List'+user_id);
            return user_id;
        }
        else  if(groupType == 'Roles')
        {
            system.debug('role_id List'+role_id);
            return role_id;
        }
        else return null;
    }
    
    public PageReference save()
    {
        
        if(groupType=='Users')
        {
            List<Custom_Attachment_Details__c> custAttach = new List<Custom_Attachment_Details__c>();
            custAttach=[Select id,GroupType__c,Attachment__c from Custom_Attachment_Details__c where GroupType__c='Users' and Attachment__c=:custAttachId];
            if(custAttach.size()>0)
                delete custAttach;
            for(integer i=0;i<user_id.Size();i++)
            {
                Custom_Attachment_Details__c custAttachnew = new Custom_Attachment_Details__c();
                custAttachnew.Case_Number__c=caseObj.Id;
                custAttachnew.Attachment__c=custAttachId;
                custAttachnew.GroupType__c=groupType;
                custAttachnew.Selected_Users__c=user_id[i].getValue();
                insert custAttachnew;
                
                
            }
        }
        if(groupType=='Public Groups')
        {
            List<Custom_Attachment_Details__c> custAttach = new List<Custom_Attachment_Details__c>();
            custAttach=[Select id,GroupType__c,Attachment__c from Custom_Attachment_Details__c where GroupType__c='Public Groups' and Attachment__c=:custAttachId];
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
                                         WHERE GroupId = :group_id[i].getValue()]){
                                             if(g.UserOrGroupID.getsObjectType() == Schema.User.sObjectType)
                                                 userIDs.add(g.UserOrGroupID);
                                             grpId = (String)group_id[i].getValue();              
                                         }
                
                usrs = [Select ID From User Where ID IN :userIDs];
                for(User u:usrs)
                {
                    Custom_Attachment_Details__c custAttachnew = new Custom_Attachment_Details__c();
                    custAttachnew.Case_Number__c=caseObj.Id;
                    custAttachnew.Attachment__c=custAttachId;
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
            custAttach=[Select id,GroupType__c,Attachment__c from Custom_Attachment_Details__c where GroupType__c='Roles' and Attachment__c=:custAttachId];
            if(custAttach.size()>0)
                delete custAttach;
            List<Custom_Attachment_Details__c> attachmentList = new List<Custom_Attachment_Details__c>();
            for(integer i=0;i<role_id.Size();i++)
            {
                
                for(User u : [select Id, name,UserRoleId from User where UserRoleId =:role_id[i].getValue()]){
                    
                    Custom_Attachment_Details__c custAttachnew = new Custom_Attachment_Details__c();
                    custAttachnew.Case_Number__c=caseObj.Id;
                    custAttachnew.Attachment__c=custAttachId;
                    custAttachnew.GroupType__c=groupType;
                    custAttachnew.Selected_Users__c=u.Id;
                    attachmentList.add(custAttachnew);
                }
                
            }
            insert attachmentList;
            
        }
        Custom_Attachment_Details__c custAttachnew = new Custom_Attachment_Details__c();
        custAttachnew.Case_Number__c=caseObj.Id;
        custAttachnew.Attachment__c=custAttachId;
        custAttachnew.GroupType__c=groupType;
        custAttachnew.Selected_Users__c=UserInfo.getUserId();
        insert custAttachnew;
        Case_Attachment__c customAttachment = [select id from Case_Attachment__c where id = :custAttachId];
        customAttachment.Description__c=description;
        update customAttachment;
        return new PageReference('/'+caseObj.Id);
        
    }
}