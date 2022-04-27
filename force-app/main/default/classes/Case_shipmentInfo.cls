public class Case_shipmentInfo {
    
    public Case c {get;set;}
    private postenNoEconnectUtilities eConnect {get; set;}
    public String shipmentIdentification{ get; set; }
    public String shipmentNumber {get; set;}
    public EConnectWrapper_GetShipmentData wrapper { get; set; }
    public List<ShipmentWrapper> shipmentList {get; set;}
    //public boolean callbroadcast{get;set;}
    
    public Case_shipmentInfo(ApexPages.StandardController stdController) {
        c = (Case) stdController.getRecord();
        
        shipmentIdentification = [SELECT id, Shipment_identification__c FROM Case WHERE id = :c.Id LIMIT 1].shipment_identification__c;
        shipmentNumber = [SELECT id, Shipment_number__c FROM Case WHERE id = :c.Id LIMIT 1].Shipment_number__c;
        //requestData(); //Called from VF page action=""
        if(!KATSutilities.isEmpty(shipmentIdentification))
        shipmentIdentification = shipmentIdentification.touppercase();
    }
    
    public void requestData() {
        try {
            eConnect = new postenNoEconnectUtilities();
            if (!KATSutilities.isEmpty(shipmentIdentification)){
                requestShipment();
            }
            else if (!KATSutilities.isEmpty(shipmentNumber)){
                requestShipmentOverview();
            }
            else {
                    system.debug('Case_shipmentInfo - requestData - no eConnect data');
                   // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Fant ingen sendings data');
                   //CSphase2 Supriya 22122016
                   ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Sending_data_not_found);
                  
            }
        }
        catch(CalloutException coe) {
            //TODO: Exception handling
            system.debug('Something went wrong in the eConnect call');
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Forbindelsen til eConnect feilet - ' + coe.getMessage() ));
            
            //CSphase2 Supriya 23122016 
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.label.cs_Connection_to_eConnect_failed + coe.getMessage() ));
               
        }
        catch(TypeException te) {
            system.debug('Something went wrong when preparing the eConnect call: ' + te.getMessage() );
            //KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Feil i angitte verdier - ' + te.getMessage() ));
             //CSphase2 Supriya 23122016 
            KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, System.Label.cs_Error_in_specified_values +'-' + te.getMessage() ));
        }
        catch (Exception ex) {
            system.debug('Case_shipmentInfo - requestData - Exception');
            //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Fant ingen sendings data' + ex.getMessage());
            //CSphase2 Supriya 23122016 
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Found_no_sendings_data + ex.getMessage());
        }
        
        
    }
    
    public void requestShipment(){
        
            if(!KATSutilities.isEmpty(shipmentIdentification) && shipmentIdentification != '0') {
                wrapper = new EConnectWrapper_GetShipmentData(eConnect.getShipment(shipmentIdentification));
                DataPersistencyController.maintainShipmentEvent(c, wrapper.eConnectResponse.Events.Event);

            } else if(shipmentIdentification == '0') {
                system.debug('Case_shipmentInfo - requestData - shipment identification = 0');
                //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Ingen sendingsinfo - Kollinummer satt til 0');
                 //CSphase2 Supriya 23122016
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_No_sending_info);
            } else {
                system.debug('Case_shipmentInfo - requestData - no eConnect data');
                //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Fant ingen sendings data');
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Sending_data_not_found);
                 //CSphase2 Supriya 23122016
            }
    }
    
    public void requestShipmentOverview() {
        List<postenNoEconnectKatsSearchshipment.TShipmentUnit> eConnectReply = new list<postenNoEconnectKatsSearchshipment.TShipmentUnit>();        
        system.debug('Search: from eConnect '+eConnectReply);  
        map<String, String> searchShipmentParams = new map<String, String>();
        searchShipmentParams.put('ShipmentUnitID', shipmentNumber);
        
        //new code
        if(Test.isRunningTest()){
        MockShipmentSearchReply mock = new MockShipmentSearchReply();
            eConnectReply = mock.testing();
            }
        else{
            eConnectReply = eConnect.searchShipment('10', searchShipmentParams);
        }
        if(eConnectReply==null || eConnectReply.size() == 0) {
            system.debug('Search: No results returned from eConnect');  
        }
        else {
            shipmentList = new List<ShipmentWrapper>();
            system.debug('Search: Reply from eConnect to be prepared for display: ' + eConnectReply);
            for(postenNoEconnectKatsSearchshipment.TShipmentUnit replyElement:eConnectReply) {
                // Fix to prevent callout exception on shipments with more than 10 units.
                if(Limits.getCallouts()>99){
                       // KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Denne sendingen kan ha flere kolli. Bare de 10 første vises.' ));
                         //CSphase2 Supriya 23122016
                        KATSutilities.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.cs_more_than_one_package )); 
                        break;                   
                }
                shipmentList.add(new ShipmentWrapper(replyElement, 
                                                    new EConnectWrapper_GetShipmentData(eConnect.getShipment(replyElement.ShipmentUnitID))));
                if(shipmentList.size()>0){
                System.debug('~~~calling wrapper'+shipmentList.size()); 
                wrapper = shipmentList.get(0).wrapper; 
                
               // DataPersistencyController.maintainShipmentEvent(c, wrapper.eConnectResponse.Events.Event);    
                   
                }

                
            }
        }    
       
    }
    
    public boolean getHasEconnectData() {
        if(wrapper != null || shipmentList != null) {
            system.debug('Case_shipmentInfo - getHasEconnectData - has eConnect data');
            return true;
        }
        system.debug('Case_shipmentInfo - getHasEconnectData - no eConnect data');
       // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Fant ingen sendings data');
         //CSphase2 Supriya 23122016
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.cs_Sending_data_not_found);
        return false;
    }
    
    public void persistShipment() {
        
        if (shipmentList != null && shipmentList.size() > 0 && shipmentList.size() ==1){
            System.debug('~~~perisist::'+shipmentList.get(0).wrapper.eConnectResponse);
            DataPersistencyController.maintainShipmentOnRegisteredCase(shipmentList.get(0).wrapper.eConnectResponse, c);
            
        }
        else {
            
            DataPersistencyController.maintainShipmentOnRegisteredCase(c);
        }       
        
    }
    public void persistShipmentReciever() {
        if (shipmentList != null && shipmentList.size() > 0){
    
            DataPersistencyController.maintainShipmentReciever(shipmentList.get(0).wrapper.eConnectResponse, c);
        }
        else {
            DataPersistencyController.maintainShipmentReciever(c);
        }
        
    }
    public void persistShipmentSender() {
        if (shipmentList != null && shipmentList.size() > 0){
    DataPersistencyController.maintainShipmentSender(shipmentList.get(0).wrapper.eConnectResponse, c);
        }
        else {
            DataPersistencyController.maintainShipmentSender( c);
        }   
        
    }
    
    public boolean getShowShipmentOverview() {
       
        if(!KATSutilities.isEmpty(shipmentNumber) && KATSutilities.isEmpty(shipmentIdentification) && shipmentList.size() > 1){
           return true;
        }
        else if(!KATSutilities.isEmpty(shipmentNumber) && !KATSutilities.isEmpty(shipmentIdentification)){
            return false;
        }
        return false;       
    }
 
}