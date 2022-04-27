@istest(seeAllData=true)

private class OmniCaseHandler_Test{

static testmethod void OmniCaseHandler_method(){
    Test.startTest();
    
    User u = [Select Id From User Where Alias = 'rumre'];
    
    System.runAs(u){
    Id ownerid = [Select Id From Group Where DeveloperName = 'Adresseendring' and Type = 'Queue'].Id;
    
    Case c = new Case(OwnerId = ownerid, Subject = 'TEST Omni Case');
    insert c;
    
        AgentWork a = new AgentWork();
        a.UserId   = Userinfo.getUserId();
        a.WorkItemid = c.Id;
        a.ServiceChannelId = [Select Id From ServiceChannel Where DeveloperName = 'Customer_Service_Cases'].Id;
        try{
        insert a;
        }Catch(Exception e){}
    }    
    Test.stoptest();
}


}