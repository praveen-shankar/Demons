public class crm_PostenUtilClass {
    //Method to get the  recordTypeId      
    Public static Id recordTypeId(String obj,string recName){
        Id recTypeId;
        if(obj!= null && recName != null){
           system.debug('obj:: '+obj);            
          system.debug('recName:: '+recName);
            recTypeId= Schema.getGlobalDescribe().get(obj).getDescribe().getRecordTypeInfosByDeveloperName().get(recName).getRecordTypeId();
        }  
     System.debug('recTypeId'+ recTypeId);
        return recTypeId;
    }
    
}