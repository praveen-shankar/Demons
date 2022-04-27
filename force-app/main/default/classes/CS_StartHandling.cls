public class CS_StartHandling {
 @AuraEnabled
 public static String updateCaseDetails(String caseId) {
  Case updateCase= new Case();
  
  updateCase =[select id, ownerId, solution_deadline_group__c, solution_deadline__c, IsClosed, Status , unread_action__c, date_to_be_resumed__c  from case where id=:caseId];
 

  
Integer days =  0;
if(updateCase.solution_deadline__c!=null)
        days = Date.today().daysBetween(date.valueof(updateCase.solution_deadline__c));
 System.debug('%%days' + days  +  updateCase.solution_deadline_group__c);
     
if(updateCase.solution_deadline_group__c!='Ingen Løsningsfrist' && days > 30){ 
return 'Milestoneerror';
}
else if(updateCase.IsClosed) {
return 'caseclosed';
}

else if(!updateCase.IsClosed){ 
    updateCase.OwnerId = UserInfo.getUserId(); 
    updateCase.Status = 'Under behandling'; 
    updateCase.unread_action__c = false; 
    updateCase.date_to_be_resumed__c= null;
}

try {
update updateCase;
}
catch(Exception e) {
return 'error';
}
 return 'success';
  
  
  
  }
  
  @AuraEnabled
 public static String starthandlingFn(String caseId) {
  Case updateCase= new Case();
  
  updateCase =[select id, ownerId, solution_deadline_group__c, solution_deadline__c, IsClosed, Status , unread_action__c  from case where id=:caseId];
  
  updateCase.OwnerId = UserInfo.getUserId(); 
    updateCase.Status = 'Under behandling'; 
    updateCase.unread_action__c = false; 
    updateCase.date_to_be_resumed__c= null;


try {
update updateCase;
}
catch(Exception e) {
return 'error';
}

  return 'success';
}

}