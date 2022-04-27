//Author - Rajeev Shekhar
//Apex class used by custom lightning record type page for Opportunity

public class crm_customRecordTypePageOpportunity {

    @AuraEnabled(cacheable=true)
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
                   // system.debug('###############'+rtIds);
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
/*
      ** Author  :- Praveen Shankar from TCS
      ** Date    :- October 2021
      ** Project :- Posten SF2.0
 */    
    @AuraEnabled(cacheable=true)
    public static List <cls_recordType> getOpportunityRecordTypes_NewBusiness(String accid) {
        //system.debug('accid--->>' + accid);
        String userLanguage = userinfo.getLanguage();
        
        List<cls_recordType> returnValue = new List<cls_recordType>();
        Schema.DescribeSObjectResult oppinfo = Opportunity.SObjectType.getDescribe();
        
        if (oppinfo != null && oppinfo.isAccessible()){
            Set<String> rtIds = new Set<String>();
            //Get all record types available for current profile
            for(Schema.RecordTypeInfo rt : oppinfo.getRecordTypeInfos()){
                if(rt.isAvailable())
                    rtIds.add(rt.getRecordTypeId());
                    //system.debug('###############'+rtIds);
                    }

        
            Account acc = [SELECT Id, Customer_Converted__c FROM Account WHERE Id = : accid LIMIT 1];
             
            New_Business_Type_Opp__mdt[] recordTypes = [SELECT Id, DeveloperName, MasterLabel, Id__c,  Available__c , New_Business_Type_name__c FROM New_Business_Type_Opp__mdt
                                                          //ORDER BY MasterLabel ASC];    
                                                        WHERE Id__c IN :rtIds ORDER BY MasterLabel ASC];
            
                for(New_Business_Type_Opp__mdt o : recordTypes){
                       if(userLanguage=='no'){
                            returnValue.add(new cls_recordType(o.Norwegian_Label__c,o.Id__c));
                       }else{
                            returnValue.add(new cls_recordType(o.New_Business_Type_name__c,o.Id__c));
                            }      
                }    
        }
        //system.debug('returnValue--->>' + returnValue);
     return returnValue;
    }
}