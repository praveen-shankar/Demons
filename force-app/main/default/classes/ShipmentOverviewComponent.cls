public with sharing class ShipmentOverviewComponent {
    
    public Transient List<ShipmentWrapper> shipmentList; 
    public boolean isSearchView;
    public Map<String, ShipmentWrapper> shipmentMap {get; set;} 
    public List<ShipmentWrapper> backupShipmentList;
    
    //public MainSearchController mainSearchController {get; set;}
    
    public Integer selected {get; set;}
    public String currentShipmentUnitID {get; set;}
    public EConnectWrapper_GetShipmentData wrapper {get; private set;}
    
    
    public void setIsSearchView(boolean isSearchView) {this.isSearchView = isSearchView;}
    
    public boolean getIsSearchView(){ return this.isSearchView; }
    
    public void setShipmentList(List<ShipmentWrapper> shipmentList) {
            this.shipmentList = shipmentList; 
            populateShipmentMap(this.shipmentList); 
    }
        
    public List<ShipmentWrapper> getShipmentList() { return this.shipmentMap != null ? this.shipmentMap.values(): new List<ShipmentWrapper> (); }
        
    public void populateShipmentMap(List<ShipmentWrapper> shipmentList) {
        
        if (shipmentMap == null) {
            shipmentMap = new Map<string,ShipmentWrapper>();
        }
        if (shipmentList != null){
            for (ShipmentWrapper shipment : shipmentList) {
            	if (shipment.ShipmentUnitID != null) {
            		shipmentMap.put(shipment.ShipmentUnitID.trim(), shipment);
            	}
            }       
        }
    }
    
    public boolean getHasShipments(){
        return shipmentList != null || backupShipmentList != null;
    }
    
    public boolean displayShipmentDetailsPopup {get; set;}  
    
    public Pagereference showShipmentDetails() {        
        displayShipmentDetailsPopup = true;
        if (currentShipmentUnitID != null){
            this.wrapper = getSelectedShipmentByID();
        }
        return null;
    }
    
    public EConnectWrapper_GetShipmentData getSelectedShipmentByID() {

        if ((currentShipmentUnitID != null) && (shipmentMap.get(currentShipmentUnitID.trim()) != null)) {
            return shipmentMap.get(currentShipmentUnitID.trim()).wrapper;
        }       
        return null;    
    }
    
    public ShipmentWrapper getShipmentSummary() {
        if (shipmentMap != null){
            for (ShipmentWrapper w : shipmentMap.values()){
                return w;
            }
        }
        return new ShipmentWrapper(null, null);
    } 
    
    /**Wrapper methods  for calling mainpage controller if set*
    public void godoSenderShipmentcase() {
        /*if (mainSearchController != null){
            mainSearchController.godoShipmentcase();
        }*
    }   
    
    public void godoRecieverShipmentcase() {
        /*if (mainSearchController != null){
            mainSearchController.godoRecieverShipmentcase();
        }*
    }
    
    public void godoGodscase(){
        /*if (mainSearchController != null){
            mainSearchController.godoGodscase();
        }*
    }
    
    public void godoShipmentcase(){
        /*if (mainSearchController != null){
            mainSearchController.godoShipmentcase();
        }*
    } */
}