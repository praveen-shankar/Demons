Global class ItemsToApproveController {
    
    public class item_wrapper {
        public item_wrapper(id id,string name,string objtype,String DateSubmited,string totalSum,id originalActorId
                            , id approvalid,string accountName, string claimedAmount,string recourse) {
            this.id = id;
            this.name = name;
            this.objtype = objtype;
            this.DateSubmited = DateSubmited;
            this.totalSum = totalSum;
            this.approvalid = approvalid ;
            this.originalActorId = originalActorId;
            if(accountName.indexof('>')!= -1 && accountName.indexof('<')!= -1 )
                this.accountName = accountName.substring(accountName.indexof('>')+1,accountName.lastindexof('<'));
            else               
                this.accountName = accountName;
            this.claimedAmount = claimedAmount;
            this.recourse = recourse;                    
        }
        public Id id { get; set; }
        public String name { get; set; }
        public String objtype { get; set; }
        public String DateSubmited { get; set; }
        public string totalSum{ get; set; }
        public Id approvalid { get; set; }
        public Boolean selected { get; set; }
        public ID originalActorId { get; set; }
        public string accountName { get; set; }
        public string claimedAmount { get; set; }
        public string recourse { get; set; }
        
    }
    
    public boolean selectAll { get; set; }
    //public list<Id> selectedIDs { get; set; }
    Set<ID> monetaryTransactionIds = new Set<ID>();  
    ApexPages.standardController stdController= null; 
    public List<Monetary_Transaction__c> monetaryTransactionApprovalList {get; set;}
    public list<item_wrapper> items_to_approve { get; set; }
    
    public ItemsToApproveController(ApexPages.StandardController controller) {
        stdController = controller;
    }
    
    public ItemsToApproveController() {
        items_to_approve = new list<item_wrapper>();
        selectAll = false;
        map<id,ProcessInstanceWorkItem> mapPIWIdToPIW = new map<id,ProcessInstanceWorkItem>();
        map<id,Monetary_Transaction__c> mapIdtoMonetaryTransac = new map<id,Monetary_Transaction__c>();
        
        list<ProcessInstanceWorkItem> piwList = [select id, processinstance.targetobjectid,CreatedDate ,processinstance.targetobject.name,
                                                 ProcessInstance.TargetObject.type,OriginalActorId from processinstanceworkitem 
                                                 where actorid = :userinfo.getuserid() Order by CreatedDate asc];
        
        if(!piwList.isEmpty()){
            for(ProcessInstanceWorkItem item: piwList) {
                monetaryTransactionIds.add(item.processinstance.targetobjectid);
                if(!mapPIWIdToPIW.containsKey(item.processinstance.targetobjectid)){
                    mapPIWIdToPIW.put(item.processinstance.targetobjectid,item);
                }
            } 
        }
        
        if(monetaryTransactionIds.size()>0){
            monetaryTransactionApprovalList=[SELECT id, Sum_paid_to_cust_total__c,account__c,case__r.amount_claimed__c,Regress__c 
                                             FROM Monetary_Transaction__c WHERE id in : monetaryTransactionIds];
            if(!monetaryTransactionApprovalList.isEmpty()){
                for(Monetary_Transaction__c objMT : monetaryTransactionApprovalList){
                    mapIdtoMonetaryTransac.put(objMT.id, objMT);
                }
            }
        }
        
        if(!piwList.isEmpty()){
            
            for(ProcessInstanceWorkItem item: mapPIWIdToPIW.values()) {      
                String dateTimeValue = item.CreatedDate.format('dd/MM/yyyy HH:mm');
                if(item.processinstance.TargetObject.type == 'Monetary_Transaction__c'){
                    string claimedAmt;
                    string sum_paid_to_cust_total;
                    string regress;
                    if (mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).Sum_paid_to_cust_total__c != null)
                        sum_paid_to_cust_total = String.valueOf(mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).Sum_paid_to_cust_total__c).replace('.',',');
                    if (mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).case__r.amount_claimed__c != null)
                        claimedAmt = String.valueOf(mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).case__r.amount_claimed__c).replace('.',',');
                    if (mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).Regress__c != null)
                        regress = String.valueOf(mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).Regress__c).replace('.',',');                    
                    items_to_approve.add(
                        new item_wrapper(item.processinstance.targetobjectid, item.processinstance.targetobject.name, 
                                         item.processinstance.TargetObject.type, dateTimeValue, 
                                         sum_paid_to_cust_total, 
                                         item.OriginalActorId, item.id,  
                                         mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).account__c,
                                         claimedAmt,
                                         regress));
                }
            }
        }
    }
    
    public static String ApproveRejectnavigation() {
        String url=''; 
        string myParam = apexpages.currentpage().getparameters().get('myParam');
        url='https://'+ System.URL.getSalesforceBaseUrl().getHost() + 
            '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + myParam ;     
        
        return url; 
        
    }
    
    public static String ReassingNavigation() {
        String url=''; 
        string myParam = apexpages.currentpage().getparameters().get('myParam');
        url='https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/'+ myParam +'/e?et=REASSIGN';     
        return url; 
        
    }
    
    /*
    public void ApproveItems(){        
        
        Id workItemId = apexpages.currentpage().getparameters().get('workItemId');
        Id originalActorId = apexpages.currentpage().getparameters().get('originalActorId');        
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approving request.');
        req.setAction('Approve');
        ID nextApproverID = [SELECT Transaction_approver__c from User where id =: UserInfo.getUserId()][0].Transaction_approver__c;
        req.setNextApproverIds(new Id[] {nextApproverID});
        req.setWorkitemId(workItemId);
        Approval.ProcessResult result =  Approval.Process(req);       

    }
    
    public void RejectItems(){        
        
        Id newWorkItemId = apexpages.currentpage().getparameters().get('myParam');        
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Rejecting request.');
        req.setAction('Reject');
        ID nextApproverID = [SELECT Transaction_approver__c from User where id =: UserInfo.getUserId()][0].Transaction_approver__c;
        req.setNextApproverIds(new Id[] {nextApproverID});        
        // Use the ID from the newly created item to specify the item to be worked
        req.setWorkitemId(newWorkItemId);        
        // Submit the request for approval
        Approval.ProcessResult result =  Approval.Process(req);
        
    }*/
    
    public void Select_All(){
        boolean select_deselect = false;
        if (selectAll)
            select_deselect = true;
        for (item_wrapper item : items_to_approve){
            item.selected = select_deselect;
        }
    }
    
    public PageReference AssignAll(){
        PageReference massReassignPage = new PageReference('/apex/MassReassignApprovalRqst');
        integer counter = 0;
        string strItems = null;
        for (item_wrapper item : items_to_approve){            
            if (item.selected)
            {
                System.debug(Item.Id);
                If (strItems == null)
                    strItems = Item.Id;
                else
                    strItems += '<>' + Item.Id;             
                //System.debug('@@@@@'+strItems );
            }
        }
        massReassignPage.getParameters().put('items', strItems);        
        massReassignPage.setRedirect(false);        
        return massReassignPage;
    }
    
    public PageReference ApproveRejectAll(){
        PageReference massApprRejectPage = new PageReference('/apex/VF_MassApprReject');
        string strItems = null;
        for (item_wrapper item : items_to_approve){            
            if (item.selected)
            {
                System.debug(Item.approvalid);
                If (strItems == null)
                    strItems = Item.approvalid;
                else
                    strItems += '<>' + Item.approvalid;
            }
        }
        massApprRejectPage.getParameters().put('items', strItems);        
        massApprRejectPage.setRedirect(false);        
        return massApprRejectPage;
    }
}