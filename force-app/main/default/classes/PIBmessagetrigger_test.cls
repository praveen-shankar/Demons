@isTest
public class PIBmessagetrigger_test {
    
     static TestMethod void testMyCustomers()
      {
       User u = crm_TestDataFactory.createUser();
       insert u;
        System.runAs(u) {                     
        
       
        PostalUnit__c p = new PostalUnit__c();
        p.Name = 'test Post 12345';
        p.DRM_id__c = 'test12334455577';
        p.unit_number__c='1233';
        insert p;
        
        Pickup_area__c pickup = new Pickup_area__c ();
        pickup.Name =  'test 122233344';
        pickup.postal_unit__c = p.id;
        insert pickup;
        
        Case test1 = new Case();
        test1.subject = 'Test 1';
        test1.origin = 'Manuelt';
        
        test1.unit_to_blame__c = p.id;
        test1.pickup_area__c= pickup.id ;
        Database.insert(test1);
        
        cs_case_pib_messages__c pib = new cs_case_pib_messages__c();
        pib.cs_subject__c='test message';
        pib.cs_pib_case__c=test1.id;
        database.insert(pib);
        }
      }

}