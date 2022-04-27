public class SF2_RecordTypeController {
    public static Map<Id,String> recordTypeMap {get;set;} 
// -------------------------------------------------------------------------------
    @AuraEnabled
    public static List <cls_recordType> getOpportunityRecordTypes(String accid) {
        String userLanguage = userinfo.getLanguage();
        
        List<cls_recordType> returnValue = new List<cls_recordType>();
        Schema.DescribeSObjectResult oppinfo = Opportunity.SObjectType.getDescribe();
        
        if (oppinfo != null && oppinfo.isAccessible()){
            Set<String> rtIds = new Set<String>();
            //Get all record types available for current profile
            for(Schema.RecordTypeInfo rt : oppinfo.getRecordTypeInfos()){
                if(rt.isAvailable())
                    rtIds.add(rt.getRecordTypeId());
                    system.debug('###############'+rtIds);
                    }

        
            Account acc = [SELECT Id, Customer_Converted__c FROM Account WHERE Id = : accid LIMIT 1];
             
            crm_Opportunity_Record_Type__mdt[] recordTypes = [SELECT Id, DeveloperName, MasterLabel, crm_Id__c, crm_IsNew__c, Modified__c,Unavailable__c,Unchanged__c, Norwegian_Label__c FROM crm_Opportunity_Record_Type__mdt
                                                              WHERE crm_Id__c IN :rtIds ORDER BY MasterLabel ASC];
            
            if (acc.Customer_Converted__c == 'Converted' || acc.Customer_Converted__c == 'InPreparation') {
                for(crm_Opportunity_Record_Type__mdt o : recordTypes){
                    if(o.crm_IsNew__c || o.Modified__c|| o.Unchanged__c)
                        if(userLanguage=='no'){
                            returnValue.add(new cls_recordType(o.Norwegian_Label__c,o.crm_Id__c));
                        }
                    else{
                        returnValue.add(new cls_recordType(o.MasterLabel,o.crm_Id__c));
                    }
                            
                }    
            } else if (acc.Customer_Converted__c == 'NotConverted' || String.isBlank(acc.Customer_Converted__c)) {   
                for(crm_Opportunity_Record_Type__mdt o : recordTypes){
                    if(!o.crm_IsNew__c)
						if(userLanguage=='no'){
                            returnValue.add(new cls_recordType(o.Norwegian_Label__c,o.crm_Id__c));
                        }
                    	else{
                        	returnValue.add(new cls_recordType(o.MasterLabel,o.crm_Id__c));
                    }                }
            }
        }
     return returnValue;
    }
        
    public class cls_recordType{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        
        cls_recordType(String label,String value){
            this.label = label;
            this.value = value;
        }
    }
  
//-----------------------------------------------------         
    @AuraEnabled
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordTypes = Opportunity.SObjectType.getDescribe().getRecordTypeInfos();
          recordTypeMap = New Map<Id , String>() ;
        for(RecordTypeInfo rt : recordTypes){
          recordTypeMap.put(rt.getRecordTypeId() , rt.getName())  ;
        }
        return recordTypeMap.values() ;
    }
    @AuraEnabled
    public static Id getRecTypeId( string recordTypeLabel){
        Id recId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId() ;
        return recId ;
    }
}