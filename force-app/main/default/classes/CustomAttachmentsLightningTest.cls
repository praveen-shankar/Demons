@isTest
public class CustomAttachmentsLightningTest {

     @TestSetup
    //@isTest(seeAllData=true)
    private static void setupData() {
        
          case c = new case();
        c.subject = 'testPositive';
        c.Shipment_number__c = '123';
        insert c;
        
        user u =crm_TestDataFactory.createUser(); 
        u.firstname='fname';
        u.LastName='lname';
        insert u; 
        
        Case_Attachment__c cattach= new Case_Attachment__c();
        cattach.Case__c = c.Id;
        cattach.Name='C001';
        insert cattach;
        
        Custom_Attachment_Details__c attachDetails = new Custom_Attachment_Details__c();
        attachDetails.Attachment__c=cattach.Id;
        attachDetails.Case_Number__c=c.Id;
        attachDetails.Selected_Users__c=u.Id;
        
        insert attachDetails;
    }
    static testMethod void TestAttachment(){
        Case cs=[Select Id from case where subject='testPositive'];
       User ur=[Select Id,name,firstname from user where firstname='fname'];
        Custom_Attachment_Details__c cad=[Select Id from Custom_Attachment_Details__c where Case_Number__c=:cs.Id];
        System.runAs(ur){
        Test.startTest();
       // CustomAttachmentsLightning ca = new CustomAttachmentsLightning();
        CustomAttachmentsLightning.getcaseAttachments(cs.Id);
        CustomAttachmentsLightning.deleterecord(cad.Id);
        Test.stopTest();
        }
    }
}