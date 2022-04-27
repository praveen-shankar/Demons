public class ActiveTerminatedAgreementOpportunities {
    
    @auraEnabled
    public static void getOpportunityRecordToDelete(String oppId){
        System.debug('oppId-----------'+oppId);
        Opportunity objOpp = new Opportunity();
        try{
            if(!String.isBlank(oppId)) {
                objOpp.Id = oppId;
        		
            }
            delete objOpp;
        }
        catch(CalloutException ex) {
        	System.debug('getOpportunityRecordToDelete: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'ActiveTerminatedAgreementOpportunities - getOpportunityRecordToDelete: '+objOpp);
		}
       
        
    }

}