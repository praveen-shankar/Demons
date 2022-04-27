@isTest
public class AttachmentUploadControllerTest {
    @TestSetup
    //@isTest(seeAllData=true)
    private static void setupData() {
        
        
        user u =crm_TestDataFactory.createUser(); 
        u.firstname='fname';
        u.LastName='lname';
        insert u; 
        
        group g= new group();
        g.Name='Test Group';
        g.Type='Regular';
        insert g;
        
        Userrole ur = new Userrole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert ur;
        Userrole ur1 = new Userrole(DeveloperName = 'MyCustomRole1', Name = 'My Role1');
        insert ur1;
        
        
    }
    static testMethod void testNegative(){
        Case c= new case();
        c.subject = 'testPositive';
        c.Shipment_number__c = '123';
        insert c;
        ApexPages.StandardController con= new ApexPages.StandardController(c);
        AttachmentUploadController ext= new AttachmentUploadController(con); 
        ext.processUpload();
    }
    static testMethod void TestAttachment(){
        case c = new case();
        c.subject = 'testPositive';
        c.Shipment_number__c = '123';
        insert c;
        List<Group> lg=[SELECT Id, Name FROM Group WHERE Type = 'Regular'];    
        List<String> optnId= new List<String>();   
        List<SelectOption> groupid= new list<SelectOption>();
        for(Group g: lg)
        {
            optnId.add(g.Id);
            groupid.add( new SelectOption(g.id, 'Group: '+g.name) );
        }
        
        PageReference pageRef = Page.CaseNewCustomAttachFile;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con= new ApexPages.StandardController(c);
        AttachmentUploadController ext= new AttachmentUploadController(con); 
        Test.startTest();
        ext.fileBody=Blob.valueOf('bodyBlob');
        ext.fileName='BodyBlob';
        ext.selectedValue=optnId;
        ext.valuepresent=optnId;
        // ext.group_id=groupid;
        // saveCustomAttachment(attach.Id);
        ext.processUpload();
        ext.groupType = 'Public groups';
        ext.keyword='Test';
        ext.back();
        ext.getallOptions();
        ext.NEXT();
        ext.change();
        ext.add();
        ext.getSelected();
        ext.remove();
        ext.save();
        Test.stopTest();
    }
    
    static testMethod void TestAttachmentUser(){
        case c = new case();
        c.subject = 'testPositive';
        c.Shipment_number__c = '123';
        insert c;
        PageReference pageRef = Page.CaseNewCustomAttachFile;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con= new ApexPages.StandardController(c);
        List<User> lu = [Select Id, firstname, lastname, Email from user where firstname='fname'];
        List<String> optnId1= new List<String>();
        for(User u: lu)
        {
            optnId1.add(u.Id);
        }
        
        AttachmentUploadController ext2= new AttachmentUploadController(con);  
        
        ext2.fileBody=Blob.valueOf('bodyBlob2');
        ext2.fileName='BodyBlob2';
        ext2.processUpload();
        ext2.groupType = 'Users';
        ext2.selectedValue = optnId1;
        ext2.valuepresent=optnId1;
        ext2.keyword='fname';
        ext2.back();
        ext2.getallOptions();
        ext2.NEXT();
        ext2.change();
        ext2.add();
        ext2.getSelected();
        ext2.remove();
        ext2.save();
        
    }
    
    static testMethod void TestAttachmentRole(){        
        case c = new case();
        c.subject = 'testPositive';
        c.Shipment_number__c = '123';
        insert c;
        List<UserRole> lr = [Select Id, Name  from UserRole where Name='My Role'];
        
        List<String> optnId1= new List<String>();
        for(UserRole u: lr)
        {
            optnId1.add(u.Id);
        }
        PageReference pageRef = Page.CaseNewCustomAttachFile;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con= new ApexPages.StandardController(c);
        
        AttachmentUploadController ext1= new AttachmentUploadController(con); 
        
        ext1.fileBody=Blob.valueOf('bodyBlob1');
        ext1.fileName='BodyBlob1';
        ext1.processUpload();
        ext1.groupType = 'Roles';
        ext1.selectedValue= optnId1;
        ext1.valuepresent=optnId1;
        ext1.keyword='Role';
        ext1.back();
        ext1.getallOptions();
        ext1.NEXT();
        ext1.change();
        ext1.add();
        ext1.getSelected();
        ext1.remove();
        ext1.save();
        
    }
}