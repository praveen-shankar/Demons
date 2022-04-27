public with sharing class Case_shipmentEventEmailTemplate {
    
    public String caseId{ get; set; }
    public String caseNumber{ get; set; }
    public String eventCode { get; set; }
    public String eventType {get; set; }
    public String query { get; set; }
    public String event;
    
    public String getEvent() {
        try {
            if(caseNumber != '') { caseId = [SELECT id FROM Case WHERE CaseNumber = :caseNumber LIMIT 1].id; }
            query = 'SELECT name, date__c, EventCode__c, ReceivedBy__c, PostalUnit__r.unit_name__c FROM LM_Shipment_Event__c WHERE case__c =\'' + caseId + '\' AND EventCode__c LIKE \'' + eventCode + '%\' LIMIT 1';
            
            if(eventType != null && eventType != '') {
                String value = '';
                List<LM_Shipment_Event__c> events = Database.query(query);
                if(eventType.toUpperCase() == 'NAVN') { value = events.get(0).name; }
                if(eventType.toUpperCase() == 'DATO') { value = events.get(0).date__c.format('dd.MM.yyyy'); }
                if(eventType.toUpperCase() == 'DATO_KLOKESLETT') { value = events.get(0).date__c.format('dd.MM.yyyy - HH:mm '); }
                if(eventType.toUpperCase() == 'MOTTATT_AV') { value = events.get(0).ReceivedBy__c; }
                if(eventType.toUpperCase() == 'POSTAL_ENHET') { value = events.get(0).PostalUnit__r.unit_name__c; }
                if(eventType.toUpperCase() == 'HENDELSES_KODE') { value = events.get(0).EventCode__c; }
                if(value == null || value == ''){ return ' -'; }
                
                return ' ' + value;
            }
        }catch(Exception e) {
            
        }
        return '-';
    }
    
    static testMethod void testCoverage() {
        //KatsTestUtilities ktu = new KatsTestUtilities();
        
        Case c = new Case();
        insert c;
        PostalUnit__c pu = new PostalUnit__c(Name = 'Test Enhet', unit_name__c = 'Test Enhet', unit_number__c = '000', DRM_id__c = system.now() + '');
        insert pu;
        LM_Shipment_Event__c se = new LM_Shipment_Event__c();
        se.name = 'Event name';
        se.date__c = system.now();
        se.ReceivedBy__c = 'testTestesen';
        se.PostalUnit__c = pu.id;
        se.eventCode__c = 'AAA';
        
        insert se;
        
        Case_shipmentEventEmailTemplate seet = new Case_shipmentEventEmailTemplate();
        c=[SELECT id, casenumber from case WHERE id=:c.id];
        seet.caseNumber = c.caseNumber;
        system.assertNotEquals(seet.caseNumber,'');
        system.assertNotEquals(seet.caseNumber,null);
        seet.eventCode = se.eventCode__c;
        
        seet.eventType='NAVN';
        seet.eventType='Dato';
        seet.eventType='DATO_KLOKESLETT';
        seet.eventType='MOTTATT_AV';
        seet.eventType='POSTAL_ENHET';
         seet.eventType='HENDELSES_KODE';
        seet.getEvent();
    }

}