public with sharing class ShipmentWrapper {
	
	private postenNoEconnectKatsSearchshipment.TShipmentUnit eConnectRow { get; set; }
	public EConnectWrapper_GetShipmentData wrapper {get; set;}
	
	public String receiverReference {get{ return wrapper != null ? wrapper.shipmentUnitType.RecipientReference : '';}}
	public String senderReference {get{ return wrapper != null ? wrapper.shipmentUnitType.SenderReference : '';}}
	public String shipmentNumber {get{ return wrapper != null ? wrapper.shipmentUnitType.ShipmentID : '';}}
        

    public String ShipmentUnitID { get{ return eConnectRow.ShipmentUnitID; } }
    public String ShipUnitSequenceID { get{ return eConnectRow.ShipUnitSequenceID; } }
    public DateTime ShipmentDateTime { get{ return eConnectRow.ShipmentDateTime; } }
    public Boolean ValueAddedService { get{ return eConnectRow.ValueAddedService; } }
    public String LoadingWeightMeasure { get{ return eConnectRow.LoadingWeightMeasure + '&nbsp;gram'; } }
    public String Product { get{ return eConnectRow.Product; } }
    public String NameSender { get{ return eConnectRow.NameSender; } }
    public String NameRecipient { get{ return eConnectRow.NameRecipient; } } 
    public String ShipToStreetAddress { get{ return eConnectRow.ShipToStreetAddress; } }
    public String PostalCode { get{ return eConnectRow.PostalCode; } }
    public String City { get{ return eConnectRow.City; } }
   
    /* Constructor for eConnect search results */
    public ShipmentWrapper(postenNoEconnectKatsSearchshipment.TShipmentUnit eConnectRow, EConnectWrapper_GetShipmentData wrapper) {
        this.eConnectRow = eConnectRow;
        this.wrapper = wrapper;
    } 

}