public class CS_UpdateCustomerInfo {

@AuraEnabled
 public static String UpdateCustomerInfo(String accountId) {
  List<Account> updateAccount= new List<Account>();
  
  updateAccount =[select id, status_update__c,  is_system_update__c from Account where id=:accountId limit 1];
  
if(updateAccount[0].id !=null && updateAccount.size()>0 ){
updateAccount[0].status_update__c= 'Updating'; 
updateAccount[0].is_system_update__c= true; 

try {
update updateAccount[0];
}
catch(Exception e) {
return 'error';
}

  return 'success';
}
else return 'error';

}

}