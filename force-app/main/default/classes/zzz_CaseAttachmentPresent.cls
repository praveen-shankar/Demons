@isTest
public class zzz_CaseAttachmentPresent {

    static testmethod void CaseAttachmentTest1() {
        Attachment a = new Attachment();
        Case c = new Case();
        c.origin = 'Mybring';
        c.Receive_case_update_for_Mybring_cases__c = true;
        c.has_Attachment__c  = false;
        insert c;

        Case c1 = new Case();
        c1.origin = 'Mybring';
        c1.Receive_case_update_for_Mybring_cases__c = true;
        c1.has_Attachment__c  = true;
        insert c1;
        
        
        Case c2 = new Case();
        c2.origin = 'Mybring';
        c2.Receive_case_update_for_Mybring_cases__c = true;
        c2.has_Attachment__c  = true;
        insert c2;
        
        
        list<case> caseList = [select id from Case];
        a.name = 'test attachment';
        a.body = blob.valueof('attachment body');
        a.parentid = caseList[0].id;

        insert a;
        delete a;
        
        Attachment a2 = new Attachment();
        a2.name = 'test attachment';
        a2.body = blob.valueof('attachment body');
        a2.parentid = caseList[1].id;
        
        insert a2;
        delete a2;
        
        set<Id> caseIds = New set<Id>();
        caseIds.add(caseList[2].Id);
        caseAttachmentPresentHelper.updateCaseWhichdoNothaveAttach(caseIds);
		
    }
    
    public static Attachment createAttachments(String attName, Id attParentId, Id attCreatedById){
        Attachment a = New Attachment(name = attName,
                                      body = blob.valueof('attachment body'),
                                      parentId = attParentId,
                                      createdById = attCreatedById
                                      );
        
        List<Attachment> attList = New List <Attachment>();
        return a;
    }
    
    static testmethod void testUpdateAttDescription(){
        
        Case c = New Case();
        c.Subject = 'Test Case';
        c.Description = 'Test case for attachment';
        c.origin = 'Mybring';
        c.Receive_case_update_for_Mybring_cases__c = true;
        insert c;
        
        list<case> caseList = [select id from Case];

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
        
        List<Id> attId = New List<Id>();
        for(Attachment a : [Select Id from Attachment]){
            attId.add(a.Id);
        }
        
        Test.startTest();
        CaseAttachmentPresentHelper.addAttachmentDescription(attId);
        Test.stopTest();
        
        system.assertEquals(null,[Select description from attachment where name = 'test attachment1'].Description);
        system.assertEquals('Internal',[Select description from attachment where name = 'test attachment2'].Description); 
        system.assertEquals(null,[Select description from attachment where name = 'test attachment3'].Description); 
        system.assertEquals(null,[Select description from attachment where name = 'test attachment4'].Description); 
        }
}