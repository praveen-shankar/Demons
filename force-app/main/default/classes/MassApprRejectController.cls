public class MassApprRejectController {
    
    private Account approverId = new Account();
    public Account Approver{ get { return approverId; } set { approverId = value; } }
    public String Comments { get; set; }
    List<ID> itemIdList = new List<ID>();
    
    public MassApprRejectController(){
        //System.debug('Size :'+ApexPages.currentPage().getParameters().size());
        //System.Debug(ApexPages.currentPage().getParameters().get('items'));
        String strItems = ApexPages.currentPage().getParameters().get('items');
        itemIdList = strItems.split('<>');
        //System.debug('ItemIDList :'+ItemIDList +' ItemIDList[0]:'+ItemIDList[0] );
    }
    
    public PageReference ApproveAllItems(){        
        //Id workItemId = apexpages.currentpage().getparameters().get('myParam');      
        Approval.ProcessWorkitemRequest[] reqList = new Approval.ProcessWorkitemRequest[]{};
            for (Id item : itemIdList){
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments(Comments);
                req.setAction('Approve');
                ID nextApproverID = [SELECT Transaction_approver__c from User where id =: UserInfo.getUserId()][0].Transaction_approver__c;
                //req.setNextApproverIds(new Id[] {nextApproverID});        
                req.setWorkitemId(item);
                reqList.add(req);                
            }
        system.debug('Hello');
        try{
            Approval.ProcessResult[] result =  Approval.Process(reqList);
            PageReference itemsToApprovePage = new PageReference('/apex/VF_ItemsToApprove');
            itemsToApprovePage.setRedirect(false);         
            return itemsToApprovePage;
        }Catch (Exception e){
            string msg;
            if (e.getMessage().contains('MANAGER_NOT_DEFINED'))
                msg = 'Invalid Data. Review all error messages below to correct your data. A valid next approver isn\'t specified. Contact your administrator.';
            else
                msg = e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
            return null;
        }        
        
        
    }
    
    public PageReference RejectAllItems(){        
        //Id workItemId = apexpages.currentpage().getparameters().get('myParam');      
        Approval.ProcessWorkitemRequest[] reqList = new Approval.ProcessWorkitemRequest[]{};
            for (Id item : itemIdList){
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments(Comments);
                req.setAction('Reject');
                ID nextApproverID = [SELECT Transaction_approver__c from User where id =: UserInfo.getUserId()][0].Transaction_approver__c;
                //req.setNextApproverIds(new Id[] {nextApproverID});        
                req.setWorkitemId(item);
                reqList.add(req);                
            }
        
        Approval.ProcessResult[] result =  Approval.Process(reqList);
        
        PageReference itemsToApprovePage = new PageReference('/apex/VF_ItemsToApprove');
        itemsToApprovePage.setRedirect(false);         
        return itemsToApprovePage;
        
    }
    
    public PageReference Cancel(){       
        PageReference itemsToApprovePage = new PageReference('/apex/VF_ItemsToApprove');
        itemsToApprovePage.setRedirect(false);         
        return itemsToApprovePage;
        
    }
}