/*  Author: Rajeev Shekhar
    Created for EDI Admin Interface Project
*/
public with sharing class crm_edi_LightningIntegrationController {

    @AuraEnabled
    public static crm_edi_IntegrationController.calloutResponse process(String recordId, String systemName) {
        crm_edi_IntegrationController.calloutResponse response = crm_edi_IntegrationController.makeCallout(recordId,systemName);
      return response;
    }
    
    @AuraEnabled
    public static Edi_Information__c getInitialData(String recordId) {
        return [SELECT Id,Status__c,Disqualified_for_Integration__c,Imported_Data__c,(SELECT Id,Message_Sent_After_Data_Change__c,Manual_Integration_Confirmation__c,System_Name__c,Message_Sent__c FROM EDI_System_Status__r) FROM Edi_Information__c WHERE Id = :recordId];
    }

}