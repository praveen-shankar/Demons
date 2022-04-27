@isTest
public class CustomEditAttachmentControllerTest {
    @TestSetup
    //@isTest(seeAllData=true)
    private static void setupData() {
        case c = new case();
        c.subject = 'testPositive';
        c.Shipment_number__c = '123';
        insert c;
		
        List<user> userList = new List<User>();
        user u = crm_TestDataFactory.createUser();
          u.firstname='fname';
        u.LastName='lname';
        userList.add(u);
        user u1 = crm_TestDataFactory.createUser('testAdd','test');
        userList.add(u1);
        insert userList;
        
        //avoid insert, fetch result
        List<group> grpList = new List<group>();
        group g = new group();
        g.Name ='Test Group';
        g.Type ='Regular';
        grpList.add(g);
        group g1 = new group();
        g1.Name ='Test Group1';
        g1.Type ='Regular';
        grpList.add(g1);
        insert grpList;
        
        Userrole ur= [select id,name from userrole limit 1];
        
       
        
        Case_Attachment__c cAtt = new Case_Attachment__c ();
        cAtt.Case__c = c.id;
        cAtt.Description__c = 'Test CA';
        insert cAtt;
        
        Custom_Attachment_Details__c cAttDetail = new Custom_Attachment_Details__c ();
        cAttDetail.Attachment__c = cAtt.id;
        cAttDetail.Case_Number__c = c.id;
        cAttDetail.GroupId__c = grpList[0].id;
        cAttDetail.Selected_Users__c = userList[0].id;
        cAttDetail.Role__c = ur.id;
        insert cAttDetail;
      
    }
    static testMethod void TestEditAttachmentforGroup(){
  
        Case_Attachment__c testCA = [select id,Case__c from Case_Attachment__c where Description__c = 'Test CA']; 
        List<Group> grp=[Select id,name from group where name ='Test Group'];
        List<String> grpid = new List<String>();
         List<Group> groupid= new list<Group>();
        for(Group g: grp)
        {
            grpid.add(g.id);
            groupid.add(g);
        }
        PageReference pageRef = Page.CaseNewCustomAttachFile;
        pageRef.getParameters().put('id', String.valueOf(testCA.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con= new ApexPages.StandardController(testCA);
        CustomEditAttachmentController ext= new CustomEditAttachmentController(con); 
        
        ext.fileBody=Blob.valueOf('bodyBlob');
        ext.fileName='BodyBlob';       	
        List<SelectOption> opList = ext.getallOptions();
        ext.NEXT();
        
        // Group type as Public Group
        ext.groupType = 'Public Groups';
        ext.keyword = 'Test Group1';
        ext.selectedValue=grpid;
        ext.valuepresent=grpid;
        ext.group_id=groupid;
        ext.change();
        
        ext.add();
        ext.getSelected();
         ext.remove();
        ext.save();
    }
    
    static testMethod void TestEditAttachmentforUser(){
  
        Case_Attachment__c testCA = [select id,Case__c from Case_Attachment__c where Description__c = 'Test CA'];
         List<User> lu = [Select Id, firstname, lastname, Email from user where firstname='fname'];
        List<String> optnId1= new List<String>();
        for(User u: lu)
        {
            optnId1.add(u.Id);
        }
        PageReference pageRef = Page.CaseNewCustomAttachFile;
        pageRef.getParameters().put('id', String.valueOf(testCA.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con= new ApexPages.StandardController(testCA);
        CustomEditAttachmentController ext= new CustomEditAttachmentController(con); 
        
        ext.fileBody=Blob.valueOf('bodyBlob');
        ext.fileName='BodyBlob';       	
        List<SelectOption> opList = ext.getallOptions();
        ext.NEXT();
        
        User testU = [select name,id from user where LastName = 'testAdd'];
        //Group type as User 
        ext.groupType = 'Users';
        ext.keyword = testU.name;
        ext.selectedValue=optnId1;
        ext.valuepresent=optnId1;
        ext.change();
        
        ext.add();
        ext.getSelected();
        ext.remove();
        ext.save();
        
    }
    
    static testMethod void TestEditAttachmentforRole(){
  
        Case_Attachment__c testCA = [select id,Case__c from Case_Attachment__c where Description__c = 'Test CA']; 
        PageReference pageRef = Page.CaseNewCustomAttachFile;
        pageRef.getParameters().put('id', String.valueOf(testCA.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con= new ApexPages.StandardController(testCA);
        CustomEditAttachmentController ext= new CustomEditAttachmentController(con); 
        
        ext.fileBody=Blob.valueOf('bodyBlob');
        ext.fileName='BodyBlob';       	
        List<SelectOption> opList = ext.getallOptions();
        ext.NEXT();
       
        Custom_Attachment_Details__c cAttDetail = [select id,Role__c from Custom_Attachment_Details__c where Attachment__c =: testCA.id limit 1];
        Userrole ur= [select id,name from userrole where id != :cAttDetail.id limit 1];
        List<String> urid= new List<String>();
        urid.add(ur.Id);
        //Group type as Role
        ext.keyword = ur.name;
        ext.groupType = 'Roles';
        ext.selectedValue=urid;
        ext.valuepresent=urid;
        ext.change();
        ext.add();
        ext.getSelected();
        ext.remove();
        ext.save();
        
    }
}