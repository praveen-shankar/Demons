public class cs_TransactionsToBeApproved {

      public with sharing class item_wrapper {
    public item_wrapper(id Id,string name,string objtype,String DateSubmited,string totalSum,string productname,string caseno,string transname,String originalActorId
                            , id approvalid,string accountName, string claimedAmount,string recourse , string closingcode) {
            this.Id = Id;
            this.name = name;
            this.objtype = objtype;
            this.DateSubmited = DateSubmited;
            this.totalSum = totalSum;
            this.productname= productname;
            this.caseno = caseno;
            this.transname= transname;
                                
            this.approvalid = approvalid ;
            this.originalActorId = originalActorId;
            if(accountName.indexof('>')!= -1 && accountName.indexof('<')!= -1 )
                this.accountName = accountName.substring(accountName.indexof('>')+1,accountName.lastindexof('<'));
            else               
                this.accountName = accountName;
            this.claimedAmount = claimedAmount;
            this.recourse = recourse;   
            this.selected = false;
             this.closingcode=closingcode;
        }
       @AuraEnabled  public Id Id { get; set; }
       @AuraEnabled  public String name { get; set; }
       @AuraEnabled  public String objtype { get; set; }
        @AuraEnabled public String DateSubmited { get; set; }
        @AuraEnabled public string totalSum{ get; set; }
           @AuraEnabled public string productname{ get; set; }
          @AuraEnabled public string caseno{ get; set; }
           @AuraEnabled public string transname{ get; set; }
             @AuraEnabled public string closingcode{ get; set; }
          
       @AuraEnabled  public Id approvalid { get; set; }
       @AuraEnabled  public Boolean selected { get; set; }
       @AuraEnabled  public String originalActorId { get; set; }
       @AuraEnabled  public string accountName { get; set; }
       @AuraEnabled  public string claimedAmount { get; set; }
       @AuraEnabled  public string recourse { get; set; }
           
    }
    
  
    //public list<Id> selectedIDs { get; set; }
      
    ApexPages.standardController stdController= null; 
 
    
     @AuraEnabled
    public static List<item_wrapper> getItemsToApproveController() {
         boolean selectAll ;
       //  List<Monetary_Transaction__c> monetaryTransactionApprovalList {get; set;};
           //items_to_approve { get; set; };
        Set<ID> monetaryTransactionIds = new Set<ID>(); 
        List<Monetary_Transaction__c> monetaryTransactionApprovalList = new List<Monetary_Transaction__c>();
        list<item_wrapper> items_to_approve = new list<item_wrapper>();
        selectAll = false;
        map<id,ProcessInstanceWorkItem> mapPIWIdToPIW = new map<id,ProcessInstanceWorkItem>();
        map<id,Monetary_Transaction__c> mapIdtoMonetaryTransac = new map<id,Monetary_Transaction__c>();
        
        list<ProcessInstanceWorkItem> piwList = [select id, processinstance.targetobjectid,CreatedDate ,processinstance.targetobject.name,
                                                 ProcessInstance.TargetObject.type,OriginalActorId, OriginalActor.Name from processinstanceworkitem 
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
            monetaryTransactionApprovalList=[SELECT id, name,Sum_paid_to_cust_total__c,Service_Product__c,account__c,case__r.caseNumber,case__r.amount_claimed__c,tolabel(case__r.close_code__c) , Regress__c 
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
                    String productname;
                    if (mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).Sum_paid_to_cust_total__c != null)
                        sum_paid_to_cust_total = String.valueOf(mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).Sum_paid_to_cust_total__c).replace('.',',');
                    if (mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).case__r.amount_claimed__c != null)
                        claimedAmt = String.valueOf(mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).case__r.amount_claimed__c).replace('.',',');
                    if (mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).Regress__c != null)
                        regress = String.valueOf(mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).Regress__c).replace('.',',');
    if (mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).Service_Product__c != null)
        productname = mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).Service_Product__c;
                    system.debug('productname'+productname);
                    system.debug(mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).case__r.CaseNumber);
                    items_to_approve.add(
                        new item_wrapper(item.processinstance.targetobjectid, 
                                         item.processinstance.targetobject.name, 
                                         item.processinstance.TargetObject.type,
                                         dateTimeValue, 
                                         sum_paid_to_cust_total,
                                         productname,
                                         mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).case__r.CaseNumber,
                                         mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).Name,
                                         item.OriginalActor.Name, 
                                         item.Id,
                                         mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).account__c,
                                         
                                         claimedAmt,
                                         regress,
                                         mapIdtoMonetaryTransac.get(item.processinstance.targetobjectid).case__r.close_code__c
                                         ));
                }
            }
        }
        system.debug('wrapper'+items_to_approve);
        return items_to_approve;
    }
    
    @AuraEnabled
 public static String approverecordsfn (List < String > selectedLists1) {
 
  Approval.ProcessWorkitemRequest[] reqList = new Approval.ProcessWorkitemRequest[]{};
            for (String item : selectedLists1){
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approved');
                req.setAction('Approve');
               // ID nextApproverID = [SELECT Transaction_approver__c from User where id =: UserInfo.getUserId()][0].Transaction_approver__c;
                //req.setNextApproverIds(new Id[] {nextApproverID});        
                req.setWorkitemId(item);
                reqList.add(req);                
            }
        system.debug('Hello');
        try{
            Approval.ProcessResult[] result =  Approval.Process(reqList);
 
     }catch(Exception e){       return 'Error';      }
 return 'Done';

 }
    
     @AuraEnabled
 public static String rejectrecordsfn (List < String > selectedLists1) {
 Approval.ProcessWorkitemRequest[] reqList = new Approval.ProcessWorkitemRequest[]{};
            for (String item : selectedLists1){
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Rejected');
                req.setAction('Reject');
               // ID nextApproverID = [SELECT Transaction_approver__c from User where id =: UserInfo.getUserId()][0].Transaction_approver__c;
                //req.setNextApproverIds(new Id[] {nextApproverID});        
                req.setWorkitemId(item);
                reqList.add(req);                
            }
        system.debug('Hello');
        try{
            Approval.ProcessResult[] result =  Approval.Process(reqList);
 
     }catch(Exception e){       return 'Error';      }
 return 'Done';
 }



}