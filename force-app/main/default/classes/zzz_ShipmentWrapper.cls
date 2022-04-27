@isTest
public class zzz_ShipmentWrapper
{
    private static testMethod void testCreateShipmentWrapper()
    {
        postenNoEconnectKatsSearchshipment.TShipmentUnit eConnectRow = new postenNoEconnectKatsSearchshipment.TShipmentUnit();
        eConnectRow.ShipmentUnitID = '12345';
        eConnectRow.ShipUnitSequenceID = '23456';
        eConnectRow.ShipmentDateTime = DateTime.Now();
        eConnectRow.ValueAddedService = false;
        eConnectRow.LoadingWeightMeasure = 10.01;
        eConnectRow.Product = 'Test Product';
        eConnectRow.NameSender = 'Test NameSender';
        eConnectRow.NameRecipient = 'Test NameRecipient';
        eConnectRow.ShipToStreetAddress = 'Test ShipToStreetAddress';
        eConnectRow.PostalCode = '0210';
        eConnectRow.City = 'Oslo';

        postenNoEconnectKatsGetshipment.ShipmentUnitType eConnectResponse = new postenNoEconnectKatsGetshipment.ShipmentUnitType();
        eConnectResponse.RecipientReference = 'REF999999';
        eConnectResponse.SenderReference = 'SEN8989989';
        eConnectResponse.ShipmentID = '12345';

        EConnectWrapper_GetShipmentData wrapper = new EConnectWrapper_GetShipmentData(eConnectResponse);
        
        test.startTest();
        
        ShipmentWrapper sw1 = new ShipmentWrapper(eConnectRow, wrapper);
        String receiverReference = sw1.receiverReference;
        String senderReference = sw1.senderReference;
        String shipmentNumber = sw1.shipmentNumber;

        String ShipmentUnitID = sw1.ShipmentUnitID;
        String ShipUnitSequenceID = sw1.ShipUnitSequenceID;
        DateTime ShipmentDateTime = sw1.ShipmentDateTime;
        Boolean ValueAddedService = sw1.ValueAddedService;
        String LoadingWeightMeasure = sw1.LoadingWeightMeasure + '&nbsp;gram';
        String Product = sw1.Product;
        String NameSender = sw1.NameSender;
        String NameRecipient = sw1.NameRecipient;
        String ShipToStreetAddress = sw1.ShipToStreetAddress;
        String PostalCode = sw1.PostalCode;
        String City = sw1.City;
       

        test.stopTest();
    }
    


}