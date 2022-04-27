//Author - Rajeev S


@IsTest

private class zzz_SendCaseAttachmentsController
{
    static SendCaseAttachmentsController ext;
    static List<SendCaseAttachmentsController.wrapEmailsToShow> wrapemails;

    //***Test method for "SendCaseAttachmentsController" class.
    static testMethod void UnitTest() {

        wrapemails= new List<SendCaseAttachmentsController.wrapEmailsToShow>();
        Case cases = new Case(Subject = 'Test',Description = 'Test');
        environment_settings__c esc = new environment_settings__c(Name='default_email_size',value__c='10000000');
        
        Test.startTest();
        
        insert cases;
        
        System.assertNotEquals(cases.Id, null);
        
        insert esc;
        
        System.assertEquals(esc.Name, 'default_email_size');
        System.assertEquals(esc.Value__C, '10000000');
        System.assertNotEquals(esc.Id, null);
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cases.id;
        insert attach;
        
        wrapEmails.add(new SendCaseAttachmentsController.wrapEmailsToShow('abc@gmail.com',0));
        
        System.assertNotEquals(attach.Id, null);
        List<Attachment> attachments=[select Id, name from Attachment where parent.id=:cases.id];
        
        System.assertEquals(1, attachments.size());
        
        Test.setCurrentPage(Page.ForwardCaseAttachments);
        
        Test.stopTest();
        
        ApexPages.StandardController con = new ApexPages.StandardController(cases);
         ext = new SendCaseAttachmentsController(con);
          ApexPages.CurrentPage().getParameters().put('rowToBeDeleted','0');
            ext.emails = 'abc@gmail.com,asd@scdf.com';
            ext.counter = 0;
            ext.addEmails();
            ext.removeEmails();
            ext.sendEmailsToAddresses();
            ext.formatEmailBody('test mail');
            ext.isUserEmailValid('abc@123.com');
            System.assert(ext.isUserEmailValid('abc@123.com'));
            System.assertNotEquals(ext.isUserEmailValid('123'),true);
            ext.isUserEmailValid('123');
            ext.getAttachmentSize();
            ext.goBackToCaseRecord();
            ext.sendPageMessage(ApexPages.Severity.CONFIRM,'Testing');
            ext.createEmailAttachments(new List<Attachment>{attach});
            ext.addAttachmentsToThisCase();
            System.assertEquals(ext.renderPageBlockTable,true);
            System.assertEquals(ext.renderPageBlockAttachmentsTable,true);
            ApexPages.currentPage().getParameters().put('AttId',attach.Id);
            ApexPages.currentPage().getParameters().put('checkValue','true');
            ext.calculateAttachmentSize();
         }
    
    
    //***Test method for "KATS_ConversionUtility" class.     
    static testMethod void KATS_ConversionUtilityMethod() {
           Double d = 10;
           KATS_ConversionUtility.ToString(1);
           KATS_ConversionUtility.ToString(d);
           System.AssertEquals(KATS_ConversionUtility.ToString(true),'true');
           System.AssertEquals(KATS_ConversionUtility.ToString(false),'false');
           KATS_ConversionUtility.ToString(123);
           KATS_ConversionUtility.ToString(System.today());
           KATS_ConversionUtility.ToString(System.today(),'h:mm a');
           KATS_ConversionUtility.ToString(System.now());
           KATS_ConversionUtility.ToString(System.now(),'h:mm a');
           KATS_ConversionUtility.ToString(Time.newInstance(1, 2, 3, 4));
           KATS_ConversionUtility.ToString(Time.newInstance(1, 2, 3, 4),'h:mm a');
           KATS_ConversionUtility.ToString(12.12);
           KATS_ConversionUtility.ToString(12.12,true);
           KATS_ConversionUtility.ToString(12.12,false);
           System.AssertEquals(KATS_ConversionUtility.FileSizeToString(100),'100 Bytes');
           //System.AssertEquals(KATS_ConversionUtility.FileSizeToString(1025),'1 KB');
           //System.AssertEquals(KATS_ConversionUtility.FileSizeToString(1024*1024*10),'10 MB');
           //System.AssertEquals(KATS_ConversionUtility.FileSizeToString(1024*1024*1024),'1 GB');
           //System.AssertEquals(KATS_ConversionUtility.FileSizeToString(null),'0 Bytes');
           //System.AssertEquals(KATS_ConversionUtility.CurrencyToString(12.12,'Pound'),'Pound12.12');
         } 
}