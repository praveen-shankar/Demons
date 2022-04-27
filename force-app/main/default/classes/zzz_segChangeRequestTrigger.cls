@isTest
public class zzz_segChangeRequestTrigger{

    @testSetUp
    static void insertData(){
        //create four user
        User currentSalesResponsibleManager = crm_TestDataFactory.createUser('currentSalesResponsibleManager','curU');
        insert currentSalesResponsibleManager;
            
        User proposedSalesResponsibleManager = crm_TestDataFactory.createUser('proposedSalesResponsibleManager','curM');
        insert proposedSalesResponsibleManager;
            
        User currentSalesResponsible = crm_TestDataFactory.createUser('currentSalesResponsible','propU');
        currentSalesResponsible.ManagerId = currentSalesResponsibleManager.id;
        insert currentSalesResponsible;
            
        User proposedSalesResponsible = crm_TestDataFactory.createUser('proposedSalesResponsible','propM');
        proposedSalesResponsible.ManagerId = proposedSalesResponsibleManager.id;
        insert proposedSalesResponsible;
        
        
        
        
        
    }
    
    static testMethod void testMethod1(){
    
        //create customer
        // Account partyAccount= crm_TestDataFactory.createPartylevelAccount();
        
        String Profileid=[Select id from Profile where name= 'System Administrator' limit 1].id;
        environment_settings__c obj= new environment_settings__c();
        obj.name= 'SystemadminProfileid';
        obj.value__c =Profileid;
        insert obj;
    
        User currentSalesResponsibleManager= [select id from User where Name like 'currentSalesResponsibleManager'];
        User proposedSalesResponsibleManager= [select id from User where Name like 'proposedSalesResponsibleManager'];
        User currentSalesResponsible = [select id from User where Name like 'currentSalesResponsible'];
        User proposedSalesResponsible = [select id from User where Name like 'proposedSalesResponsible'];
     
       // Account partyAccount=[select id from Account where Name like 'ABC'];
                
        Account partyAccount= new Account();
        partyAccount.Name='ABC';
        partyAccount.recordTypeId = '012w000000072at';
        insert partyAccount;
        
        Segment_Change_Request__c request = new Segment_Change_Request__c();
        request.Current_Sales_Responsible__c = currentSalesResponsible.id;
        request.Current_Sales_Responsible_Manager__c = currentSalesResponsibleManager.id;
        request.Proposed_Sales_Responsible__c = proposedSalesResponsible.id;
        request.Proposed_Sales_Responsible_Manager__c = proposedSalesResponsibleManager.id;
        request.Customer__c = partyAccount.id;
       // request.Start_Date__c = date.today();
       // request.Status__c='Submitted';
        
        insert request;
        
        system.runAs(proposedSalesResponsibleManager){
           Approval.ProcessWorkitemRequest req= new Approval.ProcessWorkitemRequest();
            req.setComments('Approving request using trigger');
            req.setAction('Approve');
            req.setNextApproverIds(new Id[] {proposedSalesResponsibleManager.id});
            //Id workItemId = req.
            ProcessInstanceWorkitem workItem = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =:request.id]; 
            req.setWorkitemId(workItem.Id);
           Approval.ProcessResult result= Approval.process(req); 
        }
        
       /* request.Status__c='Partially Approved';
        update request;
        
         Approval.ProcessSubmitRequest req1 = Select id from 
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(request.id);

        Approval.ProcessResult result = Approval.process(req1);
        List<Id> newWorkItemIds = result.getNewWorkitemIds();*/
        
    }
}