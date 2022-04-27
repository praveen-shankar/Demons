@isTest
public class cs_UpdateAttachmentDescription_BatchTest {

    public static Attachment createAttachments(String attName, Id attParentId, Id attCreatedById){
        Attachment a = New Attachment(name = attName,
                                      body = blob.valueof('attachment body'),
                                      parentId = attParentId,
                                      createdById = attCreatedById
                                      );
        List<Attachment> attList = New List <Attachment>();
        return a;
    }
    
    static testmethod void testscenarios(){
        Case c = New Case();
        c.Subject = 'Test case';
        c.origin = 'Mybring';
        c.Description = 'Test case for attachment';
        insert c;
        
        list<case> caseList = [select id from Case];
        list<Attachment> attList = New List<Attachment>();

        EmailMessage e = New EmailMessage();
        e.fromAddress = 'Test@mail.com';
        e.Subject = 'Test email';
        e.parentId = caseList[0].Id;
        insert e;
        List<EmailMessage> emailList = [Select id from EmailMessage];
      
        List<Attachment>  AttachList = New List<Attachment>();
        AttachList.add(createAttachments('test attachment1',caseList[0].id,'005w000000724XWAAY'));
        AttachList.add(createAttachments('test attachment2',caseList[0].id,null));
        AttachList.add(createAttachments('test attachment3',emailList[0].id,'005w000000724XWAAY'));
        AttachList.add(createAttachments('test attachment4',emailList[0].id,null));
        insert AttachList;
        
        Test.startTest();
        cs_UpdateAttachmentDescription_Batch btch = new cs_UpdateAttachmentDescription_Batch();
        Id batchId = Database.executeBatch(btch);
        Test.stopTest();
        system.assertEquals(null,[Select description from attachment where name = 'test attachment1'].Description);
        system.assertEquals('Internal',[Select description from attachment where name = 'test attachment2'].Description); 
        system.assertEquals(null,[Select description from attachment where name = 'test attachment3'].Description); 
        system.assertEquals(null,[Select description from attachment where name = 'test attachment4'].Description); 
        }
}