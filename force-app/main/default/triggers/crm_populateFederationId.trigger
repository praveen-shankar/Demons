/*
 * @Author - Rajeev Shekhar
 * @Date - 29th Aug 2016
 * @Purpose - IAM system sends FederationId in EmployeeNumber field. This trigger copies this value in FederationIdentifier field.
*/


trigger crm_populateFederationId on User (before insert) {

    for(User u : trigger.new){
        if(String.isNotBlank(u.EmployeeNumber))
            u.FederationIdentifier = u.EmployeeNumber;
    }

}