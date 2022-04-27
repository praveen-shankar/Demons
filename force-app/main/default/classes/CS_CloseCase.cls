public class CS_CloseCase{
    
  
     @AuraEnabled
 public static Case loadCaseDetails(String caseId) {
    Case caseToBeReleased = new Case();
  try {
                        caseToBeReleased = [SELECT Id,
                                                                        CaseNumber,
                                                                        Description,
                                                                        Origin,
                                                                        Status,
                                            Subject,RecordTypeId,Comments,send_email_of_case_update_myBring__c,First_time_created__c,
                                            unit_to_blame__c,unit_to_blame__r.Name,Timeforbruk__c,date_to_be_resumed__c,hidden_vip_customer_bring__c,Notify_unit_to_blame__c
                                                                       
                                                                       
                                                                FROM Case
                                                                WHERE Id = :caseId and isClosed= false];
                     
                } catch(QueryException qe) {
                        //<!--CSphase2, Akash, 20122016-->
                        //ExceptionController.handleException(true, true, qe, 'Det ligger en feil i forbindelse med spørringen som gjøres i kontrolleren til OEBS_ReleaseOrderPageController', 'Kan ikke finne sak eller saken passer ikke kriteriene for å frigis.');
                        
                }
                
                system.debug('###caseToBeReleased ' + caseToBeReleased );
                
                return caseToBeReleased ;
                
               }
 @AuraEnabled             
  public static Map<String, String> loadCaseStatus(String caseId) {
  List<CaseStatus> caseStatuses = new List<CaseStatus>();
  Set<String> statusapiname= new Set<String>();    
  caseStatuses =[Select Id, MasterLabel, ApiName From CaseStatus Where IsClosed = true];
   for (CaseStatus  cs : caseStatuses  )
           statusapiname.add(cs.ApiName);
   
   Map<String, String> options = new Map<String, String>();
        
       Schema.DescribeFieldResult fieldResult =  Case.status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.put(f.getValue(), f.getLabel());
        }  
        
        Map<String, String> CasestatusMap = new Map<String, String>();
        
        for (String s  : statusapiname){
          if (options.containskey(s))
              CasestatusMap.put(s,options.get(s));
                         
        
        }
   
   return CasestatusMap ;
            }
    
    @AuraEnabled
 public static String SaveCase(String caseId, String statusField,
                             String caseRelatedTo,
                             Integer timeConsumptionUnit,
                               //Expected Resumed Code Starts
                             Date expectedResumedUnit,
                               //Expected REsumed Code Ends
                             Boolean emailUpdate,
                             Boolean firstTime,
                             Boolean notify,
                             Boolean vip,
                             String subject,
                             String description
                            ,String comment) { 
 
  /*if(caseReason.length()>255) {
                //<!--CSphase2, Akash, 20122016-->
                        //caseToBeReleased.OEBS_order_release_reason__c.addError('Ordre frigivelsesgrunn kan ikke overskride 255 tegn');
                        caseToBeReleased.OEBS_order_release_reason__c.addError(System.Label.cs_releaseOrderMsg3);
                        return null;
                }
 */
 system.debug('Caseobj old'+caseId  );
system.debug('Inside Savecase');
 Case caseobj=[SELECT Id,
                                                                        CaseNumber,
                                                                        Description,
                                                                        Origin,
                                                                        Status,IsClosed,Code_Event__c,Service_Product__c,
                                            Subject,RecordTypeId,Comments,send_email_of_case_update_myBring__c,First_time_created__c,
                                            unit_to_blame__c,Timeforbruk__c,date_to_be_resumed__c,hidden_vip_customer_bring__c,Notify_unit_to_blame__c
                                                                       
                                                                       
                                                                FROM Case
                                                                WHERE Id = :caseId];
                                
 /*if(caseobj.Code_Event__c == null || caseobj.Service_Product__c == null)  
                {
                                             return System.Label.cs_releaseOrderMsg2;
                }
                                else{*/
                                

caseobj.Status=statusField;
if (caseRelatedTo!='' && caseRelatedTo !=null)
caseobj.unit_to_blame__c=caseRelatedTo;
caseobj.Timeforbruk__c=timeConsumptionUnit;
//Expected Resume code Starts
caseobj.date_to_be_resumed__c=expectedResumedUnit;
//Expected Resumed code ends                                
caseobj.send_email_of_case_update_myBring__c=emailUpdate;
caseobj.First_time_created__c=firstTime;caseobj.Notify_unit_to_blame__c=notify; caseobj.hidden_vip_customer_bring__c=vip; caseobj.Subject=subject; caseobj.Description=description; caseobj.Comments=comment; 
                          // } 
                                
                               
                                try{  update caseobj;  } Catch(Exception e)   {    return e.getMessage();   }return 'Success';
 
  }
 

}