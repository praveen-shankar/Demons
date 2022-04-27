@isTest
private class CS_duplicateShipmetParcelTest
{
  
     static testMethod void validate() {

 
   PageReference pageRef = Page.CS_duplicateShipmetParcel;
  
 test.startTest();
   Account testAccount = new Account(Name = 'Test OEBS Account',
                                    crm_customer_number__c = '12345678');
        
        upsert testAccount;
          Case testCase1 = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Shipment_number__c='1234',
                                Shipment_identification__c='4321',
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
       
        
    //    insert testCase1;  
    
   
        Case testCase2 = new Case(Origin = 'OEBS',
                                OEBS_order_number__c = '123456',
                                OEBS_order_URL__c = 'www.test.com',
                                OEBS_order_line_id__c = '12345',
                                OEBS_top_article__c = 'Test Produkt',
                                OEBS_contract_name__c = 'Kontrakt',
                                OEBS_contract_number__c = '123456',
                                OEBS_producer__c = testAccount.id,
                                Shipment_number__c='1234',
                                Shipment_identification__c='4321',
                                OEBS_Order_Status__c = '',
                                OEBS_order_release_reason__c = ''
        );
       
        
        insert testCase2;  
 
  Test.setCurrentPage(pageRef);
  // pageRef.getParameters().put('Id',testCase1.id);
   ApexPages.StandardController sc = new ApexPages.standardController(testCase2);
   CS_duplicateShipmetParcel  controller = new CS_duplicateShipmetParcel(sc);
 // System.assertNotEquals(null,controller.validate());
  controller.validate();
         CS_duplicateShipmetParcel.checkDuplicatenumbers(testCase2.Id);
          test.stopTest();  

  
}

}