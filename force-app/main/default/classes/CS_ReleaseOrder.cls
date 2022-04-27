public class CS_ReleaseOrder {
 @AuraEnabled
 public static Case loadCaseDetails(String caseId) {
  Case caseToBeReleased = new Case();
  try {
                        caseToBeReleased = [SELECT Id,
                                                                        CaseNumber,
                                                                        Description,
                                                                        Origin,
                                                                        Code_Event__c,
                                                                        Service_Product__c,
                                                                        Owner.Username,
                                                                        OEBS_order_number__c,
                                                                        OEBS_order_URL__c,
                                                                        OEBS_order_line_id__c,
                                                                        OEBS_top_article__c,
                                                                        OEBS_contract_name__c,
                                                                        OEBS_contract_number__c,
                                                                        OEBS_producer__c,
                                                                        Submission_place__c,
                                                                        OEBS_Order_Status__c,
                                                                        OEBS_order_release_reason__c
                                                                       
                                                                FROM Case
                                                                WHERE Origin = 'OEBS'
                                                                        AND recordTypeId = :KATSutilities.getRecordType('deviation_case')
                                                                        AND (OEBS_Order_Status__c != 'Released')
                                                                        AND Id = :caseId];
                     
                } catch(QueryException qe) {
                        //<!--CSphase2, Akash, 20122016-->
                        //ExceptionController.handleException(true, true, qe, 'Det ligger en feil i forbindelse med spørringen som gjøres i kontrolleren til OEBS_ReleaseOrderPageController', 'Kan ikke finne sak eller saken passer ikke kriteriene for å frigis.');
                        
                }
                
                system.debug('###caseToBeReleased ' + caseToBeReleased );
                
                return caseToBeReleased ;
                
               }
   @AuraEnabled             
  public static List<caseComment> loadCaseComments(String caseId) {
  List<caseComment> caseComments = new List<CaseComment>();
  caseComments =[Select id, CommentBody, CreatedDate, CreatedBy.Name from caseComment where parentid =:caseId order by createddate desc  ];
   return caseComments ;
            }
            
            
 @AuraEnabled
 public static String releaseorderFn(String caseId, String caseReason) { 
 
  /*if(caseReason.length()>255) {
                //<!--CSphase2, Akash, 20122016-->
                        //caseToBeReleased.OEBS_order_release_reason__c.addError('Ordre frigivelsesgrunn kan ikke overskride 255 tegn');
                        caseToBeReleased.OEBS_order_release_reason__c.addError(System.Label.cs_releaseOrderMsg3);
                        return null;
                }
 */
 system.debug('Caseobj old'+caseId  + caseReason );
 
 Case caseobj= new Case();
 caseobj=[SELECT Id,
                                                                        CaseNumber,
                                                                        Description,
                                                                        Origin,
                                                                        Code_Event__c,
                                                                        Service_Product__c,
                                                                        Owner.Username,
                                                                        OEBS_order_number__c,
                                                                        OEBS_order_URL__c,
                                                                        OEBS_order_line_id__c,
                                                                        OEBS_top_article__c,
                                                                        OEBS_contract_name__c,
                                                                        OEBS_contract_number__c,
                                                                        OEBS_producer__c,
                                                                        Submission_place__c,
                                                                        OEBS_Order_Status__c,
                                                                        OEBS_order_release_reason__c
                                                                       
                                                                FROM Case
                                                                WHERE Origin = 'OEBS'
                                                                        AND recordTypeId = :KATSutilities.getRecordType('deviation_case')
                                                                        AND (OEBS_Order_Status__c != 'Released')
                                                                        AND Id =:caseId];
if(caseobj!=null) {
     
  caseobj.OEBS_order_release_reason__c  = caseReason; 
       if(test.isRunningTest()) {
                        caseobj.OEBS_Order_Status__c = 'Released';
                } else {
                        caseobj = OEBS_OrderController.releaseOrder(caseobj);
                }
 //caseobj.OEBS_Order_Status__c = 'Released';
 system.debug('Caseobj old'+caseobj);
    
    try{  
 update caseobj;
 return 'success';       
    }catch(Exception e){
        return e.getMessage();}
 
}    
     else
return 'success';
 
  }
 

            
          }