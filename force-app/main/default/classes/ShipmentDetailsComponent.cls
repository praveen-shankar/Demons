public with sharing class ShipmentDetailsComponent {

    Transient EConnectWrapper_GetShipmentData wrapper;
    public String ShipmentUnitIDnew {get; set;}
    public String ShipmentUnitID {get; set;}
    
    public void setWrapper(EConnectWrapper_GetShipmentData wrapper) { this.wrapper = wrapper;   }
    public EConnectWrapper_GetShipmentData getWrapper() {   return this.wrapper;    }
    
    public EConnectWrapper_GetShipmentData.ShipmentUnitType getShipment() { 
        if(getHasEconnectData()) 
            return wrapper.shipmentUnitType;      return null;
    }
    
    public boolean getHasEconnectData() {
        if(wrapper != null) {            return true;      }
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Found_no_sendings_data);
        return false;
    }



}