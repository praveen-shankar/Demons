@isTest
private class zzz_Undeliverable_sendToCustomer {

    static testMethod void sendToCustomer() {
        //UndeliverableShipment__c un = new UndeliverableShipment__c(undeliverable_type__c='Løs gjenstand', status__c='Uidentifisert', outerDescription__c='Test');
        
        UndeliverableShipment__c un = new UndeliverableShipment__c(undeliverable_type__c='Loose Item', status__c='Unidentified', outerDescription__c='Test');
        

        //CSphase2 Supriya 29122016
        
        insert un;
        System.assertNotEquals(un,null);  
            
        Undeliverable_sendToCustomer ustc = new Undeliverable_sendToCustomer(new ApexPages.StandardController(un));
        UndeliverableShipment__c undeliverableBefore = [select u.id, u.status__c, u.Dato_Avsluttet__c from UndeliverableShipment__c u where u.id =:ustc.getUndeliverableId()];
        //System.assertEquals(undeliverableBefore.status__c,'Uidentifisert');
        System.assertEquals(undeliverableBefore.status__c,'Unidentified');
        //Csphase2 supriya 29122016
        System.assertEquals(undeliverableBefore.Dato_Avsluttet__c,null);

        ustc.loadData();
        UndeliverableShipment__c undeliverableAfter = [select u.id, u.status__c, u.Dato_Avsluttet__c from UndeliverableShipment__c u where u.id =:ustc.getUndeliverableId()];
        System.assertEquals(undeliverableBefore.Id,undeliverableAfter.Id);
        System.assertEquals(undeliverableAfter.status__c,'Sent to customer');
        
        //CSphase2 Supriya 29122016
       // System.assertEquals(undeliverableAfter.status__c,'Sent to customer');    
        System.assertNotEquals(undeliverableAfter.Dato_Avsluttet__c,null);
    }

}