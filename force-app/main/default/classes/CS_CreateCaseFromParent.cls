public class CS_CreateCaseFromParent {

@AuraEnabled
 public static String CreateCaseFromParent (String caseId) {
  List<Case>  insertedCase = new List<Case>();
  Case  newCase = new Case();
  
   insertedCase =[select id,subject, AccountId,BusinessHoursId,CurrencyIsoCode, Origin,Ownerid,Reason, Recordtypeid,SourceId,IsClosedOnCreate,ContactEmail,ContactFax,ContactMobile, ContactId, ContactPhone, Description,Entitlementid,Comments, Priority, Productid,SuppliedCompany,SuppliedEmail,SuppliedName,SuppliedPhone  from Case where id=:caseId limit 1];
  
if(insertedCase[0].id !=null && insertedCase.size()>0 ){

try {
newCase  = insertedCase[0].clone(false, true);
newcase.parentid= caseId;
newcase.contactid= insertedCase[0].contactid;
 System.debug('###newcase' + newcase );
insert newCase; 
}
catch(Exception e) {
return 'error';
}

  return String.valueof(newCase.id);
}
else return 'error';

}

}