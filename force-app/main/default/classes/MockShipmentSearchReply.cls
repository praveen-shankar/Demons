@isTest
public class MockShipmentSearchReply{
    public list<postenNoEconnectKatsSearchshipment.TShipmentUnit> testing(){
        
         list<postenNoEconnectKatsSearchshipment.TShipmentUnit> reply = new list<postenNoEconnectKatsSearchshipment.TShipmentUnit>();
        reply.add(new postenNoEconnectKatsSearchshipment.TShipmentUnit());
        reply.get(0).ShipmentUnitID = 'TestShipmentUnitId';
        reply.get(0).ShipUnitSequenceID = 'TestShipUnitSequenceID';
        reply.get(0).ShipmentDateTime = system.now();
        reply.get(0).ValueAddedService = true;
        reply.get(0).LoadingWeightMeasure = 12.12;
        reply.get(0).Product = 'TestProduct';
        reply.get(0).NameSender = 'TestNameSender';
        reply.get(0).NameRecipient = 'TestNameRecipient';
        reply.get(0).ShipToStreetAddress = 'TestShipToStreetAddress';
        reply.get(0).PostalCode = '0000';
        reply.get(0).City = 'TestCity';
        
        reply.add(new postenNoEconnectKatsSearchshipment.TShipmentUnit());
        reply.get(1).ShipmentUnitID = 'TestShipmentUnitId2';
        reply.get(1).ShipUnitSequenceID = 'TestShipUnitSequenceID2';
        reply.get(1).ShipmentDateTime = system.now();
        reply.get(1).ValueAddedService = true;
        reply.get(1).LoadingWeightMeasure = 12.12;
        reply.get(1).Product = 'TestService_Product__c';
        reply.get(1).NameSender = 'TestNameSender2';
        reply.get(1).NameRecipient = 'TestNameRecipient2';
        reply.get(1).ShipToStreetAddress = 'TestShipToStreetAddress2';
        reply.get(1).PostalCode = '0001';
        reply.get(1).City = 'TestCity2';
        
        
        return reply;

        
    }

}