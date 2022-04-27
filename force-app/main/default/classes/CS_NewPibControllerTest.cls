@isTest
private class CS_NewPibControllerTest{

private static testMethod void testTemplateLists() {
      
        
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
        
             PIBFolder_Setting__mdt folderid = [select FolderId__c from PIBFolder_Setting__mdt where DeveloperName like '%PIB_Meldinger%' limit 1];
        
        List<EmailTemplate> templist = [SELECT Name,Subject,TemplateType,Description,FolderId FROM EmailTemplate where FolderId = :folderid.FolderId__c];    
        
          Test.startTest();
          CS_NewPibController.loadtemplates();
          CS_NewPibController.getStatus();
          CS_NewPibController.loadCaseDetails(c.id);
          
          CS_NewPibController.loadTemplatedetails(c.id, templist[0].id);
          CS_NewPibController.addPIBfn(c.id,'test subj','body','true', 'New');
          Test.stopTest();
          }


}