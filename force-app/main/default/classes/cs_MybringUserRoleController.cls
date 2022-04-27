public class cs_MybringUserRoleController {
    
    @AuraEnabled
    public static List<accountContactRelation> getCustomers(Id ContactId){
        List<accountContactRelation> acrList = [Select Id, accountId, account.Name, roles__c From accountContactRelation Where contactId=:ContactId];
        return acrList;
    }
    
    @AuraEnabled
    public static string getRoles(Id AccountId, Id ContactId){
        String mbRoles = [Select Id, Roles__c from accountContactRelation where ContactId = :ContactId and AccountId = :AccountId].Roles__c;
        return mbRoles;
    }
}