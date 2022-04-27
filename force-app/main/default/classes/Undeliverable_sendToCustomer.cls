public with sharing class Undeliverable_sendToCustomer {
    
    UndeliverableShipment__c undeliverable;
    PageReference pageRef;
    
    public Undeliverable_sendToCustomer(ApexPages.StandardController controller) {
        this.undeliverable = (UndeliverableShipment__c)controller.getRecord();
        undeliverable = [select id,status__c, Dato_Avsluttet__c from UndeliverableShipment__c where id =:undeliverable.id];
    }
    
    public PageReference loadData(){
        undeliverable.status__c = System.Label.cs_Senttocustomer;
        undeliverable.Dato_Avsluttet__c = dateTime.now().date();
        
        upsert undeliverable;
        if(undeliverable != null){
            pageRef = new PageReference('/'+getUndeliverableId());        
            pageRef.setRedirect(true);
        }
        
        return pageRef;
    }
    public String getUndeliverableId(){
        String ret = '';
        if(undeliverable != null){
            ret = undeliverable.id;
        }
        return ret;
    }

}