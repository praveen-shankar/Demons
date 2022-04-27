// CS-Phase2- 03/01/2017- Akshata Asukar-Replaced all occurances of Account.party_number__c with Account.crm_customer_number__c
@isTest(SeeAllData=true) 
private class zzz_InvoiceTests {

    static testMethod void insertInvoiceTest() {
        
        Account a = new Account(Name = 'testKunde', crm_customer_number__c = 'BLNOC12345678');
         Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
         a.recordtypeid=Recordtypeid;
        insert a;
        Case c = new Case(AccountId = a.Id);
        insert c;
        PostalUnit__c p = new PostalUnit__c(Name = 'enhetTEST',unit_number__c ='enhet1234', DRM_id__c = '1234.5678.9012', unit_number_in_subsidiary__c = 'datter1234');
        insert p;
        Invoice__c iBefore = new Invoice__c(Name = String.valueOf(math.random()), Type__c = 'Paller', unit__c = p.id, exclude_reminder__c = true, case__c = c.id);
       //Csphase2 Supriya 29122016
       // Invoice__c iBefore = new Invoice__c(Name = String.valueOf(math.random()), Type__c = 'Pallets', unit__c = p.id, exclude_reminder__c = true, case__c = c.id);
        Test.startTest();
        insert iBefore;
        Test.stopTest();
        Invoice__c iAfter = [SELECT id, exclude_reminder__c, status__c FROM Invoice__c WHERE id =: iBefore.id];
        
        System.assert(iBefore.exclude_reminder__c = iAfter.exclude_reminder__c);
        // Dinesh , commented line no. 25
       // System.assertEquals('Vellykket - purrestopp opprettet', iAfter.status__c);
       //Csphase2 supriya 29122016
        System.assertEquals('Successful - dunning stop created', iAfter.status__c);
        

    }
    
    static testMethod void uppdateManyInvoiceTest() {
        
        List<Invoice__c> iListToInsert = new List<Invoice__c>();
          Id RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.crm_relation_level_customer).getRecordTypeId();
        Account a = new Account(Name = 'testKunde', crm_customer_number__c = 'BLNOC12345678');
        a.recordtypeid= recordtypeid;
        insert a;
        Case c = new Case(AccountId = a.Id);
        insert c;
        PostalUnit__c p = new PostalUnit__c(Name = 'enhetTEST',unit_number__c ='enhet1234', DRM_id__c = '1234.5678.9012', unit_number_in_subsidiary__c = 'datter1234');
        insert p;
        
        for(Integer i = 0; i<5; i++) {
            //Invoice__c iToInsert = new Invoice__c(Name = String.valueOf(math.random()+i), Type__c = 'Paller', unit__c = p.id, exclude_reminder__c = true, case__c = c.id);
            //Csphase2 Supriya 29122016
             Invoice__c iToInsert = new Invoice__c(Name = String.valueOf(math.random()+i), Type__c = 'Pallets', unit__c = p.id, exclude_reminder__c = true, case__c = c.id);
            iListToInsert.add(iToInsert);
        }
        
        Test.startTest();
        insert iListToInsert;
        
        List<Invoice__c> iListToUpdate = new List<Invoice__c>();
        for(Invoice__c i : iListToInsert) {
            i.exclude_reminder__c = false;
            iListToUpdate.add(i);
        }
        
        upsert iListToUpdate;
        Test.stopTest();
        
        List<Invoice__c> iListAfter = [SELECT id, exclude_reminder__c, status__c FROM Invoice__c WHERE id IN :iListToUpdate];
        
        for(Invoice__c i : iListAfter) {
            System.assert(!i.exclude_reminder__c);
            //System.assertEquals('Vellykket - purrestopp opphevet', i.status__c);
            //Csphase2 supriya 29122016
            System.assertEquals('Successful - dunning repealed', i.status__c);
        }
        
        
    }
}