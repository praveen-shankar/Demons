@isTest
public class ShipmentOverviewComponent_newTest {
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

        List<ShipmentWrapper> shipmentListNew = new List<ShipmentWrapper>();
        shipmentListNew.add(sr1);
      
        String recordIdBusiness=KATSutilities.getRecordType('business_account');
        Account a1=new Account( crm_customer_number__c='12345676', Name='Bedrift AS', RecordTypeId=recordIdBusiness, Phone='99009900');
       insert a1;
      
        Case c1=new Case(subject='Account is set', accountId=a1.id, description = 'test', SuppliedEmail='SuppliedEmail@test.com');
        insert c1;
      
    test.startTest();
    ShipmentOverviewComponent_new soc1 = new ShipmentOverviewComponent_new();
    soc1.setIsSearchView(true);
    soc1.getIsSearchView();
    soc1.currentcase = c1;  
    soc1.selected = 1;

    // This is a fail test
    soc1.getSelectedShipmentByID();

    soc1.currentShipmentUnitID = '1234444';

    // This is a fail test
    soc1.getShipmentSummary();

    soc1.getHasShipments();
    
    soc1.setShipmentListNew(shipmentListNew);
    soc1.getShipmentListNew();

    soc1.showShipmentDetails();

    soc1.getShipmentSummary();
    
      test.stopTest();
  }

}