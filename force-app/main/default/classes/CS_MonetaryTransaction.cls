//Author -Supriya Goel
//1 july 2019
//lightning componnet for monetary transaction
//Apex class used by custom lightning record type page for Opportunity

public class CS_MonetaryTransaction {

    @AuraEnabled
    public static List <cls_recordType> getTransactionRecordTypes(String CaseId) {
        
        List<cls_recordType> returnValue = new List<cls_recordType>();
        Schema.DescribeSObjectResult info = Monetary_Transaction__c.SObjectType.getDescribe();
        
        if (info != null && info.isAccessible()){
            Set<String> rtIds = new Set<String>();
            //Get all record types available for current profile
            for(Schema.RecordTypeInfo rt : info.getRecordTypeInfos()){
                if(rt.isAvailable())
                    rtIds.add(rt.getRecordTypeId());
            }
            
        
             
          RecordType[] rtypes = [SELECT Id, tolabel(name), DeveloperName FROM RecordType where sObjectType = 'Monetary_Transaction__c' and id in:rtIds ];
           
                for(RecordType o : rtypes ){
                           returnValue.add(new cls_recordType(o.Name,o.id));    
                }
          
     }   
     System.debug('@@returnValue'+ returnValue);
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

}