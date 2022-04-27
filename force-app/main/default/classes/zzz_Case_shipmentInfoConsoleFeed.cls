@isTest
private class zzz_Case_shipmentInfoConsoleFeed {

    static testMethod void coverageTest() 
    {
        
        User u = [Select Id from User Where Alias = 'aadmi'];
        System.runAs(u){
        List<Case> case_Lst = new List<Case>();

        Case c1 = new Case();
        c1.Shipment_number__c = '123456';
        case_Lst.add(c1);
        
        Case c2 = new Case();
        c2.Shipment_identification__c = '123456789';
        case_Lst.add(c2);
        
        Case c3 = new Case();
        c3.Shipment_identification__c = '';
        c3.Shipment_number__c = '';
        case_Lst.add(c3);

        Case c4 = new Case();
        c4.Shipment_identification__c = '0';
        c4.Shipment_number__c = '';
        case_Lst.add(c4);

        Database.insert(case_Lst);

        Case_shipmentInfoConsoleFeed csi1 = new Case_shipmentInfoConsoleFeed(new ApexPages.StandardController(c1));
        csi1.requestData();
        csi1.getHasEconnectData();
        csi1.requestShipment();
        csi1.persistShipmentReciever();
        csi1.persistShipmentSender();
        
        Case_shipmentInfoConsoleFeed csi2 = new Case_shipmentInfoConsoleFeed(new ApexPages.StandardController(c2));
        csi2.requestData();
        csi2.getHasEconnectData();
        
        Case_shipmentInfoConsoleFeed csi3 = new Case_shipmentInfoConsoleFeed(new ApexPages.StandardController(c3));
        csi3.requestData();
        csi3.getHasEconnectData();
        csi3.persistShipment();

        Case_shipmentInfoConsoleFeed csi4 = new Case_shipmentInfoConsoleFeed(new ApexPages.StandardController(c4));
        csi4.requestShipment();        
        
        Boolean result= csi3.getShowShipmentOverview();
        }
    }
}