public class CS_CloseInquiry {
 @AuraEnabled
 public static String closeInquiryFn(String caseId) {
  Case updateCase= new Case();
  
  updateCase =[select id, ownerId, solution_deadline_group__c, solution_deadline__c, IsClosed, Status , unread_action__c  from case where id=:caseId];
  
   if(updateCase.IsClosed) {
return 'caseclosed';
}

else if(!updateCase.IsClosed){ 
    updateCase.Status = 'Avsluttet'; 
    
}

try {
update updateCase;
}
catch(Exception e) {
return 'error';
}
 return 'success';
  
  
}

}