public with sharing class ShipmentOverviewComponent_new {
    
    public case currentcase{get;set;}
    public Transient List<ShipmentWrapper> shipmentList; 
    public Transient List<ShipmentWrapper> shipmentListNew;
    public boolean isSearchView;
     public boolean isSearchViewnew;
    public Map<String, ShipmentWrapper> shipmentMap {get; set;} 
    public List<ShipmentWrapper> backupShipmentList;
    
    public MainSearchController mainSearchControllernew {get; set;}
    
    public Integer selected {get; set;}
    public String currentShipmentUnitID {get; set;}
    public EConnectWrapper_GetShipmentData wrapper {get; private set;}
    
    
    public void setIsSearchView(boolean isSearchView) {this.isSearchView = isSearchView;}
     public void setIsSearchViewnew(boolean isSearchView) {this.isSearchViewnew = isSearchViewnew;}
    
    public boolean getIsSearchView(){ return this.isSearchView; }
    
    public boolean getIsSearchViewnew(){ return this.isSearchViewnew; }
   // public case getcurrentcase(){ return this.currentcase;}
    
    public void setShipmentListNew(List<ShipmentWrapper> shipmentListNew) {
            this.shipmentListNew = shipmentListNew; 
            populateShipmentMap(this.shipmentListNew); 
    }
        
    public List<ShipmentWrapper> getShipmentListNew() { return this.shipmentMap != null ? this.shipmentMap.values(): new List<ShipmentWrapper> (); }
        
    public void populateShipmentMap(List<ShipmentWrapper> shipmentListNew) {
        
        if (shipmentMap == null) {
            shipmentMap = new Map<string,ShipmentWrapper>();
        }
        if (shipmentListNew != null){
            for (ShipmentWrapper shipment : shipmentListNew) {
                if (shipment.ShipmentUnitID != null) {
                    shipmentMap.put(shipment.ShipmentUnitID.trim(), shipment);
                }
            }       
        }
    }
    
    public boolean getHasShipments(){
        return shipmentListNew != null || backupShipmentList != null;
    }
    
    public boolean displayShipmentDetailsPopup {get; set;}  
    
    public Pagereference showShipmentDetails() {    
      // Case c = [Select id from case where id =:case11 limit 1]; 
        system.debug('~~insideshowShipmentDetails');
        displayShipmentDetailsPopup = true;
        if (currentShipmentUnitID != null){
            this.wrapper = getSelectedShipmentByID();
            System.debug('~~~wrapper'+this.wrapper);
            System.debug('~~~this.wrapper.eConnectResponse'+this.wrapper.eConnectResponse);
            System.debug('~~~case11'+currentcase);
        }
        
        DataPersistencyController.maintainShipmentOnRegisteredCase(this.wrapper.eConnectResponse, currentcase);
       // DataPersistencyController.maintainShipmentOnRegisteredCase(shipmentList.get(0).wrapper.eConnectResponse, c);
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