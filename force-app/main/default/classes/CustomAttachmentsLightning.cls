public class CustomAttachmentsLightning {
 @AuraEnabled
 public static List<Custom_Attachment_Details__c> getcaseAttachments(String caseId) {
  List<Custom_Attachment_Details__c> attachmentlist= new List<Custom_Attachment_Details__c>();  
  attachmentlist =[select id,Name,GroupId__c,Attachment__r.name,Role__c,Selected_Users__r.name,Case_Number__c from Custom_Attachment_Details__c where Case_Number__c = :caseId and Selected_Users__c =:UserInfo.getUserId()];
   return attachmentlist ;
    
    }
     @AuraEnabled
    public static Boolean deleterecord(String caseId) {
        List<Custom_Attachment_Details__c> delList = new List<Custom_Attachment_Details__c>();
        delList=[Select Id from Custom_Attachment_Details__c where Id =:caseId];
        if(delList.size()>0)
        {
           delete delList;
            return true;
            
        }
        else
            return false;
        
    }
}