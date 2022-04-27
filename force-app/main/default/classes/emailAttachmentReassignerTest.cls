@isTest
public class emailAttachmentReassignerTest {
		static testmethod void attachmentTester() {
			Attachment a = new Attachment();
			Case c = new Case();
			upsert c;
			
			EmailMessage email= new EmailMessage(ParentId = c.id);
			upsert email;
			a.name = 'test attachment';
			a.body = blob.valueof('attachment body');
			a.parentid = [select id from EmailMessage limit 1].id;
			
			insert a;	
			
			delete a;
		}	
	}