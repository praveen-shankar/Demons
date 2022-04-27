//Author - Rajeev Shekhar
//Apex class used to determine if an Opportunity is on new service family

public class crm_alertOppAsNew {

    //Method to return if Opportunity is on new services
    @AuraEnabled
    public static cls_oppType getOpportunityNewOrOld(String oppId) {
        Map<String,Boolean> rtMapbyBoolean = new Map<String,Boolean>();
        cls_oppType o = new cls_oppType();
        for(crm_Opportunity_Record_Type__mdt rt : [SELECT DeveloperName, crm_IsNew__c FROM crm_Opportunity_Record_Type__mdt])
            rtMapByBoolean.put(rt.DeveloperName,rt.crm_IsNew__c);           
        try{
            Opportunity oppt = [SELECT RecordType.DeveloperName,crm_Enriched_In_PriceEngine__c,crm_Agreement_Interface_TransactionId__c,StageName,
                                crm_Verified_by_Contract_Management__c,crm_Callout_Status__c FROM Opportunity WHERE Id = :oppId];
            String rtname = oppt.RecordType.DeveloperName;
            o.check = rtMapByBoolean.containsKey(rtname) ? rtMapByBoolean.get(rtname) : false;
            o.opp = oppt;
        } catch(Exception e) {
            o.check = false;
            o.opp = null;
        }
       return o; 
    }
    
    public class cls_oppType {
        @AuraEnabled public Boolean check;
        @AuraEnabled public Opportunity opp;
    }
}