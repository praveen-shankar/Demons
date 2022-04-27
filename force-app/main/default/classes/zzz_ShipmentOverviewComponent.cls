/**
 * Unit tests for Shipment overview component that sorts 
 * shipments and shipmentUnits together
 */
@isTest
private class zzz_ShipmentOverviewComponent
{
	@isTest
	static void test1_CallController() 
	{
		//Preparing data related to Shipment
		postenNoEconnectKatsSearchshipment.TShipmentUnit eConnectRow = new postenNoEconnectKatsSearchshipment.TShipmentUnit();
		eConnectRow.ShipmentUnitID = '1234444';
		eConnectRow.ShipUnitSequenceID = '11111111';
		eConnectRow.ShipmentDateTime = DateTime.now();
		eConnectRow.ValueAddedService = false;
		eConnectRow.LoadingWeightMeasure = 10.11;
		eConnectRow.Product = 'Test Product';
        eConnectRow.NameSender = 'Test Name Sender';
        eConnectRow.NameRecipient = 'Test Recipient';
        eConnectRow.ShipToStreetAddress = 'Test Address';
        eConnectRow.PostalCode = '0210';
        eConnectRow.City = 'Oslo';

        //Preparing data related to Shipment
        postenNoEconnectKatsGetshipment.ShipmentUnitType eConnectResponse = new postenNoEconnectKatsGetshipment.ShipmentUnitType();
        EConnectWrapper_GetShipmentData wrapper = new EConnectWrapper_GetShipmentData(eConnectResponse);
        

        ShipmentWrapper sr1 = new ShipmentWrapper(eConnectRow, wrapper);

        List<ShipmentWrapper> shipmentList = new List<ShipmentWrapper>();
        shipmentList.add(sr1);

		test.startTest();
		ShipmentOverviewComponent soc1 = new ShipmentOverviewComponent();
		soc1.setIsSearchView(true);
		soc1.getIsSearchView();
		soc1.selected = 1;

		// This is a fail test
		soc1.getSelectedShipmentByID();

		soc1.currentShipmentUnitID = '1234444';

		// This is a fail test
		soc1.getShipmentSummary();

		soc1.getHasShipments();
		
		soc1.setShipmentList(shipmentList);
		soc1.getShipmentList();

		soc1.showShipmentDetails();

		soc1.getShipmentSummary();
		
	    test.stopTest();
	}
}