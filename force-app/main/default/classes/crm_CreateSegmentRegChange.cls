public class crm_CreateSegmentRegChange {
 @AuraEnabled
 public static List < crm_segment__c > getSegments(String acctId) {

  Set < String > sg = new set < String > ();
  Schema.DescribeFieldResult fieldResult = Opportunity.crm_Opp_Service_Group__c.getDescribe();
  List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
  for (Schema.PicklistEntry f: ple) {
   //options.put(f.getLabel(), f.getValue());
   sg.add(f.getValue());
  }

  Set < String > status = new Set < String > {
   'Completed',
   'Rejected',
   'Cancelled'
  };
  List < Segment_Change_Request__c > reqList = [Select id, Service_Group__c from Segment_Change_Request__c where Customer__c =: acctId and status__c not in: status];
  System.debug('###reqList' + reqList);

  for (Segment_Change_Request__c req: reqList) {
   if (sg.contains(req.Service_Group__c))
    sg.remove(req.Service_Group__c);

  }
  System.debug('###sg' + sg);

  List < crm_segment__c > segmentList = new List < crm_segment__c > ();
  segmentList = [Select id, crm_Service_Group__c, crm_Sales_Responsible__r.name, crm_Sales_Responsible__r.ManagerId from crm_segment__c where crm_account__c =: acctId and crm_Service_Group__c in: sg];
  System.debug('###segmentList ' + segmentList);
  return segmentList;
 }

 @AuraEnabled
 public static List < crm_segment__c > getSegmentList(String segId) {

  List < crm_segment__c > segmentList = new List < crm_segment__c > ();
  segmentList = [Select id, crm_Service_Group__c, crm_Sales_Responsible__r.name, crm_Sales_Responsible__c, crm_Sales_Responsible__r.ManagerId, Responsible_seller_manager_status__c  from crm_segment__c where Id =: segId];
  System.debug('###segmentList' + segmentList);
  return segmentList;
 }



 @AuraEnabled
 public static List < Segment_Change_Request__c > getSegmentCompleted() {

  Set < String > status = new Set < String > {
   'Completed'
  };
  String loggedinuserid = UserInfo.getUserId();
  string profileID = UserInfo.getProfileId();

  environment_settings__c SystemadminProfile = environment_settings__c.getValues('SystemadminProfileid');
  String SystemadminProfileid = SystemadminProfile.value__c;

  string query = 'Select  id, Service_Group__c ,name, Customer__c, Current_Sales_Responsible__r.Name,Proposed_Sales_Responsible__r.Name, Customer__r.Name,Start_Date__c, Date_Requested_On__c from Segment_Change_Request__c where  status__c   in :status';
  System.debug('###profileID' + profileID + 'profileList[0].id' + SystemadminProfileid);
  if (SystemadminProfileid != profileID)
   query += ' and (Current_Sales_Responsible_Manager__c = :loggedinuserid OR Proposed_Sales_Responsible_Manager__c= :loggedinuserid )';

  List < Segment_Change_Request__c > reqList = Database.query(query);


  System.debug('###reqList' + reqList + query);
  return reqList;

 }

 //added by Chaitali
 @AuraEnabled
 public static List < SegmentChangeWrapper > getSegmentToBeApproved() {

 /* Set < String > status = new Set < String > {
   'Submitted',
   'Partially Approved'
  };
  String loggedinuserid = UserInfo.getUserId();
  string profileID = UserInfo.getProfileId();

  environment_settings__c SystemadminProfile = environment_settings__c.getValues('SystemadminProfileid');
  String SystemadminProfileid = SystemadminProfile.value__c;

  string query = 'Select  id, Service_Group__c ,name, Customer__c,status__c, Current_Sales_Responsible__r.Name,Proposed_Sales_Responsible__r.Name, Customer__r.Name,Start_Date__c, Date_Requested_On__c from Segment_Change_Request__c where  status__c   in :status';
  System.debug('###profileID' + profileID + 'profileList[0].id' + SystemadminProfileid);
  if (SystemadminProfileid != profileID)
   query += ' and (Current_Sales_Responsible_Manager__c = :loggedinuserid OR Proposed_Sales_Responsible_Manager__c= :loggedinuserid )';

*/
     
        User currentUser = [select Id, username, name from User where Id = :UserInfo.getUserId()];
        List<ProcessInstance> processInstanceList = [SELECT Id, Status,TargetObjectId,(SELECT Id, ActorId FROM StepsAndWorkitems where ActorId = :currentUser.id) FROM ProcessInstance where Status IN('Pending','Hold','Reassigned','NoResponse')];
        System.debug(processInstanceList);
        Set<ID> idsToProcess = new Set<ID>();
        for(ProcessInstance instance : processInstanceList)
            idsToProcess.add(instance.TargetObjectId);
     
      System.debug(idsToProcess);
         
        List<Segment_Change_Request__c>  reqList= [Select  id, Service_Group__c ,name, Customer__c, Current_Sales_Responsible__r.Name,Proposed_Sales_Responsible__r.Name, Customer__r.Name,Start_Date__c, Date_Requested_On__c, Status__c from Segment_Change_Request__c where ID in :idsToProcess and ((status__c = 'Partially Approved' and Proposed_Sales_Responsible_Manager__c = :currentUser.id) OR (status__c='Submitted' and Current_Sales_Responsible_Manager__c = :currentUser.id) ) ];
        System.debug('To be processed : '+reqList);
//  List < Segment_Change_Request__c > reqList = Database.query(query);
     
  List < SegmentChangeWrapper > segmentwrapper = new List < SegmentChangeWrapper > ();
  for (Segment_Change_Request__c req: reqList) {
   SegmentChangeWrapper obj = new SegmentChangeWrapper();
   obj.id = req.id;
   obj.Name = req.Name;
   obj.CustomerName = req.Customer__r.Name;
   obj.CustomerId = req.Customer__c;
   obj.ServiceGrp = req.Service_Group__c;
   obj.currentSalesUser = req.Current_Sales_Responsible__r.Name;
   obj.proposedSalesUser = req.Proposed_Sales_Responsible__r.Name;
   obj.Startdate = String.valueof(req.Start_Date__c);
   obj.Requesteddate = String.valueof(req.Date_Requested_On__c);
   obj.status= String.valueof(req.Status__c);   
   obj.selected = false;
      
   segmentwrapper.add(obj);


  }
  System.debug('###segmentwrapper' + segmentwrapper);
  return segmentwrapper;   
 

 }

 @AuraEnabled
 public static List < Segment_Change_Request__c > getSegmentNotApproved() {

  Set < String > status = new Set < String > {
   'Submitted',
   'Partially Approved',
   'Rejected'
  };

  String loggedinuserid = UserInfo.getUserId();
  string profileID = UserInfo.getProfileId();

  environment_settings__c SystemadminProfile = environment_settings__c.getValues('SystemadminProfileid');
  String SystemadminProfileid = SystemadminProfile.value__c;
  string query = 'Select  id, Service_Group__c ,name, Customer__c, Current_Sales_Responsible__r.Name,Proposed_Sales_Responsible__r.Name, Customer__r.Name,Start_Date__c, Date_Requested_On__c, Status__c from Segment_Change_Request__c where  status__c   in :status';
  System.debug('###profileID' + profileID + 'profileList[0].id' + SystemadminProfileid);
  if (SystemadminProfileid != profileID)
   query += ' and (Current_Sales_Responsible_Manager__c = :loggedinuserid OR Proposed_Sales_Responsible_Manager__c= :loggedinuserid )';

  List < Segment_Change_Request__c > reqList = Database.query(query);

  System.debug('###reqList' + reqList);
  return reqList;

 }


 @AuraEnabled
 public static List < SegmentChangeWrapper > getSegmentApproved() {

  Set < String > status = new Set < String > {
   'Approved'
  };
  List < Segment_Change_Request__c > reqList = [Select id, Service_Group__c, name, Customer__c, Current_Sales_Responsible__r.Name, Proposed_Sales_Responsible__r.Name, Customer__r.Name, Start_Date__c, Date_Requested_On__c from Segment_Change_Request__c where status__c in: status and Start_Date__c <=TODAY];
  System.debug('###reqList' + reqList);
  List < SegmentChangeWrapper > segmentwrapper = new List < SegmentChangeWrapper > ();
  for (Segment_Change_Request__c req: reqList) {
   SegmentChangeWrapper obj = new SegmentChangeWrapper();
   obj.id = req.id;
   obj.Name = req.Name;
   obj.CustomerName = req.Customer__r.Name;
   obj.CustomerId = req.Customer__c;
   obj.ServiceGrp = req.Service_Group__c;
   obj.currentSalesUser = req.Current_Sales_Responsible__r.Name;
   obj.proposedSalesUser = req.Proposed_Sales_Responsible__r.Name;
   obj.Startdate = String.valueof(req.Start_Date__c);
   obj.Requesteddate = String.valueof(req.Date_Requested_On__c);
   obj.selected = false;
   segmentwrapper.add(obj);


  }
  System.debug('###segmentwrapper' + segmentwrapper);
  return segmentwrapper;
 }

 @AuraEnabled
 public static Map < String, String > getmonth() {
  Map < String, string > monthMap = new Map < String, string > ();
  String months = System.Label.Months;
  List < String > monthList = new List < String > ();

  if (months != null)
   monthList = months.split(';');

  Integer monNum = 1;
  for (String mon: monthList) {
   MonthMap.put(String.valueof(monNum), mon);
   ++monNum;
  }

  system.debug('MonthMap' + MonthMap);
  return monthMap;

 }
 @AuraEnabled
 public static Map < String, String > getyear() {
  Map < String, String > yearMap = new Map < String, String > ();

  yearMap.put(String.valueOf(Date.Today().Year()), String.valueOf(Date.Today().Year()));
  yearMap.put(String.valueOf(Date.Today().addyears(1).Year()), String.valueOf(Date.Today().addyears(1).Year()));
  System.debug(yearMap);
  return yearMap;
 }


 @AuraEnabled
 public static String initiateBatch(List < String > selectedLists) {
  set < String > reqIds = new set < String > ();
  for (String s: selectedLists)
   reqIds.add(s);
  crm_updateresponsibleseller_Batch bcn = new crm_updateresponsibleseller_Batch(reqIds);
  ID batchprocessid = Database.executeBatch(bcn);
  return string.valueof(batchprocessid);

 }
    
 @AuraEnabled
 public static String approverecordsfn (List < String > selectedLists1) {
  set < String > reqIds = new set < String > ();
  for (String s: selectedLists1)
   reqIds.add(s);
     System.debug('##selectedLists'+ selectedLists1);
     Map<Id,Segment_Change_Request__c> segchangeMap =  new   Map<Id,Segment_Change_Request__c> ();
     
 List<Segment_Change_Request__c> segList=[Select id,Current_Sales_Responsible_Manager__c, status__c, Proposed_Sales_Responsible_Manager__c from Segment_Change_Request__c where id in :reqIds];
     for (Segment_Change_Request__c seg:segList )   {
    segchangeMap.put(seg.id,seg);
     
     } 
     
 List<ProcessInstance>  ProcessinstanceList= [SELECT Id,Status,TargetObjectId FROM ProcessInstance where Status='Pending' and TargetObjectId in :reqIds];
 Set<id>     pIds= new Set<Id>();
     Map<Id,id> processinstancemap= new Map<id,Id>();
     for(ProcessInstance pi : ProcessinstanceList){ 
            pIds.add(pi.id);            processinstancemap.put(pi.id,pi.TargetObjectId);
     }
     
     
   List<ProcessInstanceWorkitem>  ProcessInstanceWorkitemList=[SELECT Id,ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId in :pIds];
 
Approval.ProcessResult[] allReq = New Approval.ProcessResult[]{};
Approval.ProcessWorkitemRequest reqList = new Approval.ProcessWorkitemRequest();
     try{
for (ProcessInstanceWorkitem  pInstanceWorkitems:ProcessInstanceWorkitemList ){
    system.debug(pInstanceWorkitems);
    
    Id targetid= processinstancemap.get(pInstanceWorkitems.ProcessInstanceId);
    
    Segment_Change_Request__c segobj= segchangeMap.get(targetid);
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Approved.');        req2.setAction('Approve');
     if (segobj.status__c == 'Submitted')
        req2.setNextApproverIds(new Id[] {segobj.Proposed_Sales_Responsible_Manager__c});

        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(pInstanceWorkitems.Id);
     
       Approval.ProcessResult result2 =  Approval.process(req2);
}
     }catch(Exception e){       return 'Error';      }
 return 'Done';

 }

 @AuraEnabled
 public static List < String > savesegment(String json) {
  System.debug('&&&&json' + json);
  SegmentWrapper wrapper = SegmentWrapper.parse(json);

  List < Segment_Change_Request__c > segChangereqList = new List < Segment_Change_Request__c > ();
  Segment_Change_Request__c segmentchangereq = new Segment_Change_Request__c();
  if (String.isNotBlank(wrapper.accountId))
   segmentchangereq.Customer__c = wrapper.accountId;

  Set < String > sg = new Set < String > ();

  for (Integer i = 0; i < wrapper.reqchangesegments.size(); i++) {

   //if proposedresponsible seller!=null 
   if (String.isNotBlank(wrapper.reqchangesegments[i].serviceGroupvalue))
    sg.add(wrapper.reqchangesegments[i].serviceGroupvalue);


  }
  Set < String > sgSet = new Set < String > ();
  List < String > errorLogs = new List < String > ();

  Set < String > status = new Set < String > {
   'Initiated',
   'Submitted',
   'Approved',
   'Partially Approved'
  };
  List < Segment_Change_Request__c > reqList = [Select id, Service_Group__c from Segment_Change_Request__c where Customer__c =: wrapper.accountId and Service_Group__c in: sg and status__c in: status];
  System.debug('###reqList' + reqList);
  if (reqList.size() > 0) {
   //duplicate records
   for (Segment_Change_Request__c req: reqList) {
    sgSet.add(req.Service_Group__c);

   }
  }
  System.debug('###sgSet' + sgSet);

  for (Integer i = 0; i < wrapper.reqchangesegments.size(); i++) {
   if (String.isNotBlank(wrapper.reqchangesegments[i].proposedresponsibleseller)) {
    System.debug('###wrapper.reqchangesegments[i]' + wrapper.reqchangesegments[i]);

    if (String.isNotBlank(wrapper.reqchangesegments[i].serviceGroupvalue)) {
     if (!sgSet.contains(wrapper.reqchangesegments[i].serviceGroupvalue)) {
      Segment_Change_Request__c segaddobj = new Segment_Change_Request__c();

      segaddobj.Customer__c = wrapper.accountId;

      segaddobj.Service_Group__c = wrapper.reqchangesegments[i].serviceGroupvalue;

      if (String.isNotBlank(wrapper.reqchangesegments[i].proposedresponsibleseller))
       segaddobj.Proposed_Sales_Responsible__c = wrapper.reqchangesegments[i].proposedresponsibleseller;

      if (String.isNotBlank(wrapper.reqchangesegments[i].proposedresponsibleSellermanager))
       segaddobj.Proposed_Sales_Responsible_Manager__c = wrapper.reqchangesegments[i].proposedresponsibleSellermanager;

      if (String.isNotBlank(wrapper.reqchangesegments[i].responsibleseller))
       segaddobj.Current_Sales_Responsible__c = wrapper.reqchangesegments[i].responsibleseller;

      if (String.isNotBlank(wrapper.reqchangesegments[i].responsiblesellermanager))
       segaddobj.Current_Sales_Responsible_Manager__c = wrapper.reqchangesegments[i].responsiblesellermanager;

      if (String.isNotBlank(wrapper.reqchangesegments[i].month))
       segaddobj.Month__c = wrapper.reqchangesegments[i].month;

      if (String.isNotBlank(wrapper.reqchangesegments[i].reasonofchange))
       segaddobj.Reason_for_Change__c = wrapper.reqchangesegments[i].reasonofchange;

      /*if(String.isNotBlank(wrapper.reqchangesegments[i].year)) 
          segaddobj.Year__c=wrapper.reqchangesegments[i].year;*/

      segaddobj.Year__c = String.valueof(System.today().year());
      segaddobj.Change_Requester__c = UserInfo.getUserId();
      segaddobj.Start_Date__c = date.newInstance(System.today().year(), Integer.valueOf(wrapper.reqchangesegments[i].month), 1);
      segaddobj.Date_Requested_On__c = System.today();
      segaddobj.Ownerid = UserInfo.getUserId();


      System.debug('###segaddobj' + segaddobj);
      segChangereqList.add(segaddobj);

     } else {
      //add error message to a set and display it   
      //
      system.debug('##' + wrapper.reqchangesegments[i].serviceGroupvalue);

      errorLogs.add(wrapper.reqchangesegments[i].serviceGroupvalue);
      system.debug('errorLogs' + errorLogs);
      //wrapper.reqchangesegments[i].serviceGroupvalue)

     }

    } //end o chheck service grp

   } //end o check proposed responsible seller
  }
  if (segChangereqList.size() > 0)
   insert segChangereqList;

  return errorLogs;
 }



 /**
  * Returns JSON of list of ResultWrapper to Lex Components
  * @objectName - Name of SObject
  * @fld_API_Text - API name of field to display to user while searching
  * @fld_API_Val - API name of field to be returned by Lookup COmponent
  * @lim   - Total number of record to be returned
  * @fld_API_Search - API name of field to be searched
  * @searchText - text to be searched
  * */
 @AuraEnabled
 public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val,
  Integer lim, String fld_API_Search, String searchText) {

  searchText = '\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';

  String userType = 'Sales';
  String query = 'SELECT Manager.isActive , managerid,' + fld_API_Text + ' ,' + fld_API_Val +
   ' FROM ' + objectName +
   ' WHERE ' + fld_API_Search + ' LIKE ' + searchText +
   ' and isactive =true  and crm_User_Type__c = :userType and ManagerId !=null LIMIT ' + lim;
      
      System.debug(query);

  List < User > sobjList = Database.query(query);
  List < ResultWrapper > lstRet = new List < ResultWrapper > ();

  for (User s: sobjList) {
   ResultWrapper obj = new ResultWrapper();
   obj.objName = objectName;    obj.text = String.valueOf(s.get(fld_API_Text));   obj.val = String.valueOf(s.get(fld_API_Val));
      System.debug(s.Manager.isActive);
   obj.managerid = String.valueOf(s.get('managerid'));      obj.manageridstatus = String.valueOf(s.Manager.isActive);
   lstRet.add(obj);
  }
  return JSON.serialize(lstRet);
 }

 public class ResultWrapper {
  public String objName {
   get;
   set;
  }
  public String text {
   get;
   set;
  }
  public String val {
   get;
   set;
  }
  public String managerid {
   get;
   set;
  }
   public String manageridstatus {
   get;
   set;
  }
 }


 public with sharing class SegmentChangeWrapper {
  @AuraEnabled public String Id {
   get;
   set;
  }
  @AuraEnabled public String Name {
   get;
   set;
  }
  @AuraEnabled public String CustomerId {
   get;
   set;
  }
  @AuraEnabled public String CustomerName {
   get;
   set;
  }
  @AuraEnabled public String ServiceGrp {
   get;
   set;
  }
  @AuraEnabled public String Startdate {
   get;
   set;
  }
  @AuraEnabled public String currentSalesUser {
   get;
   set;
  }
  @AuraEnabled public String proposedSalesUser {
   get;
   set;
  }
  @AuraEnabled public String Requesteddate {
   get;
   set;
  }
   @AuraEnabled public String status {
   get;
   set;
  }
  @AuraEnabled public Boolean selected {
   get;
   set;
  }


  SegmentChangeWrapper() {}

  SegmentChangeWrapper(String Id, String Name, String status, string CustomerName, string CustomerId, string ServiceGrp, string Startdate, String currentSalesUser, String proposedSalesUser, String Requesteddate, Boolean selected) {
   this.Id = Id;
   this.Name = Name;
   this.CustomerName = CustomerName;
   this.CustomerId = CustomerId;
   this.ServiceGrp = ServiceGrp;
   this.Startdate = Startdate;
   this.currentSalesUser = currentSalesUser;
   this.proposedSalesUser = proposedSalesUser;
   this.Requesteddate = Requesteddate;
   this.status = status;
   this.selected = selected;

  }
 }

}