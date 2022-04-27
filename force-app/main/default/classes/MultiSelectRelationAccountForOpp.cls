public class MultiSelectRelationAccountForOpp {
	@AuraEnabled
    public static map<String , List<String>> getPiklistValues(String oppId) {
        System.debug('oppId----------'+oppId);
        
        
        map<String , List<String>> mapOppStageVsRelationCustomers = new map<String , List<String>>();
        List<String> listRelationCustomers = new List<String>();
        try{
            Opportunity oppDetails = [Select Id, Name,AccountId,StageName from Opportunity where Id =:oppId];

            for ( Account accObj : [Select Id, Name, crm_Customer_Number__c,crm_Updated_by_CDH__c from Account where ParentId =: oppDetails.AccountId] ) {
                System.debug('accObj----------'+accObj);
                
                if(!String.isBlank(accObj.crm_Customer_Number__c)){
                    listRelationCustomers.add(accObj.crm_Customer_Number__c);
                    
                }
            
            }
            System.debug('listRelationCustomers----------'+listRelationCustomers);
            if(!listRelationCustomers.isEmpty()){
                listRelationCustomers.sort();
                mapOppStageVsRelationCustomers.put(oppDetails.StageName ,listRelationCustomers );
            }
            else{
                
                mapOppStageVsRelationCustomers.put(oppDetails.StageName ,new List<String>() );
            }
        }catch(Exception ex) {
            System.debug('getPiklistValues: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'getPiklistValues: '+listRelationCustomers);
        }
		
        return mapOppStageVsRelationCustomers;
    }
    @AuraEnabled
    public static void getSelectedCustomers(String oppId ,List<String> listselectedCustomers){
        Opportunity  oppobj = New Opportunity();
        String strCustomerNumberForAgreement;
        try{
        	Opportunity objNewVersion = [Select Id, StageName from Opportunity where Id =: oppId];
            System.debug('listselectedCustomers----------'+listselectedCustomers);
            System.debug('objNewVersion----------'+objNewVersion);
            System.debug('oppId----------'+oppId);
            
            if(!listselectedCustomers.isEmpty() && !String.isBlank(oppId) && objNewVersion.StageName != 'Closed Won'){
                for(String selectedCustomer :listselectedCustomers){
                    if(String.isBlank(strCustomerNumberForAgreement)){
                        strCustomerNumberForAgreement = selectedCustomer;
                    }
                    else{
                        strCustomerNumberForAgreement = strCustomerNumberForAgreement + ';' + selectedCustomer;
                    }
                
                }   
                System.debug('strCustomerNumberForAgreement----------'+strCustomerNumberForAgreement);
                if(!String.isBlank(strCustomerNumberForAgreement)){
                    oppobj.Id = oppId ; 
                    oppobj.Customer_NOs_For_Agreement__c = strCustomerNumberForAgreement;   
                    System.debug('oppobj----------'+oppobj);
    
                    Database.Update(oppobj);
                }
            }
        }catch(Exception ex) {
            System.debug('getSelectedCustomers: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'getSelectedCustomers: '+listselectedCustomers + oppId);
        }
    
    }
    
     @AuraEnabled
    public static List<String> getCustomerNumberForOpportunity(String oppId){
        List<String> lstCustomerNOsForAgreement = new List<String>();
        Opportunity objOppDetails;
        try{
         
            objOppDetails = [Select Id, Name ,AccountId ,Customer_NOs_For_Agreement__c from Opportunity where Id =: oppId];
            
            if(!String.isBlank(objOppDetails.Customer_NOs_For_Agreement__c))
            lstCustomerNOsForAgreement = objOppDetails.Customer_NOs_For_Agreement__c.split(';');
        }catch(Exception ex) {
            System.debug('getCustomerNumberForOpportunity: ' + ex.getMessage());
            ExceptionController.createErrorRecord(ex, 'getCustomerNumberForOpportunity: '+objOppDetails + oppId);
        }
        return lstCustomerNOsForAgreement;
        
    }
}