public class cs_getEDIDetails {
    @AuraEnabled
    public static string getEDIInfo(string caseId) {
        case ca= [SELECT id, cs_EDI_Account__c, cs_EDIId__c, cs_EDIName__c FROM Case WHERE Id=:caseId];  
        return ca.cs_EDIName__c;
    }
    
    @AuraEnabled
    public static boolean updateEDIInfo(Id caseId) {
        case ca= [SELECT id, cs_EDI_Account__c, cs_EDIId__c, cs_EDIName__c FROM Case WHERE Id=:caseId];  
        ca.cs_EDIId__c=null;
        ca.cs_EDIName__c=null;
        //System.debug('Test@1/4---->'+ca.cs_EDIIdFlow__c+'flow'+ca.cs_EDINameFlow__c);
        update ca;
        return true;
    }
}