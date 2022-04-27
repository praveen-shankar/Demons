public class MassReassignApprovalRqst {
           
    private Account approverId = new Account();
    public Account Approver{ get { return approverId; } set { approverId = value; } }
    //public String Comments { get; set; }
    List<ID> itemIdList = new List<ID>();
    
    public PageReference ReassignAll() {
        System.debug(itemIdList);
        list<ProcessInstanceWorkItem> piwList = [SELECT ActorId FROM processinstanceworkitem WHERE processinstance.targetobjectid in: itemIdList];
        //list<ProcessInstanceStep> pisList = [SELECT ActorId,comments FROM ProcessInstanceStep WHERE id in: itemIdList];
        
        System.debug('piwList '+piwList);
        for (ProcessInstanceWorkItem piw : piwList){
            piw.ActorId = Approver.OwnerId;
        }
        
        Database.update(piwList);
		        
        PageReference itemsToApprovePage = new PageReference('/apex/VF_ItemsToApprove');
        itemsToApprovePage.setRedirect(false);         
        return itemsToApprovePage;
    }
    
    
    public MassReassignApprovalRqst(){
        System.debug('Size :'+ApexPages.currentPage().getParameters().size());
        System.Debug(ApexPages.currentPage().getParameters().get('items'));
        String strItems = ApexPages.currentPage().getParameters().get('items');
        //strItems.replace('<>', '\',\'');
        //strItems = '\'' + strItems + '\'';
        itemIdList = strItems.split('<>');    
    }
    
    public PageReference Cancel(){       
        PageReference itemsToApprovePage = new PageReference('/apex/VF_ItemsToApprove');
        itemsToApprovePage.setRedirect(false);         
        return itemsToApprovePage;
        
    }
}