@isTest
public class zzz_MyBringCaseCommentsController {
    @TestSetup
    //@isTest(seeAllData=true)
	 private static void setupData() {
         case c = new case();
         c.subject = 'testPositive';
         c.Shipment_number__c = '123';
         insert c;
         
         EmailMessage msg1 = new EmailMessage();
         msg1.ParentId = c.Id;
         msg1.CreatedDate = Date.today();
         msg1.TextBody = 'test body';
         msg1.Subject = 'test subject';
         msg1.FromAddress = 'abc@gamil.com';
         insert msg1;
         
         case c1 = new case();
         c1.subject = 'testNegative';
         c1.Shipment_number__c = '567';
         insert c1;
         
         EmailMessage msg2 = new EmailMessage();
         msg2.ParentId = c.Id;
         msg2.CreatedDate = Date.today();
         msg2.TextBody = 'hg';
         msg2.Subject = '';
         msg2.FromAddress = '';
         insert msg2;
        
     }
	 
	 private static testMethod void positiveTest(){
	 
		case c = [select id from case where subject = 'testPositive'];
		PageReference pageRef = Page.MyBring_Case_Comments;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('caseid', String.valueOf(c.Id));
		MyBring_Conversation__c myBringConv = new MyBring_Conversation__c();
		myBringConv.case__c = c.id;
		
		
		ApexPages.StandardController st = new ApexPages.StandardController(myBringConv);
        MyBringCaseCommentsController controller = new MyBringCaseCommentsController(st);
        Map<String, CaseCommentTemplates__c> templates= CaseCommentTemplates__c.getAll();
        /*Set<String> toBeUpdatedIds = new Set<String>();
        toBeUpdatedIds = templates.keySet();*/
        controller.templatelist = 'endre_avsender';
        controller.getCountriesSelectList();
        controller.TemplateLists();
        controller.save1();
        controller.SaveandNew();
        controller.cancel();
	 }
    
     private static testMethod void negativeTest(){
	 
		case c = [select id,subject from case where subject = 'testNegative'];
		PageReference pageRef = Page.MyBring_Case_Comments;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('caseid', String.valueOf(c.Id));
		MyBring_Conversation__c myBringConv = new MyBring_Conversation__c();
		myBringConv.case__c = c.id;
		
		
		ApexPages.StandardController st = new ApexPages.StandardController(myBringConv);
        MyBringCaseCommentsController controller = new MyBringCaseCommentsController(st);
        controller.templatelist = 'Fellesmal_for_Signatur_og_historie_epost1';
        controller.getCountriesSelectList();
        controller.TemplateLists();
        controller.save();
        //controller.SaveandNew();
        controller.cancel();
	 }
}