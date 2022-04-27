@isTest
public class NewPibControllerTest {
    private static testMethod void testTemplateLists() {
        Test.startTest();
        
        PostalUnit__c postalUnit = new PostalUnit__c();
        postalUnit.city__c = 'Mumbai';
        postalUnit.Name = 'testPostalUnit';
        postalUnit.unit_number__c = '111111';
        insert postalUnit;
        
        Pickup_area__c pickupArea = new Pickup_area__c();
        pickupArea.Name = 'testC';
        pickupArea.postal_unit__c = postalUnit.Id;
        insert pickupArea;
        
        Case c = new Case();
        c.pickup_area__c = pickupArea.Id;
        c.unit_to_blame__c=postalUnit.Id;
        c.Shipment_identification__c = 'ab1';
        insert c;
        
        system.debug(' case '+ c);
        PageReference pageRef = Page.NewPib;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('caseid', String.valueOf(c.Id));
        cs_case_pib_messages__c pibobj = new cs_case_pib_messages__c();
        pibobj.cs_pib_case__c = c.Id;
        //pibobj.cs_subject__c='abc';
        //pibobj.cs_description__c='xyz';
        pibobj.category__c = 'New';
        //insert pibobj;
        system.debug('before controller');
    
       // List<test_setting__mdt> testSetting = [select folder_id__c from test_setting__mdt];
        PIBFolder_Setting__mdt folderid = [select FolderId__c from PIBFolder_Setting__mdt where DeveloperName like '%PIB_Meldinger%' limit 1];
        
        List<EmailTemplate> templist = [SELECT Name,Subject,TemplateType,Description,FolderId FROM EmailTemplate where FolderId = :folderid.FolderId__c];             
        
        ApexPages.StandardController st = new ApexPages.StandardController(pibobj);
        NewPibController pCon = new NewPibController(st);
        pCon.TemplateName = templist[0].Id;
        pCon.TemplateLists();
        pCon.save1();
        pCon.SaveandNew();
        system.debug('Main : '+ templist[0].Name);
        //pCon.TemplateName ='Send Email To Postal Unit';
        
        system.debug('After controller');
        Test.stopTest();
    
    }
    
    private static testMethod void negativeMethod(){
        Test.startTest();
        
        PostalUnit__c postalUnit = new PostalUnit__c();
        postalUnit.city__c = 'Mumbai';
        postalUnit.Name = 'testPostalUnit';
        postalUnit.unit_number__c = '2222';
        insert postalUnit;
        
        Pickup_area__c pickupArea = new Pickup_area__c();
        pickupArea.Name = 'testA';
        pickupArea.postal_unit__c = postalUnit.Id;
        insert pickupArea;
        
        Case c = new Case();
        c.pickup_area__c = pickupArea.Id;
        c.unit_to_blame__c=postalUnit.Id;
        c.Shipment_identification__c = 'ab2';
        insert c;
        
        system.debug(' case '+ c);
        PageReference pageRef = Page.NewPib;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('caseid', String.valueOf(c.Id));
        cs_case_pib_messages__c pibobj = new cs_case_pib_messages__c();
        pibobj.cs_pib_case__c = c.Id;
        pibobj.category__c = 'New';
        
        ApexPages.StandardController st = new ApexPages.StandardController(pibobj);
        NewPibController pCon = new NewPibController(st);
        pCon.TemplateName ='none';
        pCon.TemplateLists();
        pCon.getStatus();
        pCon.SaveandNew();
        pCon.cancel();
        
        Test.stopTest();

    }
}