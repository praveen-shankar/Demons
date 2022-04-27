@isTest
public class zzz_UndeliverableBeforeUpdate{

static testMethod void testUndeliverableShipment1()
{


Code_Event__c ce = new Code_Event__c(Name='Test Category');
upsert ce;
Code_Reason1__c re1 = new Code_Reason1__c(Name='Test Årsak1');
upsert re1;
Service_Product__c p=new Service_Product__c(Name='MyTestProduct'); /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
upsert p;

Case c =new Case();
c.RecordTypeId = KATSutilities.getRecordType('complaint');
c.external_description__c ='TEST tester testar testen'; 
c.content_description__c = 'TEST tester testar testen';
c.Code_Event__c=ce.id;
c.Code_Reason1__c=re1.id;
c.Category__c='Ingen kategori';
c.Produkt__c='Ingen produkt';
c.reason__c='Adresseendring opphørt';
c.Service_Product__c=p.id; /*Added as a part of P3CRM-Sales project. Removing reference from standard Product Object to custom Service Product object. Change by Rajesh on 12th July 2016 */
upsert c;

UndeliverableShipment__c us = getUndeliverable();
us.Type__c='Brev';
upsert us;
us.Type__c='Pakke';
upsert us;
us.Type__c='Rekommandert brev';
upsert us;
us.status__c='Sendt til kunde';
us.Case__c=c.id;
upsert us;

}

 static UndeliverableShipment__c getUndeliverable() {
        UndeliverableShipment__c undeliverable = new UndeliverableShipment__c(
            Shipment_identification__c = '0000TEST',
            Shipment_number__c = '00000',
            interiorDescription__c = 'Test tester',
            outerDescription__c = 'Test tester',
            Funnet__c = 'TEST funnet',
            status__c = 'Uidentifisert'
        );
        upsert undeliverable;

        undeliverable = [SELECT id,
            name,
            Shipment_identification__c,
            Shipment_number__c,
            outerDescription__c,
            interiorDescription__c,
            Funnet__c,
            status__c,
            recordtypeId
            FROM UndeliverableShipment__c WHERE id =:undeliverable.id LIMIT 1];
            
        return undeliverable;
    }





}