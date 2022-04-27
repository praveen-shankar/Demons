public with sharing class ShipmentUnitIDHolder {
	
	public string ShipmentNumber {get; private set;}
	
	public List<ShipmentWrapper> shipmentUnitList {get; private set;}
	
	public ShipmentUnitIDHolder(String shipmentNumber, List<ShipmentWrapper> shipmentUnitList){
		this.ShipmentNumber = shipmentNumber;
		this.shipmentUnitList = new List<ShipmentWrapper>();
		this.shipmentUnitList.addAll(shipmentUnitList);
	}
}